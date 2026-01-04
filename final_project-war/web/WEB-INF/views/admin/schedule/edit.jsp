<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Sửa Lịch chiếu</title>

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

            @media (max-width: 992px){
                .sidebar{
                    display:none;
                }
            }
        </style>

        <script>
            // ✅ validate client-side: showID + showTime
            // Lưu ý: showID dropdown bị disabled nên lấy từ hidden input name="showID"
            function validateShowForm() {
                let showIDEl = document.querySelector("input[name='showID']");
                let showTimeEl = document.querySelector("input[name='showTime']");

                let showID = showIDEl ? (showIDEl.value || "").trim() : "";
                let showTime = showTimeEl ? (showTimeEl.value || "").trim() : "";

                let error = "";
                if (showID === "")
                    error += "<li>Chưa chọn vở diễn</li>";
                if (showTime === "")
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

            // ✅ đảm bảo dropdown disabled vẫn hiển thị đúng option selected (UI only)
            window.addEventListener("load", function () {
                const lockedSelect = document.getElementById("showIDLocked");
                if (lockedSelect) {
                    lockedSelect.disabled = true;
                }
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
                        <small>Sửa lịch chiếu</small>
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
                            <i class="fa-solid fa-calendar-days"></i>
                        </div>
                        <div>
                            <h1>Sửa lịch chiếu</h1>
                            <div class="crumb">Admin / Schedule Management / Edit</div>
                        </div>
                    </div>
                </div>

                <!-- Server-side error -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger mt-3 mb-0 d-flex align-items-center gap-2">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        <div>${error}</div>
                    </div>
                </c:if>

                <!-- Client-side error -->
                <div id="clientErrorBox" class="alert alert-danger mt-3 mb-0 d-none">
                    <strong><i class="fa-solid fa-triangle-exclamation"></i> Vui lòng kiểm tra:</strong>
                    <ul id="clientErrorList" class="mt-2 mb-0"></ul>
                </div>

                <c:if test="${schedule == null}">
                    <div class="alert alert-danger mt-3 d-flex align-items-center gap-2">
                        <i class="fa-solid fa-circle-xmark"></i>
                        <div><b>Không tìm thấy lịch chiếu.</b></div>
                    </div>

                    <div class="mt-3">
                        <a class="btn btn-outline-light fw-bold" href="${pageContext.request.contextPath}/admin/schedule">
                            <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                        </a>
                    </div>
                </c:if>

                <c:if test="${schedule != null}">
                    <!-- FORM CARD -->
                    <div class="card-form mt-3">
                        <div class="card-header">
                            <i class="fa-solid fa-pen-to-square"></i> Cập nhật lịch chiếu
                        </div>

                        <div class="p-4 text-dark">
                            <form method="post"
                                  action="${pageContext.request.contextPath}/admin/schedule/edit"
                                  onsubmit="return validateShowForm();" novalidate>

                                <input type="hidden" name="scheduleID" value="${schedule.scheduleID}"/>

                                <!-- ✅ SHOWID: KHÓA DROPDOWN + HIDDEN để submit -->
                                <input type="hidden" name="showID" value="${schedule.showID.showID}"/>

                                <div class="row g-3">

                                    <!-- Show (LOCKED) -->
                                    <div class="col-lg-6">
                                        <label class="form-label fw-bold">
                                            Vở diễn <span class="req">*</span>
                                        </label>

                                        <!-- Dropdown bị khóa -->
                                        <select id="showIDLocked" class="form-select" disabled>
                                            <option value="">-- Chọn vở diễn --</option>
                                            <c:forEach var="s" items="${shows}">
                                                <option value="${s.showID}"
                                                        <c:if test="${schedule.showID.showID == s.showID}">selected</c:if>>
                                                    ${s.showName}
                                                </option>
                                            </c:forEach>
                                        </select>

                                        <div class="form-text">
                                            <i class="fa-solid fa-lock"></i>
                                            Không thể đổi vở diễn khi cập nhật. Muốn đổi show hãy tạo lịch mới.
                                        </div>
                                    </div>

                                    <!-- ShowTime -->
                                    <div class="col-lg-6">
                                        <label class="form-label fw-bold">
                                            Giờ chiếu <span class="req">*</span>
                                        </label>
                                        <input type="datetime-local"
                                               name="showTime"
                                               class="form-control"
                                               value="${showTimeLocal}"
                                               required/>
                                    </div>

                                    <!-- Status readonly -->
                                    <div class="col-lg-6">
                                        <label class="form-label fw-bold">Trạng thái (tự động)</label>
                                        <input type="text"
                                               class="form-control"
                                               value="${schedule.status}"
                                               readonly
                                               style="background:#f2f2f2;"/>
                                        <div class="form-text">
                                            <i class="fa-solid fa-circle-info"></i>
                                            Trạng thái sẽ tự cập nhật theo ngày/giờ chiếu khi bạn bấm <b>Cập nhật</b>.
                                        </div>
                                    </div>

                                    <!-- CreatedAt -->
                                    <div class="col-lg-6">
                                        <label class="form-label fw-bold">Ngày tạo</label>
                                        <div class="p-2 rounded-3 border bg-white">
                                            <i class="fa-regular fa-clock"></i>
                                            <fmt:formatDate value="${schedule.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </div>

                                    <!-- Actions -->
                                    <div class="col-12 d-flex gap-2 mt-2">
                                        <button type="submit" class="btn btn-success fw-bold">
                                            <i class="fa-solid fa-floppy-disk"></i> Cập nhật lịch chiếu
                                        </button>

                                        <a class="btn btn-outline-dark fw-bold" href="${pageContext.request.contextPath}/admin/schedule">
                                            <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                                        </a>
                                    </div>

                                </div>
                            </form>
                        </div>
                    </div>
                </c:if>

            </main>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
