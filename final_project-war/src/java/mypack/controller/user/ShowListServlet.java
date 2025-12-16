package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mypack.Show;
import mypack.ShowFacadeLocal;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ShowListServlet", urlPatterns = {"/shows"})
public class ShowListServlet extends HttpServlet {

    @EJB
    private ShowFacadeLocal showFacade;

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

        List<Show> shows;
        if (!keyword.isEmpty()) {
            shows = showFacade.searchByName(keyword);
        } else {
            shows = showFacade.findAll(); // lấy tất cả show
        }

        req.setAttribute("shows", shows);
        req.setAttribute("searchKeyword", keyword);

        req.getRequestDispatcher("/WEB-INF/views/user/shows.jsp").forward(req, resp);
    }

}
