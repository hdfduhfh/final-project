///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package mypack.controller.user;
//
//import jakarta.ejb.EJB;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import java.io.IOException;
//import java.util.ArrayList;
//import java.util.List;
//import mypack.*;
//
//@WebServlet(name = "UserTicketsServlet", urlPatterns = {"/user/tickets"})
//public class UserTicketsServlet extends HttpServlet {
//    
//    @EJB
//    private Order1FacadeLocal orderFacade;
//    
//    @EJB
//    private TicketFacadeLocal ticketFacade;
//    
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        
//        HttpSession session = request.getSession();
//        User currentUser = (User) session.getAttribute("user");
//        
//        // Kiểm tra đăng nhập
//        if (currentUser == null) {
//            session.setAttribute("redirectAfterLogin", request.getContextPath() + "/user/tickets");
//            response.sendRedirect(request.getContextPath() + "/seats/layout?openLogin=true");
//            return;
//        }
//        
//        // Lấy tất cả order của user
//        List<Order1> allOrders = orderFacade.findAll();
//        List<Order1> userOrders = new ArrayList<>();
//        
//        for (Order1 order : allOrders) {
//            if (order.getUserID().getUserID().equals(currentUser.getUserID())) {
//                userOrders.add(order);
//            }
//        }
//        
//        // Sắp xếp theo ngày tạo mới nhất
//        userOrders.sort((o1, o2) -> o2.getCreatedAt().compareTo(o1.getCreatedAt()));
//        
//        request.setAttribute("orders", userOrders);
//        request.getRequestDispatcher("/WEB-INF/views/user/my-tickets.jsp")
//                .forward(request, response);
//    }
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        
//        // 1. Kiểm tra đăng nhập (Bảo mật)
//        HttpSession session = request.getSession();
//        User currentUser = (User) session.getAttribute("user");
//        
//        if (currentUser == null) {
//            response.sendRedirect(request.getContextPath() + "/seats/layout?openLogin=true");
//            return;
//        }
//
//        // 2. Thiết lập tiếng Việt
//        request.setCharacterEncoding("UTF-8");
//
//        // 3. Lấy hành động
//        String action = request.getParameter("action");
//
//        if ("requestCancel".equals(action)) {
//            try {
//                // Lấy ID đơn hàng và lý do từ form
//                String orderIdStr = request.getParameter("orderId");
//                String reason = request.getParameter("reason");
//
//                if (orderIdStr != null && reason != null) {
//                    int orderId = Integer.parseInt(orderIdStr);
//                    Order1 order = orderFacade.find(orderId);
//
//                    // LOGIC QUAN TRỌNG:
//                    // - Đơn hàng phải tồn tại
//                    // - Đơn hàng phải là của User đang đăng nhập (Tránh hack hủy đơn người khác)
//                    // - Trạng thái phải là CONFIRMED (Đã thanh toán) mới được yêu cầu hủy
//                    if (order != null 
//                            && order.getUserID().getUserID().equals(currentUser.getUserID()) 
//                            && "CONFIRMED".equals(order.getStatus())) {
//                        
//                        // Cập nhật thông tin yêu cầu hủy
//                        order.setCancellationRequested(true);
//                        order.setCancellationReason(reason);
//                        
//                        // Lưu vào Database
//                        orderFacade.edit(order);
//                    }
//                }
//            } catch (Exception e) {
//                e.printStackTrace(); // In lỗi nếu có
//            }
//        }
//
//        // 4. Xử lý xong thì tải lại trang danh sách vé
//        response.sendRedirect(request.getContextPath() + "/user/tickets");
//    }
//}