package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import mypack.Show;
import mypack.ShowFacadeLocal;
import mypack.ShowArtist;
import mypack.ShowArtistFacadeLocal;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

@WebServlet(name = "ShowArtistManagementServlet", urlPatterns = {
    "/admin/showArtist",
    "/admin/showArtist/delete"
})
public class ShowArtistManagementServlet extends HttpServlet {

    @EJB
    private ShowArtistFacadeLocal showArtistFacade;

    @EJB
    private ShowFacadeLocal showFacade; // ✅ NEW

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

        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        String path = req.getServletPath();
        switch (path) {
            case "/admin/showArtist":
                list(req, resp);
                break;
            case "/admin/showArtist/delete":
                deleteLink(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void list(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<ShowArtist> links = showArtistFacade.findAll();

        // tránh LAZY
        try {
            if (links != null) {
                for (ShowArtist sa : links) {
                    if (sa == null) {
                        continue;
                    }
                    if (sa.getShowID() != null) {
                        sa.getShowID().getShowName();
                    }
                    if (sa.getArtistID() != null) {
                        sa.getArtistID().getName();
                        sa.getArtistID().getRole();
                    }
                }
            }
        } catch (Exception ignored) {
        }

        req.setAttribute("links", links);
        req.getRequestDispatcher("/WEB-INF/views/admin/showArtist/list.jsp")
                .forward(req, resp);
    }

    private void deleteLink(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String sidStr = req.getParameter("showId");
        String aidStr = req.getParameter("artistId");

        try {
            Integer showId = Integer.valueOf(sidStr);
            Integer artistId = Integer.valueOf(aidStr);

            // 1) Xóa liên kết show-artist
            showArtistFacade.removeByShowAndArtist(showId, artistId);

            // 2) Đếm lại số DIỄN VIÊN còn lại (không tính đạo diễn)
            long actorCount = showArtistFacade.countActorsByShow(showId);

            // 3) Auto update status show theo rule
            Show show = showFacade.find(showId);
            if (show != null) {
                // Nếu =0 -> Cancelled
                if (actorCount == 0) {
                    show.setStatus("Cancelled");
                    showFacade.edit(show);
                } // Nếu <4 -> Inactive
                else if (actorCount < 4) {
                    show.setStatus("Inactive");
                    showFacade.edit(show);
                }
                // Nếu >=4 -> giữ nguyên (không đụng status)
            }

            String msg = "Đã xóa nghệ sĩ khỏi show. Diễn viên còn lại: " + actorCount;
            resp.sendRedirect(req.getContextPath()
                    + "/admin/showArtist?success=" + URLEncoder.encode(msg, "UTF-8")
                    + "&v=" + System.currentTimeMillis());

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath()
                    + "/admin/showArtist?error=" + URLEncoder.encode("Lỗi xóa liên kết: " + e.getMessage(), "UTF-8"));
        }
    }
}
