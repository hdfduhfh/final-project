<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thùng rác - Vở diễn</title>

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

            .btn-icon{
                width: 36px;
                height: 36px;
                display:inline-grid;
                place-items:center;
                border-radius: 12px;
            }

            /* ✅ THÊM STYLE CHO BADGE BẢO VỆ */
            .badge-protected {
                background: linear-gradient(135deg, #ef4444, #dc2626);
                border: 1px solid rgba(255,255,255,.15);
                box-shadow: 0 4px 12px rgba(239,68,68,.35);
                animation: pulse-glow 2s ease-in-out infinite;
            }


            .badge-auto-delete {
                background: linear-gradient(135deg, #f59e0b, #d97706);
                border: 1px solid rgba(255,255,255,.15);
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
                        <small>Thùng rác</small>
                    </div>
                </div>

                <div class="nav-group">
                    <a class="nav-item" href="${pageContext.request.contextPath}/admin/show">
                        <i class="fa-solid fa-clapperboard"></i> Danh sách vở diễn
                    </a>
                </div>

                <hr style="border-color: var(--line);">

                <div class="px-2">
                    <div class="text-uppercase" style="font-size:12px; color:var(--muted); font-weight:900; letter-spacing:.3px;">
                        Quick actions
                    </div>
                    <div class="mt-2 d-grid gap-2">
                        <a class="btn btn-outline-light fw-bold" href="${pageContext.request.contextPath}/admin/show" style="border-radius:14px;">
                            <i class="fa-solid fa-arrow-left"></i> Về danh sách
                        </a>
                    </div>
                </div>
            </aside>

            <!-- CONTENT -->
            <main class="content">

                <div class="topbar">
                    <div class="page-h">
                        <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                            <i class="fa-solid fa-trash-can"></i>
                        </div>
                        <div>
                            <h1>Thùng rác - Vở diễn</h1>
                            <div class="crumb">Admin / Show Trash (giữ 30 ngày)</div>
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

                <!-- ✅ CẬP NHẬT PANEL GIẢI THÍCH -->
                <div class="panel">
                    <div class="d-flex align-items-start gap-3">
                        <i class="fa-solid fa-circle-info text-info" style="font-size:20px;"></i>
                        <div class="text-white-50 fw-bold" style="font-size:13px; line-height:1.6;">
                            <div class="mb-2">
                                <i class="fa-solid fa-clock text-warning"></i> 
                                Các vở diễn <b class="text-warning">không có đơn hàng</b> sẽ tự động xóa sau <b>30 ngày</b>.
                            </div>
                            <div>
                                <i class="fa-solid fa-shield-halved text-danger"></i> 
                                Các vở diễn <b class="text-danger">có đơn hàng đã đặt vé</b> được <b class="text-danger">BẢO VỆ VĨNH VIỄN</b> và không thể xóa.
                            </div>
                        </div>
                    </div>
                </div>

                <div class="table-wrap">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th style="width:60px;">#</th>
                                    <th>Tên vở diễn</th>
                                    <th style="width:110px;">Poster</th>
                                    <th style="width:170px;">Đã xóa lúc</th>
                                    <th style="width:200px;">Trạng thái</th>
                                    <th style="width:220px;">Hành động</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="s" items="${trashShows}" varStatus="loop">
                                    <c:set var="deletedAt" value="${trashDeletedAtMap[s.showID]}" />
                                    <c:set var="remainDays" value="${trashRemainDaysMap[s.showID]}" />

                                    <%-- ✅ KIỂM TRA CÓ ĐƠN HÀNG KHÔNG --%>
                                    <jsp:useBean id="showFacade" class="mypack.ShowFacade" scope="page"/>
                                    <c:set var="orderCount" value="${showFacade.countOrdersForShow(s.showID)}" />
                                    <c:set var="hasOrders" value="${orderCount > 0}" />

                                    <tr>
                                        <td class="fw-bold">${loop.index + 1}</td>

                                        <td class="fw-bold">
                                            <div class="d-flex align-items-center gap-2">
                                                <i class="fa-solid fa-clapperboard text-primary"></i>
                                                <span>${s.showName}</span>
                                            </div>
                                        </td>

                                        <td>
                                            <c:if test="${not empty s.showImage}">
                                                <img src="${pageContext.request.contextPath}/${s.showImage}" class="poster" alt="Poster">
                                            </c:if>
                                        </td>

                                        <td>
                                            <c:if test="${not empty deletedAt}">
                                                <fmt:formatDate value="${deletedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </c:if>
                                        </td>

                                        <%-- ✅ CỘT TRẠNG THÁI MỚI --%>
                                        <td>
                                            <c:choose>
                                                <c:when test="${hasOrders}">
                                                    <%-- 🔒 CÓ ĐƠN HÀNG - BẢO VỆ VĨNH VIỄN --%>
                                                    <div class="d-flex flex-column gap-1">
                                                        <span class="badge badge-protected fw-bold">
                                                            <i class="fa-solid fa-lock"></i> BẢO VỆ VĨNH VIỄN
                                                        </span>
                                                        <small class="text-muted" style="font-size:11px;">
                                                            <i class="fa-solid fa-ticket"></i> ${orderCount} đơn hàng
                                                        </small>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <%-- ⏳ KHÔNG CÓ ĐƠN HÀNG - SẼ TỰ XÓA --%>
                                                    <div class="d-flex flex-column gap-1">
                                                        <span class="badge badge-auto-delete fw-bold">
                                                            <i class="fa-solid fa-hourglass-half"></i> Còn ${remainDays} ngày
                                                        </span>
                                                        <small class="text-muted" style="font-size:11px;">
                                                            <i class="fa-solid fa-trash-clock"></i> Tự xóa sau đó
                                                        </small>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <%-- ✅ CẬP NHẬT NÚT HÀNH ĐỘNG --%>
                                        <td class="text-nowrap">
                                            <!-- Restore - LUÔN CHO PHÉP KHÔI PHỤC -->
                                            <a class="btn btn-success btn-icon" title="Khôi phục"
                                               href="${pageContext.request.contextPath}/admin/show/restore?id=${s.showID}">
                                                <i class="fa-solid fa-rotate-left"></i>
                                            </a>

                                            <!-- Hard delete - CHỈ CHO PHÉP NẾU KHÔNG CÓ ĐƠN HÀNG -->
                                            <c:choose>
                                                <c:when test="${hasOrders}">
                                                    <%-- 🔒 KHÓA NÚT XÓA --%>
                                                    <button class="btn btn-secondary btn-icon" 
                                                            title="Không thể xóa - Show có ${orderCount} đơn hàng đã đặt vé"
                                                            disabled>
                                                        <i class="fa-solid fa-lock"></i>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <%-- ✅ CHO PHÉP XÓA --%>
                                                    <a class="btn btn-danger btn-icon" title="Xóa vĩnh viễn"
                                                       href="${pageContext.request.contextPath}/admin/show/delete?id=${s.showID}&back=trash"
                                                       data-confirm="hard-delete"
                                                       data-title="Xóa vĩnh viễn?"
                                                       data-message="Bạn chắc chắn muốn <b>xóa vĩnh viễn</b> vở diễn <b>${fn:escapeXml(s.showName)}</b>?<br><small class='text-danger fw-bold'>Hành động không thể hoàn tác!</small>">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty trashShows}">
                                    <tr>
                                        <td colspan="6" class="text-center py-5 text-secondary">
                                            <i class="fa-regular fa-folder-open fa-lg"></i>
                                            <div class="mt-2 fw-bold">Thùng rác đang trống.</div>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>

                        </table>
                    </div>
                </div>

            </main>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

        <!-- ✅ CONFIRM MODAL - CẬP NHẬT MESSAGE -->
        <div class="modal fade" id="confirmModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content" style="border-radius:16px; overflow:hidden;">
                    <div class="modal-header text-bg-danger">
                        <h5 class="modal-title fw-bold mb-0">
                            <i class="fa-solid fa-triangle-exclamation me-2"></i>
                            <span id="confirmModalTitle">Xác nhận</span>
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>

                    <div class="modal-body text-dark">
                        <div id="confirmModalMsg">Bạn chắc chắn?</div>
                        <div class="alert alert-warning mt-3 mb-0">
                            <small>
                                <i class="fa-solid fa-info-circle"></i> 
                                Chỉ có thể xóa vở diễn <b>không có đơn hàng</b> nào.
                            </small>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">
                            Hủy
                        </button>
                        <a href="#" id="confirmModalOk" class="btn btn-danger fw-bold">
                            <i class="fa-solid fa-trash me-1"></i> Xóa vĩnh viễn
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <script>
            (function () {
                const modalEl = document.getElementById("confirmModal");
                if (!modalEl)
                    return;

                const titleEl = document.getElementById("confirmModalTitle");
                const msgEl = document.getElementById("confirmModalMsg");
                const okBtn = document.getElementById("confirmModalOk");
                const modal = bootstrap.Modal.getOrCreateInstance(modalEl);

                document.addEventListener("click", function (e) {
                    const a = e.target.closest("a[data-confirm='hard-delete']");
                    if (!a)
                        return;

                    e.preventDefault();

                    const title = a.getAttribute("data-title") || "Xác nhận";
                    const msg = a.getAttribute("data-message") || "Bạn chắc chắn?";
                    const href = a.getAttribute("href");

                    titleEl.textContent = title;
                    msgEl.innerHTML = msg;
                    okBtn.setAttribute("href", href);

                    modal.show();
                });
            })();
        </script>

    </body>
</html>