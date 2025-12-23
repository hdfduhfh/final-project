package mypack.controller.admin;

import java.io.IOException;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mypack.*;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @EJB private UserFacadeLocal userFacade;
    @EJB private Order1FacadeLocal orderFacade;
    @EJB private ShowFacadeLocal showFacade;
    @EJB private ArtistFacadeLocal artistFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. LẤY SỐ LIỆU TỔNG QUAN (Dùng hàm count() có sẵn, không cần viết thêm)
        int totalUsers = userFacade.count();
        int totalOrders = orderFacade.count();
        int totalShows = showFacade.count();
        int totalArtists = artistFacade.count();
        
        // Riêng doanh thu thì cần hàm tính tổng (đã có ở OrderFacade)
        // Nếu chưa có thì hiện tạm số 0 hoặc bỏ qua
        java.math.BigDecimal totalRevenue = orderFacade.getTotalRevenue(); 

        // 2. GỬI SANG JSP
        request.setAttribute("COUNT_USER", totalUsers);
        request.setAttribute("COUNT_ORDER", totalOrders);
        request.setAttribute("COUNT_SHOW", totalShows);
        request.setAttribute("COUNT_ARTIST", totalArtists);
        request.setAttribute("TOTAL_REVENUE", totalRevenue);

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}