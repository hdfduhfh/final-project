<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thành công | BookingStage</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>

    <style>
        :root {
            --gold: #D4AF37;
            --gold-light: #FDB931;
            --dark-bg: #0a0a0a;
            --card-bg: #161616;
            --text-gray: #a0a0a0;
            /* Font chủ đạo */
            --main-font: 'Playfair Display', serif; 
        }

        body {
            background-color: var(--dark-bg);
            background-image: radial-gradient(circle at top, #1a1a1a, #000);
            color: #fff;
            font-family: var(--main-font); /* Áp dụng font cho toàn trang */
            min-height: 100vh;
            margin: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px 20px;
        }

        /* --- Header Success --- */
        .success-header {
            text-align: center;
            margin-bottom: 40px;
            animation: fadeInDown 0.8s ease-out;
        }
        
        .check-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 0 30px rgba(212, 175, 55, 0.4);
        }
        
        .check-icon i { font-size: 40px; color: #000; }

        h1 {
            color: var(--gold);
            margin: 0;
            font-size: 36px; /* Font Playfair to đẹp hơn */
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .subtitle { 
            color: var(--text-gray); 
            margin-top: 10px; 
            font-size: 16px;
            font-style: italic; /* Chữ nghiêng nhẹ cho Playfair nhìn rất nghệ */
        }

        /* --- Main Layout --- */
        .content-wrapper {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 40px;
            max-width: 1000px;
            width: 100%;
        }

        /* --- Section: Order Summary --- */
        .order-summary {
            background: var(--card-bg);
            border-radius: 20px;
            padding: 30px;
            border: 1px solid #333;
            height: fit-content;
            animation: fadeInLeft 0.8s ease-out;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }

        .summary-header {
            color: var(--gold); 
            margin-bottom: 20px; 
            border-bottom: 1px solid #333; 
            padding-bottom: 15px;
            font-size: 22px;
            font-weight: 700;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px dashed #333;
            color: #ddd;
            font-size: 16px;
        }
        .summary-row:last-child { border-bottom: none; }
        .summary-row span:first-child { color: var(--text-gray); }
        .summary-row strong { 
            color: #fff; 
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .total-amount {
            font-size: 28px;
            color: var(--gold) !important;
            font-weight: 700;
        }

        /* --- Section: E-Ticket --- */
        .ticket-visual {
            position: relative;
            background: white;
            color: #000;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0,0,0,0.5);
            animation: fadeInUp 1s ease-out;
            filter: drop-shadow(0 0 15px rgba(255,255,255,0.15));
        }

        .ticket-top {
            padding: 25px 20px;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            text-align: center;
            border-bottom: 2px dashed #000;
            position: relative;
        }
        
        /* Vết xé vé */
        .ticket-top::before, .ticket-top::after {
            content: '';
            position: absolute;
            bottom: -10px;
            width: 20px;
            height: 20px;
            background: var(--dark-bg);
            border-radius: 50%;
        }
        .ticket-top::before { left: -10px; }
        .ticket-top::after { right: -10px; }

        .movie-title {
            font-weight: 700;
            font-size: 22px;
            margin-bottom: 5px;
            text-transform: uppercase;
        }
        
        .cinema-name {
            font-size: 12px; 
            letter-spacing: 2px; 
            text-transform: uppercase;
        }

        .ticket-body {
            padding: 25px 20px;
            background: #fff;
            text-align: center;
        }

        .qr-placeholder {
            margin: 10px auto;
            width: 160px;
            height: 160px;
        }
        .qr-placeholder img { width: 100%; height: 100%; object-fit: contain; }

        .seat-info {
            display: flex;
            justify-content: space-around;
            margin-top: 20px;
            border-top: 1px solid #ddd;
            padding-top: 15px;
        }
        .seat-box div:first-child { 
            font-size: 12px; 
            color: #666; 
            text-transform: uppercase; 
            margin-bottom: 5px;
        }
        .seat-box div:last-child { 
            font-size: 20px; 
            font-weight: 700; 
            color: #000; 
        }

        /* --- Buttons --- */
        .action-buttons {
            grid-column: 1 / -1;
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 35px;
            border-radius: 50px; /* Bo tròn mềm mại */
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            text-transform: uppercase;
            font-size: 14px;
            letter-spacing: 1px;
        }
        .btn-home { border: 1px solid #555; color: #fff; }
        .btn-home:hover { background: #fff; color: #000; }
        
        .btn-primary { 
            background: var(--gold); 
            color: #000; 
            box-shadow: 0 0 20px rgba(212, 175, 55, 0.3); 
        }
        .btn-primary:hover { 
            transform: translateY(-3px); 
            box-shadow: 0 0 30px rgba(212, 175, 55, 0.6); 
        }

        /* Responsive */
        @media (max-width: 768px) {
            .content-wrapper { grid-template-columns: 1fr; }
            .ticket-visual { max-width: 350px; margin: 0 auto; }
        }

        @keyframes fadeInDown { from { opacity: 0; transform: translateY(-30px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes fadeInLeft { from { opacity: 0; transform: translateX(-30px); } to { opacity: 1; transform: translateX(0); } }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>

    <div class="success-header">
        <div class="check-icon"><i class="fas fa-check"></i></div>
        <h1>Đặt Vé Thành Công!</h1>
        <p class="subtitle">Cảm ơn bạn đã lựa chọn BookingStage cho trải nghiệm nghệ thuật này.</p>
    </div>

    <div class="content-wrapper">
        <div class="order-summary">
            <div class="summary-header">
                Chi tiết giao dịch
            </div>
            
            <div class="summary-row">
                <span>Khách hàng</span>
                <strong>${sessionScope.user.fullName}</strong> 
            </div>
            <div class="summary-row">
                <span>Mã đơn hàng</span>
                <strong>#${order.orderID}</strong>
            </div>
            <div class="summary-row">
                <span>Thời gian đặt</span>
                <strong><fmt:formatDate value="${order.createdAt}" pattern="HH:mm - dd/MM/yyyy"/></strong>
            </div>
            <div class="summary-row">
                <span>Phương thức</span>
                <strong style="text-transform: uppercase;">${order.paymentMethod}</strong>
            </div>
            <div class="summary-row">
                <span>Trạng thái</span>
                <strong style="color: #2ecc71;">Đã Thanh Toán</strong>
            </div>

            <c:if test="${not empty orderDetails}">
                <c:forEach var="detail" items="${orderDetails}">
                    <div class="summary-row">
                        <span>Vé (${detail.seatID.seatType})</span>
                        <span>Ghế <strong>${detail.seatID.seatNumber}</strong></span>
                    </div>
                </c:forEach>
            </c:if>

            <div class="summary-row" style="margin-top: 20px; border-top: 1px solid #444; padding-top: 20px; border-bottom: none;">
                <span style="font-size: 18px;">TỔNG CỘNG</span>
                <strong class="total-amount"><fmt:formatNumber value="${order.finalAmount}" type="number" maxFractionDigits="0"/> Đ</strong>
            </div>
        </div>

<div class="ticket-visual">
            <c:if test="${not empty orderDetails}">
                <c:set var="firstTicket" value="${orderDetails[0]}" />

                <c:set var="qrDate">
                    <fmt:formatDate value="${firstTicket.scheduleID.showTime}" pattern="dd/MM/yyyy HH:mm"/>
                </c:set>

                <c:set var="rawQrString" value="#${firstTicket.scheduleID.scheduleID}TICKET-${order.orderID}-${firstTicket.orderDetailID} ${firstTicket.scheduleID.showID.showName} ${qrDate} ${firstTicket.seatID.seatNumber} ${sessionScope.user.fullName} VALID" />

                <c:url value="https://api.qrserver.com/v1/create-qr-code/" var="encodedQrUrl">
                    <c:param name="size" value="160x160"/>
                    <c:param name="charset-source" value="UTF-8"/>
                    <c:param name="data" value="${rawQrString}"/>
                </c:url>

                <div class="ticket-top">
                    <div class="movie-title">${firstTicket.scheduleID.showID.showName}</div>
                    <div class="cinema-name">BOOKING STAGE CINEMA</div>
                </div>
                <div class="ticket-body">
                    <div style="color: #555; font-size: 14px; margin-bottom: 10px; font-style: italic;">Quét mã này tại quầy soát vé</div>
                    
                    <div class="qr-placeholder">
                        <img src="${encodedQrUrl}" alt="QR Ticket">
                    </div>

                    <div class="seat-info">
                        <div class="seat-box">
                            <div>NGÀY</div>
                            <div><fmt:formatDate value="${firstTicket.scheduleID.showTime}" pattern="dd/MM"/></div>
                        </div>
                        <div class="seat-box">
                            <div>GIỜ</div>
                            <div><fmt:formatDate value="${firstTicket.scheduleID.showTime}" pattern="HH:mm"/></div>
                        </div>
                        <div class="seat-box">
                            <div>SỐ VÉ</div>
                            <div>${orderDetails.size()}</div>
                        </div>
                    </div>
                    
                    <div style="margin-top: 15px; font-size: 10px; color: #aaa; word-break: break-all; padding: 0 10px;">
                        ${firstTicket.scheduleID.scheduleID}-${order.orderID}-${firstTicket.orderDetailID}
                    </div>

                    <div style="margin-top: 10px; font-size: 13px; color: #888;">
                        Vui lòng đến trước giờ chiếu 15 phút.
                    </div>
                </div>
            </c:if>
        </div>

        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/" class="btn btn-home">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/my-tickets" class="btn btn-primary">
                Xem vé của tôi
            </a>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var count = 200;
            var defaults = { origin: { y: 0.7 } };

            function fire(particleRatio, opts) {
                confetti(Object.assign({}, defaults, opts, {
                    particleCount: Math.floor(count * particleRatio)
                }));
            }

            fire(0.25, { spread: 26, startVelocity: 55 });
            fire(0.2, { spread: 60 });
            fire(0.35, { spread: 100, decay: 0.91, scalar: 0.8 });
            fire(0.1, { spread: 120, startVelocity: 25, decay: 0.92, scalar: 1.2 });
            fire(0.1, { spread: 120, startVelocity: 45 });
        });
    </script>
</body>
</html>