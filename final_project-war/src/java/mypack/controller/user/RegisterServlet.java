/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import mypack.Role;
import mypack.User;
import mypack.UserFacadeLocal;
import mypack.RoleFacadeLocal;
import mypack.utils.HashUtils;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @EJB
    private UserFacadeLocal userFacade;

    @EJB
    private RoleFacadeLocal roleFacade;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        PrintWriter out = response.getWriter();

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // Kiểm tra email đã tồn tại
            if (userFacade.existsByEmail(email)) {
                out.print("{\"success\":false, \"message\":\"Email đã được đăng ký!\"}");
                return;
            }

            // Tạo user mới
            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);

            // Hash mật khẩu
            user.setPasswordHash(HashUtils.hashPassword(password));

            // Set ngày tạo
            user.setCreatedAt(new Date());

            // Gán role mặc định USER
            Role userRole = roleFacade.findByName("USER");
            user.setRoleID(userRole);

            // Lưu user
            userFacade.create(user);

            out.print("{\"success\":true, \"message\":\"Đăng ký thành công!\"}");

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false, \"message\":\"Lỗi server khi đăng ký!\"}");
        }
    }
}