package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mypack.Role;
import mypack.User;
import mypack.RoleFacadeLocal;
import mypack.UserFacadeLocal;
import mypack.utils.HashUtils;

import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/admin/user")
public class UserManagementServlet extends HttpServlet {

    @EJB
    private UserFacadeLocal userFacade;

    @EJB
    private RoleFacadeLocal roleFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    handleCreate(request);
                    break;
                case "update":
                    handleUpdate(request);
                    break;
                case "delete":
                    handleDelete(request);
                    break;
                default:
                    request.setAttribute("error", "Hành động không hợp lệ!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        loadList(request, response);
    }

    private void handleCreate(HttpServletRequest request) {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String roleName = request.getParameter("roleName");

        String error = null;

        if (fullName == null || fullName.trim().isEmpty()) error = "Vui lòng nhập họ tên!";
        else if (email == null || email.trim().isEmpty()) error = "Vui lòng nhập email!";
        else if (roleName == null || roleName.trim().isEmpty()) error = "Vui lòng chọn vai trò!";
        else if (userFacade.findByEmail(email) != null) error = "Email đã tồn tại trong hệ thống!";

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("oldFullName", fullName);
            request.setAttribute("oldEmail", email);
            request.setAttribute("oldPhone", phone);
            request.setAttribute("oldRole", roleName);
            request.setAttribute("showCreateModal", true);
        } else {
            Role role = roleFacade.findByName(roleName);
            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setRoleID(role);
            user.setPasswordHash(HashUtils.hashPassword("123456"));
            user.setCreatedAt(new Date());
            user.setUpdatedAt(new Date());

            userFacade.create(user);
            request.setAttribute("message", "Tạo tài khoản thành công!");
        }
    }

    private void handleUpdate(HttpServletRequest request) {
        String idStr = request.getParameter("userID");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String roleName = request.getParameter("roleName");

        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("error", "ID người dùng không hợp lệ!");
            return;
        }

        int userID = Integer.parseInt(idStr);
        User currentUser = userFacade.find(userID);

        if (currentUser == null) {
            request.setAttribute("error", "Người dùng không tồn tại!");
            return;
        }

        User userWithEmail = userFacade.findByEmail(email);
        if (userWithEmail != null && userWithEmail.getUserID() != userID) {
            request.setAttribute("error", "Email này đang được sử dụng bởi người khác!");
            request.setAttribute("editUserId", userID);
            request.setAttribute("editFullName", fullName);
            request.setAttribute("editEmail", email);
            request.setAttribute("editPhone", phone);
            request.setAttribute("showEditModal", true);
            return;
        }

        currentUser.setFullName(fullName);
        currentUser.setEmail(email);
        currentUser.setPhone(phone);
        currentUser.setUpdatedAt(new Date());

        if (roleName != null && !roleName.trim().isEmpty()) {
            Role role = roleFacade.findByName(roleName);
            if (role != null) currentUser.setRoleID(role);
        }

        userFacade.edit(currentUser);
        request.setAttribute("message", "Cập nhật thành công!");
    }

    private void handleDelete(HttpServletRequest request) {
        String idStr = request.getParameter("userID");
        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("error", "ID người dùng không hợp lệ!");
            return;
        }

        int id = Integer.parseInt(idStr);
        User user = userFacade.find(id);
        if (user == null) {
            request.setAttribute("error", "Người dùng không tồn tại!");
            return;
        }

        try {
            userFacade.remove(user);
            request.setAttribute("message", "Xóa người dùng thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể xóa người dùng này vì đã có dữ liệu liên quan.");
        }
    }

    private void loadList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> users = userFacade.findAll();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/views/admin/user/list.jsp").forward(request, response);
    }
}
