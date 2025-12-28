<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Về Chúng Tôi - BookingStage Elite</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600&family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        /* === COPY TỪ TRANG MẪU === */
        :root {
            --bg-color: #080808;
            --gold-primary: #d4af37;
            --text-primary: #e0e0e0;
            --text-muted: #999;
            --glass-bg: rgba(255, 255, 255, 0.03);
            --border-light: rgba(212, 175, 55, 0.2);
            --danger-color: #a83232;
            --success-color: #2e7d32;
        }

        body {
            font-family: 'Montserrat', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-primary);
            padding-top: 80px;
            min-height: 100vh;
            line-height: 1.8;
            background-image: radial-gradient(circle at 50% 0%, #1a1a1a 0%, #080808 60%);
        }

        .luxury-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 60px 20px 100px;
        }

        /* --- HEADER --- */
        .page-header {
            text-align: center;
            margin-bottom: 70px;
        }

        .page-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 3.5rem;
            font-weight: 700;
            font-style: italic;
            background: linear-gradient(135deg, #fff 0%, #d4af37 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }

        .page-header p {
            font-size: 1.1rem;
            color: var(--text-muted);
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        /* --- INTRO BOX --- */
        .intro-box {
            border-left: 2px solid var(--gold-primary);
            padding: 20px 30px;
            background: linear-gradient(90deg, var(--glass-bg) 0%, transparent 100%);
            margin-bottom: 60px;
            color: #ccc;
            font-style: italic;
        }

        /* --- SECTION TITLES --- */
        .section-title {
            font-family: 'Playfair Display', serif;
            color: var(--gold-primary);
            font-size: 2rem;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .section-title::after {
            content: '';
            flex: 1;
            height: 1px;
            background: linear-gradient(to right, var(--border-light), transparent);
        }

        /* --- CARDS (Reused Policy Card Style) --- */
        .grid-3-col {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 60px;
        }

        .feature-card {
            background: var(--glass-bg);
            border: 1px solid var(--border-light);
            padding: 30px 20px;
            text-align: center;
            border-radius: 4px;
            transition: transform 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            border-color: var(--gold-primary);
        }

        .feature-card i {
            font-size: 2rem;
            color: var(--gold-primary);
            margin-bottom: 15px;
            display: inline-block;
        }

        .feature-card h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.3rem;
            color: #fff;
            margin-bottom: 10px;
        }
        
        .feature-card .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--gold-primary);
            font-family: 'Playfair Display', serif;
            line-height: 1;
            margin-bottom: 5px;
        }

        .feature-card p {
            font-size: 0.9rem;
            color: var(--text-muted);
            margin: 0;
        }

        /* --- CTA --- */
        .cta-section {
            text-align: center;
            margin-top: 60px;
            border-top: 1px solid var(--border-light);
            padding-top: 40px;
        }

        .btn-luxury {
            display: inline-block;
            padding: 15px 40px;
            border: 1px solid var(--gold-primary);
            color: var(--gold-primary);
            text-decoration: none;
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
            font-size: 0.9rem;
            letter-spacing: 2px;
            text-transform: uppercase;
            transition: all 0.4s ease;
            background: transparent;
            margin-top: 20px;
        }

        .btn-luxury:hover {
            background: var(--gold-primary);
            color: #000;
            box-shadow: 0 0 20px rgba(212, 175, 55, 0.4);
        }

        @media (max-width: 768px) {
            .grid-3-col { grid-template-columns: 1fr; }
            .page-header h1 { font-size: 2.5rem; }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />
    
    <div class="luxury-container">
        
        <div class="page-header">
            <h1>Câu Chuyện Thương Hiệu</h1>
            <p>Nâng tầm trải nghiệm giải trí Việt</p>
        </div>

        <div class="intro-box">
            "Chúng tôi không chỉ bán vé. BookingStage Elite trao cho bạn tấm vé thông hành đến những giấc mơ và những khoảnh khắc thăng hoa nhất của nghệ thuật."
        </div>

        <div class="section-title">01. Hành Trình Phát Triển</div>
        <div style="color: var(--text-muted); margin-bottom: 50px;">
            <p style="margin-bottom: 15px;">Được thành lập với sứ mệnh định nghĩa lại sự "Sang trọng" trong lĩnh vực giải trí, BookingStage Elite là cầu nối giữa những nghệ sĩ hàng đầu và những khán giả tinh hoa.</p>
            <p>Trải qua hành trình hình thành và phát triển, chúng tôi tự hào là đơn vị phân phối vé chính thức cho các sự kiện tầm cỡ quốc tế tại Việt Nam.</p>
        </div>

        <div class="section-title">02. Những Con Số Ấn Tượng</div>
        <div class="grid-3-col">
            <div class="feature-card">
                <div class="stat-number">5+</div>
                <p>Năm Kinh Nghiệm</p>
            </div>
            <div class="feature-card">
                <div class="stat-number">500+</div>
                <p>Show Diễn Đẳng Cấp</p>
            </div>
            <div class="feature-card">
                <div class="stat-number">1M+</div>
                <p>Khán Giả Hài Lòng</p>
            </div>
        </div>

        <div class="section-title">03. Giá Trị Cốt Lõi</div>
        <div class="grid-3-col">
            <div class="feature-card">
                <i class="fa-regular fa-gem"></i>
                <h3>Đẳng Cấp</h3>
                <p>Dịch vụ chuẩn 5 sao từ khâu đặt vé đến khi check-in.</p>
            </div>
            <div class="feature-card">
                <i class="fa-solid fa-shield-halved"></i>
                <h3>Minh Bạch</h3>
                <p>Cam kết bảo mật thông tin và chính sách giá rõ ràng.</p>
            </div>
            <div class="feature-card">
                <i class="fa-solid fa-headset"></i>
                <h3>Tận Tâm</h3>
                <p>Đội ngũ hỗ trợ riêng biệt, phục vụ 24/7 mọi lúc mọi nơi.</p>
            </div>
        </div>

        <div class="cta-section">
            <p style="color: #fff; font-size: 1.2rem; font-family: 'Playfair Display', serif;">Bạn đã sẵn sàng cho trải nghiệm tiếp theo?</p>
            <a href="${pageContext.request.contextPath}/events" class="btn-luxury">Xem Lịch Diễn</a>
        </div>

    </div>
    
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>