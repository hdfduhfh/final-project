<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chính Sách Hủy Vé - BookingStage Elite</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600&family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
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

        /* --- POLICY TIMELINE --- */
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

        .status-allow {
            border-color: var(--gold-primary);
            color: var(--gold-primary);
            background: rgba(212, 175, 55, 0.1);
        }

        .status-deny {
            border-color: var(--text-muted);
            color: var(--text-muted);
            background: rgba(255, 255, 255, 0.05);
        }

        /* --- CALCULATION BOX --- */
        .calc-wrapper {
            background: rgba(10, 10, 10, 0.8);
            border: 1px solid var(--border-light);
            padding: 40px;
            position: relative;
            margin-bottom: 60px;
        }

        .calc-wrapper::before {
            content: 'RECEIPT EXAMPLE';
            position: absolute;
            top: -10px;
            left: 20px;
            background: var(--bg-color);
            padding: 0 10px;
            font-size: 0.8rem;
            color: var(--gold-primary);
            letter-spacing: 2px;
        }

        .calc-row {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px dashed rgba(255,255,255,0.1);
            color: #ccc;
        }

        .calc-row.total {
            border-bottom: none;
            border-top: 1px solid var(--gold-primary);
            margin-top: 10px;
            padding-top: 20px;
            color: var(--gold-primary);
            font-size: 1.2rem;
            font-family: 'Playfair Display', serif;
        }

        /* --- PROCESS STEPS --- */
        .process-list {
            list-style: none;
            padding: 0;
            margin-bottom: 60px;
        }

        .process-item {
            display: flex;
            gap: 20px;
            margin-bottom: 25px;
            align-items: flex-start;
        }

        .process-num {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            color: var(--gold-primary);
            line-height: 1;
            opacity: 0.5;
        }

        .process-content h4 {
            color: #fff;
            margin-bottom: 5px;
            font-size: 1.1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .process-content p {
            color: var(--text-muted);
            font-size: 0.95rem;
        }

        /* --- FAQ --- */
        .faq-item {
            margin-bottom: 30px;
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
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/layout/header.jsp" %>
    
    <div class="luxury-container">
        
        <div class="page-header">
            <h1>Chính Sách Hủy Vé</h1>
            <p>Quy định hoàn tiền & Bảo vệ quyền lợi khách hàng</p>
        </div>

        <div class="intro-box">
            "BookingStage Elite hiểu rằng kế hoạch có thể thay đổi. Chúng tôi cam kết mang đến chính sách hoàn tiền minh bạch và công bằng nhất cho quý khách."
        </div>

        <div class="section-title">01. Quy Định Thời Gian</div>
        <div class="policy-grid">
            <div class="policy-card">
                <span class="status-badge status-allow">Trước 24 giờ</span>
                <h3>Được Phép Hủy</h3>
                <p style="color: #ccc;">Quý khách được quyền hủy vé và nhận lại tiền hoàn.</p>
                <ul style="color: var(--text-muted); font-size: 0.9rem; margin-top: 15px; padding-left: 20px;">
                    <li>Hoàn tiền: <strong>70% giá trị vé</strong>.</li>
                    <li>Phí xử lý & bồi thường giữ chỗ: <strong>30%</strong>.</li>
                    <li>Áp dụng cho mọi loại vé.</li>
                </ul>
            </div>

            <div class="policy-card">
                <span class="status-badge status-deny">Trong vòng 24 giờ</span>
                <h3>Không Thể Hủy</h3>
                <p style="color: #ccc;">Vé không còn hiệu lực để hoàn tiền khi sát giờ diễn.</p>
                <ul style="color: var(--text-muted); font-size: 0.9rem; margin-top: 15px; padding-left: 20px;">
                    <li>Lý do: Ghế đã được giữ và không thể bán lại cho khách khác.</li>
                    <li>Quyền lợi: Vé vẫn có giá trị sử dụng để check-in bình thường.</li>
                </ul>
            </div>
        </div>

        <div class="section-title">02. Cách Tính Tiền Hoàn</div>
        <div class="calc-wrapper">
            <div class="calc-row">
                <span>Giá trị vé gốc</span>
                <span>500.000 VNĐ</span>
            </div>
            <div class="calc-row">
                <span>Phí hủy vé & Xử lý (30%)</span>
                <span style="color: var(--danger-color);">- 150.000 VNĐ</span>
            </div>
            <div class="calc-row total">
                <span>Số Tiền Thực Nhận</span>
                <span>350.000 VNĐ</span>
            </div>
            <div style="text-align: right; color: var(--text-muted); font-size: 0.85rem; margin-top: 15px;">
                <i class="fa-regular fa-clock"></i> Thời gian xử lý: 3 - 7 ngày làm việc
            </div>
        </div>

        <div class="section-title">03. Quy Trình Thực Hiện</div>
        <ul class="process-list">
            <li class="process-item">
                <div class="process-num">01</div>
                <div class="process-content">
                    <h4>Truy cập "Vé Của Tôi"</h4>
                    <p>Đăng nhập vào tài khoản và chọn vé quý khách muốn thực hiện yêu cầu hủy.</p>
                </div>
            </li>
            <li class="process-item">
                <div class="process-num">02</div>
                <div class="process-content">
                    <h4>Xác Nhận Yêu Cầu</h4>
                    <p>Nhấn nút "Hủy Vé" và điền lý do (nếu có). Hệ thống sẽ hiển thị chính xác số tiền được hoàn lại.</p>
                </div>
            </li>
            <li class="process-item">
                <div class="process-num">03</div>
                <div class="process-content">
                    <h4>Nhận Tiền Hoàn</h4>
                    <p>Sau khi hệ thống duyệt tự động, tiền sẽ được hoàn về phương thức thanh toán gốc (Ví/Ngân hàng).</p>
                </div>
            </li>
        </ul>

        <div class="section-title">04. Câu Hỏi Thường Gặp</div>
        <div class="faq-section">
            <div class="faq-item">
                <div class="faq-question"><i class="fa-solid fa-diamond"></i> Vé mua qua Momo/VNPAY có được hoàn không?</div>
                <div class="faq-answer">Có. Tiền sẽ được hoàn trực tiếp về ví Momo hoặc tài khoản ngân hàng liên kết với VNPAY của quý khách.</div>
            </div>
            <div class="faq-item">
                <div class="faq-question"><i class="fa-solid fa-diamond"></i> Nếu Show diễn bị hủy bởi Ban tổ chức thì sao?</div>
                <div class="faq-answer">Trong trường hợp này, quý khách sẽ được <strong>hoàn tiền 100%</strong> (bao gồm cả phí dịch vụ) mà không chịu bất kỳ khoản phạt nào.</div>
            </div>
            <div class="faq-item">
                <div class="faq-question"><i class="fa-solid fa-diamond"></i> Tôi có thể đổi vé sang Show khác thay vì hủy không?</div>
                <div class="faq-answer">Hiện tại hệ thống chưa hỗ trợ đổi vé tự động. Quý khách vui lòng hủy vé cũ và đặt lại vé mới.</div>
            </div>
        </div>

        <div class="cta-section">
            <p style="color: #fff; font-size: 1.2rem; font-family: 'Playfair Display', serif;">Cần sự trợ giúp đặc biệt?</p>
            <p style="color: var(--text-muted); margin-bottom: 20px;">Đội ngũ hỗ trợ VIP luôn sẵn sàng 24/7</p>
            <a href="${pageContext.request.contextPath}/contact" class="btn-luxury">Liên Hệ Hỗ Trợ</a>
        </div>

    </div>

    <%@ include file="/WEB-INF/views/layout/footer.jsp" %>
</body>
</html>