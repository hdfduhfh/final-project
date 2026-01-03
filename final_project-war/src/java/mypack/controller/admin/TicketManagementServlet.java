package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import mypack.Ticket;
import mypack.TicketFacadeLocal;
import mypack.User;

@WebServlet(name = "TicketManagementServlet", urlPatterns = {"/admin/tickets"})
public class TicketManagementServlet extends HttpServlet {

    @EJB
    private TicketFacadeLocal ticketFacade;

    // ========== READ: Xem danh sách & chi tiết ==========
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String action = request.getParameter("action");

        // VIEW: Xem chi tiết vé
        if ("view".equals(action)) {
            viewTicketDetail(request, response);
            return;
        }

        // EDIT FORM: Hiển thị form chỉnh sửa
        if ("edit".equals(action)) {
            showEditForm(request, response);
            return;
        }

        // DELETE: Xóa vé (có validation)
        if ("delete".equals(action)) {
            handleDelete(request, response, session);
            return;

        }
        if ("deleted".equals(action)) {
            showDeletedTickets(request, response);
            return;
        }

        // DEFAULT: Hiển thị danh sách với phân trang & tìm kiếm
        showTicketList(request, response);

    }

    // ========== UPDATE & DELETE: Xử lý form submit ==========
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String action = request.getParameter("action");

        // UPDATE: Cập nhật trạng thái vé
        if ("update".equals(action)) {
            handleUpdate(request, response, session);
            return;
        }

        // CHECK-IN: Check-in thủ công
        if ("checkin".equals(action)) {
            handleManualCheckIn(request, response, session);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/tickets");
    }

    // ========================================
    // HELPER METHODS
    // ========================================
    /**
     * READ: Hiển thị danh sách vé với filter & pagination
     */
    private void showTicketList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Pagination parameters
        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {
            }
        }

        // Search parameters
        String qrCode = request.getParameter("qrCode");
        String status = request.getParameter("status");
        String customerName = request.getParameter("customerName");
        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");

        Date fromDate = null;
        Date toDate = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        try {
            if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
                fromDate = sdf.parse(fromDateStr);
            }
            if (toDateStr != null && !toDateStr.trim().isEmpty()) {
                toDate = sdf.parse(toDateStr);
                toDate = new Date(toDate.getTime() + 86400000 - 1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        int offset = (page - 1) * pageSize;

        boolean hasSearchParams = (qrCode != null && !qrCode.trim().isEmpty())
                || (status != null && !status.trim().isEmpty() && !status.equals("ALL"))
                || (customerName != null && !customerName.trim().isEmpty())
                || fromDate != null || toDate != null;

        List<Ticket> tickets;
        int totalTickets;

        if (hasSearchParams) {
            tickets = ticketFacade.searchTickets(qrCode, status, customerName,
                    fromDate, toDate, offset, pageSize);
            totalTickets = ticketFacade.countSearchResults(qrCode, status, customerName,
                    fromDate, toDate);
        } else {
            tickets = ticketFacade.findWithPaging(offset, pageSize);
            totalTickets = ticketFacade.countAll();
        }

        int totalPages = (int) Math.ceil((double) totalTickets / pageSize);

        request.setAttribute("tickets", tickets);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTickets", totalTickets);
        request.setAttribute("hasSearchParams", hasSearchParams);

        request.getRequestDispatcher("/WEB-INF/views/admin/tickets/list.jsp")
                .forward(request, response);
    }

    /**
     * READ: Xem chi tiết 1 vé
     */
    private void viewTicketDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/tickets");
            return;
        }

        try {
            int ticketId = Integer.parseInt(idStr);
            Ticket ticket = ticketFacade.find(ticketId);

            if (ticket == null) {
                request.getSession().setAttribute("error", "Không tìm thấy vé!");
                response.sendRedirect(request.getContextPath() + "/admin/tickets");
                return;
            }

            request.setAttribute("ticket", ticket);
            request.getRequestDispatcher("/WEB-INF/views/admin/tickets/view.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/tickets");
        }
    }

    /**
     * UPDATE FORM: Hiển thị form chỉnh sửa
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/tickets");
            return;
        }

        try {
            int ticketId = Integer.parseInt(idStr);
            Ticket ticket = ticketFacade.find(ticketId);

            if (ticket == null) {
                request.getSession().setAttribute("error", "Không tìm thấy vé!");
                response.sendRedirect(request.getContextPath() + "/admin/tickets");
                return;
            }

            request.setAttribute("ticket", ticket);
            request.getRequestDispatcher("/WEB-INF/views/admin/tickets/edit.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/tickets");
        }
    }

    /**
     * UPDATE: Cập nhật trạng thái vé
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response,
            HttpSession session) throws IOException {

        String idStr = request.getParameter("id");
        String newStatus = request.getParameter("status");

        if (idStr == null || newStatus == null) {
            session.setAttribute("error", "Thiếu thông tin cập nhật!");
            response.sendRedirect(request.getContextPath() + "/admin/tickets");
            return;
        }

        try {
            int ticketId = Integer.parseInt(idStr);
            Ticket ticket = ticketFacade.find(ticketId);

            if (ticket == null) {
                session.setAttribute("error", "Không tìm thấy vé!");
                response.sendRedirect(request.getContextPath() + "/admin/tickets");
                return;
            }

            String currentStatus = ticket.getStatus();

            // ===== VALIDATION: Kiểm tra chuyển trạng thái hợp lệ =====
            // 1. VALID → USED/CANCELLED (OK)
            if ("VALID".equals(currentStatus)) {
                if (!"USED".equals(newStatus) && !"CANCELLED".equals(newStatus)) {
                    session.setAttribute("error", "Vé VALID chỉ có thể chuyển sang USED hoặc CANCELLED!");
                    response.sendRedirect(request.getContextPath() + "/admin/tickets");
                    return;
                }
            } // 2. USED → Không thể đổi (đã sử dụng rồi)
            else if ("USED".equals(currentStatus)) {
                session.setAttribute("error", "Vé đã sử dụng không thể thay đổi trạng thái!");
                response.sendRedirect(request.getContextPath() + "/admin/tickets");
                return;
            } // 3. CANCELLED → Có thể phục hồi về VALID (nếu chưa quá hạn)
            else if ("CANCELLED".equals(currentStatus)) {
                if (!"VALID".equals(newStatus)) {
                    session.setAttribute("error", "Vé đã hủy chỉ có thể phục hồi về VALID!");
                    response.sendRedirect(request.getContextPath() + "/admin/tickets");
                    return;
                }

                // Kiểm tra thời gian suất diễn
                Date showTime = ticket.getOrderDetailID().getScheduleID().getShowTime();
                if (showTime.before(new Date())) {
                    session.setAttribute("error", "Không thể phục hồi vé đã quá hạn suất diễn!");
                    response.sendRedirect(request.getContextPath() + "/admin/tickets");
                    return;
                }
            } // 4. EXPIRED → Không thể đổi
            else if ("EXPIRED".equals(currentStatus)) {
                session.setAttribute("error", "Vé đã hết hạn không thể thay đổi!");
                response.sendRedirect(request.getContextPath() + "/admin/tickets");
                return;
            }

            // ===== CẬP NHẬT =====
            ticket.setStatus(newStatus);
            ticket.setUpdatedAt(new Date());

            ticketFacade.edit(ticket);

            session.setAttribute("success", "Cập nhật trạng thái vé thành công!");
            System.out.println("✅ Admin updated Ticket #" + ticketId + ": " + currentStatus + " → " + newStatus);

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID vé không hợp lệ!");
        } catch (Exception e) {
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/tickets");
    }

    /**
     * CHECK-IN: Admin check-in thủ công
     */
    private void handleManualCheckIn(HttpServletRequest request, HttpServletResponse response,
            HttpSession session) throws IOException {

        String idStr = request.getParameter("id");

        if (idStr == null) {
            session.setAttribute("error", "Thiếu ID vé!");
            response.sendRedirect(request.getContextPath() + "/admin/tickets");
            return;
        }

        try {
            int ticketId = Integer.parseInt(idStr);
            Ticket ticket = ticketFacade.find(ticketId);

            if (ticket == null) {
                session.setAttribute("error", "Không tìm thấy vé!");
                response.sendRedirect(request.getContextPath() + "/admin/tickets");
                return;
            }

            // Chỉ check-in được vé VALID
            if (!"VALID".equals(ticket.getStatus())) {
                session.setAttribute("error", "Chỉ có thể check-in vé VALID!");
                response.sendRedirect(request.getContextPath() + "/admin/tickets");
                return;
            }

            // Cập nhật
            ticket.setStatus("USED");
            ticket.setCheckInAt(new Date());
            ticket.setUpdatedAt(new Date());

            ticketFacade.edit(ticket);

            session.setAttribute("success", "Check-in thủ công thành công!");
            System.out.println("✅ Admin manual check-in Ticket #" + ticketId);

        } catch (Exception e) {
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/tickets");
    }

    /**
     * DELETE: Soft Delete - Không xóa hẳn, chuyển sang DELETED
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response,
            HttpSession session) throws IOException {

        String idStr = request.getParameter("id");
        String reason = request.getParameter("reason"); // Lý do xóa (optional)

        if (idStr == null) {
            session.setAttribute("error", "Thiếu ID vé!");
            response.sendRedirect(request.getContextPath() + "/admin/tickets");
            return;
        }

        try {
            int ticketId = Integer.parseInt(idStr);
            Ticket ticket = ticketFacade.find(ticketId);

            if (ticket == null) {
                session.setAttribute("error", "Không tìm thấy vé!");
                response.sendRedirect(request.getContextPath() + "/admin/tickets");
                return;
            }

            // ===== VALIDATION: CHỈ XÓA VÉ ĐÃ HỦY =====
            if (!"CANCELLED".equals(ticket.getStatus())) {
                session.setAttribute("error",
                        "⚠️ Chỉ có thể xóa vé đã HỦY! Vé hiện tại: " + ticket.getStatus());
                response.sendRedirect(request.getContextPath() + "/admin/tickets");
                return;
            }

            // ===== SOFT DELETE: Chuyển status + lưu metadata =====
            ticket.setStatus("DELETED");
            ticket.setDeletedAt(new Date());

            // Lưu thông tin admin xóa (lấy từ session)
            User admin = (User) session.getAttribute("user");
            if (admin != null) {
                ticket.setDeletedBy(admin.getFullName() + " (#" + admin.getUserID() + ")");
            }

            // Lưu lý do xóa
            if (reason != null && !reason.trim().isEmpty()) {
                ticket.setDeleteReason(reason);
            } else {
                ticket.setDeleteReason("Admin xóa vé đã hủy");
            }

            ticket.setUpdatedAt(new Date());

            // Lưu vào DB (không remove)
            ticketFacade.edit(ticket);

            session.setAttribute("success", "Đã xóa vé #" + ticketId + " (lưu trữ trong lịch sử)");
            System.out.println("✅ Admin soft-deleted Ticket #" + ticketId);

        } catch (Exception e) {
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/tickets");
    }

    private void showDeletedTickets(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Ticket> deletedTickets = ticketFacade.findByStatus("DELETED");

        deletedTickets.sort((t1, t2) -> {
            if (t1.getDeletedAt() == null) {
                return 1;
            }
            if (t2.getDeletedAt() == null) {
                return -1;
            }
            return t2.getDeletedAt().compareTo(t1.getDeletedAt());
        });

        request.setAttribute("deletedTickets", deletedTickets);
        request.getRequestDispatcher("/WEB-INF/views/admin/tickets/delete.jsp")
                .forward(request, response);
    }

}
