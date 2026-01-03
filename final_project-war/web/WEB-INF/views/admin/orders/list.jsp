<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/orders-list.css">
</head>
<body>
    <div class="admin-wrap">
        <aside class="sidebar">
            <div class="brand">
                <div class="logo"><i class="fa-solid fa-masks-theater"></i></div>
                <div>
                    <div class="title">Theater Admin</div>
                    <small>Quản lý đơn hàng</small>
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

        <main class="content">
            <div class="topbar">
                <div class="page-h">
                    <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                        <i class="fa-solid fa-receipt"></i>
                    </div>
                    <div>
                        <h1>Danh sách đơn hàng</h1>
                        <div class="crumb">Admin / Order Management</div>
                    </div>
                </div>
            </div>

            <div class="stat-grid">
                <div class="stat">
                    <div>
                        <div class="label">Tổng đơn hàng</div>
                        <div class="value">${orders.size()}</div>
                    </div>
                    <div class="icon i-total"><i class="fa-solid fa-layer-group"></i></div>
                </div>
                <div class="stat">
                    <div>
                        <div class="label">Đã xác nhận</div>
                        <div class="value">
                            <c:set var="confirmedCount" value="0" />
                            <c:forEach var="order" items="${orders}">
                                <c:if test="${order.status == 'CONFIRMED'}">
                                    <c:set var="confirmedCount" value="${confirmedCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${confirmedCount}
                        </div>
                    </div>
                    <div class="icon i-confirm"><i class="fa-solid fa-circle-check"></i></div>
                </div>
                <div class="stat">
                    <div>
                        <div class="label">Đã thanh toán</div>
                        <div class="value">
                            <c:set var="paidCount" value="0" />
                            <c:forEach var="order" items="${orders}">
                                <c:if test="${order.paymentStatus == 'PAID'}">
                                    <c:set var="paidCount" value="${paidCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${paidCount}
                        </div>
                    </div>
                    <div class="icon i-paid"><i class="fa-solid fa-money-check-dollar"></i></div>
                </div>
            </div>

            <div class="panel">
                <div class="row g-2 align-items-center">
                    <div class="col-lg-6">
                        <label class="form-label fw-bold mb-1" style="color:#e6ecff;">Lọc theo trạng thái</label>
                        <select id="filterStatus" class="form-select">
                            <option value="">Tất cả trạng thái</option>
                            <option value="CONFIRMED">Đã xác nhận</option>
                            <option value="PENDING">Đang chờ</option>
                            <option value="CANCELLED">Đã hủy</option>
                        </select>
                    </div>
                    <div class="col-lg-6">
                        <label class="form-label fw-bold mb-1" style="color:#e6ecff;">Lọc theo thanh toán</label>
                        <select id="filterPayment" class="form-select">
                            <option value="">Tất cả thanh toán</option>
                            <option value="PAID">Đã thanh toán</option>
                            <option value="PENDING">Chưa thanh toán</option>
                        </select>
                    </div>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="table-wrap">
                        <div class="empty">
                            <i class="fa-regular fa-folder-open fa-2x"></i>
                            <div class="mt-2 fw-bold">Chưa có đơn hàng nào.</div>
                            <div class="mt-1">Đơn hàng sẽ hiển thị ở đây khi khách hàng đặt vé.</div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <div class="table-responsive">
                            <table id="ordersTable" class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Mã ĐH</th>
                                        <th>Khách hàng</th>
                                        <th>Ngày đặt</th>
                                        <th>Tổng tiền</th>
                                        <th>Thanh toán</th>
                                        <th>Trạng thái</th>
                                        <th>Phương thức</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${orders}">
                                        <tr data-status="${order.status}" data-payment="${order.paymentStatus}">
                                            <td class="fw-bold">#${order.orderID}</td>
                                            <td>
                                                <div class="fw-bold">${order.userID.fullName}</div>
                                                <div class="text-secondary small">${order.userID.email}</div>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td class="fw-bold">
                                                <fmt:formatNumber value="${order.finalAmount}" type="number" maxFractionDigits="0"/> đ
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.paymentStatus == 'PAID'}">
                                                        <span class="status-badge pay-paid">
                                                            <i class="fa-solid fa-circle-check"></i> Đã thanh toán
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge pay-unpaid">
                                                            <i class="fa-solid fa-clock"></i> Chưa thanh toán
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.status == 'CONFIRMED'}">
                                                        <span class="status-badge st-confirmed">
                                                            <i class="fa-solid fa-badge-check"></i> CONFIRMED
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'CANCELLED'}">
                                                        <span class="status-badge st-cancelled">
                                                            <i class="fa-solid fa-ban"></i> CANCELLED
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge st-pending">
                                                            <i class="fa-solid fa-hourglass-half"></i> PENDING
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                                
                                                <%-- ✅ BADGE YÊU CẦU HỦY --%>
                                                <c:if test="${order.cancellationRequested}">
                                                    <span class="req-cancel">
                                                        <i class="fa-solid fa-triangle-exclamation"></i> Yêu cầu hủy
                                                    </span>
                                                </c:if>
                                                
                                                <%-- ✅ BADGE YÊU CẦU ĐỔI GHẾ --%>
                                                <c:if test="${order.seatChangeRequested && order.seatChangeStatus == 'PENDING'}">
                                                    <span class="req-seat-change">
                                                        <i class="fa-solid fa-sync"></i> Yêu cầu đổi ghế
                                                    </span>
                                                </c:if>
                                            </td>
                                            <td>${order.paymentMethod}</td>
                                            <td class="text-nowrap">
                                                <a href="${pageContext.request.contextPath}/admin/orders?action=view&id=${order.orderID}"
                                                   class="btn btn-info btn-icon text-white">
                                                    <i class="fa-solid fa-eye"></i> Xem
                                                </a>
                                                <c:if test="${order.status != 'CANCELLED' && order.cancellationRequested}">
                                                    <button type="button"
                                                            class="btn btn-danger btn-icon"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#confirmApproveCancelModal"
                                                            data-order-id="${order.orderID}">
                                                        <i class="fa-solid fa-check"></i> Duyệt hủy
                                                    </button>
                                                    <form id="approveCancelForm-${order.orderID}"
                                                          action="${pageContext.request.contextPath}/admin/orders"
                                                          method="post" style="display:none;">
                                                        <input type="hidden" name="action" value="approveCancel">
                                                        <input type="hidden" name="orderId" value="${order.orderID}">
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>

    <div class="modal fade" id="confirmApproveCancelModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">
                        <i class="fa-solid fa-triangle-exclamation text-danger me-2"></i>
                        Duyệt yêu cầu hủy đơn hàng
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger mb-0">
                        Bạn có chắc chắn muốn <b>DUYỆT HỦY</b> đơn hàng
                        <b id="cancelOrderIdText">#</b> không?
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fa-solid fa-xmark me-1"></i> Hủy
                    </button>
                    <button type="button" id="btnConfirmApproveCancel" class="btn btn-danger">
                        <i class="fa-solid fa-ban me-1"></i> Xác nhận duyệt hủy
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/admin/orders-list.js"></script>
</body>
</html>