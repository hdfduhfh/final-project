/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack.controller.user;

import jakarta.inject.Inject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import mypack.Role;
import mypack.User;
import mypack.UserFacadeLocal;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Inject
    private UserFacadeLocal userFacade;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Kiểm tra email đã tồn tại
        if (userFacade.existsByEmail(email)) { // bạn có thể thêm method existsByEmail trong UserFacadeLocal
            request.setAttribute("error", "Email đã được đăng ký!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPasswordHash(password); // đúng với field trong entity

        // Gán role mặc định USER
        Role userRole = new Role();
        userRole.setRoleID(2); // ID role USER trong DB
        user.setRoleID(userRole);

        userFacade.create(user);

        // Sau khi đăng ký thành công, redirect sang login hoặc home
        response.sendRedirect("index.jsp");
    }
}
