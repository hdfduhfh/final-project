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
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

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

        if (page < 1) page = 1;

        int offset = (page - 1) * PAGE_SIZE;

        // 1) Lấy danh sách lịch theo phân trang cũ (giữ nguyên logic)
        List<ShowSchedule> pageSchedules = showScheduleFacade.findUpcoming(offset, PAGE_SIZE);
        if (pageSchedules == null) pageSchedules = new ArrayList<>();

        // 2) Lấy các showId xuất hiện trong page (giữ thứ tự)
        Set<Integer> showIds = new LinkedHashSet<>();
        for (ShowSchedule sc : pageSchedules) {
            if (sc == null || sc.getShowID() == null || sc.getShowID().getShowID() == null) continue;
            showIds.add(sc.getShowID().getShowID());
        }

        // 3) Query lại tất cả lịch diễn (Upcoming/Ongoing) của các show trong page
        List<ShowSchedule> schedulesForPageShows;
        if (showIds.isEmpty()) {
            schedulesForPageShows = pageSchedules; // rỗng thì thôi
        } else {
            schedulesForPageShows = showScheduleFacade.findUpcomingByShowIds(new ArrayList<>(showIds));
            if (schedulesForPageShows == null) schedulesForPageShows = new ArrayList<>();
        }

        // 4) Tổng phân trang giữ nguyên như cũ
        int totalItems = showScheduleFacade.countUpcoming();
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        // 5) JSP sẽ dùng schedules này để group + xổ dropdown đầy đủ suất theo show
        req.setAttribute("schedules", schedulesForPageShows);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("/WEB-INF/views/user/showSchedule.jsp").forward(req, resp);
    }
}
