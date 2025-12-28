<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mypack.Recruitment"%>
<%
    Recruitment job = (Recruitment) request.getAttribute("job");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết job tuyển dụng</title>
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

        .detail-wrap{
            margin-top: 14px;
            padding: 22px;
            border-radius: 18px;
            background: rgba(255,255,255,.96);
            box-shadow: 0 22px 70px rgba(0,0,0,.35);
            color: #0b1220;
        }

        .detail-row{
            padding: 16px;
            border-radius: 12px;
            background: rgba(0,0,0,.02);
            margin-bottom: 12px;
            border: 1px solid rgba(0,0,0,.06);
        }

        .detail-label{
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .detail-value{
            color: #374151;
            font-weight: 600;
            white-space: pre-line;
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
                        <i class="fa-solid fa-circle-info"></i>
                    </div>
                    <div>
                        <h1>Chi tiết job tuyển dụng</h1>
                        <div class="crumb">Admin / Recruitment / View</div>
                    </div>
                </div>
            </div>

            <% if (job != null) { %>
                <div class="detail-wrap">
                    <div class="detail-row">
                        <div class="detail-label">
                            <i class="fa-solid fa-heading"></i> Tiêu đề:
                        </div>
                        <div class="detail-value"><%= job.getTitle() %></div>
                    </div>

                    <div class="detail-row">
                        <div class="detail-label">
                            <i class="fa-solid fa-align-left"></i> Mô tả công việc:
                        </div>
                        <div class="detail-value"><%= job.getDescription() %></div>
                    </div>

                    <div class="detail-row">
                        <div class="detail-label">
                            <i class="fa-solid fa-list-check"></i> Yêu cầu:
                        </div>
                        <div class="detail-value"><%= job.getRequirement() %></div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="detail-row">
                                <div class="detail-label">
                                    <i class="fa-solid fa-location-dot"></i> Địa điểm:
                                </div>
                                <div class="detail-value"><%= job.getLocation() %></div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="detail-row">
                                <div class="detail-label">
                                    <i class="fa-solid fa-dollar-sign"></i> Mức lương:
                                </div>
                                <div class="detail-value"><%= job.getSalary() %></div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="detail-row">
                                <div class="detail-label">
                                    <i class="fa-solid fa-calendar"></i> Hạn nộp hồ sơ:
                                </div>
                                <div class="detail-value">
                                    <%= job.getDeadline() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(job.getDeadline()) : "-" %>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="detail-row">
                                <div class="detail-label">
                                    <i class="fa-solid fa-toggle-on"></i> Trạng thái:
                                </div>
                                <div class="detail-value"><%= job.getStatus() %></div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="detail-row">
                                <div class="detail-label">
                                    <i class="fa-solid fa-clock"></i> Ngày đăng:
                                </div>
                                <div class="detail-value">
                                    <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(job.getPostedAt()) %>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="detail-row">
                                <div class="detail-label">
                                    <i class="fa-solid fa-pen"></i> Ngày cập nhật:
                                </div>
                                <div class="detail-value">
                                    <%= job.getUpdatedAt() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(job.getUpdatedAt()) : "-" %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mt-4">
                        <a href="<%= request.getContextPath() %>/admin/recruitment?action=list" 
                           class="btn btn-outline-dark fw-bold px-4" style="border-radius:12px;">
                            <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                        </a>
                    </div>
                </div>
            <% } else { %>
                <div class="detail-wrap text-center py-5">
                    <i class="fa-regular fa-folder-open fa-3x text-muted"></i>
                    <div class="mt-3 fw-bold fs-5">Không tìm thấy job tuyển dụng.</div>
                    <div class="mt-3">
                        <a href="<%= request.getContextPath() %>/admin/recruitment?action=list" 
                           class="btn btn-outline-dark fw-bold px-4" style="border-radius:12px;">
                            <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                        </a>
                    </div>
                </div>
            <% } %>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>