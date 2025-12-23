<%-- 
    Document   : edit
    Created on : Dec 19, 2025, 7:40:24 PM
    Author     : DANG KHOA
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="mypack.Seat" %>
<%
    Seat seat = (Seat) request.getAttribute("seat");
    if (seat == null) {
        response.sendRedirect(request.getContextPath() + "/admin/seats");
        return;
    }
%>

<h4>✏️ Sửa thông tin ghế</h4>

<form id="editSeatForm" method="post" action="<%=request.getContextPath()%>/admin/seats">
    <input type="hidden" name="action" value="edit">
    <input type="hidden" name="id" value="<%=seat.getSeatID()%>">

    <div style="margin-bottom: 15px;">
        <label><strong>Số ghế:</strong></label>
        <input type="text" value="<%=seat.getSeatNumber()%>" disabled style="background-color: #f0f0f0;">
        <small style="color: #666;">(Không thể thay đổi)</small>
    </div>

    <div style="margin-bottom: 15px;">
        <label><strong>Hàng:</strong></label>
        <input type="text" value="<%=seat.getRowLabel()%>" disabled style="background-color: #f0f0f0;">
    </div>

    <div style="margin-bottom: 15px;">
        <label><strong>Cột:</strong></label>
        <input type="text" value="<%=seat.getColumnNumber()%>" disabled style="background-color: #f0f0f0;">
    </div>

    <div style="margin-bottom: 15px;">
        <label><strong>Loại ghế:</strong></label>
        <select name="seatType" id="seatType" required style="padding: 5px; font-size: 14px;">
            <option value="VIP" <%= "VIP".equals(seat.getSeatType()) ? "selected" : "" %>>VIP</option>
            <option value="NORMAL" <%= "NORMAL".equals(seat.getSeatType()) ? "selected" : "" %>>NORMAL</option>
        </select>
        <span id="seatTypeIndicator" style="margin-left: 10px; font-weight: bold;"></span>
    </div>

    <div style="margin-bottom: 15px;">
        <label><strong>Giá:</strong></label>
        <input type="number" name="price" id="price" value="<%=seat.getPrice()%>" 
               min="0" step="0.01" required style="padding: 5px; font-size: 14px;">
        <small style="color: #666;">VNĐ</small>
    </div>

    <div style="margin-bottom: 15px;">
        <label><strong>Trạng thái:</strong></label>
        <select name="isActive" required style="padding: 5px; font-size: 14px;">
            <option value="true" <%= seat.getIsActive() ? "selected" : "" %>>✅ Hoạt động</option>
            <option value="false" <%= !seat.getIsActive() ? "selected" : "" %>>❌ Vô hiệu hóa</option>
        </select>
    </div>

    <div style="margin-top: 20px;">
        <button type="submit" style="padding: 10px 20px; background-color: #28a745; color: white; border: none; cursor: pointer; font-size: 14px; border-radius: 5px;">
            💾 Lưu thay đổi
        </button>
        <a href="<%=request.getContextPath()%>/admin/seats" 
           style="padding: 10px 20px; background-color: #6c757d; color: white; text-decoration: none; display: inline-block; margin-left: 10px; border-radius: 5px;">
            ❌ Hủy
        </a>
    </div>
</form>

<script>
    const seatTypeSelect = document.getElementById("seatType");
    const seatTypeIndicator = document.getElementById("seatTypeIndicator");
    const priceInput = document.getElementById("price");

    // Cập nhật indicator khi chọn loại ghế
    function updateSeatTypeIndicator() {
        const selectedType = seatTypeSelect.value;
        if (selectedType === "VIP") {
            seatTypeIndicator.innerHTML = "⭐ VIP";
            seatTypeIndicator.style.color = "gold";
        } else {
            seatTypeIndicator.innerHTML = "🪑 NORMAL";
            seatTypeIndicator.style.color = "black";
        }
    }

    // Tự động cập nhật khi thay đổi loại ghế
    seatTypeSelect.addEventListener("change", updateSeatTypeIndicator);
    
    // Khởi tạo lần đầu
    updateSeatTypeIndicator();

    // Validate form trước khi submit
    document.getElementById("editSeatForm").addEventListener("submit", function(e) {
        const price = parseFloat(priceInput.value);
        
        if (price < 0) {
            alert("❌ Giá không được âm!");
            e.preventDefault();
            return;
        }

        if (isNaN(price)) {
            alert("❌ Vui lòng nhập giá hợp lệ!");
            e.preventDefault();
            return;
        }

        // Xác nhận trước khi lưu
        const confirmMsg = "Bạn có chắc chắn muốn lưu các thay đổi?\n\n" +
                          "Loại ghế: " + seatTypeSelect.value + "\n" +
                          "Giá: " + price.toLocaleString('vi-VN') + " VNĐ";
        
        if (!confirm(confirmMsg)) {
            e.preventDefault();
        }
    });
</script>
