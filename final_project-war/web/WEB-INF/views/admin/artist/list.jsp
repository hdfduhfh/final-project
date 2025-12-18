<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý nghệ sĩ</title>

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

            .thumb{
                width: 56px;
                height: 56px;
                border-radius: 14px;
                object-fit: cover;
                border: 2px solid rgba(6,182,212,.25);
                box-shadow: 0 12px 30px rgba(0,0,0,.15);
                background:#fff;
            }

            .bio{
                max-width: 520px;
                display:-webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow:hidden;
            }

            .btn-icon{
                width: 36px;
                height: 36px;
                display:inline-grid;
                place-items:center;
                border-radius: 12px;
            }

            /* ===== POPUP DETAIL ARTIST (theme + rõ chữ) ===== */
            .artist-overlay {
                position: fixed;
                inset: 0;
                background: rgba(0,0,0,0.82);
                display: none;
                align-items: center;
                justify-content: center;
                z-index: 9999;
            }
            .artist-modal {
                background: #fff;
                border-radius: 18px;
                max-width: 980px;
                width: 92%;
                max-height: 90vh;
                display: flex;
                overflow: hidden;
                box-shadow: 0 30px 120px rgba(0,0,0,0.75);
                position: relative;
            }
            .artist-left {
                flex: 0 0 42%;
                background:
                    radial-gradient(700px 400px at 50% 20%, rgba(6,182,212,0.18), transparent 60%),
                    linear-gradient(180deg, #05060a, #0a0f1e);
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .artist-left img {
                max-width: 100%;
                max-height: 100%;
                object-fit: cover;
                display: block;
            }
            .artist-right {
                flex: 1;
                padding: 20px 24px;
                overflow-y: auto;
                background:#fff;
                color:#111827;
                -webkit-font-smoothing: antialiased;
                text-rendering: geometricPrecision;
            }
            .artist-title {
                font-size: 22px;
                font-weight: 950;
                color: #0f172a;
                margin-bottom: 10px;
            }
            .artist-meta, .artist-bio{
                font-size: 14px;
                line-height:1.6;
            }
            .artist-meta strong, .artist-bio strong{
                color:#0f172a;
                font-weight: 900;
            }
            .artist-close {
                position:absolute;
                top: 8px;
                left: 14px;
                font-size: 30px;
                color: #fff;
                cursor: pointer;
                user-select: none;
                z-index: 10000;
                text-shadow: 0 10px 24px rgba(0,0,0,0.6);
            }

            @media (max-width: 992px){
                .sidebar{
                    display:none;
                }
                .clear-x{
                    right: 52px;
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
                        <small>Quản lý nghệ sĩ</small>
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
                        <a class="btn btn-light fw-bold" href="${pageContext.request.contextPath}/admin/artist/add" style="border-radius:14px;">
                            <i class="fa-solid fa-circle-plus"></i> Thêm nghệ sĩ mới
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
                            <i class="fa-solid fa-user-group"></i>
                        </div>
                        <div>
                            <h1>Danh sách nghệ sĩ</h1>
                            <div class="crumb">Admin / Artist Management / List</div>
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
                                  action="${pageContext.request.contextPath}/admin/artist"
                                  id="searchForm">
                                <div class="input-group position-relative">
                                    <span class="input-group-text bg-white"><i class="fa-solid fa-magnifying-glass"></i></span>

                                    <input type="text"
                                           id="keywordInput"
                                           name="search"
                                           class="form-control"
                                           placeholder="Nhập tên nghệ sĩ cần tìm..."
                                           value="${searchKeyword != null ? searchKeyword : ''}"
                                           style="padding-right: 48px;" />

                                    <button type="submit" class="btn btn-warning fw-bold">
                                        Tìm
                                    </button>
                                </div>
                            </form>
                        </div>

                        <div class="col-lg-4 text-lg-end">
                            <div class="fw-bold text-white-50">
                                Tổng số nghệ sĩ: <span class="text-white">${totalArtists}</span>
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
                                    <th>Tên nghệ sĩ</th>
                                    <th>Vai trò</th>
                                    <th>Giới thiệu</th>
                                    <th>Hình ảnh</th>
                                    <th style="width:210px;">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="a" items="${artists}">
                                    <tr>
                                        <td class="fw-bold">
                                            <i class="fa-solid fa-user text-secondary"></i> ${a.name}
                                        </td>
                                        <td>
                                            <span class="badge text-bg-light border fw-bold">
                                                <i class="fa-solid fa-id-badge"></i> ${a.role}
                                            </span>
                                        </td>
                                        <td><div class="bio">${a.bio}</div></td>
                                        <td>
                                            <c:if test="${not empty a.artistImage}">
                                                <img src="${pageContext.request.contextPath}/${a.artistImage}"
                                                     alt="${a.name}"
                                                     class="thumb"/>
                                            </c:if>
                                        </td>
                                        <td class="text-nowrap">
                                            <button type="button"
                                                    class="btn btn-info btn-icon"
                                                    title="Chi tiết"
                                                    data-name="${a.name}"
                                                    data-role="${a.role}"
                                                    data-bio="${a.bio}"
                                                    data-img="${pageContext.request.contextPath}/${a.artistImage}"
                                                    onclick="openArtistDetail(this)">
                                                <i class="fa-solid fa-circle-info"></i>
                                            </button>

                                            <a href="${pageContext.request.contextPath}/admin/artist/edit?id=${a.artistID}"
                                               class="btn btn-primary btn-icon"
                                               title="Sửa">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>
                                            <button type="button"
                                                    class="btn btn-danger btn-icon"
                                                    title="Xóa"
                                                    onclick="openDeleteArtistModal('${pageContext.request.contextPath}/admin/artist/delete?id=${a.artistID}',
                                                                    '${fn:escapeXml(a.name)}')">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>

                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty artists}">
                                    <tr>
                                        <td colspan="5" class="text-center py-5 text-secondary">
                                            <i class="fa-regular fa-folder-open fa-lg"></i>
                                            <div class="mt-2 fw-bold">Không có nghệ sĩ nào.</div>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="mt-3">
                        <nav aria-label="pagination">
                            <ul class="pagination justify-content-center mb-0">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/admin/artist?page=${currentPage - 1}">
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
                                           href="${pageContext.request.contextPath}/admin/artist?page=${currentPage + 1}">
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

        <!-- ================= POPUP DETAIL ARTIST ================= -->
        <div id="artistOverlay" class="artist-overlay">
            <div class="artist-close" onclick="closeArtistDetail()">&times;</div>

            <div class="artist-modal">
                <div class="artist-left">
                    <img id="artistDetailImg" src="" alt="Artist">
                </div>

                <div class="artist-right">
                    <div id="artistDetailName" class="artist-title"></div>

                    <div class="artist-meta mb-2">
                        <strong><i class="fa-solid fa-id-badge"></i> Vai trò:</strong>
                        <span id="artistDetailRole"></span>
                    </div>

                    <div class="artist-bio">
                        <strong><i class="fa-solid fa-align-left"></i> Giới thiệu:</strong><br>
                        <span id="artistDetailBio"></span>
                    </div>

                    <div class="mt-3 d-flex justify-content-end">
                        <button type="button" class="btn btn-outline-dark fw-bold" onclick="closeArtistDetail()" style="border-radius:14px;">
                            <i class="fa-solid fa-xmark"></i> Đóng
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                            function openDeleteArtistModal(deleteUrl, artistName) {
                                const nameEl = document.getElementById('deleteArtistName');
                                const confirmBtn = document.getElementById('deleteArtistConfirmBtn');

                                if (nameEl)
                                    nameEl.textContent = artistName || '';
                                if (confirmBtn)
                                    confirmBtn.setAttribute('href', deleteUrl || '#');

                                const modalEl = document.getElementById('deleteArtistModal');
                                const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                                modal.show();
                            }
        </script>


        <!-- Popup detail -->
        <script>
            function openArtistDetail(btn) {
                var overlay = document.getElementById("artistOverlay");

                var name = btn.getAttribute("data-name") || "";
                var role = btn.getAttribute("data-role") || "";
                var bio = btn.getAttribute("data-bio") || "";
                var img = btn.getAttribute("data-img") || "";

                document.getElementById("artistDetailName").textContent = name;
                document.getElementById("artistDetailRole").textContent = role;
                document.getElementById("artistDetailBio").textContent = bio;

                var imgEl = document.getElementById("artistDetailImg");
                if (!img || img.endsWith("/null")) {
                    imgEl.src = "";
                    imgEl.alt = "No image";
                    imgEl.style.display = "none";
                } else {
                    imgEl.style.display = "block";
                    imgEl.src = img;
                }

                overlay.style.display = "flex";
            }

            function closeArtistDetail() {
                document.getElementById("artistOverlay").style.display = "none";
            }

            document.addEventListener("click", function (e) {
                var overlay = document.getElementById("artistOverlay");
                if (overlay && overlay.style.display === "flex") {
                    if (e.target === overlay)
                        closeArtistDetail();
                }
            });
        </script>

        <script>
            (function () {
                const input = document.getElementById('keywordInput');
                if (!input)
                    return;

                const group = input.closest('.input-group');
                if (!group)
                    return;

                // tạo nút X
                const clearBtn = document.createElement('button');
                clearBtn.type = 'button';
                clearBtn.className = 'btn btn-outline-secondary';
                clearBtn.setAttribute('aria-label', 'Clear search');
                clearBtn.style.display = 'none';
                clearBtn.innerHTML = '<i class="fa-solid fa-xmark"></i>';

                // chèn nút X trước nút submit
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
                    // nếu muốn tự submit sau khi clear:
                    // if (input.form) input.form.submit();
                });

                input.addEventListener('input', toggle);
                input.addEventListener('change', toggle);

                toggle(); // init (khi reload có sẵn keyword)
            })();
        </script>
        <!-- ===== DELETE ARTIST CONFIRM MODAL (Bootstrap) ===== -->
        <div class="modal fade" id="deleteArtistModal" tabindex="-1" aria-hidden="true">
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
                                <i class="fa-solid fa-user-xmark text-danger fs-4"></i>
                            </div>

                            <div>
                                <div class="fw-bold mb-1">Bạn chắc chắn muốn xóa nghệ sĩ này?</div>
                                <div class="text-secondary">
                                    Nghệ sĩ: <span id="deleteArtistName" class="fw-bold"></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer" style="border:none;">
                        <button type="button" class="btn btn-outline-dark fw-bold" data-bs-dismiss="modal">
                            <i class="fa-solid fa-xmark"></i> Hủy
                        </button>

                        <a href="#" id="deleteArtistConfirmBtn" class="btn btn-danger fw-bold">
                            <i class="fa-solid fa-trash"></i> Xóa
                        </a>
                    </div>
                </div>
            </div>
        </div>
        s
    </body>
</html>
