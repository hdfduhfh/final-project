package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.Paths;
import java.util.Date;
import mypack.Application;
import mypack.ApplicationFacadeLocal;
import mypack.Recruitment;
import mypack.RecruitmentFacadeLocal;

@WebServlet("/applyjob")
@MultipartConfig
public class ApplyJobServlet extends HttpServlet {

    @EJB
    private ApplicationFacadeLocal applicationFacade;

    @EJB
    private RecruitmentFacadeLocal recruitmentFacade;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Integer jobID = Integer.valueOf(req.getParameter("jobId"));
        Recruitment job = recruitmentFacade.find(jobID);

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");

        // Lấy file upload
        Part cvPart = req.getPart("cvFile");
        String submitted = cvPart.getSubmittedFileName();
        String baseName = Paths.get(submitted).getFileName().toString();
        String safeName = baseName.replaceAll("[^a-zA-Z0-9\\.\\-_]", "_");

        // Thư mục assets/upload (con của assets, cùng cấp WEB-INF)
        String uploadPath = getServletContext().getRealPath("/assets/upload");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        File outFile = new File(uploadDir, safeName);
        try (InputStream in = cvPart.getInputStream();
             OutputStream out = new FileOutputStream(outFile)) {
            byte[] buffer = new byte[8192];
            int len;
            while ((len = in.read(buffer)) != -1) {
                out.write(buffer, 0, len);
            }
        }

        // Lưu đường dẫn tương đối vào DB
        Application app = new Application();
        app.setFullName(fullName);
        app.setEmail(email);
        app.setPhone(phone);
        app.setCvUrl("assets/upload/" + safeName); // đường dẫn để JSP hiển thị
        app.setAppliedAt(new Date());
        app.setJob(job);

        applicationFacade.create(app);

        // Thông báo thành công
        resp.sendRedirect(req.getContextPath() + "/viewjob?id=" + jobID + "&applied=success");
    }
}