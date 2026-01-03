<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử vé đã xóa</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/tickets-list.css">
</head>

<body>
    <div class="admin-wrap">
        <!-- SIDEBAR -->
        <aside class="sidebar">
            <div class="brand">
                <div class="logo"><i class="fa-solid fa-trash"></i></div>
                <div>
                    <div class="title">Theater Admin</div>
                    <small>Vé đã xóa</small>
                </div>
            </div>

            <hr style="border-color: var(--line);">

            <div class="px-2">
                <div class="text-uppercase" style="font-size:12px; color:var(--muted); font-weight:900;">
                    Navigation
                </div>
                <div class="mt-2 d-grid gap-2">
                    <a class="btn btn-outline-light fw-bold" href="${pageContext.request.contextPath}/admin/tickets" style="border-radius:14px;">
                        <i class="fa-solid fa-arrow-left"></i> Về Quản lý vé
                    </a>
                </div>
                
                <hr style="border-color: var(--line); margin: 16px 0;">
                
                <div class="alert alert-info" style="font-size: 12px; border-radius: 12px;">
                    <i class="fa-solid fa-info-circle"></i> <strong>Lưu trữ vé</strong><br>
                    <small>
                    Vé đã xóa được lưu vĩnh viễn để kiểm tra, audit. 
                    Không thể khôi phục.
                    </small>
                </div>
            </div>
        </aside>

        <!-- CONTENT -->
        <main class="content">
            <!-- TOPBAR -->
            <div class="topbar">
                <div class="page-h">
                    <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                        <i class="fa-solid fa-trash"></i>
                    </div>
                    <div>
                        <h1>Lịch sử vé đã xóa</h1>
                        <div class="crumb">Admin / Tickets / Deleted</div>
                    </div>
                </div>
            </div>

            <!-- STATISTICS -->
            <div class="stats-panel">
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(239,68,68,.15);">
                        <i class="fa-solid fa-trash" style="color: #ef4444;"></i>
                    </div>
                    <div>
                        <div class="stat-label">Tổng vé đã xóa</div>
                        <div class="stat-value">${deletedTickets.size()}</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(148,163,184,.15);">
                        <i class="fa-solid fa-clock-rotate-left" style="color: #64748b;"></i>
                    </div>
                    <div>
                        <div class="stat-label">Xóa gần nhất</div>
                        <div class="stat-value" style="font-size: 16px;">
                            <c:choose>
                                <c:when test="${not empty deletedTickets}">
                                    <fmt:formatDate value="${deletedTickets[0].deletedAt}" pattern="dd/MM HH:mm"/>
                                </c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
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
                                <th>ID</th>
                                <th>QR Code</th>
                                <th>Show</th>
                                <th>Khách hàng</th>
                                <th>Xóa lúc</th>
                                <th>Xóa bởi</th>
                                <th>Lý do</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ticket" items="${deletedTickets}">
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
                                        <i class="fa-solid fa-user text-secondary"></i>
                                        <c:out value="${ticket.orderDetailID.orderID.userID.fullName}" />
                                    </td>

                                    <td>
                                        <fmt:formatDate value="${ticket.deletedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                    </td>

                                    <td class="text-secondary">
                                        <c:out value="${ticket.deletedBy}" />
                                    </td>

                                    <td class="text-muted" style="max-width: 200px; overflow: hidden; text-overflow: ellipsis;">
                                        <c:out value="${ticket.deleteReason}" />
                                    </td>

                                    <td class="text-nowrap">
                                        <button class="btn btn-info btn-icon"
                                                title="Xem chi tiết"
                                                data-bs-toggle="modal"
                                                data-bs-target="#deletedModal-${ticket.ticketID}">
                                            <i class="fa-solid fa-eye"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty deletedTickets}">
                                <tr>
                                    <td colspan="8" class="empty">
                                        <i class="fa-regular fa-folder-open fa-2x"></i>
                                        <div class="mt-2 fw-bold">Chưa có vé nào bị xóa.</div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

        </main>
    </div>

    <!-- DETAIL MODALS -->
    <c:forEach var="ticket" items="${deletedTickets}">
        <div class="modal fade" id="deletedModal-${ticket.ticketID}" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fa-solid fa-trash me-2 text-danger"></i>
                            Chi tiết vé đã xóa #${ticket.ticketID}
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <div class="alert alert-danger mb-3">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                            <strong>Vé đã bị xóa</strong> - Chỉ dùng để tham khảo, không thể khôi phục.
                        </div>

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
                                <th>Phát hành</th>
                                <td>
                                    <fmt:formatDate value="${ticket.issuedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                </td>
                            </tr>
                            <tr style="background: rgba(239,68,68,.10);">
                                <th>Xóa lúc</th>
                                <td>
                                    <fmt:formatDate value="${ticket.deletedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                </td>
                            </tr>
                            <tr style="background: rgba(239,68,68,.10);">
                                <th>Xóa bởi</th>
                                <td><c:out value="${ticket.deletedBy}" /></td>
                            </tr>
                            <tr style="background: rgba(239,68,68,.10);">
                                <th>Lý do xóa</th>
                                <td><c:out value="${ticket.deleteReason}" /></td>
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