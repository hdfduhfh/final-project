package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;
import mypack.*;

@WebServlet(name = "OrderManagementServlet", urlPatterns = {"/admin/orders"})
public class OrderManagementServlet extends HttpServlet {

    @EJB
    private Order1FacadeLocal orderFacade;

    @EJB
    private OrderDetailFacadeLocal orderDetailFacade;

    @EJB
    private TicketFacadeLocal ticketFacade;

    // --- XỬ LÝ GET (Xem, Filter, Redirect) ---
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // 1. Xem chi tiết đơn hàng
        if ("view".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                try {
                    int orderId = Integer.parseInt(idParam);
                    Order1 order = orderFacade.find(orderId);

                    if (order != null) {
                        List<OrderDetail> orderDetails = orderDetailFacade.findByOrderId(orderId);
                        
                        // ✅ CHECK: Đã có vé chưa?
                        boolean hasTickets = false;
                        for (OrderDetail detail : orderDetails) {
                            List<Ticket> tickets = ticketFacade.findByOrderDetailId(detail.getOrderDetailID());
                            if (!tickets.isEmpty()) {
                                hasTickets = true;
                                break;
                            }
                        }
                        
                        request.setAttribute("order", order);
                        request.setAttribute("orderDetails", orderDetails);
                        request.setAttribute("hasTickets", hasTickets); // ✅ THÊM FLAG
                        request.getRequestDispatcher("/WEB-INF/views/admin/orders/view.jsp")
                                .forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        // 2. Cập nhật trạng thái (GET link)
        if ("updateStatus".equals(action)) {
            handleUpdateStatus(request, response);
            return;
        }

        // 3. Cập nhật thanh toán (GET link)
        if ("updatePaymentStatus".equals(action)) {
            handleUpdatePayment(request, response);
            return;
        }

        // 4. Xóa đơn hàng (GET link)
        if ("delete".equals(action)) {
            handleDelete(request, response);
            return;
        }

        // DEFAULT: Hiển thị danh sách đơn hàng
        List<Order1> orders = orderFacade.findAll();
        // Sắp xếp mới nhất lên đầu
        orders.sort((o1, o2) -> o2.getCreatedAt().compareTo(o1.getCreatedAt()));

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/views/admin/orders/list.jsp")
                .forward(request, response);
    }

    // --- XỬ LÝ POST (Form submit: Duyệt hủy) ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // >>> ĐOẠN NÀY LÀ MỚI THÊM ĐỂ DUYỆT HỦY <<<
        if ("approveCancel".equals(action)) {
            try {
                String idParam = request.getParameter("orderId");
                if (idParam != null) {
                    int orderId = Integer.parseInt(idParam);
                    Order1 order = orderFacade.find(orderId);

                    if (order != null) {

                        // 1️⃣ Tính tiền hoàn (70%)
                        BigDecimal refundAmount = order.getFinalAmount()
                                .multiply(new BigDecimal("0.7"));

                        // 2️⃣ Cập nhật trạng thái
                        order.setStatus("CANCELLED");
                        order.setPaymentStatus("REFUNDED");

                        // 3️⃣ LƯU TIỀN HOÀN (QUAN TRỌNG NHẤT)
                        order.setRefundAmount(refundAmount);

                        // 4️⃣ Tắt cờ yêu cầu hủy
                        order.setCancellationRequested(false);
                        
                        // 5️⃣ Cập nhật thời gian
                        order.setUpdatedAt(new Date());

                        // 6️⃣ Lưu DB
                        orderFacade.edit(order);
                        
                        // 7️⃣ ✅ CẬP NHẬT TRẠNG THÁI VÉ THÀNH "CANCELLED"
                        updateTicketsStatusToCancelled(orderId);
                    }

                    // Xử lý xong thì quay lại trang chi tiết đơn hàng đó
                    response.sendRedirect(request.getContextPath() + "/admin/orders?action=view&id=" + orderId);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            // Nếu lỗi thì về trang danh sách
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        // Nếu không phải action đặc biệt của POST, chuyển về doGet xử lý tiếp
        doGet(request, response);
    }

    // --- CÁC HÀM PHỤ TRỢ (Tách ra cho gọn) ---
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        String status = request.getParameter("status");

        if (idParam != null && status != null) {
            try {
                int orderId = Integer.parseInt(idParam);
                Order1 order = orderFacade.find(orderId);
                if (order != null) {
                    order.setStatus(status);
                    order.setUpdatedAt(new Date());
                    orderFacade.edit(order);
                    
                    // ✅ REMOVED: Không còn tạo vé thủ công nữa
                    // Vé đã được tạo tự động ở CheckoutServlet
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }

    private void handleUpdatePayment(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        String paymentStatus = request.getParameter("paymentStatus");

        if (idParam != null && paymentStatus != null) {
            try {
                int orderId = Integer.parseInt(idParam);
                Order1 order = orderFacade.find(orderId);
                if (order != null) {
                    order.setPaymentStatus(paymentStatus);
                    order.setUpdatedAt(new Date());
                    orderFacade.edit(order);
                    
                    // ✅ REMOVED: Không còn tạo vé thủ công nữa
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int orderId = Integer.parseInt(idParam);
                Order1 order = orderFacade.find(orderId);
                if (order != null) {
                    // Xóa tickets trước
                    List<OrderDetail> orderDetails = orderDetailFacade.findByOrderId(orderId);
                    for (OrderDetail detail : orderDetails) {
                        List<Ticket> tickets = ticketFacade.findByOrderDetailId(detail.getOrderDetailID());
                        for (Ticket ticket : tickets) {
                            ticketFacade.remove(ticket);
                        }
                        orderDetailFacade.remove(detail);
                    }
                    orderFacade.remove(order);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
    
    // ✅ PHƯƠNG THỨC MỚI: Cập nhật trạng thái vé khi đơn bị hủy
    private void updateTicketsStatusToCancelled(int orderId) {
        try {
            List<OrderDetail> details = orderDetailFacade.findByOrderId(orderId);
            
            for (OrderDetail detail : details) {
                List<Ticket> tickets = ticketFacade.findByOrderDetailId(detail.getOrderDetailID());
                
                for (Ticket ticket : tickets) {
                    ticket.setStatus("CANCELLED");
                    ticket.setUpdatedAt(new Date());
                    ticketFacade.edit(ticket);
                }
            }
            
            System.out.println("✅ Đã cập nhật trạng thái vé thành CANCELLED cho Order #" + orderId);
            
        } catch (Exception e) {
            System.err.println("❌ LỖI khi cập nhật trạng thái vé: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // ✅ REMOVED: Method createTicketsForOrder() đã không còn cần thiết
    // Vé được tạo tự động ở CheckoutServlet ngay sau khi thanh toán thành công
}