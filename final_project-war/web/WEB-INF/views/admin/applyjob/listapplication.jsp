<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, mypack.Application" %>
<%
    List<Application> apps = (List<Application>) request.getAttribute("apps");
    String message = (String) request.getAttribute("message");
    String keyword = (String) request.getAttribute("keyword");
    int currentPage = (request.getAttribute("currentPage") != null) ? (Integer) request.getAttribute("currentPage") : 1;
    int totalPages = (request.getAttribute("totalPages") != null) ? (Integer) request.getAttribute("totalPages") : 1;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đơn ứng tuyển</title>
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
        <aside class="sidebar">
            <div class="brand">
                <div class="logo"><i class="fa-solid fa-briefcase"></i></div>
                <div>
                    <div class="title">Apply Job Admin</div>
                    <small>Quản lý ứng tuyển</small>
                </div>
            </div>

            <hr style="border-color: var(--line);">

            <div class="px-2">
                <div class="text-uppercase" style="font-size:12px; color:var(--muted); font-weight:900; letter-spacing:.3px;">
                    Quick actions
                </div>
                <div class="mt-2 d-grid gap-2">
                    <a class="btn btn-outline-light fw-bold" href="<%= request.getContextPath() %>/admin/dashboard" style="border-radius:14px;">
                        <i class="fa-solid fa-arrow-left"></i> Về Dashboard
                    </a>
                </div>
            </div>
        </aside>

        <main class="content">
            <div class="topbar">
                <div class="page-h">
                    <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                        <i class="fa-solid fa-file-lines"></i>
                    </div>
                    <div>
                        <h1>Danh sách đơn ứng tuyển</h1>
                        <div class="crumb">Admin / Apply Job Management</div>
                    </div>
                </div>
            </div>

            <% if (message != null && !message.isEmpty()) { %>
                <div class="alert alert-success mt-3 mb-0 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-circle-check"></i>
                    <div><%= message %></div>
                </div>
            <% } %>

            <div class="panel">
                <!-- Form tìm kiếm và lọc -->
<form method="get" action="<%= request.getContextPath() %>/admin/applyjob" style="margin-bottom: 16px;">
    <input type="text" name="keyword" value="<%= keyword != null ? keyword : "" %>" placeholder="Nhập tên hoặc SĐT"/>

    <!-- Lọc theo công việc (nhập tên) -->
    <input type="text" name="jobTitle" value="<%= request.getParameter("jobTitle") != null ? request.getParameter("jobTitle") : "" %>" 
           placeholder="Nhập tên công việc"/>

    <!-- Lọc theo trạng thái -->
    <select name="status">
        <option value="">-- Trạng thái --</option>
        <option value="Pending" <%= "Pending".equalsIgnoreCase(request.getParameter("status")) ? "selected" : "" %>>Pending</option>
        <option value="Accepted" <%= "Accepted".equalsIgnoreCase(request.getParameter("status")) ? "selected" : "" %>>Accepted</option>
        <option value="Rejected" <%= "Rejected".equalsIgnoreCase(request.getParameter("status")) ? "selected" : "" %>>Rejected</option>
    </select>

    <button type="submit">🔍 Lọc</button>
    <button type="button" onclick="window.location.href='<%= request.getContextPath() %>/admin/applyjob'" 
            style="margin-left:10px; background-color:#f44336; color:white; border:none; padding:6px 12px; cursor:pointer;">
        ❌ Hủy lọc
    </button>
