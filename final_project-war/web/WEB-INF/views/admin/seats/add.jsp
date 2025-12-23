<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<h4>➕ Thêm ghế hàng loạt</h4>

<form id="bulkSeatForm" method="post" action="<%=request.getContextPath()%>/admin/seats">
    <input type="hidden" name="action" value="bulkCreate">

    <label>Hàng bắt đầu:</label>
    <select id="rowStart" name="rowStart" required>
        <% for (char c = 'A'; c <= 'Z'; c++) {%>
        <option value="<%=c%>"><%=c%></option>
        <% } %>
    </select>

    <label>Hàng kết thúc:</label>
    <select id="rowEnd" name="rowEnd" required>
        <% for (char c = 'A'; c <= 'Z'; c++) {%>
        <option value="<%=c%>"><%=c%></option>
        <% }%>
    </select>

    <label>Số ghế mỗi hàng:</label>
    <input type="number" name="seatPerRow" min="1" required>

    <label>Giá VIP:</label>
    <input type="number" name="vipPrice" min="0" step="0.01" required>

    <label>Giá NORMAL:</label>
    <input type="number" name="normalPrice" min="0" step="0.01" required>

    <button type="submit">Tạo ghế</button>
</form>

<!-- Thông báo phân khu và loại ghế -->
<p id="seatInfo" style="color:blue; font-weight:bold;"></p>

