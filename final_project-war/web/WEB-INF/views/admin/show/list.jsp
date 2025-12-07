<%-- 
    Document   : list
    Created on : Dec 6, 2025, 5:57:11 PM
    Author     : DANG KHOA
--%>

<%-- 
    Document   : list (Show Management)
    Created on : Dec 6, 2025
    Author     : DANG KHOA
    Đường dẫn: final_project-war/Web Pages/WEB-INF/views/admin/show/list.jsp
--%>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Show - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">

</head>
<body>
    <div class="admin-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-logo">🎭 BookingStage</div>
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/admin/show" class="active">🎪 Quản lý Show</a></li>

            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Top Bar -->
            <div class="top-bar">
                <h1 class="page-title">Quản lý Show</h1>
                <div class="admin-user">
                    <span class="admin-name">Admin: ${sessionScope.user.fullName}</span>
                    <a href="${pageContext.request.contextPath}/admin/logout" class="btn-logout">Đăng xuất</a>
                </div>
            </div>

            <!-- Thông báo -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    ✓ ${success}
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    ⚠️ ${error}
                </div>
            </c:if>

            <!-- Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">🎪</div>
                    <div class="stat-value">${totalShows}</div>
                    <div class="stat-label">Tổng số Show</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">✅</div>
                    <div class="stat-value">${activeShows}</div>
                    <div class="stat-label">Show đang hoạt động</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">❌</div>
                    <div class="stat-value">${inactiveShows}</div>
                    <div class="stat-label">Show đã đóng</div>
                </div>
            </div>

            <!-- Action Bar -->
            <div class="action-bar">
                <div class="search-box">
                    <input type="text" class="search-input" id="searchInput" placeholder="🔍 Tìm kiếm show...">
                    <button class="btn btn-primary" onclick="searchShow()">Tìm</button>
                </div>
                <a href="${pageContext.request.contextPath}/admin/show/add" class="btn btn-primary">
                    ➕ Thêm Show mới
                </a>
            </div>

            <!-- Table -->
            <div class="table-container">
                <c:choose>
                    <c:when test="${empty shows}">
                        <div class="empty-state">
                            <div class="empty-state-icon">📭</div>
                            <h3>Chưa có show nào</h3>
                            <p>Hãy thêm show đầu tiên của bạn!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Hình ảnh</th>
                                    <th>Tên Show</th>
                                    <th>Mô tả</th>
                                    <th>Thời lượng</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="show" items="${shows}">
                                    <tr>
                                        <td>#${show.showID}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty show.showImage}">
                                                    <img src="${pageContext.request.contextPath}/${show.showImage}" 
                                                         alt="${show.showName}" class="show-image">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="show-image">🎭</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><strong>${show.showName}</strong></td>
                                        <td>${show.description}</td>
                                        <td>${show.durationMinutes} phút</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${show.status == 'Active'}">
                                                    <span class="status-badge status-active">Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-inactive">Đã đóng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${show.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/admin/show/edit?id=${show.showID}" 
                                                   class="btn btn-warning btn-small">✏️ Sửa</a>
                                                <button onclick="deleteShow(${show.showID}, '${show.showName}')" 
                                                        class="btn btn-danger btn-small">🗑️ Xóa</button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>

    <script>
        // Tìm kiếm show
        function searchShow() {
            const keyword = document.getElementById('searchInput').value;
            window.location.href = '${pageContext.request.contextPath}/admin/show?search=' + encodeURIComponent(keyword);
        }

        // Enter để tìm kiếm
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchShow();
            }
        });

        // Xóa show
        function deleteShow(id, name) {
            if (confirm('Bạn có chắc muốn xóa show "' + name + '"?\nHành động này không thể hoàn tác!')) {
                window.location.href = '${pageContext.request.contextPath}/admin/show/delete?id=' + id;
            }
        }

        // Auto hide alerts sau 5 giây
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);
    </script>
</body>
</html>
