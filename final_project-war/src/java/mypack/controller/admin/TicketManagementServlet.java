/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import mypack.Ticket;
import mypack.TicketFacadeLocal;
import mypack.User;

@WebServlet(name = "TicketManagementServlet", urlPatterns = {"/admin/tickets"})
public class TicketManagementServlet extends HttpServlet {

    @EJB
    private TicketFacadeLocal ticketFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");

        // 🔒 Check đăng nhập
        if (admin == null /* || !admin.getRole().equals("ADMIN") */) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Lấy tất cả vé
        List<Ticket> tickets = ticketFacade.findAll();

        request.setAttribute("tickets", tickets);
        request.getRequestDispatcher("/WEB-INF/views/admin/tickets/list.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
