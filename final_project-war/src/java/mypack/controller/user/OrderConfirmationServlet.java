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

@WebServlet(name = "OrderConfirmationServlet", urlPatterns = {"/order/confirmation"})
public class OrderConfirmationServlet extends HttpServlet {

    @EJB
    private Order1FacadeLocal orderFacade;

    @EJB
    private OrderDetailFacadeLocal orderDetailFacade;

    @EJB
    private TicketFacadeLocal ticketFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        int orderId = Integer.parseInt(orderIdParam);
        Order1 order = orderFacade.find(orderId);

        if (order == null || order.getUserID().getUserID() != currentUser.getUserID()) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Lấy OrderDetail
        List<OrderDetail> orderDetails = orderDetailFacade.findByOrderId(orderId);

        // Nếu order đã CONFIRMED, lấy Ticket
        List<Ticket> tickets = null;
        if ("CONFIRMED".equals(order.getStatus())) {
            tickets = ticketFacade.findByOrderId(orderId); // Nếu chưa có, admin chưa tạo vé
        }

        request.setAttribute("order", order);
        request.setAttribute("orderDetails", orderDetails);
        request.setAttribute("tickets", tickets);

        request.getRequestDispatcher("/WEB-INF/views/user/order-confirmation.jsp")
                .forward(request, response);
    }
}
