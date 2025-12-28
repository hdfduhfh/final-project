<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="mypack.Recruitment"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    Recruitment job = (Recruitment) request.getAttribute("job");
    String applied = request.getParameter("applied");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết công việc | BookingStage</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@300;400;500;600&family=Playfair+Display:ital,wght@0,500;0,600;0,700;1,500&display=swap" rel="stylesheet">

    <style>
        /* --- CONFIG LUXURY (Đồng bộ với trang List) --- */
        :root {
            --gold: #D4AF37;           /* Vàng kim loại */
            --gold-hover: #F3E5AB;     /* Vàng sáng khi hover */
            --bg-dark: #050505;        /* Đen sâu */
            --glass-bg: rgba(20, 20, 20, 0.7);
            --glass-border: rgba(255, 255, 255, 0.08);
            --text-main: #FFFFFF;
            --text-muted: #A0A0A0;
        }

        /* --- BASE STYLES --- */
        * { box-sizing: border-box; }

        body {
            font-family: 'Manrope', sans-serif; /* Font chữ nội dung */
            background-color: var(--bg-dark);
            color: var(--text-main);
            margin: 0; padding: 0;
            line-height: 1.7;
            overflow-x: hidden;
        }

        /* --- BACKGROUND ATMOSPHERE --- */
        /* Tạo hiệu ứng ánh sáng nền mờ ảo phía sau */
        body::before {
            content: '';
            position: fixed;
            top: -20%; left: 30%;
            width: 60%; height: 60%;
            background: radial-gradient(circle, rgba(212, 175, 55, 0.08) 0%, transparent 70%);
            filter: blur(80px);
            z-index: -1;
            pointer-events: none;
        }

        .container {
            max-width: 1100px;
            margin: 0 auto;
            padding: 0 24px;
        }

        /* --- HERO SECTION (PHẦN TIÊU ĐỀ) --- */
        /* --- SỬA LẠI PHẦN HERO ĐỂ GIỐNG LIST --- */
        .hero-section {
            position: relative;
            /* Chiều cao vừa phải để tạo điểm nhấn */
            height: 400px; 
            display: flex;
            align-items: center; /* Căn giữa dọc */
            justify-content: center;
            
            /* Dùng ảnh background sân khấu bạn gửi */
            /* Lưu ý: Thay đường dẫn đúng tới file ảnh của bạn */
            background: url('<%= request.getContextPath() %>/assets/images/background-recruitment.jpg') no-repeat center top;
            background-size: cover;
            
            /* Thêm lớp phủ tối để chữ trắng dễ đọc hơn */
            box-shadow: inset 0 -100px 100px var(--bg-dark); /* Làm mờ chân ảnh để hòa vào nền đen */
        }

        /* Xóa cái body::before cũ đi để đỡ bị 2 lớp background chồng chéo */
        body::before {
            content: none; 
        }

        h1.job-title-hero {
            /* Tinh chỉnh lại chữ tiêu đề cho hợp với cái nền đèn */
            font-family: 'Playfair Display', serif;
            font-size: 52px;
            color: #fff;
            text-shadow: 0 0 20px rgba(212, 175, 55, 0.6); /* Hiệu ứng tỏa sáng vàng nhẹ */
            margin-top: 60px; /* Đẩy xuống một chút để không bị che bởi đèn */
        }

        /* KHẮC PHỤC LỖI: Gom breadcrumb và title vào 1 luồng dọc */
        .hero-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            position: relative;
            z-index: 2;
        }

        .page-breadcrumb a {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 2px;
            border-bottom: 1px solid transparent;
            transition: 0.3s;
            /* Đảm bảo nằm tách biệt với tiêu đề */
            display: inline-block;
            margin-bottom: 20px; 
        }
        .page-breadcrumb a:hover {
            color: var(--gold);
            border-bottom-color: var(--gold);
        }

        h1.job-title-hero {
            font-family: 'Playfair Display', serif; /* Font tiêu đề giống trang List */
            font-size: 48px;
            font-weight: 700;
            color: #fff;
            margin: 0;
            line-height: 1.2;
            text-shadow: 0 4px 15px rgba(0,0,0,0.5);
            max-width: 800px;
        }

        /* --- LAYOUT CONTENT --- */
        .content-wrapper {
            display: grid;
            grid-template-columns: 2fr 1fr; /* 2 phần nội dung, 1 phần sidebar */
            gap: 40px;
            margin-bottom: 80px;
        }

        /* --- GLASS CARD DESIGN --- */
        .glass-panel {
            background: var(--glass-bg);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
        }

        /* --- LEFT CONTENT --- */
        .section-header {
            display: flex;
            align-items: center;
            margin-bottom: 25px;
        }
        
        .section-title {
            font-family: 'Playfair Display', serif;
            color: var(--gold);
            font-size: 22px;
            font-weight: 600;
            margin: 0;
            white-space: nowrap;
        }
        
        .section-line {
            height: 1px;
            width: 100%;
            background: linear-gradient(90deg, rgba(212, 175, 55, 0.3), transparent);
            margin-left: 20px;
        }

        .text-content {
            color: #d0d0d0;
            font-size: 16px;
            font-weight: 300;
            text-align: justify;
            margin-bottom: 50px;
            line-height: 1.8;
        }

        /* --- RIGHT SIDEBAR --- */
        .sidebar-info {
            position: sticky;
            top: 40px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: baseline;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .info-row:last-child { border: none; margin-bottom: 0; }

        .info-label {
            font-size: 12px;
            color: #777;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
        }
        
        .info-value {
            font-family: 'Manrope', sans-serif;
            font-size: 16px;
            color: #fff;
            font-weight: 500;
            text-align: right;
        }
        
        .highlight-value {
            color: var(--gold);
            font-weight: 700;
            font-size: 18px;
            font-family: 'Playfair Display', serif; /* Số tiền dùng font serif cho sang */
        }

        /* --- BUTTONS --- */
        .btn-primary {
            display: block;
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #C5A028 0%, #E6C86E 100%);
            color: #000;
            border: none;
            border-radius: 6px;
            font-family: 'Manrope', sans-serif;
            font-weight: 700;
            font-size: 15px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(197, 160, 40, 0.2);
            margin-top: 30px;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(197, 160, 40, 0.4);
            filter: brightness(1.1);
        }

        .btn-disabled {
            background: #222;
            color: #555;
            cursor: not-allowed;
            box-shadow: none;
            border: 1px solid #333;
        }

        /* --- MODAL FORM --- */
        .apply-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.9);
            z-index: 1000;
            justify-content: center;
            align-items: center;
            opacity: 0;
            transition: opacity 0.3s;
            backdrop-filter: blur(5px);
        }
        .apply-overlay.active { display: flex; opacity: 1; }

        .form-container {
            background: #111;
            width: 100%; max-width: 500px;
            padding: 40px;
            border: 1px solid var(--gold);
            border-radius: 8px;
            position: relative;
            transform: translateY(20px);
            transition: transform 0.3s;
        }
        .apply-overlay.active .form-container { transform: translateY(0); }

        .close-btn {
            position: absolute;
            top: 15px; right: 20px;
            color: #666;
            font-size: 28px;
            cursor: pointer;
            line-height: 1;
        }
        .close-btn:hover { color: var(--gold); }

        .form-group { margin-bottom: 20px; }
        .form-label {
            display: block;
            color: var(--gold);
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
            font-weight: 600;
        }
        .form-input {
            width: 100%;
            padding: 14px;
            background: #080808;
            border: 1px solid #333;
            color: #fff;
            border-radius: 4px;
            font-family: 'Manrope', sans-serif;
            transition: 0.3s;
        }
        .form-input:focus {
            outline: none;
            border-color: var(--gold);
            background: #000;
        }

        /* --- RESPONSIVE --- */
        @media (max-width: 768px) {
            .content-wrapper { grid-template-columns: 1fr; }
            h1.job-title-hero { font-size: 32px; }
            .hero-section { padding-top: 100px; }
        }

        .success-msg {
            text-align: center;
            color: var(--gold);
            padding: 15px;
            background: rgba(212, 175, 55, 0.1);
            border: 1px dashed var(--gold);
            margin-bottom: 30px;
            border-radius: 8px;
        }
    </style>
