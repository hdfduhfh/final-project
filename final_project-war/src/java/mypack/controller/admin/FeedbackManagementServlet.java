/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import mypack.Feedback;
import mypack.FeedbackFacadeLocal;
import mypack.User;
import mypack.UserFacadeLocal;

/**
 * Servlet quản lý feedback cho Admin
 * @author DANG KHOA
 */
@WebServlet(name = "FeedbackManagementServlet", urlPatterns = {"/admin/feedback"})
public class FeedbackManagementServlet extends HttpServlet {

    @EJB
    private FeedbackFacadeLocal feedbackFacade;
    
    @EJB
    private UserFacadeLocal userFacade;

    /**
     * Kiểm tra quyền admin
     */
    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        
        User user = (User) session.getAttribute("user");
        if (user.getRoleID() == null || !"ADMIN".equals(user.getRoleID().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/");
            return false;
        }
        
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isAdmin(request, response)) {
            return;
        }

        try {
            // Lấy tất cả feedback, sắp xếp theo mới nhất
            List<Feedback> feedbacks = feedbackFacade.findAllOrderByNewest();
            
            request.setAttribute("feedbacks", feedbacks);
            request.setAttribute("totalFeedbacks", feedbacks.size());
            
            // Tính số feedback theo trạng thái
            long activeCount = feedbacks.stream()
                    .filter(f -> "ACTIVE".equals(f.getStatus()))
                    .count();
            long hiddenCount = feedbacks.stream()
                    .filter(f -> "HIDDEN".equals(f.getStatus()))
                    .count();
            
            request.setAttribute("activeCount", activeCount);
            request.setAttribute("hiddenCount", hiddenCount);
            
            request.getRequestDispatcher("/WEB-INF/views/admin/feedback/list.jsp")
                    .forward(request, response);
                    
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách feedback: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/feedback/list.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if ("delete".equals(action)) {
                deleteFeedback(request, response);
            } else if ("toggleStatus".equals(action)) {
                toggleStatus(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/feedback");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/feedback");
        }
    }

    /**
     * Xóa feedback
     */
    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
            
            Feedback feedback = feedbackFacade.find(feedbackId);
            if (feedback != null) {
                feedbackFacade.remove(feedback);
                request.getSession().setAttribute("success", "Đã xóa feedback thành công!");
            } else {
                request.getSession().setAttribute("error", "Không tìm thấy feedback!");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID feedback không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi xóa feedback!");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/feedback");
    }

    /**
     * Ẩn/Hiện feedback (toggle status ACTIVE <-> HIDDEN)
     */
    private void toggleStatus(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
            
            Feedback feedback = feedbackFacade.find(feedbackId);
            if (feedback != null) {
                // Toggle status
                if ("ACTIVE".equals(feedback.getStatus())) {
                    feedback.setStatus("HIDDEN");
                    request.getSession().setAttribute("success", "Đã ẩn feedback!");
                } else {
                    feedback.setStatus("ACTIVE");
                    request.getSession().setAttribute("success", "Đã hiện feedback!");
                }
                
                feedbackFacade.edit(feedback);
            } else {
                request.getSession().setAttribute("error", "Không tìm thấy feedback!");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID feedback không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi thay đổi trạng thái!");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/feedback");
    }

    @Override
    public String getServletInfo() {
        return "Feedback Management Servlet for Admin";
    }
}
