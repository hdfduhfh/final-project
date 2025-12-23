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
            }

            /* Layout */
            .admin-wrap{
                display:flex;
                min-height:100vh;
            }
            .sidebar{
                width: 270px;
                background: rgba(15,27,51,.86);
                border-right: 1px solid var(--line);
                backdrop-filter: blur(10px);
                padding: 18px 14px;
                position: sticky;
                top:0;
                height:100vh;
            }
            .brand{
                display:flex;
                align-items:center;
                gap:10px;
                padding:10px 12px;
                border-radius:14px;
                background: rgba(255,255,255,.06);
                border: 1px solid var(--line);
            }
            .brand .logo{
                width: 38px;
                height: 38px;
                border-radius: 12px;
                display:grid;
                place-items:center;
                background: linear-gradient(135deg, rgba(79,70,229,.9), rgba(6,182,212,.9));
                box-shadow: 0 14px 35px rgba(0,0,0,.35);
            }
            .brand .title{
                line-height: 1.1;
                font-weight: 800;
                letter-spacing: .2px;
            }
            .brand small{
                color: var(--muted);
                font-weight: 600;
            }

            .nav-group{
                margin-top: 14px;
            }
            .nav-item{
                display:flex;
                align-items:center;
                gap:10px;
                padding: 10px 12px;
                border-radius: 12px;
                color:#dbe5ff;
                text-decoration:none;
                border: 1px solid transparent;
            }
            .nav-item:hover{
                background: rgba(255,255,255,.06);
                border-color: var(--line);
            }
            .nav-item.active{
                background: rgba(6,182,212,.16);
                border-color: rgba(6,182,212,.35);
            }
            .nav-item i{
                width:20px;
                text-align:center;
                color:#bcd0ff;
            }

            .content{
                flex:1;
                padding: 22px 22px 28px;
            }

            .topbar{
                display:flex;
                gap:12px;
                align-items:center;
                justify-content:space-between;
                padding: 14px 16px;
                border-radius: 18px;
                background: rgba(255,255,255,.06);
                border: 1px solid var(--line);
                backdrop-filter: blur(10px);
                box-shadow: 0 18px 55px rgba(0,0,0,.35);
            }
            .page-h{
                display:flex;
                gap:12px;
                align-items:center;
            }
            .page-h h1{
                font-size: 18px;
                margin:0;
                font-weight: 900;
                letter-spacing:.2px;
            }
            .page-h .crumb{
                color: var(--muted);
                font-weight: 600;
                font-size: 12px;
            }

            .panel{
                margin-top: 14px;
                padding: 14px;
                border-radius: 18px;
                background: rgba(255,255,255,.06);
                border: 1px solid var(--line);
                backdrop-filter: blur(10px);
            }

            .table-wrap{
                margin-top: 12px;
                border-radius: 18px;
                overflow: hidden;
                background: rgba(255,255,255,.96);
                box-shadow: 0 22px 70px rgba(0,0,0,.35);
            }
            table thead th{
                background: #0f1b33 !important;
                color: #e8efff !important;
                border: none !important;
                white-space: nowrap;
                font-size: 13px;
                letter-spacing: .2px;
            }
            table tbody td{
                color: #0b1220;
                vertical-align: middle;
            }

            .btn-icon{
                width: 36px;
                height: 36px;
                display:inline-grid;
                place-items:center;
                border-radius: 12px;
            }

            .badge-pill{
                display:inline-flex;
                align-items:center;
                gap:6px;
                padding: 6px 12px;
                border-radius: 999px;
                font-weight: 950;               /* đậm hơn */
                font-size: 13px;                /* to hơn chút */
                letter-spacing: .2px;
                border: 1px solid rgba(255,255,255,.18);
                background: rgba(255,255,255,.12);
                color:#eaf2ff;                   /* chữ sáng rõ */
                box-shadow: 0 10px 28px rgba(0,0,0,.25);
            }

            /* VIP: chữ vàng sáng, nền tối hơn */
            .b-vip{
                background: rgba(245,158,11,.18);
                border-color: rgba(245,158,11,.45);
                color: #ffdd8a;                  /* vàng rõ */
            }
            .b-vip i{
                color:#ffd24d;
            }

            /* NORMAL: chữ xanh nhạt sáng, nền tối hơn */
            .b-normal{
                background: rgba(148,163,184,.18);
                border-color: rgba(148,163,184,.45);
                color: #eaf2ff;                  /* trắng xanh rõ */
            }
            .b-normal i{
                color:#cbd5e1;
            }

            .b-vip{
                background: rgba(245,158,11,.12);
                border-color: rgba(245,158,11,.25);
                color:#7c4a00;
            }
            .b-normal{
                background: rgba(148,163,184,.18);
                border-color: rgba(148,163,184,.35);
                color:#334155;
            }
            .b-active{
                background: rgba(34,197,94,.12);
                border-color: rgba(34,197,94,.25);
                color:#14532d;
            }
            .b-inactive{
                background: rgba(239,68,68,.12);
                border-color: rgba(239,68,68,.25);
                color:#7f1d1d;
            }

            /* details summary look */
            details.control-panel{
                margin-top: 14px;
                border-radius: 18px;
                overflow: hidden;
                background: rgba(255,255,255,.06);
                border: 1px solid var(--line);
                backdrop-filter: blur(10px);
            }
            details.control-panel summary{
                padding: 14px 16px;
                font-weight: 900;
                cursor: pointer;
                list-style: none;
                display:flex;
                align-items:center;
                justify-content:space-between;
                color:#e6ecff;
            }
            details.control-panel summary::-webkit-details-marker{
                display:none;
            }
            details.control-panel summary::after{
                content:'\f107';
                font-family:"Font Awesome 6 Free";
                font-weight: 900;
                opacity:.9;
            }
            details.control-panel[open] summary::after{
                content:'\f106';
            }

            .panel-content{
                padding: 16px;
            }

            .bulk-grid{
                display:grid;
                grid-template-columns: 1fr 1fr;
                gap: 12px;
            }
            @media (max-width: 992px){
                .sidebar{
                    display:none;
                }
                .bulk-grid{
                    grid-template-columns:1fr;
                }
            }

            .card-price{
                background: rgba(255,255,255,.92);
                border-radius: 16px;
                padding: 14px;
                border: 1px solid rgba(0,0,0,.06);
                box-shadow: 0 18px 45px rgba(0,0,0,.18);
                color:#0b1220;
            }
            .card-vip{
                border-left: 4px solid #f59e0b;
            }
            .card-normal{
                border-left: 4px solid #94a3b8;
            }

            .form-control{
                border-radius: 12px;
            }

            .empty{
                padding: 48px 16px;
                text-align:center;
                color:#6b7280;
            }
            /* ✅ FIX: ép badge trên topbar không bị mờ */
            .topbar .badge-pill{
                opacity: 1 !important;
                filter: none !important;
                color: #ffffff !important;
                font-weight: 950 !important;
                text-shadow: 0 1px 0 rgba(0,0,0,.55) !important; /* tăng độ nét */
            }

            /* ✅ FIX: badge Normal rõ hơn (nền + viền rõ) */
            .topbar .badge-pill.b-normal{
                background: rgba(255,255,255,.14) !important;
                border: 1px solid rgba(255,255,255,.38) !important;
                color: #ffffff !important;
            }

            /* icon cũng ép sáng */
            .topbar .badge-pill.b-normal i{
                color: #ffffff !important;
                opacity: 1 !important;
            }

        </style>
    </head>

    <body>
        <div class="admin-wrap">

            <!-- SIDEBAR -->
            <aside class="sidebar">
                <div class="brand">
                    <div class="logo"><i class="fa-solid fa-masks-theater"></i></div>
                    <div>
                        <div class="title">Theater Admin</div>
                        <small>Quản lý ghế</small>
                    </div>
                </div>

                <div class="nav-group">
                    <a class="nav-item active" href="<%=request.getContextPath()%>/admin/seats">
                        <i class="fa-solid fa-couch"></i> Quản lý ghế
                    </a>
                </div>

                <hr style="border-color: var(--line);">

                <div class="px-2">
                    <div class="text-uppercase" style="font-size:12px; color:var(--muted); font-weight:900; letter-spacing:.3px;">
                        Quick actions
                    </div>
                    <div class="mt-2 d-grid gap-2">
                        <a class="btn btn-outline-light fw-bold" href="<%=request.getContextPath()%>/admin/dashboard" style="border-radius:14px;">
                            <i class="fa-solid fa-arrow-left"></i> Về Dashboard
                        </a>
                        <a href="<%=request.getContextPath()%>/admin/seats?action=add" class="btn btn-light fw-bold" style="border-radius:14px;">
                            <i class="fa-solid fa-circle-plus"></i> Thêm ghế mới
                        </a>
                    </div>
                </div>
            </aside>

            <!-- CONTENT -->
            <main class="content">

                <!-- TOPBAR -->
                <div class="topbar">
                    <div class="page-h">
                        <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                            <i class="fa-solid fa-couch"></i>
                        </div>
                        <div>
                            <h1>Quản lý ghế rạp</h1>
                            <div class="crumb">Admin / Seat Management / List</div>
                        </div>
                    </div>

                    <div class="d-none d-md-flex gap-2">
                        <span class="badge-pill b-vip">
                            <i class="fa-solid fa-star"></i>
                            VIP: <span style="font-weight:1000;"><%=vipCount%></span>
                        </span>

                        <span class="badge-pill b-normal">
                            <i class="fa-solid fa-chair"></i>
                            Thường: <span style="font-weight:1000;"><%=normalCount%></span>
                        </span>

                    </div>
                </div>

                <!-- ALERT (server) -->
                <%
                    String errorMsg = (String) request.getAttribute("error");
                    if (errorMsg != null && !errorMsg.isEmpty()) {
                %>
                <div class="alert alert-danger mt-3 mb-0 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <div><%= errorMsg%></div>
                </div>
                <% }%>

                <!-- BULK UPDATE -->
                <details class="control-panel">
                    <summary>
                        <span><i class="fa-solid fa-money-bill-wave"></i> Cập nhật giá hàng loạt</span>
                    </summary>

                    <div class="panel-content">
                        <form id="bulkPriceForm" method="post" action="<%=request.getContextPath()%>/admin/seats">
                            <input type="hidden" name="action" value="bulkUpdatePrice">

                            <div class="bulk-grid">
                                <div class="card-price card-vip">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <div class="fw-bold">
                                            ⭐ Ghế VIP (<%=vipCount%>)
                                        </div>
                                        <input type="checkbox" name="updateVip" id="updateVip" value="true"
                                               style="transform: scale(1.4); cursor: pointer;">
                                    </div>

                                    <label class="fw-semibold mb-1">Giá mới (VNĐ):</label>
                                    <input type="number" name="vipPrice" id="vipPrice" min="0" step="1000"
                                           placeholder="Nhập giá VIP..." class="form-control" disabled>
                                </div>

                                <div class="card-price card-normal">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <div class="fw-bold">
                                            🪑 Ghế Thường (<%=normalCount%>)
                                        </div>
                                        <input type="checkbox" name="updateNormal" id="updateNormal" value="true"
                                               style="transform: scale(1.4); cursor: pointer;">
                                    </div>

                                    <label class="fw-semibold mb-1">Giá mới (VNĐ):</label>
                                    <input type="number" name="normalPrice" id="normalPrice" min="0" step="1000"
                                           placeholder="Nhập giá thường..." class="form-control" disabled>
                                </div>
                            </div>

                            <div id="updateInfo"
                                 class="mt-3"
                                 style="background: rgba(6,182,212,.12); border:1px solid rgba(6,182,212,.22); color:#063b44; padding: 12px 14px; border-radius: 14px; display:none;">
                                <i class="fa-solid fa-circle-info"></i>
                                <strong class="ms-1">Xác nhận thay đổi:</strong>
                                <div id="updateSummary" class="mt-1" style="margin-left: 22px;"></div>
                            </div>

                            <div class="mt-3 d-flex justify-content-end gap-2">
                                <button type="button" onclick="resetBulkForm()" class="btn btn-outline-light fw-bold" style="border-radius:14px;">
                                    <i class="fa-solid fa-rotate-left"></i> Đặt lại
                                </button>
                                <button type="submit" id="submitBtn" class="btn btn-warning fw-bold" style="border-radius:14px;" disabled>
                                    <i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi
                                </button>
                            </div>
                        </form>
                    </div>
                </details>

                <!-- TABLE -->
                <div class="table-wrap">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th style="width: 90px;">Số ghế</th>
                                    <th>Hàng / Cột</th>
                                    <th>Loại ghế</th>
                                    <th>Giá vé</th>
                                    <th>Trạng thái</th>
                                    <th style="text-align:center; width: 180px;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (seats != null && !seats.isEmpty()) {
                                        for (Seat seat : seats) {
                                            String seatType = seat.getSeatType();
                                            boolean isVip = "VIP".equals(seatType);
                                            boolean isActive = seat.getIsActive();

                                            String deleteUrl = request.getContextPath() + "/admin/seats?action=delete&id=" + seat.getSeatID();
                                            String seatNumber = seat.getSeatNumber();
                                %>
                                <tr>
                                    <td class="fw-bold">
                                        <i class="fa-solid fa-ticket-simple text-primary"></i>
                                        <span class="ms-1"><%=seatNumber%></span>
                                    </td>
                                    <td class="text-secondary">
                                        Hàng <%=seat.getRowLabel()%> - Cột <%=seat.getColumnNumber()%>
                                    </td>
                                    <td>
                                        <% if (isVip) { %>
                                        <span class="badge-pill b-vip"><i class="fa-solid fa-star"></i> VIP</span>
                                        <% } else { %>
                                        <span class="badge-pill b-normal"><i class="fa-solid fa-chair"></i> NORMAL</span>
                                        <% }%>
                                    </td>
                                    <td class="fw-bold" style="font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace; color:#0b3b47;">
                                        <%=String.format("%,.0f", seat.getPrice())%> ₫
                                    </td>
                                    <td>
                                        <% if (isActive) { %>
                                        <span class="badge-pill b-active"><i class="fa-solid fa-circle-check"></i> Hoạt động</span>
                                        <% } else { %>
                                        <span class="badge-pill b-inactive"><i class="fa-solid fa-circle-xmark"></i> Bảo trì</span>
                                        <% }%>
                                    </td>
                                    <td class="text-center text-nowrap">
                                        <a href="<%=request.getContextPath()%>/admin/seats?action=edit&id=<%=seat.getSeatID()%>"
                                           class="btn btn-primary btn-icon"
                                           title="Sửa">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </a>

                                        <!-- ❌ bỏ confirm() mặc định -> dùng Bootstrap Modal -->
                                        <button type="button"
                                                class="btn btn-danger btn-icon"
                                                title="Xóa"
                                                onclick="openDeleteSeatModal('<%=deleteUrl%>', '<%=seatNumber.replace("'", "\\'")%>')">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td colspan="6" class="empty">
                                        <i class="fa-regular fa-folder-open fa-2x"></i>
                                        <div class="mt-2 fw-bold">Chưa có dữ liệu ghế.</div>
                                    </td>
                                </tr>
                                <% }%>
                            </tbody>
                        </table>
                    </div>
                </div>

            </main>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

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
                                                                summaryText += "<div>⭐ <b>" + vipCount + " ghế VIP</b> → <b style='color:#b45309'>" +
                                                                        vipPrice.toLocaleString('vi-VN') + " VNĐ</b></div>";
                                                            }

                                                            if (normalChecked && normalPrice >= 0 && !isNaN(normalPrice)) {
                                                                summaryText += "<div>🪑 <b>" + normalCount + " ghế Thường</b> → <b style='color:#0369a1'>" +
                                                                        normalPrice.toLocaleString('vi-VN') + " VNĐ</b></div>";
                                                            }

                                                            updateSummary.innerHTML = summaryText;
                                                        } else {
                                                            updateInfo.style.display = "none";
                                                        }
                                                    }

                                                    updateVipCheckbox.addEventListener("change", function () {
                                                        vipPriceInput.disabled = !this.checked;
                                                        if (!this.checked)
                                                            vipPriceInput.value = "";
                                                        updateButtonState();
                                                    });

                                                    updateNormalCheckbox.addEventListener("change", function () {
                                                        normalPriceInput.disabled = !this.checked;
                                                        if (!this.checked)
                                                            normalPriceInput.value = "";
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

        <!-- ===== DELETE CONFIRM MODAL (Bootstrap) ===== -->
        <div class="modal fade" id="deleteSeatModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content" style="border-radius:18px; overflow:hidden;">
                    <div class="modal-header" style="background:#0f1b33; color:#e8efff; border:none;">
                        <h5 class="modal-title fw-bold">
                            <i class="fa-solid fa-triangle-exclamation text-warning"></i>
                            Xác nhận xóa
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body text-dark">
                        <div class="d-flex align-items-start gap-3">
                            <div style="width:46px;height:46px;border-radius:16px;display:grid;place-items:center;background:rgba(239,68,68,.12);">
                                <i class="fa-solid fa-trash-can text-danger fs-4"></i>
                            </div>

                            <div>
                                <div class="fw-bold mb-1">Bạn chắc chắn muốn xóa ghế này?</div>
                                <div class="text-secondary">
                                    Ghế: <span id="deleteSeatName" class="fw-bold"></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer" style="border:none;">
                        <button type="button" class="btn btn-outline-dark fw-bold" data-bs-dismiss="modal">
                            <i class="fa-solid fa-xmark"></i> Hủy
                        </button>

                        <a href="#" id="deleteSeatConfirmBtn" class="btn btn-danger fw-bold">
                            <i class="fa-solid fa-trash"></i> Xóa
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function openDeleteSeatModal(deleteUrl, seatNumber) {
                const nameEl = document.getElementById('deleteSeatName');
                const confirmBtn = document.getElementById('deleteSeatConfirmBtn');

                if (nameEl)
                    nameEl.textContent = seatNumber || '';
                if (confirmBtn)
                    confirmBtn.setAttribute('href', deleteUrl || '#');

                const modalEl = document.getElementById('deleteSeatModal');
                const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                modal.show();
            }
        </script>

    </body>
</html>
