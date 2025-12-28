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
import java.util.*;
import mypack.News;
import mypack.NewsFacadeLocal;
import mypack.User;
import mypack.UserFacadeLocal;

@WebServlet("/admin/news")
public class NewsManagerServlet extends HttpServlet {

    @EJB
    private NewsFacadeLocal newsFacade;

    @EJB
    private UserFacadeLocal userFacade;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if (action == null || action.equals("list")) {
            String search = req.getParameter("search");
            int page = 1;
            int pageSize = 5; // số tin mỗi trang
            try {
                page = Integer.parseInt(req.getParameter("page"));
            } catch (Exception e) {}

            List<News> list;
            long total;
            int totalPages;

            if (search != null && !search.trim().isEmpty()) {
                // tìm theo tiêu đề
                List<News> all = newsFacade.findByTitle(search.trim());
                total = all.size();
                totalPages = (int) Math.ceil((double) total / pageSize);
                int fromIndex = (page - 1) * pageSize;
                int toIndex = Math.min(fromIndex + pageSize, all.size());
                if (fromIndex < all.size()) {
                    list = all.subList(fromIndex, toIndex);
                } else {
                    list = Collections.emptyList();
                }
            } else {
                list = newsFacade.findPage(page, pageSize);
                total = newsFacade.countAll();
                totalPages = (int) Math.ceil((double) total / pageSize);
            }

            req.setAttribute("newsList", list);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);

            req.getRequestDispatcher("/WEB-INF/views/admin/news/list.jsp").forward(req, resp);
            return;
        }

        if (action.equals("create")) {
            loadAssetImages(req);
            req.getRequestDispatcher("/WEB-INF/views/admin/news/form.jsp").forward(req, resp);
            return;
        }

        if (action.equals("edit")) {
            Integer id = parseId(req.getParameter("id"));
            News news = id != null ? newsFacade.find(id) : null;
            req.setAttribute("news", news);
            loadAssetImages(req);
            req.getRequestDispatcher("/WEB-INF/views/admin/news/form.jsp").forward(req, resp);
            return;
        }

        if (action.equals("view")) {
            Integer id = parseId(req.getParameter("id"));
            News news = id != null ? newsFacade.find(id) : null;
            req.setAttribute("news", news);
            req.getRequestDispatcher("/WEB-INF/views/admin/news/view.jsp").forward(req, resp);
            return;
        }

        if (action.equals("delete")) {
            Integer id = parseId(req.getParameter("id"));
            if (id != null) {
                newsFacade.softDelete(id);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/news?action=list");
            return;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("create".equals(action)) {
            News n = buildNews(req);
            String thumbnailPath = req.getParameter("thumbnailPath");
            if (thumbnailPath != null && !thumbnailPath.isBlank()) n.setThumbnailUrl(thumbnailPath);
            newsFacade.create(n);
            resp.sendRedirect(req.getContextPath() + "/admin/news?action=list");
            return;
        }

        if ("edit".equals(action)) {
            Integer id = parseId(req.getParameter("id"));
            News n = id != null ? newsFacade.find(id) : null;
            if (n != null) {
                updateNews(n, req);
                String thumbnailPath = req.getParameter("thumbnailPath");
                if (thumbnailPath != null && !thumbnailPath.isBlank()) n.setThumbnailUrl(thumbnailPath);
                newsFacade.edit(n);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/news?action=list");
        }
    }

    private void loadAssetImages(HttpServletRequest req) {
        Set<String> paths = req.getServletContext().getResourcePaths("/assets/images/News/");
        List<String> images = new ArrayList<>();
        if (paths != null) {
            for (String p : paths) {
                String lower = p.toLowerCase(Locale.ROOT);
                if (lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png")
                        || lower.endsWith(".gif") || lower.endsWith(".webp")) {
                    images.add(p.startsWith("/") ? p.substring(1) : p);
                }
            }
        }
        req.setAttribute("assetImages", images);
    }

    private News buildNews(HttpServletRequest req) throws ServletException {
        News n = new News();
        n.setTitle(req.getParameter("title"));
        n.setSummary(req.getParameter("summary"));
        n.setContent(req.getParameter("content"));
        n.setSlug(req.getParameter("slug"));
        n.setStatus(req.getParameter("status"));
        n.setCreatedAt(new Date());

        User admin = userFacade.findByEmail("admin@example.com");
        if (admin == null) throw new ServletException("Không tìm thấy tài khoản admin");
        n.setUserID(admin);

        return n;
    }

    private void updateNews(News n, HttpServletRequest req) throws ServletException {
        n.setTitle(req.getParameter("title"));
        n.setSummary(req.getParameter("summary"));
        n.setContent(req.getParameter("content"));
        n.setSlug(req.getParameter("slug"));
        n.setStatus(req.getParameter("status"));
        n.setUpdatedAt(new Date());

        User admin = userFacade.findByEmail("admin@example.com");
        if (admin == null) throw new ServletException("Không tìm thấy tài khoản admin");
        n.setUserID(admin);
    }

    private Integer parseId(String s) {
        try { return Integer.valueOf(s); } catch (Exception e) { return null; }
    }
}