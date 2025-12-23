<%--
    Document   : edit
    Created on : Dec 19, 2025, 7:40:24 PM
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

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Sửa thông tin ghế</title>

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

            .readonly{
                background:#f3f4f6 !important;
                color:#111827 !important;
                font-weight: 800;
            }

            .type-chip{
                display:inline-flex;
                align-items:center;
                gap:8px;
                padding: 8px 12px;
                border-radius: 999px;
                font-weight: 950;
                letter-spacing:.2px;
                border: 1px solid rgba(0,0,0,.08);
                background: rgba(255,255,255,.92);
                color:#111827;
                box-shadow: 0 10px 25px rgba(0,0,0,.12);
                user-select:none;
            }
            .chip-vip{
                background: rgba(255, 193, 7, .20);
                border-color: rgba(255, 193, 7, .35);
                color:#7a5b00;
            }
            .chip-normal{
                background: rgba(17, 24, 39, .06);
                border-color: rgba(17, 24, 39, .12);
                color:#111827;
            }

            .btn{
                border-radius: 14px !important;
                font-weight: 850 !important;
            }

            /* Modal theme */
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
                    <div class="title-ico"><i class="fa-solid fa-pen-to-square"></i></div>
                    <div>
                        <h1>Sửa thông tin ghế</h1>
                        <div class="crumb">Admin / Seats / Edit</div>
                    </div>
                </div>
            </div>

            <div class="card-body">
                <form id="editSeatForm" method="post" action="<%=request.getContextPath()%>/admin/seats">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" value="<%=seat.getSeatID()%>">

                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Số ghế</label>
                            <input type="text" class="form-control readonly" value="<%=seat.getSeatNumber()%>" disabled>
                            <div class="form-text text-white-50">Không thể thay đổi</div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Hàng</label>
                            <input type="text" class="form-control readonly" value="<%=seat.getRowLabel()%>" disabled>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Cột</label>
                            <input type="text" class="form-control readonly" value="<%=seat.getColumnNumber()%>" disabled>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold d-flex align-items-center gap-2">
                                Loại ghế
                                <span id="seatTypeIndicator" class="type-chip"></span>
                            </label>

                            <select name="seatType" id="seatType" required class="form-select">
                                <option value="VIP" <%= "VIP".equals(seat.getSeatType()) ? "selected" : ""%>>VIP</option>
                                <option value="NORMAL" <%= "NORMAL".equals(seat.getSeatType()) ? "selected" : ""%>>NORMAL</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Giá (VNĐ)</label>
                            <input type="number"
                                   name="price"
                                   id="price"
                                   value="<%=seat.getPrice()%>"
                                   min="0" step="0.01" required
                                   class="form-control"
                                   placeholder="Nhập giá...">
                            <div class="form-text text-white-50">Giá phải ≥ 0</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Trạng thái</label>
                            <select name="isActive" id="isActive" required class="form-select">
                                <option value="true" <%= seat.getIsActive() ? "selected" : ""%>>✅ Hoạt động</option>
                                <option value="false" <%= !seat.getIsActive() ? "selected" : ""%>>❌ Vô hiệu hóa</option>
                            </select>
                        </div>
                    </div>

                    <div class="mt-4 d-flex gap-2 justify-content-end">
                        <a href="<%=request.getContextPath()%>/admin/seats" class="btn btn-outline-light">
                            <i class="fa-solid fa-xmark"></i> Hủy
                        </a>
                        <button type="submit" class="btn btn-success">
                            <i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi
                        </button>
                    </div>
                </form>
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
                        <h5 class="modal-title fw-bold">
                            <i class="fa-solid fa-circle-question text-info"></i> Xác nhận lưu
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="confirmModalBody"></div>
                    <div class="modal-footer" style="border:none;">
                        <button type="button" class="btn btn-outline-dark fw-bold" data-bs-dismiss="modal">
                            <i class="fa-solid fa-xmark"></i> Hủy
                        </button>
                        <button type="button" class="btn btn-success fw-bold" id="confirmYesBtn">
                            <i class="fa-solid fa-check"></i> Lưu
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            const seatTypeSelect = document.getElementById("seatType");
            const seatTypeIndicator = document.getElementById("seatTypeIndicator");
            const priceInput = document.getElementById("price");

            // Modal helpers
            const msgModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('msgModal'));
            const msgTitleEl = document.getElementById('msgModalTitle');
            const msgBodyEl = document.getElementById('msgModalBody');

            function showMessage(titleHtml, bodyHtml) {
                msgTitleEl.innerHTML = titleHtml || "<i class='fa-solid fa-triangle-exclamation text-warning'></i> Thông báo";
                msgBodyEl.innerHTML = bodyHtml || "";
                msgModal.show();
            }

            const confirmModal = bootstrap.Modal.getOrCreateInstance(document.getElementById('confirmModal'));
            const confirmBodyEl = document.getElementById('confirmModalBody');
            const confirmYesBtn = document.getElementById('confirmYesBtn');

            function askConfirm(bodyHtml, onYes) {
                confirmBodyEl.innerHTML = bodyHtml || "";
                confirmYesBtn.onclick = function () {
                    confirmModal.hide();
                    if (typeof onYes === "function")
                        onYes();
                };
                confirmModal.show();
            }

            // Indicator VIP/NORMAL (rõ chữ, không mờ)
            function updateSeatTypeIndicator() {
                const selectedType = seatTypeSelect.value;
                if (selectedType === "VIP") {
                    seatTypeIndicator.className = "type-chip chip-vip";
                    seatTypeIndicator.innerHTML = "<i class='fa-solid fa-star'></i> VIP";
                } else {
                    seatTypeIndicator.className = "type-chip chip-normal";
                    seatTypeIndicator.innerHTML = "<i class='fa-solid fa-chair'></i> NORMAL";
                }
            }

            seatTypeSelect.addEventListener("change", updateSeatTypeIndicator);
            updateSeatTypeIndicator();

            // Validate + confirm bằng modal
            document.getElementById("editSeatForm").addEventListener("submit", function (e) {
                e.preventDefault(); // chặn submit để mở confirm

                const price = parseFloat(priceInput.value);

                if (!Number.isFinite(price)) {
                    showMessage(
                            "<i class='fa-solid fa-triangle-exclamation text-warning'></i> Lỗi dữ liệu",
                            "❌ Vui lòng nhập <b>giá hợp lệ</b>!"
                            );
                    return;
                }

                if (price < 0) {
                    showMessage(
                            "<i class='fa-solid fa-triangle-exclamation text-warning'></i> Lỗi dữ liệu",
                            "❌ <b>Giá</b> không được âm!"
                            );
                    return;
                }

                const type = seatTypeSelect.value;
                const typeHtml = (type === "VIP")
                        ? "<span class='badge text-bg-warning text-dark fw-bold'><i class='fa-solid fa-star'></i> VIP</span>"
                        : "<span class='badge text-bg-secondary fw-bold'><i class='fa-solid fa-chair'></i> NORMAL</span>";

                askConfirm(
                        "Bạn có chắc chắn muốn lưu các thay đổi?<br><br>" +
                        "<div class='d-grid gap-2'>" +
                        "  <div>Loại ghế: " + typeHtml + "</div>" +
                        "  <div>Giá: <b>" + price.toLocaleString('vi-VN') + " VNĐ</b></div>" +
                        "</div>",
                        () => this.submit()
                );
            });
        </script>

    </body>
</html>
