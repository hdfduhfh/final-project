<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý User - Admin Dashboard</title>

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome 6 -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

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

            .badge-status{
                font-weight: 800;
                border-radius: 999px;
                padding: 6px 10px;
                font-size: 12px;
            }

            .btn-icon{
                width: 36px;
                height: 36px;
                display:inline-grid;
                place-items:center;
                border-radius: 12px;
            }

            @media (max-width: 992px){
                .sidebar{
                    display:none;
                }
            }
        </style>
    </head>

    <body>
        <div class="admin-wrap">

            <!-- SIDEBAR -->
            <aside class="sidebar">
                <div class="brand">
                    <div class="logo"><i class="fa-solid fa-users"></i></div>
                    <div>
                        <div class="title">User Admin</div>
                        <small>Quản lý người dùng</small>
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
                        <button class="btn btn-light fw-bold" data-bs-toggle="modal" data-bs-target="#userCreateModal" style="border-radius:14px;">
                            <i class="fa-solid fa-circle-plus"></i> Thêm người dùng
                        </button>
                    </div>
                </div>
            </aside>

            <!-- CONTENT -->
            <main class="content">

                <!-- TOPBAR -->
                <div class="topbar">
                    <div class="page-h">
                        <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                            <i class="fa-solid fa-users"></i>
                        </div>
                        <div>
                            <h1>Danh sách người dùng</h1>
                            <div class="crumb">Admin / User Management / List</div>
                        </div>
                    </div>
                </div>

                <!-- THÔNG BÁO SERVER -->
                <c:if test="${not empty message}">
                    <div class="alert mt-3 mb-0 d-flex align-items-center gap-2 ${message.contains('thành công') ? 'alert-success' : 'alert-danger'}" role="alert">
                        <i class="fa-solid ${message.contains('thành công') ? 'fa-circle-check' : 'fa-triangle-exclamation'}"></i>
                        <div class="fw-bold">${message}</div>
                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- PANEL FILTERS -->
                <div class="panel">
                    <form method="get" action="${pageContext.request.contextPath}/admin/user">
                        <div class="row g-3 align-items-end">
                            <!-- Lọc theo vai trò -->
                            <div class="col-md-3">
                                <label class="form-label text-white fw-bold mb-2">
                                    <i class="fa-solid fa-filter"></i> Vai trò
                                </label>
                                <select name="roleFilter" class="form-select">
                                    <option value="">-- Tất cả vai trò --</option>
                                    <option value="USER" ${param.roleFilter == 'USER' ? 'selected' : ''}>USER</option>
                                    <option value="ADMIN" ${param.roleFilter == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                                </select>
                            </div>

                            <!-- Lọc theo ngày tạo -->
                            <div class="col-md-3">
                                <label class="form-label text-white fw-bold mb-2">
                                    <i class="fa-solid fa-sort"></i> Sắp xếp ngày tạo
                                </label>
                                <select name="dateSort" class="form-select">
                                    <option value="">-- Mặc định --</option>
                                    <option value="newest" ${param.dateSort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                                    <option value="oldest" ${param.dateSort == 'oldest' ? 'selected' : ''}>Cũ nhất</option>
                                </select>
                            </div>

                            <!-- Tìm kiếm theo tên/email -->
                            <div class="col-md-4">
                                <label class="form-label text-white fw-bold mb-2">
                                    <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm
                                </label>
                                <input type="text" name="keyword" class="form-control" 
                                       placeholder="Tên hoặc email..." 
                                       value="${param.keyword}">
                            </div>

                            <div class="col-md-2">
                                <button type="submit" class="btn btn-warning w-100 fw-bold">
                                    <i class="fa-solid fa-search"></i> Lọc
                                </button>
                            </div>
                        </div>

                        <!-- Hiển thị kết quả lọc -->
                        <c:if test="${not empty param.roleFilter or not empty param.dateSort or not empty param.keyword}">
                            <div class="mt-3 d-flex gap-2 align-items-center flex-wrap">
                                <span class="text-white-50">Đang lọc:</span>
                                <c:if test="${not empty param.roleFilter}">
                                    <span class="badge bg-info">Vai trò: ${param.roleFilter}</span>
                                </c:if>
                                <c:if test="${not empty param.dateSort}">
                                    <span class="badge bg-info">Ngày: ${param.dateSort == 'newest' ? 'Mới nhất' : 'Cũ nhất'}</span>
                                </c:if>
                                <c:if test="${not empty param.keyword}">
                                    <span class="badge bg-info">Từ khóa: "${param.keyword}"</span>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/admin/user" class="badge bg-danger text-decoration-none">
                                    <i class="fa-solid fa-xmark"></i> Xóa bộ lọc
                                </a>
                            </div>
                        </c:if>
                    </form>
                </div>

                <!-- Thống kê -->
                <div class="panel">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                        <div class="fw-bold text-white-50">
                            Tổng số người dùng:
                            <span class="text-white">${not empty users ? users.size() : 0}</span>
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
                                    <th>Người dùng</th>
                                    <th>Email</th>
                                    <th>Vai trò</th>
                                    <th>Đơn hàng</th>
                                    <th>Ngày tạo</th>
                                    <th style="width:170px;">Tác vụ</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty users}">
                                        <c:forEach var="u" items="${users}" varStatus="loop">
                                            <c:set var="orderCount" value="${orderCountMap[u.userID]}" />
                                            <tr>
                                                <td class="fw-bold">${loop.index + 1}</td>
                                                
                                                <td class="fw-bold">
                                                    <div class="d-flex align-items-center gap-2">
                                                        <i class="fa-solid fa-user-tie text-primary"></i>
                                                        <span>${u.fullName}</span>
                                                    </div>
                                                </td>
                                                
                                                <td>
                                                    <i class="fa-regular fa-envelope text-secondary"></i> ${u.email}
                                                </td>
                                                
                                                <td>
                                                    <span class="badge badge-status text-bg-light border">
                                                        <i class="fa-solid fa-id-badge"></i> ${u.roleID.roleName}
                                                    </span>
                                                </td>
                                                
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${orderCount > 0}">
                                                            <span class="badge bg-primary">
                                                                <i class="fa-solid fa-shopping-cart"></i> ${orderCount} đơn
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-secondary">
                                                                <i class="fa-regular fa-circle"></i> Chưa có
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                
                                                <td>
                                                    <i class="fa-regular fa-clock text-secondary"></i>
                                                    <fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy"/>
                                                </td>
                                                
                                                <td class="text-nowrap">
                                                    <!-- DETAIL -->
                                                    <button class="btn btn-info btn-icon"
                                                            title="Xem chi tiết"
                                                            data-id="${u.userID}"
                                                            data-fullname="${u.fullName}"
                                                            data-email="${u.email}"
                                                            data-phone="${u.phone}"
                                                            data-role="${u.roleID.roleName}"
                                                            data-ordercount="${orderCount}"
                                                            data-created="<fmt:formatDate value='${u.createdAt}' pattern='dd/MM/yyyy HH:mm:ss'/>"
                                                            data-lastlogin="<c:choose><c:when test='${not empty u.lastLogin}'><fmt:formatDate value='${u.lastLogin}' pattern='dd/MM/yyyy HH:mm:ss'/></c:when><c:otherwise>Chưa đăng nhập</c:otherwise></c:choose>"
                                                            onclick="showUserDetail(this)">
                                                        <i class="fa-solid fa-circle-info"></i>
                                                    </button>

                                                    <!-- EDIT -->
                                                    <button class="btn btn-primary btn-icon"
                                                            title="Sửa"
                                                            onclick="showUserEdit(${u.userID}, '${u.fullName}', '${u.email}', '${u.phone}')">
                                                        <i class="fa-solid fa-pen-to-square"></i>
                                                    </button>

                                                    <!-- DELETE -->
                                                    <button class="btn btn-danger btn-icon"
                                                            title="Xóa"
                                                            onclick="confirmDelete(${u.userID}, '${u.fullName}', '${u.roleID.roleName}', ${orderCount})">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" class="text-center py-5 text-secondary">
                                                <i class="fa-regular fa-folder-open fa-lg"></i>
                                                <div class="mt-2 fw-bold">Không tìm thấy người dùng nào.</div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- ========== MODALS ========== -->

                <!-- MODAL CREATE USER -->
                <div class="modal fade" id="userCreateModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content" style="border-radius:18px; overflow:hidden;">
                            <form id="createUserForm" method="post" 
                                  action="${pageContext.request.contextPath}/admin/user" 
                                  novalidate>
                                <div class="modal-header" style="background:#0f1b33; color:#e8efff; border:none;">
                                    <h5 class="modal-title fw-bold">
                                        <i class="fa-solid fa-circle-plus text-warning me-2"></i>Thêm người dùng mới
                                    </h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <input type="hidden" name="action" value="create">

                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger">${error}</div>
                                    </c:if>

                                    <div class="mb-3">
                                        <label class="fw-bold">Họ và tên *</label>
                                        <input type="text" name="fullName" class="form-control" value="${oldFullName}">
                                        <span class="text-danger" id="createFullNameError"></span>
                                    </div>

                                    <div class="mb-3">
                                        <label class="fw-bold">Email *</label>
                                        <input type="email" name="email" class="form-control" value="${oldEmail}">
                                        <span class="text-danger" id="createEmailError"></span>
                                    </div>

                                    <div class="mb-3">
                                        <label class="fw-bold">Số điện thoại</label>
                                        <input type="text" name="phone" class="form-control" value="${oldPhone}">
                                    </div>

                                    <div class="mb-3">
                                        <label class="fw-bold">Vai trò *</label>
                                        <select name="roleName" class="form-select">
                                            <option value="">-- Chọn --</option>
                                            <option value="USER" ${oldRole=='USER'?'selected':''}>USER</option>
                                            <option value="ADMIN" ${oldRole=='ADMIN'?'selected':''}>ADMIN</option>
                                        </select>
                                        <span class="text-danger" id="createRoleError"></span>
                                    </div>
                                </div>
                                <div class="modal-footer" style="border:none;">
                                    <button class="btn btn-outline-dark fw-bold" data-bs-dismiss="modal">
                                        <i class="fa-solid fa-xmark"></i> Hủy
                                    </button>
                                    <button type="submit" class="btn btn-warning fw-bold">
                                        <i class="fa-solid fa-check"></i> Tạo
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- MODAL DETAIL USER -->
                <div class="modal fade" id="userDetailModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content" style="border-radius:18px; overflow:hidden;">
                            <div class="modal-header" style="background:#0f1b33; color:#e8efff; border:none;">
                                <h5 class="modal-title fw-bold">
                                    <i class="fa-solid fa-id-card text-info me-2"></i>Hồ sơ chi tiết
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                            </div>

                            <div class="modal-body p-4">
                                <div class="text-center mb-4">
                                    <div class="avatar-circle mx-auto" style="width: 70px; height: 70px; font-size: 1.75rem; background: linear-gradient(135deg, #667eea, #764ba2); color: white; display: grid; place-items: center; border-radius: 50%; font-weight: bold;" id="modalAvatar">U</div>
                                    <h5 class="mt-3 mb-1 fw-bold text-dark" id="detailFullName">Full Name</h5>
                                    <span class="badge text-bg-primary" id="detailRole">Role</span>
                                </div>

                                <div class="bg-light p-3 rounded-3">
                                    <div style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #dee2e6;">
                                        <span style="color: #6c757d;">ID:</span>
                                        <span class="text-secondary">#<span id="detailUserID"></span></span>
                                    </div>
                                    <div style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #dee2e6;">
                                        <span style="color: #6c757d;"><i class="fa-regular fa-envelope me-2"></i>Email:</span>
                                        <span id="detailEmail">...</span>
                                    </div>
                                    <div style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #dee2e6;">
                                        <span style="color: #6c757d;"><i class="fa-solid fa-phone me-2"></i>SĐT:</span>
                                        <span id="detailPhone">...</span>
                                    </div>
                                    <div style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #dee2e6;">
                                        <span style="color: #6c757d;"><i class="fa-solid fa-shopping-cart me-2"></i>Đơn hàng:</span>
                                        <span id="detailOrderCount" class="fw-bold">0 đơn</span>
                                    </div>
                                    <div style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #dee2e6;">
                                        <span style="color: #6c757d;"><i class="fa-regular fa-clock me-2"></i>Ngày tạo:</span>
                                        <span id="detailCreatedAt">...</span>
                                    </div>
                                    <div style="display: flex; justify-content: space-between; padding: 8px 0;">
                                        <span style="color: #6c757d;"><i class="fa-solid fa-right-to-bracket me-2"></i>Login cuối:</span>
                                        <span class="text-success fw-bold" id="detailLastLogin">...</span>
                                    </div>
                                </div>
                            </div>

                            <div class="modal-footer bg-light border-top-0">
                                <button type="button" class="btn btn-outline-dark fw-bold" data-bs-dismiss="modal" style="border-radius:14px;">
                                    <i class="fa-solid fa-xmark"></i> Đóng
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- MODAL EDIT USER -->
                <div class="modal fade" id="userEditModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content" style="border-radius:18px; overflow:hidden;">
                            <form id="editUserForm" method="post" 
                                  action="${pageContext.request.contextPath}/admin/user" 
                                  novalidate>
                                <div class="modal-header" style="background:#0f1b33; color:#e8efff; border:none;">
                                    <h5 class="modal-title fw-bold">
                                        <i class="fa-solid fa-pen-to-square text-warning me-2"></i>Cập nhật người dùng
                                    </h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>

                                <div class="modal-body">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="userID" id="editUserID">

                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger">${error}</div>
                                    </c:if>

                                    <div class="mb-3">
                                        <label class="fw-bold">Họ và tên *</label>
                                        <input type="text" name="fullName" id="editFullName" class="form-control">
                                        <span class="text-danger" id="editFullNameError"></span>
                                    </div>
                                    <div class="mb-3">
                                        <label class="fw-bold">Email *</label>
                                        <input type="email" name="email" id="editEmail" class="form-control">
                                        <span class="text-danger" id="editEmailError"></span>
                                    </div>
                                    <div class="mb-3">
                                        <label class="fw-bold">Số điện thoại</label>
                                        <input type="text" name="phone" id="editPhone" class="form-control">
                                    </div>
                                </div>

                                <div class="modal-footer" style="border:none;">
                                    <button class="btn btn-outline-dark fw-bold" data-bs-dismiss="modal">
                                        <i class="fa-solid fa-xmark"></i> Hủy
                                    </button>
                                    <button type="submit" class="btn btn-warning fw-bold">
                                        <i class="fa-solid fa-check"></i> Lưu
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- MODAL DELETE USER -->
                <div class="modal fade" id="deleteModal" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content" style="border-radius:18px; overflow:hidden;">
                            <div class="modal-header" style="background:#0f1b33; color:#e8efff; border:none;">
                                <h5 class="modal-title fw-bold">
                                    <i class="fa-solid fa-triangle-exclamation text-warning me-2"></i>Xác nhận xóa
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body text-dark">
                                <div class="d-flex align-items-start gap-3">
                                    <div style="width:46px;height:46px;border-radius:16px;display:grid;place-items:center;background:rgba(239,68,68,.12);">
                                        <i class="fa-solid fa-trash-can text-danger fs-4"></i>
                                    </div>
                                    <div>
                                        <p class="mb-2 fw-bold">Bạn có chắc muốn xóa người dùng này không?</p>
                                        <div class="alert alert-warning text-center fw-bold mb-0" id="deleteUserNameDisplay">...</div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer" style="border:none;">
                                <button class="btn btn-outline-dark fw-bold" data-bs-dismiss="modal">
                                    <i class="fa-solid fa-xmark"></i> Hủy
                                </button>
                                <button class="btn btn-danger fw-bold" id="confirmDeleteBtn" onclick="submitDeleteForm()">
                                    <i class="fa-solid fa-trash"></i> Xóa ngay
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <form id="deleteUserForm" method="post" action="${pageContext.request.contextPath}/admin/user">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="userID" id="inputDeleteUserId">
            </form>

            <!-- AUTO SHOW MODAL NẾU CÓ LỖI TỪ SERVER -->
            <c:if test="${showCreateModal}">
                <script>
                    window.addEventListener("load", function () {
                        new bootstrap.Modal(document.getElementById('userCreateModal')).show();
                    });
                </script>
            </c:if>

            <c:if test="${showEditModal}">
                <script>
                    window.addEventListener("load", function () {
                        new bootstrap.Modal(document.getElementById('userEditModal')).show();
                        document.getElementById("editUserID").value = '${editUserId}';
                        document.getElementById("editFullName").value = '${editFullName}';
                        document.getElementById("editEmail").value = '${editEmail}';
                        document.getElementById("editPhone").value = '${editPhone}';
                    });
                </script>
            </c:if>

        </main>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function showUserDetail(btn) {
            document.getElementById('detailUserID').textContent = btn.getAttribute('data-id');
            document.getElementById('detailFullName').textContent = btn.getAttribute('data-fullname');
            document.getElementById('detailEmail').textContent = btn.getAttribute('data-email');
            document.getElementById('detailPhone').textContent = btn.getAttribute('data-phone') || 'Chưa cập nhật';
            document.getElementById('detailRole').textContent = btn.getAttribute('data-role');
            document.getElementById('detailOrderCount').textContent = btn.getAttribute('data-ordercount') + ' đơn';
            document.getElementById('detailCreatedAt').textContent = btn.getAttribute('data-created');
            document.getElementById('detailLastLogin').textContent = btn.getAttribute('data-lastlogin');
            
            const name = btn.getAttribute('data-fullname');
            document.getElementById('modalAvatar').textContent = name.charAt(0).toUpperCase();
            
            new bootstrap.Modal(document.getElementById('userDetailModal')).show();
        }

        function showUserEdit(id, name, email, phone) {
            document.getElementById('editUserID').value = id;
            document.getElementById('editFullName').value = name;
            document.getElementById('editEmail').value = email;
            document.getElementById('editPhone').value = phone || '';
            new bootstrap.Modal(document.getElementById('userEditModal')).show();
        }

        function confirmDelete(userId, userName, role, orderCount) {
            document.getElementById('inputDeleteUserId').value = userId;
            document.getElementById('deleteUserNameDisplay').innerHTML = 
                '<i class="fa-solid fa-user"></i> ' + userName + 
                '<br><small>Vai trò: ' + role + ' | Đơn hàng: ' + orderCount + '</small>';
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }

        function submitDeleteForm() {
            document.getElementById('deleteUserForm').submit();
        }
    </script>

</body>
</html