<%-- 
    Document   : form
    Created on : Dec 24, 2025
    Author     : DANG KHOA
    Updated UI : Theater Admin Theme
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*, mypack.News"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Form tin tức</title>
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
        .content{ flex:1; padding: 22px; }
        .brand{ display:flex; align-items:center; gap:10px; padding:10px 12px; border-radius:14px; background: rgba(255,255,255,.06); border: 1px solid var(--line); }
        .brand .logo{ width: 38px; height: 38px; border-radius: 12px; display:grid; place-items:center; background: linear-gradient(135deg, rgba(79,70,229,.9), rgba(6,182,212,.9)); box-shadow: 0 14px 35px rgba(0,0,0,.35); }
        .topbar{ display:flex; justify-content:space-between; align-items:center; padding: 14px 16px; border-radius: 18px; background: rgba(255,255,255,.06); border: 1px solid var(--line); backdrop-filter: blur(10px); box-shadow: 0 18px 55px rgba(0,0,0,.35); margin-bottom: 20px; }
        .panel{ padding: 24px; border-radius: 18px; background: rgba(255,255,255,.06); border: 1px solid var(--line); backdrop-filter: blur(10px); }
        
        /* Custom form styles */
        .form-label { font-weight: 600; color: #bcd0ff; margin-bottom: 8px; }
        .form-control, .form-select { background: rgba(15, 27, 51, 0.6); border: 1px solid var(--line); color: #fff; border-radius: 10px; padding: 10px 14px; }
        .form-control:focus, .form-select:focus { background: rgba(15, 27, 51, 0.9); border-color: rgba(6,182,212,.5); box-shadow: 0 0 0 4px rgba(6,182,212,.15); color: #fff; }
        
        /* Image Picker Grid */
        .img-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(100px, 1fr)); gap: 10px; max-height: 250px; overflow-y: auto; padding: 10px; background: rgba(0,0,0,0.2); border-radius: 12px; }
        .img-option { border: 2px solid transparent; border-radius: 8px; overflow: hidden; cursor: pointer; transition: all 0.2s; position: relative; }
        .img-option:hover { transform: translateY(-3px); border-color: rgba(6,182,212,.5); }
        .img-option img { width: 100%; height: 80px; object-fit: cover; display: block; }
        .img-name { font-size: 10px; text-align: center; background: #000; padding: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        
        @media (max-width: 992px){ .sidebar{ display:none; } }
    </style>
</head>
<body>
<%
    News news = (News) request.getAttribute("news");
    boolean isEdit = news != null && news.getNewsID() != null;
    String actionUrl = isEdit
        ? (request.getContextPath() + "/admin/news?action=edit&id=" + news.getNewsID())
        : (request.getContextPath() + "/admin/news?action=create");

    List<String> assetImages = (List<String>) request.getAttribute("assetImages");
    String currentThumb = (news != null && news.getThumbnailUrl() != null) ? news.getThumbnailUrl() : null;
%>

<div class="admin-wrap">
    <aside class="sidebar">
        <div class="brand">
            <div class="logo"><i class="fa-solid fa-newspaper"></i></div>
            <div><div class="title">News Admin</div></div>
        </div>
        <hr style="border-color: var(--line);">
        <div class="px-2">
             <a class="btn btn-outline-light fw-bold w-100" href="<%= request.getContextPath() %>/admin/news?action=list" style="border-radius:14px;">
                <i class="fa-solid fa-arrow-left"></i> Quay lại DS
            </a>
        </div>
    </aside>

    <main class="content">
        <div class="topbar">
            <div>
                <h1 class="m-0 fw-bold fs-5"><%= isEdit ? "Chỉnh sửa tin tức" : "Thêm tin tức mới" %></h1>
            </div>
            <% if(isEdit) { %>
                <span class="badge bg-warning text-dark"><i class="fa-solid fa-pen"></i> Editing Mode</span>
            <% } else { %>
                <span class="badge bg-success"><i class="fa-solid fa-plus"></i> Creation Mode</span>
            <% } %>
        </div>

        <form method="post" action="<%= actionUrl %>">
            <div class="row">
                <div class="col-lg-8">
                    <div class="panel mb-3">
                        <div class="mb-3">
                            <label class="form-label">Tiêu đề</label>
                            <input type="text" name="title" class="form-control fw-bold" required
                                   value="<%= news!=null?news.getTitle():"" %>" placeholder="Nhập tiêu đề tin tức...">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Tóm tắt</label>
                            <textarea name="summary" class="form-control" rows="3" placeholder="Mô tả ngắn..."><%= news!=null?news.getSummary():"" %></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Nội dung chi tiết</label>
                            <div class="mb-2">
                                <button type="button" class="btn btn-sm btn-outline-info" onclick="toggleContentImageList()">
                                    <i class="fa-regular fa-image"></i> Chèn ảnh từ thư viện
                                </button>
                                <div id="contentImageList" style="display:none; margin-top:10px;">
                                    <div class="img-grid">
                                        <% if (assetImages != null) {
                                            for (String path : assetImages) {
                                                String url = request.getContextPath() + "/" + path;
                                        %>
                                        <div class="img-option" onclick="insertImageToEditor('<%= url %>')">
                                            <img src="<%= url %>" />
                                            <div class="img-name"><%= path.substring(path.lastIndexOf('/') + 1) %></div>
                                        </div>
                                        <% }} %>
                                    </div>
                                </div>
                            </div>
                            
                            <div style="color: #000;">
                                <textarea name="content" id="editor" rows="12"><%= news!=null?news.getContent():"" %></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="panel mb-3">
                        <h5 class="fw-bold mb-3 border-bottom pb-2" style="border-color:var(--line)!important;">Cài đặt</h5>
                        
                        <div class="mb-3">
                            <label class="form-label">Trạng thái</label>
                            <select name="status" class="form-select">
                                <option value="Draft" <%= (news!=null && "Draft".equalsIgnoreCase(news.getStatus()))?"selected":"" %>>Draft (Nháp)</option>
                                <option value="Published" <%= (news!=null && "Published".equalsIgnoreCase(news.getStatus()))?"selected":"" %>>Published (Công khai)</option>
                                <option value="Archived" <%= (news!=null && "Archived".equalsIgnoreCase(news.getStatus()))?"selected":"" %>>Archived (Lưu trữ)</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Slug (URL)</label>
                            <input type="text" name="slug" class="form-control form-control-sm" value="<%= news!=null?news.getSlug():"" %>" placeholder="tu-dong-tao-neu-trong">
                        </div>
                    </div>

                    <div class="panel">
                        <label class="form-label">Ảnh đại diện (Thumbnail)</label>
                        <input type="hidden" name="thumbnailPath" id="thumbnailPath" value="<%= currentThumb != null ? currentThumb : "" %>"/>
                        
                        <div id="selectedPreview" class="mb-2 text-center p-2 rounded" style="background:rgba(0,0,0,0.3); min-height:100px; display:grid; place-items:center;">
                            <% if (currentThumb != null) { %>
                                <img src="<%= request.getContextPath() + "/" + currentThumb %>" style="max-width:100%; max-height:150px; border-radius:8px;"/>
                            <% } else { %>
                                <span class="text-muted small">Chưa chọn ảnh</span>
                            <% } %>
                        </div>

                        <button type="button" class="btn btn-outline-light w-100 mb-2" onclick="toggleImageList()">
                            <i class="fa-regular fa-images"></i> Chọn từ thư viện
                        </button>

                        <div id="imageList" style="display:none;">
                            <div class="img-grid">
                                <% if (assetImages != null) {
                                    for (String path : assetImages) {
                                        String fileName = path.substring(path.lastIndexOf('/') + 1);
                                %>
                                <div class="img-option" onclick="selectImage('<%= path %>', '<%= request.getContextPath() + "/" + path %>')">
                                    <img src="<%= request.getContextPath() + "/" + path %>"/>
                                    <div class="img-name"><%= fileName %></div>
                                </div>
                                <% }} %>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mt-4 d-grid gap-2">
                        <button type="submit" class="btn btn-primary fw-bold py-2" style="border-radius:12px;">
                            <i class="fa-solid fa-floppy-disk"></i> <%= isEdit ? "Cập nhật tin tức" : "Lưu tin tức mới" %>
                        </button>
                        <a href="<%= request.getContextPath() %>/admin/news?action=list" class="btn btn-outline-secondary fw-bold" style="border-radius:12px;">Hủy bỏ</a>
                    </div>
                </div>
            </div>
        </form>
    </main>
</div>

<script src="<%= request.getContextPath() %>/assets/ckeditor/ckeditor.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        CKEDITOR.replace('editor', { height: 400 });
    });

    function toggleImageList() {
        const list = document.getElementById("imageList");
        list.style.display = (list.style.display === "none" || list.style.display === "") ? "block" : "none";
    }
    function selectImage(path, url) {
        document.getElementById("thumbnailPath").value = path;
        document.getElementById("selectedPreview").innerHTML = '<img src="' + url + '" style="max-width:100%; max-height:150px; border-radius:8px;"/>';
        document.getElementById("imageList").style.display = "none";
    }

    function toggleContentImageList() {
        const list = document.getElementById("contentImageList");
        list.style.display = (list.style.display === "none" || list.style.display === "") ? "block" : "none";
    }
    function insertImageToEditor(url) {
        CKEDITOR.instances['editor'].insertHtml('<img src="' + url + '" style="max-width:100%; display:block; margin: 10px auto;"/>');
        document.getElementById("contentImageList").style.display = "none";
    }
</script>
</body>
</html>