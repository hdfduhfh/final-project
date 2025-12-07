package mypack.controller.user;

import jakarta.inject.Inject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import mypack.User;
import mypack.UserFacadeLocal;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Inject
    private UserFacadeLocal userFacade;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userFacade.login(email, password);

        if (user == null) {
            request.setAttribute("error", "Sai thông tin đăng nhập!");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        // Redirect theo role
        if (user.getRoleID().getRoleName().equalsIgnoreCase("ADMIN")) {
            response.sendRedirect("admin/");
        } else {
            response.sendRedirect("user/");
        }
    }
}
