package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mypack.ShowSchedule;
import mypack.ShowScheduleFacadeLocal;

import java.io.IOException;
import java.util.List;

@WebServlet("/showSchedule")
public class ShowScheduleUserServlet extends HttpServlet {

    @EJB
    private ShowScheduleFacadeLocal showScheduleFacade;

    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int page = 1;
        try {
            page = Integer.parseInt(req.getParameter("page"));
        } catch (Exception ignored) {}

        int offset = (page - 1) * PAGE_SIZE;

        List<ShowSchedule> schedules
                = showScheduleFacade.findUpcoming(offset, PAGE_SIZE);

        int totalItems = showScheduleFacade.countUpcoming();
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);

        req.setAttribute("schedules", schedules);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher(
                "/WEB-INF/views/user/showSchedule.jsp"
        ).forward(req, resp);
    }
}

