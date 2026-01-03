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
import java.util.Collections;
import java.util.List;

@WebServlet(name = "ShowDetailServlet", urlPatterns = {"/shows/detail/*"})
public class ShowDetailServlet extends HttpServlet {

    @EJB
    private ShowFacadeLocal showFacade;

    @EJB
    private ShowScheduleFacadeLocal showScheduleFacade;

    private boolean isOngoing(Show show) {
        if (show == null || show.getStatus() == null) return false;
        return "Ongoing".equalsIgnoreCase(show.getStatus().trim());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // URL dạng: /shows/detail/1
        String pathInfo = req.getPathInfo(); // "/1"

        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendRedirect(req.getContextPath() + "/shows");
            return;
        }

        try {
            int showID = Integer.parseInt(pathInfo.substring(1));

            // 1) Lấy thông tin show
            Show show = showFacade.find(showID);

            if (show == null) {
                resp.sendRedirect(req.getContextPath() + "/shows");
                return;
            }

            // 2) Chỉ lấy lịch chiếu khi show đang chiếu (Ongoing)
            List<ShowSchedule> schedules = Collections.emptyList();
            if (isOngoing(show)) {
                schedules = showScheduleFacade.findByShowId(showID);
                if (schedules == null) schedules = Collections.emptyList();
            }

            // 3) Đẩy dữ liệu sang JSP
            req.setAttribute("show", show);
            req.setAttribute("schedules", schedules);

            // 4) Forward
            req.getRequestDispatcher("/WEB-INF/views/user/showDetail.jsp")
               .forward(req, resp);

        } catch (NumberFormatException ex) {
            resp.sendRedirect(req.getContextPath() + "/shows");
        }
    }
}
