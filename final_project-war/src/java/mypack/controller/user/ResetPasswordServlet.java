package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import mypack.User;
import mypack.UserFacadeLocal;
import mypack.utils.HashUtils;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    @EJB
    private UserFacadeLocal userFacade;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        try {
            // Kiểm tra user tồn tại
            User user = userFacade.findByEmail(email);
            if (user == null) {
                out.print("{\"success\":false, \"message\":\"Email không tồn tại!\"}");
                return;
            }

            // Kiểm tra password nhập lại
            if (!newPassword.equals(confirmPassword)) {
                out.print("{\"success\":false, \"message\":\"Mật khẩu nhập lại không khớp!\"}");
                return;
            }

            // Hash mật khẩu mới
            user.setPasswordHash(HashUtils.hashPassword(newPassword));
            user.setUpdatedAt(new Date());

            // Lưu lại
            userFacade.edit(user);

            out.print("{\"success\":true, \"message\":\"Đổi mật khẩu thành công!\"}");

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false, \"message\":\"Lỗi server khi đổi mật khẩu!\"}");
        }
    }
}
