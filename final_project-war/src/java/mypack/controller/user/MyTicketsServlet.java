package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import mypack.*;

@WebServlet("/my-tickets")
public class MyTicketsServlet extends HttpServlet {
    
    @EJB
    private Order1FacadeLocal orderFacade;
    
    @EJB
    private OrderDetailFacadeLocal orderDetailFacade;
    
    @EJB
    private TicketFacadeLocal ticketFacade;
    
    // ===== 1️⃣ HIỂN THỊ DANH SÁCH VÉ (DoGet) =====
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            session.setAttribute("redirectAfterLogin", request.getContextPath() + "/my-tickets");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Lấy danh sách đơn hàng của user
        List<Order1> orders = orderFacade.findByUser(user);
        
        // Lấy chi tiết vé cho từng đơn hàng
        for (Order1 order : orders) {
            List<OrderDetail> details = orderDetailFacade.findByOrderId(order.getOrderID());
            order.setOrderDetailCollection(details);
            
            for (OrderDetail detail : details) {
                List<Ticket> tickets = ticketFacade.findByOrderDetailId(detail.getOrderDetailID());
                detail.setTicketCollection(tickets);
            }
        }
        
        // Sắp xếp đơn mới nhất lên đầu
        orders.sort((o1, o2) -> o2.getCreatedAt().compareTo(o1.getCreatedAt()));
        
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/views/user/my-tickets.jsp").forward(request, response);
    }
    
    // ===== 2️⃣ XỬ LÝ YÊU CẦU HỦY VÉ (DoPost) =====
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("requestCancel".equals(action)) {
            handleCancelRequest(request, response, session, currentUser);
        }
    }
    
    /**
     * ===== XỬ LÝ YÊU CẦU HỦY VÉ (CÓ KIỂM TRA VOUCHER) =====
     */
    private void handleCancelRequest(HttpServletRequest request, 
                                     HttpServletResponse response,
                                     HttpSession session,
                                     User currentUser) throws IOException {
        try {
            String orderIdStr = request.getParameter("orderId");
            String reason = request.getParameter("reason");
            
            if (orderIdStr == null || reason == null || reason.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
                response.sendRedirect(request.getContextPath() + "/my-tickets");
                return;
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            Order1 order = orderFacade.find(orderId);
            
            // ===== VALIDATION BẢO MẬT =====
            if (order == null) {
                session.setAttribute("error", "Không tìm thấy đơn hàng!");
                response.sendRedirect(request.getContextPath() + "/my-tickets");
                return;
            }
            
            // Kiểm tra quyền sở hữu
            if (!order.getUserID().getUserID().equals(currentUser.getUserID())) {
                session.setAttribute("error", "Bạn không có quyền hủy đơn hàng này!");
                response.sendRedirect(request.getContextPath() + "/my-tickets");
                return;
            }
            
            // Kiểm tra trạng thái
            if (!"CONFIRMED".equals(order.getStatus())) {
                session.setAttribute("error", "Chỉ có thể hủy đơn hàng đã xác nhận!");
                response.sendRedirect(request.getContextPath() + "/my-tickets");
                return;
            }
            
            // Kiểm tra đã yêu cầu hủy trước đó chưa
            if (order.getCancellationRequested()) {
                session.setAttribute("error", "Đơn hàng này đã được yêu cầu hủy trước đó!");
                response.sendRedirect(request.getContextPath() + "/my-tickets");
                return;
            }
            
            // ===== 🔥 KIỂM TRA VOUCHER (QUAN TRỌNG!) =====
            BigDecimal discountAmount = order.getDiscountAmount();
            if (discountAmount != null && discountAmount.compareTo(BigDecimal.ZERO) > 0) {
                session.setAttribute("error", 
                    "⚠️ Không thể hủy vé đã sử dụng voucher/mã giảm giá! " +
                    "Vui lòng liên hệ hotline 1900-xxxx để được hỗ trợ.");
                
                System.out.println("❌ CHẶN HỦY VÉ CÓ VOUCHER:");
                System.out.println("   - Order ID: " + orderId);
                System.out.println("   - User: " + currentUser.getFullName());
                System.out.println("   - Discount: " + discountAmount);
                
                response.sendRedirect(request.getContextPath() + "/my-tickets");
                return;
            }
            
            // ===== KIỂM TRA THỜI GIAN 24H =====
            Date showTime = getShowTimeFromOrder(order);
            if (showTime != null) {
                long diffMillis = showTime.getTime() - new Date().getTime();
                long diffHours = diffMillis / (1000 * 60 * 60);
                
                if (diffHours < 24) {
                    session.setAttribute("error", 
                        "Không thể hủy vé khi suất chiếu còn dưới 24 giờ!");
                    response.sendRedirect(request.getContextPath() + "/my-tickets");
                    return;
                }
            }
            
            // ===== TÍNH TOÁN HOÀN TIỀN (30% PHÍ HỦY) =====
            BigDecimal finalAmount = order.getFinalAmount();
            BigDecimal refundAmount = finalAmount.multiply(new BigDecimal("0.70")); // Hoàn 70%
            
            // ===== CẬP NHẬT ĐƠN HÀNG =====
            order.setCancellationRequested(true);
            order.setCancellationReason(reason);
            order.setRefundAmount(refundAmount);
            
            orderFacade.edit(order);
            
            // ===== THÔNG BÁO THÀNH CÔNG =====
            session.setAttribute("success", 
                String.format("Yêu cầu hủy vé thành công! Số tiền hoàn lại dự kiến: %,.0f VNĐ", 
                    refundAmount.doubleValue()));
            
            System.out.println("✅ Đã gửi yêu cầu hủy đơn #" + orderId);
            System.out.println("   - Lý do: " + reason);
            System.out.println("   - Hoàn lại: " + refundAmount);
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID đơn hàng không hợp lệ!");
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại!");
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/my-tickets");
    }
    
    /**
     * 📅 Lấy thời gian chiếu từ OrderDetail
     */
    private Date getShowTimeFromOrder(Order1 order) {
        try {
            List<OrderDetail> details = orderDetailFacade.findByOrderId(order.getOrderID());
            if (!details.isEmpty()) {
                return details.get(0).getScheduleID().getShowTime();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}