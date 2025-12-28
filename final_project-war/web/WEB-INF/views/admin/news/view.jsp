<%-- 
    Document   : view
    Created on : Dec 24, 2025
    Author     : DANG KHOA
    Updated UI : Theater Admin Theme (Reader Mode)
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="mypack.News"%>
<%
    News news = (News) request.getAttribute("news");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= news != null ? news.getTitle() : "Chi tiết tin tức" %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <style>
        :root{ --bg:#0b1220; --panel:#0f1b33; --line:rgba(255,255,255,.08); }
        body{
            background: radial-gradient(1200px 700px at 20% -10%, rgba(79,70,229,.28), transparent 55%),
                        linear-gradient(180deg, var(--bg), #070b14);
            min-height:100vh; color:#e6ecff; font-family: system-ui, sans-serif;
            padding-bottom: 50px;
        }
        .view-container { max-width: 900px; margin: 40px auto; }
        .paper {
            background: #fff;
            color: #111827;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        }
        .paper img { max-width: 100%; height: auto; border-radius: 8px; }
        .news-meta { color: #6b7280; font-size: 0.9rem; border-bottom: 1px solid #e5e7eb; padding-bottom: 20px; margin-bottom: 25px; }
        .news-content { font-size: 1.1rem; line-height: 1.8; }
        .btn-back { border-radius: 50px; padding: 10px 24px; font-weight: bold; background: rgba(255,255,255,0.1); color: #fff; text-decoration: none; border: 1px solid var(--line); transition: .2s; }
        .btn-back:hover { background: rgba(255,255,255,0.2); color: #fff; }
    </style>
</head>
<body>
    <div class="container view-container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <a href="<%= request.getContextPath() %>/admin/news?action=list" class="btn-back">
                <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
            </a>
            <% if (news != null) { %>
            <div>
                <a href="<%= request.getContextPath() %>/admin/news?action=edit&id=<%= news.getNewsID() %>" class="btn btn-primary fw-bold rounded-pill">
                    <i class="fa-solid fa-pen"></i> Chỉnh sửa
                </a>
            </div>
            <% } %>
        </div>

        <% if (news != null) { %>
            <div class="paper">
                <h1 class="fw-bold mb-3 display-6"><%= news.getTitle() %></h1>
                
                <div class="news-meta d-flex gap-3 align-items-center">
                    <span><i class="fa-regular fa-calendar"></i> <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(news.getCreatedAt()) %></span>
                    <span>|</span>
                    <span class="badge bg-secondary"><%= news.getStatus() %></span>
                </div>

                <% if (news.getSummary() != null && !news.getSummary().isEmpty()) { %>
                    <div class="p-3 bg-light border-start border-4 border-info mb-4 fst-italic text-secondary">
                        <%= news.getSummary() %>
                    </div>
                <% } %>

                <div class="news-content">
                    <% if (news.getContent() != null) { 
                        out.print(news.getContent()); 
                    } %>
                </div>
            </div>
        <% } else { %>
            <div class="alert alert-danger text-center">
                <h3><i class="fa-solid fa-circle-exclamation"></i> Không tìm thấy tin tức</h3>
                <p>Tin tức bạn đang tìm không tồn tại hoặc đã bị xóa.</p>
            </div>
        <% } %>
    </div>
</body>
</html>