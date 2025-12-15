<%-- 
    Document   : guide
    Created on : Dec 11, 2025, 2:11:29 PM
    Author     : DANG KHOA
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hướng dẫn đặt vé - BookingStage</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&display=swap" rel="stylesheet">

    <style>
        /* --- GLOBAL SETTINGS --- */
        body {
            margin: 0;
            font-family: 'Playfair Display', serif; /* Font sang trọng */
            background-color: #050505;
            /* Tạo nền đen có chút đốm sáng mờ ảo */
            background-image: 
                radial-gradient(circle at 10% 20%, rgba(255, 215, 0, 0.05) 0%, transparent 20%),
                radial-gradient(circle at 90% 80%, rgba(255, 215, 0, 0.05) 0%, transparent 20%);
            color: #e0e0e0;
            padding-top: 100px; /* Né cái Header fixed */
            min-height: 100vh;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        
        /* --- PAGE HEADER --- */
        .page-header {
            text-align: center;
            margin-bottom: 60px;
            animation: fadeInDown 0.8s ease;
        }
        
        .page-header h1 {
            font-size: 3.5rem;
            margin-bottom: 15px;
            
            /* Gradient Vàng Kim Loại */
            background: linear-gradient(to right, #bf953f, #fcf6ba, #b38728, #fbf5b7, #aa771c);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            
            filter: drop-shadow(0 4px 4px rgba(0,0,0,0.5));
        }
        
        .page-header p {
            font-size: 1.3rem;
            color: #aaa;
            font-style: italic;
            letter-spacing: 1px;
        }
        
        /* --- MAIN GUIDE BOX (GLASS EFFECT) --- */
        .guide-section {
            /* Kính mờ tối màu */
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            
            border: 1px solid rgba(255, 215, 0, 0.15); /* Viền vàng mảnh */
            border-radius: 24px;
            padding: 50px;
            margin-bottom: 40px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.5);
            animation: fadeInUp 0.8s ease;
        }
        
        /* --- STEPS --- */
        .step {
            display: flex;
            gap: 30px;
            margin-bottom: 50px;
            align-items: flex-start;
            position: relative;
        }

        /* Đường nối giữa các bước (trang trí) */
        .step:not(:last-child)::after {
            content: '';
            position: absolute;
            left: 35px; /* Căn giữa số */
            top: 80px;
            bottom: -50px;
            width: 2px;
            background: linear-gradient(to bottom, rgba(255,215,0,0.5), transparent);
            z-index: 0;
        }
        
        .step:last-child {
            margin-bottom: 0;
        }
        
        /* Số bước (1, 2, 3) */
        .step-number {
            flex-shrink: 0;
            width: 70px;
            height: 70px;
            
            /* Nền vàng, chữ đen */
            background: linear-gradient(135deg, #ffd700, #b38728);
            color: #000;
            
            border-radius: 50%; /* Tròn hoàn toàn */
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            font-weight: 800;
            box-shadow: 0 0 20px rgba(255, 215, 0, 0.3);
            z-index: 1; /* Nằm trên đường kẻ */
            border: 4px solid #1a1a1a; /* Viền đen để tách nền */
        }
        
        .step-content {
            padding-top: 5px;
        }
        
        .step-content h3 {
            font-size: 2rem;
            color: #ffd700; /* Tiêu đề màu vàng */
            margin-bottom: 15px;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0,0,0,0.5);
        }
        
        .step-content p {
            font-size: 1.1rem;
            color: #ddd;
            line-height: 1.8;
            margin-bottom: 15px;
        }
        
        .step-content ul {
            margin-top: 10px;
            padding-left: 20px;
        }
        
        .step-content li {
            font-size: 1.05rem;
            color: #ccc;
            margin-bottom: 12px;
            line-height: 1.6;
            list-style: none;
            position: relative;
        }
        
        /* Dấu chấm đầu dòng */
        .step-content li::before {
            content: "✦"; /* Biểu tượng ngôi sao 4 cánh */
            color: #ffd700;
            position: absolute;
            left: -25px;
            top: 0;
        }
        
        /* --- TIPS BOX --- */
        .tips-box {
            background: rgba(255, 215, 0, 0.05); /* Nền vàng siêu mờ */
            border-left: 4px solid #ffd700;
            padding: 30px;
            border-radius: 0 15px 15px 0;
            margin-top: 50px;
        }
        
        .tips-box h4 {
            color: #ffd700;
            font-size: 1.4rem;
            margin-bottom: 20px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .tips-box ul {
            padding-left: 20px;
        }
        
        .tips-box li {
            color: #e0e0e0;
            margin-bottom: 10px;
            list-style: square; /* Dấu chấm vuông */
        }
        
        /* --- PAYMENT CARDS --- */
        .payment-methods {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        
        .payment-card {
            background: rgba(255, 255, 255, 0.05);
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }
        
        .payment-card:hover {
            transform: translateY(-5px);
            border-color: #ffd700;
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.15);
            background: rgba(255, 215, 0, 0.05);
        }
        
        .payment-card .icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
            filter: grayscale(100%); /* Mặc định đen trắng */
            transition: 0.3s;
        }
        
        .payment-card:hover .icon {
            filter: grayscale(0%); /* Hover thì hiện màu */
        }
        
        .payment-card h5 {
            color: #fff;
            font-size: 1rem;
            margin: 0;
        }
        
        /* --- CTA SECTION (BOTTOM) --- */
        .cta-section {
            text-align: center;
            margin-top: 60px;
            padding: 60px 40px;
            
            /* Gradient Vàng chéo */
            background: linear-gradient(135deg, #b38728 0%, #ffd700 100%);
            border-radius: 24px;
            color: #000; /* Chữ đen trên nền vàng */
            box-shadow: 0 10px 40px rgba(255, 215, 0, 0.2);
            position: relative;
            overflow: hidden;
        }
        
        /* Hiệu ứng bóng láng lướt qua */
        .cta-section::before {
            content: '';
            position: absolute;
            top: 0; left: -100%;
            width: 100%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
            animation: shine 3s infinite;
        }
        
        
        .cta-section h3 {
            font-size: 2.5rem;
            margin-bottom: 15px;
            font-weight: 800;
        }
        
        .btn-primary {
            padding: 16px 45px;
            background: #000; /* Nút đen */
            color: #ffd700; /* Chữ vàng */
            border: 1px solid #000;
            border-radius: 50px;
            font-size: 1.2rem;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            margin-top: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            position: relative;
            z-index: 2;
        }
        
        .btn-primary:hover {
            background: #fff; /* Hover thành trắng */
            color: #000; /* Chữ đen */
            transform: scale(1.05);
        }
        
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @media (max-width: 768px) {
            .step {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }
            .step:not(:last-child)::after {
                display: none; /* Ẩn đường nối trên mobile */
            }
            .page-header h1 {
                font-size: 2.2rem;
            }
            .tips-box {
                border-left: none;
                border-top: 4px solid #ffd700;
                border-radius: 15px;
            }
            .payment-methods {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/layout/header.jsp" %>
    
    <div class="container">
        <div class="page-header">
            <h1>Hướng Dẫn Đặt Vé</h1>
            <p>Sở hữu tấm vé nghệ thuật chỉ trong 3 bước đơn giản</p>
        </div>
        
        <div class="guide-section">
            <div class="step">
                <div class="step-number">1</div>
                <div class="step-content">
                    <h3>Chọn Show Yêu Thích</h3>
                    <p>Khám phá các tuyệt tác nghệ thuật đang được trình diễn.</p>
                    <ul>
                        <li>Xem trailer và mô tả chi tiết nội dung.</li>
                        <li>Kiểm tra thời gian, địa điểm và nghệ sĩ biểu diễn.</li>
                        <li>Đọc cảm nhận từ những khán giả đã thưởng thức.</li>
                    </ul>
                </div>
            </div>
            
            <div class="step">
                <div class="step-number">2</div>
                <div class="step-content">
                    <h3>Chọn Vị Trí & Hạng Vé</h3>
                    <p>Lựa chọn chỗ ngồi tốt nhất để thưởng thức trọn vẹn buổi diễn.</p>
                    <ul>
                        <li>Sơ đồ ghế trực quan, cập nhật theo thời gian thực.</li>
                        <li><strong>Ghế Vàng (VIP):</strong> Góc nhìn trung tâm, tặng kèm nước uống.</li>
                        <li><strong>Ghế Bạc:</strong> Tầm nhìn bao quát, giá cả hợp lý.</li>
                        <li>Hệ thống tự động giữ chỗ trong 10 phút.</li>
                    </ul>
                </div>
            </div>
            
            <div class="step">
                <div class="step-number">3</div>
                <div class="step-content">
                    <h3>Thanh Toán & Nhận Vé</h3>
                    <p>Hoàn tất giao dịch an toàn và nhận vé điện tử ngay lập tức.</p>
                    <ul>
                        <li>Hỗ trợ đa dạng phương thức thanh toán bảo mật.</li>
                        <li>Vé QR Code được gửi tự động qua Email.</li>
                        <li>Check-in tại rạp chỉ với 1 lần quét mã.</li>
                    </ul>
                    
                    <div class="payment-methods">
                        <div class="payment-card">
                            <div class="icon">💳</div>
                            <h5>Visa/Master</h5>
                        </div>
                        <div class="payment-card">
                            <div class="icon">🏦</div>
                            <h5>Internet Banking</h5>
                        </div>
                        <div class="payment-card">
                            <div class="icon">📱</div>
                            <h5>Momo/ZaloPay</h5>
                        </div>
                        <div class="payment-card">
                            <div class="icon">✨</div>
                            <h5>VNPAY-QR</h5>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="tips-box">
                <h4>💡 Lưu Ý Quan Trọng</h4>
                <ul>
                    <li><strong>Check-in sớm:</strong> Vui lòng đến trước 30 phút để ổn định chỗ ngồi.</li>
                    <li><strong>Trang phục:</strong> Khuyến khích trang phục lịch sự phù hợp không gian nghệ thuật.</li>
                    <li><strong>Vé điện tử:</strong> Không cần in vé, chỉ cần xuất trình mã QR trên điện thoại.</li>
                    <li><strong>Hotline VIP:</strong> 1900-9999 (Hỗ trợ 24/7).</li>
                </ul>
            </div>
        </div>
        
        <div class="cta-section">
            <h3>Sẵn Sàng Cho Đêm Nhạc?</h3>
            <p style="margin-bottom: 25px; opacity: 0.8;">Hàng ngàn khoảnh khắc thăng hoa đang chờ đón bạn.</p>
            <a href="${pageContext.request.contextPath}/shows" class="btn-primary">
                ĐẶT VÉ NGAY
            </a>
        </div>
    </div>
    
    <%@ include file="/WEB-INF/views/layout/footer.jsp" %>
</body>
</html>