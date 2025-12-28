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
import mypack.Recruitment;
import mypack.RecruitmentFacadeLocal;
import mypack.User;
import mypack.UserFacadeLocal;

@WebServlet("/admin/recruitment")
public class RecruitmentManagerServlet extends HttpServlet {

    @EJB
    private RecruitmentFacadeLocal recruitmentFacade;

    @EJB
    private UserFacadeLocal userFacade;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if (action == null || action.equals("list")) {
            String search = req.getParameter("search");

            // Trang hiện tại
            int page = 1;
            int pageSize = 5; // ✅ cố định 5 job/trang
            try {
                page = Integer.parseInt(req.getParameter("page"));
            } catch (Exception e) {}

            // Lấy toàn bộ danh sách
            List<Recruitment> allJobs = (search != null && !search.trim().isEmpty())
                    ? recruitmentFacade.findByTitle(search.trim())
                    : recruitmentFacade.findAll();

            // ✅ Sắp xếp theo ngày đăng mới nhất
            allJobs.sort(Comparator.comparing(Recruitment::getPostedAt).reversed());

            // Tổng số trang
            int totalJobs = allJobs.size();
            int totalPages = (int) Math.ceil((double) totalJobs / pageSize);

            // Cắt danh sách theo trang
            int fromIndex = (page - 1) * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, totalJobs);
            List<Recruitment> list = allJobs.subList(fromIndex, toIndex);

            // ✅ Kiểm tra deadline và tự động đóng
            Date now = new Date();
            for (Recruitment job : list) {
                if (job.getDeadline() != null && now.after(job.getDeadline())) {
                    if (!"Closed".equalsIgnoreCase(job.getStatus())) {
                        job.setStatus("Closed");
                        recruitmentFacade.edit(job);
                    }
                }
            }

            // Truyền sang JSP
            req.setAttribute("jobList", list);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);

            req.getRequestDispatcher("/WEB-INF/views/admin/recruitment/list.jsp").forward(req, resp);
            return;
        }

        if (action.equals("create")) {
            loadLogoImages(req);
            req.getRequestDispatcher("/WEB-INF/views/admin/recruitment/form.jsp").forward(req, resp);
            return;
        }

        if (action.equals("edit")) {
            Integer id = parseId(req.getParameter("id"));
            Recruitment job = id != null ? recruitmentFacade.find(id) : null;

            if (job != null && job.getDeadline() != null && new Date().after(job.getDeadline())) {
                if (!"Closed".equalsIgnoreCase(job.getStatus())) {
                    job.setStatus("Closed");
                    recruitmentFacade.edit(job);
                }
            }

            req.setAttribute("job", job);
            loadLogoImages(req);
            req.getRequestDispatcher("/WEB-INF/views/admin/recruitment/form.jsp").forward(req, resp);
            return;
        }

        if (action.equals("view")) {
            Integer id = parseId(req.getParameter("id"));
            Recruitment job = id != null ? recruitmentFacade.find(id) : null;

            if (job != null && job.getDeadline() != null && new Date().after(job.getDeadline())) {
                if (!"Closed".equalsIgnoreCase(job.getStatus())) {
                    job.setStatus("Closed");
                    recruitmentFacade.edit(job);
                }
            }

            req.setAttribute("job", job);
            req.getRequestDispatcher("/WEB-INF/views/admin/recruitment/view.jsp").forward(req, resp);
            return;
        }

        if (action.equals("delete")) {
            Integer id = parseId(req.getParameter("id"));
            if (id != null) {
                Recruitment job = recruitmentFacade.find(id);
                if (job != null) {
                    recruitmentFacade.remove(job); // ✅ hard delete
                }
            }
            resp.sendRedirect(req.getContextPath() + "/admin/recruitment?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("create".equals(action)) {
            Recruitment job = buildJob(req);
            recruitmentFacade.create(job);
            resp.sendRedirect(req.getContextPath() + "/admin/recruitment?action=list");
        }

        if ("edit".equals(action)) {
            Integer id = parseId(req.getParameter("id"));
            Recruitment job = id != null ? recruitmentFacade.find(id) : null;
            if (job != null) {
                updateJob(job, req);
                recruitmentFacade.edit(job);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/recruitment?action=list");
        }
    }

    private void loadLogoImages(HttpServletRequest req) {
        Set<String> paths = req.getServletContext().getResourcePaths("/assets/images/logo/");
        List<String> logos = new ArrayList<>();
        if (paths != null) {
            for (String p : paths) {
                String lower = p.toLowerCase(Locale.ROOT);
                if (lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png")
                        || lower.endsWith(".gif") || lower.endsWith(".webp")) {
                    logos.add(p.startsWith("/") ? p.substring(1) : p);
                }
            }
        }
        req.setAttribute("logoImages", logos);
    }

    private Recruitment buildJob(HttpServletRequest req) throws ServletException {
        Recruitment job = new Recruitment();
        job.setTitle(req.getParameter("title"));
        job.setDescription(req.getParameter("description"));
        job.setRequirement(req.getParameter("requirement"));
        job.setLocation(req.getParameter("location"));
        job.setSalary(req.getParameter("salary"));
        job.setStatus(req.getParameter("status"));
        job.setLogoUrl(req.getParameter("logoUrl"));
        job.setPostedAt(new Date());

        String deadlineStr = req.getParameter("deadline");
        if (deadlineStr != null && !deadlineStr.isBlank()) {
            try {
                Date deadline = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(deadlineStr);
                job.setDeadline(deadline);
                if (new Date().after(deadline)) {
                    job.setStatus("Closed");
                }
            } catch (Exception e) {}
        }

        User admin = userFacade.findByEmail("admin@example.com");
        if (admin == null) throw new ServletException("Không tìm thấy tài khoản admin");
        job.setUserID(admin);

        return job;
    }

    private void updateJob(Recruitment job, HttpServletRequest req) throws ServletException {
        job.setTitle(req.getParameter("title"));
        job.setDescription(req.getParameter("description"));
        job.setRequirement(req.getParameter("requirement"));
        job.setLocation(req.getParameter("location"));
        job.setSalary(req.getParameter("salary"));
        job.setStatus(req.getParameter("status"));
        job.setLogoUrl(req.getParameter("logoUrl"));
        job.setUpdatedAt(new Date());

        String deadlineStr = req.getParameter("deadline");
        if (deadlineStr != null && !deadlineStr.isBlank()) {
            try {
                Date deadline = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(deadlineStr);
                job.setDeadline(deadline);
                if (new Date().after(deadline)) {
                    job.setStatus("Closed");
                }
            } catch (Exception e) {}
        }

        User admin = userFacade.findByEmail("admin@example.com");
        if (admin == null) throw new ServletException("Không tìm thấy tài khoản admin");
        job.setUserID(admin);
    }

    private Integer parseId(String s) {
        try { return Integer.valueOf(s); } catch (Exception e) { return null; }
    }
}