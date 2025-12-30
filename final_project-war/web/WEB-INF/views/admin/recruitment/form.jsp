<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="mypack.Recruitment"%>
<%
    Recruitment job = (Recruitment) request.getAttribute("job");
    boolean isEdit = (job != null && job.getJobID() != null);
    List<String> logos = (List<String>) request.getAttribute("logoImages");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= isEdit ? "Sửa job tuyển dụng" : "Thêm job tuyển dụng" %></title>
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
        
        .page-h{
            display:flex;
            gap:12px;
            align-items:center;
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
            padding: 24px;
            border-radius: 18px;
            background: rgba(255,255,255,.06);
            border: 1px solid var(--line);
            backdrop-filter: blur(10px);
        }

        .form-wrap{
            margin-top: 14px;
            padding: 28px;
            border-radius: 18px;
            background: rgba(255,255,255,.96);
            box-shadow: 0 22px 70px rgba(0,0,0,.35);
        }

        .form-wrap label{
            color: #0b1220;
            font-weight: 700;
            font-size: 14px;
            margin-bottom: 8px;
            display: block;
            letter-spacing: .2px;
        }

        .form-wrap input[type="text"],
        .form-wrap input[type="date"],
        .form-wrap textarea,
        .form-wrap select{
            width: 100%;
            padding: 12px 16px;
            border: 2px solid rgba(15,27,51,.15);
            border-radius: 12px;
            font-size: 14px;
            color: #0b1220;
            background: #ffffff;
            transition: all .2s;
            font-family: inherit;
        }

        .form-wrap input[type="text"]:focus,
        .form-wrap input[type="date"]:focus,
        .form-wrap textarea:focus,
        .form-wrap select:focus{
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(79,70,229,.1);
        }

        .form-wrap textarea{
            resize: vertical;
        }

        .form-group{
            margin-bottom: 20px;
        }

        .btn-submit{
            background: linear-gradient(135deg, var(--primary), #6366f1);
            color: white;
            border: none;
            padding: 14px 32px;
            border-radius: 12px;
            font-weight: 800;
            font-size: 15px;
            cursor: pointer;
            transition: all .3s;
            box-shadow: 0 12px 30px rgba(79,70,229,.35);
            letter-spacing: .3px;
        }

        .btn-submit:hover{
            transform: translateY(-2px);
            box-shadow: 0 16px 40px rgba(79,70,229,.45);
        }

        .btn-actions{
            display: flex;
            gap: 12px;
            margin-top: 28px;
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
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-light fw-bold" style="border-radius:14px;">
                        <i class="fa-solid fa-gauge"></i> Dashboard
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
                        <h1><%= isEdit ? "Sửa job tuyển dụng" : "Thêm job tuyển dụng" %></h1>
                        <div class="crumb">Admin / Recruitment / <%= isEdit ? "Edit" : "Create" %></div>
                    </div>
                </div>
            </div>

            <div class="form-wrap">
                <form method="post" action="<%= request.getContextPath() %>/admin/recruitment">
                    <input type="hidden" name="action" value="<%= isEdit ? "edit" : "create" %>"/>
                    <% if (isEdit) { %>
                        <input type="hidden" name="id" value="<%= job.getJobID() %>"/>
                    <% } %>
                    
                    <div class="form-group">
                        <label><i class="fa-solid fa-briefcase"></i> Tiêu đề</label>
                        <input type="text" name="title" value="<%= isEdit ? job.getTitle() : "" %>" required placeholder="Nhập tiêu đề công việc"/>
                    </div>

                    <div class="form-group">
                        <label><i class="fa-solid fa-file-lines"></i> Mô tả công việc</label>
                        <textarea name="description" rows="4" required placeholder="Nhập mô tả chi tiết về công việc"><%= isEdit ? job.getDescription() : "" %></textarea>
                    </div>

                    <div class="form-group">
                        <label><i class="fa-solid fa-list-check"></i> Yêu cầu</label>
                        <textarea name="requirement" rows="3" placeholder="Nhập yêu cầu cho ứng viên"><%= isEdit ? job.getRequirement() : "" %></textarea>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label><i class="fa-solid fa-location-dot"></i> Địa điểm</label>
                                <input type="text" name="location" value="<%= isEdit ? job.getLocation() : "" %>" placeholder="VD: Hà Nội, TP.HCM"/>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label><i class="fa-solid fa-money-bill-wave"></i> Mức lương</label>
                                <input type="text" name="salary" value="<%= isEdit ? job.getSalary() : "" %>" placeholder="VD: 10-15 triệu"/>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label><i class="fa-solid fa-calendar-days"></i> Hạn nộp hồ sơ</label>
                                <input type="date" name="deadline"
                                       value="<%= isEdit && job.getDeadline() != null ?
                                                new java.text.SimpleDateFormat("yyyy-MM-dd").format(job.getDeadline()) : "" %>"/>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label><i class="fa-solid fa-image"></i> Logo công việc</label>
                                <select name="logoUrl">
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
                        </div>
                    </div>

                    <div class="form-group">
                        <label><i class="fa-solid fa-toggle-on"></i> Trạng thái</label>
                        <select name="status">
                            <option value="Open" <%= isEdit && "Open".equalsIgnoreCase(job.getStatus()) ? "selected" : "" %>>Open</option>
                            <option value="Closed" <%= isEdit && "Closed".equalsIgnoreCase(job.getStatus()) ? "selected" : "" %>>Closed</option>
                        </select>
                    </div>

                    <div class="btn-actions">
                        <button type="submit" class="btn-submit">
                            <i class="fa-solid fa-<%= isEdit ? "floppy-disk" : "circle-plus" %>"></i>
                            <%= isEdit ? "Cập nhật" : "Thêm mới" %>
                        </button>
                        <a href="<%= request.getContextPath() %>/admin/recruitment?action=list" class="btn btn-outline-secondary" style="border-radius:12px; font-weight:700;">
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