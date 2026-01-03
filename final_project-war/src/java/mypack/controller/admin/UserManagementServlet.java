package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mypack.*;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;
import mypack.utils.HashUtils;

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
            request.setAttribute("error", "❌ " + e.getMessage());
        }

        loadList(request, response);
    }

    // ================= CREATE =================
    private void handleCreate(HttpServletRequest request) {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String roleName = request.getParameter("roleName");

        if (fullName == null || fullName.isBlank()) {
            request.setAttribute("error", "Vui lòng nhập họ tên");
            setCreateAttributes(request, fullName, email, phone, roleName);
            return;
        }

        if (email == null || email.isBlank()) {
            request.setAttribute("error", "Vui lòng nhập email");
            setCreateAttributes(request, fullName, email, phone, roleName);
            return;
        }

        if (!isValidEmail(email)) {
            request.setAttribute("error", "Email không đúng định dạng!");
            setCreateAttributes(request, fullName, email, phone, roleName);
            return;
        }

        if (userFacade.findByEmail(email) != null) {
            request.setAttribute("error", "Email đã tồn tại!");
            setCreateAttributes(request, fullName, email, phone, roleName);
            return;
        }

        Role role = roleFacade.findByName(roleName);
        if (role == null) {
            request.setAttribute("error", "Vai trò không hợp lệ");
            setCreateAttributes(request, fullName, email, phone, roleName);
            return;
        }

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setRoleID(role);
        user.setPasswordHash(HashUtils.hashPassword("123456"));
        user.setCreatedAt(new Date());

        userFacade.create(user);
        request.setAttribute("message", "Tạo người dùng thành công!");
    }

// ================= UPDATE =================
    private void handleUpdate(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("userID"));
        User user = userFacade.find(id);

        if (user == null) {
            request.setAttribute("error", "Không tìm thấy người dùng!");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // ❗ Validate email rỗng
        if (email == null || email.isBlank()) {
            request.setAttribute("error", "Email không được để trống");
            setEditAttributes(request, id, fullName, email, phone);
            return;
        }

        // ❗ Validate format email
        if (!isValidEmail(email)) {
            request.setAttribute("error", "Email không hợp lệ!");
            setEditAttributes(request, id, fullName, email, phone);
            return;
        }

        // ❗ Check trùng email
        User checkEmail = userFacade.findByEmail(email);
        if (checkEmail != null && checkEmail.getUserID() != id) {
            request.setAttribute("error", "Email đã được sử dụng!");
            setEditAttributes(request, id, fullName, email, phone);
            return;
        }

        String roleName = request.getParameter("roleName");

        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);

        if (roleName != null) {
            Role role = roleFacade.findByName(roleName);
            if (role != null) {
                user.setRoleID(role);
            }
        }

        userFacade.edit(user);
        request.setAttribute("message", "Cập nhật thành công!");
    }

    // ================= DELETE =================
    private void handleDelete(HttpServletRequest request) {
        String idStr = request.getParameter("userID");

        if (idStr == null || idStr.isEmpty()) {
            request.setAttribute("message", "ID người dùng không hợp lệ!");
            return;
        }

        int userId = Integer.parseInt(idStr);
        User user = userFacade.find(userId);

        if (user == null) {
            request.setAttribute("message", "Người dùng không tồn tại!");
            return;
        }

        if ("ADMIN".equalsIgnoreCase(user.getRoleID().getRoleName())) {
            request.setAttribute("message", "Không thể xóa tài khoản ADMIN!");
            return;
        }

        Long orderCount = userFacade.countOrdersByUser(userId);
        if (orderCount > 0) {
            request.setAttribute("message",
                    "Không thể xóa vì người dùng có " + orderCount + " đơn hàng!");
            return;
        }

        userFacade.deleteUser(userId);
        request.setAttribute("message", "Đã xóa người dùng thành công!");
    }

    // ================= LOAD LIST =================
    private void loadList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roleFilter = request.getParameter("roleFilter");
        String keyword = request.getParameter("keyword");
        String dateSort = request.getParameter("dateSort");

        List<User> users = userFacade.findAll();

        if (roleFilter != null && !roleFilter.isBlank()) {
            users = users.stream()
                    .filter(u -> u.getRoleID().getRoleName().equals(roleFilter))
                    .collect(Collectors.toList());
        }

        if (keyword != null && !keyword.isBlank()) {
            String k = keyword.toLowerCase();
            users = users.stream()
                    .filter(u -> u.getFullName().toLowerCase().contains(k)
                    || u.getEmail().toLowerCase().contains(k))
                    .collect(Collectors.toList());
        }

        if ("newest".equals(dateSort)) {
            users.sort(Comparator.comparing(User::getCreatedAt).reversed());
        } else if ("oldest".equals(dateSort)) {
            users.sort(Comparator.comparing(User::getCreatedAt));
        }

        Map<Integer, Long> orderMap = new HashMap<>();
        for (User u : users) {
            orderMap.put(u.getUserID(), userFacade.countOrdersByUser(u.getUserID()));
        }

        request.setAttribute("users", users);
        request.setAttribute("orderCountMap", orderMap);

        request.getRequestDispatcher("/WEB-INF/views/admin/user/list.jsp")
                .forward(request, response);
    }

    private boolean isValidEmail(String email) {
        if (email == null) {
            return false;
        }
        String regex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
        return email.matches(regex);
    }

    private void setEditAttributes(HttpServletRequest request, int id,
            String fullName, String email, String phone) {
        request.setAttribute("showEditModal", true);
        request.setAttribute("editUserId", id);
        request.setAttribute("editFullName", fullName);
        request.setAttribute("editEmail", email);
        request.setAttribute("editPhone", phone);
    }

    private void setCreateAttributes(HttpServletRequest request,
            String fullName,
            String email,
            String phone,
            String role) {
        request.setAttribute("showCreateModal", true);
        request.setAttribute("oldFullName", fullName);
        request.setAttribute("oldEmail", email);
        request.setAttribute("oldPhone", phone);
        request.setAttribute("oldRole", role);
    }

}
