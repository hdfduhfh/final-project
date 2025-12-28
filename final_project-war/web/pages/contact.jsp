<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Liên Hệ - BookingStage Elite</title>
    
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

        /* --- INFO GRID --- */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 60px;
        }

        .info-card {
            background: var(--glass-bg);
            border: 1px solid var(--border-light);
            padding: 30px 20px;
            text-align: center;
            border-radius: 4px;
            transition: transform 0.3s ease;
        }

        .info-card:hover {
            transform: translateY(-5px);
            border-color: var(--gold-primary);
        }

        .info-card i {
            color: var(--gold-primary);
            font-size: 1.5rem;
            margin-bottom: 15px;
        }

        .info-card h4 {
            font-family: 'Playfair Display', serif;
            color: #fff;
            margin-bottom: 5px;
            font-size: 1.2rem;
        }

        .info-card p {
            color: var(--text-muted);
            font-size: 0.9rem;
            margin: 0;
        }

        /* --- CONTACT FORM STYLE (Customized to match theme) --- */
        .contact-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            background: rgba(10, 10, 10, 0.8); /* Dark layout like calc-wrapper */
            border: 1px solid var(--border-light);
            padding: 40px;
            border-radius: 4px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            color: #fff;
            margin-bottom: 8px;
            font-size: 0.9rem;
            letter-spacing: 0.5px;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            background: var(--glass-bg);
            border: 1px solid #333;
            color: #fff;
            border-radius: 4px;
            font-family: 'Montserrat', sans-serif;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--gold-primary);
            background: rgba(255,255,255,0.05);
            box-shadow: 0 0 10px rgba(212, 175, 55, 0.1);
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }

        .btn-luxury {
            display: inline-block;
            width: 100%;
            padding: 15px 40px;
            border: 1px solid var(--gold-primary);
            color: var(--gold-primary);
            background: transparent;
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
            font-size: 0.9rem;
            letter-spacing: 2px;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.4s ease;
        }

        .btn-luxury:hover {
            background: var(--gold-primary);
            color: #000;
            box-shadow: 0 0 20px rgba(212, 175, 55, 0.4);
        }

        /* --- MAP --- */
        .map-container iframe {
            width: 100%;
            height: 100%;
            min-height: 400px;
            border: none;
            filter: grayscale(100%) invert(92%) contrast(83%); /* Dark map effect */
            border-radius: 4px;
        }

        @media (max-width: 768px) {
            .info-grid { grid-template-columns: 1fr; }
            .contact-layout { grid-template-columns: 1fr; padding: 20px; }
            .map-container iframe { min-height: 300px; }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />
    
    <div class="luxury-container">
        
        <div class="page-header">
            <h1>Liên Hệ Hỗ Trợ</h1>
            <p>Chúng tôi luôn sẵn sàng lắng nghe bạn 24/7</p>
        </div>

        <div class="intro-box">
            "Sự hài lòng của quý khách là ưu tiên hàng đầu. Đừng ngần ngại liên hệ với đội ngũ BookingStage Elite bất cứ khi nào bạn cần hỗ trợ."
        </div>

        <div class="section-title">01. Kênh Liên Lạc Trực Tiếp</div>
        <div class="info-grid">
            <div class="info-card">
                <i class="fa-solid fa-phone"></i>
                <h4>Hotline VIP</h4>
                <p>1900-XXXX</p>
                <p style="font-size: 0.8rem; opacity: 0.6;">(08:00 - 22:00 Hàng ngày)</p>
            </div>
            <div class="info-card">
                <i class="fa-solid fa-envelope"></i>
                <h4>Email Support</h4>
                <p>support@bookingstage.vn</p>
                <p style="font-size: 0.8rem; opacity: 0.6;">Phản hồi trong 24h</p>
            </div>
            <div class="info-card">
                <i class="fa-solid fa-location-dot"></i>
                <h4>Trụ Sở Chính</h4>
                <p>Q.1, TP. Hồ Chí Minh</p>
                <p style="font-size: 0.8rem; opacity: 0.6;">Việt Nam</p>
            </div>
        </div>

        <div class="section-title">02. Gửi Yêu Cầu Hỗ Trợ</div>
        <div class="contact-layout">
            <div class="form-section">
                <form action="${pageContext.request.contextPath}/contact/send" method="POST">
                    <div class="form-group">
                        <label for="name">Họ và Tên</label>
                        <input type="text" id="name" name="name" class="form-control" placeholder="Nhập tên của quý khách" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email liên hệ</label>
                        <input type="email" id="email" name="email" class="form-control" placeholder="example@email.com" required>
                    </div>

                    <div class="form-group">
                        <label for="message">Nội dung cần hỗ trợ</label>
                        <textarea id="message" name="message" class="form-control" placeholder="Quý khách cần hỗ trợ về vé hay sự kiện?"></textarea>
                    </div>

                    <button type="submit" class="btn-luxury">Gửi Tin Nhắn</button>
                </form>
            </div>

            <div class="map-container">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.4241674197475!2d106.6983793148008!3d10.779785492319347!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31752f36c5e0a6d1%3A0x6c3d8a7e1c8e8e8!2sHo%20Chi%20Minh%20City!5e0!3m2!1sen!2s!4v1620000000000!5m2!1sen!2s" 
                    allowfullscreen="" loading="lazy"></iframe>
            </div>
        </div>

    </div>
    
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>