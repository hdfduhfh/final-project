<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*, mypack.News"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
    // Lấy dữ liệu từ Servlet truyền sang
    List<News> latestNews = (List<News>) request.getAttribute("latestNews");
    int currentPage = request.getAttribute("currentPage") != null ? (Integer) request.getAttribute("currentPage") : 1;
    int totalPages = request.getAttribute("totalPages") != null ? (Integer) request.getAttribute("totalPages") : 1;
    String searchKeyword = request.getParameter("search") != null ? request.getParameter("search") : "";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tin Tức & Sự Kiện | BookingStage</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600&family=Playfair+Display:ital,wght@0,700;1,600&display=swap" rel="stylesheet">
    
    <style>
        /* --- CẤU HÌNH GIAO DIỆN CHUNG (THEME GOLD/BLACK) --- */
        :root {
            --gold-primary: #d4af37;
            --gold-gradient: linear-gradient(135deg, #d4af37 0%, #f9f295 50%, #d4af37 100%);
            --dark-bg: #111;
            --card-bg: rgba(30, 30, 30, 0.9);
            --text-main: #f0f0f0;
        }

        body {
            font-family: 'Montserrat', sans-serif;
            margin: 0;
            padding: 0;
            background: radial-gradient(circle at center, rgba(20,20,20,0.95) 0%, #000 100%),
                        url('<%= request.getContextPath() %>/asset/images/background-myticket.jpg') no-repeat center center fixed;
            background-size: cover;
            color: var(--text-main);
            min-height: 100vh;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        /* --- HEADER & SEARCH --- */
        .news-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 40px;
            border-bottom: 1px solid rgba(212, 175, 55, 0.3);
            padding-bottom: 20px;
            flex-wrap: wrap;
            gap: 20px;
        }

        .page-title {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            color: var(--gold-primary);
            margin: 0;
            text-shadow: 0 4px 10px rgba(0,0,0,0.5);
        }

        .search-box {
            position: relative;
            display: flex;
            align-items: center;
        }

        .search-input {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: #fff;
            padding: 10px 15px;
            border-radius: 30px;
            width: 250px;
            outline: none;
            transition: 0.3s;
            font-family: 'Montserrat', sans-serif;
        }

        .search-input:focus {
            border-color: var(--gold-primary);
            background: rgba(0, 0, 0, 0.5);
            box-shadow: 0 0 10px rgba(212, 175, 55, 0.2);
        }

        .search-btn {
            background: var(--gold-primary);
            border: none;
            color: #000;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            margin-left: -40px; /* Đè lên input */
            cursor: pointer;
            transition: 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .search-btn:hover {
            transform: scale(1.1);
            background: #fff;
        }

        /* --- GRID TIN TỨC --- */
        .news-grid {
            display: grid;
            /* Tự động chia cột: nhỏ nhất 260px, còn lại tự giãn */
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); 
            gap: 30px;
        }

        .news-card {
            background: var(--card-bg);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.4s ease;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            height: 100%; /* Để các card cao bằng nhau */
        }

        .news-card:hover {
            transform: translateY(-10px);
            border-color: var(--gold-primary);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        }

        .thumb-wrapper {
            width: 100%;
            height: 180px;
            overflow: hidden;
            position: relative;
        }

        .news-thumb {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .news-card:hover .news-thumb {
            transform: scale(1.1); /* Zoom ảnh khi hover */
        }

        .news-content {
            padding: 20px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }

        .news-date {
            font-size: 0.8rem;
            color: #999;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
        }
        
        .news-date i {
            color: var(--gold-primary);
            margin-right: 5px;
        }

        .news-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.2rem;
            font-weight: 700;
            line-height: 1.4;
            margin: 0;
            color: #fff;
            /* Giới hạn 3 dòng, thừa thì hiện ... */
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            transition: 0.3s;
        }

        .news-card:hover .news-title {
            color: var(--gold-primary);
        }
        
        /* Hiệu ứng gạch dưới cho tiêu đề khi hover */
        .read-more {
            margin-top: auto; /* Đẩy xuống đáy */
            padding-top: 15px;
            font-size: 0.85rem;
            color: var(--gold-primary);
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 1px;
            opacity: 0;
            transform: translateX(-10px);
            transition: all 0.3s ease;
        }
        
        .news-card:hover .read-more {
            opacity: 1;
            transform: translateX(0);
        }

        /* --- PHÂN TRANG & NÚT --- */
        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 50px;
        }

        .page-link {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            min-width: 40px;
            height: 40px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: #fff;
            text-decoration: none;
            border-radius: 50%; /* Hình tròn */
            transition: 0.3s;
            font-size: 0.9rem;
        }

        .page-link:hover {
            border-color: var(--gold-primary);
            color: var(--gold-primary);
        }

        .page-link.active {
            background: var(--gold-primary);
            color: #000;
            border-color: var(--gold-primary);
            font-weight: bold;
        }
        
        .empty-state {
            grid-column: 1 / -1; /* Chiếm hết chiều ngang */
            text-align: center;
            padding: 50px;
            color: #777;
        }

        .back-home {
            display: inline-block;
            margin-top: 30px;
            color: #aaa;
            text-decoration: none;
            transition: 0.3s;
        }
        .back-home:hover {
            color: var(--gold-primary);
        }

    </style>
</head>
<body>

    <div class="container">
        <div class="news-header">
            <h2 class="page-title">Tin Tức & Sự Kiện</h2>
            
            <form method="get" action="<%= request.getContextPath() %>/new" class="search-box">
                <input type="text" name="search" class="search-input" 
                       placeholder="Tìm kiếm tin tức..."
                       value="<%= searchKeyword %>">
                <button type="submit" class="search-btn">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </button>
            </form>
        </div>

        <div class="news-grid">
            <% if (latestNews != null && !latestNews.isEmpty()) { 
                for (News n : latestNews) { 
            %>
                <a href="<%= request.getContextPath() %>/new?id=<%= n.getNewsID() %>" class="news-card">
                    <div class="thumb-wrapper">
                        <% if (n.getThumbnailUrl() != null && !n.getThumbnailUrl().isEmpty()) { %>
                            <img src="<%= request.getContextPath() + "/" + n.getThumbnailUrl() %>" class="news-thumb" alt="thumbnail" />
                        <% } else { %>
                            <img src="https://via.placeholder.com/400x300/111/333?text=BookingStage" class="news-thumb" alt="no image" />
                        <% } %>
                    </div>
                    
                    <div class="news-content">
                        <div class="news-date">
                            <i class="fa-regular fa-calendar"></i>
                            <%= new SimpleDateFormat("dd/MM/yyyy").format(n.getCreatedAt()) %>
                        </div>
                        <h3 class="news-title"><%= n.getTitle() %></h3>
                        <div class="read-more">Xem chi tiết <i class="fa-solid fa-arrow-right"></i></div>
                    </div>
                </a>
            <%  } 
               } else { %>
                <div class="empty-state">
                    <i class="fa-regular fa-newspaper" style="font-size: 3rem; margin-bottom: 20px;"></i>
                    <p>Chưa có tin tức nào phù hợp.</p>
                </div>
            <% } %>
        </div>

        <% if (totalPages > 1) { %>
            <div class="pagination">
                <% if (currentPage > 1) { %>
                    <a href="<%= request.getContextPath() %>/new?page=<%= currentPage - 1 %>&search=<%= searchKeyword %>" class="page-link">
                        <i class="fa-solid fa-chevron-left"></i>
                    </a>
                <% } %>
                
                <% for (int i = 1; i <= totalPages; i++) { %>
                    <a href="<%= request.getContextPath() %>/new?page=<%= i %>&search=<%= searchKeyword %>" 
                       class="page-link <%= (i == currentPage) ? "active" : "" %>">
                        <%= i %>
                    </a>
                <% } %>
                
                <% if (currentPage < totalPages) { %>
                    <a href="<%= request.getContextPath() %>/new?page=<%= currentPage + 1 %>&search=<%= searchKeyword %>" class="page-link">
                        <i class="fa-solid fa-chevron-right"></i>
                    </a>
                <% } %>
            </div>
        <% } %>

        <div style="text-align: center; border-top: 1px solid rgba(255,255,255,0.1); margin-top: 40px; padding-top: 20px;">
            <a href="<%= request.getContextPath() %>/" class="back-home">
                <i class="fa-solid fa-arrow-left-long"></i> Về Trang Chủ
            </a>
        </div>
    </div>

</body>
</html>