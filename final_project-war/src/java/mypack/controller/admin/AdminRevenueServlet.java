/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import mypack.Order1;
import mypack.Order1FacadeLocal;

@WebServlet("/admin/revenue")
public class AdminRevenueServlet extends HttpServlet {

    @EJB
    private Order1FacadeLocal orderFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Các thống kê tổng số (Giữ nguyên code cũ)
        request.setAttribute("totalRevenue", orderFacade.getTotalRevenue());
        request.setAttribute("totalDiscount", orderFacade.getTotalDiscount());
        request.setAttribute("totalRefund", orderFacade.getTotalRefund());
        request.setAttribute("totalCancelledOrder", orderFacade.countCancelledOrder());

        // 2. Danh sách đơn hàng chi tiết (Giữ nguyên)
        List<Order1> paidOrders = orderFacade.findPaidOrders();
        request.setAttribute("paidOrders", paidOrders);

        // --- PHẦN THÊM MỚI QUAN TRỌNG ---
        // 3. Gọi hàm thống kê theo ngày (SQL Server) mà bạn vừa thêm vào Facade
        // Hàm này trả về List<Object[]> gồm [Ngày, Tổng tiền]
        List<Object[]> revenueByDate = orderFacade.getRevenueByDate();
        
        // Đẩy biến này sang JSP với tên "revenueByDate" để biểu đồ vẽ được
        request.setAttribute("revenueByDate", revenueByDate); 

        // 4. Chuyển hướng về trang JSP
        request.getRequestDispatcher("/WEB-INF/views/admin/revenue/list.jsp").forward(request, response);
    }
}