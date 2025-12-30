<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý vé</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/tickets-list.css">
    </head>

    <body>
        <div class="admin-wrap">

            <!-- SIDEBAR -->
            <aside class="sidebar">
                <div class="brand">
                    <div class="logo"><i class="fa-solid fa-masks-theater"></i></div>
                    <div>
                        <div class="title">Theater Admin</div>
                        <small>Quản lý vé</small>
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
                        <button class="btn btn-light fw-bold" onclick="window.print()" style="border-radius:14px;">
                            <i class="fa-solid fa-print"></i> In báo cáo
                        </button>
                    </div>
                </div>
            </aside>

            <!-- CONTENT -->
            <main class="content">

                <!-- TOPBAR -->
                <div class="topbar">
                    <div class="page-h">
                        <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                            <i class="fa-solid fa-ticket"></i>
                        </div>
                        <div>
                            <h1>Quản lý vé</h1>
                            <div class="crumb">Admin / Ticket Management / List</div>
                        </div>
                    </div>
                </div>

                <!-- SEARCH PANEL -->
                <div class="panel">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h6 class="mb-0" style="font-weight:900; letter-spacing:.2px;">
                            <i class="fa-solid fa-filter"></i> Bộ lọc & Tìm kiếm
                        </h6>
                        <c:if test="${hasSearchParams}">
                            <a href="${pageContext.request.contextPath}/admin/tickets" class="btn btn-sm btn-outline-light" style="border-radius:10px;">
                                <i class="fa-solid fa-xmark"></i> Xóa bộ lọc
                            </a>
                        </c:if>
                    </div>

                    <form method="get" action="${pageContext.request.contextPath}/admin/tickets">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label" style="font-weight:700; font-size:13px;">
                                    <i class="fa-solid fa-qrcode"></i> Mã QR
                                </label>
                                <input type="text" 
                                       name="qrCode" 
                                       class="form-control" 
                                       placeholder="Nhập mã QR..."
                                       value="${param.qrCode}"
                                       style="border-radius:10px;">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label" style="font-weight:700; font-size:13px;">
                                    <i class="fa-solid fa-toggle-on"></i> Trạng thái
                                </label>
                                <select name="status" class="form-select" style="border-radius:10px;">
                                    <option value="ALL" ${param.status == 'ALL' || empty param.status ? 'selected' : ''}>-- Tất cả --</option>
                                    <option value="VALID" ${param.status == 'VALID' ? 'selected' : ''}>VALID</option>
                                    <option value="USED" ${param.status == 'USED' ? 'selected' : ''}>USED</option>
                                    <option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                    <option value="EXPIRED" ${param.status == 'EXPIRED' ? 'selected' : ''}>EXPIRED</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label" style="font-weight:700; font-size:13px;">
                                    <i class="fa-solid fa-user"></i> Tên khách hàng
                                </label>
                                <input type="text" 
                                       name="customerName" 
                                       class="form-control" 
                                       placeholder="Nhập tên..."
                                       value="${param.customerName}"
                                       style="border-radius:10px;">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label" style="font-weight:700; font-size:13px;">
                                    <i class="fa-solid fa-calendar-days"></i> Từ ngày
                                </label>
                                <input type="date" 
                                       name="fromDate" 
                                       class="form-control"
                                       value="${param.fromDate}"
                                       style="border-radius:10px;">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label" style="font-weight:700; font-size:13px;">
                                    <i class="fa-solid fa-calendar-days"></i> Đến ngày
                                </label>
                                <input type="date" 
                                       name="toDate" 
                                       class="form-control"
                                       value="${param.toDate}"
                                       style="border-radius:10px;">
                            </div>

                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-warning fw-bold w-100" style="border-radius:10px;">
                                    <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- STATISTICS PANEL -->
                <div class="stats-panel">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: rgba(34,197,94,.15);">
                            <i class="fa-solid fa-ticket" style="color: #22c55e;"></i>
                        </div>
                        <div>
                            <div class="stat-label">Tổng số vé</div>
                            <div class="stat-value">${totalTickets}</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon" style="background: rgba(79,70,229,.15);">
                            <i class="fa-solid fa-circle-check" style="color: #4f46e5;"></i>
                        </div>
                        <div>
                            <div class="stat-label">Vé hợp lệ</div>
                            <div class="stat-value">
                                <c:set var="validCount" value="0"/>
                                <c:forEach var="t" items="${tickets}">
                                    <c:if test="${fn:toLowerCase(t.status) == 'valid'}">
                                        <c:set var="validCount" value="${validCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${validCount}
                            </div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon" style="background: rgba(148,163,184,.15);">
                            <i class="fa-solid fa-circle-dot" style="color: #64748b;"></i>
                        </div>
                        <div>
                            <div class="stat-label">Đã sử dụng</div>
                            <div class="stat-value">
                                <c:set var="usedCount" value="0"/>
                                <c:forEach var="t" items="${tickets}">
                                    <c:if test="${fn:toLowerCase(t.status) == 'used'}">
                                        <c:set var="usedCount" value="${usedCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${usedCount}
                            </div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon" style="background: rgba(239,68,68,.15);">
                            <i class="fa-solid fa-ban" style="color: #ef4444;"></i>
                        </div>
                        <div>
                            <div class="stat-label">Đã hủy</div>
                            <div class="stat-value">
                                <c:set var="cancelledCount" value="0"/>
                                <c:forEach var="t" items="${tickets}">
                                    <c:if test="${fn:toLowerCase(t.status) == 'cancelled'}">
                                        <c:set var="cancelledCount" value="${cancelledCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${cancelledCount}
                            </div>
                        </div>
                    </div>
                </div>

                <!-- TABLE -->
                <div class="table-wrap">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th style="width:90px;">ID</th>
                                    <th>QR Code</th>
                                    <th>Show</th>
                                    <th>Suất diễn</th>
                                    <th>Ghế</th>
                                    <th>Khách hàng</th>
                                    <th>Trạng thái</th>
                                    <th style="width:120px;">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ticket" items="${tickets}">
                                    <c:set var="stLower" value="${ticket.status != null ? fn:toLowerCase(ticket.status) : ''}" />
                                    <tr>
                                        <td class="fw-bold">#${ticket.ticketID}</td>

                                        <td>
                                            <span class="code-pill">
                                                <i class="fa-solid fa-qrcode"></i>
                                                <c:out value="${ticket.QRCode}" />
                                            </span>
                                        </td>

                                        <td class="fw-bold">
                                            <i class="fa-solid fa-clapperboard text-primary"></i>
                                            <c:out value="${ticket.orderDetailID.scheduleID.showID.showName}" />
                                        </td>

                                        <td>
                                            <i class="fa-regular fa-clock text-secondary"></i>
                                            <fmt:formatDate value="${ticket.orderDetailID.scheduleID.showTime}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>

                                        <td class="fw-bold">
                                            <i class="fa-solid fa-couch text-secondary"></i>
                                            <c:out value="${ticket.orderDetailID.seatID.seatNumber}" />
                                        </td>

                                        <td>
                                            <i class="fa-solid fa-user text-secondary"></i>
                                            <c:out value="${ticket.orderDetailID.orderID.userID.fullName}" />
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${stLower == 'valid'}">
                                                    <span class="status-badge st-valid">
                                                        <i class="fa-solid fa-circle-check"></i> VALID
                                                    </span>
                                                </c:when>
                                                <c:when test="${stLower == 'used'}">
                                                    <span class="status-badge st-used">
                                                        <i class="fa-solid fa-circle-dot"></i> USED
                                                    </span>
                                                </c:when>
                                                <c:when test="${stLower == 'cancelled'}">
                                                    <span class="status-badge st-cancelled">
                                                        <i class="fa-solid fa-ban"></i> CANCELLED
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge">
                                                        <i class="fa-solid fa-tag"></i>
                                                        <c:out value="${ticket.status}" />
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="text-nowrap">
                                            <button class="btn btn-info btn-icon"
                                                    title="Xem chi tiết"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#ticketModal-${ticket.ticketID}">
                                                <i class="fa-solid fa-circle-info"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty tickets}">
                                    <tr>
                                        <td colspan="8" class="empty">
                                            <i class="fa-regular fa-folder-open fa-2x"></i>
                                            <div class="mt-2 fw-bold">
                                                <c:choose>
                                                    <c:when test="${hasSearchParams}">
                                                        Không tìm thấy vé nào phù hợp với tiêu chí tìm kiếm.
                                                    </c:when>
                                                    <c:otherwise>
                                                        Chưa có vé nào.
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- PAGINATION -->
                <c:if test="${totalPages > 1}">
                    <nav class="mt-4 d-flex justify-content-center">
                        <ul class="pagination">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/admin/tickets?page=${currentPage - 1}&qrCode=${param.qrCode}&status=${param.status}&customerName=${param.customerName}&fromDate=${param.fromDate}&toDate=${param.toDate}">
                                    <i class="fa-solid fa-arrow-left"></i> Trước
                                </a>
                            </li>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/admin/tickets?page=${i}&qrCode=${param.qrCode}&status=${param.status}&customerName=${param.customerName}&fromDate=${param.fromDate}&toDate=${param.toDate}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:if>
                                <c:if test="${(i == 2 && currentPage > 4) || (i == totalPages - 1 && currentPage < totalPages - 3)}">
                                    <li class="page-item disabled">
                                        <span class="page-link">...</span>
                                    </li>
                                </c:if>
                            </c:forEach>

                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/admin/tickets?page=${currentPage + 1}&qrCode=${param.qrCode}&status=${param.status}&customerName=${param.customerName}&fromDate=${param.fromDate}&toDate=${param.toDate}">
                                    Sau <i class="fa-solid fa-arrow-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>

            </main>
        </div>

        <!-- MODALS -->
        <c:forEach var="ticket" items="${tickets}">
            <c:set var="stLower" value="${ticket.status != null ? fn:toLowerCase(ticket.status) : ''}" />
            <div class="modal fade" id="ticketModal-${ticket.ticketID}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">
                                <i class="fa-solid fa-ticket me-2 text-warning"></i>
                                Chi tiết vé #${ticket.ticketID}
                            </h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>

                        <div class="modal-body">
                            <table class="table table-bordered mb-0">
                                <tr>
                                    <th>QR Code</th>
                                    <td>
                                        <span class="code-pill">
                                            <i class="fa-solid fa-qrcode"></i>
                                            <c:out value="${ticket.QRCode}" />
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Show</th>
                                    <td><c:out value="${ticket.orderDetailID.scheduleID.showID.showName}" /></td>
                                </tr>
                                <tr>
                                    <th>Suất diễn</th>
                                    <td>
                                        <fmt:formatDate value="${ticket.orderDetailID.scheduleID.showTime}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Ghế</th>
                                    <td><c:out value="${ticket.orderDetailID.seatID.seatNumber}" /></td>
                                </tr>
                                <tr>
                                    <th>Khách hàng</th>
                                    <td><c:out value="${ticket.orderDetailID.orderID.userID.fullName}" /></td>
                                </tr>
                                <tr>
                                    <th>Trạng thái</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${stLower == 'valid'}">
                                                <span class="status-badge st-valid">
                                                    <i class="fa-solid fa-circle-check"></i> VALID
                                                </span>
                                            </c:when>
                                            <c:when test="${stLower == 'used'}">
                                                <span class="status-badge st-used">
                                                    <i class="fa-solid fa-circle-dot"></i> USED
                                                </span>
                                            </c:when>
                                            <c:when test="${stLower == 'cancelled'}">
                                                <span class="status-badge st-cancelled">
                                                    <i class="fa-solid fa-ban"></i> CANCELLED
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge">
                                                    <i class="fa-solid fa-tag"></i>
                                                    <c:out value="${ticket.status}" />
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Phát hành lúc</th>
                                    <td>
                                        <fmt:formatDate value="${ticket.issuedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Check-in lúc</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty ticket.checkInAt}">
                                                <fmt:formatDate value="${ticket.checkInAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                            </c:when>
                                            <c:otherwise>Chưa check-in</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Cập nhật</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty ticket.updatedAt}">
                                                <fmt:formatDate value="${ticket.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </table>
                        </div>

                        <div class="modal-footer">
                            <button class="btn btn-outline-dark fw-bold" data-bs-dismiss="modal" style="border-radius:14px;">
                                <i class="fa-solid fa-xmark"></i> Đóng
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>