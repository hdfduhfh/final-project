<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết vé #${ticket.ticketID}</title>
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
                    <small>Chi tiết vé</small>
                </div>
            </div>

            <hr style="border-color: var(--line);">

            <div class="px-2">
                <div class="text-uppercase" style="font-size:12px; color:var(--muted); font-weight:900;">
                    Quick actions
                </div>
                <div class="mt-2 d-grid gap-2">
                    <a class="btn btn-outline-light fw-bold" href="${pageContext.request.contextPath}/admin/tickets" style="border-radius:14px;">
                        <i class="fa-solid fa-arrow-left"></i> Về danh sách
                    </a>
                    <button class="btn btn-light fw-bold" onclick="window.print()" style="border-radius:14px;">
                        <i class="fa-solid fa-print"></i> In vé
                    </button>
                </div>
            </div>
        </aside>

        <!-- CONTENT -->
        <main class="content">
            <div class="topbar">
                <div class="page-h">
                    <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                        <i class="fa-solid fa-eye"></i>
                    </div>
                    <div>
                        <h1>[READ] Chi tiết vé #${ticket.ticketID}</h1>
                        <div class="crumb">Admin / Tickets / View</div>
                    </div>
                </div>
            </div>

            <div class="panel" style="max-width: 900px; margin: 14px auto;">
                
                <!-- ACTION BUTTONS -->
                <div class="d-flex gap-2 mb-4">
                    <a href="${pageContext.request.contextPath}/admin/tickets?action=edit&id=${ticket.ticketID}"
                       class="btn btn-warning fw-bold" style="border-radius:12px;">
                        <i class="fa-solid fa-pen-to-square"></i> Chỉnh sửa
                    </a>
                    
                    <c:if test="${fn:toLowerCase(ticket.status) == 'cancelled'}">
                        <button class="btn btn-danger fw-bold" style="border-radius:12px;"
                                onclick="confirmDelete(${ticket.ticketID}, '${ticket.QRCode}')">
                            <i class="fa-solid fa-trash-alt"></i> Xóa vé
                        </button>
                    </c:if>
                </div>

                <!-- TICKET INFO -->
                <h5 class="mb-3" style="font-weight:900;">
                    <i class="fa-solid fa-ticket text-warning"></i> Thông tin vé
                </h5>

                <div class="table-responsive mb-4">
                    <table class="table table-bordered">
                        <tr>
                            <th style="width: 200px; background:#f1f5f9;">ID vé</th>
                            <td class="fw-bold">#${ticket.ticketID}</td>
                        </tr>
                        <tr>
                            <th style="background:#f1f5f9;">QR Code</th>
                            <td>
                                <span class="code-pill">
                                    <i class="fa-solid fa-qrcode"></i>
                                    <c:out value="${ticket.QRCode}" />
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th style="background:#f1f5f9;">Trạng thái</th>
                            <td>
                                <c:set var="stLower" value="${fn:toLowerCase(ticket.status)}" />
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
                                            <c:out value="${ticket.status}" />
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th style="background:#f1f5f9;">Phát hành lúc</th>
                            <td>
                                <i class="fa-regular fa-clock"></i>
                                <fmt:formatDate value="${ticket.issuedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </td>
                        </tr>
                        <tr>
                            <th style="background:#f1f5f9;">Check-in lúc</th>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty ticket.checkInAt}">
                                        <i class="fa-solid fa-check-circle text-success"></i>
                                        <fmt:formatDate value="${ticket.checkInAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Chưa check-in</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th style="background:#f1f5f9;">Cập nhật lần cuối</th>
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

                <!-- SHOW INFO -->
                <h5 class="mb-3" style="font-weight:900;">
                    <i class="fa-solid fa-clapperboard text-primary"></i> Thông tin show
                </h5>

                <div class="table-responsive mb-4">
                    <table class="table table-bordered">
                        <tr>
                            <th style="width: 200px; background:#f1f5f9;">Tên show</th>
                            <td class="fw-bold">
                                <c:out value="${ticket.orderDetailID.scheduleID.showID.showName}" />
                            </td>
                        </tr>
                        <tr>
                            <th style="background:#f1f5f9;">Suất diễn</th>
                            <td>
                                <i class="fa-regular fa-calendar"></i>
                                <fmt:formatDate value="${ticket.orderDetailID.scheduleID.showTime}" pattern="dd/MM/yyyy"/>
                                <i class="fa-regular fa-clock ms-3"></i>
                                <fmt:formatDate value="${ticket.orderDetailID.scheduleID.showTime}" pattern="HH:mm"/>
                            </td>
                        </tr>
                        <tr>
                            <th style="background:#f1f5f9;">Rạp</th>
                            <td>
                                <c:out value="${ticket.orderDetailID.scheduleID.venueID.venueName}" />
                            </td>
                        </tr>
                        <tr>
                            <th style="background:#f1f5f9;">Số ghế</th>
                            <td class="fw-bold">
                                <i class="fa-solid fa-couch"></i>
                                <c:out value="${ticket.orderDetailID.seatID.seatNumber}" />
                            </td>
                        </tr>
                        <tr>
                            <th style="background:#f1f5f9;">Loại ghế</th>
                            <td>
                                <span class="badge bg-secondary">
                                    <c:out value="${ticket.orderDetailID.seatID.seatType}" />
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th style="background:#f1f5f9;">Giá vé</th>
                            <td class="fw-bold text-success">
                                <fmt:formatNumber value="${ticket.orderDetailID.price}" pattern="#,###" /> VNĐ
                            </td>
                        </tr>
                    </table>
                </div>

                <!-- CUSTOMER INFO -->
                <h5 class="mb-3" style="font-weight:900;">
                    <i class="fa-solid fa-user text-info"></i> Thông tin khách hàng
                </h5>

                <div class="table-responsive mb-4">
                    <table class="table table-bordered">
                        <tr>
                            <th style="width: 200px; background:#f1f5f9;">Họ tên</th>
                            <td class="fw-bold">
                                <c:out value="${ticket.orderDetailID.orderID.userID.fullName}" />
                            </td>
                        </tr>
                        <tr>
                            <th style="background:#f1f5f9;">Email</th>
                            <td>
                                <c:out value="${ticket.orderDetailID.orderID.userID.email}" />
                            </td>
                        </tr>
                        <tr>
                            <th style="background:#f1f5f9;">Số điện thoại</th>
                            <td>
                                <c:out value="${ticket.orderDetailID.orderID.userID.phone}" />
                            </td>
                        </tr>
                    </table>
                </div>

                <!-- ORDER INFO -->
                <h5 class="mb-3" style="font-weight:900;">
                    <i class="fa-solid fa-receipt text-secondary"></i> Thông tin đơn hàng
                </h5>

                <div class="table-responsive">
                    <table class="table table-bordered">
                        <tr>
                            <th style="width: 200px; background:#f1f5f9;">Mã đơn hàng</th>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/orders?action=view&id=${ticket.orderDetailID.orderID.orderID}"
                                   class="fw-bold text-decoration-none">
                                    #${ticket.orderDetailID.orderID.orderID}
                                    <i class="fa-solid fa-arrow-up-right-from-square ms-1"></i>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <th style="background:#f1f5f9;">Ngày đặt</th>
                            <td>
                                <fmt:formatDate value="${ticket.orderDetailID.orderID.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </td>
                        </tr>
                        <tr>
                            <th style="background:#f1f5f9;">Phương thức thanh toán</th>
                            <td>
                                <span class="badge bg-primary">
                                    <c:out value="${ticket.orderDetailID.orderID.paymentMethod}" />
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th style="background:#f1f5f9;">Trạng thái thanh toán</th>
                            <td>
                                <c:choose>
                                    <c:when test="${ticket.orderDetailID.orderID.paymentStatus == 'PAID'}">
                                        <span class="badge bg-success">✓ Đã thanh toán</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning">
                                            <c:out value="${ticket.orderDetailID.orderID.paymentStatus}" />
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th style="background:#f1f5f9;">Trạng thái đơn</th>
                            <td>
                                <span class="badge" style="background: ${ticket.orderDetailID.orderID.status == 'CONFIRMED' ? '#22c55e' : '#64748b'};">
                                    <c:out value="${ticket.orderDetailID.orderID.status}" />
                                </span>
                            </td>
                        </tr>
                    </table>
                </div>

            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    function confirmDelete(ticketId, qrCode) {
        if (confirm('⚠️ XÁC NHẬN XÓA VÉ\n\n' +
                    'Vé: #' + ticketId + '\n' +
                    'QR: ' + qrCode + '\n\n' +
                    'Bạn có chắc chắn muốn XÓA vé này không?')) {
            window.location.href = '${pageContext.request.contextPath}/admin/tickets?action=delete&id=' + ticketId;
        }
    }
    </script>
</body>
</html>