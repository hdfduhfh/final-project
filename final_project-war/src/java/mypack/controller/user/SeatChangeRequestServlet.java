package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;
import mypack.*;

/**
 * Servlet xử lý yêu cầu đổi ghế từ user khi ghế bị bảo trì
 */
@WebServlet("/seat-change-request")
public class SeatChangeRequestServlet extends HttpServlet {
    
    @EJB
    private Order1FacadeLocal orderFacade;
    
    @EJB
    private OrderDetailFacadeLocal orderDetailFacade;
    
    @EJB
    private SeatFacadeLocal seatFacade;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // ===== KIỂM TRA ĐĂNG NHẬP =====
        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Vui lòng đăng nhập!\"}");
            return;
        }
        
        try {
            String orderIdStr = request.getParameter("orderId");
            String reason = request.getParameter("reason");
            
            // ===== VALIDATE INPUT =====
            if (orderIdStr == null || reason == null || reason.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                PrintWriter out = response.getWriter();
                out.print("{\"success\": false, \"message\": \"Thiếu thông tin!\"}");
                return;
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            Order1 order = orderFacade.find(orderId);
            
            // ===== VALIDATE ORDER =====
            if (order == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                PrintWriter out = response.getWriter();
                out.print("{\"success\": false, \"message\": \"Không tìm thấy đơn hàng!\"}");
                return;
            }
            
            // Kiểm tra quyền sở hữu
            if (!order.getUserID().getUserID().equals(currentUser.getUserID())) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                PrintWriter out = response.getWriter();
                out.print("{\"success\": false, \"message\": \"Bạn không có quyền truy cập đơn hàng này!\"}");
                return;
            }
            
            // Chỉ cho phép đơn CONFIRMED
            if (!"CONFIRMED".equals(order.getStatus())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                PrintWriter out = response.getWriter();
                out.print("{\"success\": false, \"message\": \"Chỉ có thể yêu cầu đổi ghế cho đơn đã xác nhận!\"}");
                return;
            }
            
            // Kiểm tra đã gửi yêu cầu chưa
            if (order.getSeatChangeRequested() != null && order.getSeatChangeRequested()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                PrintWriter out = response.getWriter();
                out.print("{\"success\": false, \"message\": \"Đơn hàng này đã có yêu cầu đổi ghế đang chờ xử lý!\"}");
                return;
            }
            
            // ===== KIỂM TRA CÓ GHẾ BẢO TRÌ KHÔNG =====
            List<OrderDetail> details = orderDetailFacade.findByOrderId(orderId);
            boolean hasBrokenSeat = false;
            
            for (OrderDetail detail : details) {
                Seat seat = detail.getSeatID();
                if (seat != null && !seat.getIsActive()) {
                    hasBrokenSeat = true;
                    break;
                }
            }
            
            if (!hasBrokenSeat) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                PrintWriter out = response.getWriter();
                out.print("{\"success\": false, \"message\": \"Đơn hàng không có ghế bảo trì!\"}");
                return;
            }
            
            // ===== CẬP NHẬT ĐỠN HÀNG =====
            order.setSeatChangeRequested(true);
            order.setSeatChangeReason(reason);
            order.setSeatChangeStatus("PENDING");
            order.setUpdatedAt(new Date());
            
            orderFacade.edit(order);
            
            // ===== LOG =====
            System.out.println("✅ User #" + currentUser.getUserID() + 
                             " gửi yêu cầu đổi ghế cho Order #" + orderId);
            System.out.println("   Lý do: " + reason);
            
            // ===== RESPONSE =====
            PrintWriter out = response.getWriter();
            out.print("{\"success\": true, \"message\": \"Yêu cầu đổi ghế đã được gửi! Admin sẽ xử lý trong thời gian sớm nhất.\"}");
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"ID đơn hàng không hợp lệ!\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Lỗi hệ thống: " + e.getMessage() + "\"}");
        }
    }
}