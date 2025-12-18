<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm nghệ sĩ</title>

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
                background: rgba(245,158,11,.16);
                border-color: rgba(245,158,11,.35);
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

            /* Custom dropdown role (giữ id/logic) */
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
                max-height: 200px;
                overflow-y: auto;
                display: none;
                z-index: 999;
                border-radius: 14px;
                box-shadow: 0 18px 45px rgba(0,0,0,.18);
                padding: 6px 0;
            }
            .dd-list label{
                display:block;
                padding: 10px 12px;
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

            .preview{
                border-radius: 16px;
                overflow:hidden;
                border: 1px solid rgba(0,0,0,.12);
                box-shadow: 0 14px 35px rgba(0,0,0,.18);
                background:#fff;
                max-width: 280px;
            }
            .preview img{
                width:100%;
                display:block;
                object-fit:cover;
            }
            .preview .meta{
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

            <!-- SIDEBAR -->
            <aside class="sidebar">
                <div class="brand">
                    <div class="logo"><i class="fa-solid fa-masks-theater"></i></div>
                    <div>
                        <div class="title">Theater Admin</div>
                        <small>Thêm nghệ sĩ</small>
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
                            <i class="fa-solid fa-circle-plus"></i>
                        </div>
                        <div>
                            <h1>Thêm nghệ sĩ</h1>
                            <div class="crumb">Admin / Artist Management / Add</div>
                        </div>
                    </div>
                </div>

                <!-- Alerts -->
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

                <!-- FORM CARD -->
                <div class="card-form mt-3">
                    <div class="card-header">
                        <i class="fa-solid fa-user-plus"></i> Thông tin nghệ sĩ
                    </div>

                    <div class="p-4 text-dark">
                        <form method="post"
                              action="${pageContext.request.contextPath}/admin/artist/add"
                              novalidate>

                            <div class="row g-3">

                                <!-- Name -->
                                <div class="col-lg-6">
                                    <label class="form-label fw-bold">
                                        Tên nghệ sĩ <span class="req">*</span>
                                    </label>
                                    <input type="text"
                                           name="name"
                                           class="form-control"
                                           value="${param.name != null ? param.name : ''}"
                                           placeholder="VD: Trấn Thành, Thành Lộc..."
                                           required>
                                </div>

                                <!-- Role dropdown custom -->
                                <div class="col-lg-6">
                                    <label class="form-label fw-bold">
                                        Vai trò <span class="req">*</span>
                                    </label>

                                    <div class="multi-select-dropdown" id="roleContainerAdd">
                                        <div id="roleDropdownHeaderAdd"
                                             class="dd-header"
                                             onclick="toggleDropdown('roleDropdownListAdd')">
                                            <span id="roleSelectedTextAdd" class="text">Chọn vai trò...</span>
                                            <span><i class="fa-solid fa-chevron-down"></i></span>
                                        </div>

                                        <div id="roleDropdownListAdd" class="dd-list">
                                            <label>
                                                <input type="radio"
                                                       name="role"
                                                       value="Đạo diễn"
                                                       data-role-name="Đạo diễn"
                                                       <c:if test="${param.role eq 'Đạo diễn'}">checked</c:if>
                                                           onchange="updateRoleSelectedText('roleDropdownListAdd', 'roleSelectedTextAdd')">
                                                       <i class="fa-solid fa-video me-1 text-secondary"></i> Đạo diễn
                                                </label>

                                                <label>
                                                    <input type="radio"
                                                           name="role"
                                                           value="Diễn viên"
                                                           data-role-name="Diễn viên"
                                                    <c:if test="${param.role eq 'Diễn viên'}">checked</c:if>
                                                        onchange="updateRoleSelectedText('roleDropdownListAdd', 'roleSelectedTextAdd')">
                                                    <i class="fa-solid fa-person-walking me-1 text-secondary"></i> Diễn viên
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Bio -->
                                    <div class="col-12">
                                        <label class="form-label fw-bold">
                                            Tiểu sử <span class="req">*</span>
                                        </label>
                                        <textarea name="bio"
                                                  rows="5"
                                                  class="form-control"
                                                  placeholder="Mô tả ngắn về nghệ sĩ..."
                                                  required>${param.bio != null ? param.bio : ''}</textarea>
                                </div>

                                <!-- Image dropdown -->
                                <div class="col-lg-6">
                                    <label class="form-label fw-bold">
                                        Hình ảnh nghệ sĩ <span class="req">*</span>
                                    </label>

                                    <select name="artistImage" class="form-select" id="artistImageSelect" required>
                                        <option value="">Chọn hình ảnh nghệ sĩ từ thư mục</option>
                                        <c:forEach var="img" items="${imageFiles}">
                                            <option value="${img}"
                                                    <c:if test="${param.artistImage eq img}">selected</c:if>>
                                                ${img}
                                            </option>
                                        </c:forEach>
                                    </select>

                                    <div class="form-text">
                                        <i class="fa-regular fa-image"></i> Ảnh sẽ hiển thị trong danh sách và popup chi tiết.
                                    </div>
                                </div>

                                <!-- Preview (optional - tự đổi khi select) -->
                                <div class="col-lg-6">
                                    <label class="form-label fw-bold">Xem trước</label>
                                    <div class="preview" id="imgPreviewBox" style="display:none;">
                                        <img id="imgPreview" src="" alt="Preview">
                                        <div class="meta" id="imgPreviewText"></div>
                                    </div>
                                    <div class="text-secondary" id="imgPreviewHint">
                                        <i class="fa-solid fa-circle-info"></i> Chọn ảnh ở dropdown để xem trước.
                                    </div>
                                </div>

                                <!-- Actions -->
                                <div class="col-12 d-flex gap-2 mt-2">
                                    <button type="submit" class="btn btn-warning fw-bold" style="border-radius:14px;">
                                        <i class="fa-solid fa-circle-plus"></i> Thêm Nghệ Sĩ
                                    </button>

                                    <a href="${pageContext.request.contextPath}/admin/artist"
                                       class="btn btn-outline-dark fw-bold" style="border-radius:14px;">
                                        <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                                    </a>
                                </div>

                            </div>
                        </form>
                    </div>
                </div>

            </main>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                           function toggleDropdown(listId) {
                                                               var list = document.getElementById(listId);
                                                               if (!list)
                                                                   return;
                                                               list.style.display = (list.style.display === "none" || list.style.display === "") ? "block" : "none";
                                                           }

                                                           function updateRoleSelectedText(listId, textId) {
                                                               var list = document.getElementById(listId);
                                                               var textSpan = document.getElementById(textId);
                                                               if (!list || !textSpan)
                                                                   return;

                                                               var checked = list.querySelector("input[type='radio'][name='role']:checked");
                                                               if (checked) {
                                                                   textSpan.textContent = checked.getAttribute("data-role-name") || "Chọn vai trò...";
                                                               } else {
                                                                   textSpan.textContent = "Chọn vai trò...";
                                                               }
                                                           }

                                                           window.addEventListener("load", function () {
                                                               updateRoleSelectedText('roleDropdownListAdd', 'roleSelectedTextAdd');
                                                           });

                                                           document.addEventListener("click", function (e) {
                                                               var container = document.getElementById("roleContainerAdd");
                                                               var list = document.getElementById("roleDropdownListAdd");
                                                               if (container && list && !container.contains(e.target)) {
                                                                   list.style.display = "none";
                                                               }
                                                           });
        </script>

        <!-- Preview ảnh theo dropdown (không đổi servlet) -->
        <script>
            (function () {
                const select = document.getElementById('artistImageSelect');
                const box = document.getElementById('imgPreviewBox');
                const img = document.getElementById('imgPreview');
                const text = document.getElementById('imgPreviewText');
                const hint = document.getElementById('imgPreviewHint');

                if (!select || !box || !img || !text || !hint)
                    return;

                function updatePreview() {
                    const file = select.value;
                    if (!file) {
                        box.style.display = 'none';
                        hint.style.display = '';
                        img.src = '';
                        text.textContent = '';
                        return;
                    }

                    // Giả định ảnh nằm trong cùng cấu trúc bạn đang dùng khi render: contextPath + "/" + file
                    // Nếu bạn lưu trong folder như "images/artists/xxx.jpg" thì file đã có path sẵn.
                    const url = '${pageContext.request.contextPath}/' + file;

                    img.src = url;
                    text.textContent = file;

                    hint.style.display = 'none';
                    box.style.display = '';
                }

                select.addEventListener('change', updatePreview);
                updatePreview(); // init khi reload có param.artistImage
            })();
        </script>

    </body>
</html>