</head>
<body>

    <div class="hero-section">
        <div class="container hero-content">
            <div class="page-breadcrumb">
                <a href="<%= request.getContextPath() %>/job">← Quay lại danh sách</a>
            </div>
            
            <% if (job != null) { %>
                <h1 class="job-title-hero"><%= job.getTitle() %></h1>
            <% } %>
        </div>
    </div>

    <div class="container">
        
        <% if ("success".equals(applied)) { %>
            <div class="success-msg">
                ★ Hồ sơ ứng tuyển của bạn đã được gửi thành công!
            </div>
        <% } %>

        <% if (job != null) { %>
            <div class="content-wrapper">
                
                <div class="glass-panel">
                    <div class="section-header">
                        <h3 class="section-title">Mô tả công việc</h3>
                        <div class="section-line"></div>
                    </div>
                    <div class="text-content">
                        <%= job.getDescription() %>
                    </div>

                    <div class="section-header">
                        <h3 class="section-title">Yêu cầu ứng viên</h3>
                        <div class="section-line"></div>
                    </div>
                    <div class="text-content">
                        <%= job.getRequirement() %>
                    </div>
                </div>

                <div class="sidebar-info">
                    <div class="glass-panel">
                        <div class="info-row">
                            <span class="info-label">Mức lương</span>
                            <span class="info-value highlight-value"><%= job.getSalary() %></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Địa điểm</span>
                            <span class="info-value"><%= job.getLocation() %></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Hạn nộp hồ sơ</span>
                            <span class="info-value">
                                <%= job.getDeadline() != null ? new SimpleDateFormat("dd/MM/yyyy").format(job.getDeadline()) : "----" %>
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Trạng thái</span>
                            <span class="info-value" style="<%= "Open".equalsIgnoreCase(job.getStatus()) ? "color:#4CAF50" : "color:#888" %>">
                                <%= job.getStatus() %>
                            </span>
                        </div>

                        <% if ("Open".equalsIgnoreCase(job.getStatus())) { %>
                            <button onclick="openForm()" class="btn-primary">Ứng tuyển ngay</button>
                        <% } else { %>
                            <button class="btn-primary btn-disabled" disabled>Đã đóng đơn</button>
                        <% } %>
                    </div>
                </div>

            </div>
        <% } else { %>
            <div style="text-align: center; padding: 80px 0; color: #555;">
                <h2>Công việc không tồn tại hoặc đã bị xóa.</h2>
            </div>
        <% } %>
    </div>

    <div id="applyModal" class="apply-overlay">
        <div class="form-container">
            <span class="close-btn" onclick="closeForm()">×</span>
            <h2 style="font-family: 'Playfair Display'; color: var(--gold); text-align: center; margin-top: 0; margin-bottom: 30px;">
                Ứng Tuyển
            </h2>
            
            <form method="post" action="<%= request.getContextPath() %>/applyjob" enctype="multipart/form-data">
                <input type="hidden" name="jobId" value="<%= job != null ? job.getJobID() : "" %>"/>
                
                <div class="form-group">
                    <label class="form-label">Họ và tên</label>
                    <input type="text" name="fullName" class="form-input" required placeholder="Nhập tên của bạn">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-input" required placeholder="example@gmail.com">
                </div>

                <div class="form-group">
                    <label class="form-label">Số điện thoại</label>
                    <input type="text" name="phone" class="form-input" pattern="\d{9,11}" required placeholder="09xxxxxxxxx">
                </div>

                <div class="form-group">
                    <label class="form-label">CV đính kèm (PDF/DOC)</label>
                    <input type="file" name="cvFile" class="form-input" accept=".pdf,.doc,.docx" required style="padding-left: 0;">
                </div>

                <button type="submit" class="btn-primary">Gửi Hồ Sơ</button>
            </form>
        </div>
    </div>

    <script>
        function openForm() {
            document.getElementById('applyModal').classList.add('active');
            document.body.style.overflow = 'hidden';
        }
        function closeForm() {
            document.getElementById('applyModal').classList.remove('active');
            document.body.style.overflow = 'auto';
        }
        document.getElementById('applyModal').addEventListener('click', function(e) {
            if (e.target === this) closeForm();
        });
    </script>
</body>
</html>