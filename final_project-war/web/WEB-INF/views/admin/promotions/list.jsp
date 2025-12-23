<%-- 
    Document   : list
    Created on : Dec 19, 2025
    Updated    : Added Actions, Limits, Formatting
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý khuyến mãi</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            h2 {
                color: #333;
            }

            /* Table Styling */
            table {
                border-collapse: collapse;
                width: 100%;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            th, td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: left;
                vertical-align: middle;
            }
            th {
                background-color: #007bff;
                color: white;
            }
            tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            tr:hover {
                background-color: #f1f1f1;
            }

            /* Status Badges */
            .status-badge {
                padding: 4px 8px;
                border-radius: 4px;
                color: white;
                font-size: 0.85em;
                font-weight: bold;
            }
            .status-active {
                background-color: #28a745;
            } /* Màu xanh */
            .status-inactive {
                background-color: #dc3545;
            } /* Màu đỏ */

            /* Buttons */
            .btn {
                padding: 8px 15px;
                text-decoration: none;
                border-radius: 4px;
                display: inline-block;
            }
            .btn-primary {
                background-color: #007bff;
                color: white;
            }
            .btn-warning {
                background-color: #ffc107;
                color: black;
                font-size: 0.9em;
                margin-right: 5px;
            }
            .btn-danger {
                background-color: #dc3545;
                color: white;
                font-size: 0.9em;
            }

            /* Info Text */
            .small-text {
                font-size: 0.85em;
                color: #666;
            }
            .limit-info {
                font-weight: bold;
                color: #0056b3;
            }
        </style>
    </head>
    <body>

        <div style="display: flex; justify-content: space-between; align-items: center;">
            <h2>Danh sách mã giảm giá</h2>

            <c:if test="${not empty param.msg}">
                <span style="color: green; font-weight: bold;">
                    <c:choose>
                        <c:when test="${param.msg == 'success'}">Thao tác thành công!</c:when>
                        <c:when test="${param.msg == 'created'}">Đã thêm mới thành công!</c:when>
                        <c:when test="${param.msg == 'updated'}">Cập nhật thành công!</c:when>
                        <c:when test="${param.msg == 'deleted'}">Đã xóa thành công!</c:when>
                    </c:choose>
                </span>
            </c:if>

            <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/promotions?action=create">
                + Thêm khuyến mãi mới
            </a>
        </div>

        <br>

        <table>
            <thead>
                <tr>
                    <th style="width: 5%">ID</th>
                    <th style="width: 15%">Thông tin mã</th>
                    <th style="width: 15%">Giá trị giảm</th>
                    <th style="width: 15%">Giới hạn dùng</th>
                    <th style="width: 20%">Thời gian hiệu lực</th>
                    <th style="width: 10%">Trạng thái</th>
                    <th style="width: 15%">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${promotions}">
                    <tr>
                        <td>${p.promotionID}</td>

                        <td>
                            <strong>${p.name}</strong><br>
                            <span style="color: #d63384; font-family: monospace; font-size: 1.1em;">
                                ${p.code}
                            </span>
                        </td>

                        <td>
                            <c:choose>
                                <%-- TRƯỜNG HỢP 1: GIẢM THEO PHẦN TRĂM --%>
                                <c:when test="${p.discountType == 'PERCENT'}">
                                    <strong style="color: red;">
                                        -<fmt:formatNumber value="${p.discountValue}" type="number" maxFractionDigits="0"/>%
                                    </strong>

                                    <div class="small-text">
                                        <c:if test="${not empty p.maxDiscount}">
                                            (Tối đa: 
                                            <fmt:formatNumber value="${p.maxDiscount}" pattern="#,###"/> đ)
                                        </c:if>
                                    </div>
                                </c:when>

                                <%-- TRƯỜNG HỢP 2: GIẢM TIỀN CỐ ĐỊNH --%>
                                <c:otherwise>
                                    <strong style="color: green;">
                                        -<fmt:formatNumber value="${p.discountValue}" pattern="#,###"/> đ
                                    </strong>
                                </c:otherwise>
                            </c:choose>

                            <div class="small-text" style="margin-top: 5px;">
                                Min đơn: <fmt:formatNumber value="${p.minOrderAmount}" pattern="#,###"/> đ
                            </div>
                        </td>

                        <td>
                            <div>Toàn web: 
                                <c:choose>
                                    <c:when test="${empty p.maxUsage || p.maxUsage == 0}">
                                        <span class="limit-info">∞</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color:red">${fn:length(p.order1Collection)}</span> 
                                        / <span class="limit-info">${p.maxUsage}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div style="margin-top: 5px;">Mỗi khách: 
                                <c:choose>
                                    <c:when test="${empty p.maxUsagePerUser || p.maxUsagePerUser == 0}">
                                        <span class="limit-info">∞</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="limit-info">${p.maxUsagePerUser}</span> lượt
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </td>

                        <td class="small-text">
                            Bắt đầu: <fmt:formatDate value="${p.startDate}" pattern="dd/MM/yyyy HH:mm"/><br>
                            Kết thúc: <fmt:formatDate value="${p.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </td>

                        <td style="text-align: center;">
                            <c:choose>
                                <c:when test="${p.status == 'ACTIVE'}">
                                    <span class="status-badge status-active">Đang chạy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge status-inactive">Đã tắt</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <a class="btn btn-warning" href="${pageContext.request.contextPath}/admin/promotions?action=edit&id=${p.promotionID}">
                                Sửa
                            </a>

                            <%-- LOGIC MỚI: Chỉ hiện nút Xóa nếu chưa ai dùng (size == 0) --%>
                            <c:choose>
                                <c:when test="${fn:length(p.order1Collection) == 0}">
                                    <a class="btn btn-danger" 
                                       href="${pageContext.request.contextPath}/admin/promotions?action=delete&id=${p.promotionID}"
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa mã ${p.code} không?');">
                                        Xóa
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="btn" style="background-color: #ccc; color: #fff; cursor: not-allowed; border:none;" 
                                          title="Mã này đã có người dùng, không thể xóa. Hãy chuyển sang INACTIVE.">
                                        Xóa
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty promotions}">
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 20px;">
                            Chưa có chương trình khuyến mãi nào. Hãy thêm mới!
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>

    </body>
</html>