package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import mypack.Show;
import mypack.ShowFacadeLocal;
import mypack.ShowSchedule;
import mypack.ShowScheduleFacadeLocal;

import java.io.IOException;
import java.util.*;

@WebServlet(name = "ShowListServlet", urlPatterns = {"/shows"})
public class ShowListServlet extends HttpServlet {

    @EJB
    private ShowFacadeLocal showFacade;

    @EJB
    private ShowScheduleFacadeLocal showScheduleFacade;

    private void setUtf8(HttpServletRequest req, HttpServletResponse resp) {
        try {
            req.setCharacterEncoding("UTF-8");
        } catch (Exception ignored) {
        }
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setUtf8(req, resp);

        // Lấy keyword search (tên show)
        String keyword = req.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }
        keyword = keyword.trim();

        // ✅ (khuyến nghị) đồng bộ realtime schedule trước, rồi đồng bộ show theo schedule
        // Nếu bạn không muốn sync ở trang user thì có thể bỏ 2 khối try/catch này.
        try {
            // bạn đã có method này trong admin servlet -> thường nằm trong showScheduleFacade
            // nếu facade bạn có: syncRealtimeStatuses()
            showScheduleFacade.syncRealtimeStatuses();
        } catch (Exception ignored) {
        }

        try {
            // method bạn vừa thêm trong ShowFacade ở bước trước
            showFacade.syncShowStatusFromSchedules();
        } catch (Exception ignored) {
        }

        List<Show> shows;
        if (!keyword.isEmpty()) {
            shows = showFacade.searchByName(keyword);
        } else {
            shows = showFacade.findAll(); // lấy tất cả show
        }

        if (shows == null) {
            shows = new ArrayList<>();
        }

        // ✅ NEW: map lịch chiếu theo showId để JSP hiển thị
        Map<Integer, List<ShowSchedule>> scheduleMap = new HashMap<>();
        Date now = new Date();

        for (Show s : shows) {
            if (s == null || s.getShowID() == null) {
                continue;
            }

            String st = (s.getStatus() == null) ? "" : s.getStatus().trim();

            // ✅ Theo yêu cầu: show Upcoming cũng phải hiện lịch chiếu nếu admin đã thêm
            if ("Upcoming".equalsIgnoreCase(st) || "Ongoing".equalsIgnoreCase(st)) {
                List<ShowSchedule> lst = Collections.emptyList();
                try {
                    lst = showScheduleFacade.findPublicSchedulesByShow(s.getShowID(), now);
                } catch (Exception ignored) {
                }
                scheduleMap.put(s.getShowID(), (lst != null) ? lst : Collections.emptyList());
            }
        }

        req.setAttribute("shows", shows);
        req.setAttribute("searchKeyword", keyword);

        // ✅ NEW
        req.setAttribute("scheduleMap", scheduleMap);

        req.getRequestDispatcher("/WEB-INF/views/user/shows.jsp").forward(req, resp);
    }
}
