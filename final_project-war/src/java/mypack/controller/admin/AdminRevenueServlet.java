package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import mypack.Order1FacadeLocal;

@WebServlet(name = "AdminRevenueServlet", urlPatterns = {"/admin/revenue"})
public class AdminRevenueServlet extends HttpServlet {

    @EJB
    private Order1FacadeLocal orderFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // ===== 1. TỔNG DOANH THU (ĐÃ TRỪ HOÀN TIỀN) =====
            BigDecimal totalRevenue = orderFacade.getTotalRevenue();
            
            // ===== 2. TỔNG KHUYẾN MÃI =====
            BigDecimal totalDiscount = orderFacade.getTotalDiscount();
            
            // ===== 3. TỔNG TIỀN ĐÃ HOÀN LẠI =====
            BigDecimal totalRefund = orderFacade.getTotalRefund();
            
            // ===== 4. SỐ ĐƠN BỊ HỦY =====
            Long totalCancelledOrder = orderFacade.countCancelledOrder();
            
            // ===== 5. CHI TIẾT THEO NGÀY (7 NGÀY GẦN NHẤT) =====
            List<Object[]> revenueByDate = orderFacade.getRevenueByDate();
            
            // ===== 6. BÁO CÁO THEO THÁNG =====
            List<Object[]> revenueByMonth = orderFacade.getRevenueByMonth();

            // ===== GỬI DỮ LIỆU ĐẾN JSP =====
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalDiscount", totalDiscount);
            request.setAttribute("totalRefund", totalRefund);
            request.setAttribute("totalCancelledOrder", totalCancelledOrder);
            request.setAttribute("revenueByDate", revenueByDate);
            request.setAttribute("revenueByMonth", revenueByMonth);

            // ===== LOG ĐỂ DEBUG =====
            System.out.println("=== ADMIN REVENUE PAGE ===");
            System.out.println("Total Revenue: " + totalRevenue);
            System.out.println("Total Refund: " + totalRefund);
            System.out.println("Cancelled Orders: " + totalCancelledOrder);
            System.out.println("Daily Records: " + revenueByDate.size());

            request.getRequestDispatcher("/WEB-INF/views/admin/revenue/list.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            System.err.println("❌ Error in AdminRevenueServlet:");
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Không thể tải dữ liệu thống kê");
        }
    }
}