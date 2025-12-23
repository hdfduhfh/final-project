<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Lịch chiếu</title>

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

            /* ===== POPUP DETAIL SCHEDULE (theme) ===== */
            .detail-overlay{
                position:fixed;
                inset:0;
                background:rgba(0,0,0,0.82);
                display:none;
                align-items:center;
                justify-content:center;
                z-index:9999;
            }
            .detail-modal{
                background:#fff;
                border-radius:18px;
                width:92%;
                max-width:920px;
                max-height:90vh;
                overflow:hidden;
                box-shadow:0 30px 120px rgba(0,0,0,0.75);
                position:relative;
                display:flex;
            }
            .detail-left{
                flex: 0 0 40%;
                background:
                    radial-gradient(700px 400px at 50% 20%, rgba(6,182,212,0.18), transparent 60%),
                    linear-gradient(180deg, #05060a, #0a0f1e);
                display:flex;
                align-items:center;
                justify-content:center;
                color:#fff;
                padding:18px;
                text-align:center;
            }
            .detail-left .big-ico{
                width:72px;
                height:72px;
                border-radius:22px;
                display:grid;
                place-items:center;
                background: rgba(255,255,255,.10);
                border: 1px solid rgba(255,255,255,.16);
                box-shadow: 0 18px 45px rgba(0,0,0,.35);
                margin: 0 auto 12px;
                font-size: 28px;
            }
            .detail-left .hint{
                opacity:.9;
                font-weight:700;
            }

            .detail-right{
                flex:1;
                padding: 20px 24px;
                overflow-y:auto;
                background:#fff;
                color:#111827;
                -webkit-font-smoothing: antialiased;
                text-rendering: geometricPrecision;
            }
            .detail-title{
                font-size: 22px;
                font-weight: 950;
                color: #0f172a;
                margin-bottom: 12px;
                letter-spacing:.2px;
            }
            .detail-row{
                font-size: 14px;
                line-height: 1.7;
                margin-bottom: 10px;
            }
            .detail-row strong{
                color:#0f172a;
                font-weight: 900;
            }
            .detail-close{
                position:absolute;
                top: 8px;
                right: 14px;
                font-size: 30px;
                color: #fff;
                cursor: pointer;
                user-select:none;
                z-index: 10000;
                text-shadow: 0 10px 24px rgba(0,0,0,0.6);
            }

            @media (max-width: 992px){
                .sidebar{
                    display:none;
                }
                .detail-modal{
                    flex-direction:column;
                }
                .detail-left{
                    flex: none;
                }
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
                        <small>Quản lý lịch chiếu</small>
                    </div>
                </div>

                <hr style="border-color: var(--line);">

                <div class="px-2">
                    <div class="text-uppercase" style="font-size:12px; color:var(--muted); font-weight:900; letter-spacing:.3px;">
                        Quick actions
                    </div>
                    <div class="mt-2 d-grid gap-2">
                        <a class="btn btn-outline-light fw-bold" href="${pageContext.request.contextPath}/admin/dashboard" style="border-radius:14px;">
                            <i class="fa-solid fa-arrow-left"></i> Về Dashboard
                        </a>
                        <a class="btn btn-light fw-bold" href="${pageContext.request.contextPath}/admin/schedule/add" style="border-radius:14px;">
                            <i class="fa-solid fa-circle-plus"></i> Thêm lịch chiếu mới
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
                            <i class="fa-solid fa-calendar-check"></i>
                        </div>
                        <div>
                            <h1>Quản lý Lịch chiếu</h1>
                            <div class="crumb">Admin / Schedule Management / List</div>
                        </div>
                    </div>
                </div>

                <!-- Alerts -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success mt-3 mb-0 d-flex align-items-center gap-2">
                        <i class="fa-solid fa-circle-check"></i>
                        <div>${param.success}</div>
                    </div>
                </c:if>

                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger mt-3 mb-0 d-flex align-items-center gap-2">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        <div>${param.error}</div>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger mt-3 mb-0 d-flex align-items-center gap-2">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        <div>${error}</div>
                    </div>
                </c:if>

                <!-- Controls -->
                <div class="panel">
                    <div class="row g-2 align-items-center">
                        <div class="col-lg-8">
                            <form method="get"
                                  action="${pageContext.request.contextPath}/admin/schedule"
                                  id="searchForm">
                                <div class="input-group position-relative">
                                    <span class="input-group-text bg-white">
                                        <i class="fa-solid fa-magnifying-glass"></i>
                                    </span>

                                    <input type="text"
                                           id="keywordInput"
                                           name="search"
                                           class="form-control"
                                           placeholder="Nhập tên show cần tìm..."
                                           value="${searchKeyword != null ? searchKeyword : ''}"
                                           style="padding-right:48px;"/>

                                    <button type="submit" class="btn btn-warning fw-bold">
                                        Tìm
                                    </button>
                                </div>
                            </form>

                            <!-- FILTER STATUS (Client-side, không đụng servlet) -->
                            <div class="col-12 mt-2">
                                <div class="btn-group btn-group-sm" role="group" aria-label="Filter status">
                                    <button type="button" class="btn btn-outline-light fw-bold status-filter active" data-status="ALL">
                                        <i class="fa-solid fa-layer-group"></i> Tất cả
                                    </button>
                                    <button type="button" class="btn btn-outline-light fw-bold status-filter" data-status="Ongoing">
                                        <i class="fa-solid fa-circle-play"></i> Ongoing
                                    </button>
                                    <button type="button" class="btn btn-outline-light fw-bold status-filter" data-status="Upcoming">
                                        <i class="fa-solid fa-clock"></i> Upcoming
                                    </button>
                                    <button type="button" class="btn btn-outline-light fw-bold status-filter" data-status="Cancelled">
                                        <i class="fa-solid fa-ban"></i> Cancelled
                                    </button>
                                </div>

                                <span class="ms-2 text-white-50" style="font-weight:700; font-size:13px;">
                                    Lọc nhanh theo trạng thái (không tải lại trang)
                                </span>
                            </div>
                        </div>

                        <div class="col-lg-4 text-lg-end">
                            <div class="fw-bold text-white-50">
                                Tổng số lịch chiếu: <span class="text-white">${totalSchedules}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Table -->
                <div class="table-wrap">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Vở diễn</th>
                                    <th>Giờ chiếu</th>
                                    <th>Trạng thái</th>
                                    <th style="width:220px;">Hành động</th>
                                </tr>
                            </thead>

                            <tbody>
                                <!-- groupedSchedules: Map<showId, List<ShowSchedule>> -->
                                <c:forEach var="entry" items="${groupedSchedules}">
                                    <c:set var="list" value="${entry.value}" />
                                    <c:set var="rowspan" value="${list.size()}" />

                                    <c:forEach var="sc" items="${list}" varStatus="st">
                                        <fmt:formatDate value="${sc.showTime}" pattern="dd/MM/yyyy HH:mm" var="timeFmt"/>

                                        <!-- durationMinutes từ Show -->
                                        <c:set var="dur" value="${sc.showID != null ? sc.showID.durationMinutes : 0}" />

                                        <!-- ✅ Tính endTime + rtStatus (real-time theo NGÀY giữ nguyên, thêm GIỜ/PHÚT khi hôm nay) -->
                                        <%
                                            // ===== LẤY DATA =====
                                            mypack.ShowSchedule scObj = (mypack.ShowSchedule) pageContext.findAttribute("sc");

                                            int _dur = 0;
                                            Object durObj = pageContext.findAttribute("dur");
                                            if (durObj != null) {
                                                try {
                                                    _dur = Integer.parseInt(durObj.toString());
                                                } catch (Exception ignored) {
                                                    _dur = 0;
                                                }
                                            }

                                            java.util.Date _start = (scObj != null) ? scObj.getShowTime() : null;

                                            // ===== endTime =====
                                            java.util.Date _end = null;
                                            if (_start != null && _dur > 0) {
                                                java.util.Calendar cal = java.util.Calendar.getInstance();
                                                cal.setTime(_start);
                                                cal.add(java.util.Calendar.MINUTE, _dur);
                                                _end = cal.getTime();
                                            }
                                            pageContext.setAttribute("endTime", _end);

                                            // ===== REAL-TIME STATUS =====
                                            // Rule theo NGÀY vẫn giữ nguyên:
                                            // - showDate < today => Cancelled
                                            // - showDate > today => Upcoming
                                            // - showDate == today => xét thêm theo GIỜ/PHÚT:
                                            //      + now < start => Upcoming
                                            //      + start <= now <= end => Ongoing
                                            //      + now > end => Cancelled
                                            String _rtStatus = "Upcoming";

                                            if (_start != null) {
                                                // timezone VN (để tránh server lệch múi giờ)
                                                java.util.TimeZone tz = java.util.TimeZone.getTimeZone("Asia/Ho_Chi_Minh");

                                                java.util.Calendar nowCal = java.util.Calendar.getInstance(tz);
                                                nowCal.setTime(new java.util.Date());

                                                // today 00:00
                                                java.util.Calendar cToday = java.util.Calendar.getInstance(tz);
                                                cToday.setTime(nowCal.getTime());
                                                cToday.set(java.util.Calendar.HOUR_OF_DAY, 0);
                                                cToday.set(java.util.Calendar.MINUTE, 0);
                                                cToday.set(java.util.Calendar.SECOND, 0);
                                                cToday.set(java.util.Calendar.MILLISECOND, 0);

                                                // showDate 00:00
                                                java.util.Calendar cShow = java.util.Calendar.getInstance(tz);
                                                cShow.setTime(_start);
                                                cShow.set(java.util.Calendar.HOUR_OF_DAY, 0);
                                                cShow.set(java.util.Calendar.MINUTE, 0);
                                                cShow.set(java.util.Calendar.SECOND, 0);
                                                cShow.set(java.util.Calendar.MILLISECOND, 0);

                                                if (cShow.before(cToday)) {
                                                    _rtStatus = "Cancelled";
                                                } else if (cShow.after(cToday)) {
                                                    _rtStatus = "Upcoming";
                                                } else {
                                                    // ✅ showDate == today => xét thêm GIỜ/PHÚT
                                                    long nowMs = nowCal.getTimeInMillis();
                                                    long startMs = _start.getTime();

                                                    if (nowMs < startMs) {
                                                        _rtStatus = "Upcoming";
                                                    } else {
                                                        // now >= start
                                                        if (_end != null && _dur > 0) {
                                                            long endMs = _end.getTime();
                                                            if (nowMs > endMs) {
                                                                _rtStatus = "Cancelled";
                                                            } else {
                                                                _rtStatus = "Ongoing";
                                                            }
                                                        } else {
                                                            // nếu không có duration/endTime thì coi như đã tới giờ => Ongoing
                                                            _rtStatus = "Ongoing";
                                                        }
                                                    }
                                                }
                                            }

                                            pageContext.setAttribute("rtStatus", _rtStatus);
                                        %>

                                        <!-- format end -->
                                        <fmt:formatDate value="${endTime}" pattern="dd/MM/yyyy HH:mm" var="endFmt"/>

                                        <tr data-status="${rtStatus}">
                                            <!-- Merge cell: chỉ show 1 lần -->
                                            <c:if test="${st.first}">
                                                <td rowspan="${rowspan}" class="fw-bold" style="vertical-align: middle;">
                                                    <c:choose>
                                                        <c:when test="${sc.showID != null}">
                                                            <i class="fa-solid fa-clapperboard text-primary"></i>
                                                            ${sc.showID.showName}
                                                        </c:when>
                                                        <c:otherwise>(Không có vở diễn)</c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </c:if>

                                            <td>
                                                <i class="fa-regular fa-clock text-secondary"></i>
                                                ${timeFmt}
                                                <c:if test="${endTime != null && dur > 0}">
                                                    – ${endFmt}
                                                    <span class="text-muted fw-semibold">(${dur} phút)</span>
                                                </c:if>
                                            </td>

                                            <td>
                                                <span class="badge text-bg-light border fw-bold">
                                                    <i class="fa-solid fa-tag"></i> ${rtStatus}
                                                </span>
                                            </td>

                                            <td class="text-nowrap">
                                                <!-- DETAIL -->
                                                <button type="button"
                                                        class="btn btn-info btn-icon"
                                                        title="Chi tiết"
                                                        data-show-name="<c:out value='${sc.showID != null ? sc.showID.showName : "(Không có vở diễn)"}'/>"
                                                        data-show-time="<c:out value='${timeFmt}'/>"
                                                        data-end-time="<c:out value='${endTime != null && dur > 0 ? endFmt : ""}'/>"
                                                        data-duration="<c:out value='${dur}'/>"
                                                        data-status="<c:out value='${rtStatus}'/>"
                                                        onclick="openScheduleDetail(this)">
                                                    <i class="fa-solid fa-circle-info"></i>
                                                </button>

                                                <a href="${pageContext.request.contextPath}/admin/schedule/edit?id=${sc.scheduleID}"
                                                   class="btn btn-primary btn-icon"
                                                   title="Sửa">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </a>

                                                <button type="button"
                                                        class="btn btn-danger btn-icon"
                                                        title="Xóa"
                                                        onclick="openDeleteScheduleModal('${pageContext.request.contextPath}/admin/schedule/delete?id=${sc.scheduleID}',
                                                                        '<c:out value="${sc.showID != null ? sc.showID.showName : '(Không có vở diễn)'}"/>',
                                                                        '<c:out value="${timeFmt}"/>')">
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>

                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:forEach>

                                <c:if test="${empty groupedSchedules}">
                                    <tr>
                                        <td colspan="4" class="text-center py-5 text-secondary">
                                            <i class="fa-regular fa-folder-open fa-lg"></i>
                                            <div class="mt-2 fw-bold">Không có lịch chiếu nào.</div>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- PAGINATION (giữ searchKeyword trên link) -->
                <c:if test="${totalPages > 1}">
                    <div class="mt-3">
                        <nav aria-label="pagination">
                            <ul class="pagination justify-content-center mb-0">
                                <c:set var="kw" value="${searchKeyword != null ? searchKeyword : ''}" />

                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/admin/schedule?page=${currentPage - 1}&search=${kw}">
                                            <i class="fa-solid fa-arrow-left"></i> Trước
                                        </a>
                                    </li>
                                </c:if>

                                <li class="page-item disabled">
                                    <span class="page-link">
                                        Trang <b>${currentPage}</b> / <b>${totalPages}</b>
                                    </span>
                                </li>

                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/admin/schedule?page=${currentPage + 1}&search=${kw}">
                                            Sau <i class="fa-solid fa-arrow-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>
                </c:if>

            </main>
        </div>

        <!-- ================= POPUP DETAIL SCHEDULE ================= -->
        <div id="scheduleOverlay" class="detail-overlay">
            <div class="detail-close" onclick="closeScheduleDetail()">&times;</div>

            <div class="detail-modal">
                <div class="detail-left">
                    <div>
                        <div class="big-ico">
                            <i class="fa-solid fa-calendar-day"></i>
                        </div>
                        <div class="hint">Chi tiết lịch chiếu</div>
                        <div class="mt-2" style="opacity:.8; font-weight:600; font-size:13px;">
                            Xem nhanh thông tin vở diễn, giờ chiếu và trạng thái.
                        </div>
                    </div>
                </div>

                <div class="detail-right">
                    <div class="detail-title" id="detailTitle">Lịch chiếu</div>

                    <div class="detail-row">
                        <strong><i class="fa-solid fa-clapperboard"></i> Tên vở diễn:</strong>
                        <span id="detailShowName"></span>
                    </div>

                    <div class="detail-row">
                        <strong><i class="fa-regular fa-clock"></i> Giờ chiếu:</strong>
                        <span id="detailShowTime"></span>
                    </div>

                    <div class="detail-row">
                        <strong><i class="fa-solid fa-tag"></i> Trạng thái:</strong>
                        <span id="detailStatus"></span>
                    </div>

                    <div class="mt-3 d-flex justify-content-end">
                        <button type="button" class="btn btn-outline-dark fw-bold" onclick="closeScheduleDetail()" style="border-radius:14px;">
                            <i class="fa-solid fa-xmark"></i> Đóng
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                            function openDeleteScheduleModal(deleteUrl, showName, showTime) {
                                const nameEl = document.getElementById('deleteScheduleShowName');
                                const timeEl = document.getElementById('deleteScheduleShowTime');
                                const confirmBtn = document.getElementById('deleteScheduleConfirmBtn');

                                if (nameEl)
                                    nameEl.textContent = showName || '';
                                if (timeEl)
                                    timeEl.textContent = showTime || '';
                                if (confirmBtn)
                                    confirmBtn.setAttribute('href', deleteUrl || '#');

                                const modalEl = document.getElementById('deleteScheduleModal');
                                const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                                modal.show();
                            }
        </script>

        <!-- Popup detail schedule -->
        <script>
            function openScheduleDetail(btn) {
                document.getElementById("detailTitle").textContent = "Chi tiết lịch chiếu";
                document.getElementById("detailShowName").textContent = btn.getAttribute("data-show-name") || "";

                const start = btn.getAttribute("data-show-time") || "";
                const end = btn.getAttribute("data-end-time") || "";
                const dur = btn.getAttribute("data-duration") || "0";

                let timeText = start;
                if (end && dur && dur !== "0") {
                    timeText = start + " – " + end + " (" + dur + " phút)";
                }
                document.getElementById("detailShowTime").textContent = timeText;

                document.getElementById("detailStatus").textContent = btn.getAttribute("data-status") || "";
                document.getElementById("scheduleOverlay").style.display = "flex";
            }

            function closeScheduleDetail() {
                document.getElementById("scheduleOverlay").style.display = "none";
            }

            document.addEventListener("click", function (e) {
                var overlay = document.getElementById("scheduleOverlay");
                if (!overlay)
                    return;
                if (overlay.style.display === "flex" && e.target === overlay) {
                    closeScheduleDetail();
                }
            });

            document.addEventListener("keydown", function (e) {
                var overlay = document.getElementById("scheduleOverlay");
                if (e.key === "Escape" && overlay && overlay.style.display === "flex") {
                    closeScheduleDetail();
                }
            });
        </script>

        <!-- ✅ Clear X giống trang quản lý nghệ sĩ -->
        <script>
            (function () {
                const input = document.getElementById('keywordInput');
                if (!input)
                    return;

                const group = input.closest('.input-group');
                if (!group)
                    return;

                const clearBtn = document.createElement('button');
                clearBtn.type = 'button';
                clearBtn.className = 'btn btn-outline-secondary';
                clearBtn.setAttribute('aria-label', 'Clear search');
                clearBtn.style.display = 'none';
                clearBtn.innerHTML = '<i class="fa-solid fa-xmark"></i>';

                const submitBtn = group.querySelector('button[type="submit"], input[type="submit"]');
                if (submitBtn)
                    group.insertBefore(clearBtn, submitBtn);
                else
                    group.appendChild(clearBtn);

                function toggle() {
                    clearBtn.style.display = input.value.trim().length ? '' : 'none';
                }

                clearBtn.addEventListener('click', function () {
                    input.value = '';
                    toggle();
                    input.focus();
                });

                input.addEventListener('input', toggle);
                input.addEventListener('change', toggle);

                toggle();
            })();
        </script>

        <!-- FILTER STATUS + FIX ROWSPAN -->
        <script>
            (function () {
                const table = document.querySelector('.table-wrap table');
                if (!table)
                    return;

                const filterButtons = document.querySelectorAll('.status-filter');
                const tbody = table.querySelector('tbody');
                if (!tbody)
                    return;

                const rows = Array.from(tbody.querySelectorAll('tr'));

                const groupMap = new Map();
                let currentShowCell = null;
                let currentGroupRows = [];

                rows.forEach((tr) => {
                    const showCell = tr.querySelector('td[rowspan]');
                    if (showCell) {
                        if (currentShowCell && currentGroupRows.length) {
                            groupMap.set(currentShowCell, currentGroupRows);
                        }
                        currentShowCell = showCell;
                        currentGroupRows = [tr];
                    } else {
                        if (currentShowCell)
                            currentGroupRows.push(tr);
                    }
                });
                if (currentShowCell && currentGroupRows.length) {
                    groupMap.set(currentShowCell, currentGroupRows);
                }

                function applyFilter(status) {
                    rows.forEach(tr => {
                        const st = (tr.getAttribute('data-status') || '').trim();
                        const show = (status === 'ALL') || (st === status);
                        tr.style.display = show ? '' : 'none';
                    });

                    groupMap.forEach((groupRows, showCell) => {
                        const visibleRows = groupRows.filter(r => r.style.display !== 'none');

                        if (visibleRows.length === 0) {
                            showCell.style.display = 'none';
                            showCell.setAttribute('rowspan', '1');
                            return;
                        }

                        showCell.style.display = '';
                        showCell.setAttribute('rowspan', String(visibleRows.length));

                        const firstRow = groupRows[0];
                        const firstVisibleRow = visibleRows[0];

                        if (firstRow !== firstVisibleRow) {
                            if (firstRow.contains(showCell))
                                firstRow.removeChild(showCell);
                            firstVisibleRow.insertBefore(showCell, firstVisibleRow.firstElementChild);
                        } else {
                            if (!firstRow.contains(showCell)) {
                                firstRow.insertBefore(showCell, firstRow.firstElementChild);
                            }
                        }
                    });
                }

                filterButtons.forEach(btn => {
                    btn.addEventListener('click', function () {
                        filterButtons.forEach(b => b.classList.remove('active'));
                        this.classList.add('active');

                        const status = (this.getAttribute('data-status') || 'ALL').trim();
                        applyFilter(status);
                    });
                });

                applyFilter('ALL');
            })();
        </script>

        <!-- ===== DELETE SCHEDULE CONFIRM MODAL (Bootstrap) ===== -->
        <div class="modal fade" id="deleteScheduleModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content" style="border-radius:18px; overflow:hidden;">
                    <div class="modal-header" style="background:#0f1b33; color:#e8efff; border:none;">
                        <h5 class="modal-title fw-bold">
                            <i class="fa-solid fa-triangle-exclamation text-warning"></i>
                            Xác nhận xóa lịch chiếu
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body text-dark">
                        <div class="d-flex align-items-start gap-3">
                            <div style="width:46px;height:46px;border-radius:16px;display:grid;place-items:center;background:rgba(239,68,68,.12);">
                                <i class="fa-solid fa-calendar-xmark text-danger fs-4"></i>
                            </div>

                            <div>
                                <div class="fw-bold mb-1">Bạn chắc chắn muốn xóa lịch chiếu này?</div>

                                <div class="text-secondary">
                                    <div><span class="fw-bold">Vở diễn:</span> <span id="deleteScheduleShowName"></span></div>
                                    <div class="mt-1"><span class="fw-bold">Giờ chiếu:</span> <span id="deleteScheduleShowTime"></span></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer" style="border:none;">
                        <button type="button" class="btn btn-outline-dark fw-bold" data-bs-dismiss="modal">
                            <i class="fa-solid fa-xmark"></i> Hủy
                        </button>

                        <a href="#" id="deleteScheduleConfirmBtn" class="btn btn-danger fw-bold">
                            <i class="fa-solid fa-trash"></i> Xóa
                        </a>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>
