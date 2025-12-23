<%-- 
    Document   : edit
    Created on : Dec 19, 2025
    Updated    : Added Data Binding & Logic Toggle
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Cập nhật khuyến mãi</title>
        <style>
            .alert-error {
                background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb;
                padding: 15px; margin-bottom: 20px; border-radius: 4px;
            }
            .form-group { margin-bottom: 15px; }
            label { font-weight: bold; display: block; margin-bottom: 5px; }
            input, select { padding: 8px; width: 300px; border: 1px solid #ccc; border-radius: 4px; }
            input:disabled { background-color: #e9ecef; cursor: not-allowed; }
            .btn-save { background-color: #28a745; color: white; padding: 10px 20px; border: none; cursor: pointer; border-radius: 4px;}
            .btn-cancel { text-decoration: none; color: #333; margin-left: 15px; }
        </style>
    </head>
    <body>

        <h2>Cập nhật khuyến mãi: <span style="color:blue">${promotion.code}</span></h2>

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

        <form action="${pageContext.request.contextPath}/admin/promotions" method="post">
            <input type="hidden" name="action" value="update"/>
            <input type="hidden" name="id" value="${promotion.promotionID}"/>

            <div class="form-group">
                <label>Tên khuyến mãi:</label>
                <input type="text" name="name" 
                       value="${not empty oldName ? oldName : promotion.name}" required>
            </div>

            <div class="form-group">
                <label>Mã khuyến mãi (Code):</label>
                <input type="text" name="code" 
                       value="${not empty oldCode ? oldCode : promotion.code}" required>
            </div>

            <div class="form-group">
                <label>Loại giảm giá:</label>
                <select name="discountType" id="discountType" onchange="toggleMaxDiscount()" required>
                    <c:set var="currentType" value="${not empty oldType ? oldType : promotion.discountType}"/>
                    <option value="PERCENT" ${currentType == 'PERCENT' ? 'selected' : ''}>Phần trăm (%)</option>
                    <option value="FIXED" ${currentType == 'FIXED' ? 'selected' : ''}>Số tiền cố định (VNĐ)</option>
                </select>
            </div>

            <div class="form-group">
                <label>Giá trị giảm:</label>
                <input type="number" step="0.01" name="discountValue" 
                       value="${not empty oldValue ? oldValue : promotion.discountValue}" required>
            </div>

            <div class="form-group">
                <label>Đơn hàng tối thiểu (VNĐ):</label>
                <input type="number" step="0.01" name="minOrderAmount" 
                       value="${not empty oldMinOrder ? oldMinOrder : promotion.minOrderAmount}" placeholder="0">
            </div>

            <div class="form-group">
                <label>Giảm tối đa (VNĐ):</label>
                <input type="number" step="0.01" name="maxDiscount" id="maxDiscount"
                       value="${not empty oldMaxDiscount ? oldMaxDiscount : promotion.maxDiscount}">
                <br><small style="color: gray;">* Chỉ áp dụng cho loại Phần trăm</small>
            </div>

            <div class="form-group">
                <label>Ngày bắt đầu:</label>
                <input type="datetime-local" name="startDate" 
                       value="${not empty oldStartDate ? oldStartDate : formattedStartDate}" required>
            </div>

            <div class="form-group">
                <label>Ngày kết thúc:</label>
                <input type="datetime-local" name="endDate" 
                       value="${not empty oldEndDate ? oldEndDate : formattedEndDate}" required>
            </div>

            <div class="form-group">
                <label>Trạng thái:</label>
                <select name="status">
                    <c:set var="currentStatus" value="${not empty oldStatus ? oldStatus : promotion.status}"/>
                    <option value="ACTIVE" ${currentStatus == 'ACTIVE' ? 'selected' : ''}>ACTIVE (Đang chạy)</option>
                    <option value="INACTIVE" ${currentStatus == 'INACTIVE' ? 'selected' : ''}>INACTIVE (Tạm dừng)</option>
                </select>
            </div>

            <div class="form-group">
                <label>Số lượt sử dụng tối đa (Toàn hệ thống):</label>
                <input type="number" name="maxUsage" 
                       value="${not empty oldMaxUsage ? oldMaxUsage : promotion.maxUsage}" placeholder="Để trống nếu không giới hạn">
            </div>

            <div class="form-group">
                <label>Số lượt dùng tối đa (Mỗi user):</label>
                <input type="number" name="maxUsagePerUser" 
                       value="${not empty oldMaxPerUser ? oldMaxPerUser : promotion.maxUsagePerUser}" placeholder="Để trống nếu không giới hạn">
            </div>

            <br>
            <button type="submit" class="btn-save">Cập nhật</button>
            <a href="${pageContext.request.contextPath}/admin/promotions" class="btn-cancel">Hủy bỏ</a>
        </form>

        <script>
            function toggleMaxDiscount() {
                var typeSelect = document.getElementById("discountType");
                var maxDiscountInput = document.getElementById("maxDiscount");
                
                if (typeSelect.value === "FIXED") {
                    maxDiscountInput.disabled = true;
                    maxDiscountInput.value = ""; // Xóa giá trị cũ để tránh nhầm lẫn
                    maxDiscountInput.placeholder = "Không cần nhập cho loại Fixed";
                    maxDiscountInput.style.backgroundColor = "#e9ecef";
                } else {
                    maxDiscountInput.disabled = false;
                    maxDiscountInput.placeholder = "Nhập số tiền tối đa";
                    maxDiscountInput.style.backgroundColor = "white";
                }
            }

            // Chạy hàm này ngay khi trang tải xong để set đúng trạng thái ban đầu
            window.onload = function() {
                toggleMaxDiscount();
            };
        </script>
    </body>
</html>