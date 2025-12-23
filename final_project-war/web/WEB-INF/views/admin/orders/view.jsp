<%-- 
    Document   : view
    Created on : Dec 20, 2025, 10:24:33 AM
    Author     : DANG KHOA
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết đơn hàng #${order.orderID}</title>
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; }
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; padding: 20px; }
            .container { max-width: 1200px; margin: 0 auto; }
            .header { background: white; padding: 20px 30px; border-radius: 10px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
            .header h2 { color: #333; }
            .btn-back { padding: 10px 20px; background: #6c757d; color: white; text-decoration: none; border-radius: 5px; }
            .content { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
            .card { background: white; padding: 25px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
            .card h3 { color: #007bff; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid #007bff; }
            .info-row { display: flex; padding: 12px 0; border-bottom: 1px solid #eee; }
            .info-label { font-weight: bold; width: 150px; color: #666; }
            .info-value { flex: 1; color: #333; }
            .status-badge { display: inline-block; padding: 5px 15px; border-radius: 20px; font-size: 12px; font-weight: bold; }
            .status-confirmed { background: #28a745; color: white; }
            .status-pending { background: #ffc107; color: #333; }
            .status-cancelled { background: #dc3545; color: white; }
            .status-paid { background: #28a745; color: white; }
            .status-unpaid { background: #dc3545; color: white; }
            .order-items { grid-column: 1 / -1; }
            table { width: 100%; border-collapse: collapse; margin-top: 15px; }
            th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
            th { background-color: #f8f9fa; font-weight: bold; color: #333; }
            .total-section { margin-top: 20px; padding-top: 20px; border-top: 2px solid #007bff; }
            .total-row { display: flex; justify-content: space-between; padding: 8px 0; font-size: 18px; }
            .total-row.final { font-weight: bold; font-size: 24px; color: #007bff; }
            .actions { grid-column: 1 / -1; display: flex; gap: 10px; justify-content: flex-end; }
            .btn { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; }
            .btn-success { background: #28a745; color: white; }
            .btn-danger { background: #dc3545; color: white; }
            .btn:hover { opacity: 0.8; }
            
            /* Style cho ô Lý do hủy */
            .reason-box { background-color: #fff3cd; border: 1px solid #ffeeba; }
            .reason-label { color: #856404; }
            .reason-text { color: #856404; font-weight: bold; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h2>📋 Chi tiết đơn hàng #${order.orderID}</h2>
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn-back">
                    ← Quay lại danh sách
                </a>
            </div>

            <div class="content">
                <div class="card">
                    <h3>📦 Thông tin đơn hàng</h3>
                    <div class="info-row">
                        <div class="info-label">Mã đơn hàng:</div>
                        <div class="info-value"><strong>#${order.orderID}</strong></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Ngày đặt:</div>
                        <div class="info-value">
                            <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Trạng thái:</div>
                        <div class="info-value">
                            <span class="status-badge 
                                  ${order.status == 'CONFIRMED' ? 'status-confirmed' : 
                                    order.status == 'CANCELLED' ? 'status-cancelled' : 'status-pending'}">
                                    ${order.status}
                              </span>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Thanh toán:</div>
                        <div class="info-value">
                            <span class="status-badge ${order.paymentStatus == 'PAID' ? 'status-paid' : 'status-unpaid'}">
                                ${order.paymentStatus == 'PAID' ? '✓ Đã thanh toán' : '⏳ Chưa thanh toán'}
                            </span>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Phương thức:</div>
                        <div class="info-value">${order.paymentMethod}</div>
                    </div>

                    <c:if test="${order.cancellationRequested}">
                        <div class="info-row reason-box">
                            <div class="info-label reason-label">⚠️ Lý do hủy:</div>
                            <div class="info-value reason-text">${order.cancellationReason}</div>
                        </div>
                    </c:if>
                </div>

                <div class="card">
                    <h3>👤 Thông tin khách hàng</h3>
                    <div class="info-row">
                        <div class="info-label">Họ tên:</div>
                        <div class="info-value"><strong>${order.userID.fullName}</strong></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Email:</div>
                        <div class="info-value">${order.userID.email}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Số điện thoại:</div>
                        <div class="info-value">
                            ${order.userID.phone != null ? order.userID.phone : 'Chưa cập nhật'}
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">User ID:</div>
                        <div class="info-value">#${order.userID.userID}</div>
                    </div>
                </div>

                <div class="card order-items">
                    <h3>🎫 Chi tiết vé đã đặt</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Số ghế</th>
                                <th>Loại ghế</th>
                                <th>Suất diễn</th>
                                <th>Thời gian</th>
                                <th>Giá</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="detail" items="${orderDetails}" varStatus="status">
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td><strong>${detail.seatID.seatNumber}</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${detail.seatID.seatType == 'VIP'}">
                                                ⭐ VIP
                                            </c:when>
                                            <c:otherwise>
                                                🪑 Thường
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${detail.scheduleID.showID.showName}</td>
                                    <td>
                                        <fmt:formatDate value="${detail.scheduleID.showTime}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td>
                                        <strong><fmt:formatNumber value="${detail.price}" type="number" maxFractionDigits="0"/> đ</strong>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div class="total-section">
                        <div class="total-row">
                            <span>Tổng cộng:</span>
                            <span><fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> đ</span>
                        </div>
                        <div class="total-row">
                            <span>Giảm giá:</span>
                            <span>- <fmt:formatNumber value="${order.discountAmount}" type="number" maxFractionDigits="0"/> đ</span>
                        </div>
                        <div class="total-row final">
                            <span>Thành tiền:</span>
                            <span><fmt:formatNumber value="${order.finalAmount}" type="number" maxFractionDigits="0"/> đ</span>
                        </div>
                    </div>
                </div>

                <div class="card actions">
                    <c:if test="${order.status == 'PENDING' && order.paymentStatus == 'PAID'}">
                        <a href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.orderID}&status=CONFIRMED" 
                           class="btn btn-success"
                           onclick="return confirm('✅ Xác nhận đơn hàng này?\n\nVé sẽ được tạo ngay lập tức!')">
                            ✓ XÁC NHẬN & TẠO VÉ
                        </a>
                    </c:if>

                    <c:if test="${order.paymentStatus != 'PAID'}">
                        <a href="${pageContext.request.contextPath}/admin/orders?action=updatePaymentStatus&id=${order.orderID}&paymentStatus=PAID" 
                           class="btn btn-success"
                           onclick="return confirm('Xác nhận đơn hàng này đã thanh toán?')">
                            ✓ Xác nhận đã thanh toán
                        </a>
                    </c:if>

                    <c:if test="${order.status != 'CANCELLED' && order.cancellationRequested}">
                        <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="approveCancel">
                            <input type="hidden" name="orderId" value="${order.orderID}">
                            <button type="submit" class="btn btn-danger" onclick="return confirm('⚠️ Duyệt yêu cầu hủy và hoàn vé này?');">
                                ✅ DUYỆT YÊU CẦU HỦY
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>
    </body>
</html>