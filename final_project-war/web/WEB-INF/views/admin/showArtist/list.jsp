<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Show - Nghệ sĩ</title>

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome 6 -->
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
                font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, "Noto Sans", "Helvetica Neue", sans-serif;
            }

            /* Layout */
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

            .nav-group{
                margin-top: 14px;
            }
            .nav-item{
                display:flex;
                align-items:center;
                gap:10px;
                padding: 10px 12px;
                border-radius: 12px;
                color:#dbe5ff;
                text-decoration:none;
                border: 1px solid transparent;
            }
            .nav-item:hover{
                background: rgba(255,255,255,.06);
                border-color: var(--line);
            }
            .nav-item.active{
                background: rgba(6,182,212,.16);
                border-color: rgba(6,182,212,.35);
            }
            .nav-item i{
                width:20px;
                text-align:center;
                color:#bcd0ff;
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

            /* “Vai trò” chip */
            .role-chip{
                display:inline-flex;
                align-items:center;
                gap:6px;
                padding: 6px 10px;
                border-radius: 999px;
                background: rgba(6,182,212,.10);
                border: 1px solid rgba(6,182,212,.22);
                color:#0b3b47;
                font-weight: 800;
                font-size: 12px;
            }

            /* empty state */
            .empty{
                padding: 48px 16px;
                text-align:center;
                color:#6b7280;
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

            <!-- SIDEBAR (giống theme trước) -->
            <aside class="sidebar">
                <div class="brand">
                    <div class="logo"><i class="fa-solid fa-masks-theater"></i></div>
                    <div>
                        <div class="title">Theater Admin</div>
                        <small>Quản lý Show - Nghệ sĩ</small>
                    </div>
                </div>

                <div class="nav-group">
                    <a class="nav-item active" href="${pageContext.request.contextPath}/admin/showArtist">
                        <i class="fa-solid fa-people-group"></i> Quản lý nghệ sĩ
                    </a>
                </div>

                <hr style="border-color: var(--line);">

                <div class="px-2">
                    <div class="text-uppercase" style="font-size:12px; color:var(--muted); font-weight:900; letter-spacing:.3px;">
                        Quick actions
                    </div>
                    <div class="mt-2 d-grid gap-2">
                        <a class="btn btn-outline-light fw-bold" href="${pageContext.request.contextPath}/admin/show" style="border-radius:14px;">
                            <i class="fa-solid fa-arrow-left"></i> Quay về Show
                        </a>
                    </div>
                </div>
            </aside>

            <!-- CONTENT -->
            <main class="content">

                <!-- TOPBAR -->
                <div class="topbar">
                    <div class="page-h">
                        <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                            <i class="fa-solid fa-people-group"></i>
                        </div>
                        <div>
                            <h1>Danh sách nghệ sĩ tham gia các show</h1>
                            <div class="crumb">Admin / ShowArtist Management</div>
                        </div>
                    </div>
                </div>

                <!-- Alerts -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success mt-3 mb-0 d-flex align-items-center gap-2">
                        <i class="fa-solid fa-circle-check"></i>
                        <div>${param.success}</div>
                    </div>
                </c:if>
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger mt-3 mb-0 d-flex align-items-center gap-2">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        <div>${param.error}</div>
                    </div>
                </c:if>

                <!-- Table -->
                <div class="table-wrap">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Show</th>
                                    <th>Nghệ sĩ</th>
                                    <th>Vai trò</th>
                                    <th style="width:160px;">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="sa" items="${links}">
                                    <tr>
                                        <td class="fw-bold">
                                            <i class="fa-solid fa-clapperboard text-primary"></i>
                                            ${sa.showID.showName}
                                        </td>
                                        <td class="fw-bold">
                                            <i class="fa-solid fa-user text-secondary"></i>
                                            ${sa.artistID.name}
                                        </td>
                                        <td>
                                            <span class="role-chip">
                                                <i class="fa-solid fa-id-badge"></i>
                                                ${sa.artistID.role}
                                            </span>
                                        </td>
                                        <td class="text-nowrap">
                                            <a class="btn btn-danger btn-sm fw-bold"
                                               href="${pageContext.request.contextPath}/admin/showArtist/delete?showId=${sa.showID.showID}&artistId=${sa.artistID.artistID}"
                                               onclick="return confirm('Xóa nghệ sĩ này khỏi show này?');">
                                                <i class="fa-solid fa-user-xmark"></i> Xóa
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty links}">
                                    <tr>
                                        <td colspan="4" class="empty">
                                            <i class="fa-regular fa-folder-open fa-2x"></i>
                                            <div class="mt-2 fw-bold">Chưa có nghệ sĩ nào được gán vào show.</div>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

            </main>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
