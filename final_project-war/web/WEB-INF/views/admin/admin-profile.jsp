<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="mypack.User" %>

<%
    User user = (User) session.getAttribute("user");
    String fullName = (user != null) ? user.getFullName() : "Admin";
    String email = (user != null) ? user.getEmail() : "admin@email.com";
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #0f111a;
            color: #fff;
        }

        .profile-card {
            background: #1e2433;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
        }

        .avatar {
            width: 120px;
            height: 120px;
            background: #3b82f6;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 42px;
            font-weight: bold;
            color: white;
            margin: auto;
        }

        .info-label {
            color: #94a3b8;
            font-size: 0.85rem;
        }

        .info-value {
            font-weight: 600;
            font-size: 1rem;
        }

        .badge-role {
            background: rgba(16,185,129,.15);
            color: #10b981;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
        }

        .btn-custom {
            background: #3b82f6;
            border: none;
        }

        .btn-custom:hover {
            background: #2563eb;
        }
    </style>
</head>

<body>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">

            <div class="profile-card text-center mb-4">
                <div class="avatar mb-3">
                    <%= fullName.substring(0,1).toUpperCase() %>
                </div>
                <h4 class="mb-1"><%= fullName %></h4>
                <p class="text-muted mb-2"><%= email %></p>
                <span class="badge-role">ADMINISTRATOR</span>
            </div>

            <div class="profile-card mb-4">
                <h5 class="mb-3">📋 Thông tin cá nhân</h5>
                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="info-label">Họ và tên</div>
                        <div class="info-value"><%= fullName %></div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-label">Email</div>
                        <div class="info-value"><%= email %></div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-label">Vai trò</div>
                        <div class="info-value">Quản trị hệ thống</div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-label">Trạng thái</div>
                        <div class="info-value text-success">Đang hoạt động</div>
                    </div>
                </div>
            </div>

            <div class="profile-card">
                <h5 class="mb-3">🔐 Bảo mật tài khoản</h5>
                <div class="d-flex gap-3 flex-wrap">
                    <a href="#" class="btn btn-outline-light">Đổi mật khẩu</a>
                    <a href="#" class="btn btn-outline-warning">Đăng xuất tất cả thiết bị</a>
                </div>
            </div>

        </div>
    </div>
</div>

</body>
</html>
