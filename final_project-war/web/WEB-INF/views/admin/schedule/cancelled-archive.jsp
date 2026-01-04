<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kho lưu trữ - Lịch chiếu đã kết thúc</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
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
            font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
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
        
        .page-h h1{
            font-size: 18px;
            margin:0;
            font-weight: 900;
            letter-spacing:.2px;
        }
        
        .page-h .crumb{
            color: var(--muted);
            font-weight: 600;
            font-size: 12px;
        }

        .panel{
            margin-top: 14px;
            padding: 14px;
            border-radius: 18px;
            background: rgba(255,255,255,.06);
            border: 1px solid var(--line);
            backdrop-filter: blur(10px);
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
        
        .btn-icon{
            width: 36px;
            height: 36px;
            display:inline-grid;
            place-items:center;
            border-radius: 12px;
        }

        .badge-protected {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            border: 1px solid rgba(255,255,255,.15);
            box-shadow: 0 4px 12px rgba(239,68,68,.35);
        }

        .badge-deletable {
            background: linear-gradient(135deg, #22c55e, #16a34a);
            border: 1px solid rgba(255,255,255,.15);
        }
    </style>
</head>

<body>
    <div class="admin-wrap">
        
        <!-- SIDEBAR -->
        <aside class="sidebar">
            <div class="brand">
                <div class="logo"><i class="fa-solid fa-archive"></i></div>
                <div>
                    <div class="title">Kho lưu trữ</div>
                    <small>Schedule Cancelled</small>
                </div>
            </div>

            <hr style="border-color: var(--line);">

            <div class="px-2">
                <div class="text-uppercase" style="font-size:12px; color:var(--muted); font-weight:900; letter-spacing:.3px;">
                    Quick actions
                </div>
                <div class="mt-2 d-grid gap-2">
                    <a class="btn btn-outline-light fw-bold" href="${pageContext.request.contextPath}/admin/schedule" style="border-radius:14px;">
                        <i class="fa-solid fa-arrow-left"></i> Về Quản lý lịch chiếu
                    </a>
                    <a class="btn btn-outline-light fw-bold" href="${pageContext.request.contextPath}/admin/dashboard" style="border-radius:14px;">
                        <i class="fa-solid fa-house"></i> Về Dashboard
                    </a>
                </div>
            </div>
        </aside>

        <!-- CONTENT -->
        <main class="content">
            
            <div class="topbar">
                <div class="page-h">
                    <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                        <i class="fa-solid fa-archive"></i>
                    </div>
                    <div>
                        <h1>🗄️ Kho lưu trữ - Lịch chiếu đã kết thúc</h1>
                        <div class="crumb">Admin / Schedule / Cancelled Archive</div>
                    </div>
                </div>
            </div>

            <!-- ALERTS -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success mt-3 mb-0 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-circle-check"></i>
                    <div>${param.success}</div>
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="alert alert-danger mt-3 mb-0 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <div>${param.error}</div>
                </div>
            </c:if>

            <!-- PANEL GIẢI THÍCH -->
            <div class="panel">
                <div class="d-flex align-items-start gap-3">
                    <i class="fa-solid fa-circle-info text-info" style="font-size:20px;"></i>
                    <div class="text-white-50 fw-bold" style="font-size:13px; line-height:1.6;">
                        <div class="mb-2">
                            <i class="fa-solid fa-clock text-warning"></i> 
                            Các lịch chiếu <b class="text-warning">không có đơn hàng</b> có thể xóa để giải phóng không gian.
                        </div>
                        <div>
                            <i class="fa-solid fa-shield-halved text-danger"></i> 
                            Các lịch chiếu <b class="text-danger">có đơn hàng</b> được <b class="text-danger">BẢO VỆ VĨNH VIỄN</b> để đảm bảo tính toàn vẹn dữ liệu.
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
                                <th style="width:60px;">#</th>
                                <th>Vở diễn</th>
                                <th>Thời gian chiếu</th>
                                <th style="width:200px;">Trạng thái</th>
                                <th style="width:180px;">Hành động</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="sc" items="${cancelledSchedules}" varStatus="loop">
                                <fmt:formatDate value="${sc.showTime}" pattern="dd/MM/yyyy HH:mm" var="timeFmt"/>
                                
                                <c:set var="hasOrders" value="${hasOrdersMap[sc.scheduleID]}" />
                                <c:set var="orderCount" value="${orderCountMap[sc.scheduleID]}" />

                                <tr>
                                    <td class="fw-bold">${loop.index + 1}</td>

                                    <td class="fw-bold">
                                        <i class="fa-solid fa-clapperboard text-primary"></i>
                                        <c:choose>
                                            <c:when test="${sc.showID != null}">
                                                ${sc.showID.showName}
                                            </c:when>
                                            <c:otherwise>(Không có vở diễn)</c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <i class="fa-regular fa-clock text-secondary"></i>
                                        ${timeFmt}
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${hasOrders}">
                                                <div class="d-flex flex-column gap-1">
                                                    <span class="badge badge-protected fw-bold">
                                                        <i class="fa-solid fa-lock"></i> BẢO VỆ VĨNH VIỄN
                                                    </span>
                                                    <small class="text-muted" style="font-size:11px;">
                                                        <i class="fa-solid fa-ticket"></i> ${orderCount} đơn hàng
                                                    </small>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-deletable fw-bold">
                                                    <i class="fa-solid fa-check"></i> CÓ THỂ XÓA
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-nowrap">
                                        <c:choose>
                                            <c:when test="${hasOrders}">
                                                <button class="btn btn-secondary btn-icon" 
                                                        title="Không thể xóa - Có ${orderCount} đơn hàng"
                                                        disabled>
                                                    <i class="fa-solid fa-lock"></i>
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button"
                                                        class="btn btn-danger btn-icon"
                                                        title="Xóa vĩnh viễn"
                                                        onclick="confirmDelete('${pageContext.request.contextPath}/admin/schedule/cancelled/delete?id=${sc.scheduleID}',
                                                                '<c:out value="${sc.showID != null ? sc.showID.showName : '(Không có vở diễn)'}"/>',
                                                                '<c:out value="${timeFmt}"/>')">
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty cancelledSchedules}">
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-secondary">
                                        <i class="fa-regular fa-folder-open fa-lg"></i>
                                        <div class="mt-2 fw-bold">Chưa có lịch chiếu nào đã kết thúc.</div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

    <!-- CONFIRM DELETE MODAL -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius:18px; overflow:hidden;">
                <div class="modal-header" style="background:#0f1b33; color:#e8efff; border:none;">
                    <h5 class="modal-title fw-bold">
                        <i class="fa-solid fa-triangle-exclamation text-danger"></i>
                        Xác nhận xóa vĩnh viễn
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body text-dark">
                    <div class="d-flex align-items-start gap-3">
                        <div style="width:46px;height:46px;border-radius:16px;display:grid;place-items:center;background:rgba(239,68,68,.12);">
                            <i class="fa-solid fa-trash text-danger fs-4"></i>
                        </div>

                        <div>
                            <div class="fw-bold mb-1">Bạn chắc chắn muốn xóa lịch chiếu này?</div>

                            <div class="text-secondary">
                                <div><span class="fw-bold">Vở diễn:</span> <span id="deleteShowName"></span></div>
                                <div class="mt-1"><span class="fw-bold">Giờ chiếu:</span> <span id="deleteShowTime"></span></div>
                            </div>

                            <div class="alert alert-warning mt-3 mb-0">
                                <small><i class="fa-solid fa-info-circle"></i> Hành động không thể hoàn tác!</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer" style="border:none;">
                    <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">
                        <i class="fa-solid fa-xmark"></i> Hủy
                    </button>

                    <a href="#" id="deleteConfirmBtn" class="btn btn-danger fw-bold">
                        <i class="fa-solid fa-trash"></i> Xóa vĩnh viễn
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(deleteUrl, showName, showTime) {
            document.getElementById('deleteShowName').textContent = showName || '';
            document.getElementById('deleteShowTime').textContent = showTime || '';
            document.getElementById('deleteConfirmBtn').setAttribute('href', deleteUrl || '#');

            const modal = new bootstrap.Modal(document.getElementById('deleteModal'));
            modal.show();
        }
    </script>

</body>
</html>