<script>
    const rowStartEl = document.getElementById("rowStart");
    const rowEndEl = document.getElementById("rowEnd");
    const seatInfo = document.getElementById("seatInfo");

    // Quy định khu và số hàng
    const areaRows = {
        "TOP": ['A', 'B', 'C', 'D', 'E'],
        "LEFT": ['F', 'G', 'H', 'I', 'J'],
        "RIGHT": ['K', 'L', 'M', 'N', 'O'],
        "BOTTOM": ['P', 'Q', 'R', 'S', 'T']
    };

    // Số ghế tối đa mỗi hàng theo khu
    const maxSeatsPerRow = {
        "TOP": 12,
        "LEFT": 10,
        "RIGHT": 10,
        "BOTTOM": 12
    };

    // Xác định khu theo hàng
    function getArea(rowChar) {
        for (let area in areaRows) {
            if (areaRows[area].includes(rowChar))
                return area;
        }
        return "UNKNOWN";
    }

    // Xác định VIP/NORMAL
    function getSeatType(area, rowChar) {
        switch (area) {
            case "TOP":
                return rowChar <= 'B' ? "VIP" : "NORMAL";
            case "LEFT":
                return rowChar <= 'G' ? "VIP" : "NORMAL";
            case "RIGHT":
                return rowChar <= 'L' ? "VIP" : "NORMAL";
            case "BOTTOM":
                return rowChar <= 'Q' ? "VIP" : "NORMAL";
            default:
                return "NORMAL";
        }
    }

    // Cập nhật thông báo phân khu
    function updateSeatInfo() {
        let start = rowStartEl.value.charCodeAt(0);
        let end = rowEndEl.value.charCodeAt(0);

        if (start > end) {
            seatInfo.innerHTML = "❌ Hàng bắt đầu phải trước hàng kết thúc!";
            seatInfo.style.color = "red";
            return;
        }

        // Kiểm tra xem các hàng có thuộc nhiều khu khác nhau không
        let areas = new Set();
        for (let r = start; r <= end; r++) {
            let rowChar = String.fromCharCode(r);
            let area = getArea(rowChar);
            areas.add(area);
        }

        if (areas.size > 1) {
            seatInfo.innerHTML = "⚠️ Cảnh báo: Bạn đang chọn nhiều hàng thuộc các khu khác nhau!<br>" +
                "Các khu: <strong>" + Array.from(areas).join(", ") + "</strong><br>" +
                "Mỗi khu có giới hạn số ghế khác nhau. Vui lòng kiểm tra kỹ!";
            seatInfo.style.color = "orange";
        } else {
            seatInfo.style.color = "blue";
        }

        let infoText = areas.size > 1 ? seatInfo.innerHTML + "<br><br>" : "";
        infoText += "ℹ️ Thông tin chi tiết từng hàng:<br>";

        for (let r = start; r <= end; r++) {
            let rowChar = String.fromCharCode(r);
            let area = getArea(rowChar);
            let seatType = getSeatType(area, rowChar);
            let maxSeats = maxSeatsPerRow[area];
            
            infoText += "Hàng <strong>" + rowChar + "</strong>: Khu <strong>" + area + "</strong> " +
                    "(tối đa <strong>" + maxSeats + " ghế</strong>), " +
                    "<span style='color:" + (seatType === "VIP" ? "gold" : "black") + "'>" + seatType + "</span><br>";
        }

        seatInfo.innerHTML = infoText;
    }

    // Tự động cập nhật khi chọn start hoặc end
    rowStartEl.addEventListener("change", updateSeatInfo);
    rowEndEl.addEventListener("change", updateSeatInfo);
    updateSeatInfo();

    // Kiểm tra form trước khi submit
    document.getElementById("bulkSeatForm").addEventListener("submit", function (e) {
        let start = rowStartEl.value.charCodeAt(0);
        let end = rowEndEl.value.charCodeAt(0);
        let seatPerRow = parseInt(this.seatPerRow.value);
        let vipPrice = parseFloat(this.vipPrice.value);
        let normalPrice = parseFloat(this.normalPrice.value);

        if (start > end) {
            alert("❌ Hàng bắt đầu phải trước hàng kết thúc!");
            e.preventDefault();
            return;
        }

        if (seatPerRow <= 0 || vipPrice < 0 || normalPrice < 0) {
            alert("❌ Số ghế và giá phải lớn hơn hoặc bằng 0");
            e.preventDefault();
            return;
        }

        // Kiểm tra từng hàng có vượt quá số ghế tối đa không
        let errorMessages = [];
        
        for (let r = start; r <= end; r++) {
            let rowChar = String.fromCharCode(r);
            let area = getArea(rowChar);
            let maxSeats = maxSeatsPerRow[area];
            
            if (seatPerRow > maxSeats) {
                errorMessages.push("Hàng " + rowChar + " (khu " + area + ") tối đa " + maxSeats + " ghế");
            }
        }

        if (errorMessages.length > 0) {
            alert("❌ Lỗi số ghế vượt quá giới hạn:\n\n" + errorMessages.join("\n") + 
                  "\n\nBạn đang nhập: " + seatPerRow + " ghế/hàng");
            e.preventDefault();
            return;
        }

        // Kiểm tra số hàng trong mỗi khu
        const areaCount = {"TOP": 0, "LEFT": 0, "RIGHT": 0, "BOTTOM": 0};
        
        for (let r = start; r <= end; r++) {
            let rowChar = String.fromCharCode(r);
            let area = getArea(rowChar);
            areaCount[area]++;
        }

        for (let area in areaCount) {
            if (areaCount[area] > 0 && areaCount[area] > areaRows[area].length) {
                alert("❌ Khu " + area + " chỉ có " + areaRows[area].length + " hàng (" + areaRows[area].join(", ") + ")\n" +
                      "Bạn đang chọn " + areaCount[area] + " hàng trong khu này!");
                e.preventDefault();
                return;
            }
        }

        // Xác nhận trước khi submit nếu có nhiều khu
        let areas = new Set();
        for (let r = start; r <= end; r++) {
            areas.add(getArea(String.fromCharCode(r)));
        }

        if (areas.size > 1) {
            let confirm = window.confirm(
                "⚠️ Bạn đang tạo ghế cho nhiều khu khác nhau:\n" +
                Array.from(areas).join(", ") + "\n\n" +
                "Mỗi khu có giới hạn số ghế khác nhau.\n" +
                "Bạn có chắc chắn muốn tiếp tục?"
            );
            
            if (!confirm) {
                e.preventDefault();
                return;
            }
        }
    });
</script>