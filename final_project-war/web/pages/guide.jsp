<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hướng Dẫn Đặt Vé - BookingStage Elite</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600&family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-color: #080808;
            --gold-primary: #d4af37;
            --gold-light: #f3e5ab;
            --text-primary: #e0e0e0;
            --text-muted: #999;
            --glass-bg: rgba(255, 255, 255, 0.02);
        }

        body {
            font-family: 'Montserrat', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-primary);
            padding-top: 80px;
            min-height: 100vh;
            line-height: 1.8;
            /* Gradient nền nhẹ nhàng đồng bộ */
            background-image: radial-gradient(circle at 50% 0%, #1a1a1a 0%, #080808 60%);
        }

        .luxury-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 60px 20px 100px;
        }

        /* --- HEADER --- */
        .page-header {
            text-align: center;
            margin-bottom: 90px;
        }

        .page-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 3.8rem;
            font-weight: 700;
            font-style: italic;
            background: linear-gradient(135deg, #fff 0%, #d4af37 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 15px;
            letter-spacing: -1px;
        }

        .page-header p {
            font-size: 1.1rem;
            color: var(--text-muted);
            font-weight: 300;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        /* --- TIMELINE STEPS --- */
        .timeline-wrapper {
            position: relative;
            padding-left: 30px; /* Chừa chỗ cho đường kẻ */
        }

        /* Đường kẻ dọc mảnh mai */
        .timeline-wrapper::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 20px;
            bottom: 50px;
            width: 1px;
            background: linear-gradient(to bottom, var(--gold-primary), transparent);
        }

        .step-item {
            position: relative;
            padding-bottom: 60px;
            padding-left: 50px;
        }

        /* Dấu chấm tròn trên dòng thời gian */
        .step-dot {
            position: absolute;
            left: -35px; /* Căn chỉnh với đường kẻ */
            top: 0;
            width: 30px;
            height: 30px;
            background: var(--bg-color);
            border: 1px solid var(--gold-primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 2;
            box-shadow: 0 0 15px rgba(212, 175, 55, 0.2);
        }

        .step-dot span {
            font-family: 'Playfair Display', serif;
            color: var(--gold-primary);
            font-weight: 700;
            font-size: 0.9rem;
        }

        .step-content h3 {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            color: #fff;
            margin-top: -5px;
            margin-bottom: 15px;
            font-weight: 400;
        }

        .step-content p {
            font-size: 1rem;
            color: var(--text-muted);
            margin-bottom: 15px;
        }

        .step-list {
            list-style: none;
            padding: 0;
        }

        .step-list li {
            position: relative;
            padding-left: 20px;
            margin-bottom: 8px;
            color: #ccc;
            font-size: 0.95rem;
        }

        .step-list li::before {
            content: '•';
            color: var(--gold-primary);
            position: absolute;
            left: 0;
            font-size: 1.2rem;
            line-height: 1;
        }

        /* --- PAYMENT GRID (Minimalist) --- */
        .payment-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 20px;
            margin-top: 30px;
            border-top: 1px solid rgba(255,255,255,0.05);
            padding-top: 30px;
        }

        .payment-item {
            text-align: center;
            padding: 15px;
            border-radius: 8px;
            transition: all 0.3s ease;
            border: 1px solid transparent;
        }

        .payment-item:hover {
            border-color: rgba(212, 175, 55, 0.3);
            background: rgba(212, 175, 55, 0.05);
        }

        .payment-icon {
            font-size: 2rem;
            margin-bottom: 10px;
            display: block;
            filter: grayscale(100%) opacity(0.7);
            transition: all 0.3s ease;
        }

        .payment-item:hover .payment-icon {
            filter: grayscale(0%) opacity(1);
            transform: scale(1.1);
        }

        .payment-text {
            font-size: 0.8rem;
            color: var(--text-muted);
            font-family: 'Montserrat', sans-serif;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* --- NOTE SECTION (Elegant) --- */
        .note-section {
            margin-top: 40px;
            padding: 30px 40px;
            border-left: 2px solid var(--gold-primary);
            background: linear-gradient(90deg, rgba(212, 175, 55, 0.05) 0%, transparent 100%);
        }

        .note-title {
            font-family: 'Playfair Display', serif;
            color: var(--gold-primary);
            font-size: 1.5rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* --- CTA --- */
        .cta-wrapper {
            text-align: center;
            margin-top: 80px;
            padding-top: 50px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .cta-wrapper h3 {
            font-family: 'Playfair Display', serif;
            font-size: 2.2rem;
            margin-bottom: 30px;
            color: #fff;
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
        }

        .btn-luxury:hover {
            background: var(--gold-primary);
            color: #000;
            box-shadow: 0 0 20px rgba(212, 175, 55, 0.4);
        }

        @media (max-width: 768px) {
            .page-header h1 { font-size: 2.5rem; }
            .step-content h3 { font-size: 1.6rem; }
            .luxury-container { padding: 40px 20px; }
            .timeline-wrapper::before { left: 14px; }
            .step-item { padding-left: 40px; }
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/layout/header.jsp" %>
    
    <div class="luxury-container">
        <div class="page-header">
            <h1>Quy Trình Đặt Vé</h1>
            <p>Trải nghiệm nghệ thuật chỉ với 3 bước</p>
        </div>
        
        <div class="timeline-wrapper">
            
            <div class="step-item">
                <div class="step-dot"><span>1</span></div>
                <div class="step-content">
                    <h3>Lựa Chọn Tác Phẩm</h3>
                    <p>Khám phá không gian nghệ thuật và tìm kiếm nguồn cảm hứng cho riêng bạn.</p>
                    <ul class="step-list">
                        <li>Xem trailer & nội dung chi tiết của Show diễn.</li>
                        <li>Kiểm tra thời gian và dàn nghệ sĩ (Cast).</li>
                        <li>Tham khảo đánh giá từ cộng đồng khán giả.</li>
                    </ul>
                </div>
            </div>

            <div class="step-item">
                <div class="step-dot"><span>2</span></div>
                <div class="step-content">
                    <h3>Vị Trí & Hạng Ghế</h3>
                    <p>Hệ thống sơ đồ trực quan (Real-time) giúp bạn chọn được tầm nhìn hoàn hảo nhất.</p>
                    <ul class="step-list">
                        <li><strong>Diamond/VIP:</strong> Vị trí trung tâm, bao gồm tiệc trà và lối đi riêng.</li>
                        <li><strong>Gold/Silver:</strong> Tầm nhìn bao quát sân khấu với mức giá ưu đãi.</li>
                        <li>Thời gian giữ ghế tự động: <strong>10 phút</strong>.</li>
                    </ul>
                </div>
            </div>

            <div class="step-item">
                <div class="step-dot"><span>3</span></div>
                <div class="step-content">
                    <h3>Thanh Toán & Xác Nhận</h3>
                    <p>Hoàn tất giao dịch bảo mật. Vé điện tử (QR-Code) sẽ được gửi ngay lập tức.</p>
                    
                    <div class="payment-grid">
                        <div class="payment-item">
                            <span class="payment-icon">💳</span>
                            <span class="payment-text">Visa/Master</span>
                        </div>
                        <div class="payment-item">
                            <span class="payment-icon">🏦</span>
                            <span class="payment-text">Banking</span>
                        </div>
                        <div class="payment-item">
                            <span class="payment-icon">📱</span>
                            <span class="payment-text">E-Wallet</span>
                        </div>
                        <div class="payment-item">
                            <span class="payment-icon">✨</span>
                            <span class="payment-text">VNPay QR</span>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <div class="note-section">
            <div class="note-title">✦ Lưu Ý Quan Trọng</div>
            <ul class="step-list">
                <li>Quý khách vui lòng đến trước giờ diễn <strong>30 phút</strong> để check-in và ổn định chỗ ngồi.</li>
                <li>Trang phục lịch sự (Formal/Smart Casual) được khuyến khích để phù hợp không gian nghệ thuật.</li>
                <li>Vé đã mua không hỗ trợ hoàn hủy sát giờ diễn (xem chính sách chi tiết).</li>
                <li>Hotline hỗ trợ VIP 24/7: <strong>1900-xxxx</strong></li>
            </ul>
        </div>

        <div class="cta-wrapper">
            <h3>Sẵn sàng cho những khoảnh khắc thăng hoa?</h3>
            <a href="${pageContext.request.contextPath}/shows" class="btn-luxury">Đặt Vé Ngay</a>
        </div>

    </div>

    <%@ include file="/WEB-INF/views/layout/footer.jsp" %>
</body>
</html>