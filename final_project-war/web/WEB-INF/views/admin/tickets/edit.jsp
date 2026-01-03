<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa vé #${ticket.ticketID}</title>
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
                    <small>Chỉnh sửa vé</small>
                </div>
            </div>

            <hr style="border-color: var(--line);">

            <div class="px-2">
                <div class="text-uppercase" style="font-size:12px; color:var(--muted); font-weight:900;">
                    Navigation
                </div>
                <div class="mt-2 d-grid gap-2">
                    <a class="btn btn-outline-light fw-bold" href="${pageContext.request.contextPath}/admin/tickets" style="border-radius:14px;">
                        <i class="fa-solid fa-arrow-left"></i> Về danh sách
                    </a>
                </div>
                
                <hr style="border-color: var(--line); margin: 16px 0;">
                
                <div class="alert alert-warning" style="font-size: 12px; border-radius: 12px;">
                    <i class="fa-solid fa-triangle-exclamation"></i> <strong>UPDATE Rules:</strong><br>
                    <small>
                    • VALID → USED/CANCELLED ✅<br>
                    • USED → Không đổi được ❌<br>
                    • CANCELLED → VALID (nếu chưa quá hạn) ✅<br>
                    • EXPIRED → Không đổi được ❌
                    </small>
                </div>
            </div>
        </aside>

        <!-- CONTENT -->
        <main class="content">
            <div class="topbar">
                <div class="page-h">
                    <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                        <i class="fa-solid fa-pen-to-square"></i>
                    </div>
                    <div>
                        <h1>[UPDATE] Chỉnh sửa vé #${ticket.ticketID}</h1>
                        <div class="crumb">Admin / Tickets / Edit</div>
                    </div>
                </div>
            </div>

            <div class="panel" style="max-width: 800px; margin: 14px auto;">
                <h5 class="mb-4" style="font-weight:900;">
                    <i class="fa-solid fa-ticket text-warning"></i> Thông tin vé
                </h5>

                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">QR Code</label>
                        <div class="form-control" style="background: rgba(255,255,255,.96); border-radius:10px;">
                            <span class="code-pill">
                                <i class="fa-solid fa-qrcode"></i>
                                <c:out value="${ticket.QRCode}" />
                            </span>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Trạng thái hiện tại</label>
                        <div class="form-control" style="background: rgba(255,255,255,.96); border-radius:10px;">
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
                        </div>
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-bold">Show</label>
                        <input type="text" class="form-control" readonly
                               value="${ticket.orderDetailID.scheduleID.showID.showName}"
                               style="background: rgba(255,255,255,.96); border-radius:10px;">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Suất diễn</label>
                        <input type="text" class="form-control" readonly
                               value="<fmt:formatDate value='${ticket.orderDetailID.scheduleID.showTime}' pattern='dd/MM/yyyy HH:mm'/>"
                               style="background: rgba(255,255,255,.96); border-radius:10px;">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Ghế</label>
                        <input type="text" class="form-control" readonly
                               value="${ticket.orderDetailID.seatID.seatNumber}"
                               style="background: rgba(255,255,255,.96); border-radius:10px;">
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-bold">Khách hàng</label>
                        <input type="text" class="form-control" readonly
                               value="${ticket.orderDetailID.orderID.userID.fullName}"
                               style="background: rgba(255,255,255,.96); border-radius:10px;">
                    </div>
                </div>

                <hr style="border-color: var(--line); margin: 24px 0;">

                <h5 class="mb-3" style="font-weight:900;">
                    <i class="fa-solid fa-pen-to-square text-primary"></i> Cập nhật trạng thái
                </h5>

                <form method="post" action="${pageContext.request.contextPath}/admin/tickets" onsubmit="return confirmUpdate();">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="${ticket.ticketID}">

                    <div class="mb-4">
                        <label class="form-label fw-bold">
                            <i class="fa-solid fa-toggle-on"></i> Trạng thái mới
                        </label>
                        <select name="status" id="statusSelect" class="form-select" required
                                style="background: rgba(255,255,255,.96); border-radius:10px; font-weight:600;">
                            <option value="">-- Chọn trạng thái --</option>
                            
                            <c:set var="currentStatus" value="${fn:toLowerCase(ticket.status)}" />
                            
                            <!-- VALID → USED/CANCELLED -->
                            <c:if test="${currentStatus == 'valid'}">
                                <option value="USED">USED - Đã sử dụng</option>
                                <option value="CANCELLED">CANCELLED - Hủy vé</option>
                            </c:if>
                            
                            <!-- USED → Không đổi được -->
                            <c:if test="${currentStatus == 'used'}">
                                <option value="" disabled>❌ Vé đã sử dụng không thể thay đổi</option>
                            </c:if>
                            
                            <!-- CANCELLED → VALID (nếu chưa quá hạn) -->
                            <c:if test="${currentStatus == 'cancelled'}">
                                <c:set var="showTime" value="${ticket.orderDetailID.scheduleID.showTime}" />
                                <c:set var="now" value="<%= new java.util.Date() %>" />
                                <c:choose>
                                    <c:when test="${showTime.after(now)}">
                                        <option value="VALID">VALID - Phục hồi vé</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="" disabled>❌ Vé đã quá hạn suất diễn</option>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            
                            <!-- EXPIRED → Không đổi được -->
                            <c:if test="${currentStatus == 'expired'}">
                                <option value="" disabled>❌ Vé đã hết hạn không thể thay đổi</option>
                            </c:if>
                        </select>
                    </div>

                    <div class="alert alert-info" style="border-radius:12px;">
                        <i class="fa-solid fa-info-circle"></i> <strong>Lưu ý:</strong>
                        <ul class="mb-0 mt-2" style="font-size: 13px;">
                            <c:if test="${currentStatus == 'valid'}">
                                <li>Vé VALID có thể chuyển sang USED (đã check-in) hoặc CANCELLED (hủy)</li>
                            </c:if>
                            <c:if test="${currentStatus == 'used'}">
                                <li>Vé đã sử dụng không thể thay đổi trạng thái</li>
                            </c:if>
                            <c:if test="${currentStatus == 'cancelled'}">
                                <li>Vé đã hủy chỉ có thể phục hồi về VALID nếu chưa quá hạn suất diễn</li>
                            </c:if>
                            <c:if test="${currentStatus == 'expired'}">
                                <li>Vé hết hạn không thể thay đổi</li>
                            </c:if>
                        </ul>
                    </div>

                    <div class="d-flex gap-2 justify-content-end mt-4">
                        <a href="${pageContext.request.contextPath}/admin/tickets" 
                           class="btn btn-outline-light fw-bold" style="border-radius:14px;">
                            <i class="fa-solid fa-xmark"></i> Hủy
                        </a>
                        
                        <c:if test="${currentStatus != 'used' && currentStatus != 'expired'}">
                            <button type="submit" class="btn btn-primary fw-bold" style="border-radius:14px;">
                                <i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi
                            </button>
                        </c:if>
                    </div>
                </form>

                <!-- QUICK ACTION: Manual Check-In -->
                <c:if test="${currentStatus == 'valid'}">
                    <hr style="border-color: var(--line); margin: 24px 0;">
                    
                    <div class="alert alert-success" style="border-radius:12px;">
                        <h6 class="fw-bold mb-2">
                            <i class="fa-solid fa-user-check"></i> Check-in thủ công
                        </h6>
                        <p class="mb-3" style="font-size: 13px;">
                            Admin có thể check-in vé thủ công nếu khách hàng gặp vấn đề với QR code.
                        </p>
                        <form method="post" action="${pageContext.request.contextPath}/admin/tickets" 
                              onsubmit="return confirm('✅ Xác nhận check-in thủ công cho vé này?');">
                            <input type="hidden" name="action" value="checkin">
                            <input type="hidden" name="id" value="${ticket.ticketID}">
                            <button type="submit" class="btn btn-success fw-bold" style="border-radius:10px;">
                                <i class="fa-solid fa-check-circle"></i> Check-in ngay
                            </button>
                        </form>
                    </div>
                </c:if>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    function confirmUpdate() {
        const select = document.getElementById('statusSelect');
        const newStatus = select.value;
        const currentStatus = '${ticket.status}';
        
        if (!newStatus) {
            alert('⚠️ Vui lòng chọn trạng thái mới!');
            return false;
        }
        
        return confirm(
            '⚠️ XÁC NHẬN CẬP NHẬT\n\n' +
            'Vé: #${ticket.ticketID}\n' +
            'Từ: ' + currentStatus + '\n' +
            'Sang: ' + newStatus + '\n\n' +
            'Bạn có chắc chắn muốn thay đổi trạng thái không?'
        );
    }
    </script>
</body>
</html>