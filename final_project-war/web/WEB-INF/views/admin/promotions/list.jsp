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
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/promotions-list.css">
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

                <!-- Alerts -->
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
                                    <th style="width:240px;">Hành động</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="p" items="${promotions}">
                                    <tr>
                                        <!-- Thông tin mã -->
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

                                        <!-- Giá trị giảm -->
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

                                        <!-- Giới hạn dùng -->
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

                                        <!-- Thời gian -->
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

                                        <!-- Trạng thái -->
                                       <!-- Trạng thái -->
<td style="text-align:center;">
    <%-- ✅ THÊM LOGIC KIỂM TRA HẾT HẠN --%>
    <jsp:useBean id="now" class="java.util.Date" />
    
    <c:choose>
        <%-- Kiểm tra đã hết hạn chưa --%>
        <c:when test="${p.endDate.time < now.time}">
            <span class="status-pill status-expired">
                <i class="fa-solid fa-clock-rotate-left"></i> Đã hết hạn
            </span>
        </c:when>
        
        <%-- Kiểm tra đang chạy --%>
        <c:when test="${p.status == 'ACTIVE'}">
            <span class="status-pill status-active">
                <i class="fa-solid fa-circle-play"></i> Đang chạy
            </span>
        </c:when>
        
        <%-- Đã tắt --%>
        <c:otherwise>
            <span class="status-pill status-inactive">
                <i class="fa-solid fa-circle-stop"></i> Đã tắt
            </span>
        </c:otherwise>
    </c:choose>
</td>

                                        <!-- Hành động -->
                                        <td class="text-nowrap">
                                            <!-- Sửa -->
                                            <a class="btn btn-primary btn-icon" title="Sửa"
                                               href="${pageContext.request.contextPath}/admin/promotions?action=edit&id=${p.promotionID}">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>

                                            <!-- Xem người dùng -->
                                            <button type="button"
                                                    class="btn btn-info btn-icon text-white"
                                                    title="Xem người dùng"
                                                    onclick="openUsageModal(${p.promotionID}, '${fn:escapeXml(p.code)}', '${fn:escapeXml(p.name)}')">
                                                <i class="fa-solid fa-users"></i>
                                            </button>

                                            <!-- Xóa -->
                                            <c:choose>
                                                <c:when test="${fn:length(p.order1Collection) == 0}">
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

        <!-- ===== DELETE MODAL ===== -->
        <div class="modal fade" id="deletePromotionModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header theme">
                        <h5 class="modal-title fw-bold">
                            <i class="fa-solid fa-triangle-exclamation text-warning"></i> Xác nhận xóa
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
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

        <!-- ===== USAGE MODAL ===== -->
        <div class="modal fade" id="usageModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header theme">
                        <h5 class="modal-title fw-bold">
                            <i class="fa-solid fa-users text-info"></i> 
                            Chi tiết sử dụng mã: <span id="usagePromoCode"></span>
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body" style="background:#f8f9fa;">
                        <!-- Loading -->
                        <div id="usageLoading" class="text-center py-5">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <div class="mt-2 text-muted">Đang tải dữ liệu...</div>
                        </div>

                        <!-- Error -->
                        <div id="usageError" class="alert alert-danger d-none">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                            <span id="usageErrorText"></span>
                        </div>

                        <!-- Content -->
                        <div id="usageContent" class="d-none">
                            <div class="alert alert-info mb-3">
                                <strong id="usagePromoName"></strong> - 
                                Tổng: <strong id="usageTotalCount">0</strong> lượt sử dụng
                            </div>

                            <div class="table-responsive">
                                <table class="table table-hover table-bordered bg-white mb-0">
                                    <thead class="table-dark">
                                        <tr>
                                            <th style="width:50px;">#</th>
                                            <th>Khách hàng</th>
                                            <th>Email</th>
                                            <th>Đơn hàng</th>
                                            <th>Ngày sử dụng</th>
                                            <th>Giảm giá</th>
                                            <th>Thành tiền</th>
                                            <th>Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody id="usageTableBody">
                                        <!-- Data inserted by JS -->
                                    </tbody>
                                </table>
                            </div>

                            <div id="usageEmpty" class="text-center py-5 d-none">
                                <i class="fa-regular fa-face-frown fa-3x text-muted"></i>
                                <div class="mt-3 text-muted fw-bold">Chưa có ai sử dụng mã này</div>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">
                            <i class="fa-solid fa-xmark"></i> Đóng
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Custom JS -->
        <script>
            // Pass context path to JS
            window.APP_CONTEXT_PATH = '${pageContext.request.contextPath}';
        </script>
        <script src="${pageContext.request.contextPath}/js/admin/promotions-list.js"></script>

    </body>
</html>