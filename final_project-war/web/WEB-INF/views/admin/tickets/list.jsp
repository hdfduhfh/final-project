<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý vé</title>

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome 6 -->
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
                                            <div class="mt-2 fw-bold">Chưa có vé nào.</div>
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

            <!-- Previous -->
            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <a class="page-link"
                   href="${pageContext.request.contextPath}/admin/tickets?page=${currentPage - 1}">
                    &laquo;
                </a>
            </li>

            <!-- Page numbers -->
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/admin/tickets?page=${i}">
                        ${i}
                    </a>
                </li>
            </c:forEach>

            <!-- Next -->
            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <a class="page-link"
                   href="${pageContext.request.contextPath}/admin/tickets?page=${currentPage + 1}">
                    &raquo;
                </a>
            </li>

        </ul>
    </nav>
</c:if>

            </main>
        </div>

        <!-- ================= MODAL DETAIL ================= -->
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

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
