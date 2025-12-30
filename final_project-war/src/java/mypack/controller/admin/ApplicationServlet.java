package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import java.util.Iterator;
import mypack.Application;
import mypack.ApplicationFacadeLocal;

@WebServlet("/admin/applyjob")
public class ApplicationServlet extends HttpServlet {

    @EJB
    private ApplicationFacadeLocal applicationFacade;

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String keyword = req.getParameter("keyword");   // tìm theo tên/SĐT
        String status = req.getParameter("status");     // lọc trạng thái
        String jobTitle = req.getParameter("jobTitle"); // lọc theo tên công việc

        int page = 1;
        try {
            page = Integer.parseInt(req.getParameter("page"));
        } catch (Exception e) {
            page = 1;
        }

        // lấy danh sách ban đầu
        List<Application> apps = (keyword != null && !keyword.trim().isEmpty())
                ? applicationFacade.searchByNameOrPhone(keyword.trim())
                : applicationFacade.findAll();

        // lọc theo trạng thái
        if (status != null && !status.isEmpty()) {
            Iterator<Application> it = apps.iterator();
            while (it.hasNext()) {
                Application a = it.next();
                if (a.getStatus() == null || !status.equalsIgnoreCase(a.getStatus())) {
                    it.remove();
                }
            }
        }

        // lọc theo tên công việc
        if (jobTitle != null && !jobTitle.trim().isEmpty()) {
            String jobTitleLower = jobTitle.trim().toLowerCase();
            Iterator<Application> it = apps.iterator();
            while (it.hasNext()) {
                Application a = it.next();
                if (a.getJob() == null || a.getJob().getTitle() == null
                        || !a.getJob().getTitle().toLowerCase().contains(jobTitleLower)) {
                    it.remove();
                }
            }
        }

        // phân trang
        int total = apps.size();
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
        int fromIndex = Math.max(0, (page - 1) * PAGE_SIZE);
        int toIndex = Math.min(fromIndex + PAGE_SIZE, total);
        List<Application> pageApps = apps.subList(fromIndex, toIndex);

        req.setAttribute("apps", pageApps);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("keyword", keyword);

        String message = req.getParameter("message");
        if (message != null) {
            req.setAttribute("message", message);
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/applyjob/listapplication.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String idStr = req.getParameter("id");
        String action = req.getParameter("action");
        String message = "";

        if (idStr != null && action != null) {
            Integer id = Integer.valueOf(idStr);
            Application app = applicationFacade.find(id);
            if (app != null) {
                switch (action) {
                    case "accept":
                        app.setStatus("Accepted");
                        applicationFacade.edit(app);
                        message = "Đã gửi tin nhắn xác hẹn lịch phỏng vấn cho "
                                + app.getFullName() + " - SĐT: " + app.getPhone();
                        break;
                    case "reject":
                        app.setStatus("Rejected");
                        applicationFacade.edit(app);
                        message = "Đã gửi tin nhắn từ chối CV.";
                        break;
                    case "delete":
                        applicationFacade.remove(app);
                        message = "Đơn ứng tuyển của " + app.getFullName() + " đã bị xóa khỏi hệ thống.";
                        break;
                }
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/applyjob?message=" + URLEncoder.encode(message, "UTF-8"));
    }
}
