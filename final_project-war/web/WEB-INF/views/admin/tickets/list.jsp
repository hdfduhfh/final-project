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
            .admin-wrap{ display:flex; min-height:100vh; }
            .sidebar{
                width:270px;
                background: rgba(15,27,51,.86);
                border-right: 1px solid var(--line);
                backdrop-filter: blur(10px);
                padding: 18px 14px;
                position: sticky;
                top:0;
                height:100vh;
            }
            .brand{
                display:flex; align-items:center; gap:10px;
                padding:10px 12px;
                border-radius:14px;
                background: rgba(255,255,255,.06);
                border: 1px solid var(--line);
            }
            .brand .logo{
                width:38px;height:38px;border-radius:12px;
                display:grid;place-items:center;
                background: linear-gradient(135deg, rgba(79,70,229,.9), rgba(6,182,212,.9));
                box-shadow: 0 14px 35px rgba(0,0,0,.35);
            }
            .brand .title{ line-height:1.1; font-weight:800; letter-spacing:.2px; }
            .brand small{ color:var(--muted); font-weight:600; }

            .nav-group{ margin-top: 14px; }
            .nav-item{
                display:flex; align-items:center; gap:10px;
                padding:10px 12px;
                border-radius:12px;
                color:#dbe5ff;
                text-decoration:none;
                border:1px solid transparent;
            }
            .nav-item:hover{ background: rgba(255,255,255,.06); border-color: var(--line); }
            .nav-item.active{
                background: rgba(6,182,212,.16);
                border-color: rgba(6,182,212,.35);
            }
            .nav-item i{ width:20px; text-align:center; color:#bcd0ff; }

            .content{ flex:1; padding: 22px 22px 28px; }

            .topbar{
                display:flex; gap:12px; align-items:center; justify-content:space-between;
                padding:14px 16px;
                border-radius:18px;
                background: rgba(255,255,255,.06);
                border: 1px solid var(--line);
                backdrop-filter: blur(10px);
                box-shadow: 0 18px 55px rgba(0,0,0,.35);
            }
            .page-h{ display:flex; gap:12px; align-items:center; }
            .page-h h1{ font-size:18px; margin:0; font-weight:900; letter-spacing:.2px; }
            .page-h .crumb{ color: var(--muted); font-weight:600; font-size:12px; }

            .panel{
                margin-top:14px;
                padding:14px;
                border-radius:18px;
                background: rgba(255,255,255,.06);
                border: 1px solid var(--line);
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
                background: #0f1b33 !important;
                color: #e8efff !important;
                border:none !important;
                white-space: nowrap;
                font-size: 13px;
                letter-spacing:.2px;
            }
            table tbody td{ color:#0b1220; vertical-align: middle; }

            .btn-icon{
                width:36px;height:36px;
                display:inline-grid; place-items:center;
                border-radius:12px;
            }

            /* QR code pill (clear text) */
            .code-pill{
                display:inline-flex;
                align-items:center;
                gap:8px;
                padding: 6px 12px;
                border-radius: 999px;
                background: rgba(15,23,42,.10);
                border: 1px solid rgba(15,23,42,.16);

                color:#0f172a;
                font-weight: 950;
                letter-spacing:.5px;
                text-transform: uppercase;
                font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;

                text-shadow: none;
                -webkit-text-fill-color:#0f172a;
            }
            .code-pill i{ color:#334155; opacity:1; filter:none; }

            /* Status badges */
            .status-badge{
                display:inline-flex;
                align-items:center;
                gap:7px;
                padding: 6px 10px;
                border-radius: 999px;
                font-weight: 900;
                font-size: 12px;
                border: 1px solid rgba(0,0,0,.08);
                background: rgba(255,255,255,.9);
            }
            .st-valid{ color:#166534; background: rgba(34,197,94,.12); border-color: rgba(34,197,94,.25); }
            .st-used{ color:#334155; background: rgba(148,163,184,.18); border-color: rgba(148,163,184,.28); }
            .st-cancelled{ color:#991b1b; background: rgba(239,68,68,.12); border-color: rgba(239,68,68,.25); }

            /* empty */
            .empty{
                padding: 48px 16px;
                text-align:center;
                color:#6b7280;
            }

            @media (max-width: 992px){
                .sidebar{ display:none; }
            }

            /* Modal style (tối giản, hợp theme) */
            .modal-content{
                border-radius: 18px;
                overflow: hidden;
                border: none;
                box-shadow: 0 30px 120px rgba(0,0,0,0.45);
            }
            .modal-header{
                background: #0f1b33;
                color: #e8efff;
                border: none;
            }
            .modal-title{ font-weight: 900; }
            .modal-body{ background:#fff; color:#0b1220; }
            .modal-footer{ background:#f8fafc; border:none; }

            /* Table inside modal */
            .modal table th{
                width: 180px;
                background:#f1f5f9;
                color:#0f172a;
                border-color:#e5e7eb;
                font-weight:900;
            }
            .modal table td{
                border-color:#e5e7eb;
                color:#0b1220;
                font-weight:600;
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
