package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
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

    // 1️⃣ XỬ LÝ HIỂN THỊ DANH SÁCH VÉ (DoGet)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            // Lưu lại trang hiện tại để login xong quay lại đúng chỗ
            session.setAttribute("redirectAfterLogin", request.getContextPath() + "/my-tickets");
            response.sendRedirect(request.getContextPath() + "/login"); // Hoặc trang login của bạn
            return;
        }

        // Lấy danh sách đơn hàng của user
        List<Order1> orders = orderFacade.findByUser(user);

        // Lấy chi tiết vé cho từng đơn hàng (Code cũ của bạn)
        for (Order1 order : orders) {
            List<OrderDetail> details = orderDetailFacade.findByOrderId(order.getOrderID());
            order.setOrderDetailCollection(details);

            for (OrderDetail detail : details) {
                List<Ticket> tickets = ticketFacade.findByOrderDetailId(detail.getOrderDetailID());
                detail.setTicketCollection(tickets);
            }
        }
        
        // Sắp xếp đơn mới nhất lên đầu (Optional)
        orders.sort((o1, o2) -> o2.getCreatedAt().compareTo(o1.getCreatedAt()));

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/views/user/my-tickets.jsp").forward(request, response);
    }

    // 2️⃣ XỬ LÝ YÊU CẦU HỦY VÉ (DoPost - Phần này bạn đang thiếu)
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
            try {
                String orderIdStr = request.getParameter("orderId");
                String reason = request.getParameter("reason");

                if (orderIdStr != null) {
                    int orderId = Integer.parseInt(orderIdStr);
                    Order1 order = orderFacade.find(orderId);

                    // Kiểm tra bảo mật: Đúng chủ đơn hàng và trạng thái CONFIRMED mới được hủy
                    if (order != null 
                            && order.getUserID().getUserID().equals(currentUser.getUserID())
                            && "CONFIRMED".equals(order.getStatus())) {
                        
                        order.setCancellationRequested(true);
                        order.setCancellationReason(reason);
                        orderFacade.edit(order);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        // Load lại trang để thấy cập nhật
        response.sendRedirect(request.getContextPath() + "/my-tickets");
    }
}