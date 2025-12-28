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
import java.util.Collections;
import java.util.List;
import mypack.News;
import mypack.NewsFacadeLocal;

@WebServlet("/new")
public class NewsPublicServlet extends HttpServlet {

    @EJB
    private NewsFacadeLocal newsFacade;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idParam = req.getParameter("id");
        String search = req.getParameter("search");

        if (idParam != null) {
            try {
                Integer id = Integer.valueOf(idParam);
                News news = newsFacade.find(id);
                if (news != null && !news.isIsDeleted() && "Published".equalsIgnoreCase(news.getStatus())) {
                    req.setAttribute("news", news);
                    req.getRequestDispatcher("/WEB-INF/views/user/new/viewnew.jsp").forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Tin tức không tồn tại hoặc chưa được public");
                }
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
            }
        } else {
            int page = 1;
            int pageSize = 20; // 4 bài/1 hàng * 5 hàng = 20 bài/trang
            try {
                page = Integer.parseInt(req.getParameter("page"));
            } catch (Exception e) {}

            List<News> latestNews;
            long total;
            int totalPages;

            if (search != null && !search.trim().isEmpty()) {
                List<News> all = newsFacade.findPublishedByTitle(search.trim());
                total = all.size();
                totalPages = (int) Math.ceil((double) total / pageSize);
                int fromIndex = (page - 1) * pageSize;
                int toIndex = Math.min(fromIndex + pageSize, all.size());
                if (fromIndex < all.size()) {
                    latestNews = all.subList(fromIndex, toIndex);
                } else {
                    latestNews = Collections.emptyList();
                }
            } else {
                latestNews = newsFacade.findPublishedPage(page, pageSize);
                total = newsFacade.countPublished();
                totalPages = (int) Math.ceil((double) total / pageSize);
            }

            req.setAttribute("latestNews", latestNews);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);

            req.getRequestDispatcher("/WEB-INF/views/user/new/listnew.jsp").forward(req, resp);
        }
    }
}
