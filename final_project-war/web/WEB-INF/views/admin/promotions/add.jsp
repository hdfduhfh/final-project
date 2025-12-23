<%-- 
    Document   : add
    Created on : Dec 19, 2025, 1:49:28 AM
    Author     : DANG KHOA
    Updated    : Added Validation Display & Data Retention
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thêm khuyến mãi</title>
        <style>
            /* CSS đơn giản để hiển thị lỗi đẹp hơn */
            .alert-error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 4px;
            }
            .alert-error ul {
                margin: 0;
                padding-left: 20px;
            }
            .form-group { margin-bottom: 15px; }
            label { font-weight: bold; display: block; margin-bottom: 5px; }
            input, select { padding: 5px; width: 300px; }
        </style>
    </head>
    <body>

        <h2>Thêm khuyến mãi mới</h2>

        <c:if test="${not empty errors}">
            <div class="alert-error">
                <strong>Vui lòng sửa các lỗi sau:</strong>
                <ul>
                    <c:forEach var="err" items="${errors}">
                        <li>${err}</li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert-error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/promotions" method="post">
            <input type="hidden" name="action" value="insert"/>

            <div class="form-group">
                <label>Tên khuyến mãi:</label>
                <input type="text" name="name" value="${oldName}" required>
            </div>

            <div class="form-group">
                <label>Mã khuyến mãi (Code):</label>
                <input type="text" name="code" value="${oldCode}" required placeholder="Ví dụ: SALE50">
            </div>

            <div class="form-group">
                <label>Loại giảm giá:</label>
                <select name="discountType" required>
                    <option value="PERCENT" ${oldType == 'PERCENT' ? 'selected' : ''}>Phần trăm (%)</option>
                    <option value="FIXED" ${oldType == 'FIXED' ? 'selected' : ''}>Số tiền cố định (VNĐ)</option>
                </select>
            </div>

            <div class="form-group">
                <label>Giá trị giảm:</label>
                <input type="number" step="0.01" name="discountValue" value="${oldValue}" required placeholder="Nhập số % hoặc số tiền">
            </div>

            <div class="form-group">
                <label>Đơn hàng tối thiểu (VNĐ):</label>
                <input type="number" step="0.01" name="minOrderAmount" value="${oldMinOrder}" placeholder="0">
            </div>

            <div class="form-group">
                <label>Giảm tối đa (VNĐ):</label>
                <input type="number" step="0.01" name="maxDiscount" value="${oldMaxDiscount}" placeholder="Chỉ dùng cho loại %">
            </div>

            <div class="form-group">
                <label>Ngày bắt đầu:</label>
                <input type="datetime-local" name="startDate" value="${oldStartDate}" required>
            </div>

            <div class="form-group">
                <label>Ngày kết thúc:</label>
                <input type="datetime-local" name="endDate" value="${oldEndDate}" required>
            </div>

            <div class="form-group">
                <label>Trạng thái:</label>
                <select name="status">
                    <option value="ACTIVE" ${oldStatus == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                    <option value="INACTIVE" ${oldStatus == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                </select>
            </div>

            <div class="form-group">
                <label>Số lượt sử dụng tối đa (Toàn hệ thống):</label>
                <input type="number" name="maxUsage" value="${oldMaxUsage}" placeholder="Để trống nếu không giới hạn">
            </div>

            <div class="form-group">
                <label>Số lượt dùng tối đa (Mỗi user):</label>
                <input type="number" name="maxUsagePerUser" value="${oldMaxPerUser}" placeholder="Để trống nếu không giới hạn">
            </div>

            <br>
            <button type="submit" style="padding: 10px 20px; cursor: pointer;">Lưu khuyến mãi</button>
            <a href="${pageContext.request.contextPath}/admin/promotions" style="margin-left: 10px;">Hủy bỏ</a>
        </form>

    </body>
</html>