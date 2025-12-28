<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="mypack.News"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
    News news = (News) request.getAttribute("news");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= news != null ? news.getTitle() : "Không tìm thấy bài viết" %> | BookingStage</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600&family=Playfair+Display:ital,wght@0,700;1,600&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --gold-primary: #d4af37;
            --text-main: #e0e0e0;
            --text-muted: #aaa;
            --bg-overlay: rgba(20, 20, 20, 0.95);
        }

        body {
            font-family: 'Montserrat', sans-serif;
            margin: 0;
            padding: 0;
            background: radial-gradient(circle at center, rgba(30,30,30,0.9) 0%, #000 100%),
                        url('<%= request.getContextPath() %>/asset/images/background-myticket.jpg') no-repeat center center fixed;
            background-size: cover;
            color: var(--text-main);
            min-height: 100vh;
        }

        /* Khung chứa bài viết */
        .article-container {
            max-width: 800px;
            margin: 40px auto;
            background: var(--bg-overlay);
            padding: 50px;
            border-radius: 8px;
            box-shadow: 0 0 50px rgba(0,0,0,0.8);
            border: 1px solid rgba(255,255,255,0.05);
        }

        /* Nút quay lại */
        .nav-top {
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .back-link {
            text-decoration: none;
            color: var(--gold-primary);
            font-weight: 500;
            transition: 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .back-link:hover {
            color: #fff;
            transform: translateX(-5px);
        }

        /* Phần Header bài viết */
        .article-header {
            margin-bottom: 30px;
            border-bottom: 1px solid rgba(212, 175, 55, 0.2);
            padding-bottom: 20px;
        }

        .article-title {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            color: #fff;
            margin: 0 0 15px 0;
            line-height: 1.3;
        }

        .article-meta {
            color: var(--text-muted);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .article-meta i {
            color: var(--gold-primary);
            margin-right: 5px;
        }

        /* Ảnh đại diện bài viết */
        .article-banner {
            width: 100%;
            height: auto;
            max-height: 450px;
            object-fit: cover;
            border-radius: 4px;
            margin-bottom: 30px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.5);
        }

        /* Nội dung chính */
        .article-content {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #ddd;
            text-align: justify;
            /* Giữ nguyên định dạng xuống dòng từ Database */
            white-space: pre-line; 
        }

        /* Chữ cái đầu to (Drop cap) */
        .article-content::first-letter {
            font-family: 'Playfair Display', serif;
            font-size: 3.5rem;
            float: left;
            line-height: 0.8;
            margin-right: 10px;
            color: var(--gold-primary);
        }
        
        .article-content strong {
            color: #fff;
            font-weight: 600;
        }

        /* Footer bài viết */
        .article-footer {
            margin-top: 50px;
            padding-top: 30px;
            border-top: 1px solid rgba(255,255,255,0.1);
            text-align: center;
        }

        .btn-home {
            display: inline-block;
            padding: 10px 25px;
            border: 1px solid var(--gold-primary);
            color: var(--gold-primary);
            text-decoration: none;
            border-radius: 30px;
            transition: 0.3s;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 1px;
        }

        .btn-home:hover {
            background: var(--gold-primary);
            color: #000;
        }

        /* Trạng thái không tìm thấy */
        .not-found {
            text-align: center;
            padding: 100px 20px;
        }
        .not-found h2 {
            font-family: 'Playfair Display', serif;
            color: #888;
            font-size: 2rem;
        }

        @media (max-width: 768px) {
            .article-container {
                padding: 25px;
                margin: 20px;
            }
            .article-title {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>

    <div class="article-container">
        <% if (news != null) { %>
            
            <div class="nav-top">
                <a href="<%= request.getContextPath() %>/new" class="back-link">
                    <i class="fa-solid fa-arrow-left-long"></i> Danh sách tin tức
                </a>
                <a href="<%= request.getContextPath() %>/" style="color: #666; text-decoration: none; font-size: 1.2rem;">
                    <i class="fa-solid fa-house"></i>
                </a>
            </div>

            <div class="article-header">
                <h1 class="article-title"><%= news.getTitle() %></h1>
                <div class="article-meta">
                    <span><i class="fa-regular fa-calendar-check"></i> 
                        <%= new SimpleDateFormat("dd 'tháng' MM, yyyy").format(news.getCreatedAt()) %>
                    </span>
                    <span><i class="fa-solid fa-feather-pointed"></i> BookingStage Admin</span>
                </div>
            </div>

            <% if (news.getThumbnailUrl() != null && !news.getThumbnailUrl().isEmpty()) { %>
                <img src="<%= request.getContextPath() + "/" + news.getThumbnailUrl() %>" 
                     alt="Banner" class="article-banner" />
            <% } %>

            <div class="article-content">
                <%= news.getContent() %>
            </div>

            <div class="article-footer">
                <p style="font-style: italic; color: #777; margin-bottom: 20px;">Cảm ơn bạn đã quan tâm theo dõi.</p>
                <a href="<%= request.getContextPath() %>/" class="btn-home">Về Trang Chủ</a>
            </div>

        <% } else { %>
            <div class="not-found">
                <i class="fa-regular fa-face-frown-open" style="font-size: 4rem; color: #444; margin-bottom: 20px;"></i>
                <h2>Rất tiếc, bài viết này không tồn tại.</h2>
                <p style="color: #777;">Có thể bài viết đã bị xóa hoặc đường dẫn không chính xác.</p>
                <a href="<%= request.getContextPath() %>/new" class="btn-home" style="margin-top: 20px;">Xem tin khác</a>
            </div>
        <% } %>
    </div>

</body>
</html>