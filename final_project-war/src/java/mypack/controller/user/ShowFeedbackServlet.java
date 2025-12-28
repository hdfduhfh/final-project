/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import mypack.*;

/**
 * Servlet hiển thị đánh giá công khai của show
 * @author DANG KHOA
 */
@WebServlet(name = "ShowFeedbackServlet", urlPatterns = {"/show-feedback"})
public class ShowFeedbackServlet extends HttpServlet {

    @EJB
    private FeedbackFacadeLocal feedbackFacade;
    
    @EJB
    private ShowFacadeLocal showFacade;
    
    @EJB
    private ShowScheduleFacadeLocal scheduleFacade;

    /**
     * GET: Hiển thị trang đánh giá
     * Param: showId hoặc scheduleId
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String showIdStr = request.getParameter("showId");
        String scheduleIdStr = request.getParameter("scheduleId");
        
        try {
            List<Feedback> feedbacks = null;
            Show show = null;
            ShowSchedule schedule = null;
            Double avgRating = 0.0;
            Long totalFeedback = 0L;
            
            // ✅ Nếu có scheduleId → Hiển thị feedback của 1 suất chiếu
            if (scheduleIdStr != null && !scheduleIdStr.isEmpty()) {
                int scheduleId = Integer.parseInt(scheduleIdStr);
                schedule = scheduleFacade.find(scheduleId);
                
                if (schedule != null) {
                    show = schedule.getShowID();
                    feedbacks = feedbackFacade.findBySchedule(schedule);
                    
                    // Tính rating trung bình của suất chiếu này
                    if (!feedbacks.isEmpty()) {
                        avgRating = feedbacks.stream()
                                .mapToInt(Feedback::getRating)
                                .average()
                                .orElse(0.0);
                    }
                    totalFeedback = (long) feedbacks.size();
                }
            }
            // ✅ Nếu có showId → Hiển thị feedback của tất cả suất chiếu của show
            else if (showIdStr != null && !showIdStr.isEmpty()) {
                int showId = Integer.parseInt(showIdStr);
                show = showFacade.find(showId);
                
                if (show != null) {
                    feedbacks = feedbackFacade.findByShow(show);
                    avgRating = feedbackFacade.getAverageRatingByShow(show);
                    totalFeedback = feedbackFacade.countFeedbackByShow(show);
                }
            }
            
            // Nếu không tìm thấy
            if (show == null) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }
            
            // Phân loại đánh giá theo rating
            long rating5 = feedbacks.stream().filter(f -> f.getRating() == 5).count();
            long rating4 = feedbacks.stream().filter(f -> f.getRating() == 4).count();
            long rating3 = feedbacks.stream().filter(f -> f.getRating() == 3).count();
            long rating2 = feedbacks.stream().filter(f -> f.getRating() == 2).count();
            long rating1 = feedbacks.stream().filter(f -> f.getRating() == 1).count();
            
            // Set attributes
            request.setAttribute("show", show);
            request.setAttribute("schedule", schedule);
            request.setAttribute("feedbacks", feedbacks);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("totalFeedback", totalFeedback);
            request.setAttribute("rating5", rating5);
            request.setAttribute("rating4", rating4);
            request.setAttribute("rating3", rating3);
            request.setAttribute("rating2", rating2);
            request.setAttribute("rating1", rating1);
            
            request.getRequestDispatcher("/WEB-INF/views/user/show-feedback.jsp")
                    .forward(request, response);
                    
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải đánh giá: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/user/show-feedback.jsp")
                    .forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Show Feedback Display Servlet";
    }
}