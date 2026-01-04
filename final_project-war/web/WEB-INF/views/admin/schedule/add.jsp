<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm Lịch chiếu</title>

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

            .card-form{
                margin-top: 14px;
                border-radius: 18px;
                overflow: hidden;
                background: rgba(255,255,255,.96);
                box-shadow: 0 22px 70px rgba(0,0,0,.35);
            }
            .card-form .card-header{
                background: #0f1b33;
                color: #e8efff;
                border: none;
                padding: 14px 16px;
                font-weight: 900;
                letter-spacing: .2px;
            }

            .req{
                color:#ef4444;
                font-weight:900;
            }

            .form-control, .form-select{
                border-radius: 12px;
            }
            .btn{
                border-radius: 14px;
            }

            /* showtime items */
            .showtime-item{
                display:flex;
                align-items:flex-start;
                gap:10px;
                margin-bottom:10px;
            }
            .showtime-col{
                flex: 0 0 260px;
                min-width: 240px;
            }
            .showtime-meta{
                margin-top: 6px;
                font-size: 12.5px;
                color: #6b7280;
                font-weight: 700;
            }
            .showtime-meta .badge{
                border-radius: 999px;
                font-weight: 800;
            }
            .icon-btn{
                width: 40px;
                height: 40px;
                display:inline-grid;
                place-items:center;
                border-radius: 12px;
            }

            @media (max-width: 992px){
                .sidebar{
                    display:none;
                }
                .showtime-item{
                    flex-direction:column;
                }
                .showtime-col{
                    width:100%;
                    flex: none;
                }
            }
        </style>

        <script>
            // ✅ Không giới hạn số lượng row tạo trên UI
            const MAX_TIMES = Number.POSITIVE_INFINITY;

            function showNoticeModal(title, message, type) {
                const modalEl = document.getElementById("noticeModal");
                if (!modalEl)
                    return;

                const titleEl = document.getElementById("noticeModalTitle");
                const msgEl = document.getElementById("noticeModalMsg");
                const iconEl = document.getElementById("noticeModalIcon");
                const headerEl = modalEl.querySelector(".modal-header");

                titleEl.textContent = title || "Thông báo";
                msgEl.innerHTML = message || "";

                headerEl.classList.remove("text-bg-danger", "text-bg-warning", "text-bg-info", "text-bg-success");

                const t = (type || "info").toLowerCase();
                if (t === "danger") {
                    headerEl.classList.add("text-bg-danger");
                    iconEl.className = "fa-solid fa-circle-xmark me-2";
                } else if (t === "warning") {
                    headerEl.classList.add("text-bg-warning");
                    iconEl.className = "fa-solid fa-triangle-exclamation me-2";
                } else if (t === "success") {
                    headerEl.classList.add("text-bg-success");
                    iconEl.className = "fa-solid fa-circle-check me-2";
                } else {
                    headerEl.classList.add("text-bg-info");
                    iconEl.className = "fa-solid fa-circle-info me-2";
                }

                bootstrap.Modal.getOrCreateInstance(modalEl).show();
            }

            // ====== Bộ đếm: còn bao nhiêu ngày nữa sẽ chiếu (timezone VN) ======
            function calcCountdownDaysVN(datetimeLocalStr) {
                if (!datetimeLocalStr)
                    return null;

                const parts = datetimeLocalStr.split("T");
                if (parts.length !== 2)
                    return null;
                const datePart = parts[0];

                const todayVN = new Date().toLocaleDateString('en-CA', {timeZone: 'Asia/Ho_Chi_Minh'});

                const d1 = new Date(todayVN + "T00:00:00");
                const d2 = new Date(datePart + "T00:00:00");

                const diffMs = d2.getTime() - d1.getTime();
                const diffDays = Math.round(diffMs / 86400000);
                return diffDays;
            }

            function renderCountdownForRow(row) {
                const t = row.querySelector("input[name='showTime']");
                const meta = row.querySelector(".showtime-meta");
                if (!t || !meta)
                    return;

                const val = (t.value || "").trim();
                if (!val) {
                    meta.innerHTML = '<span class="text-muted"><i class="fa-regular fa-hourglass"></i> Chọn ngày & giờ chiếu để xem bộ đếm</span>';
                    return;
                }

                const days = calcCountdownDaysVN(val);
                if (days === null) {
                    meta.innerHTML = '<span class="text-muted">—</span>';
                    return;
                }

                if (days < 0) {
                    meta.innerHTML = '<span class="badge text-bg-danger"><i class="fa-solid fa-triangle-exclamation"></i> Ngày chiếu đã qua</span>';
                } else if (days === 0) {
                    meta.innerHTML = '<span class="badge text-bg-success"><i class="fa-solid fa-bolt"></i> Hôm nay sẽ chiếu</span>';
                } else if (days === 1) {
                    meta.innerHTML = '<span class="badge text-bg-warning"><i class="fa-regular fa-clock"></i> Còn 1 ngày nữa sẽ chiếu</span>';
                } else {
                    meta.innerHTML = '<span class="badge text-bg-warning"><i class="fa-regular fa-clock"></i> Còn ' + days + ' ngày nữa sẽ chiếu</span>';
                }
            }

            function renderCountdownAllRows() {
                document.querySelectorAll(".showTimeItem").forEach(r => renderCountdownForRow(r));
            }

            // ====== wire events for row ======
            function wireRow(row) {
                const timeInput = row.querySelector("input[name='showTime']");
                if (timeInput && !timeInput.__wired) {
                    timeInput.__wired = true;
                    timeInput.addEventListener("change", function () {
                        renderCountdownForRow(row);
                    });
                    timeInput.addEventListener("input", function () {
                        renderCountdownForRow(row);
                    });
                }
            }

            function wireAllRows() {
                document.querySelectorAll(".showTimeItem").forEach(r => wireRow(r));
            }

            // ====== add/remove show time row ======
            function addShowTime() {
                const container = document.getElementById("showTimeContainer");
                const items = container.querySelectorAll(".showTimeItem");

                if (Number.isFinite(MAX_TIMES) && items.length >= MAX_TIMES) {
                    showNoticeModal("Vượt giới hạn", "Bạn chỉ được tạo tối đa <b>" + MAX_TIMES + "</b> lịch chiếu.", "warning");
                    return;
                }

                const div = document.createElement("div");
                div.className = "showTimeItem showtime-item";

                div.innerHTML =
                        '<div class="showtime-col">'
                        + '<input type="datetime-local" name="showTime" class="form-control" required/>'
                        + '<div class="showtime-meta"><span class="text-muted"><i class="fa-regular fa-hourglass"></i> Chọn ngày & giờ chiếu để xem bộ đếm</span></div>'
                        + '</div>'
                        + '<button type="button" class="btn btn-outline-danger icon-btn" onclick="removeShowTime(this)" title="Xóa giờ chiếu">'
                        + '<i class="fa-solid fa-xmark"></i>'
                        + '</button>';

                container.appendChild(div);
                wireRow(div);
                renderCountdownForRow(div);
            }

            function removeShowTime(btn) {
                const container = document.getElementById("showTimeContainer");
                const items = container.querySelectorAll(".showTimeItem");
                if (items.length <= 1) {
                    showNoticeModal("Không thể xóa", "Phải có ít nhất <b>1</b> lịch chiếu.", "danger");
                    return;
                }
                btn.parentElement.remove();
                renderCountdownAllRows();
            }

            // ====== validate client-side ======
            function validateShowForm() {
                const showID = (document.querySelector("select[name='showID']").value || "").trim();
                const rows = document.querySelectorAll(".showTimeItem");

                let error = "";
                if (showID === "")
                    error += "<li>Chưa chọn vở diễn</li>";

                let hasEmptyTime = false;
                rows.forEach(r => {
                    const t = r.querySelector("input[name='showTime']");
                    if (!t || !(t.value || "").trim())
                        hasEmptyTime = true;
                });

                if (hasEmptyTime)
                    error += "<li>Chưa chọn giờ chiếu</li>";

                const box = document.getElementById("clientErrorBox");
                const list = document.getElementById("clientErrorList");

                if (error !== "") {
                    if (list)
                        list.innerHTML = error;
                    if (box)
                        box.classList.remove("d-none");
                    return false;
                }
                if (box)
                    box.classList.add("d-none");
                return true;
            }

            window.addEventListener("load", function () {
                wireAllRows();
                renderCountdownAllRows();
            });
        </script>
    </head>

    <body>
        <div class="admin-wrap">

            <!-- SIDEBAR -->
            <aside class="sidebar">
                <div class="brand">
                    <div class="logo"><i class="fa-solid fa-masks-theater"></i></div>
                    <div>
                        <div class="title">Theater Admin</div>
                        <small>Thêm lịch chiếu</small>
                    </div>
                </div>
                <hr style="border-color: var(--line);">
            </aside>

            <!-- CONTENT -->
            <main class="content">

                <!-- TOPBAR -->
                <div class="topbar">
                    <div class="page-h">
                        <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                            <i class="fa-solid fa-calendar-plus"></i>
                        </div>
                        <div>
                            <h1>Thêm lịch chiếu</h1>
                            <div class="crumb">Admin / Schedule Management / Add</div>
                        </div>
                    </div>
                </div>

                <!-- Server-side messages -->
                <c:if test="${not empty globalMessage}">
                    <div class="alert alert-danger mt-3 mb-0 d-flex align-items-center gap-2">
                        <i class="fa-solid fa-circle-xmark"></i>
                        <div>${globalMessage}</div>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger mt-3 mb-0 d-flex align-items-center gap-2">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        <div>${error}</div>
                    </div>
                </c:if>

                <!-- Client-side errors -->
                <div id="clientErrorBox" class="alert alert-danger mt-3 mb-0 d-none">
                    <strong><i class="fa-solid fa-triangle-exclamation"></i> Vui lòng kiểm tra:</strong>
                    <ul id="clientErrorList" class="mt-2 mb-0"></ul>
                </div>

                <!-- FORM CARD -->
                <div class="card-form mt-3">
                    <div class="card-header">
                        <i class="fa-solid fa-calendar-plus"></i> Tạo lịch chiếu mới
                    </div>

                    <div class="p-4 text-dark">
                        <form method="post"
                              action="${pageContext.request.contextPath}/admin/schedule/add"
                              onsubmit="return validateShowForm();" novalidate>

                            <!-- Show -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">
                                    Vở diễn <span class="req">*</span>
                                </label>
                                <select name="showID" class="form-select" required>
                                    <option value="">-- Chọn vở diễn --</option>
                                    <c:forEach var="s" items="${shows}">
                                        <c:set var="st" value="${s.status}" />

                                        <!-- ✅ CHỈ HIỂN THỊ Ongoing + Upcoming -->
                                        <c:if test="${st eq 'Ongoing' or st eq 'Upcoming'}">
                                            <option value="${s.showID}"
                                        <c:if test="${showIDValue == s.showID}">selected</c:if>>
                                            ${s.showName}
                                        <c:choose>
                                            <c:when test="${st eq 'Ongoing'}"> (ĐANG HOẠT ĐỘNG)</c:when>
                                            <c:when test="${st eq 'Upcoming'}"> (SẮP HOẠT ĐỘNG)</c:when>
                                        </c:choose>
                                        </option>
                                    </c:if>
                                </c:forEach>

                            </select>
                        </div>

                        <!-- Show times -->
                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                Giờ chiếu <span class="req">*</span>
                            </label>

                            <div id="showTimeContainer">
                                <div class="showTimeItem showtime-item">
                                    <div class="showtime-col">
                                        <input type="datetime-local"
                                               name="showTime"
                                               class="form-control"
                                               value="${showTimeValue != null ? showTimeValue : ''}"
                                               required/>
                                        <div class="showtime-meta">
                                            <span class="text-muted"><i class="fa-regular fa-hourglass"></i> Chọn ngày & giờ chiếu để xem bộ đếm</span>
                                        </div>
                                    </div>

                                    <button type="button" class="btn btn-outline-danger icon-btn" onclick="removeShowTime(this)" title="Xóa giờ chiếu">
                                        <i class="fa-solid fa-xmark"></i>
                                    </button>
                                </div>
                            </div>

                            <button type="button" class="btn btn-outline-primary fw-bold mt-2" onclick="addShowTime()">
                                <i class="fa-solid fa-plus"></i> Thêm lịch chiếu
                            </button>

                            <div class="form-text">
                                <i class="fa-solid fa-circle-info"></i> Tối thiểu 1 lịch chiếu. Bạn có thể thêm nhiều lịch chiếu.
                            </div>
                        </div>

                        <!-- Status note -->
                        <div class="alert alert-info d-flex align-items-start gap-2" style="border-radius:14px;">
                            <i class="fa-solid fa-wand-magic-sparkles mt-1"></i>
                            <div>
                                <b>Ghi chú:</b> Trạng thái sẽ được hệ thống tự gán theo ngày/giờ chiếu (không cần chọn).
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="d-flex gap-2 mt-3">
                            <button type="submit" class="btn btn-success fw-bold">
                                <i class="fa-solid fa-floppy-disk"></i> Lưu lịch chiếu
                            </button>

                            <a class="btn btn-outline-dark fw-bold" href="${pageContext.request.contextPath}/admin/schedule">
                                <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                            </a>
                        </div>

                    </form>
                </div>
            </div>

        </main>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

    <!-- ================= NOTICE MODAL ================= -->
    <div class="modal fade" id="noticeModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius:16px; overflow:hidden;">
                <div class="modal-header text-bg-info">
                    <h5 class="modal-title fw-bold mb-0">
                        <i id="noticeModalIcon" class="fa-solid fa-circle-info me-2"></i>
                        <span id="noticeModalTitle">Thông báo</span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>

                <div class="modal-body text-dark">
                    <div id="noticeModalMsg">—</div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">
                        Đóng
                    </button>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
    