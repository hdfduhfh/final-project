<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chính Sách Bảo Mật - BookingStage Elite</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600&family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        /* === COPY TỪ TRANG HỦY VÉ ĐỂ ĐỒNG BỘ === */
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

        /* --- CARDS & GRID --- */
        .policy-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 60px;
        }

        .policy-card {
            background: var(--glass-bg);
            border: 1px solid var(--border-light);
            padding: 30px;
            border-radius: 4px;
            transition: transform 0.3s ease;
        }

        .policy-card:hover {
            transform: translateY(-5px);
            border-color: var(--gold-primary);
        }

        .policy-card h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: #fff;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 12px;
            border: 1px solid;
            border-radius: 50px;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 15px;
        }

        .status-secure {
            border-color: #2e7d32; /* Green */
            color: #4ade80;
            background: rgba(46, 125, 50, 0.1);
        }

        .status-alert {
            border-color: #ef4444; /* Red */
            color: #f87171;
            background: rgba(239, 68, 68, 0.1);
        }

        /* --- DATA TABLE (STYLED LIKE RECEIPT) --- */
        .data-wrapper {
            background: rgba(10, 10, 10, 0.8);
            border: 1px solid var(--border-light);
            padding: 40px;
            position: relative;
            margin-bottom: 60px;
        }

        .data-wrapper::before {
            content: 'DATA USAGE';
            position: absolute;
            top: -10px;
            left: 20px;
            background: var(--bg-color);
            padding: 0 10px;
            font-size: 0.8rem;
            color: var(--gold-primary);
            letter-spacing: 2px;
        }

        .data-row {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px dashed rgba(255,255,255,0.1);
            color: #ccc;
            align-items: center;
        }

        .data-row:last-child {
            border-bottom: none;
        }

        .data-label {
            color: var(--gold-primary);
            font-weight: 500;
            width: 40%;
        }

        .data-value {
            width: 60%;
            text-align: right;
            color: var(--text-muted);
            font-size: 0.95rem;
        }

        /* --- FAQ / LIST --- */
        .faq-item {
            margin-bottom: 25px;
        }

        .faq-question {
            color: #fff;
            font-size: 1.1rem;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .faq-question i {
            color: var(--gold-primary);
            font-size: 0.9rem;
        }

        .faq-answer {
            color: var(--text-muted);
            padding-left: 25px;
            font-size: 0.95rem;
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
            .policy-grid { grid-template-columns: 1fr; }
            .page-header h1 { font-size: 2.5rem; }
            .luxury-container { padding: 40px 20px; }
            .data-row { flex-direction: column; align-items: flex-start; gap: 5px; }
            .data-label, .data-value { width: 100%; text-align: left; }
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/layout/header.jsp" %>
    
    <div class="luxury-container">
        
        <div class="page-header">
            <h1>Chính Sách Bảo Mật</h1>
            <p>Cam kết bảo vệ an toàn thông tin tuyệt đối</p>
        </div>

        <div class="intro-box">
            "Tại BookingStage, sự riêng tư của bạn là ưu tiên hàng đầu. Chúng tôi cam kết bảo vệ dữ liệu cá nhân của bạn theo các tiêu chuẩn an ninh mạng cao nhất và tuân thủ pháp luật hiện hành."
        </div>

        <div class="section-title">01. Thu Thập & Cam Kết</div>
        <div class="policy-grid">
            <div class="policy-card">
                <span class="status-badge status-secure"><i class="fa-solid fa-check"></i> Dữ liệu thu thập</span>
                <h3>Thông Tin Cần Thiết</h3>
                <p style="color: #ccc;">Chúng tôi chỉ thu thập những gì cần để xử lý vé:</p>
                <ul style="color: var(--text-muted); font-size: 0.9rem; margin-top: 15px; padding-left: 20px;">
                    <li>Họ tên, SĐT, Email (để gửi vé điện tử).</li>
                    <li>Lịch sử giao dịch & Sở thích xem show.</li>
                    <li>Cookie để tối ưu trải nghiệm website.</li>
                </ul>
            </div>

            <div class="policy-card">
                <span class="status-badge status-alert"><i class="fa-solid fa-shield-halved"></i> Nghiêm cấm</span>
                <h3>Không Chia Sẻ</h3>
                <p style="color: #ccc;">Sự an toàn của bạn được đảm bảo tuyệt đối:</p>
                <ul style="color: var(--text-muted); font-size: 0.9rem; margin-top: 15px; padding-left: 20px;">
                    <li><strong>KHÔNG</strong> bán dữ liệu cho bên thứ ba.</li>
                    <li><strong>KHÔNG</strong> lưu trữ số thẻ/CVV (qua cổng thanh toán).</li>
                    <li><strong>KHÔNG</strong> spam email rác làm phiền.</li>
                </ul>
            </div>
        </div>

        <div class="section-title">02. Mục Đích Sử Dụng Dữ Liệu</div>
        <div class="data-wrapper">
            <div class="data-row">
                <span class="data-label">Email & Số điện thoại</span>
                <span class="data-value">Gửi mã vé QR code & Thông báo khẩn cấp</span>
            </div>
            <div class="data-row">
                <span class="data-label">Lịch sử đặt vé</span>
                <span class="data-value">Hỗ trợ check-in & Đổi trả vé nhanh chóng</span>
            </div>
            <div class="data-row">
                <span class="data-label">Địa chỉ IP</span>
                <span class="data-value">Ngăn chặn gian lận & Tấn công mạng</span>
            </div>
            <div class="data-row">
                <span class="data-label">Dữ liệu thanh toán</span>
                <span class="data-value" style="color: #4ade80;">Mã hóa SSL 100% qua VNPay/Momo</span>
            </div>
        </div>

        <div class="section-title">03. Quyền Của Bạn & Bên Thứ Ba</div>
        <div class="faq-section">
            <div class="faq-item">
                <div class="faq-question"><i class="fa-solid fa-diamond"></i> Ai có thể tiếp cận dữ liệu?</div>
                <div class="faq-answer">Chỉ có 3 bên: Cổng thanh toán (xử lý tiền), Ban tổ chức (check-in vé), và Cơ quan pháp luật (khi có yêu cầu văn bản).</div>
            </div>
            <div class="faq-item">
                <div class="faq-question"><i class="fa-solid fa-diamond"></i> Tôi có thể xóa tài khoản không?</div>
                <div class="faq-answer">Có. Bạn có quyền yêu cầu xem lại, chỉnh sửa hoặc xóa vĩnh viễn dữ liệu cá nhân khỏi hệ thống của chúng tôi bất cứ lúc nào.</div>
            </div>
            <div class="faq-item">
                <div class="faq-question"><i class="fa-solid fa-diamond"></i> Về Cookie & Theo dõi?</div>
                <div class="faq-answer">Website sử dụng Cookie để ghi nhớ đăng nhập. Bạn có thể tắt trong cài đặt trình duyệt, nhưng trải nghiệm đặt vé có thể bị ảnh hưởng.</div>
            </div>
        </div>

        <div class="cta-section">
            <p style="color: #fff; font-size: 1.2rem; font-family: 'Playfair Display', serif;">Bạn có thắc mắc về dữ liệu?</p>
            <p style="color: var(--text-muted); margin-bottom: 20px;">Liên hệ bộ phận DPO (Data Protection Officer)</p>
            <a href="mailto:privacy@bookingstage.vn" class="btn-luxury">Gửi Email Bảo Mật</a>
        </div>

    </div>
    
    <%@ include file="/WEB-INF/views/layout/footer.jsp" %>
</body>
</html>