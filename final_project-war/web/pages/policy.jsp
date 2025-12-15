<%-- 
    Document   : policy
    Created on : Dec 11, 2025, 2:22:29 PM
    Author     : DANG KHOA
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chính sách đổi/trả vé - BookingStage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding-top: 80px;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 50px;
            animation: fadeInDown 0.8s ease;
        }
        
        .page-header h1 {
            font-size: 3rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 15px;
        }
        
        .page-header p {
            font-size: 1.2rem;
            color: #64748b;
        }
        
        .policy-section {
            background: white;
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            animation: fadeInUp 0.8s ease;
        }
        
        .policy-section h2 {
            font-size: 1.8rem;
            color: #1e293b;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 3px solid #667eea;
        }
        
        .policy-section h3 {
            font-size: 1.4rem;
            color: #334155;
            margin-top: 30px;
            margin-bottom: 15px;
        }
        
        .policy-section p {
            font-size: 1.1rem;
            color: #64748b;
            line-height: 1.8;
            margin-bottom: 15px;
        }
        
        .policy-section ul, .policy-section ol {
            margin: 15px 0;
            padding-left: 30px;
        }
        
        .policy-section li {
            font-size: 1.05rem;
            color: #64748b;
            margin-bottom: 12px;
            line-height: 1.7;
        }
        
        .policy-section strong {
            color: #1e293b;
        }
        
        .highlight-box {
            background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
            border-left: 5px solid #3b82f6;
            padding: 25px;
            border-radius: 15px;
            margin: 25px 0;
        }
        
        .highlight-box h4 {
            color: #1e40af;
            font-size: 1.3rem;
            margin-bottom: 15px;
        }
        
        .warning-box {
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            border-left: 5px solid #ef4444;
            padding: 25px;
            border-radius: 15px;
            margin: 25px 0;
        }
        
        .warning-box h4 {
            color: #991b1b;
            font-size: 1.3rem;
            margin-bottom: 15px;
        }
        
        .success-box {
            background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
            border-left: 5px solid #10b981;
            padding: 25px;
            border-radius: 15px;
            margin: 25px 0;
        }
        
        .success-box h4 {
            color: #065f46;
            font-size: 1.3rem;
            margin-bottom: 15px;
        }
        
        .timeline {
            display: flex;
            justify-content: space-between;
            margin: 30px 0;
            flex-wrap: wrap;
            gap: 20px;
        }
        
        .timeline-item {
            flex: 1;
            min-width: 200px;
            text-align: center;
            padding: 20px;
            background: #f8fafc;
            border-radius: 15px;
            border: 2px solid #e2e8f0;
        }
        
        .timeline-item .icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        
        .timeline-item .title {
            font-weight: bold;
            color: #1e293b;
            margin-bottom: 8px;
            font-size: 1.1rem;
        }
        
        .timeline-item .desc {
            color: #64748b;
            font-size: 0.95rem;
        }
        
        .contact-section {
            text-align: center;
            margin-top: 50px;
            padding: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            color: white;
        }
        
        .contact-section h3 {
            font-size: 2rem;
            margin-bottom: 20px;
        }
        
        .contact-info {
            display: flex;
            justify-content: center;
            gap: 40px;
            flex-wrap: wrap;
            margin-top: 30px;
        }
        
        .contact-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.1rem;
        }
        
        .contact-item .icon {
            font-size: 1.5rem;
        }
        
        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @media (max-width: 768px) {
            .page-header h1 {
                font-size: 2rem;
            }
            
            .timeline {
                flex-direction: column;
            }
            
            .contact-info {
                flex-direction: column;
                gap: 20px;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/layout/header.jsp" %>
    
    <div class="container">
        <div class="page-header">
            <h1>🔄 Chính Sách Đổi/Trả Vé</h1>
            <p>Quy định về việc đổi và hoàn vé tại BookingStage</p>
        </div>
        
        <div class="policy-section">
            <h2>📋 Điều Kiện Đổi/Trả Vé</h2>
            
            <div class="highlight-box">
                <h4>✅ Trường Hợp Được Chấp Nhận</h4>
                <ul>
                    <li>Show bị hủy hoặc hoãn do ban tổ chức</li>
                    <li>Thay đổi thời gian, địa điểm không được thông báo trước</li>
                    <li>Vé bị lỗi kỹ thuật (không quét được QR code)</li>
                    <li>Khách hàng có lý do bất khả kháng (giấy tờ chứng minh)</li>
                </ul>
            </div>
            
            <div class="warning-box">
                <h4>❌ Trường Hợp Không Chấp Nhận</h4>
                <ul>
                    <li>Thay đổi ý định sau khi đã mua vé</li>
                    <li>Vé đã được sử dụng để check-in</li>
                    <li>Quá thời hạn hoàn vé (dưới 24h trước show)</li>
                    <li>Vé khuyến mãi, vé giảm giá đặc biệt</li>
                    <li>Thông tin khách hàng không khớp với vé</li>
                </ul>
            </div>
            
            <h2>⏰ Thời Hạn Đổi/Trả Vé</h2>
            
            <div class="timeline">
                <div class="timeline-item">
                    <div class="icon">💯</div>
                    <div class="title">≥ 7 ngày trước</div>
                    <div class="desc">Hoàn 100% giá vé</div>
                </div>
                <div class="timeline-item">
                    <div class="icon">💰</div>
                    <div class="title">3-7 ngày trước</div>
                    <div class="desc">Hoàn 70% giá vé</div>
                </div>
                <div class="timeline-item">
                    <div class="icon">💸</div>
                    <div class="title">1-3 ngày trước</div>
                    <div class="desc">Hoàn 50% giá vé</div>
                </div>
                <div class="timeline-item">
                    <div class="icon">🚫</div>
                    <div class="title">< 24 giờ trước</div>
                    <div class="desc">Không hoàn vé</div>
                </div>
            </div>
            
            <h2>📝 Quy Trình Đổi/Trả Vé</h2>
            
            <h3>1. Gửi Yêu Cầu</h3>
            <ul>
                <li>Truy cập <strong>Tài khoản của tôi</strong> → <strong>Lịch sử đặt vé</strong></li>
                <li>Chọn vé cần đổi/trả và nhấn <strong>"Yêu cầu hoàn vé"</strong></li>
                <li>Hoặc gửi email đến: <strong>support@bookingstage.vn</strong></li>
                <li>Hoặc gọi hotline: <strong>1900-xxxx</strong></li>
            </ul>
            
            <h3>2. Cung Cấp Thông Tin</h3>
            <ul>
                <li>Mã đơn hàng (Order ID)</li>
                <li>Email đặt vé</li>
                <li>Số điện thoại liên hệ</li>
                <li>Lý do đổi/trả vé</li>
                <li>Giấy tờ chứng minh (nếu có)</li>
            </ul>
            
            <h3>3. Xét Duyệt Yêu Cầu</h3>
            <p>Chúng tôi sẽ xem xét yêu cầu trong vòng <strong>24-48 giờ</strong> làm việc và thông báo kết quả qua email/SMS.</p>
            
            <h3>4. Hoàn Tiền</h3>
            <ul>
                <li><strong>Thẻ tín dụng/ATM:</strong> 7-14 ngày làm việc</li>
                <li><strong>Ví điện tử:</strong> 3-5 ngày làm việc</li>
                <li><strong>Chuyển khoản:</strong> 5-7 ngày làm việc</li>
            </ul>
            
            <div class="success-box">
                <h4>💡 Lưu Ý Quan Trọng</h4>
                <ul>
                    <li>Phí xử lý đổi/trả vé: <strong>10.000đ/vé</strong></li>
                    <li>Số tiền hoàn được tính sau khi trừ phí xử lý</li>
                    <li>Vé đã hoàn không thể sử dụng lại</li>
                    <li>Mỗi đơn hàng chỉ được đổi/trả <strong>1 lần duy nhất</strong></li>
                    <li>Giữ nguyên vé điện tử cho đến khi nhận được xác nhận hoàn tiền</li>
                </ul>
            </div>
            
            <h2>🎁 Đổi Sang Suất Chiếu Khác</h2>
            <p>Nếu bạn muốn đổi sang suất chiếu hoặc show khác (cùng giá hoặc cao hơn):</p>
            <ol>
                <li>Liên hệ hotline trước <strong>48 giờ</strong></li>
                <li>Chọn suất/show mới còn ghế trống</li>
                <li>Phí đổi vé: <strong>20.000đ/vé</strong></li>
                <li>Bù thêm tiền nếu vé mới đắt hơn</li>
                <li>Nhận vé mới qua email trong 2-4 giờ</li>
            </ol>
        </div>
        
        <div class="contact-section">
            <h3>Cần Hỗ Trợ Đổi/Trả Vé?</h3>
            <p style="margin-bottom: 20px; opacity: 0.9;">Liên hệ ngay với chúng tôi để được hỗ trợ nhanh chóng</p>
            <div class="contact-info">
                <div class="contact-item">
                    <span class="icon">📞</span>
                    <span>Hotline: 1900-xxxx</span>
                </div>
                <div class="contact-item">
                    <span class="icon">✉️</span>
                    <span>support@bookingstage.vn</span>
                </div>
                <div class="contact-item">
                    <span class="icon">🕐</span>
                    <span>8:00 - 22:00 hàng ngày</span>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="/WEB-INF/views/layout/footer.jsp" %>
</body>
</html>
