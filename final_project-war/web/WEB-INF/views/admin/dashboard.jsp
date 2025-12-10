<%-- 
    Document   : dashboard
    Created on : Dec 5, 2025, 2:36:00 PM
    Author     : DANG KHOA
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="mypack.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equalsIgnoreCase(user.getRoleID().getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f6fa;
        }
        .sidebar {
            width: 220px;
            height: 100vh;
            background: #2c3e50;
            color: white;
            padding-top: 20px;
            position: fixed;
            left: 0;
            top: 0;
            overflow-y: auto;
        }
        .sidebar h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .sidebar a {
            display: block;
            padding: 12px 20px;
            text-decoration: none;
            color: white;
            font-size: 15px;
            transition: background 0.3s;
        }
        .sidebar a:hover {
            background: #34495e;
        }
        .sidebar a.active {
            background: #34495e;
            border-left: 4px solid #3498db;
        }
        .content {
            margin-left: 220px;
            height: 100vh;
            overflow: hidden;
        }
        .dashboard-home {
            padding: 20px;
            display: none;
        }
        .dashboard-home.active {
            display: block;
        }
        .card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .logout-btn {
            color: #c0392b !important;
            font-weight: bold;
        }
        #contentFrame {
            width: 100%;
            height: 100%;
            border: none;
            display: none;
        }
        #contentFrame.active {
            display: block;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h2>Admin Panel</h2>
        <a href="#" onclick="showDashboard(event)" id="link-dashboard" class="active">📊 Dashboard</a>
        <a href="#" onclick="loadPage(event, 'user')" id="link-user">👤 Quản lý User</a>
        <a href="#" onclick="loadPage(event, 'show')" id="link-show">🎭 Quản lý Show</a>
        <a href="#" onclick="loadPage(event, 'artist')" id="link-artist">🎤 Quản lý Artist</a>
        <a href="#" onclick="loadPage(event, 'schedule')" id="link-schedule">📅 Quản lý Schedule</a>
        <a href="#" onclick="loadPage(event, 'ticket')" id="link-ticket">🎟 Quản lý Vé</a>
        <a href="#" onclick="loadPage(event, 'payment')" id="link-payment">💰 Quản lý Thanh toán</a>
        <a href="<%= request.getContextPath() %>/logout" class="logout-btn">🚪 Đăng xuất</a>
    </div>

    <!-- Nội dung chính -->
    <div class="content">
        <!-- Trang dashboard mặc định -->
        <div id="dashboardHome" class="dashboard-home active">
            <h1>Xin chào Admin: <%= user.getFullName() %> 👋</h1>
            <div class="card">
                <h2>Tổng quan hệ thống</h2>
                <p>• Tổng số Users: ...</p>
                <p>• Tổng số Vé đã bán: ...</p>
                <p>• Doanh thu tháng này: ...</p>
            </div>
            <div class="card">
                <h2>Nhật ký hoạt động gần đây</h2>
                <p>• User A đã đặt vé</p>
                <p>• User B đăng ký tài khoản</p>
            </div>
        </div>

        <!-- iframe để load các trang quản lý -->
        <iframe id="contentFrame"></iframe>
    </div>

    <script>
        const contextPath = '<%= request.getContextPath() %>';
        
        function showDashboard(event) {
            event.preventDefault();
            
            // Ẩn iframe, hiện dashboard
            document.getElementById('contentFrame').classList.remove('active');
            document.getElementById('dashboardHome').classList.add('active');
            
            // Cập nhật active menu
            updateActiveMenu('link-dashboard');
        }
        
        function loadPage(event, page) {
            event.preventDefault();
            
            // Ẩn dashboard, hiện iframe
            document.getElementById('dashboardHome').classList.remove('active');
            const iframe = document.getElementById('contentFrame');
            iframe.classList.add('active');
            
            // Load trang vào iframe
            iframe.src = contextPath + '/admin/' + page;
            
            // Cập nhật active menu
            updateActiveMenu('link-' + page);
        }
        
        function updateActiveMenu(activeId) {
            // Xóa active của tất cả links
            const links = document.querySelectorAll('.sidebar a');
            links.forEach(link => link.classList.remove('active'));
            
            // Thêm active cho link được chọn
            document.getElementById(activeId).classList.add('active');
        }
    </script>
</body>
</html>
