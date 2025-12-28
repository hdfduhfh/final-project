<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*, mypack.Recruitment"%>
<%
    List<Recruitment> jobList = (List<Recruitment>) request.getAttribute("jobList");
    int currentPage = (request.getAttribute("currentPage") != null)
            ? (Integer) request.getAttribute("currentPage") : 1;
    int totalPages = (request.getAttribute("totalPages") != null)
            ? (Integer) request.getAttribute("totalPages") : 1;
    
    String baseUrl = request.getContextPath() + "/job";
    String searchParam = request.getParameter("search") != null ? "&search=" + request.getParameter("search") : "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tuyển dụng | BookingStage</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700&family=Playfair+Display:ital,wght@0,600;1,600&display=swap" rel="stylesheet">

    <style>
        /* --- CONFIG --- */
        :root {
            --gold: #DFBD69;
            --gold-light: #FFE5A0; /* Màu vàng sáng hơn cho tiêu đề */
            --gold-gradient: linear-gradient(135deg, #DFBD69 0%, #B88A44 100%);
            --text-main: #ECECEC;
            --panel-bg: rgba(20, 20, 20, 0.6); 
        }

        body {
            font-family: 'Montserrat', sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            color: var(--text-main);
            overflow-x: hidden;

            /* --- BACKGROUND SETUP --- */
            background-color: #050505; 
            background-image: 
                /* Lớp phủ đen mờ dần xuống dưới để list job dễ đọc */
                linear-gradient(to bottom, rgba(0,0,0,0.2) 0%, rgba(0,0,0,0.9) 70%, #000 100%),
                url('<%= request.getContextPath() %>/assets/images/background-recruitment.jpg'); 

            background-size: cover;          
            background-position: center top; 
            background-attachment: fixed;    
            background-repeat: no-repeat;
        }
        
        /* --- NÚT VỀ TRANG CHỦ (Góc trái) --- */
        .btn-back-home {
            position: fixed; /* Cố định khi cuộn trang */
            top: 30px;
            left: 30px;
            z-index: 100;
            text-decoration: none;
            color: #ccc;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 10px 20px;
            border-radius: 30px;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
        }

        .btn-back-home:hover {
            background: rgba(223, 189, 105, 0.15);
            border-color: var(--gold);
            color: var(--gold);
            transform: translateX(5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 0 20px;
            position: relative;
            z-index: 2;
        }

        /* --- HERO SECTION --- */
        .header-section {
            text-align: center;
            /* Đẩy xuống thấp hơn chút để né luồng sáng gắt nhất, giúp chữ rõ hơn */
            padding: 140px 0 70px 0; 
        }
        
        .main-title {
            font-family: 'Playfair Display', serif;
            font-size: 56px; 
            margin: 0;
            letter-spacing: 3px;
            text-transform: uppercase;
            /* Gradient sáng hơn: Bắt đầu bằng trắng vàng nhạt */
            background: linear-gradient(to bottom, #FFF5D0 0%, #DFBD69 50%, #B88A44 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            /* Bóng đổ đậm hơn để tách nền */
            filter: drop-shadow(0 5px 15px rgba(0,0,0,0.8));
        }
        
        .sub-title {
            color: #ddd;
            font-size: 16px;
            margin-top: 15px;
            font-weight: 300;
            letter-spacing: 2px;
            text-shadow: 0 2px 5px rgba(0,0,0,0.8);
            opacity: 0.8;
        }

        /* --- SEARCH BAR --- */
        .search-container {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 50px;
            padding: 6px;
            display: flex;
            max-width: 600px;
            margin: 0 auto 60px auto;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            transition: all 0.3s;
        }

        .search-container:hover, .search-container:focus-within {
            border-color: var(--gold);
            box-shadow: 0 0 25px rgba(223, 189, 105, 0.25);
            background: rgba(0, 0, 0, 0.5);
        }

        .search-input {
            background: transparent;
            border: none;
            color: #fff;
            padding: 15px 25px;
            flex-grow: 1;
            font-size: 15px;
            font-family: inherit;
            outline: none;
        }

        .search-input::placeholder { color: #888; }

        .search-btn {
            background: var(--gold-gradient);
            color: #000;
            border: none;
            border-radius: 40px;
            padding: 0 35px;
            font-weight: 700;
            cursor: pointer;
            transition: transform 0.2s;
            font-family: inherit;
            text-transform: uppercase;
            font-size: 13px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }
        .search-btn:hover {
            transform: scale(1.05);
            filter: brightness(1.1);
        }

        /* --- JOB LIST --- */
        .job-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .job-card {
            background: var(--panel-bg);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            padding: 25px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: all 0.4s ease;
            text-decoration: none;
            position: relative;
            overflow: hidden;
        }

        .job-card:hover {
            transform: translateY(-5px);
            background: rgba(40, 40, 40, 0.8);
            border-color: var(--gold);
            box-shadow: 0 15px 40px rgba(0,0,0,0.6);
        }

        .job-content {
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .job-logo {
            width: 60px; height: 60px;
            border-radius: 12px;
            background: #fff;
            display: flex;
            align-items: center; justify-content: center;
            flex-shrink: 0;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            border: 2px solid transparent;
            transition: border-color 0.3s;
        }
        .job-card:hover .job-logo { border-color: var(--gold); }
        
        .job-logo img { max-width: 80%; max-height: 80%; object-fit: contain; }
        .job-logo-placeholder { font-size: 24px; }

        .job-info h3 {
            margin: 0 0 8px 0;
            font-size: 18px;
            color: #fff;
            font-weight: 600;
            transition: color 0.3s;
        }
        .job-card:hover .job-info h3 { color: var(--gold); }

        .job-meta {
            font-size: 13px;
            color: #bbb;
            display: flex;
            gap: 15px;
        }
        
        .job-action {
            width: 40px; height: 40px;
            border-radius: 50%;
            border: 1px solid rgba(255,255,255,0.1);
            display: flex;
            align-items: center; justify-content: center;
            color: #888;
            transition: all 0.3s;
        }
        .job-card:hover .job-action {
            background: var(--gold);
            color: #000;
            border-color: var(--gold);
        }

        /* --- PAGINATION --- */
        .pagination {
            margin-top: 60px;
            margin-bottom: 80px;
            display: flex;
            justify-content: center;
            gap: 10px;
        }

        .page-link {
            width: 40px; height: 40px;
            display: flex;
            align-items: center; justify-content: center;
            border-radius: 50%;
            text-decoration: none;
            color: #ccc;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            border: 1px solid rgba(255,255,255,0.1);
            background: rgba(255,255,255,0.02);
        }

        .page-link:hover {
            color: var(--gold);
            border-color: var(--gold);
            transform: scale(1.1);
            background: rgba(0,0,0,0.5);
        }

        .page-link.active {
            background: var(--gold-gradient);
            color: #000;
            border: none;
            font-weight: 700;
            box-shadow: 0 0 15px rgba(223, 189, 105, 0.4);
        }
        
        .empty-state {
            text-align: center;
            padding: 60px;
            color: #888;
            background: rgba(0,0,0,0.4);
            border-radius: 12px;
            border: 1px dashed rgba(255,255,255,0.1);
        }
        
        @media (max-width: 600px) {
            .btn-back-home { top: 20px; left: 15px; padding: 8px 15px; font-size: 12px; }
            .header-section { padding-top: 100px; }
            .main-title { font-size: 36px; }
            .job-card { flex-direction: column; align-items: flex-start; gap: 15px; }
            .job-action { display: none; }
            .search-container { width: 100%; }
        }
    </style>
</head>
<body>

    <a href="<%= request.getContextPath() %>/" class="btn-back-home">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                    <path fill-rule="evenodd" d="M12 8a.5.5 0 0 1-.5.5H5.707l2.147 2.146a.5.5 0 0 1-.708.708l-3-3a.5.5 0 0 1 0-.708l3-3a.5.5 0 1 1 .708.708L5.707 7.5H11.5a.5.5 0 0 1 .5.5z"/>
                </svg>
                Trang chủ
            </a>

    <div class="container">
        <div class="header-section">
            <h1 class="main-title">Tuyển Dụng</h1>
            <p class="sub-title">Cánh cửa bước vào thế giới nghệ thuật đỉnh cao</p>
        </div>

        <form method="get" action="<%= baseUrl %>" class="search-container">
            <input type="text" name="search" class="search-input" 
                   placeholder="Nhập vị trí bạn muốn ứng tuyển..."
                   value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" />
            <button type="submit" class="search-btn">Tìm Kiếm</button>
        </form>

        <div class="job-list">
            <% if (jobList != null && !jobList.isEmpty()) {
                for (Recruitment j : jobList) {
                    if (j.getIsDeleted()) continue;
            %>
                <a href="<%= request.getContextPath() %>/viewjob?id=<%= j.getJobID() %>" class="job-card">
                    <div class="job-content">
                        <div class="job-logo">
                            <% if (j.getLogoUrl() != null && !j.getLogoUrl().isEmpty()) { %>
                                <img src="<%= request.getContextPath() + "/" + j.getLogoUrl() %>" alt="Logo"/>
                            <% } else { %>
                                <span class="job-logo-placeholder">💼</span>
                            <% } %>
                        </div>
                        
                        <div class="job-info">
                            <h3><%= j.getTitle() %></h3>
                            <div class="job-meta">
                                <span>📍 <%= j.getLocation() %></span>
                                <span style="margin: 0 10px; opacity: 0.3;">|</span>
                                <span style="color: var(--gold);">💰 <%= j.getSalary() %></span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="job-action">➜</div>
                </a>
            <% }} else { %>
                <div class="empty-state">
                    <p>Hiện chưa có vị trí nào phù hợp với tìm kiếm của bạn.</p>
                </div>
            <% } %>
        </div>

        <% if (totalPages > 1) { %>
        <div class="pagination">
            <% if (currentPage > 1) { %>
                <a href="<%= baseUrl %>?page=<%= currentPage - 1 %><%= searchParam %>" class="page-link">❮</a>
            <% } %>

            <% for (int i = 1; i <= totalPages; i++) { %>
                <% if (i == currentPage) { %>
                    <span class="page-link active"><%= i %></span>
                <% } else { %>
                    <a href="<%= baseUrl %>?page=<%= i %><%= searchParam %>" class="page-link"><%= i %></a>
                <% } %>
            <% } %>

            <% if (currentPage < totalPages) { %>
                <a href="<%= baseUrl %>?page=<%= currentPage + 1 %><%= searchParam %>" class="page-link">❯</a>
            <% } %>
        </div>
        <% } %>
    </div>

</body>
</html>