package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.io.PrintWriter;
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
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userFacade.login(email, password);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (user == null) {
            // Sai thông tin
            out.print("{\"success\":false, \"message\":\"Sai thông tin đăng nhập!\"}");
            return;
        }

        // Lưu session
        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        // Trả về JSON role
        if (user.getRoleID().getRoleName().equalsIgnoreCase("ADMIN")) {
            out.print("{\"success\":true, \"role\":\"ADMIN\"}");
        } else {
            out.print("{\"success\":true, \"role\":\"USER\"}");
        }
    }
}
