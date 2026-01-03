<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #${order.orderID}</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/orders-view.css">
</head>
<body>
    <div class="admin-wrap">
        <aside class="sidebar">
            <div class="brand">
                <div class="logo"><i class="fa-solid fa-masks-theater"></i></div>
                <div>
                    <div class="title">Theater Admin</div>
                    <small>Chi tiết đơn hàng</small>
                </div>
            </div>
            <hr style="border-color: var(--line);">
        </aside>

        <main class="content">
            <div class="topbar">
                <div class="page-h">
                    <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                        <i class="fa-solid fa-receipt"></i>
                    </div>
                    <div>
                        <h1>Chi tiết đơn hàng #${order.orderID}</h1>
                        <div class="crumb">Admin / Orders / View</div>
                    </div>
                </div>
            </div>

            <%-- ✅ YÊU CẦU ĐỔI GHẾ --%>
            <c:if test="${order.seatChangeRequested && order.seatChangeStatus == 'PENDING'}">
                <div class="alert alert-warning d-flex align-items-start gap-3" style="border-radius: 16px; border: 1px solid rgba(245,158,11,.3);">
                    <i class="fa-solid fa-triangle-exclamation fa-2x text-warning"></i>
                    <div class="flex-fill">
                        <h5 class="alert-heading mb-2">
                            <i class="fa-solid fa-sync me-2"></i>Yêu cầu đổi ghế
                        </h5>
                        <p class="mb-2">
                            <strong>Lý do:</strong> ${order.seatChangeReason}
                        </p>
                        <button type="button" class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#seatChangeModal">
                            <i class="fa-solid fa-check me-1"></i>Xử lý yêu cầu
                        </button>
                    </div>
                </div>
            </c:if>

            <%-- SUCCESS/ERROR MESSAGES --%>
            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-check-circle me-2"></i>${sessionScope.success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>
            
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-xmark me-2"></i>${sessionScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <div class="grid">
                <section class="cardx">
                    <div class="cardx-h">
                        <h3><i class="fa-solid fa-box"></i> Thông tin đơn hàng</h3>
                    </div>
                    <div class="cardx-b">
                        <div class="info-row">
                            <div class="info-label">Mã đơn hàng</div>
                            <div class="info-value"><span class="fw-bold">#${order.orderID}</span></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Ngày đặt</div>
                            <div class="info-value">
                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Trạng thái</div>
                            <div class="info-value">
                                <span class="badge-pill
                                      ${order.status == 'CONFIRMED' ? 'st-confirmed' :
                                        order.status == 'CANCELLED' ? 'st-cancelled' : 'st-pending'}">
                                      <c:choose>
                                          <c:when test="${order.status == 'CONFIRMED'}">
                                              <i class="fa-solid fa-badge-check"></i> ${order.status}
                                          </c:when>
                                          <c:when test="${order.status == 'CANCELLED'}">
                                              <i class="fa-solid fa-ban"></i> ${order.status}
                                          </c:when>
                                          <c:otherwise>
                                              <i class="fa-solid fa-hourglass-half"></i> ${order.status}
                                          </c:otherwise>
                                      </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Thanh toán</div>
                            <div class="info-value">
                                <span class="badge-pill ${order.paymentStatus == 'PAID' ? 'pay-paid' : 'pay-unpaid'}">
                                    <c:choose>
                                        <c:when test="${order.paymentStatus == 'PAID'}">
                                            <i class="fa-solid fa-circle-check"></i> ✓ Đã thanh toán
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fa-solid fa-clock"></i> ⏳ Chưa thanh toán
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Phương thức</div>
                            <div class="info-value">${order.paymentMethod}</div>
                        </div>
                        <c:if test="${order.cancellationRequested}">
                            <div class="reason-box">
                                <div class="t"><i class="fa-solid fa-triangle-exclamation"></i> Lý do hủy</div>
                                <div class="v">${order.cancellationReason}</div>
                            </div>
                        </c:if>
                    </div>
                </section>

                <section class="cardx">
                    <div class="cardx-h">
                        <h3><i class="fa-solid fa-user"></i> Thông tin khách hàng</h3>
                    </div>
                    <div class="cardx-b">
                        <div class="info-row">
                            <div class="info-label">Họ tên</div>
                            <div class="info-value"><span class="fw-bold">${order.userID.fullName}</span></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Email</div>
                            <div class="info-value">${order.userID.email}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Số điện thoại</div>
                            <div class="info-value">
                                ${order.userID.phone != null ? order.userID.phone : 'Chưa cập nhật'}
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">User ID</div>
                            <div class="info-value">#${order.userID.userID}</div>
                        </div>
                    </div>
                </section>
            </div>

            <div class="table-wrap">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Số ghế</th>
                                <th>Loại ghế</th>
                                <th>Vở diễn</th>
                                <th>Suất diễn</th>
                                <th>Giá</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="detail" items="${orderDetails}" varStatus="status">
                                <tr>
                                    <td class="fw-bold">${status.index + 1}</td>
                                    <td class="fw-bold">${detail.seatID.seatNumber}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${detail.seatID.seatType == 'VIP'}">
                                                <span class="badge text-bg-warning fw-bold"><i class="fa-solid fa-star"></i> VIP</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge text-bg-secondary fw-bold"><i class="fa-solid fa-chair"></i> Thường</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="fw-bold">${detail.scheduleID.showID.showName}</td>
                                    <td>
                                        <fmt:formatDate value="${detail.scheduleID.showTime}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td class="fw-bold">
                                        <fmt:formatNumber value="${detail.price}" type="number" maxFractionDigits="0"/> đ
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${!detail.seatID.isActive}">
                                                <span class="badge text-bg-danger">
                                                    <i class="fa-solid fa-tools"></i> Bảo trì
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge text-bg-success">
                                                    <i class="fa-solid fa-check"></i> Hoạt động
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="total-box">
                <div class="total-row">
                    <span>Tổng cộng</span>
                    <span><fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> đ</span>
                </div>
                <div class="total-row">
                    <span>Giảm giá</span>
                    <span>- <fmt:formatNumber value="${order.discountAmount}" type="number" maxFractionDigits="0"/> đ</span>
                </div>
                <div class="total-row final">
                    <span>Thành tiền</span>
                    <span><fmt:formatNumber value="${order.finalAmount}" type="number" maxFractionDigits="0"/> đ</span>
                </div>
            </div>

            <div class="actions">
                <c:if test="${hasTickets}">
                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check"></i>
                        <strong>Vé đã được tạo tự động!</strong> 
                        Khách hàng đã nhận được vé qua email.
                    </div>
                </c:if>

                <c:if test="${order.status == 'PENDING'}">
                    <a href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.orderID}&status=CONFIRMED"
                       class="btn btn-success btn-strong"
                       onclick="return confirm('Xác nhận đơn hàng này?')">
                        <i class="fa-solid fa-check"></i> XÁC NHẬN ĐƠN HÀNG
                    </a>
                </c:if>

                <c:if test="${order.paymentStatus != 'PAID'}">
                    <a href="#"
                       class="btn btn-success btn-strong"
                       data-bs-toggle="modal"
                       data-bs-target="#confirmMarkPaidModal"
                       data-confirm-url="${pageContext.request.contextPath}/admin/orders?action=updatePaymentStatus&id=${order.orderID}&paymentStatus=PAID">
                        <i class="fa-solid fa-money-check-dollar"></i> Xác nhận đã thanh toán
                    </a>
                </c:if>

                <c:if test="${order.status != 'CANCELLED' && order.cancellationRequested}">
                    <button type="button"
                            class="btn btn-danger btn-strong"
                            data-bs-toggle="modal"
                            data-bs-target="#confirmApproveCancelModal">
                        <i class="fa-solid fa-ban"></i> DUYỆT YÊU CẦU HỦY
                    </button>
                    <form id="approveCancelForm"
                          action="${pageContext.request.contextPath}/admin/orders"
                          method="post"
                          style="display:none;">
                        <input type="hidden" name="action" value="approveCancel">
                        <input type="hidden" name="orderId" value="${order.orderID}">
                    </form>
                </c:if>

                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-light btn-strong">
                    <i class="fa-solid fa-arrow-left"></i> Về danh sách
                </a>
            </div>
        </main>
    </div>

    <%-- SEAT CHANGE MODAL --%>
    <div class="modal fade" id="seatChangeModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">
                        <i class="fa-solid fa-sync text-warning me-2"></i>
                        Xử lý yêu cầu đổi ghế - Order #${order.orderID}
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                    <input type="hidden" name="action" value="processSeatChange">
                    <input type="hidden" name="orderId" value="${order.orderID}">
                    <input type="hidden" name="actionType" id="actionType">
                    
                    <div class="modal-body">
                        <div class="alert alert-info">
                            <strong>Lý do khách hàng:</strong><br>
                            ${order.seatChangeReason}
                        </div>
                        
                        <c:if test="${not empty availableSeats}">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Chọn ghế mới:</label>
                                <select name="newSeatId" class="form-select" id="newSeatSelect">
                                    <option value="">-- Chọn ghế --</option>
                                    <c:forEach var="seat" items="${availableSeats}">
                                        <option value="${seat.seatID}">
                                            ${seat.seatNumber} - ${seat.seatType} - 
                                            <fmt:formatNumber value="${seat.price}" type="number" maxFractionDigits="0"/>đ
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </c:if>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Ghi chú của admin (tùy chọn):</label>
                            <textarea name="adminNote" class="form-control" rows="3" 
                                      placeholder="Ví dụ: Đã đổi ghế A1 sang A5 theo yêu cầu..."></textarea>
                        </div>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fa-solid fa-xmark me-1"></i> Đóng
                        </button>
                        <button type="submit" class="btn btn-danger" onclick="document.getElementById('actionType').value='REJECT';">
                            <i class="fa-solid fa-ban me-1"></i> Từ chối
                        </button>
                        <button type="submit" class="btn btn-success" onclick="document.getElementById('actionType').value='APPROVE';" 
                                ${empty availableSeats ? 'disabled' : ''}>
                            <i class="fa-solid fa-check me-1"></i> Duyệt đổi ghế
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%-- OTHER MODALS --%>
    <div class="modal fade" id="confirmMarkPaidModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">
                        <i class="fa-solid fa-money-check-dollar text-success me-2"></i>
                        Xác nhận đã thanh toán
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-warning mb-0">
                        Bạn có chắc chắn muốn đánh dấu đơn hàng này là <b>ĐÃ THANH TOÁN</b>?
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fa-solid fa-xmark me-1"></i> Hủy
                    </button>
                    <a id="btnConfirmMarkPaid" href="#" class="btn btn-success">
                        <i class="fa-solid fa-check me-1"></i> Xác nhận
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="confirmApproveCancelModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">
                        <i class="fa-solid fa-triangle-exclamation text-danger me-2"></i>
                        Duyệt yêu cầu hủy
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger">
                        Bạn có chắc chắn muốn <b>DUYỆT HỦY</b> đơn hàng này?
                    </div>
                    <c:if test="${order.cancellationRequested}">
                        <div class="mt-2">
                            <div class="fw-bold mb-1">Lý do hủy:</div>
                            <div class="p-2 rounded bg-light text-dark">
                                ${order.cancellationReason}
                            </div>
                        </div>
                    </c:if>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fa-solid fa-xmark me-1"></i> Hủy
                    </button>
                    <button type="button" id="btnConfirmApproveCancel" class="btn btn-danger">
                        <i class="fa-solid fa-ban me-1"></i> Duyệt hủy
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/admin/orders-view.js"></script>
</body>
</html>