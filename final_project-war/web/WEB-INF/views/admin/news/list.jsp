<%-- 
    Document   : list
    Created on : Dec 24, 2025
    Author     : DANG KHOA
    Updated UI : Based on Theater Admin Theme
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*, mypack.News"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%
    List<News> newsList = (List<News>) request.getAttribute("newsList");
    int currentPage = request.getAttribute("currentPage") != null ? (Integer) request.getAttribute("currentPage") : 1;
    int totalPages = request.getAttribute("totalPages") != null ? (Integer) request.getAttribute("totalPages") : 1;
    String search = request.getParameter("search") != null ? request.getParameter("search") : "";
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý tin tức</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <style>
        :root{ --bg:#0b1220; --panel:#0f1b33; --muted:#8ea0c4; --line:rgba(255,255,255,.08); }
        body{
            background: radial-gradient(1200px 700px at 20% -10%, rgba(79,70,229,.28), transparent 55%),
                        radial-gradient(900px 500px at 80% 0%, rgba(6,182,212,.22), transparent 60%),
                        linear-gradient(180deg, var(--bg), #070b14);
            min-height:100vh; color:#e6ecff; font-family: system-ui, sans-serif;
        }
        .admin-wrap{ display:flex; min-height:100vh; }
        .sidebar{ width: 270px; background: rgba(15,27,51,.86); border-right: 1px solid var(--line); backdrop-filter: blur(10px); padding: 18px 14px; position: sticky; top:0; height:100vh; }
        .brand{ display:flex; align-items:center; gap:10px; padding:10px 12px; border-radius:14px; background: rgba(255,255,255,.06); border: 1px solid var(--line); }
        .brand .logo{ width: 38px; height: 38px; border-radius: 12px; display:grid; place-items:center; background: linear-gradient(135deg, rgba(79,70,229,.9), rgba(6,182,212,.9)); box-shadow: 0 14px 35px rgba(0,0,0,.35); }
        .brand .title{ line-height: 1.1; font-weight: 800; letter-spacing: .2px; }
        .content{ flex:1; padding: 22px 22px 28px; }
        .topbar{ display:flex; gap:12px; align-items:center; justify-content:space-between; padding: 14px 16px; border-radius: 18px; background: rgba(255,255,255,.06); border: 1px solid var(--line); backdrop-filter: blur(10px); box-shadow: 0 18px 55px rgba(0,0,0,.35); }
        .page-h h1{ font-size: 18px; margin:0; font-weight: 900; }
        .page-h .crumb{ color: var(--muted); font-weight: 600; font-size: 12px; }
        .panel{ margin-top: 14px; padding: 14px; border-radius: 18px; background: rgba(255,255,255,.06); border: 1px solid var(--line); backdrop-filter: blur(10px); }
        .table-wrap{ margin-top: 12px; border-radius: 18px; overflow: hidden; background: rgba(255,255,255,.96); box-shadow: 0 22px 70px rgba(0,0,0,.35); }
        table thead th{ background: #0f1b33 !important; color: #e8efff !important; border: none !important; white-space: nowrap; font-size: 13px; }
        table tbody td{ color: #0b1220; vertical-align: middle; }
        .thumb{ width: 60px; height: 45px; border-radius: 8px; object-fit: cover; border: 1px solid #ddd; }
        .btn-icon{ width: 36px; height: 36px; display:inline-grid; place-items:center; border-radius: 12px; }
        @media (max-width: 992px){ .sidebar{ display:none; } }
     /* ===============================
   FILTER BAR - NEWS (SYNC STYLE)
   =============================== */
.panel form {
    background: rgba(255,255,255,0.95);
    padding: 14px;
    border-radius: 14px;
    box-shadow: 0 12px 35px rgba(0,0,0,.18);
}

/* Input + Select */
.panel form input[type="text"],
.panel form input[type="date"],
.panel form select {
    background: #ffffff !important;
    color: #0b1220 !important;
    border: 1px solid #d1d5db !important;
    border-radius: 10px;
    padding: 8px 12px;
    font-weight: 500;
}

/* Placeholder */
.panel form input::placeholder {
    color: #9ca3af;
}

/* Focus effect */
.panel form input:focus,
.panel form select:focus {
    border-color: #4f46e5;
    box-shadow: 0 0 0 3px rgba(79,70,229,.25);
    outline: none;
}

/* Nút LỌC */
.panel form button[type="submit"] {
    background: #2563eb;
    color: #fff;
    font-weight: 600;
    border-radius: 10px;
    padding: 7px 14px;
    border: none;
}

.panel form button[type="submit"]:hover {
    background: #1d4ed8;
}

/* Nút HỦY */
.panel form button[type="button"] {
    background: #ef4444;
    color: #fff;
    border-radius: 10px;
    padding: 7px 14px;
    border: none;
}

.panel form button[type="button"]:hover {
    background: #dc2626;
}

    </style>
</head>
<body>
    <div class="admin-wrap">
        <aside class="sidebar">
            <div class="brand">
                <div class="logo"><i class="fa-solid fa-newspaper"></i></div>
                <div><div class="title">News Admin</div><small>Quản lý tin tức</small></div>
            </div>
            <hr style="border-color: var(--line);">
            <div class="px-2">
                <div class="mt-2 d-grid gap-2">
                    <a class="btn btn-outline-light fw-bold" href="<%= request.getContextPath() %>/admin/dashboard" style="border-radius:14px;">
                        <i class="fa-solid fa-arrow-left"></i> Dashboard
                    </a>
                    <a class="btn btn-light fw-bold" href="<%= request.getContextPath() %>/admin/news?action=create" style="border-radius:14px;">
                        <i class="fa-solid fa-pen-nib"></i> Viết tin mới
                    </a>
                </div>
            </div>
        </aside>

        <main class="content">
            <div class="topbar">
                <div class="d-flex align-items-center gap-3">
                    <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                        <i class="fa-solid fa-list-ul"></i>
                    </div>
                    <div class="page-h">
                        <div>
                            <h1>Danh sách tin tức</h1>
                            <div class="crumb">Admin / News / List</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="panel">
                <div class="row g-2 align-items-center">
                    <div class="col-lg-8">
                        <form method="get" action="<%= request.getContextPath() %>/admin/news" style="margin-bottom: 16px;">
    <input type="hidden" name="action" value="list"/>
    <input type="text" name="search" placeholder="Nhập tiêu đề cần tìm"
           value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>"
           style="padding:6px; width:250px;"/>

    <!-- Lọc theo trạng thái -->
    <select name="status" style="padding:6px;">
        <option value="">-- Trạng thái --</option>
        <option value="Draft" <%= "Draft".equalsIgnoreCase(request.getParameter("status")) ? "selected" : "" %>>Draft</option>
        <option value="Published" <%= "Published".equalsIgnoreCase(request.getParameter("status")) ? "selected" : "" %>>Published</option>
        <option value="Archived" <%= "Archived".equalsIgnoreCase(request.getParameter("status")) ? "selected" : "" %>>Archived</option>
    </select>

    <!-- Lọc theo ngày tạo (chỉ một ngày) -->
    Ngày tạo: 
    <input type="date" name="createdDate"
           value="<%= request.getParameter("createdDate") != null ? request.getParameter("createdDate") : "" %>"/>

    <button type="submit">🔍 Lọc</button>
    <button type="button" onclick="window.location.href='<%= request.getContextPath() %>/admin/news?action=list'" 
            style="margin-left:10px; background-color:#f44336; color:white; border:none; padding:6px 12px; cursor:pointer;">
        ❌ Hủy lọc
    </button>
</form>
                    </div>
                    <div class="col-lg-4 text-lg-end text-white-50 fw-bold">
                        Trang <%= currentPage %> / <%= totalPages %>
                    </div>
                </div>
            </div>

            <div class="table-wrap">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Thumbnail</th>
                                <th>Tiêu đề</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th style="width:180px;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (newsList != null && !newsList.isEmpty()) {
                                for (News n : newsList) {
                                    if (n.isIsDeleted()) continue;
                            %>
                            <tr>
                                <td>
                                    <% if (n.getThumbnailUrl() != null && !n.getThumbnailUrl().isEmpty()) { %>
                                        <img class="thumb" src="<%= request.getContextPath() + "/" + n.getThumbnailUrl() %>" alt="thumb"/>
                                    <% } else { %>
                                        <div class="thumb d-grid place-items-center bg-light text-muted" style="place-items:center;"><i class="fa-regular fa-image"></i></div>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="fw-bold"><%= n.getTitle() %></div>
                                    <small class="text-muted">ID: <%= n.getNewsID() %></small>
                                </td>
                                <td>
                                    <% 
                                    String statusClass = "bg-secondary";
                                    if("Published".equalsIgnoreCase(n.getStatus())) statusClass = "bg-success";
                                    else if("Draft".equalsIgnoreCase(n.getStatus())) statusClass = "bg-warning text-dark";
                                    %>
                                    <span class="badge <%= statusClass %> rounded-pill"><%= n.getStatus() %></span>
                                </td>
                                <td><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(n.getCreatedAt()) %></td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/admin/news?action=view&id=<%= n.getNewsID() %>" class="btn btn-info btn-icon text-white" title="Xem"><i class="fa-solid fa-eye"></i></a>
                                    <a href="<%= request.getContextPath() %>/admin/news?action=edit&id=<%= n.getNewsID() %>" class="btn btn-primary btn-icon" title="Sửa"><i class="fa-solid fa-pen-to-square"></i></a>
                                    <button type="button" class="btn btn-danger btn-icon" title="Xóa"
                                            onclick="openDeleteModal('<%= request.getContextPath() %>/admin/news?action=delete&id=<%= n.getNewsID() %>', '<%= n.getTitle() %>')">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                            <% }} else { %>
                            <tr><td colspan="5" class="text-center py-4 fw-bold text-muted">Chưa có tin tức nào.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <% if (totalPages > 1) { %>
            <div class="mt-3">
                <nav>
                    <ul class="pagination justify-content-center">
                        <% if (currentPage > 1) { %>
                            <li class="page-item"><a class="page-link" href="<%= request.getContextPath() %>/admin/news?action=list&page=<%= currentPage - 1 %>&search=<%= search %>">«</a></li>
                        <% } %>
                        <% for (int i = 1; i <= totalPages; i++) { %>
                            <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                                <a class="page-link" href="<%= request.getContextPath() %>/admin/news?action=list&page=<%= i %>&search=<%= search %>"><%= i %></a>
                            </li>
                        <% } %>
                        <% if (currentPage < totalPages) { %>
                            <li class="page-item"><a class="page-link" href="<%= request.getContextPath() %>/admin/news?action=list&page=<%= currentPage + 1 %>&search=<%= search %>">»</a></li>
                        <% } %>
                    </ul>
                </nav>
            </div>
            <% } %>
        </main>
    </div>

    <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius:18px; overflow:hidden;">
                <div class="modal-header" style="background:#0f1b33; color:#e8efff; border:none;">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-triangle-exclamation text-warning"></i> Xác nhận xóa</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-dark">
                    <div class="fw-bold mb-1">Bạn có chắc muốn xóa tin tức này?</div>
                    <div class="text-secondary" id="deleteTitle"></div>
                </div>
                <div class="modal-footer" style="border:none;">
                    <button type="button" class="btn btn-outline-dark fw-bold" data-bs-dismiss="modal">Hủy</button>
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger fw-bold">Xóa</a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openDeleteModal(url, title) {
            document.getElementById('deleteTitle').textContent = title;
            document.getElementById('confirmDeleteBtn').href = url;
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }
        // Script clear search input (như mẫu)
        (function () {
            const input = document.getElementById('keywordInput');
            if (!input) return;
            const group = input.closest('.input-group');
            const clearBtn = document.createElement('button');
            clearBtn.type = 'button';
            clearBtn.className = 'btn btn-outline-secondary';
            clearBtn.style.display = 'none';
            clearBtn.innerHTML = '<i class="fa-solid fa-xmark"></i>';
            const submitBtn = group.querySelector('button[type="submit"]');
            group.insertBefore(clearBtn, submitBtn);
            function toggle() { clearBtn.style.display = input.value.trim().length ? '' : 'none'; }
            clearBtn.addEventListener('click', function () { input.value = ''; toggle(); input.focus(); });
            input.addEventListener('input', toggle);
            toggle();
        })();
    </script>
</body>
</html>