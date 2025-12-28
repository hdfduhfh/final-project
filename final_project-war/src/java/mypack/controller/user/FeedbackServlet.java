package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import mypack.*;

/**
 * Servlet xử lý feedback từ user
 * @author DANG KHOA
 */
@WebServlet(name = "FeedbackServlet", urlPatterns = {"/feedback"})
public class FeedbackServlet extends HttpServlet {

    @EJB
    private FeedbackFacadeLocal feedbackFacade;
    
    @EJB
    private ShowScheduleFacadeLocal scheduleFacade;
    
    @EJB
    private Order1FacadeLocal orderFacade;

    /**
     * ✅ POST: Submit feedback
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // 🔒 KIỂM TRA 1: Đăng nhập chưa?
        if (currentUser == null) {
            out.print("{\"success\": false, \"message\": \"Vui lòng đăng nhập để đánh giá\"}");
            return;
        }
        
        try {
            // Lấy parameters
            String scheduleIdStr = request.getParameter("scheduleId");
            String ratingStr = request.getParameter("rating");
            String comment = request.getParameter("comment");
            
            // Validate input
            if (scheduleIdStr == null || ratingStr == null) {
                out.print("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ\"}");
                return;
            }
            
            int scheduleId = Integer.parseInt(scheduleIdStr);
            int rating = Integer.parseInt(ratingStr);
            
            // Validate rating range
            if (rating < 1 || rating > 5) {
                out.print("{\"success\": false, \"message\": \"Đánh giá phải từ 1-5 sao\"}");
                return;
            }
            
            // Lấy schedule
            ShowSchedule schedule = scheduleFacade.find(scheduleId);
            if (schedule == null) {
                out.print("{\"success\": false, \"message\": \"Suất chiếu không tồn tại\"}");
                return;
            }
            
            // ✅ KIỂM TRA 2: Đã feedback chưa? (MỖI USER CHỈ 1 LẦN/SUẤT CHIẾU)
            if (feedbackFacade.hasUserFeedback(currentUser, schedule)) {
                out.print("{\"success\": false, \"message\": \"Bạn đã đánh giá suất chiếu này rồi!\"}");
                return;
            }
            
            // ✅ KIỂM TRA 3: Có mua vé không? (Dùng method mới từ OrderFacade)
            if (!orderFacade.hasUserPurchasedSchedule(currentUser, schedule)) {
                out.print("{\"success\": false, \"message\": \"Bạn chưa mua vé cho suất chiếu này\"}");
                return;
            }
            
            // ✅ KIỂM TRA 4: Đã xem xong chưa? (sau giờ chiếu)
            Date now = new Date();
            if (now.before(schedule.getShowTime())) {
                out.print("{\"success\": false, \"message\": \"Chỉ được đánh giá sau khi xem xong\"}");
                return;
            }
            
            // ✅ TẠO FEEDBACK
            Feedback feedback = new Feedback();
            feedback.setUserID(currentUser);
            feedback.setScheduleID(schedule);
            feedback.setRating(rating);
            feedback.setComment(comment != null && !comment.trim().isEmpty() ? comment.trim() : null);
            feedback.setStatus("ACTIVE");
            feedback.setCreatedAt(new Date());
            
            feedbackFacade.create(feedback);
            
            out.print("{\"success\": true, \"message\": \"Cảm ơn bạn đã đánh giá!\"}");
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Lỗi hệ thống: " + e.getMessage() + "\"}");
        }
    }
    
    @Override
    public String getServletInfo() {
        return "User Feedback Submission Servlet";
    }
}