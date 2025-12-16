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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @EJB
    private UserFacadeLocal userFacade;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userFacade.login(email, password);

        PrintWriter out = response.getWriter();

        if (user == null) {
            out.print("{\"success\":false, \"message\":\"Sai thông tin đăng nhập!\"}");
            return;
        }

        // ✅ CẬP NHẬT LAST LOGIN
        user.setLastLogin(new Date());
        userFacade.edit(user);

        // ✅ LƯU SESSION
        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        // ✅ TRẢ JSON ROLE
        if ("ADMIN".equalsIgnoreCase(user.getRoleID().getRoleName())) {
            out.print("{\"success\":true, \"role\":\"ADMIN\"}");
        } else {
            out.print("{\"success\":true, \"role\":\"USER\"}");
        }
    }
}
