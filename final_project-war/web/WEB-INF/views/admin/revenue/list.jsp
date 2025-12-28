<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- THIẾT LẬP LOCALE VIỆT NAM --%>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thống kê doanh thu - Admin Dashboard</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <style>
            :root {
                --bg-dark: #0f172a;
                --panel-dark: #1e293b;
                --sidebar-dark: #111827;
                --text-main: #f8fafc;
                --text-muted: #94a3b8;
                --accent: #3b82f6;
                --border-color: #334155;
            }

            body {
                background-color: var(--bg-dark);
                color: var(--text-main);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .admin-wrap {
                display: flex;
                min-height: 100vh;
            }
            .sidebar {
                width: 260px;
                background-color: var(--sidebar-dark);
                border-right: 1px solid var(--border-color);
                padding: 20px;
                display: flex;
                flex-direction: column;
                flex-shrink: 0;
            }
            .brand {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 30px;
            }
            .logo {
                width: 40px;
                height: 40px;
                background: linear-gradient(45deg, #3b82f6, #8b5cf6);
                border-radius: 10px;
                display: grid;
                place-items: center;
                font-size: 1.2rem;
                color: white;
            }
            .brand .title {
                font-weight: 700;
                font-size: 1.1rem;
                line-height: 1.2;
            }
            .brand small {
                color: var(--text-muted);
                font-size: 0.85rem;
            }

            .content {
                flex-grow: 1;
                padding: 30px;
                overflow-y: auto;
            }

            .stat-card-box {
                border-radius: 16px;
                padding: 24px;
                color: #fff;
                height: 100%;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
                transition: transform 0.2s, box-shadow 0.2s;
                border: 1px solid rgba(255,255,255,0.1);
            }
            .stat-card-box:hover {
                transform: translateY(-5px);
                box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2);
            }

            .stat-icon {
                font-size: 2.5rem;
                opacity: 0.2;
                position: absolute;
                top: 20px;
                right: 20px;
            }
            .card-title-sm {
                font-size: 0.85rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                opacity: 0.9;
            }
            .card-value {
                font-size: 1.75rem;
                font-weight: 700;
                margin-top: 10px;
            }

            .bg-gradient-success {
                background: linear-gradient(135deg, #059669, #34d399);
            }
            .bg-gradient-primary {
                background: linear-gradient(135deg, #2563eb, #60a5fa);
            }
            .bg-gradient-danger {
                background: linear-gradient(135deg, #db2777, #f472b6);
            }
            .bg-gradient-warning {
                background: linear-gradient(135deg, #f59e0b, #fbbf24);
            }
            .bg-gradient-secondary {
                background: linear-gradient(135deg, #4b5563, #9ca3af);
            }
            .bg-gradient-info {
                background: linear-gradient(135deg, #0891b2, #22d3ee);
            }

            .panel-box {
                background-color: var(--panel-dark);
                border-radius: 16px;
                padding: 20px;
                border: 1px solid var(--border-color);
                margin-bottom: 24px;
            }
            .section-title {
                font-size: 1.1rem;
                font-weight: 700;
                color: var(--text-main);
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .table {
                --bs-table-color: var(--text-main);
                --bs-table-bg: transparent;
                --bs-table-border-color: var(--border-color);
                --bs-table-hover-color: #ffffff;
                --bs-table-hover-bg: rgba(255, 255, 255, 0.05);
                width: 100%;
                margin-bottom: 0;
            }

            .table > :not(caption) > * > * {
                color: var(--text-main) !important;
                background-color: transparent !important;
                border-bottom-width: 1px;
                vertical-align: middle;
                opacity: 1 !important;
            }

            .table thead th {
                color: #60a5fa !important;
                font-weight: 600;
                border-bottom: 2px solid rgba(255,255,255,0.1) !important;
            }

            .table-hover > tbody > tr:hover > * {
                background-color: rgba(255, 255, 255, 0.08) !important;
                color: #ffffff !important;
            }

            .btn-glass {
                background: rgba(255,255,255,0.05);
                border: 1px solid var(--border-color);
                color: var(--text-main);
                border-radius: 12px;
                padding: 10px 20px;
                transition: all 0.2s;
            }
            .btn-glass:hover {
                background: rgba(255,255,255,0.1);
                color: white;
                border-color: var(--text-muted);
            }
            .btn-refresh {
                background: white;
                color: #0f172a;
                border: none;
                font-weight: 600;
            }
            .btn-refresh:hover {
                background: #e2e8f0;
            }

            .topbar {
                margin-bottom: 30px;
                display: flex;
                justify-content: space-between;
                align-items: end;
            }
            .page-h h1 {
                font-size: 1.8rem;
                font-weight: 700;
                margin-bottom: 5px;
            }
            .crumb {
                color: var(--text-muted);
                font-size: 0.9rem;
            }

            /* ✅ BADGE CHO SỐ ÂM (VÉ HỦY) */
            .refund-badge {
                background: rgba(239, 68, 68, 0.2);
                color: #f87171;
                padding: 4px 10px;
                border-radius: 6px;
                font-weight: 600;
                font-size: 0.9rem;
            }

            .profit-badge {
                background: rgba(34, 197, 94, 0.2);
                color: #4ade80;
                padding: 4px 10px;
                border-radius: 6px;
                font-weight: 600;
                font-size: 0.9rem;
            }
        </style>
    </head>

    <body>
        <div class="admin-wrap">

            <aside class="sidebar">
                <div class="brand">
                    <div class="logo"><i class="fa-solid fa-masks-theater"></i></div>
                    <div>
                        <div class="title">Theater Admin</div>
                        <small>Quản lý rạp</small>
                    </div>
                </div>

                <hr style="border-color: var(--border-color); opacity: 0.5;">

                <div class="px-2">
                    <div class="text-uppercase mb-3" style="font-size:11px; color:var(--text-muted); font-weight:800; letter-spacing:1px;">
                        Quick actions
                    </div>
                    <div class="d-grid gap-3">
                        <a class="btn btn-glass text-start" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fa-solid fa-arrow-left me-2"></i> Về Dashboard
                        </a>
                        <a href="" class="btn btn-refresh text-start" style="border-radius:12px; padding: 10px 20px;">
                            <i class="fa-solid fa-rotate-right me-2"></i> Làm mới dữ liệu
                        </a>
                    </div>
                </div>
            </aside>

            <main class="content">

                <div class="topbar">
                    <div class="page-h">
                        <h1>Thống kê doanh thu</h1>
                        <div class="crumb">Admin / Statistics / Revenue</div>
                    </div>
                    <div class="d-none d-md-block text-muted">
                        <i class="fa-regular fa-clock me-1"></i> Dữ liệu cập nhật realtime
                    </div>
                </div>

                <%-- ✅ TÍNH TOÁN PHÍ HỦY & LỢI NHUẬN --%>
                <c:set var="cancellationFee" value="${totalRevenue + totalRefund - (totalRevenue)}" />
                <c:set var="actualProfit" value="${totalRevenue - totalDiscount}" />

                <div class="row g-4 mb-5">
                    <%-- TỔNG DOANH THU --%>
                    <div class="col-md-3">
                        <div class="stat-card-box bg-gradient-success position-relative overflow-hidden">
                            <i class="fa-solid fa-sack-dollar stat-icon"></i>
                            <div>
                                <div class="card-title-sm">Tổng doanh thu</div>
                                <div class="card-value">
                                    <fmt:formatNumber value="${totalRevenue}" pattern="#,###"/> đ
                                </div>
                                <small style="opacity: 0.8; font-size: 0.75rem;">Đã trừ tiền hoàn lại</small>
                            </div>
                        </div>
                    </div>

                    <%-- TỔNG TIỀN HOÀN LẠI --%>
                    <div class="col-md-3">
                        <div class="stat-card-box bg-gradient-danger position-relative overflow-hidden">
                            <i class="fa-solid fa-arrow-rotate-left stat-icon"></i>
                            <div>
                                <div class="card-title-sm">Tiền hoàn khách</div>
                                <div class="card-value">
                                    <fmt:formatNumber value="${totalRefund}" pattern="#,###"/> đ
                                </div>
                                <small style="opacity: 0.8; font-size: 0.75rem;">Từ vé bị hủy</small>
                            </div>
                        </div>
                    </div>

                    <%-- PHÍ HỦY VÉ (LỢI NHUẬN TỪ HỦY) --%>
                    <div class="col-md-3">
                        <div class="stat-card-box bg-gradient-warning position-relative overflow-hidden">
                            <i class="fa-solid fa-percent stat-icon"></i>
                            <div>
                                <div class="card-title-sm">Phí hủy vé (30%)</div>
                                <div class="card-value">
                                    <fmt:formatNumber value="${totalRefund * 0.30 / 0.70}" pattern="#,###"/> đ
                                </div>
                                <small style="opacity: 0.8; font-size: 0.75rem;">Giữ lại khi hủy vé</small>
                            </div>
                        </div>
                    </div>

                    <%-- TỔNG KHUYẾN MÃI --%>
                    <div class="col-md-3">
                        <div class="stat-card-box bg-gradient-primary position-relative overflow-hidden">
                            <i class="fa-solid fa-tags stat-icon"></i>
                            <div>
                                <div class="card-title-sm">Tổng khuyến mãi</div>
                                <div class="card-value">
                                    <fmt:formatNumber value="${totalDiscount}" pattern="#,###"/> đ
                                </div>
                                <small style="opacity: 0.8; font-size: 0.75rem;">Giảm giá đã áp dụng</small>
                            </div>
                        </div>
                    </div>

                    <%-- ĐƠN BỊ HỦY --%>
                    <div class="col-md-3">
                        <div class="stat-card-box bg-gradient-secondary position-relative overflow-hidden">
                            <i class="fa-solid fa-ban stat-icon"></i>
                            <div>
                                <div class="card-title-sm">Đơn bị hủy</div>
                                <div class="card-value">
                                    ${totalCancelledOrder} <small class="fs-6 fw-normal">đơn</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- LỢI NHUẬN THỰC --%>
                    <div class="col-md-3">
                        <div class="stat-card-box bg-gradient-info position-relative overflow-hidden">
                            <i class="fa-solid fa-chart-line stat-icon"></i>
                            <div>
                                <div class="card-title-sm">Lợi nhuận thực</div>
                                <div class="card-value">
                                    <fmt:formatNumber value="${actualProfit}" pattern="#,###"/> đ
                                </div>
                                <small style="opacity: 0.8; font-size: 0.75rem;">Doanh thu - Khuyến mãi</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-8 mb-4">
                        <div class="panel-box h-100">
                            <div class="section-title">
                                <i class="fa-solid fa-chart-line text-info"></i> Biểu đồ doanh thu (7 ngày gần nhất)
                            </div>
                            <div style="height: 300px; width: 100%;">
                                <canvas id="revenueChart"></canvas>
                            </div>

                            <c:if test="${empty revenueByDate}">
                                <div class="d-flex flex-column align-items-center justify-content-center h-100 text-muted">
                                    <i class="fa-regular fa-folder-open fa-2x mb-3"></i>
                                    <span>Chưa có dữ liệu để hiển thị biểu đồ</span>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <%-- ✅ CHI TIẾT THEO NGÀY (CÓ VÉ HỦY) --%>
                    <div class="col-lg-4 mb-4">
                        <div class="panel-box h-100">
                            <div class="section-title">
                                <i class="fa-regular fa-calendar-days text-warning"></i> Chi tiết theo ngày
                            </div>
                            <div class="table-responsive" style="max-height: 400px; overflow-y: auto;">
                                <table class="table table-hover mb-0" style="font-size: 0.9rem;">
                                    <thead>
                                        <tr>
                                            <th>Ngày</th>
                                            <th class="text-end">Thu</th>
                                            <th class="text-end">Hoàn</th>
                                            <th class="text-end">Thực</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${revenueByDate}" var="row">
                                            <tr>
                                                <td>
                                                    <i class="fa-regular fa-calendar me-2 text-muted"></i>
                                                    <span class="fw-bold"><fmt:formatDate value="${row[0]}" pattern="dd/MM"/></span>
                                                </td>
                                                <td class="text-end text-success">
                                                    +<fmt:formatNumber value="${row[1]}" pattern="#,###"/>
                                                </td>
                                                <td class="text-end">
                                                    <c:if test="${row[2] > 0}">
                                                        <span class="refund-badge">
                                                            -<fmt:formatNumber value="${row[2]}" pattern="#,###"/>
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${row[2] == 0}">
                                                        <span class="text-muted">0</span>
                                                    </c:if>
                                                </td>
                                                <td class="text-end fw-bold">
                                                    <span class="profit-badge">
                                                        <fmt:formatNumber value="${row[3]}" pattern="#,###"/>
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty revenueByDate}">
                                            <tr>
                                                <td colspan="4" class="text-center py-4 text-muted">Không có dữ liệu</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel-box">
                    <div class="section-title">
                        <i class="fa-solid fa-layer-group text-primary"></i> Báo cáo theo tháng
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th class="ps-4">Tháng</th>
                                    <th class="text-end pe-4">Tổng doanh thu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${revenueByMonth}" var="row">
                                    <tr>
                                        <td class="ps-4">
                                            <div class="d-flex align-items-center">
                                                <div style="width: 40px; height: 40px; background: rgba(59, 130, 246, 0.2); color: #60a5fa; border-radius: 8px; display: grid; place-items: center; margin-right: 15px;">
                                                    <i class="fa-solid fa-calendar-check"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-bold">Tháng ${row[1]}</div>
                                                    <small class="text-muted">Năm ${row[0]}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-end pe-4 fw-bold fs-5 text-white">
                                            <fmt:formatNumber value="${row[2]}" pattern="#,###"/> đ
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty revenueByMonth}">
                                    <tr>
                                        <td colspan="2" class="text-center py-5 text-muted">
                                            <i class="fa-regular fa-folder-open fa-lg mb-2"></i>
                                            <div>Không có dữ liệu giao dịch theo tháng</div>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

            </main>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            const dates = [];
            const revenues = [];

            <c:forEach items="${revenueByDate}" var="row">
                dates.push('<fmt:formatDate value="${row[0]}" pattern="dd/MM"/>');
                revenues.push(${row[3]}); // ✅ Lấy cột 3 (Doanh thu thực = Thu - Hoàn)
            </c:forEach>

            if (dates.length > 0) {
                const ctx = document.getElementById('revenueChart');

                const gradientFill = ctx.getContext('2d').createLinearGradient(0, 0, 0, 400);
                gradientFill.addColorStop(0, 'rgba(59, 130, 246, 0.5)');
                gradientFill.addColorStop(1, 'rgba(59, 130, 246, 0.0)');

                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: dates.reverse(),
                        datasets: [{
                                label: 'Doanh thu thực (VNĐ)',
                                data: revenues.reverse(),
                                borderColor: '#60a5fa',
                                backgroundColor: gradientFill,
                                borderWidth: 2,
                                pointBackgroundColor: '#ffffff',
                                pointBorderColor: '#60a5fa',
                                pointRadius: 4,
                                fill: true,
                                tension: 0.4
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {display: false}
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: {color: '#334155'},
                                ticks: {color: '#94a3b8'}
                            },
                            x: {
                                grid: {display: false},
                                ticks: {color: '#94a3b8'}
                            }
                        }
                    }
                });
            }
        </script>
    </body>
</html>