<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Điều Khoản Sử Dụng - BookingStage Elite</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600&family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        /* ===== LUXURY THEME VARIABLES ===== */
        :root {
            --bg-color: #080808;
            --gold-primary: #d4af37;
            --text-primary: #e0e0e0;
            --text-muted: #999;
            --glass-bg: rgba(255, 255, 255, 0.03);
            --border-light: rgba(212, 175, 55, 0.2);
            --danger-color: #a83232;
            --danger-bg: rgba(168, 50, 50, 0.1);
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

        /* --- HEADER STYLE --- */
        .page-header {
            text-align: center;
            margin-bottom: 70px;
            animation: fadeInDown 0.8s ease;
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

        .page-header .update-date {
            font-size: 0.9rem;
            color: var(--text-muted);
            letter-spacing: 2px;
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
            font-family: 'Playfair Display', serif;
            font-size: 1.1rem;
        }

        /* --- SECTION STYLES --- */
        .section-title {
            font-family: 'Playfair Display', serif;
            color: var(--gold-primary);
            font-size: 1.8rem;
            margin-top: 50px;
            margin-bottom: 25px;
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

        .content-block {
            margin-bottom: 20px;
            color: var(--text-muted);
            text-align: justify;
        }

        .sub-title {
            color: #fff;
            font-weight: 600;
            margin-top: 25px;
            margin-bottom: 10px;
            display: block;
            font-size: 1.1rem;
        }

        /* --- LIST STYLES (Custom bullets) --- */
        .gold-list {
            list-style: none;
            padding-left: 0;
            margin-bottom: 20px;
        }

        .gold-list li {
            position: relative;
            padding-left: 25px;
            margin-bottom: 10px;
            color: var(--text-muted);
        }

        .gold-list li::before {
            content: "✦"; /* Diamond symbol */
            position: absolute;
            left: 0;
            color: var(--gold-primary);
            font-size: 0.8rem;
            top: 4px;
        }

        /* --- TABLE OF CONTENTS (Styled as a card) --- */
        .toc-card {
            background: var(--glass-bg);
            border: 1px solid var(--border-light);
            padding: 30px;
            border-radius: 4px;
            margin-bottom: 60px;
        }

        .toc-card h3 {
            font-family: 'Playfair Display', serif;
            color: var(--gold-primary);
            margin-top: 0;
            margin-bottom: 20px;
            text-align: center;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .toc-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .toc-link {
            color: var(--text-muted);
            text-decoration: none;
            padding: 8px 12px;
            border-radius: 4px;
            transition: all 0.3s ease;
            font-size: 0.95rem;
            border-left: 1px solid transparent;
        }

        .toc-link:hover {
            color: var(--gold-primary);
            background: rgba(212, 175, 55, 0.05);
            border-left: 1px solid var(--gold-primary);
            padding-left: 18px;
        }

        /* --- WARNING BOX (Prohibited Acts) --- */
        .warning-box {
            background: linear-gradient(135deg, var(--danger-bg) 0%, transparent 100%);
            border-left: 3px solid var(--danger-color);
            padding: 30px;
            border-radius: 4px;
            margin: 30px 0;
        }

        .warning-box h4 {
            color: #ff6b6b; /* Lighter red for dark mode */
            margin-top: 0;
            margin-bottom: 15px;
            font-family: 'Playfair Display', serif;
            font-size: 1.3rem;
        }

        .warning-list li::before {
            color: #ff6b6b;
            content: "✕";
        }

        /* --- CTA SECTION --- */
        .cta-section {
            text-align: center;
            margin-top: 80px;
            border-top: 1px solid var(--border-light);
            padding-top: 50px;
        }

        .btn-luxury {
            display: inline-block;
            padding: 15px 40px;
            border: 1px solid var(--gold-primary);
            color: var(--gold-primary);
            text-decoration: none;
            font-weight: 600;
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

        /* --- ANIMATIONS --- */
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .page-header h1 { font-size: 2.5rem; }
            .toc-grid { grid-template-columns: 1fr; }
            .luxury-container { padding: 40px 20px; }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />
    
    <div class="luxury-container">
        
        <div class="page-header">
            <h1>Điều Khoản Sử Dụng</h1>
            <p class="update-date">Cập nhật lần cuối: 12/12/2024</p>
        </div>

        <div class="intro-box">
            "Chào mừng bạn đến với BookingStage Elite. Việc bạn truy cập và sử dụng dịch vụ đồng nghĩa với việc chấp nhận các quy định dưới đây nhằm đảm bảo trải nghiệm đẳng cấp và công bằng cho mọi thành viên."
        </div>

        <div class="toc-card">
            <h3>Mục Lục</h3>
            <div class="toc-grid">
                <a href="#sec1" class="toc-link">01. Tài khoản người dùng</a>
                <a href="#sec2" class="toc-link">02. Đặt vé & Thanh toán</a>
                <a href="#sec3" class="toc-link">03. Quyền lợi thành viên</a>
                <a href="#sec4" class="toc-link">04. Bảo mật thông tin</a>
                <a href="#sec5" class="toc-link">05. Sở hữu trí tuệ</a>
                <a href="#sec6" class="toc-link">06. Hành vi bị cấm</a>
                <a href="#sec7" class="toc-link">07. Miễn trừ trách nhiệm</a>
                <a href="#sec8" class="toc-link">08. Liên hệ</a>
            </div>
        </div>

        <div id="sec1" class="section-title">01. Tài Khoản Người Dùng</div>
        <div class="content-block">
            <span class="sub-title">1.1. Đăng ký tài khoản</span>
            <p>Để trải nghiệm đầy đủ các dịch vụ hạng sang, quý khách cần cung cấp thông tin xác thực bao gồm: Họ tên, Email, và Số điện thoại liên hệ chính chủ.</p>
            
            <span class="sub-title">1.2. Bảo mật</span>
            <ul class="gold-list">
                <li>Quý khách có trách nhiệm bảo mật tuyệt đối thông tin đăng nhập.</li>
                <li>Không chia sẻ tài khoản BookingStage Elite cho bên thứ ba.</li>
                <li>Thông báo ngay cho chúng tôi nếu phát hiện truy cập trái phép.</li>
            </ul>
        </div>

        <div id="sec2" class="section-title">02. Đặt Vé & Thanh Toán</div>
        <div class="content-block">
            <p>Khi tiến hành đặt vé, quý khách cam kết:</p>
            <ul class="gold-list">
                <li>Thanh toán đầy đủ theo đúng giá trị niêm yết tại thời điểm giao dịch.</li>
                <li>Tuân thủ giới hạn số lượng vé đặt (nếu có) để đảm bảo công bằng.</li>
                <li>Vé đã mua chỉ có giá trị sử dụng cho suất diễn đã chọn, trừ các trường hợp áp dụng chính sách hoàn hủy đặc biệt.</li>
            </ul>
        </div>

        <div id="sec3" class="section-title">03. Quyền Lợi & Nghĩa Vụ</div>
        <div class="content-block">
            <ul class="gold-list">
                <li><strong>Quyền lợi:</strong> Truy cập hệ thống đặt vé 24/7, nhận thông báo sớm về các show diễn độc quyền và được hỗ trợ ưu tiên.</li>
                <li><strong>Nghĩa vụ:</strong> Cung cấp thông tin trung thực và cư xử văn minh trong cộng đồng BookingStage.</li>
            </ul>
        </div>

        <div id="sec4" class="section-title">04. Bảo Mật Thông Tin</div>
        <div class="content-block">
            <p>Chúng tôi tôn trọng quyền riêng tư của quý khách. Mọi dữ liệu cá nhân chỉ được sử dụng để:</p>
            <ul class="gold-list">
                <li>Xử lý đơn hàng và gửi vé điện tử (E-Ticket).</li>
                <li>Cải thiện chất lượng dịch vụ và trải nghiệm người dùng.</li>
                <li>Gửi các thông tin quan trọng liên quan đến sự kiện.</li>
            </ul>
            <p><em>Chi tiết vui lòng xem tại <a href="${pageContext.request.contextPath}/pages/privacy.jsp" style="color: var(--gold-primary); text-decoration: none;">Chính sách bảo mật</a>.</em></p>
        </div>

        <div id="sec5" class="section-title">05. Sở Hữu Trí Tuệ</div>
        <div class="content-block">
            <p>Toàn bộ nội dung, hình ảnh, logo và thiết kế trên website đều thuộc quyền sở hữu độc quyền của BookingStage. Nghiêm cấm mọi hành vi sao chép, chỉnh sửa hoặc sử dụng cho mục đích thương mại khi chưa có sự đồng ý bằng văn bản.</p>
        </div>

        <div id="sec6" class="section-title">06. Hành Vi Bị Cấm</div>
        <div class="warning-box">
            <h4><i class="fa-solid fa-ban"></i> NGHIÊM CẤM CÁC HÀNH VI:</h4>
            <ul class="gold-list warning-list">
                <li>Sử dụng công cụ tự động (bot, script) để săn vé, gây ảnh hưởng hệ thống.</li>
                <li>Đầu cơ, tích trữ vé số lượng lớn để bán lại (phe vé).</li>
                <li>Phát tán nội dung độc hại, lừa đảo hoặc vi phạm thuần phong mỹ tục.</li>
                <li>Giả mạo thông tin cá nhân để trục lợi khuyến mãi.</li>
            </ul>
            <p style="color: #ff6b6b; font-size: 0.9rem; margin-top: 10px;">
                * Vi phạm sẽ dẫn đến việc khóa tài khoản vĩnh viễn không báo trước.
            </p>
        </div>

        <div id="sec7" class="section-title">07. Miễn Trừ Trách Nhiệm</div>
        <div class="content-block">
            <p>BookingStage Elite nỗ lực cung cấp dịch vụ tốt nhất, tuy nhiên chúng tôi được miễn trừ trách nhiệm trong các trường hợp:</p>
            <ul class="gold-list">
                <li>Sự cố kỹ thuật khách quan (đường truyền mạng phía người dùng, thiên tai).</li>
                <li>Thay đổi nội dung nghệ thuật từ phía Ban tổ chức sự kiện.</li>
                <li>Mất mát tài sản cá nhân khi tham gia sự kiện trực tiếp.</li>
            </ul>
        </div>

        <div id="sec8" class="section-title">08. Sửa Đổi Điều Khoản</div>
        <div class="content-block">
            <p>Chúng tôi có quyền cập nhật các điều khoản này bất cứ lúc nào. Những thay đổi sẽ có hiệu lực ngay khi được đăng tải. Việc tiếp tục sử dụng dịch vụ đồng nghĩa với việc quý khách chấp nhận các điều khoản mới.</p>
        </div>

        <div class="cta-section">
            <p style="color: #fff; font-size: 1.2rem; font-family: 'Playfair Display', serif;">Bạn có thắc mắc về điều khoản?</p>
            <p style="color: var(--text-muted); margin-bottom: 20px;">Đội ngũ pháp lý & CSKH luôn sẵn sàng hỗ trợ</p>
            
            <div style="margin-bottom: 30px; display: flex; justify-content: center; gap: 30px; flex-wrap: wrap; color: var(--gold-primary);">
                <span><i class="fa-solid fa-envelope"></i> support@bookingstage.vn</span>
                <span><i class="fa-solid fa-phone"></i> 1900-xxxx</span>
            </div>
            
            <a href="${pageContext.request.contextPath}/contact" class="btn-luxury">Liên Hệ Ngay</a>
        </div>

    </div>
    
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>