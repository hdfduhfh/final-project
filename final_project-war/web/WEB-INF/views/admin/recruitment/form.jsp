<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, mypack.Recruitment"%>
<%
    Recruitment job = (Recruitment) request.getAttribute("job");
    boolean isEdit = (job != null && job.getJobID() != null);
    List logos = (List) request.getAttribute("logoImages");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= isEdit ? "Sửa job tuyển dụng" : "Thêm job tuyển dụng"%></title>
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

        .form-wrap{
            margin-top: 14px;
            padding: 22px;
            border-radius: 18px;
            background: rgba(255,255,255,.96);
            box-shadow: 0 22px 70px rgba(0,0,0,.35);
            color: #0b1220;
        }

        .form-label{
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .form-control, .form-select{
            border-radius: 12px;
            border: 1px solid #d1d5db;
            padding: 10px 14px;
        }

        .form-control:focus, .form-select:focus{
            border-color: #4f46e5;
            box-shadow: 0 0 0 3px rgba(79,70,229,.1);
        }

        textarea.form-control{
            min-height: 120px;
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
                    <a class="btn btn-outline-light fw-bold" href="<%= request.getContextPath() %>/admin/recruitment?action=list" style="border-radius:14px;">
                        <i class="fa-solid fa-arrow-left"></i> Về danh sách
                    </a>
                </div>
            </div>
        </aside>

        <main class="content">
            <div class="topbar">
                <div class="page-h">
                    <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                        <i class="fa-solid fa-<%= isEdit ? "pen-to-square" : "circle-plus" %>"></i>
                    </div>
                    <div>
                        <h1><%= isEdit ? "Sửa job tuyển dụng" : "Thêm job tuyển dụng"%></h1>
                        <div class="crumb">Admin / Recruitment / <%= isEdit ? "Edit" : "Create"%></div>
                    </div>
                </div>
            </div>

            <div class="form-wrap">
                <form method="post" action="<%= request.getContextPath() %>/admin/recruitment">
                    <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>"/>
                    
                    <% if (isEdit) { %>
                        <input type="hidden" name="jobID" value="<%= job.getJobID() %>"/>
                    <% } %>

                    <div class="row g-3">
                        <div class="col-md-12">
                            <label class="form-label">
                                <i class="fa-solid fa-heading"></i> Tiêu đề
                            </label>
                            <input type="text" name="title" class="form-control" 
                                   value="<%= isEdit ? job.getTitle() : "" %>" required/>
                        </div>

                        <div class="col-md-12">
                            <label class="form-label">
                                <i class="fa-solid fa-align-left"></i> Mô tả công việc
                            </label>
                            <textarea name="description" class="form-control"><%= isEdit ? job.getDescription() : "" %></textarea>
                        </div>

                        <div class="col-md-12">
                            <label class="form-label">
                                <i class="fa-solid fa-list-check"></i> Yêu cầu
                            </label>
                            <textarea name="requirement" class="form-control"><%= isEdit ? job.getRequirement() : "" %></textarea>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">
                                <i class="fa-solid fa-location-dot"></i> Địa điểm
                            </label>
                            <input type="text" name="location" class="form-control" 
                                   value="<%= isEdit ? job.getLocation() : "" %>"/>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">
                                <i class="fa-solid fa-dollar-sign"></i> Mức lương
                            </label>
                            <input type="text" name="salary" class="form-control" 
                                   value="<%= isEdit ? job.getSalary() : "" %>" required/>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">
                                <i class="fa-solid fa-calendar"></i> Hạn nộp hồ sơ
                            </label>
                            <input type="date" name="deadline" class="form-control" 
                                   value="<%= isEdit && job.getDeadline() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(job.getDeadline()) : "" %>"/>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">
                                <i class="fa-solid fa-image"></i> Logo công việc
                            </label>
                            <select name="logoUrl" class="form-select">
                                <option value="">-- Chọn logo --</option>
                                <%
                                    if (logos != null) {
                                        for (String logo : logos) {
                                            boolean selected = (isEdit && job != null && logo.equals(job.getLogoUrl()));
                                %>
                                <option value="<%= logo %>" <%= selected ? "selected" : "" %>>
                                    <%= logo.substring(logo.lastIndexOf("/") + 1) %>
                                </option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">
                                <i class="fa-solid fa-toggle-on"></i> Trạng thái
                            </label>
                            <select name="status" class="form-select">
                                <option value="Open" <%= isEdit && "Open".equals(job.getStatus()) ? "selected" : "" %>>Open</option>
                                <option value="Closed" <%= isEdit && "Closed".equals(job.getStatus()) ? "selected" : "" %>>Closed</option>
                            </select>
                        </div>
                    </div>

                    <div class="mt-4 d-flex gap-2">
                        <button type="submit" class="btn btn-primary fw-bold px-4" style="border-radius:12px;">
                            <i class="fa-solid fa-<%= isEdit ? "check" : "plus" %>"></i>
                            <%= isEdit ? "Cập nhật" : "Thêm mới" %>
                        </button>
                        <a href="<%= request.getContextPath() %>/admin/recruitment?action=list" 
                           class="btn btn-outline-secondary fw-bold px-4" style="border-radius:12px;">
                            <i class="fa-solid fa-xmark"></i> Hủy
                        </a>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>