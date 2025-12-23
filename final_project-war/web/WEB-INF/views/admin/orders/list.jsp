<%-- 
    Document   : list
    Created on : Dec 20, 2025, 10:24:04 AM
    Author     : DANG KHOA
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý đơn hàng</title>
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; }
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; padding: 20px; }
            .container { max-width: 1400px; margin: 0 auto; background: white; border-radius: 10px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
            h2 { color: #333; margin-bottom: 30px; padding-bottom: 15px; border-bottom: 3px solid #007bff; }
            .stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
            .stat-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 10px; text-align: center; }
            .stat-card h3 { font-size: 32px; margin-bottom: 5px; }
            .stat-card p { opacity: 0.9; font-size: 14px; }
            table { width: 100%; border-collapse: collapse; margin-top: 20px; }
            th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
            th { background-color: #007bff; color: white; font-weight: bold; }
            tr:hover { background-color: #f8f9fa; }
            .status-badge { display: inline-block; padding: 5px 15px; border-radius: 20px; font-size: 12px; font-weight: bold; }
            .status-confirmed { background: #28a745; color: white; }
            .status-pending { background: #ffc107; color: #333; }
            .status-cancelled { background: #dc3545; color: white; }
            .status-paid { background: #28a745; color: white; }
            .status-unpaid { background: #dc3545; color: white; }
            .btn { padding: 6px 12px; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; margin: 2px; }
            .btn-view { background: #17a2b8; color: white; }
            .btn-edit { background: #ffc107; color: #333; }
            .btn-delete { background: #dc3545; color: white; }
            .btn:hover { opacity: 0.8; }
            .empty { text-align: center; padding: 60px 20px; color: #999; }
            .filter-bar { background: #f8f9fa; padding: 15px; border-radius: 8px; margin-bottom: 20px; display: flex; gap: 15px; align-items: center; }
            .filter-bar select { padding: 8px 12px; border: 1px solid #ddd; border-radius: 5px; }
            
            /* Style cho badge yêu cầu hủy */
            .req-cancel { color: red; font-weight: bold; font-size: 0.85em; display: block; margin-top: 5px; }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>📋 Quản lý đơn hàng</h2>

            <div class="stats">
                <div class="stat-card">
                    <h3>${orders.size()}</h3>
                    <p>Tổng đơn hàng</p>
                </div>
                <div class="stat-card">
                    <h3>
                        <c:set var="confirmedCount" value="0" />
                        <c:forEach var="order" items="${orders}">
                            <c:if test="${order.status == 'CONFIRMED'}">
                                <c:set var="confirmedCount" value="${confirmedCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${confirmedCount}
                    </h3>
                    <p>Đã xác nhận</p>
                </div>
                <div class="stat-card">
                    <h3>
                        <c:set var="paidCount" value="0" />
                        <c:forEach var="order" items="${orders}">
                            <c:if test="${order.paymentStatus == 'PAID'}">
                                <c:set var="paidCount" value="${paidCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${paidCount}
                    </h3>
                    <p>Đã thanh toán</p>
                </div>
                <div class="stat-card">
                    <h3>
                        <c:set var="totalRevenue" value="0" />
                        <c:forEach var="order" items="${orders}">
                            <c:if test="${order.paymentStatus == 'PAID'}">
                                <c:set var="totalRevenue" value="${totalRevenue + order.finalAmount}" />
                            </c:if>
                        </c:forEach>
                        <fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0" />đ
                    </h3>
                    <p>Doanh thu</p>
                </div>
            </div>

            <div class="filter-bar">
                <label><strong>Lọc theo:</strong></label>
                <select id="filterStatus" onchange="filterOrders()">
                    <option value="">Tất cả trạng thái</option>
                    <option value="CONFIRMED">Đã xác nhận</option>
                    <option value="PENDING">Đang chờ</option>
                    <option value="CANCELLED">Đã hủy</option>
                </select>

                <select id="filterPayment" onchange="filterOrders()">
                    <option value="">Tất cả thanh toán</option>
                    <option value="PAID">Đã thanh toán</option>
                    <option value="PENDING">Chưa thanh toán</option>
                </select>
            </div>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="empty">
                        <h3>📭 Chưa có đơn hàng nào</h3>
                        <p>Đơn hàng sẽ hiển thị ở đây khi khách hàng đặt vé</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table id="ordersTable">
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
                                <td><strong>#${order.orderID}</strong></td>
                                <td>
                                    ${order.userID.fullName}<br>
                                    <small style="color: #666;">${order.userID.email}</small>
                                </td>
                                <td>
                                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td>
                                    <strong><fmt:formatNumber value="${order.finalAmount}" type="number" maxFractionDigits="0"/> đ</strong>
                                </td>
                                <td>
                                    <span class="status-badge ${order.paymentStatus == 'PAID' ? 'status-paid' : 'status-unpaid'}">
                                        ${order.paymentStatus == 'PAID' ? '✓ Đã thanh toán' : '⏳ Chưa thanh toán'}
                                    </span>
                                </td>
                                <td>
                                    <span class="status-badge 
                                          ${order.status == 'CONFIRMED' ? 'status-confirmed' : 
                                            order.status == 'CANCELLED' ? 'status-cancelled' : 'status-pending'}">
                                            ${order.status}
                                    </span>
                                    
                                    <c:if test="${order.cancellationRequested}">
                                        <span class="req-cancel">⚠️ Yêu cầu hủy</span>
                                    </c:if>
                                </td>
                                <td>${order.paymentMethod}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/orders?action=view&id=${order.orderID}" 
                                       class="btn btn-view">👁️ Xem</a>

                                    <c:if test="${order.status != 'CANCELLED' && order.cancellationRequested}">
                                        <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="approveCancel">
                                            <input type="hidden" name="orderId" value="${order.orderID}">
                                            <button type="submit" class="btn btn-delete" onclick="return confirm('Xác nhận duyệt yêu cầu hủy đơn hàng này?');">
                                                ✅ Duyệt Hủy
                                            </button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

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

                    if (statusMatch && paymentMatch) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }
        </script>
    </body>
</html>