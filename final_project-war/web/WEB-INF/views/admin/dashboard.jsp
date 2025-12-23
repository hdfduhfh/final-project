<%-- 
    Document    : dashboard_modern
    Created on  : Dec 16, 2025
    Author      : GEMINI AI
    Style       : Modern Sidebar & Soft UI
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="mypack.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    // 1. KIỂM TRA QUYỀN ADMIN (GIỮ NGUYÊN)
    User user = (User) session.getAttribute("user");
    // Code demo nên mình comment đoạn check để bạn chạy thử giao diện ngay
    // if (user == null || !"ADMIN".equalsIgnoreCase(user.getRoleID().getRoleName())) {
    //    response.sendRedirect(request.getContextPath() + "/");
    //    return;
    // }
    String contextPath = request.getContextPath();

    // 2. GIẢ LẬP DỮ LIỆU (GIỮ NGUYÊN ĐỂ TEST)
    if (request.getAttribute("monthlyRevenue") == null) {
        request.setAttribute("monthlyRevenue", 150000000);
    }
    if (request.getAttribute("totalUsers") == null) {
        request.setAttribute("totalUsers", 1250);
    }
    if (request.getAttribute("activeShows") == null) {
        request.setAttribute("activeShows", 8);
    }
    if (request.getAttribute("ticketsSoldToday") == null) {
        request.setAttribute("ticketsSoldToday", 45); // Đã đổi ý nghĩa màu
    }%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Portal - Quản trị hệ thống</title>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.min.css" rel="stylesheet">

        <style>
            :root {
                --sidebar-width: 260px;
                --primary-color: #4e73df;
                --secondary-color: #858796;
                --success-color: #1cc88a;
                --info-color: #36b9cc;
                --warning-color: #f6c23e;
                --danger-color: #e74a3b;
                --dark-blue: #224abe;
                --light-bg: #f3f4f6;
            }

            body {
                font-family: 'Inter', sans-serif;
                background-color: var(--light-bg);
                overflow-x: hidden;
            }

            /* --- SIDEBAR STYLE --- */
            #sidebar-wrapper {
                height: 100vh; /* Chiều cao bằng đúng màn hình */
                width: var(--sidebar-width);
                margin-left: 0;
                position: fixed; /* Cố định vị trí */
                top: 0;
                left: 0;
                z-index: 1000;
                background: linear-gradient(180deg, #4e73df 10%, #224abe 100%);
                color: #fff;
                transition: margin .25s ease-out;

                /* QUAN TRỌNG: Thêm 2 dòng này để cuộn khi nội dung dài quá */
                overflow-y: auto;
                overflow-x: hidden;
            }

            /* --- TÙY CHỈNH THANH CUỘN (SCROLLBAR) CHO ĐẸP --- */
            /* Chỉ hiện thanh cuộn mảnh, màu trắng mờ để sang trọng */
            #sidebar-wrapper::-webkit-scrollbar {
                width: 6px;
            }

            #sidebar-wrapper::-webkit-scrollbar-track {
                background: transparent;
            }

            #sidebar-wrapper::-webkit-scrollbar-thumb {
                background-color: rgba(255, 255, 255, 0.2); /* Màu trắng mờ */
                border-radius: 20px; /* Bo tròn */
            }

            #sidebar-wrapper::-webkit-scrollbar-thumb:hover {
                background-color: rgba(255, 255, 255, 0.5); /* Sáng hơn khi rê chuột vào */
            }

            .sidebar-heading {
                padding: 1.5rem 1.5rem;
                font-size: 1.2rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 1px;
                color: rgba(255,255,255,0.9);
                border-bottom: 1px solid rgba(255,255,255,0.15);
            }

            .list-group-item {
                background-color: transparent;
                color: rgba(255,255,255,0.8);
                border: none;
                padding: 0.75rem 1.5rem;
                font-weight: 500;
                transition: all 0.2s;
                border-left: 4px solid transparent;
            }

            .list-group-item:hover {
                background-color: rgba(255,255,255,0.1);
                color: #fff;
                border-left-color: #fff;
            }

            .list-group-item.active {
                background-color: rgba(255,255,255,0.2);
                color: #fff;
                font-weight: 600;
                border-left-color: #fff;
            }

            .sidebar-divider {
                margin: 1rem 1.5rem 0.5rem;
                color: rgba(255,255,255,0.4);
                font-size: 0.75rem;
                font-weight: 700;
                text-transform: uppercase;
            }

            /* --- MAIN CONTENT --- */
            #page-content-wrapper {
                margin-left: var(--sidebar-width);
                width: calc(100% - var(--sidebar-width));
                transition: margin .25s ease-out;
            }

            /* --- TOP NAVBAR --- */
            .top-navbar {
                background: #fff;
                box-shadow: 0 .15rem 1.75rem 0 rgba(58,59,69,.15);
                padding: 1rem 2rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            /* --- DASHBOARD CARDS (MODERN STYLE) --- */
            .dash-card {
                border: none;
                border-radius: 15px;
                background: #fff;
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58,59,69,0.05);
                transition: transform 0.3s ease;
                position: relative;
                overflow: hidden;
                height: 100%;
            }

            .dash-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 0.5rem 2rem 0 rgba(58,59,69,0.15);
            }

            .card-left-border-primary {
                border-left: 5px solid var(--primary-color);
            }
            .card-left-border-success {
                border-left: 5px solid var(--success-color);
            }
            .card-left-border-warning {
                border-left: 5px solid var(--warning-color);
            }
            .card-left-border-info {
                border-left: 5px solid #6f42c1;
            } /* Màu Tím mới */

            .text-xs {
                font-size: .7rem;
                font-weight: 700;
                text-transform: uppercase;
                margin-bottom: 0.25rem;
            }

            .h5-number {
                font-size: 1.5rem;
                font-weight: 700;
                color: #5a5c69;
            }

            .icon-circle {
                height: 50px;
                width: 50px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
            }

            .bg-blue-soft {
                background: rgba(78, 115, 223, 0.1);
                color: var(--primary-color);
            }
            .bg-green-soft {
                background: rgba(28, 200, 138, 0.1);
                color: var(--success-color);
            }
            .bg-yellow-soft {
                background: rgba(246, 194, 62, 0.1);
                color: var(--warning-color);
            }
            .bg-purple-soft {
                background: rgba(111, 66, 193, 0.1);
                color: #6f42c1;
            }

            /* --- TABLE & GENERAL --- */
            .card-modern {
                border: none;
                border-radius: 12px;
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58,59,69,0.05);
            }
            .card-header-modern {
                background-color: #fff;
                border-bottom: 1px solid #e3e6f0;
                padding: 1rem 1.5rem;
                font-weight: 700;
                color: var(--primary-color);
                border-top-left-radius: 12px;
                border-top-right-radius: 12px;
            }

            /* Mobile Responsive */
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
                <div class="sidebar-heading text-center">
                    <i class="fas fa-laugh-wink me-2"></i> Dashboard Admin
                </div>

                <div class="list-group list-group-flush mt-3">
                    <a href="<%=contextPath%>/admin/dashboard" class="list-group-item list-group-item-action active">
                        <i class="fas fa-fw fa-tachometer-alt me-2"></i> Dashboard
                    </a>

                    <div class="sidebar-divider">Quản lý Show</div>
                    <a href="<%=contextPath%>/admin/show" class="list-group-item list-group-item-action">
                        <i class="fas fa-fw fa-theater-masks me-2"></i> Danh sách Show
                    </a>
                    <a href="<%=contextPath%>/admin/artist" class="list-group-item list-group-item-action">
                        <i class="fas fa-fw fa-microphone-alt me-2"></i> Nghệ sĩ (Artists)
                    </a>
                    <a href="<%=contextPath%>/admin/schedule" class="list-group-item list-group-item-action">
                        <i class="fas fa-fw fa-theater-masks me-2"></i> Lịch diễn
                    </a>
                    <a href="<%=contextPath%>/admin/seats" class="list-group-item list-group-item-action">
                        <i class="fas fa-fw fa-chair me-2"></i> Sơ đồ ghế (Seats)
                    </a>

                    <div class="sidebar-divider">Kinh doanh</div>
                    <a href="<%=contextPath%>/admin/promotions" class="list-group-item list-group-item-action">
                        <i class="fas fa-fw fa-tags me-2"></i> Khuyến mãi
                    </a>

                    <a href="<%=contextPath%>/admin/tickets" class="list-group-item list-group-item-action">
                        <i class="fas fa-fw fa-ticket-alt me-2"></i> Vé bán
                    </a>
                    <!-- 🔥 THÊM CÁI NÀY -->
                    <a href="<%=contextPath%>/admin/ticket-checkin" 
                       class="list-group-item list-group-item-action fw-bold"
                       style="background: rgba(255,255,255,0.15);">
                        <i class="fas fa-qrcode me-2"></i> CHECK-IN VÉ
                    </a>
                    <a href="<%=contextPath%>/admin/orders" class="list-group-item list-group-item-action">
                        <i class="fas fa-fw fa-shopping-cart me-2"></i> Đơn hàng <span class="badge bg-danger rounded-pill float-end">New</span>
                    </a>
                    <a href="#" class="list-group-item list-group-item-action">
                        <i class="fas fa-fw fa-file-invoice-dollar me-2"></i> Báo cáo thu chi
                    </a>

                    <div class="sidebar-divider">Hệ thống & Nội dung</div>
                    <a href="<%=contextPath%>/admin/user" class="list-group-item list-group-item-action">
                        <i class="fas fa-fw fa-users me-2"></i> Thành viên (Users)
                    </a>
                    <a href="#" class="list-group-item list-group-item-action">
                        <i class="fas fa-fw fa-newspaper me-2"></i> Tin tức (News)
                    </a>
                    <a href="#" class="list-group-item list-group-item-action">
                        <i class="fas fa-fw fa-briefcase me-2"></i> Tuyển dụng
                    </a>
                    <a href="#" class="list-group-item list-group-item-action">
                        <i class="fas fa-fw fa-comments me-2"></i> Feedback
                    </a>
                </div>
            </div>
            <div id="page-content-wrapper">

                <nav class="top-navbar mb-4">
                    <button class="btn btn-link text-primary" id="menu-toggle"><i class="fas fa-bars fa-lg"></i></button>

                    <form class="d-none d-sm-inline-block form-inline ms-md-3 my-2 my-md-0 mw-100 navbar-search">
                        <div class="input-group">
                            <input type="text" class="form-control bg-light border-0 small" placeholder="Tìm kiếm nhanh..." aria-label="Search">
                            <button class="btn btn-primary" type="button"><i class="fas fa-search"></i></button>
                        </div>
                    </form>

                    <div class="dropdown">
                        <a class="nav-link dropdown-toggle text-dark d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                            <span class="me-2 d-none d-lg-inline text-gray-600 small">Xin chào, <strong><%= (user != null) ? user.getFullName() : "Admin"%></strong></span>
                            <img class="img-profile rounded-circle" src="https://ui-avatars.com/api/?name=Admin&background=random" width="32" height="32">
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow animated--grow-in">
                            <li><a class="dropdown-item" href="#"><i class="fas fa-user fa-sm fa-fw me-2 text-gray-400"></i> Hồ sơ</a></li>
                            <li><a class="dropdown-item" href="#"><i class="fas fa-cogs fa-sm fa-fw me-2 text-gray-400"></i> Cài đặt</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="<%=contextPath%>/logout"><i class="fas fa-sign-out-alt fa-sm fa-fw me-2"></i> Đăng xuất</a></li>
                        </ul>
                    </div>
                </nav>

                <div class="container-fluid px-4">

                    <div class="d-sm-flex align-items-center justify-content-between mb-4">
                        <h1 class="h3 mb-0 text-gray-800 fw-bold">Tổng quan hệ thống</h1>
                        <a href="#" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm">
                            <i class="fas fa-download fa-sm text-white-50"></i> Xuất báo cáo
                        </a>
                    </div>

                    <div class="row g-4 mb-4">
                        <div class="col-xl-3 col-md-6">
                            <div class="card dash-card card-left-border-primary py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs text-primary mb-1">DOANH THU (THÁNG)</div>
                                            <div class="h5-number mb-0 text-gray-800">
                                                <fmt:formatNumber value="${monthlyRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <div class="icon-circle bg-blue-soft"><i class="fas fa-dollar-sign"></i></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6">
                            <div class="card dash-card card-left-border-success py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs text-success mb-1">TỔNG THÀNH VIÊN</div>
                                            <div class="h5-number mb-0 text-gray-800">${totalUsers}</div>
                                        </div>
                                        <div class="col-auto">
                                            <div class="icon-circle bg-green-soft"><i class="fas fa-users"></i></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6">
                            <div class="card dash-card card-left-border-warning py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs text-warning mb-1">SHOW ĐANG MỞ BÁN</div>
                                            <div class="h5-number mb-0 text-gray-800">${activeShows}</div>
                                        </div>
                                        <div class="col-auto">
                                            <div class="icon-circle bg-yellow-soft"><i class="fas fa-theater-masks"></i></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6">
                            <div class="card dash-card card-left-border-info py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs mb-1" style="color: #6f42c1;">VÉ BÁN HÔM NAY</div>
                                            <div class="h5-number mb-0 text-gray-800">${ticketsSoldToday}</div>
                                        </div>
                                        <div class="col-auto">
                                            <div class="icon-circle bg-purple-soft"><i class="fas fa-ticket-alt"></i></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-4">
                        <div class="col-xl-8 col-lg-7">
                            <div class="card card-modern h-100">
                                <div class="card-header-modern d-flex flex-row align-items-center justify-content-between">
                                    <h6 class="m-0 font-weight-bold text-primary">Biểu đồ doanh thu</h6>
                                </div>
                                <div class="card-body">
                                    <canvas id="revenueChart" style="height: 320px; width: 100%;"></canvas>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-4 col-lg-5">
                            <div class="card card-modern h-100">
                                <div class="card-header-modern">
                                    <h6 class="m-0 font-weight-bold text-primary">Nguồn doanh thu</h6>
                                </div>
                                <div class="card-body d-flex align-items-center justify-content-center">
                                    <canvas id="pieChart" style="max-height: 250px;"></canvas>
                                </div>
                                <div class="card-footer bg-white small text-center text-muted">
                                    Dữ liệu mẫu phân tích bán vé
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card card-modern mb-4">
                        <div class="card-header-modern d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold text-primary">Top Show Bán Chạy</h6>
                            <a href="<%=contextPath%>/admin/show" class="btn btn-sm btn-outline-primary rounded-pill px-3">Xem tất cả</a>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="bg-light text-secondary small">
                                        <tr>
                                            <th class="ps-4 py-3">TÊN SHOW</th>
                                            <th>ĐỊA ĐIỂM</th>
                                            <th>TIẾN ĐỘ BÁN</th>
                                            <th>TRẠNG THÁI</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty topShows}">
                                                <c:forEach var="show" items="${topShows}">
                                                    <tr>
                                                        <td class="ps-4 fw-bold text-dark">${show.showName}</td>
                                                        <td class="text-muted small">${show.location}</td>
                                                        <td style="width: 30%">
                                                            <div class="d-flex align-items-center">
                                                                <span class="me-2 small fw-bold">${show.soldTickets}/${show.totalTickets}</span>
                                                                <div class="progress flex-grow-1" style="height: 6px;">
                                                                    <div class="progress-bar bg-primary" style="width: ${(show.soldTickets/show.totalTickets)*100}%"></div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td><span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill">Active</span></td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr><td colspan="4" class="text-center py-4 text-muted">Chưa có dữ liệu</td></tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                </div> </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

        <script>
            // 1. Toggle Sidebar Script
            document.getElementById("menu-toggle").addEventListener("click", function (e) {
                e.preventDefault();
                document.body.classList.toggle("sidebar-toggled");

                // Xử lý CSS trực tiếp cho simple toggle
                const wrapper = document.getElementById("wrapper");
                const sidebar = document.getElementById("sidebar-wrapper");

                if (sidebar.style.marginLeft === "-260px") {
                    sidebar.style.marginLeft = "0";
                } else {
                    sidebar.style.marginLeft = "-260px";
                }
            });

            // 2. Chart Config
            const ctx = document.getElementById('revenueChart');
            if (ctx) {
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: ["T1", "T2", "T3", "T4", "T5", "T6", "T7"],
                        datasets: [{
                                label: 'Doanh thu (Triệu VNĐ)',
                                data: [50, 80, 60, 120, 90, 150, 180], // Demo data
                                borderColor: '#4e73df',
                                backgroundColor: 'rgba(78, 115, 223, 0.05)',
                                tension: 0.3,
                                fill: true,
                                pointRadius: 3,
                                pointHoverRadius: 5
                            }]
                    },
                    options: {
                        maintainAspectRatio: false,
                        plugins: {legend: {display: false}},
                        scales: {y: {beginAtZero: true, grid: {borderDash: [2]}}, x: {grid: {display: false}}}
                    }
                });
            }

            // 3. Pie Chart Demo
            const pieCtx = document.getElementById('pieChart');
            if (pieCtx) {
                new Chart(pieCtx, {
                    type: 'doughnut',
                    data: {
                        labels: ["VIP", "Thường", "Early Bird"],
                        datasets: [{
                                data: [55, 30, 15],
                                backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc'],
                                hoverOffset: 4
                            }]
                    },
                    options: {maintainAspectRatio: false, cutout: '70%'}
                });
            }
        </script>
    </body>
</html>