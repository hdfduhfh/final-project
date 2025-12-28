<%-- 
    Document   : view
    Created on : Dec 20, 2025, 10:24:33 AM
    Author     : DANG KHOA
--%>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết đơn hàng #${order.orderID}</title>

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
                font-weight: 950;
                letter-spacing:.2px;
            }
            .page-h .crumb{
                color: var(--muted);
                font-weight: 600;
                font-size: 12px;
            }

            .btn-pill{
                border-radius: 14px;
                font-weight: 900;
                padding: 10px 14px;
                white-space: nowrap;
            }

            .grid{
                margin-top: 14px;
                display:grid;
                grid-template-columns: 1fr 1fr;
                gap: 12px;
            }
            @media (max-width: 992px){
                .sidebar{
                    display:none;
                }
                .grid{
                    grid-template-columns: 1fr;
                }
            }

            .cardx{
                border-radius: 18px;
                background: rgba(255,255,255,.06);
                border: 1px solid var(--line);
                backdrop-filter: blur(10px);
                box-shadow: 0 18px 55px rgba(0,0,0,.30);
                overflow:hidden;
            }
            .cardx .cardx-h{
                padding: 14px 16px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                gap:10px;
                border-bottom: 1px solid var(--line);
            }
            .cardx .cardx-h h3{
                margin:0;
                font-size: 14px;
                font-weight: 950;
                letter-spacing:.2px;
                color:#e8efff;
                display:flex;
                align-items:center;
                gap:8px;
            }
            .cardx .cardx-b{
                padding: 14px 16px;
            }

            .info-row{
                display:flex;
                gap:12px;
                padding: 10px 0;
                border-bottom: 1px solid rgba(255,255,255,.10);
            }
            .info-row:last-child{
                border-bottom:none;
            }
            .info-label{
                width: 160px;
                color: var(--muted);
                font-weight: 900;
                font-size: 13px;
                flex: 0 0 auto;
            }
            .info-value{
                flex: 1 1 auto;
                color:#e6ecff;
                font-weight: 700;
            }

            .badge-pill{
                display:inline-flex;
                align-items:center;
                gap:6px;
                padding: 6px 10px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 950;
                border: 1px solid rgba(255,255,255,.14);
                background: rgba(255,255,255,.06);
                white-space: nowrap;
            }
            .st-confirmed{
                border-color: rgba(34,197,94,.30);
                background: rgba(34,197,94,.14);
                color:#eafff4;
            }
            .st-pending{
                border-color: rgba(245,158,11,.30);
                background: rgba(245,158,11,.16);
                color:#fff7e6;
            }
            .st-cancelled{
                border-color: rgba(239,68,68,.30);
                background: rgba(239,68,68,.16);
                color:#ffecec;
            }

            .pay-paid{
                border-color: rgba(34,197,94,.30);
                background: rgba(34,197,94,.14);
                color:#eafff4;
            }
            .pay-unpaid{
                border-color: rgba(239,68,68,.30);
                background: rgba(239,68,68,.16);
                color:#ffecec;
            }

            .reason-box{
                margin-top: 12px;
                border-radius: 16px;
                padding: 12px 14px;
                border: 1px dashed rgba(245,158,11,.35);
                background: rgba(245,158,11,.12);
                color:#fff7e6;
            }
            .reason-box .t{
                font-weight: 950;
                display:flex;
                gap:8px;
                align-items:center;
            }
            .reason-box .v{
                margin-top: 6px;
                font-weight: 800;
                word-break: break-word;
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

            .total-box{
                margin-top: 12px;
                border-radius: 18px;
                background: rgba(255,255,255,.06);
                border: 1px solid var(--line);
                backdrop-filter: blur(10px);
                padding: 14px 16px;
            }
            .total-row{
                display:flex;
                justify-content:space-between;
                padding: 8px 0;
                border-bottom: 1px solid rgba(255,255,255,.10);
                color:#e6ecff;
                font-weight: 800;
            }
            .total-row:last-child{
                border-bottom:none;
            }
            .total-row.final{
                font-size: 18px;
                font-weight: 950;
                color:#ffffff;
            }

            .actions{
                margin-top: 12px;
                display:flex;
                gap:10px;
                justify-content:flex-end;
                flex-wrap: wrap;
            }
            .btn-strong{
                border-radius: 14px;
                font-weight: 950;
                padding: 10px 14px;
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
                        <small>Chi tiết đơn hàng</small>
                    </div>
                </div>

                <hr style="border-color: var(--line);">
            </aside>

            <!-- CONTENT -->
            <main class="content">

                <!-- TOPBAR -->
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

                <!-- INFO GRID -->
                <div class="grid">
                    <!-- ORDER INFO -->
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

                    <!-- CUSTOMER INFO -->
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

                <!-- ORDER DETAILS TABLE -->
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
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- TOTALS -->
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

                <!-- ACTIONS -->
                <div class="actions">

                    <c:if test="${hasTickets}">
                        <div class="alert alert-success">
                            <i class="fa-solid fa-circle-check"></i>
                            <strong>Vé đã được tạo tự động!</strong> 
                            Khách hàng đã nhận được vé qua email.
                        </div>
                    </c:if>

                    <c:if test="${!hasTickets && order.paymentStatus == 'PAID'}">
                        <div class="alert alert-warning">
                            <i class="fa-solid fa-hourglass-half"></i>
                            <strong>Đang xử lý...</strong> 
                            Vé sẽ được tạo tự động khi thanh toán hoàn tất.
                        </div>
                    </c:if>

                    <!-- Nút xác nhận chỉ dùng để đổi status, KHÔNG TẠO VÉ NỮA -->
                    <c:if test="${order.status == 'PENDING'}">
                        <a href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.orderID}&status=CONFIRMED"
                           class="btn btn-success btn-strong"
                           onclick="return confirm('Xác nhận đơn hàng này?')">
                            <i class="fa-solid fa-check"></i> XÁC NHẬN ĐỠN HÀNG
                        </a>
                    </c:if>

                    <c:if test="${order.paymentStatus != 'PAID'}">
                        <!-- Cái này bạn có thể giữ confirm() hoặc làm modal tương tự.
                             Mình để luôn modal cho đồng bộ -->
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

                        <!-- form thật (ẩn) để submit khi bấm xác nhận trong modal -->
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

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
        <!-- ====================== BOOTSTRAP CONFIRM MODALS ====================== -->

        <!-- Modal: Xác nhận & tạo vé -->
        <div class="modal fade" id="confirmCreateTicketModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold">
                            <i class="fa-solid fa-circle-check text-success me-2"></i>
                            Xác nhận & tạo vé
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <div class="alert alert-info mb-0">
                            Bạn có chắc chắn muốn <b>XÁC NHẬN</b> đơn hàng này?<br>
                            Sau khi xác nhận, hệ thống sẽ <b>tạo vé ngay lập tức</b>.
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fa-solid fa-xmark me-1"></i> Hủy
                        </button>
                        <a id="btnConfirmCreateTicket" href="#" class="btn btn-success">
                            <i class="fa-solid fa-check me-1"></i> Xác nhận
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal: Xác nhận đã thanh toán -->
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

        <!-- Modal: Duyệt yêu cầu hủy -->
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
        <script>
           // Gán URL vào nút confirm của modal "Tạo vé"
           const createTicketModal = document.getElementById('confirmCreateTicketModal');
           if (createTicketModal) {
               createTicketModal.addEventListener('show.bs.modal', function (event) {
                   const trigger = event.relatedTarget;
                   const url = trigger.getAttribute('data-confirm-url');
                   document.getElementById('btnConfirmCreateTicket').setAttribute('href', url);
               });
           }

           // Gán URL vào nút confirm của modal "Đã thanh toán"
           const markPaidModal = document.getElementById('confirmMarkPaidModal');
           if (markPaidModal) {
               markPaidModal.addEventListener('show.bs.modal', function (event) {
                   const trigger = event.relatedTarget;
                   const url = trigger.getAttribute('data-confirm-url');
                   document.getElementById('btnConfirmMarkPaid').setAttribute('href', url);
               });
           }

           // Submit form "approveCancel" khi bấm nút trong modal
           const btnApproveCancel = document.getElementById('btnConfirmApproveCancel');
           if (btnApproveCancel) {
               btnApproveCancel.addEventListener('click', function () {
                   const form = document.getElementById('approveCancelForm');
                   if (form)
                       form.submit();
               });
           }
        </script>

    </body>
</html>
