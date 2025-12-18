<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý vở diễn</title>

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome 6 -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <style>
            :root{
                --bg:#0b1220;
                --panel:#0f1b33;
                --card:#ffffff;
                --muted:#8ea0c4;
                --line:rgba(255,255,255,.08);
                --primary:#4f46e5;
                --danger:#ef4444;
                --success:#22c55e;
                --warning:#f59e0b;
                --info:#06b6d4;
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
                background: rgba(79,70,229,.18);
                border-color: rgba(79,70,229,.35);
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

            /* Stat cards */
            .stat-grid{
                margin-top: 14px;
                display:grid;
                grid-template-columns: repeat(4, minmax(0, 1fr));
                gap: 12px;
            }
            @media (max-width: 992px){
                .sidebar{
                    display:none;
                }
                .stat-grid{
                    grid-template-columns: repeat(2, minmax(0, 1fr));
                }
            }
            @media (max-width: 576px){
                .stat-grid{
                    grid-template-columns: 1fr;
                }
            }

            .stat{
                background: rgba(255,255,255,.92);
                border-radius: 18px;
                padding: 14px 14px;
                border: 1px solid rgba(0,0,0,.06);
                box-shadow: 0 18px 45px rgba(0,0,0,.25);
                color:#0b1220;
                display:flex;
                align-items:center;
                justify-content:space-between;
                gap:12px;
            }
            .stat .label{
                font-size: 12px;
                color:#58627a;
                font-weight: 800;
                letter-spacing:.2px;
            }
            .stat .value{
                font-size: 22px;
                font-weight: 950;
                margin-top: 2px;
            }
            .stat .icon{
                width: 44px;
                height: 44px;
                border-radius: 16px;
                display:grid;
                place-items:center;
                color:#fff;
                box-shadow: 0 18px 35px rgba(0,0,0,.18);
            }
            .i-total{
                background: linear-gradient(135deg, #4f46e5, #22c55e);
            }
            .i-on{
                background: linear-gradient(135deg, #22c55e, #06b6d4);
            }
            .i-up{
                background: linear-gradient(135deg, #f59e0b, #4f46e5);
            }
            .i-cancel{
                background: linear-gradient(135deg, #ef4444, #f59e0b);
            }

            /* Controls */
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
            .poster{
                width: 56px;
                height: 74px;
                object-fit: cover;
                border-radius: 12px;
                border: 2px solid rgba(245,158,11,.25);
                box-shadow: 0 12px 30px rgba(0,0,0,.15);
            }

            .desc{
                max-width: 520px;
                display:-webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow:hidden;
            }

            .badge-status{
                font-weight: 800;
                border-radius: 999px;
                padding: 6px 10px;
                font-size: 12px;
            }

            /* Action buttons compact */
            .btn-icon{
                width: 36px;
                height: 36px;
                display:inline-grid;
                place-items:center;
                border-radius: 12px;
            }

            /* Overlay + Popup (giữ logic) */
            .show-detail-overlay {
                position: fixed;
                inset: 0;
                background: rgba(0,0,0,0.82);
                display: none;
                align-items: center;
                justify-content: center;
                z-index: 9999;
            }
            .show-detail-modal {
                background: white;
                border-radius: 18px;
                max-width: 980px;
                width: 92%;
                max-height: 90vh;
                display: flex;
                overflow: hidden;
                box-shadow: 0 30px 120px rgba(0,0,0,0.75);
                position: relative;
            }
            .show-detail-left {
                flex: 0 0 45%;
                background:
                    radial-gradient(700px 400px at 50% 20%, rgba(245,158,11,0.18), transparent 60%),
                    linear-gradient(180deg, #05060a, #0a0f1e);
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .show-detail-left img {
                max-width: 100%;
                max-height: 100%;
                object-fit: cover;
            }

            /* ===== POPUP TEXT CLEAR (fixed) ===== */
            .show-detail-right{
                flex: 1;
                padding: 22px 24px;
                overflow-y: auto;
                background: #ffffff !important;
                color: #111827 !important;
                -webkit-font-smoothing: antialiased;
                -moz-osx-font-smoothing: grayscale;
                text-rendering: geometricPrecision;
            }
            .show-detail-title {
                font-size: 22px;
                font-weight: 950;
                color: #0f172a !important;
                margin-bottom: 10px;
                letter-spacing: .2px;
                text-shadow:none !important;
            }
            .show-detail-artists {
                margin-top: 10px;
                font-size: 14px;
                line-height: 1.6;
                white-space: normal;
                word-break: break-word;
                color:#111827 !important;
                font-weight:600;
            }
            .show-detail-meta{
                color:#111827 !important;
                font-weight:600;
            }
            .show-detail-meta strong,
            .show-detail-artists strong{
                color:#0f172a !important;
                font-weight:900 !important;
            }
            #detailDirector,
            #detailArtists{
                color:#111827 !important;
                font-weight:700 !important;
            }

            .show-detail-close {
                position: absolute;
                top: 8px;
                right: 14px;
                font-size: 30px;
                color: #fff;
                cursor: pointer;
                z-index: 10000;
                text-shadow: 0 10px 24px rgba(0,0,0,0.6);
            }

            /* Magnifier */
            .poster-wrap{
                position:relative;
                width:100%;
                height:100%;
                overflow:hidden;
            }
            .poster-wrap img{
                width:100%;
                height:100%;
                object-fit:cover;
                display:block;
            }
            .magnifier-lens{
                position:absolute;
                width:180px;
                height:180px;
                border-radius:50%;
                border:4px solid rgba(255,255,255,0.95);
                box-shadow:0 10px 30px rgba(0,0,0,0.35);
                pointer-events:none;
                display:none;
                background-repeat:no-repeat;
                transform:translate(-50%, -50%);
            }
            /* Poster loading overlay */
            .poster-wrap{
                position:relative;
            }
            .poster-loading{
                position:absolute;
                inset:0;
                display:none;
                align-items:center;
                justify-content:center;
                background: rgba(0,0,0,0.35);
                z-index: 2;
            }

            /* Cho popup render “nhẹ” hơn lúc mở */
            .show-detail-overlay{
                will-change: opacity;
            }
            .show-detail-modal{
                will-change: transform;
            }
            /* Clear X nằm TRONG ô input (chừa chỗ cho nút Tìm) */
            .clear-x{
                position:absolute;
                right: 56px;            /* chừa chỗ cho nút Tìm */
                top: 50%;
                transform: translateY(-50%);
                width: 26px;
                height: 26px;
                border-radius: 999px;

                display:none;           /* mặc định ẩn */
                place-items:center;

                cursor:pointer;
                user-select:none;
                color:#6b7280;
                background: transparent;
                border: none;
                padding:0;
            }
            .clear-x:hover{
                background:#f3f4f6;
            }


        </style>
    </head>

    <body>
        <div class="admin-wrap">

            <!-- SIDEBAR (chỉ giữ 2 nút: Danh sách vở diễn + Quản lý nghệ sĩ) -->
            <aside class="sidebar">
                <div class="brand">
                    <div class="logo"><i class="fa-solid fa-masks-theater"></i></div>
                    <div>
                        <div class="title">Theater Admin</div>
                        <small>Quản lý vở diễn</small>
                    </div>
                </div>

                <div class="nav-group">
                    <a class="nav-item active" href="${pageContext.request.contextPath}/admin/show">
                        <i class="fa-solid fa-clapperboard"></i> Danh sách vở diễn
                    </a>
                    <a class="nav-item" href="${pageContext.request.contextPath}/admin/showArtist">
                        <i class="fa-solid fa-people-group"></i> Quản lý ShowArtist
                    </a>
                </div>

                <hr style="border-color: var(--line);">

                <!-- Quick actions (chỉ giữ: Về Dashboard) -->
                <div class="px-2">
                    <div class="text-uppercase" style="font-size:12px; color:var(--muted); font-weight:900; letter-spacing:.3px;">
                        Quick actions
                    </div>
                    <div class="mt-2 d-grid gap-2">
                        <a class="btn btn-outline-light fw-bold" href="${pageContext.request.contextPath}/admin/dashboard" style="border-radius:14px;">
                            <i class="fa-solid fa-arrow-left"></i> Về Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/show/add" class="btn btn-light fw-bold" style="border-radius:14px;">
                            <i class="fa-solid fa-circle-plus"></i> Thêm vở diễn
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
                            <i class="fa-solid fa-clapperboard"></i>
                        </div>
                        <div>
                            <h1>Danh sách vở diễn</h1>
                            <div class="crumb">Admin / Show Management</div>
                        </div>
                    </div>
                </div>

                <!-- ALERTS -->
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

                <!-- STATS -->
                <div class="stat-grid">
                    <div class="stat">
                        <div>
                            <div class="label">TỔNG SỐ VỞ DIỄN</div>
                            <div class="value">${statTotal}</div>
                        </div>
                        <div class="icon i-total"><i class="fa-solid fa-layer-group"></i></div>
                    </div>

                    <div class="stat">
                        <div>
                            <div class="label">ĐANG CHIẾU</div>
                            <div class="value">${statOngoing}</div>
                        </div>
                        <div class="icon i-on"><i class="fa-solid fa-play"></i></div>
                    </div>

                    <div class="stat">
                        <div>
                            <div class="label">SẮP CHIẾU</div>
                            <div class="value">${statUpcoming}</div>
                        </div>
                        <div class="icon i-up"><i class="fa-solid fa-calendar-days"></i></div>
                    </div>

                    <div class="stat">
                        <div>
                            <div class="label">BỊ HỦY</div>
                            <div class="value">${statCancelled}</div>
                        </div>
                        <div class="icon i-cancel"><i class="fa-solid fa-ban"></i></div>
                    </div>
                </div>

                <!-- CONTROLS (nút Tìm sát input như trang Quản lý nghệ sĩ) -->
                <div class="panel">
                    <form method="get" action="${pageContext.request.contextPath}/admin/show">
                        <div class="row g-2 align-items-center">
                            <div class="col-lg-8">
                                <div class="input-group position-relative">
                                    <span class="input-group-text bg-white">
                                        <i class="fa-solid fa-magnifying-glass"></i>
                                    </span>

                                    <input type="text"
                                           id="keywordInput"
                                           name="keyword"
                                           value="${searchKeyword}"
                                           class="form-control"
                                           placeholder="Tìm theo tên vở diễn..."
                                           style="padding-right:48px;">

                                    <button type="submit" class="btn btn-warning fw-bold">Tìm</button>
                                </div>



                            </div>
                        </div>
                    </form>
                </div>


                <!-- TABLE -->
                <div class="table-wrap">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th style="width:60px;">#</th>
                                    <th>Tên vở diễn</th>
                                    <th>Mô tả</th>
                                    <th style="width:120px;">Thời lượng</th>
                                    <th style="width:150px;">Trạng thái</th>
                                    <th style="width:110px;">Poster</th>
                                    <th style="width:170px;">Ngày tạo</th>
                                    <th style="width:190px;">Hành động</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="s" items="${shows}" varStatus="loop">
                                    <c:set var="directorName" value="${directorMap[s.showID]}" />
                                    <c:set var="actorNames" value="${actorMap[s.showID]}" />

                                    <tr>
                                        <td class="fw-bold">${loop.index + 1}</td>

                                        <td class="fw-bold">
                                            <div class="d-flex align-items-center gap-2">
                                                <i class="fa-solid fa-clapperboard text-primary"></i>
                                                <span>${s.showName}</span>
                                            </div>
                                        </td>

                                        <td><div class="desc">${s.description}</div></td>

                                        <td><span class="fw-bold">${s.durationMinutes}</span> phút</td>

                                        <td>
                                            <span class="badge badge-status text-bg-light border">
                                                <i class="fa-solid fa-tag"></i> ${s.status}
                                            </span>
                                        </td>

                                        <td>
                                            <c:if test="${not empty s.showImage}">
                                                <img src="${pageContext.request.contextPath}/${s.showImage}" class="poster" alt="Poster">
                                            </c:if>
                                        </td>

                                        <td>
                                            <fmt:formatDate value="${s.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>

                                        <td class="text-nowrap">
                                            <button type="button"
                                                    class="btn btn-info btn-icon"
                                                    title="Xem chi tiết"
                                                    data-show-name="${fn:escapeXml(s.showName)}"
                                                    data-poster-url="${pageContext.request.contextPath}/${s.showImage}"
                                                    data-director="${fn:escapeXml(directorName)}"
                                                    data-actors="${fn:escapeXml(actorNames)}"
                                                    onclick="openShowDetail(this)">
                                                <i class="fa-solid fa-circle-info"></i>
                                            </button>

                                            <a href="${pageContext.request.contextPath}/admin/show/edit?id=${s.showID}"
                                               class="btn btn-primary btn-icon"
                                               title="Sửa vở diễn">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>

                                            <button type="button"
                                                    class="btn btn-danger btn-icon"
                                                    title="Xóa vở diễn"
                                                    onclick="openDeleteShowModal('${pageContext.request.contextPath}/admin/show/delete?id=${s.showID}',
                        '${fn:escapeXml(s.showName)}')">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>

                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty shows}">
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-secondary">
                                            <i class="fa-regular fa-folder-open fa-lg"></i>
                                            <div class="mt-2 fw-bold">Không có vở diễn nào.</div>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- PAGINATION -->
                <div class="mt-3">
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="pagination">
                            <ul class="pagination justify-content-center mb-0">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/admin/show?page=${currentPage - 1}&keyword=${fn:escapeXml(searchKeyword)}">
                                            <i class="fa-solid fa-arrow-left"></i> Trước
                                        </a>
                                    </li>
                                </c:if>

                                <li class="page-item disabled">
                                    <span class="page-link">
                                        Trang <b>${currentPage}</b> / <b>${totalPages}</b>
                                        &nbsp; (Tổng: ${totalItems} vở)
                                    </span>
                                </li>

                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/admin/show?page=${currentPage + 1}&keyword=${fn:escapeXml(searchKeyword)}">
                                            Sau <i class="fa-solid fa-arrow-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </c:if>
                </div>

            </main>
        </div>

        <!-- POPUP DETAIL SHOW -->
        <div id="showDetailOverlay" class="show-detail-overlay">
            <div class="show-detail-close" onclick="closeShowDetail()">&times;</div>

            <div class="show-detail-modal">
                <!-- LEFT: POSTER -->
                <div class="show-detail-left">
                    <div class="poster-wrap" id="posterWrap">
                        <img id="detailPoster" src="" alt="Poster" decoding="async">
                        <div class="poster-loading" id="posterLoading">
                            <div class="spinner-border text-warning" role="status" style="width:3rem;height:3rem;">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                        <div class="magnifier-lens" id="magnifierLens"></div>
                        >
                    </div>
                </div>

                <!-- RIGHT: INFO -->
                <div class="show-detail-right">
                    <div id="detailTitle" class="show-detail-title"></div>

                    <div class="mb-2 show-detail-meta">
                        <strong><i class="fa-solid fa-user-tie"></i> Đạo diễn:</strong>
                        <span id="detailDirector"></span>
                    </div>

                    <div class="show-detail-artists">
                        <strong><i class="fa-solid fa-users"></i> Nghệ sĩ tham gia:</strong><br>
                        <span id="detailArtists"></span>
                    </div>

                    <div class="mt-3">
                        <button class="btn btn-outline-dark fw-bold" onclick="closeShowDetail()">
                            <i class="fa-solid fa-xmark"></i> Đóng
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                            function openDeleteShowModal(deleteUrl, showName) {
                                const nameEl = document.getElementById('deleteShowName');
                                const confirmBtn = document.getElementById('deleteShowConfirmBtn');

                                if (nameEl)
                                    nameEl.textContent = showName || '';
                                if (confirmBtn)
                                    confirmBtn.setAttribute('href', deleteUrl || '#');

                                const modalEl = document.getElementById('deleteShowModal');
                                const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                                modal.show();
                            }
        </script>



        <script>
            (function () {
                const input = document.getElementById('keywordInput');
                if (!input)
                    return;

                const group = input.closest('.input-group');
                if (!group)
                    return;

                // Tạo nút X
                const clearBtn = document.createElement('button');
                clearBtn.type = 'button';
                clearBtn.className = 'btn btn-outline-secondary';
                clearBtn.setAttribute('aria-label', 'Clear search');
                clearBtn.style.display = 'none';
                clearBtn.innerHTML = '<i class="fa-solid fa-xmark"></i>';

                // Chèn nút X NGAY TRƯỚC nút submit (Tìm) => giống trang nghệ sĩ
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
                    // Nếu muốn xóa xong tự submit lại:
                    // input.form && input.form.submit();
                });

                input.addEventListener('input', toggle);
                input.addEventListener('change', toggle);

                toggle(); // init khi reload có sẵn keyword
            })();
        </script>


        <script>
            const overlay = document.getElementById("showDetailOverlay");
            const modal = overlay.querySelector(".show-detail-modal");

            const titleEl = document.getElementById("detailTitle");
            const directorEl = document.getElementById("detailDirector");
            const artistsEl = document.getElementById("detailArtists");

            const posterImg = document.getElementById("detailPoster");
            const posterLoading = document.getElementById("posterLoading");

            // Preload image helper
            function preloadImage(url) {
                return new Promise((resolve, reject) => {
                    const img = new Image();
                    img.onload = () => resolve(url);
                    img.onerror = reject;
                    img.src = url;
                });
            }

            async function openShowDetail(btn) {
                // 1) Set text trước (nhẹ, popup hiện liền)
                titleEl.textContent = btn.getAttribute("data-show-name") || "";
                directorEl.textContent = btn.getAttribute("data-director") || "(Chưa có)";
                artistsEl.textContent = btn.getAttribute("data-actors") || "";

                // 2) Mở popup ngay lập tức
                overlay.style.display = "flex";

                // 3) Show loading + clear ảnh cũ (tránh dùng ảnh cũ rồi mới đổi)
                posterLoading.style.display = "flex";
                posterImg.removeAttribute("src");

                const url = btn.getAttribute("data-poster-url") || "";
                if (!url) {
                    posterLoading.style.display = "none";
                    return;
                }

                // 4) Load ảnh trước bằng Image() -> xong mới set vào DOM
                try {
                    await preloadImage(url);
                    // set vào img thật
                    posterImg.src = url;
                } catch (e) {
                    // nếu lỗi, tắt loading
                    posterImg.removeAttribute("src");
                } finally {
                    posterLoading.style.display = "none";
                }
            }

            function closeShowDetail() {
                overlay.style.display = "none";
                posterLoading.style.display = "none";
                posterImg.removeAttribute("src");
            }

            // ✅ Click ngoài modal thì đóng (KHÔNG dựa vào class btn-info nữa)
            overlay.addEventListener("click", function (e) {
                // nếu click trực tiếp lên nền overlay (không phải modal) -> đóng
                if (e.target === overlay) {
                    closeShowDetail();
                }
            });

            // ESC to close
            document.addEventListener("keydown", function (e) {
                if (e.key === "Escape" && overlay.style.display === "flex") {
                    closeShowDetail();
                }
            });
        </script>


        <script>
            (function () {
                const zoom = 2.2;

                function setupMagnifier() {
                    const wrap = document.getElementById("posterWrap");
                    const img = document.getElementById("detailPoster");
                    const lens = document.getElementById("magnifierLens");
                    if (!wrap || !img || !lens)
                        return;

                    function showLens() {
                        if (!img.src)
                            return;
                        lens.style.display = "block";
                        lens.style.backgroundImage = "url('" + img.src + "')";
                    }

                    function hideLens() {
                        lens.style.display = "none";
                    }

                    function moveLens(e) {
                        if (lens.style.display !== "block")
                            return;

                        const rect = wrap.getBoundingClientRect();
                        const x = e.clientX - rect.left;
                        const y = e.clientY - rect.top;

                        const size = lens.offsetWidth;
                        const half = size / 2;

                        const cx = Math.max(half, Math.min(x, rect.width - half));
                        const cy = Math.max(half, Math.min(y, rect.height - half));

                        lens.style.left = cx + "px";
                        lens.style.top = cy + "px";

                        lens.style.backgroundSize =
                                (rect.width * zoom) + "px " + (rect.height * zoom) + "px";

                        const bgX = -(cx * zoom - half);
                        const bgY = -(cy * zoom - half);
                        lens.style.backgroundPosition = bgX + "px " + bgY + "px";
                    }

                    wrap.addEventListener("mouseenter", showLens);
                    wrap.addEventListener("mouseleave", hideLens);
                    wrap.addEventListener("mousemove", moveLens);

                    img.addEventListener("load", function () {
                        lens.style.backgroundImage = "url('" + img.src + "')";
                    });
                }

                window.addEventListener("load", setupMagnifier);
            })();
        </script>
        <!-- ===== DELETE CONFIRM MODAL (Bootstrap) ===== -->
        <div class="modal fade" id="deleteShowModal" tabindex="-1" aria-hidden="true">
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
                                <div class="fw-bold mb-1">Bạn chắc chắn muốn xóa vở diễn này?</div>
                                <div class="text-secondary">
                                    Vở diễn: <span id="deleteShowName" class="fw-bold"></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer" style="border:none;">
                        <button type="button" class="btn btn-outline-dark fw-bold" data-bs-dismiss="modal">
                            <i class="fa-solid fa-xmark"></i> Hủy
                        </button>

                        <a href="#" id="deleteShowConfirmBtn" class="btn btn-danger fw-bold">
                            <i class="fa-solid fa-trash"></i> Xóa
                        </a>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>
