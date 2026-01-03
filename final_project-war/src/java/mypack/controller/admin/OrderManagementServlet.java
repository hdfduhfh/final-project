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

    @EJB
    private SeatFacadeLocal seatFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("view".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                try {
                    int orderId = Integer.parseInt(idParam);
                    Order1 order = orderFacade.find(orderId);

                    if (order != null) {
                        List<OrderDetail> orderDetails = orderDetailFacade.findByOrderId(orderId);
                        
                        boolean hasTickets = false;
                        for (OrderDetail detail : orderDetails) {
                            List<Ticket> tickets = ticketFacade.findByOrderDetailId(detail.getOrderDetailID());
                            if (!tickets.isEmpty()) {
                                hasTickets = true;
                                break;
                            }
                        }
                        
                        // ✅ LẤY DANH SÁCH GHẾ KHẢ DỤNG (CÙNG LOẠI, CÙNG SUẤT CHIẾU)
                        List<Seat> availableSeats = new ArrayList<>();
                        if (order.getSeatChangeRequested() != null && order.getSeatChangeRequested() 
                            && "PENDING".equals(order.getSeatChangeStatus())) {
                            
                            for (OrderDetail detail : orderDetails) {
                                if (!detail.getSeatID().getIsActive()) {
                                    // Lấy ghế cùng loại, active, chưa được đặt
                                    String seatType = detail.getSeatID().getSeatType();
                                    int scheduleId = detail.getScheduleID().getScheduleID();
                                    
                                    List<Seat> sameTypeSeats = seatFacade.findBySeatType(seatType);
                                    Set<Integer> bookedSeatIds = orderDetailFacade.findBookedSeatIdsBySchedule(scheduleId);
                                    
                                    for (Seat seat : sameTypeSeats) {
                                        if (seat.getIsActive() && !bookedSeatIds.contains(seat.getSeatID())) {
                                            availableSeats.add(seat);
                                        }
                                    }
                                    break; // Chỉ xử lý ghế hỏng đầu tiên
                                }
                            }
                        }
                        
                        request.setAttribute("order", order);
                        request.setAttribute("orderDetails", orderDetails);
                        request.setAttribute("hasTickets", hasTickets);
                        request.setAttribute("availableSeats", availableSeats);
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

        if ("updateStatus".equals(action)) {
            handleUpdateStatus(request, response);
            return;
        }

        if ("updatePaymentStatus".equals(action)) {
            handleUpdatePayment(request, response);
            return;
        }

        if ("delete".equals(action)) {
            handleDelete(request, response);
            return;
        }

        // DEFAULT: Hiển thị danh sách đơn hàng
        List<Order1> orders = orderFacade.findAll();
        orders.sort((o1, o2) -> o2.getCreatedAt().compareTo(o1.getCreatedAt()));

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/views/admin/orders/list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("approveCancel".equals(action)) {
            try {
                String idParam = request.getParameter("orderId");
                if (idParam != null) {
                    int orderId = Integer.parseInt(idParam);
                    Order1 order = orderFacade.find(orderId);

                    if (order != null) {
                        BigDecimal refundAmount = order.getFinalAmount()
                                .multiply(new BigDecimal("0.7"));

                        order.setStatus("CANCELLED");
                        order.setRefundAmount(refundAmount);
                        order.setCancellationRequested(false);
                        order.setUpdatedAt(new Date());

                        orderFacade.edit(order);
                        
                        updateTicketsStatusToCancelled(orderId);
                    }

                    response.sendRedirect(request.getContextPath() + "/admin/orders?action=view&id=" + orderId);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        // ✅ XỬ LÝ ĐỔI GHẾ
        if ("processSeatChange".equals(action)) {
            handleSeatChange(request, response);
            return;
        }

        doGet(request, response);
    }

    // ===== XỬ LÝ ĐỔI GHẾ =====
    private void handleSeatChange(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        HttpSession session = request.getSession();
        
        try {
            String orderIdStr = request.getParameter("orderId");
            String newSeatIdStr = request.getParameter("newSeatId");
            String adminNote = request.getParameter("adminNote");
            String actionType = request.getParameter("actionType"); // APPROVE or REJECT
            
            if (orderIdStr == null || actionType == null) {
                session.setAttribute("error", "Thiếu thông tin!");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            Order1 order = orderFacade.find(orderId);
            
            if (order == null) {
                session.setAttribute("error", "Không tìm thấy đơn hàng!");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }
            
            // ===== TỪ CHỐI =====
            if ("REJECT".equals(actionType)) {
                order.setSeatChangeStatus("REJECTED");
                order.setSeatChangeRequested(false);
                order.setAdminNote(adminNote != null ? adminNote : "Yêu cầu đổi ghế đã bị từ chối.");
                order.setUpdatedAt(new Date());
                
                orderFacade.edit(order);
                
                session.setAttribute("success", "Đã từ chối yêu cầu đổi ghế!");
                
                System.out.println("❌ Admin từ chối yêu cầu đổi ghế Order #" + orderId);
                
                response.sendRedirect(request.getContextPath() + "/admin/orders?action=view&id=" + orderId);
                return;
            }
            
            // ===== DUYỆT ĐỔI GHẾ =====
            if ("APPROVE".equals(actionType)) {
                if (newSeatIdStr == null) {
                    session.setAttribute("error", "Vui lòng chọn ghế mới!");
                    response.sendRedirect(request.getContextPath() + "/admin/orders?action=view&id=" + orderId);
                    return;
                }
                
                int newSeatId = Integer.parseInt(newSeatIdStr);
                Seat newSeat = seatFacade.find(newSeatId);
                
                if (newSeat == null || !newSeat.getIsActive()) {
                    session.setAttribute("error", "Ghế mới không hợp lệ!");
                    response.sendRedirect(request.getContextPath() + "/admin/orders?action=view&id=" + orderId);
                    return;
                }
                
                // Tìm OrderDetail có ghế bị hỏng
                List<OrderDetail> details = orderDetailFacade.findByOrderId(orderId);
                OrderDetail brokenSeatDetail = null;
                
                for (OrderDetail detail : details) {
                    if (!detail.getSeatID().getIsActive()) {
                        brokenSeatDetail = detail;
                        break;
                    }
                }
                
                if (brokenSeatDetail == null) {
                    session.setAttribute("error", "Không tìm thấy ghế bảo trì!");
                    response.sendRedirect(request.getContextPath() + "/admin/orders?action=view&id=" + orderId);
                    return;
                }
                
                // ✅ CẬP NHẬT GHẾ MỚI
                String oldSeatNumber = brokenSeatDetail.getSeatID().getSeatNumber();
                brokenSeatDetail.setSeatID(newSeat);
                orderDetailFacade.edit(brokenSeatDetail);
                
                // ✅ CẬP NHẬT VÉ (QR CODE MỚI)
                List<Ticket> tickets = ticketFacade.findByOrderDetailId(brokenSeatDetail.getOrderDetailID());
                for (Ticket ticket : tickets) {
                    // Tạo QR code mới với ghế mới
                    String newQrCode = "TICKET-" + orderId + "-" + 
                                     brokenSeatDetail.getOrderDetailID() + "-" + 
                                     UUID.randomUUID().toString().substring(0, 8).toUpperCase();
                    ticket.setQRCode(newQrCode);
                    ticket.setUpdatedAt(new Date());
                    ticketFacade.edit(ticket);
                }
                
                // ✅ CẬP NHẬT TRẠNG THÁI ĐƠN HÀNG
                order.setSeatChangeStatus("APPROVED");
                order.setSeatChangeRequested(false);
                order.setAdminNote(adminNote != null ? adminNote : 
                    "Đã đổi ghế " + oldSeatNumber + " → " + newSeat.getSeatNumber());
                order.setUpdatedAt(new Date());
                
                orderFacade.edit(order);
                
                session.setAttribute("success", "Đã đổi ghế thành công: " + 
                                    oldSeatNumber + " → " + newSeat.getSeatNumber());
                
                System.out.println("✅ Admin đổi ghế Order #" + orderId + ": " + 
                                 oldSeatNumber + " → " + newSeat.getSeatNumber());
                
                response.sendRedirect(request.getContextPath() + "/admin/orders?action=view&id=" + orderId);
                return;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi xử lý: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

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
            System.err.println("❌ Lỗi khi cập nhật trạng thái vé: " + e.getMessage());
            e.printStackTrace();
        }
    }
}