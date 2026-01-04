<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cập nhật Show</title>

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
                background: rgba(34,197,94,.16);
                border-color: rgba(34,197,94,.35);
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

            .multi-select-dropdown{
                position: relative;
                display: inline-block;
                width: 100%;
            }
            .dd-header{
                border: 1px solid #d1d5db;
                background: #fff;
                padding: 10px 12px;
                border-radius: 12px;
                cursor: pointer;
                user-select: none;
                display:flex;
                align-items:center;
                justify-content:space-between;
                gap:10px;
            }
            .dd-header .text{
                color:#111827;
                font-weight:700;
                overflow:hidden;
                text-overflow:ellipsis;
                white-space:nowrap;
            }
            .dd-list{
                position: absolute;
                top: calc(100% + 6px);
                left: 0;
                right: 0;
                border: 1px solid #e5e7eb;
                background: #fff;
                max-height: 220px;
                overflow-y: auto;
                display: none;
                z-index: 999;
                border-radius: 14px;
                box-shadow: 0 18px 45px rgba(0,0,0,.18);
                padding: 6px 0;
            }
            .dd-list label{
                display:block;
                padding: 8px 12px;
                margin:0;
                cursor:pointer;
                color:#111827;
            }
            .dd-list label:hover{
                background: #f3f4f6;
            }

            .form-control, .form-select{
                border-radius: 12px;
            }

            .poster-preview{
                border-radius: 16px;
                overflow:hidden;
                border: 1px solid rgba(0,0,0,.12);
                box-shadow: 0 14px 35px rgba(0,0,0,.18);
                background:#fff;
                max-width: 280px;
            }
            .poster-preview img{
                width:100%;
                display:block;
                object-fit:cover;
            }
            .poster-meta{
                padding: 10px 12px;
                color:#111827;
                font-weight:800;
                font-size: 13px;
                border-top: 1px solid rgba(0,0,0,.08);
            }

            @media (max-width: 992px){
                .sidebar{
                    display:none;
                }
            }
        </style>
    </head>

    <body>
        <div class="admin-wrap">

            <aside class="sidebar">
                <div class="brand">
                    <div class="logo"><i class="fa-solid fa-masks-theater"></i></div>
                    <div>
                        <div class="title">Theater Admin</div>
                        <small>Cập nhật vở diễn</small>
                    </div>
                </div>

                <hr style="border-color: var(--line);">
            </aside>

            <main class="content">

                <div class="topbar">
                    <div class="page-h">
                        <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                            <i class="fa-solid fa-pen-to-square"></i>
                        </div>
                        <div>
                            <h1>Cập nhật vở diễn</h1>
                            <div class="crumb">Admin / Show Management / Edit</div>
                        </div>
                    </div>
                </div>

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

                <div id="clientError" class="alert alert-danger mt-3 mb-0 d-none"></div>

                <div id="clientErrors"
                     class="alert alert-danger mt-3 mb-0"
                     style="display:none;">
                    <strong><i class="fa-solid fa-triangle-exclamation"></i> Vui lòng kiểm tra:</strong>
                    <ul id="clientErrorsList" class="mt-2 mb-0"></ul>
                </div>

                <div class="card-form mt-3">
                    <div class="card-header">
                        <i class="fa-solid fa-pen-to-square"></i> Chỉnh sửa thông tin vở diễn
                    </div>

                    <div class="p-4 text-dark">
                        <form method="post"
                              action="${pageContext.request.contextPath}/admin/show/edit"
                              enctype="multipart/form-data"
                              onsubmit="return validateShowForm();" novalidate>

                            <input type="hidden" name="showID" value="${show.showID}" />

                            <div class="row g-3">
                                <div class="col-lg-6">
                                    <label class="form-label fw-bold">
                                        Tên vở diễn <span class="req">*</span>
                                    </label>
                                    <input type="text"
                                           name="showName"
                                           class="form-control"
                                           value="${not empty param.showName ? param.showName : show.showName}"
                                           required/>
                                </div>

                                <div class="col-lg-3">
                                    <label class="form-label fw-bold">
                                        Thời lượng (phút) <span class="req">*</span>
                                    </label>
                                    <input type="number"
                                           name="durationMinutes"
                                           min="1"
                                           class="form-control"
                                           value="${not empty param.durationMinutes ? param.durationMinutes : show.durationMinutes}"
                                           required/>
                                </div>

                                <!-- ✅ Trạng thái (CHỈ CHỈNH disable theo rule, không đổi CSS) -->
                                <div class="col-lg-3">
                                    <label class="form-label fw-bold">
                                        Trạng thái <span class="req">*</span>
                                    </label>

                                    <c:set var="stVal" value="${not empty statusValue ? statusValue : show.status}" />
                                    <c:set var="curSt" value="${not empty currentShowStatus ? currentShowStatus : show.status}" />
                                    <c:set var="canCancel" value="${canCancel}" />

                                    <select name="status" class="form-select" required>
                                        <option value="" <c:if test="${empty stVal}">selected</c:if>>-- Chọn trạng thái --</option>

                                        <!-- Ongoing: nếu show hiện tại là Upcoming thì disable -->
                                        <option value="Ongoing"
                                                <c:if test="${stVal eq 'Ongoing'}">selected</c:if>
                                                <c:if test="${curSt eq 'Upcoming'}">disabled</c:if>>
                                            ĐANG HOẠT ĐỘNG
                                        </option>

                                        <!-- Upcoming: nếu show hiện tại là Ongoing thì disable -->
                                        <option value="Upcoming"
                                                <c:if test="${stVal eq 'Upcoming'}">selected</c:if>
                                                <c:if test="${curSt eq 'Ongoing'}">disabled</c:if>>
                                            SẮP HOẠT ĐỘNG
                                        </option>

                                        <!-- Cancelled: chỉ enable khi canCancel = true hoặc đang Cancelled -->
                                        <option value="Cancelled"
                                                <c:if test="${stVal eq 'Cancelled'}">selected</c:if>
                                                <c:if test="${(curSt ne 'Cancelled') and (not canCancel)}">disabled</c:if>>
                                            TẠM NGƯNG
                                        </option>
                                    </select>

                                    <c:if test="${(curSt ne 'Cancelled') and (not canCancel)}">
                                        <div class="form-text text-danger mt-1">
                                            <i class="fa-solid fa-circle-info"></i>
                                            Chỉ được chuyển sang TẠM NGƯNG khi show đã xong toàn bộ lịch diễn.
                                        </div>
                                    </c:if>
                                </div>

                                <div class="col-12">
                                    <label class="form-label fw-bold">
                                        Mô tả <span class="req">*</span>
                                    </label>
                                    <textarea name="description"
                                              rows="5"
                                              class="form-control"
                                              required>${not empty param.description ? param.description : show.description}</textarea>
                                </div>

                                <!-- Đạo diễn -->
                                <div class="col-lg-6">
                                    <label class="form-label fw-bold">
                                        Đạo diễn <span class="req">*</span>
                                    </label>

                                    <div class="multi-select-dropdown" id="directorContainerAdd">
                                        <div id="directorDropdownHeaderAdd"
                                             class="dd-header"
                                             onclick="toggleDropdown('directorDropdownListAdd')">
                                            <span id="directorSelectedTextAdd" class="text">Chọn đạo diễn...</span>
                                            <span><i class="fa-solid fa-chevron-down"></i></span>
                                        </div>

                                        <div id="directorDropdownListAdd" class="dd-list">
                                            <c:forEach var="d" items="${directors}">
                                                <c:set var="directorChecked" value="false"/>

                                                <c:if test="${not empty param.directorId}">
                                                    <c:if test="${param.directorId == d.artistID}">
                                                        <c:set var="directorChecked" value="true"/>
                                                    </c:if>
                                                </c:if>

                                                <c:if test="${empty param.directorId and not empty selectedDirectorId}">
                                                    <c:if test="${selectedDirectorId == d.artistID}">
                                                        <c:set var="directorChecked" value="true"/>
                                                    </c:if>
                                                </c:if>

                                                <label>
                                                    <input type="radio"
                                                           name="directorId"
                                                           value="${d.artistID}"
                                                           data-director-name="${d.name}"
                                                           <c:if test="${directorChecked}">checked</c:if>
                                                               onchange="updateDirectorSelectedText('directorDropdownListAdd', 'directorSelectedTextAdd')">
                                                    ${d.name}
                                                    <c:if test="${not empty d.role}">
                                                        - ${d.role}
                                                    </c:if>
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>

                                <!-- Nghệ sĩ tham gia -->
                                <div class="col-lg-6">
                                    <label class="form-label fw-bold">
                                        Nghệ sĩ tham gia <span class="req">*</span>
                                    </label>

                                    <div class="multi-select-dropdown" id="artistContainerAdd">
                                        <div id="artistDropdownHeaderAdd"
                                             class="dd-header"
                                             onclick="toggleDropdown('artistDropdownListAdd')">
                                            <span id="artistSelectedTextAdd" class="text">Chọn nghệ sĩ...</span>
                                            <span><i class="fa-solid fa-chevron-down"></i></span>
                                        </div>

                                        <div id="artistDropdownListAdd" class="dd-list">
                                            <c:forEach var="a" items="${artists}">
                                                <c:set var="checked" value="false"/>

                                                <c:if test="${not empty paramValues.artistIds}">
                                                    <c:forEach var="aid" items="${paramValues.artistIds}">
                                                        <c:if test="${aid == a.artistID}">
                                                            <c:set var="checked" value="true"/>
                                                        </c:if>
                                                    </c:forEach>
                                                </c:if>

                                                <c:if test="${empty paramValues.artistIds and not empty selectedArtistIds}">
                                                    <c:forEach var="aidDb" items="${selectedArtistIds}">
                                                        <c:if test="${aidDb == a.artistID}">
                                                            <c:set var="checked" value="true"/>
                                                        </c:if>
                                                    </c:forEach>
                                                </c:if>

                                                <label>
                                                    <input type="checkbox"
                                                           name="artistIds"
                                                           value="${a.artistID}"
                                                           data-artist-name="${a.name}"
                                                           <c:if test="${checked}">checked</c:if>
                                                               onchange="updateArtistSelectedText('artistDropdownListAdd', 'artistSelectedTextAdd')">
                                                    ${a.name}
                                                    <c:if test="${not empty a.role}">
                                                        - ${a.role}
                                                    </c:if>
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>

                                <!-- Poster current -->
                                <div class="col-lg-6">
                                    <label class="form-label fw-bold">Poster hiện tại</label><br/>

                                    <c:if test="${not empty show.showImage}">
                                        <div class="poster-preview">
                                            <img src="${pageContext.request.contextPath}/${show.showImage}" alt="Poster">
                                            <div class="poster-meta">
                                                <i class="fa-regular fa-image"></i> ${show.showImage}
                                            </div>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Poster dropdown + Preview poster mới -->
                                <div class="col-lg-6">
                                    <label class="form-label fw-bold">
                                        Chọn hình từ thư mục <span class="req">*</span>
                                    </label>

                                    <c:set var="currentImage"
                                           value="${not empty param.showImageDropdown ? param.showImageDropdown : show.showImage}" />

                                    <select name="showImageDropdown" class="form-select" id="showImageDropdownSelect" required>
                                        <option value="">Chọn hình ảnh từ thư mục</option>

                                        <c:forEach var="img" items="${imageFiles}">
                                            <option value="${img}"
                                                    <c:if test="${img eq currentImage}">selected</c:if>>
                                                ${img}
                                            </option>
                                        </c:forEach>
                                    </select>

                                    <div class="form-text">
                                        <i class="fa-solid fa-circle-info"></i> Chọn ảnh mới để thay thế poster hiện tại.
                                    </div>

                                    <div class="mt-3">
                                        <label class="form-label fw-bold">Xem trước poster mới</label>

                                        <div class="poster-preview" id="imgPreviewBox" style="display:none;">
                                            <img id="imgPreview" src="" alt="Preview">
                                            <div class="poster-meta" id="imgPreviewText"></div>
                                        </div>

                                        <div class="text-secondary" id="imgPreviewHint">
                                            <i class="fa-solid fa-circle-info"></i> Chọn ảnh ở dropdown để xem trước.
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12 d-flex gap-2 mt-2">
                                    <button type="submit" class="btn btn-success fw-bold" style="border-radius:14px;">
                                        <i class="fa-solid fa-floppy-disk"></i> Cập nhật
                                    </button>

                                    <a href="${pageContext.request.contextPath}/admin/show"
                                       class="btn btn-outline-dark fw-bold" style="border-radius:14px;">
                                        <i class="fa-solid fa-ban"></i> Hủy
                                    </a>
                                </div>
                            </div>

                        </form>
                    </div>
                </div>

            </main>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            function toggleDropdown(listId) {
                var list = document.getElementById(listId);
                if (!list) return;
                list.style.display = (list.style.display === "block") ? "none" : "block";
            }

            function updateDirectorSelectedText(listId, textId) {
                var list = document.getElementById(listId);
                var textSpan = document.getElementById(textId);
                if (!list || !textSpan) return;

                var checked = list.querySelector("input[name='directorId']:checked");
                textSpan.textContent = checked ? checked.getAttribute("data-director-name") : "Chọn đạo diễn...";
            }

            function updateArtistSelectedText(listId, textId) {
                var list = document.getElementById(listId);
                var textSpan = document.getElementById(textId);
                if (!list || !textSpan) return;

                var selected = [];
                var checkedBoxes = list.querySelectorAll("input[type='checkbox'][name='artistIds']:checked");
                checkedBoxes.forEach(function (cb) {
                    selected.push(cb.getAttribute("data-artist-name"));
                });

                textSpan.textContent = (selected.length > 0) ? selected.join(", ") : "Chọn nghệ sĩ...";
            }

            window.addEventListener("load", function () {
                updateDirectorSelectedText('directorDropdownListAdd', 'directorSelectedTextAdd');
                updateArtistSelectedText('artistDropdownListAdd', 'artistSelectedTextAdd');
            });

            document.addEventListener("click", function (e) {
                var dContainer = document.getElementById("directorContainerAdd");
                var dList = document.getElementById("directorDropdownListAdd");
                if (dContainer && dList && !dContainer.contains(e.target)) dList.style.display = "none";

                var aContainer = document.getElementById("artistContainerAdd");
                var aList = document.getElementById("artistDropdownListAdd");
                if (aContainer && aList && !aContainer.contains(e.target)) aList.style.display = "none";
            });
        </script>

        <script>
            (function () {
                const select = document.getElementById('showImageDropdownSelect');
                const box = document.getElementById('imgPreviewBox');
                const img = document.getElementById('imgPreview');
                const text = document.getElementById('imgPreviewText');
                const hint = document.getElementById('imgPreviewHint');

                if (!select || !box || !img || !text || !hint) return;

                function normalizePath(p) {
                    p = (p || '').trim();
                    if (!p) return '';
                    if (p.startsWith('/')) p = p.substring(1);
                    return p;
                }

                function updatePreview() {
                    const file = normalizePath(select.value);

                    if (!file) {
                        box.style.display = 'none';
                        hint.style.display = '';
                        img.src = '';
                        text.textContent = '';
                        return;
                    }

                    const url = '${pageContext.request.contextPath}/' + file;

                    img.onload = function () {
                        hint.style.display = 'none';
                        box.style.display = '';
                    };

                    img.onerror = function () {
                        box.style.display = 'none';
                        hint.style.display = '';
                        img.src = '';
                        text.textContent = '';
                    };

                    img.src = url;
                    text.textContent = 'Poster mới: ' + file;
                }

                select.addEventListener('change', updatePreview);
                updatePreview();
            })();
        </script>

    </body>
</html>
