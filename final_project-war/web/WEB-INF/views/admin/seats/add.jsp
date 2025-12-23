<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm ghế hàng loạt</title>

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
            }

            body{
                background:
                    radial-gradient(1200px 700px at 20% -10%, rgba(79,70,229,.28), transparent 55%),
                    radial-gradient(900px 500px at 80% 0%, rgba(6,182,212,.22), transparent 60%),
                    linear-gradient(180deg, var(--bg), #070b14);
                min-height:100vh;
                color:#e6ecff;
                font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, "Noto Sans", "Helvetica Neue", sans-serif;
                padding: 22px;
            }

            .card-glass{
                border-radius: 18px;
                background: rgba(255,255,255,.06);
                border: 1px solid var(--line);
                backdrop-filter: blur(10px);
                box-shadow: 0 18px 55px rgba(0,0,0,.35);
                overflow:hidden;
            }

            .card-head{
                padding: 14px 16px;
                border-bottom: 1px solid var(--line);
                display:flex;
                gap:12px;
                align-items:center;
                justify-content:space-between;
            }
            .title-wrap{
                display:flex;
                gap:12px;
                align-items:center;
            }
            .title-ico{
                width:44px;
                height:44px;
                border-radius:16px;
                display:grid;
                place-items:center;
                background:rgba(255,255,255,.08);
                border:1px solid var(--line);
            }
            .card-head h1{
                font-size: 18px;
                margin:0;
                font-weight: 900;
                letter-spacing:.2px;
            }
            .crumb{
                color: var(--muted);
                font-weight: 650;
                font-size: 12px;
                margin-top:2px;
            }

            .card-body{
                padding: 16px;
            }

            .form-control, .form-select{
                border-radius: 14px !important;
            }

            .help-box{
                margin-top: 12px;
                border-radius: 18px;
                overflow: hidden;
                background: rgba(255,255,255,.96);
                box-shadow: 0 22px 70px rgba(0,0,0,.35);
                color:#0b1220;
            }
            .help-head{
                background:#0f1b33;
                color:#e8efff;
                padding: 10px 14px;
                font-weight: 900;
                letter-spacing:.2px;
                display:flex;
                align-items:center;
                gap:10px;
            }
            .help-content{
                padding: 12px 14px;
                font-weight: 650;
            }

            /* text colors in info */
            .text-vip{
                color:#b8860b; /* vàng đậm dễ đọc trên nền trắng */
                font-weight: 900;
            }
            .text-normal{
                color:#111827;
                font-weight: 900;
            }

            /* Buttons */
            .btn{
                border-radius: 14px !important;
                font-weight: 850 !important;
            }

            /* Modal style match theme */
            .modal-content{
                border-radius: 18px;
                overflow:hidden;
            }
            .modal-header.theme{
                background:#0f1b33;
                color:#e8efff;
                border:none;
            }
            .modal-body{
                color:#111827;
            }
        </style>
    </head>

    <body>

        <div class="card-glass">
            <div class="card-head">
                <div class="title-wrap">
                    <div class="title-ico"><i class="fa-solid fa-couch"></i></div>
                    <div>
                        <h1>Thêm ghế hàng loạt</h1>
                        <div class="crumb">Admin / Seats / Bulk Create</div>
                    </div>
                </div>

                <a class="btn btn-outline-light" href="<%=request.getContextPath()%>/admin/seats">
                    <i class="fa-solid fa-arrow-left"></i> Quay về danh sách ghế
                </a>
            </div>

            <div class="card-body">

                <form id="bulkSeatForm" method="post" action="<%=request.getContextPath()%>/admin/seats">
                    <input type="hidden" name="action" value="bulkCreate">

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Hàng bắt đầu</label>
                            <select id="rowStart" name="rowStart" class="form-select" required>
                                <% for (char c = 'A'; c <= 'Z'; c++) {%>
                                <option value="<%=c%>"><%=c%></option>
                                <% } %>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Hàng kết thúc</label>
                            <select id="rowEnd" name="rowEnd" class="form-select" required>
                                <% for (char c = 'A'; c <= 'Z'; c++) {%>
                                <option value="<%=c%>"><%=c%></option>
                                <% }%>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Số ghế mỗi hàng</label>
                            <input type="number" name="seatPerRow" min="1" required class="form-control" placeholder="VD: 10">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Giá VIP</label>
                            <input type="number" name="vipPrice" min="0" step="0.01" required class="form-control" placeholder="VD: 200000">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Giá NORMAL</label>
                            <input type="number" name="normalPrice" min="0" step="0.01" required class="form-control" placeholder="VD: 150000">
                        </div>
                    </div>

                    <div class="mt-3 d-flex gap-2 justify-content-end">
                        <button type="button" class="btn btn-outline-light" onclick="resetBulkSeatForm()">
                            <i class="fa-solid fa-rotate-left"></i> Đặt lại
                        </button>
                        <button type="submit" class="btn btn-warning">
                            <i class="fa-solid fa-circle-plus"></i> Tạo ghế
                        </button>
                    </div>
                </form>

                <!-- Info box -->
                <div class="help-box" id="seatInfoBox" style="display:none;">
                    <div class="help-head" id="seatInfoHead">
                        <i class="fa-solid fa-circle-info"></i>
                        <span id="seatInfoTitle">Thông tin</span>
                    </div>
                    <div class="help-content" id="seatInfo"></div>
                </div>

            </div>
        </div>

        <!-- ================= MODAL: Message (replace alert) ================= -->
        <div class="modal fade" id="msgModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header theme">
                        <h5 class="modal-title fw-bold" id="msgModalTitle">
                            <i class="fa-solid fa-triangle-exclamation text-warning"></i> Thông báo
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="msgModalBody"></div>
                    <div class="modal-footer" style="border:none;">
                        <button type="button" class="btn btn-outline-dark fw-bold" data-bs-dismiss="modal">
                            <i class="fa-solid fa-xmark"></i> Đóng
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- ================= MODAL: Confirm (replace confirm) ================= -->
        <div class="modal fade" id="confirmModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header theme">
                        <h5 class="modal-title fw-bold" id="confirmModalTitle">
                            <i class="fa-solid fa-circle-question text-info"></i> Xác nhận
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="confirmModalBody"></div>
                    <div class="modal-footer" style="border:none;">
                        <button type="button" class="btn btn-outline-dark fw-bold" data-bs-dismiss="modal">
                            <i class="fa-solid fa-xmark"></i> Hủy
                        </button>
                        <button type="button" class="btn btn-warning fw-bold" id="confirmYesBtn">
                            <i class="fa-solid fa-check"></i> Tiếp tục
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                            const rowStartEl = document.getElementById("rowStart");
                            const rowEndEl = document.getElementById("rowEnd");
                            const seatInfoBox = document.getElementById("seatInfoBox");
                            const seatInfo = document.getElementById("seatInfo");
                            const seatInfoTitle = document.getElementById("seatInfoTitle");
                            const seatInfoHead = document.getElementById("seatInfoHead");

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

                            function getArea(rowChar) {
                                for (let area in areaRows) {
                                    if (areaRows[area].includes(rowChar))
                                        return area;
                                }
                                return "UNKNOWN";
                            }

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

                            function showInfoBox(kind, title, html) {
                                seatInfoBox.style.display = "block";
                                seatInfoTitle.textContent = title || "Thông tin";
                                seatInfo.innerHTML = html || "";

                                // đổi màu header theo loại
                                if (kind === "error") {
                                    seatInfoHead.style.background = "#ef4444";
                                } else if (kind === "warn") {
                                    seatInfoHead.style.background = "#f59e0b";
                                } else {
                                    seatInfoHead.style.background = "#0f1b33";
                                }
                            }

                            function updateSeatInfo() {
                                let start = rowStartEl.value.charCodeAt(0);
                                let end = rowEndEl.value.charCodeAt(0);

                                if (start > end) {
                                    showInfoBox("error", "Lỗi", "❌ <b>Hàng bắt đầu</b> phải trước <b>hàng kết thúc</b>!");
                                    return;
                                }

                                // detect multi areas
                                let areas = new Set();
                                for (let r = start; r <= end; r++) {
                                    areas.add(getArea(String.fromCharCode(r)));
                                }

                                let header = "info";
                                let topHtml = "";

                                if (areas.size > 1) {
                                    header = "warn";
                                    topHtml =
                                            "⚠️ <b>Cảnh báo:</b> Bạn đang chọn nhiều hàng thuộc các khu khác nhau!<br>" +
                                            "Các khu: <b>" + Array.from(areas).join(", ") + "</b><br>" +
                                            "Mỗi khu có giới hạn số ghế khác nhau. Vui lòng kiểm tra kỹ!<hr class='my-2'>";
                                }

                                let html = topHtml + "ℹ️ <b>Thông tin chi tiết từng hàng:</b><br>";

                                for (let r = start; r <= end; r++) {
                                    let rowChar = String.fromCharCode(r);
                                    let area = getArea(rowChar);
                                    let seatType = getSeatType(area, rowChar);
                                    let maxSeats = maxSeatsPerRow[area] ?? "-";

                                    const typeHtml = (seatType === "VIP")
                                            ? "<span class='text-vip'><i class='fa-solid fa-star'></i> VIP</span>"
                                            : "<span class='text-normal'><i class='fa-solid fa-chair'></i> NORMAL</span>";

                                    html +=
                                            "Hàng <b>" + rowChar + "</b>: Khu <b>" + area + "</b> " +
                                            "(tối đa <b>" + maxSeats + " ghế</b>), " + typeHtml + "<br>";
                                }

                                showInfoBox(header, (areas.size > 1 ? "Cảnh báo" : "Thông tin"), html);
                            }

                            rowStartEl.addEventListener("change", updateSeatInfo);
                            rowEndEl.addEventListener("change", updateSeatInfo);
                            updateSeatInfo();

                            // ===== Replace alert / confirm by Bootstrap Modals =====
                            const msgModalEl = document.getElementById('msgModal');
                            const msgModal = bootstrap.Modal.getOrCreateInstance(msgModalEl);
                            const msgTitleEl = document.getElementById('msgModalTitle');
                            const msgBodyEl = document.getElementById('msgModalBody');

                            function showMessage(title, htmlBody) {
                                msgTitleEl.innerHTML = title || "<i class='fa-solid fa-triangle-exclamation text-warning'></i> Thông báo";
                                msgBodyEl.innerHTML = htmlBody || "";
                                msgModal.show();
                            }

                            const confirmModalEl = document.getElementById('confirmModal');
                            const confirmModal = bootstrap.Modal.getOrCreateInstance(confirmModalEl);
                            const confirmBodyEl = document.getElementById('confirmModalBody');
                            const confirmYesBtn = document.getElementById('confirmYesBtn');

                            function askConfirm(htmlBody, onYes) {
                                confirmBodyEl.innerHTML = htmlBody || "";
                                // reset handler
                                confirmYesBtn.onclick = function () {
                                    confirmModal.hide();
                                    if (typeof onYes === "function")
                                        onYes();
                                };
                                confirmModal.show();
                            }

                            function resetBulkSeatForm() {
                                document.getElementById("bulkSeatForm").reset();
                                updateSeatInfo();
                            }

                            // Validate before submit (no default alert/confirm)
                            document.getElementById("bulkSeatForm").addEventListener("submit", function (e) {
                                e.preventDefault(); // giữ lại để quyết định submit sau

                                let start = rowStartEl.value.charCodeAt(0);
                                let end = rowEndEl.value.charCodeAt(0);

                                let seatPerRow = parseInt(this.seatPerRow.value);
                                let vipPrice = parseFloat(this.vipPrice.value);
                                let normalPrice = parseFloat(this.normalPrice.value);

                                if (start > end) {
                                    showMessage(
                                            "<i class='fa-solid fa-triangle-exclamation text-warning'></i> Lỗi dữ liệu",
                                            "❌ <b>Hàng bắt đầu</b> phải trước <b>hàng kết thúc</b>!"
                                            );
                                    return;
                                }

                                if (!Number.isFinite(seatPerRow) || seatPerRow <= 0 || !Number.isFinite(vipPrice) || vipPrice < 0 || !Number.isFinite(normalPrice) || normalPrice < 0) {
                                    showMessage(
                                            "<i class='fa-solid fa-triangle-exclamation text-warning'></i> Lỗi dữ liệu",
                                            "❌ <b>Số ghế</b> phải > 0 và <b>giá</b> phải ≥ 0."
                                            );
                                    return;
                                }

                                // check max seats per row
                                let errorMessages = [];
                                for (let r = start; r <= end; r++) {
                                    let rowChar = String.fromCharCode(r);
                                    let area = getArea(rowChar);
                                    let maxSeats = maxSeatsPerRow[area];

                                    if (maxSeats != null && seatPerRow > maxSeats) {
                                        errorMessages.push("Hàng <b>" + rowChar + "</b> (khu <b>" + area + "</b>) tối đa <b>" + maxSeats + "</b> ghế");
                                    }
                                }

                                if (errorMessages.length > 0) {
                                    showMessage(
                                            "<i class='fa-solid fa-triangle-exclamation text-warning'></i> Vượt giới hạn số ghế",
                                            "❌ Bạn đang nhập <b>" + seatPerRow + " ghế/hàng</b>. Các hàng bị vượt giới hạn:<br><br>" +
                                            "• " + errorMessages.join("<br>• ")
                                            );
                                    return;
                                }

                                // check rows per area count
                                const areaCount = {"TOP": 0, "LEFT": 0, "RIGHT": 0, "BOTTOM": 0};
                                for (let r = start; r <= end; r++) {
                                    let rowChar = String.fromCharCode(r);
                                    let area = getArea(rowChar);
                                    if (areaCount[area] != null)
                                        areaCount[area]++;
                                }

                                for (let area in areaCount) {
                                    if (areaCount[area] > 0 && areaRows[area] && areaCount[area] > areaRows[area].length) {
                                        showMessage(
                                                "<i class='fa-solid fa-triangle-exclamation text-warning'></i> Lỗi phạm vi hàng",
                                                "❌ Khu <b>" + area + "</b> chỉ có <b>" + areaRows[area].length + "</b> hàng (" + areaRows[area].join(", ") + ").<br>" +
                                                "Bạn đang chọn <b>" + areaCount[area] + "</b> hàng trong khu này!"
                                                );
                                        return;
                                    }
                                }

                                // confirm when multi-area
                                let areas = new Set();
                                for (let r = start; r <= end; r++) {
                                    areas.add(getArea(String.fromCharCode(r)));
                                }

                                const doSubmit = () => this.submit();

                                if (areas.size > 1) {
                                    askConfirm(
                                            "⚠️ Bạn đang tạo ghế cho <b>nhiều khu</b>: <b>" + Array.from(areas).join(", ") + "</b>.<br><br>" +
                                            "Mỗi khu có giới hạn số ghế khác nhau. Bạn có chắc chắn muốn tiếp tục?",
                                            doSubmit
                                            );
                                } else {
                                    doSubmit();
                                }
                            });
        </script>

    </body>
</html>
