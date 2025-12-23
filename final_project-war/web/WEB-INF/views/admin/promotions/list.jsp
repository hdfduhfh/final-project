<%--
    Document   : list
    Created on : Dec 19, 2025
    Updated    : UI upgraded (Bootstrap 5 + FA + Glass theme) + Delete confirm modal
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý khuyến mãi</title>

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
                width:270px;
                background: rgba(15,27,51,.86);
                border-right:1px solid var(--line);
                backdrop-filter: blur(10px);
                padding:18px 14px;
                position:sticky;
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
                border:1px solid var(--line);
            }
            .brand .logo{
                width:38px;
                height:38px;
                border-radius:12px;
                display:grid;
                place-items:center;
                background: linear-gradient(135deg, rgba(79,70,229,.9), rgba(6,182,212,.9));
                box-shadow: 0 14px 35px rgba(0,0,0,.35);
            }
            .brand .title{
                line-height:1.1;
                font-weight:900;
                letter-spacing:.2px;
            }
            .brand small{
                color:var(--muted);
                font-weight:650;
            }

            .nav-group{
                margin-top:14px;
            }
            .nav-item{
                display:flex;
                align-items:center;
                gap:10px;
                padding:10px 12px;
                border-radius:12px;
                color:#dbe5ff;
                text-decoration:none;
                border:1px solid transparent;
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
                padding:22px 22px 28px;
            }

            .topbar{
                display:flex;
                gap:12px;
                align-items:center;
                justify-content:space-between;
                padding:14px 16px;
                border-radius:18px;
                background: rgba(255,255,255,.06);
                border:1px solid var(--line);
                backdrop-filter: blur(10px);
                box-shadow: 0 18px 55px rgba(0,0,0,.35);
            }
            .page-h{
                display:flex;
                gap:12px;
                align-items:center;
            }
            .page-h h1{
                font-size:18px;
                margin:0;
                font-weight:950;
                letter-spacing:.2px;
            }
            .page-h .crumb{
                color:var(--muted);
                font-weight:650;
                font-size:12px;
            }

            .panel{
                margin-top:14px;
                padding:14px;
                border-radius:18px;
                background: rgba(255,255,255,.06);
                border:1px solid var(--line);
                backdrop-filter: blur(10px);
            }

            .table-wrap{
                margin-top:12px;
                border-radius:18px;
                overflow:hidden;
                background: rgba(255,255,255,.96);
                box-shadow: 0 22px 70px rgba(0,0,0,.35);
            }
            table thead th{
                background:#0f1b33 !important;
                color:#e8efff !important;
                border:none !important;
                white-space:nowrap;
                font-size:13px;
                letter-spacing:.2px;
            }
            table tbody td{
                color:#0b1220;
                vertical-align:middle;
            }

            .code-badge{
                display:inline-flex;
                align-items:center;
                gap:8px;
                padding:6px 10px;
                border-radius:999px;
                background: rgba(214,51,132,.10);
                border: 1px solid rgba(214,51,132,.18);
                color:#8b1e4d;
                font-weight:900;
                font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
            }

            .status-pill{
                display:inline-flex;
                align-items:center;
                gap:8px;
                padding:6px 10px;
                border-radius:999px;
                font-weight:900;
                font-size:12px;
                border:1px solid rgba(0,0,0,.08);
            }
            .status-active{
                background: rgba(34,197,94,.16);
                color:#14532d;
                border-color: rgba(34,197,94,.28);
            }
            .status-inactive{
                background: rgba(239,68,68,.14);
                color:#7f1d1d;
                border-color: rgba(239,68,68,.24);
            }

            .mini{
                font-size:12px;
                color:#4b5563;
                font-weight:650;
            }
            .limit{
                display:inline-flex;
                align-items:center;
                gap:8px;
                font-weight:900;
            }
            .limit .inf{
                color:#0f172a;
                background: rgba(2,132,199,.10);
                border: 1px solid rgba(2,132,199,.18);
                padding: 4px 8px;
                border-radius: 999px;
                font-weight:950;
            }

            .btn-icon{
                width:36px;
                height:36px;
                display:inline-grid;
                place-items:center;
                border-radius:12px;
            }

            .empty{
                padding:48px 16px;
                text-align:center;
                color:#6b7280;
            }

            /* Modal theme */
            .modal-content{
                border-radius:18px;
                overflow:hidden;
            }
            .modal-header.theme{
                background:#0f1b33;
                color:#e8efff;
                border:none;
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
                        <small>Quản lý khuyến mãi</small>
                    </div>
                </div>

                <hr style="border-color: var(--line);">

                <div class="px-2">
                    <div class="text-uppercase" style="font-size:12px; color:var(--muted); font-weight:950; letter-spacing:.3px;">
                        Quick actions
                    </div>
                    <div class="mt-2 d-grid gap-2">
                        <a class="btn btn-outline-light fw-bold" href="${pageContext.request.contextPath}/admin/dashboard" style="border-radius:14px;">
                            <i class="fa-solid fa-arrow-left"></i> Về Dashboard
                        </a>
                        <a class="btn btn-light fw-bold" href="${pageContext.request.contextPath}/admin/promotions?action=create" style="border-radius:14px;">
                            <i class="fa-solid fa-circle-plus"></i> Thêm khuyến mãi
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
                            <i class="fa-solid fa-tags"></i>
                        </div>
                        <div>
                            <h1>Danh sách mã giảm giá</h1>
                            <div class="crumb">Admin / Promotions / List</div>
                        </div>
                    </div>
                </div>

                <!-- Alerts (từ param.msg) -->
                <c:if test="${not empty param.msg}">
                    <div class="alert alert-success mt-3 mb-0 d-flex align-items-center gap-2">
                        <i class="fa-solid fa-circle-check"></i>
                        <div class="fw-bold">
                            <c:choose>
                                <c:when test="${param.msg == 'success'}">Thao tác thành công!</c:when>
                                <c:when test="${param.msg == 'created'}">Đã thêm mới thành công!</c:when>
                                <c:when test="${param.msg == 'updated'}">Cập nhật thành công!</c:when>
                                <c:when test="${param.msg == 'deleted'}">Đã xóa thành công!</c:when>
                                <c:otherwise>Thao tác thành công!</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:if>

                <!-- Table -->
                <div class="table-wrap">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th style="min-width:220px;">Thông tin mã</th>
                                    <th style="min-width:220px;">Giá trị giảm</th>
                                    <th style="min-width:220px;">Giới hạn dùng</th>
                                    <th style="min-width:240px;">Thời gian hiệu lực</th>
                                    <th style="width:140px; text-align:center;">Trạng thái</th>
                                    <th style="width:180px;">Hành động</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="p" items="${promotions}">
                                    <tr>

                                        <td>
                                            <div class="fw-bold text-dark">
                                                <i class="fa-solid fa-ticket text-primary"></i>
                                                ${p.name}
                                            </div>
                                            <div class="mt-1">
                                                <span class="code-badge">
                                                    <i class="fa-solid fa-hashtag"></i> ${p.code}
                                                </span>
                                            </div>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${p.discountType == 'PERCENT'}">
                                                    <div class="fw-bold text-danger">
                                                        <i class="fa-solid fa-percent"></i>
                                                        -<fmt:formatNumber value="${p.discountValue}" type="number" maxFractionDigits="0"/>%
                                                    </div>
                                                    <c:if test="${not empty p.maxDiscount}">
                                                        <div class="mini">
                                                            Tối đa:
                                                            <b><fmt:formatNumber value="${p.maxDiscount}" pattern="#,###"/> đ</b>
                                                        </div>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="fw-bold text-success">
                                                        <i class="fa-solid fa-money-bill-wave"></i>
                                                        -<fmt:formatNumber value="${p.discountValue}" pattern="#,###"/> đ
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="mini mt-1">
                                                Min đơn:
                                                <b><fmt:formatNumber value="${p.minOrderAmount}" pattern="#,###"/> đ</b>
                                            </div>
                                        </td>

                                        <td>
                                            <div class="limit">
                                                <i class="fa-solid fa-globe text-info"></i>
                                                <span>Toàn web:</span>
                                                <c:choose>
                                                    <c:when test="${empty p.maxUsage || p.maxUsage == 0}">
                                                        <span class="inf">∞</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-danger fw-bold">${fn:length(p.order1Collection)}</span>
                                                        <span>/</span>
                                                        <span class="inf">${p.maxUsage}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div class="limit mt-2">
                                                <i class="fa-solid fa-user text-secondary"></i>
                                                <span>Mỗi khách:</span>
                                                <c:choose>
                                                    <c:when test="${empty p.maxUsage || p.maxUsage == 0}">
                                                        <span class="text-primary fw-bold">${fn:length(p.order1Collection)}</span>
                                                        <span>/</span>
                                                        <span class="inf">∞</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inf">${p.maxUsagePerUser}</span>
                                                        <span class="mini">lượt</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>

                                        <td class="mini">
                                            <div>
                                                <i class="fa-regular fa-clock"></i>
                                                Bắt đầu:
                                                <b><fmt:formatDate value="${p.startDate}" pattern="dd/MM/yyyy HH:mm"/></b>
                                            </div>
                                            <div class="mt-1">
                                                <i class="fa-regular fa-hourglass-half"></i>
                                                Kết thúc:
                                                <b><fmt:formatDate value="${p.endDate}" pattern="dd/MM/yyyy HH:mm"/></b>
                                            </div>
                                        </td>

                                        <td style="text-align:center;">
                                            <c:choose>
                                                <c:when test="${p.status == 'ACTIVE'}">
                                                    <span class="status-pill status-active">
                                                        <i class="fa-solid fa-circle-play"></i> Đang chạy
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-pill status-inactive">
                                                        <i class="fa-solid fa-circle-stop"></i> Đã tắt
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="text-nowrap">
                                            <a class="btn btn-primary btn-icon" title="Sửa"
                                               href="${pageContext.request.contextPath}/admin/promotions?action=edit&id=${p.promotionID}">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>

                                            <c:choose>
                                                <c:when test="${fn:length(p.order1Collection) == 0}">
                                                    <!-- Delete dùng modal (không confirm mặc định) -->
                                                    <button type="button"
                                                            class="btn btn-danger btn-icon"
                                                            title="Xóa"
                                                            onclick="openDeletePromotionModal(
                                                                            '${pageContext.request.contextPath}/admin/promotions?action=delete&id=${p.promotionID}',
                                                                                            '${fn:escapeXml(p.code)}',
                                                                                            '${fn:escapeXml(p.name)}'
                                                                                            )">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button"
                                                            class="btn btn-secondary btn-icon"
                                                            title="Mã đã có người dùng, không thể xóa"
                                                            disabled>
                                                        <i class="fa-solid fa-ban"></i>
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty promotions}">
                                    <tr>
                                        <td colspan="7" class="empty">
                                            <i class="fa-regular fa-folder-open fa-2x"></i>
                                            <div class="mt-2 fw-bold">Chưa có chương trình khuyến mãi nào. Hãy thêm mới!</div>
                                        </td>
                                    </tr>
                                </c:if>

                            </tbody>
                        </table>
                    </div>
                </div>

            </main>
        </div>

        <!-- ===== DELETE CONFIRM MODAL (Bootstrap) ===== -->
        <div class="modal fade" id="deletePromotionModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header theme">
                        <h5 class="modal-title fw-bold">
                            <i class="fa-solid fa-triangle-exclamation text-warning"></i> Xác nhận xóa
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body text-dark">
                        <div class="d-flex align-items-start gap-3">
                            <div style="width:46px;height:46px;border-radius:16px;display:grid;place-items:center;background:rgba(239,68,68,.12);">
                                <i class="fa-solid fa-trash-can text-danger fs-4"></i>
                            </div>

                            <div>
                                <div class="fw-bold mb-1">Bạn chắc chắn muốn xóa mã khuyến mãi này?</div>
                                <div class="text-secondary">
                                    Mã: <span id="delPromoCode" class="fw-bold"></span><br>
                                    Tên: <span id="delPromoName" class="fw-bold"></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer" style="border:none;">
                        <button type="button" class="btn btn-outline-dark fw-bold" data-bs-dismiss="modal">
                            <i class="fa-solid fa-xmark"></i> Hủy
                        </button>

                        <a href="#" id="deletePromotionConfirmBtn" class="btn btn-danger fw-bold">
                            <i class="fa-solid fa-trash"></i> Xóa
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                                                function openDeletePromotionModal(deleteUrl, code, name) {
                                                                                    const codeEl = document.getElementById('delPromoCode');
                                                                                    const nameEl = document.getElementById('delPromoName');
                                                                                    const confirmBtn = document.getElementById('deletePromotionConfirmBtn');

                                                                                    if (codeEl)
                                                                                        codeEl.textContent = code || '';
                                                                                    if (nameEl)
                                                                                        nameEl.textContent = name || '';
                                                                                    if (confirmBtn)
                                                                                        confirmBtn.setAttribute('href', deleteUrl || '#');

                                                                                    const modalEl = document.getElementById('deletePromotionModal');
                                                                                    const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                                                                                    modal.show();
                                                                                }
        </script>

    </body>
</html>
