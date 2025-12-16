<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý User - Admin Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/user-admin.css" rel="stylesheet">

    </head>
    <body>
        <div class="container py-5">

            <!-- THÔNG BÁO SERVER -->
            <c:if test="${not empty message}">
                <div class="alert alert-dismissible fade show ${message.contains('thành công') ? 'alert-success' : 'alert-danger'}" role="alert">
                    <i class="fas ${message.contains('thành công') ? 'fa-check-circle' : 'fa-exclamation-circle'} me-2"></i>
                    <strong>${message}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4>Danh sách người dùng</h4>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#userCreateModal">
                    <i class="fas fa-plus"></i> Thêm mới
                </button>
            </div>

            <!-- BẢNG USER -->
            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>Người dùng</th>
                        <th>Email</th>
                        <th>Vai trò</th>
                        <th>Ngày tạo</th>
                        <th>Tác vụ</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty users}">
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td>${u.fullName}</td>
                                    <td>${u.email}</td>
                                    <td>${u.roleID.roleName}</td>
                                    <td><fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy"/></td>
                                    <td>
                                        <button class="btn btn-action btn-outline-info border-0 bg-light text-info"
                                                title="Xem chi tiết"
                                                data-id="${u.userID}"
                                                data-fullname="${u.fullName}"
                                                data-email="${u.email}"
                                                data-phone="${u.phone}"
                                                data-role="${u.roleID.roleName}"
                                                data-created="<fmt:formatDate value='${u.createdAt}' pattern='dd/MM/yyyy HH:mm:ss'/>"
                                                data-lastlogin="<c:choose><c:when test='${not empty u.lastLogin}'><fmt:formatDate value='${u.lastLogin}' pattern='dd/MM/yyyy HH:mm:ss'/></c:when><c:otherwise>Chưa đăng nhập</c:otherwise></c:choose>"
                                                        onclick="showUserDetail(this)">
                                                        <i class="fas fa-eye"></i>
                                                    </button>

                                                        <button class="btn btn-info btn-sm" onclick="showUserEdit(${u.userID}, '${u.fullName}', '${u.email}', '${u.phone}')">
                                            <i class="fas fa-pen"></i>
                                        </button>
                                        <button class="btn btn-danger btn-sm" onclick="confirmDelete(${u.userID}, '${u.fullName}', '${u.roleID.roleName}')">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="text-center">Chưa có dữ liệu người dùng</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- MODAL CREATE USER -->
        <div class="modal fade" id="userCreateModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form id="createUserForm" method="post" action="${pageContext.request.contextPath}/admin/user">
                        <div class="modal-header">
                            <h5 class="modal-title">Thêm người dùng mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="create">

                            <!-- HIỂN THỊ LỖI -->
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">${error}</div>
                            </c:if>

                            <div class="mb-3">
                                <label>Họ và tên *</label>
                                <input type="text" name="fullName" class="form-control" value="${oldFullName}">
                                <span class="text-danger" id="createFullNameError"></span>
                            </div>
                            <div class="mb-3">
                                <label>Email *</label>
                                <input type="email" name="email" class="form-control" value="${oldEmail}">
                                <span class="text-danger" id="createEmailError"></span>
                            </div>
                            <div class="mb-3">
                                <label>Số điện thoại</label>
                                <input type="text" name="phone" class="form-control" value="${oldPhone}">
                            </div>
                            <div class="mb-3">
                                <label>Vai trò *</label>
                                <select name="roleName" class="form-control">
                                    <option value="">-- Chọn --</option>
                                    <option value="USER" ${oldRole=='USER'?'selected':''}>USER</option>
                                    <option value="ADMIN" ${oldRole=='ADMIN'?'selected':''}>ADMIN</option>
                                </select>
                                <span class="text-danger" id="createRoleError"></span>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Tạo</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <!-- MODAL DETAIL USER -->
        <div class="modal fade" id="userDetailModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-dark">
                            <i class="fas fa-id-card me-2 text-primary"></i>Hồ sơ chi tiết
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="text-center mb-4">
                            <div class="avatar-circle mx-auto" style="width: 70px; height: 70px; font-size: 1.75rem;" id="modalAvatar">U</div>
                            <h5 class="mt-3 mb-1 fw-bold text-dark" id="detailFullName">Full Name</h5>
                            <span class="badge badge-soft badge-soft-primary" id="detailRole">Role</span>
                        </div>

                        <div class="bg-light p-3 rounded-3">
                            <div class="detail-row pt-0">
                                <span class="detail-label">ID Hệ thống:</span>
                                <span class="detail-value text-secondary">#<span id="detailUserID"></span></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label"><i class="far fa-envelope me-2 text-muted"></i>Email:</span>
                                <span class="detail-value" id="detailEmail">...</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label"><i class="fas fa-phone-alt me-2 text-muted"></i>SĐT:</span>
                                <span class="detail-value" id="detailPhone">...</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label"><i class="far fa-clock me-2 text-muted"></i>Ngày tạo:</span>
                                <span class="detail-value" id="detailCreatedAt">...</span>
                            </div>
                            <div class="detail-row border-0 pb-0">
                                <span class="detail-label"><i class="fas fa-sign-in-alt me-2 text-muted"></i>Login cuối:</span>
                                <span class="detail-value text-success fw-bold" id="detailLastLogin">...</span>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-top-0">
                        <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- MODAL EDIT USER -->
        <div class="modal fade" id="userEditModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form id="editUserForm" method="post" action="${pageContext.request.contextPath}/admin/user">
                        <div class="modal-header">
                            <h5 class="modal-title">Cập nhật người dùng</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="userID" id="editUserID">

                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">${error}</div>
                            </c:if>

                            <div class="mb-3">
                                <label>Họ và tên *</label>
                                <input type="text" name="fullName" id="editFullName" class="form-control">
                                <span class="text-danger" id="editFullNameError"></span>
                            </div>
                            <div class="mb-3">
                                <label>Email *</label>
                                <input type="email" name="email" id="editEmail" class="form-control">
                                <span class="text-danger" id="editEmailError"></span>
                            </div>
                            <div class="mb-3">
                                <label>Số điện thoại</label>
                                <input type="text" name="phone" id="editPhone" class="form-control">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Lưu</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- MODAL DELETE USER -->
        <div class="modal fade" id="deleteModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">Xác nhận xóa</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>Bạn có chắc muốn xóa người dùng này không?</p>
                        <div class="alert alert-warning text-center fw-bold" id="deleteUserNameDisplay">...</div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button class="btn btn-danger" onclick="submitDeleteForm()">Xóa ngay</button>
                    </div>
                </div>
            </div>
        </div>

        <form id="deleteUserForm" method="post" action="${pageContext.request.contextPath}/admin/user">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="userID" id="inputDeleteUserId">
        </form>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/user-admin.js"></script>

        <!-- AUTO SHOW MODAL NẾU CÓ LỖI TỪ SERVER -->
        <c:if test="${showCreateModal}">
            <script>
                            new bootstrap.Modal(document.getElementById('userCreateModal')).show();
            </script>
        </c:if>

        <c:if test="${showEditModal}">
            <script>
                new bootstrap.Modal(document.getElementById('userEditModal')).show();
                document.getElementById("editUserID").value = '${editUserId}';
                document.getElementById("editFullName").value = '${editFullName}';
                document.getElementById("editEmail").value = '${editEmail}';
                document.getElementById("editPhone").value = '${editPhone}';
            </script>
        </c:if>


    </body>
</html>
