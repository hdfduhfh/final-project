<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="mypack.Seat" %>
<%
    List<Seat> seats = (List<Seat>) request.getAttribute("seats");
    Long vipCount = (Long) request.getAttribute("vipCount");
    Long normalCount = (Long) request.getAttribute("normalCount");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý ghế</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --primary-color: #4361ee;
            --danger-color: #ef233c;
            --success-color: #2ec4b6;
            --vip-color: #ffd700;
            --bg-color: #f8f9fa;
            --text-color: #2b2d42;
        }

        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: var(--bg-color); color: var(--text-color); padding: 30px; margin: 0; }
        
        /* Header Section */
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .page-header h2 { margin: 0; color: #333; font-size: 1.8rem; }

        /* Alert Box */
        .alert-error {
            background-color: #fff0f1; border-left: 5px solid var(--danger-color); color: #c0392b;
            padding: 15px 20px; margin-bottom: 25px; border-radius: 4px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05); display: flex; align-items: center;
        }
        .alert-error i { margin-right: 12px; font-size: 1.2rem; }

        /* Control Panel (Bulk Update) */
        .control-panel {
            background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            margin-bottom: 30px; overflow: hidden;
        }
        .control-panel summary {
            padding: 15px 20px; font-weight: bold; cursor: pointer; background-color: #e9ecef;
            list-style: none; display: flex; align-items: center; justify-content: space-between;
        }
        .control-panel summary::after { content: '\f107'; font-family: "Font Awesome 6 Free"; font-weight: 900; }
        .control-panel[open] summary::after { content: '\f106'; }
        .panel-content { padding: 25px; }

        /* Grid Layout for Bulk Form */
        .bulk-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-bottom: 20px; }
        .card-price { padding: 20px; border-radius: 8px; border: 1px solid #eee; transition: all 0.3s ease; }
        
        .card-vip { background: linear-gradient(to right bottom, #fffdf0, #fff); border-left: 4px solid var(--vip-color); }
        .card-normal { background: linear-gradient(to right bottom, #f8f9fa, #fff); border-left: 4px solid #adb5bd; }

        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 0.9rem; }
        .form-control { width: 90%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 1rem; }
        
        /* Buttons */
        .btn { padding: 8px 16px; border: none; cursor: pointer; border-radius: 6px; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; font-weight: 600; transition: 0.2s; }
        .btn-add { background-color: var(--primary-color); color: white; padding: 10px 20px; }
        .btn-add:hover { background-color: #304ffe; }
        .btn-edit { background-color: #e2e6ea; color: #333; }
        .btn-edit:hover { background-color: #dbe0e5; }
        .btn-delete { background-color: #ffebee; color: var(--danger-color); }
        .btn-delete:hover { background-color: #ffcdd2; }
        .btn-primary { background-color: var(--primary-color); color: white; padding: 12px 24px; font-size: 1rem; }
        .btn-secondary { background-color: #6c757d; color: white; padding: 12px 24px; }
        .btn:disabled { opacity: 0.6; cursor: not-allowed; }

        /* Table Styles */
        .table-container { background: white; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #f1f3f5; color: #495057; font-weight: 700; padding: 15px; text-align: left; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; }
        td { padding: 15px; border-bottom: 1px solid #eee; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover { background-color: #f8f9fa; }

        /* Badges */
        .badge { padding: 5px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: bold; }
        .badge-vip { background-color: #fff3cd; color: #856404; }
        .badge-normal { background-color: #e2e3e5; color: #383d41; }
        .badge-active { color: var(--success-color); }
        .badge-inactive { color: var(--danger-color); }

        .price-text { font-family: 'Consolas', monospace; font-weight: bold; color: #2ecc71; }
    </style>
</head>
<body>

    <div class="page-header">
        <h2><i class="fa-solid fa-couch"></i> Quản lý ghế rạp</h2>
        <a href="<%=request.getContextPath()%>/admin/seats?action=add" class="btn btn-add">
            <i class="fa-solid fa-plus"></i> Thêm ghế mới
        </a>
    </div>

    <% 
        String errorMsg = (String) request.getAttribute("error"); 
        if (errorMsg != null && !errorMsg.isEmpty()) { 
    %>
        <div class="alert-error">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <span><%= errorMsg %></span>
        </div>
    <% } %>

    <details class="control-panel">
        <summary>
            <span><i class="fa-solid fa-money-bill-wave"></i> Cập nhật giá hàng loạt</span>
        </summary>
        <div class="panel-content">
            <form id="bulkPriceForm" method="post" action="<%=request.getContextPath()%>/admin/seats">
                <input type="hidden" name="action" value="bulkUpdatePrice">
                
                <div class="bulk-grid">
                    <div class="card-price card-vip">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                            <h4 style="margin: 0; color: #b7950b;">⭐ Ghế VIP (<%=vipCount%>)</h4>
                            <input type="checkbox" name="updateVip" id="updateVip" value="true" style="transform: scale(1.5); cursor: pointer;">
                        </div>
                        <div class="form-group">
                            <label>Giá mới (VNĐ):</label>
                            <input type="number" name="vipPrice" id="vipPrice" min="0" step="1000" placeholder="Nhập giá VIP..." class="form-control" disabled>
                        </div>
                    </div>
                    
                    <div class="card-price card-normal">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                            <h4 style="margin: 0; color: #495057;">🪑 Ghế Thường (<%=normalCount%>)</h4>
                            <input type="checkbox" name="updateNormal" id="updateNormal" value="true" style="transform: scale(1.5); cursor: pointer;">
                        </div>
                        <div class="form-group">
                            <label>Giá mới (VNĐ):</label>
                            <input type="number" name="normalPrice" id="normalPrice" min="0" step="1000" placeholder="Nhập giá thường..." class="form-control" disabled>
                        </div>
                    </div>
                </div>

                <div id="updateInfo" style="background: #e7f5ff; padding: 15px; border-radius: 6px; margin-bottom: 20px; display: none; color: #004085;">
                    <i class="fa-solid fa-circle-info"></i> <strong>Xác nhận thay đổi:</strong>
                    <div id="updateSummary" style="margin-top: 5px; margin-left: 20px;"></div>
                </div>

                <div style="text-align: right;">
                    <button type="button" onclick="resetBulkForm()" class="btn btn-secondary">
                        <i class="fa-solid fa-rotate-left"></i> Đặt lại
                    </button>
                    <button type="submit" id="submitBtn" class="btn btn-primary" disabled>
                        <i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </details>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th style="width: 80px;">Số ghế</th>
                    <th>Hàng / Cột</th>
                    <th>Loại ghế</th>
                    <th>Giá vé</th>
                    <th>Trạng thái</th>
                    <th style="text-align: center; width: 180px;">Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <% 
                if (seats != null && !seats.isEmpty()) {
                    for (Seat seat : seats) { 
                %>
                <tr>
                    <td><strong style="font-size: 1.1em;"><%=seat.getSeatNumber()%></strong></td>
                    <td style="color: #666;">Hàng <%=seat.getRowLabel()%> - Cột <%=seat.getColumnNumber()%></td>
                    <td>
                        <% if ("VIP".equals(seat.getSeatType())) { %>
                            <span class="badge badge-vip">VIP</span>
                        <% } else { %>
                            <span class="badge badge-normal">NORMAL</span>
                        <% } %>
                    </td>
                    <td class="price-text"><%=String.format("%,.0f", seat.getPrice())%> ₫</td>
                    <td>
                        <% if (seat.getIsActive()) { %>
                            <span class="badge-active"><i class="fa-solid fa-circle-check"></i> Hoạt động</span>
                        <% } else { %>
                            <span class="badge-inactive"><i class="fa-solid fa-circle-xmark"></i> Bảo trì</span>
                        <% } %>
                    </td>
                    <td style="text-align: center;">
                        <a href="<%=request.getContextPath()%>/admin/seats?action=edit&id=<%=seat.getSeatID()%>" 
                           class="btn btn-edit" title="Sửa">
                           <i class="fa-solid fa-pen"></i>
                        </a>
                        <a href="<%=request.getContextPath()%>/admin/seats?action=delete&id=<%=seat.getSeatID()%>" 
                           class="btn btn-delete" 
                           onclick="return confirm('Bạn có chắc muốn xóa ghế <%=seat.getSeatNumber()%>?')"
                           title="Xóa">
                           <i class="fa-solid fa-trash"></i>
                        </a>
                    </td>
                </tr>
                <% 
                    }
                } else { 
                %>
                <tr>
                    <td colspan="6" style="text-align: center; padding: 40px; color: #999;">
                        <i class="fa-regular fa-folder-open" style="font-size: 2rem; display: block; margin-bottom: 10px;"></i>
                        Chưa có dữ liệu ghế.
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <script>
        const updateVipCheckbox = document.getElementById("updateVip");
        const updateNormalCheckbox = document.getElementById("updateNormal");
        const vipPriceInput = document.getElementById("vipPrice");
        const normalPriceInput = document.getElementById("normalPrice");
        const submitBtn = document.getElementById("submitBtn");
        const updateInfo = document.getElementById("updateInfo");
        const updateSummary = document.getElementById("updateSummary");
        
        const vipCount = <%=vipCount%>;
        const normalCount = <%=normalCount%>;
        
        function updateButtonState() {
            const vipChecked = updateVipCheckbox.checked;
            const normalChecked = updateNormalCheckbox.checked;
            const vipPrice = parseFloat(vipPriceInput.value);
            const normalPrice = parseFloat(normalPriceInput.value);
            
            const canSubmit = (vipChecked && vipPrice >= 0 && !isNaN(vipPrice)) || 
                             (normalChecked && normalPrice >= 0 && !isNaN(normalPrice));
            
            submitBtn.disabled = !canSubmit;
            
            if (vipChecked || normalChecked) {
                updateInfo.style.display = "block";
                let summaryText = "";
                
                if (vipChecked && vipPrice >= 0 && !isNaN(vipPrice)) {
                    summaryText += "<div>⭐ <b>" + vipCount + " ghế VIP</b> sẽ đổi thành <b style='color:#d35400'>" + 
                                  vipPrice.toLocaleString('vi-VN') + " VNĐ</b></div>";
                }
                
                if (normalChecked && normalPrice >= 0 && !isNaN(normalPrice)) {
                    summaryText += "<div>🪑 <b>" + normalCount + " ghế Thường</b> sẽ đổi thành <b style='color:#2980b9'>" + 
                                  normalPrice.toLocaleString('vi-VN') + " VNĐ</b></div>";
                }
                
                updateSummary.innerHTML = summaryText;
            } else {
                updateInfo.style.display = "none";
            }
        }
        
        updateVipCheckbox.addEventListener("change", function() {
            vipPriceInput.disabled = !this.checked;
            if (!this.checked) vipPriceInput.value = "";
            updateButtonState();
        });
        
        updateNormalCheckbox.addEventListener("change", function() {
            normalPriceInput.disabled = !this.checked;
            if (!this.checked) normalPriceInput.value = "";
            updateButtonState();
        });
        
        vipPriceInput.addEventListener("input", updateButtonState);
        normalPriceInput.addEventListener("input", updateButtonState);
        
        function resetBulkForm() {
            updateVipCheckbox.checked = false;
            updateNormalCheckbox.checked = false;
            vipPriceInput.value = "";
            normalPriceInput.value = "";
            vipPriceInput.disabled = true;
            normalPriceInput.disabled = true;
            updateButtonState();
        }
    </script>
</body>
</html>