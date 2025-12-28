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

        // Bảo vệ route
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        int page = 1;
        int pageSize = 10;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {}
        }

        int offset = (page - 1) * pageSize;

        List<Ticket> tickets = ticketFacade.findWithPaging(offset, pageSize);
        int totalTickets = ticketFacade.countAll();
        int totalPages = (int) Math.ceil((double) totalTickets / pageSize);

        request.setAttribute("tickets", tickets);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/WEB-INF/views/admin/tickets/list.jsp")
               .forward(request, response);
    }
}
