<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt vé thành công | BookingStage</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <style>
        /* --- 1. CẤU HÌNH CHUNG --- */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Roboto', sans-serif; 
            min-height: 100vh;
            color: #fff;
            background-color: #050505;
            background-image:
                radial-gradient(circle at 50% 0%, rgba(255, 215, 0, 0.15) 0%, transparent 60%),
                linear-gradient(0deg, #000000 0%, #1a1a1a 100%);
            background-attachment: fixed;
            padding: 20px;
        }

        /* --- 2. CONTAINER CHÍNH --- */
        .container {
            max-width: 800px;
            margin: 40px auto;
            background: rgba(20, 20, 20, 0.6);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 215, 0, 0.2);
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
            animation: slideUp 0.6s cubic-bezier(0.2, 0.8, 0.2, 1);
        }

        @keyframes slideUp {
            from { transform: translateY(30px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        /* --- 3. HEADER SUCCESS --- */
        .success-icon {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .success-icon .icon {
            font-size: 60px;
            margin-bottom: 20px;
            text-shadow: 0 0 30px rgba(40, 167, 69, 0.6);
        }

        h1 {
            font-family: 'Playfair Display', serif;
            background: linear-gradient(135deg, #FFD700 0%, #FDB931 50%, #FFD700 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 38px;
            text-transform: uppercase;
            margin-bottom: 10px;
            letter-spacing: 1px;
        }

        .subtitle {
            color: #ccc;
            font-size: 16px;
            font-weight: 300;
        }

        /* --- 4. THÔNG TIN ĐƠN HÀNG --- */
        .order-info {
            background: rgba(255, 255, 255, 0.03);
            padding: 30px;
            border-radius: 16px;
            margin-bottom: 30px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .order-info h3 {
            font-family: 'Playfair Display', serif;
            color: #FFD700;
            margin-bottom: 20px;
            font-size: 22px;
            border-bottom: 1px solid rgba(255, 215, 0, 0.2);
            padding-bottom: 10px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            color: #ddd;
        }
        .info-row:last-child { border-bottom: none; }

        .info-label { color: #888; }
        .info-value { text-align: right; font-weight: 500; }
        .info-value strong { color: #fff; letter-spacing: 1px; }

        /* Status Badge */
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .status-pending {
            background: rgba(255, 193, 7, 0.15);
            color: #ffc107;
            border: 1px solid rgba(255, 193, 7, 0.3);
        }
        .status-confirmed {
            background: rgba(40, 167, 69, 0.15);
            color: #28a745;
            border: 1px solid rgba(40, 167, 69, 0.3);
        }

        /* --- 5. NOTICE --- */
        .notice {
            background: rgba(255, 215, 0, 0.05);
            border: 1px solid rgba(255, 215, 0, 0.2);
            padding: 20px;
            border-radius: 12px;
            margin: 30px 0;
        }
        
        .notice-title {
            font-weight: 700;
            color: #FFD700;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-family: 'Playfair Display', serif;
            font-size: 18px;
        }
        
        .notice-text {
            color: #ccc;
            font-size: 14px;
            line-height: 1.6;
        }

        /* --- 6. DANH SÁCH VÉ --- */
        .ticket-list h3 {
            font-family: 'Playfair Display', serif;
            color: #fff;
            margin-bottom: 20px;
            font-size: 22px;
        }

        .ticket-item {
            background: linear-gradient(145deg, #1a1a1a, #222);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 15px;
            position: relative;
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        .ticket-item:hover {
            transform: translateY(-2px);
            border-color: rgba(255, 215, 0, 0.3);
        }
        /* Decor trang trí vé */
        .ticket-item::before {
            content: '';
            position: absolute;
            left: -10px; top: 50%; transform: translateY(-50%);
            width: 20px; height: 20px; background: #050505; border-radius: 50%;
        }
        .ticket-item::after {
            content: '';
            position: absolute;
            right: -10px; top: 50%; transform: translateY(-50%);
            width: 20px; height: 20px; background: #050505; border-radius: 50%;
        }

        .ticket-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            border-bottom: 1px dashed rgba(255, 255, 255, 0.1);
            padding-bottom: 15px;
        }

        .seat-number {
            font-family: 'Playfair Display', serif;
            font-size: 24px;
            font-weight: 700;
            color: #FFD700;
        }

        .ticket-info {
            color: #999;
            font-size: 14px;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .price-display {
            font-size: 20px;
            font-weight: 700;
            color: #fff;
        }

        /* --- 7. TỔNG TIỀN --- */
        .total-section {
            background: linear-gradient(to right, rgba(255, 255, 255, 0.02), rgba(255, 215, 0, 0.05));
            border: 1px solid rgba(255, 255, 255, 0.05);
            padding: 25px;
            border-radius: 12px;
            margin-top: 30px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 16px;
            color: #ccc;
        }

        .total-row.final {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 18px;
            color: #fff;
            align-items: center;
        }
        .total-row.final span:first-child {
            font-family: 'Playfair Display', serif;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .total-row.final span:last-child {
            font-size: 28px;
            font-weight: 700;
            color: #FFD700;
        }

        /* --- 8. BUTTONS --- */
        .actions {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 40px;
        }

        .btn {
            padding: 12px 30px;
            border-radius: 50px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-primary {
            background: linear-gradient(90deg, #FDB931 0%, #FFD700 50%, #FDB931 100%);
            background-size: 200% auto;
            color: #000;
            border: none;
            box-shadow: 0 0 20px rgba(255, 215, 0, 0.4);
        }
        .btn-primary:hover {
            background-position: right center;
            transform: translateY(-2px);
            box-shadow: 0 0 30px rgba(255, 215, 0, 0.6);
        }

        .btn-secondary {
            background: transparent;
            color: #aaa;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .btn-secondary:hover {
            color: #fff;
            border-color: #fff;
            background: rgba(255, 255, 255, 0.05);
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>

    <div class="container">
        <div class="success-icon">
            <div class="icon">✅</div>
            <h1>Đặt vé thành công!</h1>
            <p class="subtitle">Cảm ơn bạn đã lựa chọn BookingStage cho trải nghiệm nghệ thuật này.</p>
        </div>
        
        <div class="order-info">
            <h3>📋 Thông tin đơn hàng</h3>
            <div class="info-row">
                <span class="info-label">Mã đơn hàng:</span>
                <span class="info-value"><strong>#${order.orderID}</strong></span>
            </div>
            <div class="info-row">
                <span class="info-label">Ngày đặt:</span>
                <span class="info-value">
                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">Trạng thái:</span>
                <span class="info-value">
                    <span class="status-badge ${order.status == 'CONFIRMED' ? 'status-confirmed' : 'status-pending'}">
                        <c:choose>
                            <c:when test="${order.status == 'CONFIRMED'}">✓ Đã xác nhận</c:when>
                            <c:otherwise>⏳ Đang chờ xác nhận</c:otherwise>
                        </c:choose>
                    </span>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">Thanh toán:</span>
                <span class="info-value" style="color: #FFD700;">${order.paymentMethod}</span>
            </div>
        </div>
        
        <div class="notice">
            <div class="notice-title">⏰ Lưu ý quan trọng</div>
            <div class="notice-text">
                <c:choose>
                    <c:when test="${order.status == 'CONFIRMED'}">
                        • Vé điện tử của bạn đã được kích hoạt thành công.<br>
                        • Vui lòng xuất trình mã QR hoặc vé điện tử tại quầy soát vé.<br>
                        • Bạn có thể xem lại chi tiết trong mục "Lịch sử vé".
                    </c:when>
                    <c:otherwise>
                        • Đơn hàng của bạn đang được hệ thống xử lý.<br>
                        • Chúng tôi sẽ gửi thông báo xác nhận trong thời gian sớm nhất.<br>
                        • Vui lòng kiểm tra email hoặc mục "Lịch sử vé" để cập nhật trạng thái.
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <c:if test="${not empty orderDetails}">
            <div class="ticket-list">
                <h3>🎫 Vé đã đặt</h3>
                <c:forEach var="detail" items="${orderDetails}">
                    <div class="ticket-item">
                        <div class="ticket-header">
                            <div>
                                <div class="seat-number">Ghế ${detail.seatID.seatNumber}</div>
                                <div class="ticket-info">
                                    <c:choose>
                                        <c:when test="${detail.seatID.seatType == 'VIP'}"><span style="color: #FFD700;">👑 VIP Class</span></c:when>
                                        <c:otherwise><span>🪑 Standard Class</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div style="text-align: right;">
                                <div class="price-display">
                                    <fmt:formatNumber value="${detail.price}" type="number" maxFractionDigits="0"/> đ
                                </div>
                            </div>
                        </div>
                        <div class="ticket-info">🎭 ${detail.scheduleID.showID.showName}</div>
                        <div class="ticket-info">📅 <fmt:formatDate value="${detail.scheduleID.showTime}" pattern="HH:mm - dd/MM/yyyy"/></div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        
        <div class="total-section">
            <div class="total-row">
                <span>Tạm tính:</span>
                <span><fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> đ</span>
            </div>
            <c:if test="${order.discountAmount > 0}">
                <div class="total-row">
                    <span>Giảm giá:</span>
                    <span style="color: #28a745;">- <fmt:formatNumber value="${order.discountAmount}" type="number" maxFractionDigits="0"/> đ</span>
                </div>
            </c:if>
            <div class="total-row final">
                <span>Tổng thanh toán:</span>
                <span><fmt:formatNumber value="${order.finalAmount}" type="number" maxFractionDigits="0"/> đ</span>
            </div>
        </div>
        
        <div class="actions">
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">🏠 Về trang chủ</a>
            <a href="${pageContext.request.contextPath}/my-tickets" class="btn btn-primary">🎟️ Xem vé của tôi</a>
        </div>
    </div>
</body>
</html>