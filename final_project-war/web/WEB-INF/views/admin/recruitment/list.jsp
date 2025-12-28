<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, mypack.Recruitment"%>
<%
    List<Recruitment> jobList = (List<Recruitment>) request.getAttribute("jobList");
    int currentPage = (request.getAttribute("currentPage") != null)
            ? (Integer) request.getAttribute("currentPage") : 1;
    int totalPages = (request.getAttribute("totalPages") != null)
            ? (Integer) request.getAttribute("totalPages") : 1;

    String baseUrl = request.getContextPath() + "/admin/recruitment?action=list";
    String searchParam = request.getParameter("search") != null ? "&search=" + request.getParameter("search") : "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý tuyển dụng</title>
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

        .logo-img{
            width: 56px;
            height: 56px;
            object-fit: cover;
            border-radius: 12px;
            border: 2px solid rgba(245,158,11,.25);
            box-shadow: 0 12px 30px rgba(0,0,0,.15);
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
                <div class="logo"><i class="fa-solid fa-building"></i></div>
                <div>
                    <div class="title">Recruitment Admin</div>
                    <small>Quản lý tuyển dụng</small>
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
                    <a href="<%= request.getContextPath() %>/admin/recruitment?action=create" class="btn btn-light fw-bold" style="border-radius:14px;">
                        <i class="fa-solid fa-circle-plus"></i> Thêm job mới
                    </a>
                </div>
            </div>
        </aside>

        <main class="content">
            <div class="topbar">
                <div class="page-h">
                    <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                        <i class="fa-solid fa-briefcase"></i>
                    </div>
                    <div>
                        <h1>Danh sách tuyển dụng</h1>
                        <div class="crumb">Admin / Recruitment Management</div>
                    </div>
                </div>
            </div>

            <div class="panel">
                <form method="get" action="<%= request.getContextPath() %>/admin/recruitment">
                    <input type="hidden" name="action" value="list"/>
                    <div class="row g-2 align-items-center">
                        <div class="col-lg-8">
                            <div class="input-group">
                                <span class="input-group-text bg-white">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                </span>
                                <input type="text" name="search" placeholder="Nhập tiêu đề cần tìm"
                                       value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>"
                                       class="form-control">
                                <button type="submit" class="btn btn-warning fw-bold">Tìm</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <div class="table-wrap">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th style="width:60px;">#</th>
                                <th style="width:100px;">Logo</th>
                                <th>Tiêu đề</th>
                                <th>Địa điểm</th>
                                <th style="width:120px;">Trạng thái</th>
                                <th style="width:130px;">Ngày đăng</th>
                                <th style="width:130px;">Hạn nộp</th>
                                <th style="width:170px;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (jobList != null && !jobList.isEmpty()) {
                                int index = 1;
                                for (Recruitment j : jobList) {
                                    if (j.getIsDeleted()) continue;
                            %>
                            <tr>
                                <td class="fw-bold"><%= index++ %></td>
                                <td>
                                    <% if (j.getLogoUrl() != null && !j.getLogoUrl().isEmpty()) { %>
                                        <img class="logo-img" src="<%= request.getContextPath() + "/" + j.getLogoUrl() %>" alt="Logo"/>
                                    <% } else { %>
                                        <div class="logo-img d-flex align-items-center justify-content-center bg-light">
                                            <i class="fa-solid fa-image text-muted"></i>
                                        </div>
                                    <% } %>
                                </td>
                                <td class="fw-bold">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="fa-solid fa-briefcase text-primary"></i>
                                        <span><%= j.getTitle() %></span>
                                    </div>
                                </td>
                                <td><%= j.getLocation() %></td>
                                <td>
                                    <span class="badge badge-status text-bg-light border">
                                        <i class="fa-solid fa-tag"></i> <%= j.getStatus() %>
                                    </span>
                                </td>
                                <td><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(j.getPostedAt()) %></td>
                                <td><%= j.getDeadline() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(j.getDeadline()) : "-" %></td>
                                <td class="text-nowrap">
                                    <a href="<%= request.getContextPath() %>/admin/recruitment?action=view&id=<%= j.getJobID() %>" 
                                       class="btn btn-info btn-icon" title="Xem">
                                        <i class="fa-solid fa-circle-info"></i>
                                    </a>
                                    <a href="<%= request.getContextPath() %>/admin/recruitment?action=edit&id=<%= j.getJobID() %>" 
                                       class="btn btn-primary btn-icon" title="Sửa">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </a>
                                    <a href="<%= request.getContextPath() %>/admin/recruitment?action=delete&id=<%= j.getJobID() %>"
                                       class="btn btn-danger btn-icon" title="Xóa"
                                       onclick="return confirm('Bạn có chắc muốn xóa job này?');">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <% }} else { %>
                            <tr>
                                <td colspan="8" class="text-center py-5 text-secondary">
                                    <i class="fa-regular fa-folder-open fa-lg"></i>
                                    <div class="mt-2 fw-bold">Chưa có job nào.</div>
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
                                    <a class="page-link" href="<%= baseUrl %>&page=<%= currentPage - 1 %><%= searchParam %>">
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
                                    <a class="page-link" href="<%= baseUrl %>&page=<%= currentPage + 1 %><%= searchParam %>">
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