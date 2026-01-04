package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import mypack.*;

/**
 * 🗄️ SERVLET QUẢN LÝ KHO LƯU TRỮ SCHEDULE CANCELLED
 * 
 * Chức năng:
 * - Hiển thị tất cả Schedule đã Cancelled (quá thời gian)
 * - Cho phép Admin xem lại thông tin
 * - Cho phép xóa vĩnh viễn nếu KHÔNG CÓ ĐƠN HÀNG
 * - Bảo vệ Schedule có đơn hàng VĨNH VIỄN
 */
@WebServlet(name = "CancelledSchedulesServlet", urlPatterns = {
    "/admin/schedule/cancelled",
    "/admin/schedule/cancelled/delete"
})
public class CancelledSchedulesServlet extends HttpServlet {

    @EJB
    private ShowScheduleFacadeLocal showScheduleFacade;

    @EJB
    private OrderDetailFacadeLocal orderDetailFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String uri = request.getRequestURI();

        if (uri.endsWith("/admin/schedule/cancelled/delete")) {
            handleDelete(request, response);
        } else {
            showCancelledList(request, response);
        }
    }

    /**
     * 📋 HIỂN THỊ DANH SÁCH SCHEDULE CANCELLED
     */
    private void showCancelledList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy tất cả Schedule có status = "Cancelled"
            List<ShowSchedule> cancelledSchedules = showScheduleFacade.findAll();
            
            // Lọc chỉ lấy Cancelled
            cancelledSchedules.removeIf(sc -> 
                sc == null || 
                !"Cancelled".equalsIgnoreCase(sc.getStatus())
            );

            // Sắp xếp theo thời gian (mới nhất trước)
            cancelledSchedules.sort((a, b) -> {
                if (a.getShowTime() == null && b.getShowTime() == null) return 0;
                if (a.getShowTime() == null) return 1;
                if (b.getShowTime() == null) return -1;
                return b.getShowTime().compareTo(a.getShowTime());
            });

            // ✅ Kiểm tra từng schedule có đơn hàng không
            java.util.Map<Integer, Boolean> hasOrdersMap = new java.util.HashMap<>();
            java.util.Map<Integer, Long> orderCountMap = new java.util.HashMap<>();

            for (ShowSchedule sc : cancelledSchedules) {
                if (sc.getScheduleID() == null) continue;
                
                boolean hasOrders = orderDetailFacade.hasOrdersForSchedule(sc.getScheduleID());
                Long orderCount = orderDetailFacade.countOrdersBySchedule(sc.getScheduleID());
                
                hasOrdersMap.put(sc.getScheduleID(), hasOrders);
                orderCountMap.put(sc.getScheduleID(), orderCount);
            }

            request.setAttribute("cancelledSchedules", cancelledSchedules);
            request.setAttribute("hasOrdersMap", hasOrdersMap);
            request.setAttribute("orderCountMap", orderCountMap);

            request.getRequestDispatcher("/WEB-INF/views/admin/schedule/cancelled-archive.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/schedule/cancelled-archive.jsp")
                    .forward(request, response);
        }
    }

    /**
     * 🗑️ XÓA VĨNH VIỄN SCHEDULE CANCELLED
     * 
     * RULE:
     * - Cancelled + CÓ ĐƠN HÀNG → CHẶN (bảo vệ dữ liệu)
     * - Cancelled + KHÔNG ĐƠN HÀNG → CHO PHÉP
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + 
                "/admin/schedule/cancelled?error=" + 
                java.net.URLEncoder.encode("❌ ID không hợp lệ", "UTF-8"));
            return;
        }

        try {
            Integer scheduleId = Integer.valueOf(idStr);
            ShowSchedule schedule = showScheduleFacade.find(scheduleId);

            if (schedule == null) {
                response.sendRedirect(request.getContextPath() + 
                    "/admin/schedule/cancelled?error=" + 
                    java.net.URLEncoder.encode("❌ Không tìm thấy lịch chiếu", "UTF-8"));
                return;
            }

            // ✅ Kiểm tra status
            if (!"Cancelled".equalsIgnoreCase(schedule.getStatus())) {
                response.sendRedirect(request.getContextPath() + 
                    "/admin/schedule/cancelled?error=" + 
                    java.net.URLEncoder.encode(
                        "❌ Chỉ được xóa lịch chiếu đã Cancelled!", "UTF-8"));
                return;
            }

            // 🔒 KIỂM TRA ĐƠN HÀNG
            boolean hasOrders = orderDetailFacade.hasOrdersForSchedule(scheduleId);
            
            if (hasOrders) {
                Long orderCount = orderDetailFacade.countOrdersBySchedule(scheduleId);
                
                response.sendRedirect(request.getContextPath() + 
                    "/admin/schedule/cancelled?error=" + 
                    java.net.URLEncoder.encode(
                        "🔒 KHÔNG THỂ XÓA! Lịch chiếu này có " + orderCount + 
                        " đơn hàng đã đặt vé. Dữ liệu được bảo vệ vĩnh viễn.", "UTF-8"));
                return;
            }

            // ✅ CHO PHÉP XÓA (KHÔNG CÓ ĐƠN HÀNG)
            showScheduleFacade.remove(schedule);

            System.out.println("✅ Đã xóa vĩnh viễn Schedule #" + scheduleId + " (CANCELLED, NO ORDERS)");

            response.sendRedirect(request.getContextPath() + 
                "/admin/schedule/cancelled?success=" + 
                java.net.URLEncoder.encode(
                    "✅ Xóa lịch chiếu thành công! " +
                    "Lịch chiếu đã kết thúc và không có đơn hàng nào.", "UTF-8"));

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + 
                "/admin/schedule/cancelled?error=" + 
                java.net.URLEncoder.encode("❌ ID không hợp lệ", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                "/admin/schedule/cancelled?error=" + 
                java.net.URLEncoder.encode("❌ Lỗi khi xóa: " + e.getMessage(), "UTF-8"));
        }
    }

    @Override
    public String getServletInfo() {
        return "Cancelled Schedules Archive Management";
    }
}