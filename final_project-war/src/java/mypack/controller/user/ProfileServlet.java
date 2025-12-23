package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import mypack.Order1;
import mypack.Order1FacadeLocal;
import mypack.User;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    @EJB
    private Order1FacadeLocal orderFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // 🔐 Chưa đăng nhập → về trang chủ
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // ✅ Lấy danh sách đơn hàng của user
        List<Order1> orders = orderFacade.findByUser(user);

        // Đưa sang JSP
        request.setAttribute("orders", orders);

        request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp")
               .forward(request, response);
    }
}