</form>
            </div>

            <div class="table-wrap">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th style="width:60px;">#</th>
                                <th>Ứng viên</th>
                                <th>Email</th>
                                <th>SĐT</th>
                                <th>Công việc</th>
                                <th>CV</th>
                                <th>Ngày nộp</th>
                                <th>Trạng thái</th>
                                <th style="width:200px;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (apps != null && !apps.isEmpty()) {
                                int index = 1;
                                for (Application a : apps) {
                                    String statusClass = "text-bg-warning";
                                    if ("Accepted".equalsIgnoreCase(a.getStatus())) statusClass = "text-bg-success";
                                    else if ("Rejected".equalsIgnoreCase(a.getStatus())) statusClass = "text-bg-danger";
                            %>
                            <tr>
                                <td class="fw-bold"><%= index++ %></td>
                                <td class="fw-bold">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="fa-solid fa-user-tie text-primary"></i>
                                        <span><%= a.getFullName() %></span>
                                    </div>
                                </td>
                                <td><%= a.getEmail() %></td>
                                <td><%= a.getPhone() %></td>
                                <td><%= a.getJob() != null ? a.getJob().getTitle() : "-" %></td>
                                <td>
                                    <% String cvUrl = a.getCvUrl(); %>
                                    <% if (cvUrl != null && !cvUrl.isEmpty()) { %>
                                        <a href="<%= request.getContextPath() + "/" + cvUrl %>" target="_blank" class="btn btn-sm btn-outline-primary">
                                            <i class="fa-solid fa-file-pdf"></i> Xem
                                        </a>
                                    <% } else { %>
                                        <span class="text-muted">-</span>
                                    <% } %>
                                </td>
                                <td><%= a.getAppliedAt() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(a.getAppliedAt()) : "-" %></td>
                                <td>
                                    <span class="badge badge-status <%= statusClass %>">
                                        <i class="fa-solid fa-tag"></i> <%= a.getStatus() %>
                                    </span>
                                </td>
                                <td class="text-nowrap">
                                    <form method="post" action="<%= request.getContextPath() %>/admin/applyjob" style="display:inline;">
                                        <input type="hidden" name="id" value="<%= a.getId() %>"/>
                                        <input type="hidden" name="action" value="accept"/>
                                        <button type="submit" class="btn btn-success btn-icon" title="Chấp nhận">
                                            <i class="fa-solid fa-check"></i>
                                        </button>
                                    </form>
                                    <form method="post" action="<%= request.getContextPath() %>/admin/applyjob" style="display:inline;">
                                        <input type="hidden" name="id" value="<%= a.getId() %>"/>
                                        <input type="hidden" name="action" value="reject"/>
                                        <button type="submit" class="btn btn-warning btn-icon" title="Từ chối">
                                            <i class="fa-solid fa-xmark"></i>
                                        </button>
                                    </form>
                                    <form method="post" action="<%= request.getContextPath() %>/admin/applyjob" style="display:inline;"
                                          onsubmit="return confirm('Bạn có chắc muốn xóa đơn ứng tuyển này không?');">
                                        <input type="hidden" name="id" value="<%= a.getId() %>"/>
                                        <input type="hidden" name="action" value="delete"/>
                                        <button type="submit" class="btn btn-danger btn-icon" title="Xóa">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <% }} else { %>
                            <tr>
                                <td colspan="9" class="text-center py-5 text-secondary">
                                    <i class="fa-regular fa-folder-open fa-lg"></i>
                                    <div class="mt-2 fw-bold">Không có đơn ứng tuyển nào.</div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="mt-3">
                <% if (totalPages > 1) { %>
                    <nav aria-label="pagination">
                        <ul class="pagination justify-content-center mb-0">
                            <% if (currentPage > 1) { %>
                                <li class="page-item">
                                    <a class="page-link" href="<%= request.getContextPath() %>/admin/applyjob?page=<%= currentPage - 1 %><%= (keyword != null ? "&keyword=" + keyword : "") %>">
                                        <i class="fa-solid fa-arrow-left"></i> Trước
                                    </a>
                                </li>
                            <% } %>

                            <li class="page-item disabled">
                                <span class="page-link">
                                    Trang <b><%= currentPage %></b> / <b><%= totalPages %></b>
                                </span>
                            </li>

                            <% if (currentPage < totalPages) { %>
                                <li class="page-item">
                                    <a class="page-link" href="<%= request.getContextPath() %>/admin/applyjob?page=<%= currentPage + 1 %><%= (keyword != null ? "&keyword=" + keyword : "") %>">
                                        Sau <i class="fa-solid fa-arrow-right"></i>
                                    </a>
                                </li>
                            <% } %>
                        </ul>
                    </nav>
                <% } %>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>