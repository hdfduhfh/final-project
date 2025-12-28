<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đánh giá | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <style>
        :root{
            --bg:#0b1220;
            --panel:#0f1b33;
            --card:#ffffff;
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

        /* Stat cards */
        .stat-grid{
            margin-top: 14px;
            display:grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 12px;
        }
        
        @media (max-width: 992px){
            .sidebar{
                display:none;
            }
            .stat-grid{
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }
        
        @media (max-width: 576px){
            .stat-grid{
                grid-template-columns: 1fr;
            }
        }

        .stat{
            background: rgba(255,255,255,.92);
            border-radius: 18px;
            padding: 14px 14px;
            border: 1px solid rgba(0,0,0,.06);
            box-shadow: 0 18px 45px rgba(0,0,0,.25);
            color:#0b1220;
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:12px;
        }
        
        .stat .label{
            font-size: 12px;
            color:#58627a;
            font-weight: 800;
            letter-spacing:.2px;
        }
        
        .stat .value{
            font-size: 22px;
            font-weight: 950;
            margin-top: 2px;
        }
        
        .stat .icon{
            width: 44px;
            height: 44px;
            border-radius: 16px;
            display:grid;
            place-items:center;
            color:#fff;
            box-shadow: 0 18px 35px rgba(0,0,0,.18);
        }
        
        .i-total{
            background: linear-gradient(135deg, #667eea, #764ba2);
        }
        
        .i-active{
            background: linear-gradient(135deg, #56ab2f, #a8e063);
        }
        
        .i-hidden{
            background: linear-gradient(135deg, #f09819, #ff512f);
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
        
        .user-avatar{
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, #d4af37, #FDB931);
            display:inline-grid;
            place-items:center;
            font-weight: 700;
            color: #000;
        }
        
        .rating-stars{
            color: #ffc107;
            font-size: 14px;
        }
        
        .rating-stars .empty{
            color: #ddd;
        }
    </style>
</head>
<body>
    <div class="admin-wrap">
        <aside class="sidebar">
            <div class="brand">
                <div class="logo"><i class="fa-solid fa-star"></i></div>
                <div>
                    <div class="title">Feedback Admin</div>
                    <small>Quản lý đánh giá</small>
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
                        <i class="fa-solid fa-comments"></i>
                    </div>
                    <div>
                        <h1>Quản lý đánh giá</h1>
                        <div class="crumb">Admin / Feedback Management</div>
                    </div>
                </div>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success mt-3 mb-0 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-circle-check"></i>
                    <div>${sessionScope.success}</div>
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger mt-3 mb-0 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <div>${sessionScope.error}</div>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <!-- Statistics -->
            <div class="stat-grid">
                <div class="stat">
                    <div>
                        <div class="label">TỔNG ĐÁNH GIÁ</div>
                        <div class="value">${totalFeedbacks}</div>
                    </div>
                    <div class="icon i-total"><i class="fa-solid fa-comments"></i></div>
                </div>

                <div class="stat">
                    <div>
                        <div class="label">ĐANG HIỂN THỊ</div>
                        <div class="value">${activeCount}</div>
                    </div>
                    <div class="icon i-active"><i class="fa-solid fa-eye"></i></div>
                </div>

                <div class="stat">
                    <div>
                        <div class="label">ĐÃ ẨN</div>
                        <div class="value">${hiddenCount}</div>
                    </div>
                    <div class="icon i-hidden"><i class="fa-solid fa-eye-slash"></i></div>
                </div>
            </div>

            <!-- Table -->
            <div class="table-wrap">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th style="width:80px;">ID</th>
                                <th>Người dùng</th>
                                <th>Suất chiếu</th>
                                <th style="width:120px;">Đánh giá</th>
                                <th>Bình luận</th>
                                <th style="width:130px;">Thời gian</th>
                                <th style="width:130px;">Trạng thái</th>
                                <th style="width:110px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty feedbacks}">
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-secondary">
                                            <i class="fa-regular fa-folder-open fa-lg"></i>
                                            <div class="mt-2 fw-bold">Chưa có đánh giá nào.</div>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="feedback" items="${feedbacks}">
                                        <tr>
                                            <td class="fw-bold">
                                                <span class="badge bg-secondary">#${feedback.feedbackID}</span>
                                            </td>
                                            
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="user-avatar">
                                                        ${feedback.userID.fullName.substring(0, 1).toUpperCase()}
                                                    </div>
                                                    <div>
                                                        <div class="fw-bold">${feedback.userID.fullName}</div>
                                                        <small class="text-muted">${feedback.userID.email}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            
                                            <td>
                                                <div class="fw-bold">
                                                    <i class="fa-solid fa-clapperboard text-primary"></i>
                                                    ${feedback.scheduleID.showID.showName}
                                                </div>
                                                <small class="text-muted">
                                                    <i class="fa-regular fa-clock"></i>
                                                    <fmt:formatDate value="${feedback.scheduleID.showTime}" pattern="dd/MM/yyyy HH:mm"/>
                                                </small>
                                            </td>
                                            
                                            <td>
                                                <div class="rating-stars">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="fa-solid fa-star ${i <= feedback.rating ? '' : 'empty'}"></i>
                                                    </c:forEach>
                                                </div>
                                                <div><small class="text-muted fw-bold">${feedback.rating}/5</small></div>
                                            </td>
                                            
                                            <td style="max-width: 300px;">
                                                <c:choose>
                                                    <c:when test="${not empty feedback.comment}">
                                                        <div style="overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                            ${feedback.comment}
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <em class="text-muted">Không có bình luận</em>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            
                                            <td>
                                                <fmt:formatDate value="${feedback.createdAt}" pattern="dd/MM/yyyy"/>
                                                <br>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${feedback.createdAt}" pattern="HH:mm"/>
                                                </small>
                                            </td>
                                            
                                            <td>
                                                <c:choose>
                                                    <c:when test="${feedback.status == 'ACTIVE'}">
                                                        <span class="badge bg-success rounded-pill fw-bold">
                                                            <i class="fa-solid fa-eye"></i> Hiển thị
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning text-dark rounded-pill fw-bold">
                                                            <i class="fa-solid fa-eye-slash"></i> Đã ẩn
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            
                                            <td class="text-nowrap">
                                                <form method="post" style="display: inline;">
                                                    <input type="hidden" name="action" value="toggleStatus">
                                                    <input type="hidden" name="feedbackId" value="${feedback.feedbackID}">
                                                    <button type="submit" class="btn ${feedback.status == 'ACTIVE' ? 'btn-warning' : 'btn-success'} btn-icon text-white" 
                                                            title="${feedback.status == 'ACTIVE' ? 'Ẩn' : 'Hiện'}">
                                                        <i class="fa-solid fa-eye${feedback.status == 'ACTIVE' ? '-slash' : ''}"></i>
                                                    </button>
                                                </form>
                                                
                                                <button type="button" class="btn btn-danger btn-icon" title="Xóa"
                                                        onclick="openDeleteModal('${feedback.feedbackID}', '${feedback.userID.fullName}')">
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Delete Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius:18px; overflow:hidden;">
                <div class="modal-header" style="background:#0f1b33; color:#e8efff; border:none;">
                    <h5 class="modal-title fw-bold">
                        <i class="fa-solid fa-triangle-exclamation text-warning"></i>
                        Xác nhận xóa
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body text-dark">
                    <div class="d-flex align-items-start gap-3">
                        <div style="width:46px;height:46px;border-radius:16px;display:grid;place-items:center;background:rgba(239,68,68,.12);">
                            <i class="fa-solid fa-trash-can text-danger fs-4"></i>
                        </div>

                        <div>
                            <div class="fw-bold mb-1">Bạn có chắc muốn xóa đánh giá này?</div>
                            <div class="text-secondary" id="deleteUser"></div>
                            <small class="text-muted d-block mt-2">Hành động này không thể hoàn tác!</small>
                        </div>
                    </div>
                </div>

                <div class="modal-footer" style="border:none;">
                    <button type="button" class="btn btn-outline-dark fw-bold" data-bs-dismiss="modal">
                        <i class="fa-solid fa-xmark"></i> Hủy
                    </button>
                    <form id="deleteForm" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="feedbackId" id="deleteFeedbackId">
                        <button type="submit" class="btn btn-danger fw-bold">
                            <i class="fa-solid fa-trash"></i> Xóa
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openDeleteModal(feedbackId, userName) {
            document.getElementById('deleteFeedbackId').value = feedbackId;
            document.getElementById('deleteUser').textContent = 'Người dùng: ' + userName;
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }
    </script>
</body>
</html>