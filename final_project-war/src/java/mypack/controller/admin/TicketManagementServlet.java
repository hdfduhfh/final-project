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
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        // Pagination parameters
        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {}
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
                // Set to end of day
                toDate = new Date(toDate.getTime() + 86400000 - 1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        int offset = (page - 1) * pageSize;
        
        // Check if any search parameter is provided
        boolean hasSearchParams = (qrCode != null && !qrCode.trim().isEmpty()) ||
                                 (status != null && !status.trim().isEmpty() && !status.equals("ALL")) ||
                                 (customerName != null && !customerName.trim().isEmpty()) ||
                                 fromDate != null || toDate != null;
        
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
        
        // Set attributes
        request.setAttribute("tickets", tickets);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTickets", totalTickets);
        request.setAttribute("hasSearchParams", hasSearchParams);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/tickets/list.jsp")
               .forward(request, response);
    }
}