package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import mypack.Recruitment;
import mypack.RecruitmentFacadeLocal;

@WebServlet({"/job", "/listjob", "/viewjob"})
public class RecruitmentServlet extends HttpServlet {

    @EJB
    private RecruitmentFacadeLocal recruitmentFacade;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        if ("/job".equals(path) || "/listjob".equals(path)) {
            handleListJob(req, resp);
        } else if ("/viewjob".equals(path)) {
            handleViewJob(req, resp);
        }
    }

    /**
     * Hiển thị danh sách job (chỉ job đang mở), có tìm kiếm và phân trang
     */
    private void handleListJob(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String search = req.getParameter("search");
        int page = 1;
        int pageSize = 10; // ✅ 10 job/trang
        try {
            page = Integer.parseInt(req.getParameter("page"));
        } catch (Exception e) {
            // giữ nguyên page = 1 nếu không parse được
        }

        // Lấy danh sách job từ DB
        List<Recruitment> allJobs = (search != null && !search.trim().isEmpty())
                ? recruitmentFacade.findByTitle(search.trim())
                : recruitmentFacade.findAll();

        // ✅ Lọc chỉ lấy job đang mở (status = "Open")
        List<Recruitment> openJobs = new ArrayList<>();
        for (Recruitment job : allJobs) {
            if (job.getStatus() != null && job.getStatus().equalsIgnoreCase("Open")) {
                openJobs.add(job);
            }
        }

        // Sắp xếp theo ngày đăng mới nhất
        openJobs.sort(Comparator.comparing(Recruitment::getPostedAt).reversed());

        // Phân trang
        int totalJobs = openJobs.size();
        int totalPages = (int) Math.ceil((double) totalJobs / pageSize);
        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalJobs);
        List<Recruitment> list = openJobs.subList(fromIndex, toIndex);

        // Gửi dữ liệu sang JSP
        req.setAttribute("jobList", list);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalJobs", totalJobs);

        req.getRequestDispatcher("/WEB-INF/views/job/listjob.jsp").forward(req, resp);
    }

    /**
     * Hiển thị chi tiết job
     */
    private void handleViewJob(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Integer id = null;
        try {
            id = Integer.valueOf(req.getParameter("id"));
        } catch (Exception e) {
            // id không hợp lệ
        }
        Recruitment job = id != null ? recruitmentFacade.find(id) : null;

        req.setAttribute("job", job);
        req.getRequestDispatcher("/WEB-INF/views/job/viewjob.jsp").forward(req, resp);
    }
}