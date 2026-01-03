package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
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
            String status = req.getParameter("status");
            String createdDateStr = req.getParameter("createdDate");

            Date createdDate = null;
            try {
                if (createdDateStr != null && !createdDateStr.isEmpty()) {
                    createdDate = new SimpleDateFormat("yyyy-MM-dd").parse(createdDateStr);
                }
            } catch (Exception e) { }

            int page = 1;
            int pageSize = 5;
            try {
                page = Integer.parseInt(req.getParameter("page"));
            } catch (Exception e) { }

            List<News> all;
            if (search != null && !search.trim().isEmpty()) {
                all = newsFacade.findByTitle(search.trim());
            } else {
                all = newsFacade.findAll();
            }

            // sắp xếp tin mới nhất lên đầu (theo createdAt giảm dần)
            all.sort((a, b) -> {
                if (a.getCreatedAt() == null || b.getCreatedAt() == null) {
                    return 0;
                }
                return b.getCreatedAt().compareTo(a.getCreatedAt());
            });

            // lọc theo trạng thái
            if (status != null && !status.isEmpty()) {
                all.removeIf(n -> n.getStatus() == null || !status.equalsIgnoreCase(n.getStatus()));
            }

            // lọc theo ngày tạo
            if (createdDate != null) {
                Calendar calSelected = Calendar.getInstance();
                calSelected.setTime(createdDate);
                calSelected.set(Calendar.HOUR_OF_DAY, 0);
                calSelected.set(Calendar.MINUTE, 0);
                calSelected.set(Calendar.SECOND, 0);
                calSelected.set(Calendar.MILLISECOND, 0);

                all.removeIf(n -> {
                    if (n.getCreatedAt() == null) return true;
                    Calendar calNews = Calendar.getInstance();
                    calNews.setTime(n.getCreatedAt());
                    calNews.set(Calendar.HOUR_OF_DAY, 0);
                    calNews.set(Calendar.MINUTE, 0);calNews.set(Calendar.SECOND, 0);
                    calNews.set(Calendar.MILLISECOND, 0);
                    return !calNews.getTime().equals(calSelected.getTime());
                });
            }

            int total = all.size();
            int totalPages = (int) Math.ceil((double) total / pageSize);
            if (page < 1) page = 1;
            if (page > totalPages) page = totalPages;

            int fromIndex = (page - 1) * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, total);
            List<News> list = all.subList(fromIndex, toIndex);

            req.setAttribute("newsList", list);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);

            req.getRequestDispatcher("/WEB-INF/views/admin/news/list.jsp").forward(req, resp);
            return;
        }

        if ("create".equals(action)) {
            loadAssetImages(req);
            req.getRequestDispatcher("/WEB-INF/views/admin/news/form.jsp").forward(req, resp);
            return;
        }

        if ("edit".equals(action)) {
            Integer id = parseId(req.getParameter("id"));
            News news = id != null ? newsFacade.find(id) : null;
            req.setAttribute("news", news);
            loadAssetImages(req);
            req.getRequestDispatcher("/WEB-INF/views/admin/news/form.jsp").forward(req, resp);
            return;
        }

        if ("view".equals(action)) {
            Integer id = parseId(req.getParameter("id"));
            News news = id != null ? newsFacade.find(id) : null;
            req.setAttribute("news", news);
            req.getRequestDispatcher("/WEB-INF/views/admin/news/view.jsp").forward(req, resp);
            return;
        }

        if ("delete".equals(action)) {
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
            if (thumbnailPath != null && !thumbnailPath.isBlank()) {
                n.setThumbnailUrl(thumbnailPath);
            }
            newsFacade.create(n);
            resp.sendRedirect(req.getContextPath() + "/admin/news?action=list");
            return;
        }

        if ("edit".equals(action)) {
            Integer id = parseId(req.getParameter("id"));
            News n = id != null ? newsFacade.find(id) : null;
            if (n != null) {
                updateNews(n, req);String thumbnailPath = req.getParameter("thumbnailPath");
                if (thumbnailPath != null && !thumbnailPath.isBlank()) {
                    n.setThumbnailUrl(thumbnailPath);
                }
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
        if (admin == null) {
            throw new ServletException("Không tìm thấy tài khoản admin");
        }
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
        if (admin == null) {
            throw new ServletException("Không tìm thấy tài khoản admin");
        }
        n.setUserID(admin);
    }

    private Integer parseId(String s) {
        try {
            return Integer.valueOf(s);
        } catch (Exception e) {
            return null;
        }
    }
}