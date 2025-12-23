<%-- 
    Document   : list
    Created on : Dec 20, 2025, 10:24:04 AM
    Author     : DANG KHOA
--%>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý đơn hàng</title>

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome 6 -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <style>
            :root{
                --bg:#0b1220;
                --panel:#0f1b33;
                --muted:#8ea0c4;
                --line:rgba(255,255,255,.08);
                --primary:#4f46e5;
                --danger:#ef4444;
                --success:#22c55e;
                --warning:#f59e0b;
                --info:#06b6d4;
            }

            body{
                background:
                    radial-gradient(1200px 700px at 20% -10%, rgba(79,70,229,.28), transparent 55%),
                    radial-gradient(900px 500px at 80% 0%, rgba(6,182,212,.22), transparent 60%),
                    linear-gradient(180deg, var(--bg), #070b14);
                min-height:100vh;
                color:#e6ecff;
                font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, "Noto Sans", "Helvetica Neue", sans-serif;
            }

            .admin-wrap{
                display:flex;
                min-height:100vh;
            }
            .sidebar{
                width: 270px;
                background: rgba(15,27,51,.86);
                border-right: 1px solid var(--line);
                backdrop-filter: blur(10px);
                padding: 18px 14px;
                position: sticky;
                top:0;
                height:100vh;
            }
            .brand{
                display:flex;
                align-items:center;
                gap:10px;
                padding:10px 12px;
                border-radius:14px;
                background: rgba(255,255,255,.06);
                border: 1px solid var(--line);
            }
            .brand .logo{
                width: 38px;
                height: 38px;
                border-radius: 12px;
                display:grid;
                place-items:center;
                background: linear-gradient(135deg, rgba(79,70,229,.9), rgba(6,182,212,.9));
                box-shadow: 0 14px 35px rgba(0,0,0,.35);
            }
            .brand .title{
                line-height: 1.1;
                font-weight: 800;
                letter-spacing: .2px;
            }
            .brand small{
                color: var(--muted);
                font-weight: 600;
            }

            .nav-group{
                margin-top: 14px;
            }
            .nav-item{
                display:flex;
                align-items:center;
                gap:10px;
                padding: 10px 12px;
                border-radius: 12px;
                color:#dbe5ff;
                text-decoration:none;
                border: 1px solid transparent;
            }
            .nav-item:hover{
                background: rgba(255,255,255,.06);
                border-color: var(--line);
            }
            .nav-item.active{
                background: rgba(6,182,212,.16);
                border-color: rgba(6,182,212,.35);
            }
            .nav-item i{
                width:20px;
                text-align:center;
                color:#bcd0ff;
            }

            .content{
                flex:1;
                padding: 22px 22px 28px;
            }

            .topbar{
                display:flex;
                gap:12px;
                align-items:center;
                justify-content:space-between;
                padding: 14px 16px;
                border-radius: 18px;
                background: rgba(255,255,255,.06);
                border: 1px solid var(--line);
                backdrop-filter: blur(10px);
                box-shadow: 0 18px 55px rgba(0,0,0,.35);
            }
            .page-h{
                display:flex;
                gap:12px;
                align-items:center;
            }
            .page-h h1{
                font-size: 18px;
                margin:0;
                font-weight: 900;
                letter-spacing:.2px;
            }
            .page-h .crumb{
                color: var(--muted);
                font-weight: 600;
                font-size: 12px;
            }

            /* Stats */
            .stat-grid{
                margin-top: 14px;
                display:grid;
                grid-template-columns: repeat(4, minmax(0, 1fr));
                gap: 12px;
            }
            @media (max-width: 992px){
                .sidebar{
                    display:none;
                }
                .stat-grid{
                    grid-template-columns: repeat(2, minmax(0, 1fr));
                }
            }
            @media (max-width: 576px){
                .stat-grid{
                    grid-template-columns: 1fr;
                }
            }
            .stat{
                background: rgba(255,255,255,.92);
                border-radius: 18px;
                padding: 14px 14px;
                border: 1px solid rgba(0,0,0,.06);
                box-shadow: 0 18px 45px rgba(0,0,0,.25);
                color:#0b1220;
                display:flex;
                align-items:center;
                justify-content:space-between;
                gap:12px;
            }
            .stat .label{
                font-size: 12px;
                color:#58627a;
                font-weight: 900;
                letter-spacing:.2px;
                text-transform: uppercase;
            }
            .stat .value{
                font-size: 20px;
                font-weight: 950;
                margin-top: 2px;
                line-height: 1.2;
            }
            .stat .icon{
                width: 44px;
                height: 44px;
                border-radius: 16px;
                display:grid;
                place-items:center;
                color:#fff;
                box-shadow: 0 18px 35px rgba(0,0,0,.18);
            }
            .i-total{
                background: linear-gradient(135deg, #4f46e5, #06b6d4);
            }
            .i-confirm{
                background: linear-gradient(135deg, #22c55e, #06b6d4);
            }
            .i-paid{
                background: linear-gradient(135deg, #22c55e, #4f46e5);
            }
            .i-rev{
                background: linear-gradient(135deg, #f59e0b, #4f46e5);
            }

            /* Panel */
            .panel{
                margin-top: 14px;
                padding: 14px;
                border-radius: 18px;
                background: rgba(255,255,255,.06);
                border: 1px solid var(--line);
                backdrop-filter: blur(10px);
            }

            /* Table */
            .table-wrap{
                margin-top: 12px;
                border-radius: 18px;
                overflow: hidden;
                background: rgba(255,255,255,.96);
                box-shadow: 0 22px 70px rgba(0,0,0,.35);
            }
            table thead th{
                background: #0f1b33 !important;
                color: #e8efff !important;
                border: none !important;
                white-space: nowrap;
                font-size: 13px;
                letter-spacing: .2px;
            }
            table tbody td{
                color: #0b1220;
                vertical-align: middle;
            }

            .status-badge{
                display:inline-flex;
                align-items:center;
                gap:6px;
                padding: 6px 10px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 900;
                border: 1px solid rgba(0,0,0,.08);
                background: #fff;
                white-space: nowrap;
            }
            .st-confirmed{
                color:#0b6b33;
                border-color: rgba(34,197,94,.25);
                background: rgba(34,197,94,.10);
            }
            .st-pending{
                color:#7a4b00;
                border-color: rgba(245,158,11,.25);
                background: rgba(245,158,11,.12);
            }
            .st-cancelled{
                color:#7a1010;
                border-color: rgba(239,68,68,.25);
                background: rgba(239,68,68,.12);
            }

            .pay-paid{
                color:#0b6b33;
                border-color: rgba(34,197,94,.25);
                background: rgba(34,197,94,.10);
            }
            .pay-unpaid{
                color:#7a1010;
                border-color: rgba(239,68,68,.25);
                background: rgba(239,68,68,.12);
            }

            .req-cancel{
                display:inline-flex;
                align-items:center;
                gap:6px;
                margin-top: 6px;
                font-size: 12px;
                font-weight: 950;
                color: #7a1010;
                background: rgba(239,68,68,.10);
                border: 1px dashed rgba(239,68,68,.35);
                border-radius: 999px;
                padding: 4px 10px;
            }

            .btn-icon{
                height: 36px;
                padding: 0 12px;
                display:inline-flex;
                align-items:center;
                gap:8px;
                border-radius: 12px;
                font-weight: 900;
                white-space: nowrap;
            }

            .empty{
                padding: 58px 16px;
                text-align:center;
                color:#6b7280;
            }
        </style>
    </head>

    <body>
        <div class="admin-wrap">

            <!-- SIDEBAR -->
            <aside class="sidebar">
                <div class="brand">
                    <div class="logo"><i class="fa-solid fa-masks-theater"></i></div>
                    <div>
                        <div class="title">Theater Admin</div>
                        <small>Quản lý đơn hàng</small>
                    </div>
                </div>

                <hr style="border-color: var(--line);">

                <div class="px-2">
                    <div class="text-uppercase" style="font-size:12px; color:var(--muted); font-weight:900; letter-spacing:.3px;">
                        Quick actions
                    </div>
                    <div class="mt-2 d-grid gap-2">
                        <a class="btn btn-outline-light fw-bold" href="${pageContext.request.contextPath}/admin/dashboard" style="border-radius:14px;">
                            <i class="fa-solid fa-arrow-left"></i> Về Dashboard
                        </a>
                    </div>
                </div>
            </aside>

            <!-- CONTENT -->
            <main class="content">

                <!-- TOPBAR -->
                <div class="topbar">
                    <div class="page-h">
                        <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                            <i class="fa-solid fa-receipt"></i>
                        </div>
                        <div>
                            <h1>Danh sách đơn hàng</h1>
                            <div class="crumb">Admin / Order Management</div>
                        </div>
                    </div>
                </div>

                <!-- STATS -->
                <div class="stat-grid">
                    <div class="stat">
                        <div>
                            <div class="label">Tổng đơn hàng</div>
                            <div class="value">${orders.size()}</div>
                        </div>
                        <div class="icon i-total"><i class="fa-solid fa-layer-group"></i></div>
                    </div>

                    <div class="stat">
                        <div>
                            <div class="label">Đã xác nhận</div>
                            <div class="value">
                                <c:set var="confirmedCount" value="0" />
                                <c:forEach var="order" items="${orders}">
                                    <c:if test="${order.status == 'CONFIRMED'}">
                                        <c:set var="confirmedCount" value="${confirmedCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${confirmedCount}
                            </div>
                        </div>
                        <div class="icon i-confirm"><i class="fa-solid fa-circle-check"></i></div>
                    </div>

                    <div class="stat">
                        <div>
                            <div class="label">Đã thanh toán</div>
                            <div class="value">
                                <c:set var="paidCount" value="0" />
                                <c:forEach var="order" items="${orders}">
                                    <c:if test="${order.paymentStatus == 'PAID'}">
                                        <c:set var="paidCount" value="${paidCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${paidCount}
                            </div>
                        </div>
                        <div class="icon i-paid"><i class="fa-solid fa-money-check-dollar"></i></div>
                    </div>

                    <div class="stat">
                        <div>
                            <div class="label">Doanh thu</div>
                            <div class="value">
                                <c:set var="totalRevenue" value="0" />
                                <c:forEach var="order" items="${orders}">
                                    <c:if test="${order.paymentStatus == 'PAID'}">
                                        <c:set var="totalRevenue" value="${totalRevenue + order.finalAmount}" />
                                    </c:if>
                                </c:forEach>
                                <fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0" />đ
                            </div>
                        </div>
                        <div class="icon i-rev"><i class="fa-solid fa-chart-line"></i></div>
                    </div>
                </div>

                <!-- FILTER PANEL -->
                <div class="panel">
                    <div class="row g-2 align-items-center">
                        <div class="col-lg-6">
                            <label class="form-label fw-bold mb-1" style="color:#e6ecff;">Lọc theo trạng thái</label>
                            <select id="filterStatus" class="form-select" onchange="filterOrders()">
                                <option value="">Tất cả trạng thái</option>
                                <option value="CONFIRMED">Đã xác nhận</option>
                                <option value="PENDING">Đang chờ</option>
                                <option value="CANCELLED">Đã hủy</option>
                            </select>
                        </div>

                        <div class="col-lg-6">
                            <label class="form-label fw-bold mb-1" style="color:#e6ecff;">Lọc theo thanh toán</label>
                            <select id="filterPayment" class="form-select" onchange="filterOrders()">
                                <option value="">Tất cả thanh toán</option>
                                <option value="PAID">Đã thanh toán</option>
                                <option value="PENDING">Chưa thanh toán</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- TABLE -->
                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="table-wrap">
                            <div class="empty">
                                <i class="fa-regular fa-folder-open fa-2x"></i>
                                <div class="mt-2 fw-bold">Chưa có đơn hàng nào.</div>
                                <div class="mt-1">Đơn hàng sẽ hiển thị ở đây khi khách hàng đặt vé.</div>
                            </div>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="table-wrap">
                            <div class="table-responsive">
                                <table id="ordersTable" class="table table-hover align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th>Mã ĐH</th>
                                            <th>Khách hàng</th>
                                            <th>Ngày đặt</th>
                                            <th>Tổng tiền</th>
                                            <th>Thanh toán</th>
                                            <th>Trạng thái</th>
                                            <th>Phương thức</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <c:forEach var="order" items="${orders}">
                                            <tr data-status="${order.status}" data-payment="${order.paymentStatus}">
                                                <td class="fw-bold">#${order.orderID}</td>

                                                <td>
                                                    <div class="fw-bold">${order.userID.fullName}</div>
                                                    <div class="text-secondary small">${order.userID.email}</div>
                                                </td>

                                                <td>
                                                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </td>

                                                <td class="fw-bold">
                                                    <fmt:formatNumber value="${order.finalAmount}" type="number" maxFractionDigits="0"/> đ
                                                </td>

                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.paymentStatus == 'PAID'}">
                                                            <span class="status-badge pay-paid">
                                                                <i class="fa-solid fa-circle-check"></i> Đã thanh toán
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge pay-unpaid">
                                                                <i class="fa-solid fa-clock"></i> Chưa thanh toán
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.status == 'CONFIRMED'}">
                                                            <span class="status-badge st-confirmed">
                                                                <i class="fa-solid fa-badge-check"></i> CONFIRMED
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'CANCELLED'}">
                                                            <span class="status-badge st-cancelled">
                                                                <i class="fa-solid fa-ban"></i> CANCELLED
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge st-pending">
                                                                <i class="fa-solid fa-hourglass-half"></i> PENDING
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <c:if test="${order.cancellationRequested}">
                                                        <span class="req-cancel">
                                                            <i class="fa-solid fa-triangle-exclamation"></i> Yêu cầu hủy
                                                        </span>
                                                    </c:if>
                                                </td>

                                                <td>${order.paymentMethod}</td>

                                                <td class="text-nowrap">
                                                    <a href="${pageContext.request.contextPath}/admin/orders?action=view&id=${order.orderID}"
                                                       class="btn btn-info btn-icon text-white">
                                                        <i class="fa-solid fa-eye"></i> Xem
                                                    </a>

                                                    <c:if test="${order.status != 'CANCELLED' && order.cancellationRequested}">
                                                        <form action="${pageContext.request.contextPath}/admin/orders"
                                                              method="post" style="display:inline;">
                                                            <input type="hidden" name="action" value="approveCancel">
                                                            <input type="hidden" name="orderId" value="${order.orderID}">
                                                            <button type="submit" class="btn btn-danger btn-icon"
                                                                    onclick="return confirm('Xác nhận duyệt yêu cầu hủy đơn hàng này?');">
                                                                <i class="fa-solid fa-check"></i> Duyệt hủy
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>

            </main>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                                        function filterOrders() {
                                                                            const statusFilter = document.getElementById('filterStatus').value;
                                                                            const paymentFilter = document.getElementById('filterPayment').value;
                                                                            const rows = document.querySelectorAll('#ordersTable tbody tr');

                                                                            rows.forEach(row => {
                                                                                const status = row.getAttribute('data-status');
                                                                                const payment = row.getAttribute('data-payment');

                                                                                const statusMatch = !statusFilter || status === statusFilter;
                                                                                const paymentMatch = !paymentFilter || payment === paymentFilter;

                                                                                row.style.display = (statusMatch && paymentMatch) ? '' : 'none';
                                                                            });
                                                                        }
        </script>
    </body>
</html>
