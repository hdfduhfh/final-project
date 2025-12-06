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
//import jakarta.servlet.http.HttpSession;
import mypack.Show;
import mypack.ShowFacadeLocal;
import java.io.IOException;
import java.util.Date;
import java.util.List;

/**
 * Servlet xử lý quản lý Show
 * Các chức năng: Xem danh sách, Thêm, Sửa, Xóa, Tìm kiếm
 */
@WebServlet(name = "ShowManagementServlet", urlPatterns = {
    "/admin/show",
    "/admin/show/add",
    "/admin/show/edit",
    "/admin/show/delete"
})
public class ShowManagementServlet extends HttpServlet {

    @EJB
    private ShowFacadeLocal showFacade;

    /**
     * Handles the HTTP <code>GET</code> method.
     * - /admin/show -> Hiển thị danh sách
     * - /admin/show/add -> Hiển thị form thêm
     * - /admin/show/edit -> Hiển thị form sửa
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra session admin
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("user") == null) {
//            response.sendRedirect(request.getContextPath() + "/admin/login");
//            return;
//        }

        String path = request.getServletPath();
        
        switch (path) {
            case "/admin/show":
                showList(request, response);
                break;
            case "/admin/show/add":
                showAddForm(request, response);
                break;
            case "/admin/show/edit":
                showEditForm(request, response);
                break;
            case "/admin/show/delete":
                deleteShow(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * - /admin/show/add -> Xử lý thêm show
     * - /admin/show/edit -> Xử lý sửa show
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String path = request.getServletPath();
        
        switch (path) {
            case "/admin/show/add":
                createShow(request, response);
                break;
            case "/admin/show/edit":
                updateShow(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Hiển thị danh sách show
     */
    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy từ khóa tìm kiếm (nếu có)
            String searchKeyword = request.getParameter("search");
            List<Show> shows;
            
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                // Tìm kiếm show theo tên
                shows = showFacade.findByShowName(searchKeyword);
            } else {
                // Lấy tất cả show
                shows = showFacade.findAll();
            }
            
            // Tính toán thống kê
            long totalShows = shows.size();
            long activeShows = shows.stream()
                    .filter(s -> "Active".equals(s.getStatus()))
                    .count();
            long inactiveShows = totalShows - activeShows;
            
            // Đưa dữ liệu vào request
            request.setAttribute("shows", shows);
            request.setAttribute("totalShows", totalShows);
            request.setAttribute("activeShows", activeShows);
            request.setAttribute("inactiveShows", inactiveShows);
            
            // Forward đến JSP
            request.getRequestDispatcher("/WEB-INF/views/admin/show/list.jsp")
                   .forward(request, response);
                   
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách show: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/show/list.jsp")
                   .forward(request, response);
        }
    }

    /**
     * Hiển thị form thêm show
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/WEB-INF/views/admin/show/add.jsp")
               .forward(request, response);
    }

    /**
     * Hiển thị form sửa show
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String idParam = request.getParameter("id");
            
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/show?error=ID không hợp lệ");
                return;
            }
            
            Integer showId = Integer.parseInt(idParam);
            Show show = showFacade.find(showId);
            
            if (show == null) {
                response.sendRedirect(request.getContextPath() + "/admin/show?error=Không tìm thấy show");
                return;
            }
            
            request.setAttribute("show", show);
            request.getRequestDispatcher("/WEB-INF/views/admin/show/edit.jsp")
                   .forward(request, response);
                   
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/show?error=ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/show?error=Lỗi: " + e.getMessage());
        }
    }

    /**
     * Tạo show mới
     */
    private void createShow(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy dữ liệu từ form
            String showName = request.getParameter("showName");
            String description = request.getParameter("description");
            String durationStr = request.getParameter("durationMinutes");
            String status = request.getParameter("status");
            String showImage = request.getParameter("showImage");
            
            // Validate
            if (showName == null || showName.trim().isEmpty()) {
                request.setAttribute("error", "Tên show không được để trống!");
                request.getRequestDispatcher("/WEB-INF/views/admin/show/add.jsp")
                       .forward(request, response);
                return;
            }
            
            // Tạo đối tượng Show
            Show newShow = new Show();
            newShow.setShowName(showName.trim());
            newShow.setDescription(description != null ? description.trim() : "");
            newShow.setDurationMinutes(Integer.parseInt(durationStr));
            newShow.setStatus(status != null ? status : "Active");
            newShow.setShowImage(showImage != null ? showImage.trim() : "");
            newShow.setCreatedAt(new Date());
            
            // Lưu vào database
            showFacade.create(newShow);
            
            // Redirect về danh sách với thông báo thành công
            response.sendRedirect(request.getContextPath() + "/admin/show?success=Thêm show thành công!");
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Thời lượng phải là số!");
            request.getRequestDispatcher("/WEB-INF/views/admin/show/add.jsp")
                   .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi thêm show: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/show/add.jsp")
                   .forward(request, response);
        }
    }

    /**
     * Cập nhật show
     */
    private void updateShow(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy ID
            String idParam = request.getParameter("showID");
            Integer showId = Integer.parseInt(idParam);
            
            // Tìm show
            Show show = showFacade.find(showId);
            if (show == null) {
                response.sendRedirect(request.getContextPath() + "/admin/show?error=Không tìm thấy show");
                return;
            }
            
            // Lấy dữ liệu từ form
            String showName = request.getParameter("showName");
            String description = request.getParameter("description");
            String durationStr = request.getParameter("durationMinutes");
            String status = request.getParameter("status");
            String showImage = request.getParameter("showImage");
            
            // Validate
            if (showName == null || showName.trim().isEmpty()) {
                request.setAttribute("error", "Tên show không được để trống!");
                request.setAttribute("show", show);
                request.getRequestDispatcher("/WEB-INF/views/admin/show/edit.jsp")
                       .forward(request, response);
                return;
            }
            
            // Cập nhật thông tin
            show.setShowName(showName.trim());
            show.setDescription(description != null ? description.trim() : "");
            show.setDurationMinutes(Integer.parseInt(durationStr));
            show.setStatus(status != null ? status : "Active");
            show.setShowImage(showImage != null ? showImage.trim() : "");
            
            // Lưu vào database
            showFacade.edit(show);
            
            // Redirect về danh sách với thông báo thành công
            response.sendRedirect(request.getContextPath() + "/admin/show?success=Cập nhật show thành công!");
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID hoặc thời lượng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/admin/show?error=Dữ liệu không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/show?error=Lỗi: " + e.getMessage());
        }
    }

    /**
     * Xóa show
     */
    private void deleteShow(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String idParam = request.getParameter("id");
            
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/show?error=ID không hợp lệ");
                return;
            }
            
            Integer showId = Integer.parseInt(idParam);
            Show show = showFacade.find(showId);
            
            if (show == null) {
                response.sendRedirect(request.getContextPath() + "/admin/show?error=Không tìm thấy show");
                return;
            }
            
            // Xóa show
            showFacade.remove(show);
            
            // Redirect về danh sách với thông báo thành công
            response.sendRedirect(request.getContextPath() + "/admin/show?success=Xóa show thành công!");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/show?error=ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/show?error=Lỗi khi xóa: " + e.getMessage());
        }
    }

    @Override
    public String getServletInfo() {
        return "Show Management Servlet for Admin";
    }
}
