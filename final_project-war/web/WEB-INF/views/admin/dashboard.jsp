<%-- 
    Document   : dashboard_dark_final
    Updated    : Added Events Menu & Fixed Apply Job Icon
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="mypack.User" %>
<%@ page import="java.math.BigDecimal" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    // 1. KIỂM TRA SESSION USER
    User user = (User) session.getAttribute("user");
    String contextPath = request.getContextPath();
    String fullName = (user != null) ? user.getFullName() : "Admin";

    // 2. XỬ LÝ DỮ LIỆU THẬT TỪ SERVLET
    // Servlet gửi: COUNT_USER, COUNT_ORDER, COUNT_SHOW, COUNT_ARTIST, TOTAL_REVENUE
    if (request.getAttribute("TOTAL_REVENUE") == null) {
        request.setAttribute("TOTAL_REVENUE", BigDecimal.ZERO);
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - Dark Cinematic</title>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.min.css" rel="stylesheet">

        <style>
            :root {
                /* DARK THEME PALETTE */
                --bg-body: #0f111a;
                --bg-sidebar: #131722;
                --bg-card: #1e2433;
                --text-main: #ffffff;
                --text-muted: #94a3b8;
                --border-color: rgba(255,255,255,0.05);

                /* Accent Colors */
                --accent-blue: #3b82f6;
                --accent-green: #10b981;
                --accent-orange: #f59e0b;
                --accent-purple: #8b5cf6;

                --sidebar-width: 260px;
            }

            body {
                background-color: var(--bg-body);
                color: var(--text-main);
                font-family: 'Inter', sans-serif;
                overflow-x: hidden;
            }

            /* --- SIDEBAR --- */
            #sidebar-wrapper {
                width: var(--sidebar-width);
                height: 100vh;
                position: fixed;
                top: 0;
                left: 0;
                background-color: var(--bg-sidebar);
                border-right: 1px solid var(--border-color);
                z-index: 1000;
                overflow-y: auto;
                transition: margin .25s ease-out;
            }

            #sidebar-wrapper::-webkit-scrollbar {
                width: 5px;
            }
            #sidebar-wrapper::-webkit-scrollbar-thumb {
                background: #334155;
                border-radius: 10px;
            }

            .sidebar-brand {
                padding: 1.5rem;
                font-size: 1.25rem;
                font-weight: 700;
                color: white;
                border-bottom: 1px solid var(--border-color);
                display: flex;
                align-items: center;
            }

            .list-group-item {
                background: transparent;
                color: var(--text-muted);
                border: none;
                padding: 0.85rem 1.5rem;
                font-weight: 500;
                transition: all 0.2s;
                display: flex;
                align-items: center;
            }
            .list-group-item i {
                width: 25px;
                margin-right: 10px;
                text-align: center;
            }

            .list-group-item:hover, .list-group-item.active {
                color: white;
                background: rgba(59, 130, 246, 0.1);
                border-left: 3px solid var(--accent-blue);
            }

            .sidebar-heading {
                font-size: 0.75rem;
                text-transform: uppercase;
                letter-spacing: 1px;
                color: #64748b;
                padding: 1.5rem 1.5rem 0.5rem;
                font-weight: 700;
            }

            /* --- MAIN CONTENT --- */
            #page-content-wrapper {
                margin-left: var(--sidebar-width);
                width: calc(100% - var(--sidebar-width));
                transition: margin .25s ease-out;
                min-height: 100vh;
            }

            .top-navbar {
                background-color: rgba(19, 23, 34, 0.8);
                backdrop-filter: blur(10px);
                border-bottom: 1px solid var(--border-color);
                padding: 1rem 2rem;
                position: sticky;
                top: 0;
                z-index: 999;
            }

            /* --- CARDS --- */
            .card-custom {
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 16px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            }

            .stat-card {
                padding: 1.5rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
                transition: transform 0.2s;
            }
            .stat-card:hover {
                transform: translateY(-5px);
            }

            .stat-title {
                font-size: 0.85rem;
                color: var(--text-muted);
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 0.5rem;
            }
            .stat-value {
                font-size: 1.75rem;
                font-weight: 700;
                color: white;
            }

            .stat-icon-box {
                width: 50px;
                height: 50px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
            }
            .icon-blue {
                background: rgba(59, 130, 246, 0.2);
                color: var(--accent-blue);
            }
            .icon-green {
                background: rgba(16, 185, 129, 0.2);
                color: var(--accent-green);
            }
            .icon-orange {
                background: rgba(245, 158, 11, 0.2);
                color: var(--accent-orange);
            }
            .icon-purple {
                background: rgba(139, 92, 246, 0.2);
                color: var(--accent-purple);
            }

            /* --- WIDGETS --- */
            .widget-header {
                padding: 1.25rem 1.5rem;
                border-bottom: 1px solid var(--border-color);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .widget-title {
                margin: 0;
                font-size: 1rem;
                font-weight: 600;
                color: white;
            }

            .list-item {
                padding: 1rem 1.5rem;
                border-bottom: 1px solid var(--border-color);
                display: flex;
                align-items: center;
                transition: background 0.2s;
            }
            .list-item:hover {
                background-color: rgba(255,255,255,0.02);
            }
            .avatar-circle {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: #334155;
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.85rem;
                font-weight: bold;
                margin-right: 15px;
            }

            /* --- TABLE --- */
            .table-dark-custom {
                --bs-table-bg: transparent;
                --bs-table-color: var(--text-muted);
                --bs-table-border-color: var(--border-color);
            }
            .table-dark-custom th {
                color: white;
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.8rem;
                border-bottom-width: 1px;
            }
            .table-dark-custom td {
                vertical-align: middle;
                color: #e2e8f0;
            }

            /* Mobile Toggle */
            body.sidebar-toggled #sidebar-wrapper {
                margin-left: -260px;
            }
            body.sidebar-toggled #page-content-wrapper {
                margin-left: 0;
                width: 100%;
            }

            @media (max-width: 768px) {
                #sidebar-wrapper {
                    margin-left: -260px;
                }
                #page-content-wrapper {
                    margin-left: 0;
                    width: 100%;
                }
                body.sidebar-toggled #sidebar-wrapper {
                    margin-left: 0;
                }
            }
        </style>
    </head>
    <body>

        <div class="d-flex" id="wrapper">
            <div id="sidebar-wrapper">
                <div class="sidebar-brand">
                    <i class="fas fa-film text-primary me-2"></i> THEATER ADMIN
                </div>

                <div class="list-group list-group-flush mt-2">
                    <a href="<%=contextPath%>/admin/dashboard" class="list-group-item list-group-item-action active">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>

                    <div class="sidebar-heading">Quản lý Show</div>
                    <a href="<%=contextPath%>/admin/show" class="list-group-item list-group-item-action">
                        <i class="fas fa-theater-masks"></i> Danh sách Show
                    </a>
                    <a href="<%=contextPath%>/admin/artist" class="list-group-item list-group-item-action">
                        <i class="fas fa-microphone-alt"></i> Nghệ sĩ
                    </a>
                    <a href="<%=contextPath%>/admin/schedule" class="list-group-item list-group-item-action">
                        <i class="fas fa-calendar-alt"></i> Lịch diễn
                    </a>
                    <a href="<%=contextPath%>/admin/seats" class="list-group-item list-group-item-action">
                        <i class="fas fa-chair"></i> Sơ đồ ghế
                    </a>

                    <!-- ✅ THÊM MỚI: Menu Sự kiện -->
                    <div class="sidebar-heading">Sự kiện & Giao lưu</div>
                    <a href="<%=contextPath%>/admin/events" class="list-group-item list-group-item-action">
                        <i class="fas fa-calendar-star"></i> Quản lý Sự kiện
                    </a>

                    <div class="sidebar-heading">Kinh Doanh</div>
                    <a href="<%=contextPath%>/admin/revenue" class="list-group-item list-group-item-action">
                        <i class="fas fa-chart-line"></i> Thống kê doanh thu
                    </a>
                    <a href="<%=contextPath%>/admin/promotions" class="list-group-item list-group-item-action">
                        <i class="fas fa-tags"></i> Khuyến mãi
                    </a>
                    <a href="<%=contextPath%>/admin/tickets" class="list-group-item list-group-item-action">
                        <i class="fas fa-ticket-alt"></i> Vé bán
                    </a>
                    <a href="<%=contextPath%>/admin/ticket-checkin" class="list-group-item list-group-item-action text-warning fw-bold">
                        <i class="fas fa-qrcode"></i> Check-in Vé
                    </a>
                    <a href="<%=contextPath%>/admin/orders" class="list-group-item list-group-item-action">
                        <i class="fas fa-shopping-cart"></i> Đơn hàng <span class="badge bg-danger ms-auto">New</span>
                    </a>

                    <div class="sidebar-heading">Hệ Thống & Nội Dung</div>
                    <a href="<%=contextPath%>/admin/user" class="list-group-item list-group-item-action">
                        <i class="fas fa-users"></i> Thành viên
                    </a>
                    <a href="<%=contextPath%>/admin/news" class="list-group-item list-group-item-action">
                        <i class="fas fa-newspaper"></i> Tin tức
                    </a>
                    <a href="<%=contextPath%>/admin/recruitment" class="list-group-item list-group-item-action">
                        <i class="fas fa-briefcase"></i> Tuyển dụng
                    </a>
                    <!-- ✅ SỬA: Icon Đơn tuyển từ fa-briefcase → fa-file-alt -->
                    <a href="<%=contextPath%>/admin/applyjob" class="list-group-item list-group-item-action">
                        <i class="fas fa-file-alt"></i> Đơn tuyển
                    </a>
                    <a href="<%=contextPath%>/admin/feedback" class="list-group-item list-group-item-action">
                        <i class="fas fa-comment-dots"></i> Feedback
                    </a>
                </div>
            </div>

            <div id="page-content-wrapper">
                <nav class="top-navbar d-flex justify-content-between align-items-center">
                    <button class="btn btn-outline-secondary border-0 text-white" id="menu-toggle">
                        <i class="fas fa-bars fa-lg"></i>
                    </button>
                    <div class="d-flex align-items-center gap-3">
                        <div class="dropdown">
                            <a class="text-white text-decoration-none dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                <span class="me-2 d-none d-lg-inline small text-muted">Xin chào,</span>
                                <span class="fw-bold"><%= fullName%></span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end dropdown-menu-dark shadow">
                                <li><a class="dropdown-item" href="#">Hồ sơ</a></li>
                                <li><a class="dropdown-item" href="#">Cài đặt</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="<%=contextPath%>/logout">Đăng xuất</a></li>
                            </ul>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid px-4 py-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold text-white mb-0">Tổng quan hệ thống</h3>
                        <button class="btn btn-primary btn-sm"><i class="fas fa-download me-1"></i> Xuất báo cáo</button>
                    </div>

                    <div class="row g-4 mb-4">
                        <div class="col-xl-3 col-md-6">
                            <div class="card-custom stat-card">
                                <div>
                                    <div class="stat-title">Tổng Doanh thu</div>
                                    <div class="stat-value text-success">
                                        <fmt:formatNumber value="${TOTAL_REVENUE}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                    </div>
                                </div>
                                <div class="stat-icon-box icon-blue"><i class="fas fa-dollar-sign"></i></div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6">
                            <div class="card-custom stat-card">
                                <div>
                                    <div class="stat-title">Thành viên</div>
                                    <div class="stat-value">${COUNT_USER}</div>
                                </div>
                                <div class="stat-icon-box icon-green"><i class="fas fa-users"></i></div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6">
                            <div class="card-custom stat-card">
                                <div>
                                    <div class="stat-title">Show hiện có</div>
                                    <div class="stat-value">${COUNT_SHOW}</div>
                                </div>
                                <div class="stat-icon-box icon-orange"><i class="fas fa-theater-masks"></i></div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6">
                            <div class="card-custom stat-card">
                                <div>
                                    <div class="stat-title">Tổng Đơn hàng</div>
                                    <div class="stat-value">${COUNT_ORDER}</div>
                                </div>
                                <div class="stat-icon-box icon-purple"><i class="fas fa-receipt"></i></div>
                            </div>
                        </div>
                    </div>

                    <div class="row g-4 mb-4">
                        <div class="col-lg-8">
                            <div class="card-custom h-100">
                                <div class="widget-header">
                                    <h5 class="widget-title">Biểu đồ doanh thu (Minh họa)</h5>
                                </div>
                                <div class="card-body">
                                    <canvas id="revenueChart" style="height: 300px; width: 100%;"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="card-custom h-100">
                                <div class="widget-header">
                                    <h5 class="widget-title">Nguồn vé bán (Minh họa)</h5>
                                </div>
                                <div class="card-body d-flex justify-content-center align-items-center">
                                    <canvas id="pieChart" style="max-height: 250px;"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <div class="card-custom h-100">
                                <div class="widget-header">
                                    <h5 class="widget-title"><i class="fas fa-comments text-warning me-2"></i> Phản hồi mới nhất</h5>
                                    <a href="#" class="text-muted small text-decoration-none">Xem tất cả</a>
                                </div>
                                <div class="list-group list-group-flush">
                                    <div class="list-item">
                                        <div class="avatar-circle bg-primary">A</div>
                                        <div class="flex-grow-1">
                                            <div class="d-flex justify-content-between">
                                                <span class="text-white fw-bold">Nguyễn Văn A</span>
                                                <span class="text-warning small"><i class="fas fa-star"></i> 5.0</span>
                                            </div>
                                            <small class="text-muted">Rạp rất đẹp, âm thanh sống động...</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card-custom h-100">
                                <div class="widget-header">
                                    <h5 class="widget-title"><i class="fas fa-bell text-info me-2"></i> Tin tức & Tuyển dụng</h5>
                                    <button class="btn btn-sm btn-outline-light py-0">+ Tạo mới</button>
                                </div>
                                <div class="list-group list-group-flush">
                                    <div class="list-item">
                                        <div class="stat-icon-box" style="width: 40px; height: 40px; background: rgba(255,255,255,0.05); font-size: 1rem; margin-right: 15px;">
                                            <i class="fas fa-briefcase text-info"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="text-white fw-bold">Tuyển dụng NV Soát vé</div>
                                            <small class="text-muted">Hạn nộp: 30/12/2025 • <span class="text-warning">3 hồ sơ chờ duyệt</span></small>
                                        </div>
                                        <span class="badge bg-warning text-dark">Pending</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card-custom">
                        <div class="widget-header">
                            <h5 class="widget-title">Top Show Bán Chạy (Minh họa)</h5>
                            <a href="<%=contextPath%>/admin/show" class="btn btn-sm btn-outline-primary rounded-pill px-3">Xem tất cả</a>
                        </div>
                        <div class="table-responsive p-3">
                            <table class="table table-dark-custom mb-0">
                                <thead>
                                    <tr>
                                        <th>Tên Show</th>
                                        <th>Địa điểm</th>
                                        <th>Tiến độ bán</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td colspan="4" class="text-center py-3 text-muted">
                                            Dữ liệu thật đang được cập nhật từ Artist: <b>${COUNT_ARTIST}</b> người
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

        <script>
            // 1. Sidebar Toggle
            document.getElementById("menu-toggle").addEventListener("click", function (e) {
                e.preventDefault();
                document.body.classList.toggle("sidebar-toggled");
            });

            // 2. Chart Config (Giữ nguyên)
            Chart.defaults.color = '#94a3b8';
            Chart.defaults.borderColor = 'rgba(255,255,255,0.05)';

            const ctx = document.getElementById('revenueChart');
            if (ctx) {
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: ["T1", "T2", "T3", "T4", "T5", "T6", "T7"],
                        datasets: [{
                                label: 'Doanh thu (Triệu VNĐ)',
                                data: [50, 80, 60, 120, 90, 150, 180],
                                borderColor: '#3b82f6',
                                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                                tension: 0.4,
                                fill: true,
                                pointBackgroundColor: '#3b82f6'
                            }]
                    },
                    options: {
                        maintainAspectRatio: false,
                        plugins: {legend: {display: false}},
                        scales: {
                            y: {beginAtZero: true, grid: {color: 'rgba(255,255,255,0.05)'}},
                            x: {grid: {display: false}}
                        }
                    }
                });
            }

            const pieCtx = document.getElementById('pieChart');
            if (pieCtx) {
                new Chart(pieCtx, {
                    type: 'doughnut',
                    data: {
                        labels: ["VIP", "Thường", "Early Bird"],
                        datasets: [{
                                data: [55, 30, 15],
                                backgroundColor: ['#3b82f6', '#10b981', '#f59e0b'],
                                borderWidth: 0
                            }]
                    },
                    options: {
                        maintainAspectRatio: false,
                        cutout: '75%',
                        plugins: {
                            legend: {position: 'bottom', labels: {usePointStyle: true, padding: 20}}
                        }
                    }
                });
            }
        </script>

    </body>
</html>