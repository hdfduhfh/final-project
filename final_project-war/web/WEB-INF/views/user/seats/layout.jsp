<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đặt vé Thượng Hạng - BookingStage</title>

        <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;800&family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

        <style>
            :root {
                --gold-primary: #FFD700; 
                --gold-dark: #d4af37;
                --gold-light: #fff5cc;
                --text-main: #ffffff;
                --seat-vip-bg: linear-gradient(135deg, #FFD700 0%, #B8860B 100%);
                --seat-norm-bg: linear-gradient(135deg, #4a4a4a 0%, #2c2c2c 100%);
                --seat-booked: #1a1a1a;
                --seat-selected: #00ffd5;
                --seat-reserved: linear-gradient(135deg, #d35400 0%, #a04000 100%);
                --shadow-seat: 0 4px 8px rgba(0,0,0,0.8);
                --glow-cyan: 0 0 15px rgba(0, 255, 213, 0.7);
                --glow-gold: 0 0 10px rgba(255, 215, 0, 0.6);
            }

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Playfair Display', sans-serif;
                color: var(--text-main);
                min-height: 100vh;
                padding-bottom: 20px;
                background-color: #000;
                background-image:
                    linear-gradient(to bottom, rgba(0,0,0,0.5) 0%, #000 100%),
                    url('${pageContext.request.contextPath}/assets/images/background-book.png');
                background-size: cover;
                background-position: center top;
                background-repeat: no-repeat;
                background-attachment: fixed;
                overflow-x: hidden;
                position: relative;
            }

            .header-section {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding: 15px 0;
                border-bottom: 1px solid rgba(255, 215, 0, 0.2);
                position: relative;
            }

            .btn-home-minimal {
                position: absolute;
                left: 0;
                top: 50%;
                transform: translateY(-50%);
                z-index: 10;
                display: flex;
                align-items: center;
                gap: 10px;
                text-decoration: none;
                opacity: 0.9;
                transition: all 0.4s ease;
                cursor: pointer;
                padding-right: 20px;
            }

            .btn-home-minimal svg {
                width: 22px;
                height: 22px;
                fill: var(--gold-primary);
                filter: drop-shadow(0 0 5px rgba(255, 215, 0, 0.5));
                transition: transform 0.3s ease;
            }

            .btn-home-minimal span {
                font-family: 'Cinzel', serif; 
                color: var(--gold-primary);
                font-size: 14px;
                letter-spacing: 3px;
                text-transform: uppercase;
                font-weight: 700;
                text-shadow: 0 0 8px rgba(255, 215, 0, 0.4);
                position: relative;
            }

            .btn-home-minimal span::after {
                content: '';
                position: absolute;
                bottom: -6px;
                left: 0;
                width: 0%;
                height: 2px;
                background: linear-gradient(90deg, transparent, var(--gold-primary), transparent);
                transition: width 0.4s ease;
            }

            .btn-home-minimal:hover { opacity: 1; }
            .btn-home-minimal:hover span::after { width: 100%; }
            .btn-home-minimal:hover svg { transform: scale(1.1); filter: drop-shadow(0 0 10px rgba(255, 215, 0, 0.8)); }

            .header-title-container {
                flex-grow: 1;
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 15px;
            }

            .header-icon {
                font-size: 32px;
                filter: drop-shadow(0 0 8px rgba(255, 215, 0, 0.6));
            }

            .header-section h2 {
                color: var(--gold-primary);
                font-family: 'Playfair Display', serif;
                font-size: 34px;
                text-transform: uppercase;
                letter-spacing: 2px;
                text-shadow: 0 0 15px rgba(212, 175, 55, 0.6);
                margin: 0;
            }

            .header-right {
                display: flex;
                align-items: center;
                gap: 20px;
                position: absolute;
                right: 0;
                top: 50%;
                transform: translateY(-50%);
            }

            .fog-container {
                position: absolute;
                top: 0; left: 0; width: 100%; height: 100%;
                overflow: hidden;
                z-index: 1; pointer-events: none;
            }
            .fog-img {
                position: absolute;
                height: 100vh; width: 300vw;
                z-index: 1; opacity: 0.5;
                background-image: url('${pageContext.request.contextPath}/assets/images/fog.png');
                background-size: contain; background-repeat: repeat-x;
            }
            .fog-img-first { animation: fog-drift 60s linear infinite; }
            .fog-img-second { top: 20%; opacity: 0.3; animation: fog-drift-reverse 40s linear infinite; }
            @keyframes fog-drift { from { transform: translate3d(0, 0, 0); } to { transform: translate3d(-50vw, 0, 0); } }
            @keyframes fog-drift-reverse { from { transform: translate3d(-50vw, 0, 0); } to { transform: translate3d(0, 0, 0); } }

            .container {
                max-width: 1400px; margin: 0 auto; padding: 10px 20px;
                position: relative; z-index: 5;
            }

            .controls-area {
                margin-bottom: 10px; padding: 15px 25px;
                background: rgba(10, 10, 10, 0.9);
                border: 1px solid rgba(255, 215, 0, 0.15);
                border-radius: 4px;
                display: flex; justify-content: space-between; align-items: center;
                backdrop-filter: blur(10px);
                box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            }

            #scheduleSelect {
                padding: 10px 20px;
                border-radius: 2px;
                background: #000;
                color: var(--gold-primary);
                border: 1px solid var(--gold-dark);
                font-family: 'Roboto', sans-serif;
                font-weight: 500;
                cursor: pointer;
                outline: none;
                transition: 0.3s;
            }
            #scheduleSelect:hover, #scheduleSelect:focus {
                border-color: var(--gold-primary);
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.2);
            }

            .btn-cart {
                background: var(--gold-primary);
                color: #1a1a1a;
                padding: 10px 25px;
                text-decoration: none;
                font-weight: 800;
                border-radius: 2px;
                transition: all 0.3s;
                font-family: 'Cinzel', serif;
                letter-spacing: 1px;
                text-transform: uppercase;
                border: 1px solid var(--gold-primary);
            }
            .btn-cart:hover {
                background: transparent;
                color: var(--gold-primary);
                box-shadow: var(--glow-gold);
                text-shadow: 0 0 5px var(--gold-primary);
            }

            .legend { display: flex; gap: 20px; }
            .legend-item {
                display: flex; align-items: center; gap: 10px;
                font-size: 13px; color: #ddd; 
                text-transform: uppercase; font-family: 'Roboto', sans-serif;
            }
            .box-sample { width: 18px; height: 18px; border-radius: 3px; box-shadow: 0 2px 4px #000;}
            .bg-vip { background: var(--seat-vip-bg); }
            .bg-norm { background: var(--seat-norm-bg); }
            .bg-book { background: var(--seat-booked); border: 1px solid #444; }
            .bg-res { background: var(--seat-reserved); }
            .bg-sel { background: var(--seat-selected); box-shadow: var(--glow-cyan); }

            .stadium-container {
                display: flex; justify-content: center;
                perspective: 1600px;
                margin-top: 40px; padding-bottom: 100px;
            }

            .grid-layout {
                display: grid;
                grid-template-areas:
                    "stage stage stage"
                    "left center right"
                    "gap gap gap"
                    "balcony balcony balcony";
                grid-template-columns: 220px 500px 220px;
                gap: 20px 40px;
                transform-style: preserve-3d;
                align-items: end; 
            }

            .stage-center {
                grid-area: stage; width: 75%; margin: 0 auto 60px auto; height: 80px;
                background: linear-gradient(to bottom, #e0e0e0 0%, #333 100%);
                box-shadow: 0 -10px 50px rgba(255, 255, 255, 0.15);
                border-radius: 50% 50% 0 0 / 25px 25px 0 0;
                transform: rotateX(20deg); 
                display: flex; flex-direction: column; justify-content: center; align-items: center;
                position: relative; z-index: 10; border-bottom: 2px solid var(--gold-primary);
            }
            .stage-text {
                color: #000; font-weight: 800; letter-spacing: 6px;
                font-size: 18px; font-family: 'Cinzel', serif;
            }

            .seat-section {
                padding: 20px; display: flex; flex-wrap: wrap; justify-content: center;
                gap: 8px; background: rgba(30, 30, 30, 0.6); 
                border: 1px solid rgba(255, 215, 0, 0.1);
                border-radius: 6px; position: relative;
                transition: transform 0.3s;
            }
            
            .section-title {
                width: 100%; text-align: center;
                color: var(--gold-primary); font-size: 14px;
                margin-bottom: 15px; letter-spacing: 3px;
                text-transform: uppercase; font-weight: 700;
                font-family: 'Cinzel', serif; text-shadow: 0 0 5px rgba(0,0,0,0.8);
            }

            .area-left { grid-area: left; transform: rotateY(15deg) translateZ(10px); transform-origin: right center; }
            .area-top { 
                grid-area: center; transform: translateZ(40px); z-index: 50;
                background: rgba(50, 40, 10, 0.4); border: 1px solid rgba(255, 215, 0, 0.3);
            }
            .area-right { grid-area: right; transform: rotateY(-15deg) translateZ(10px); transform-origin: left center; }
            .area-bottom {
                grid-area: balcony; margin-top: 50px; padding-top: 30px;
                border-top: 4px solid var(--gold-primary);
                background: linear-gradient(to bottom, #111, #000);
                border-radius: 50% 50% 10px 10px / 40px 40px 10px 10px;
                transform: translateZ(60px) scale(1.05);
                box-shadow: 0 -20px 50px rgba(0,0,0,0.8);
            }

            .seat {
                width: 38px; height: 38px;
                border-radius: 4px 4px 10px 10px;
                display: flex; align-items: center; justify-content: center;
                cursor: pointer; transition: all 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                box-shadow: 0 3px 6px rgba(0,0,0,0.9);
                color: #888; font-size: 11px; font-weight: 500;
                position: relative; z-index: 100;
            }
            .seat:hover:not(.booked):not(.reserved) {
                transform: scale(1.4) translateY(-8px); z-index: 9999;
                box-shadow: 0 0 20px rgba(255,255,255,0.8); 
                border: 1px solid #fff; color: #fff; background: #555;
            }
            .seat.vip { background: var(--seat-vip-bg); color: #423105; font-weight: 800; border-top: 1px solid rgba(255,255,255,0.5); }
            .seat.normal { background: var(--seat-norm-bg); border: 1px solid #444; }
            .seat.booked { background: var(--seat-booked); color: #444; cursor: not-allowed; border: 1px solid #222; box-shadow: none; pointer-events: none; }
            .seat.reserved { background: var(--seat-reserved) !important; color: #fff !important; pointer-events: none; }
            .seat.in-cart { background: var(--seat-selected); color: #000; font-weight: bold; box-shadow: var(--glow-cyan); transform: scale(1.15); z-index: 200; }

            .notification {
                background: rgba(10, 10, 10, 0.95); 
                border-left: 5px solid var(--gold-primary);
                color: #fff; 
                position: fixed; top: 30px; right: 30px;
                padding: 20px 30px; border-radius: 4px; display: none; z-index: 10000;
                animation: slideIn 0.4s cubic-bezier(0.68, -0.55, 0.27, 1.55); 
                box-shadow: 0 10px 30px rgba(0,0,0,0.8);
                font-family: 'Roboto', sans-serif;
                font-size: 15px; font-weight: 500; letter-spacing: 0.5px;
            }
            @keyframes slideIn { from { transform: translateX(120%); } to { transform: translateX(0); } }

            @media (max-width: 1024px) {
                .stadium-container { transform: scale(0.85); margin-top: -30px; }
            }
            @media (max-width: 768px) {
                .grid-layout {
                    display: flex !important; flex-direction: column !important;
                    align-items: center !important; width: 100% !important;
                    padding-bottom: 120px !important; gap: 20px !important;
                }
                .seat-section, .stage-center { width: 94% !important; transform: none !important; margin: 0 auto !important; }
                .stage-center { order: 1; } .area-left { order: 2; } .area-top { order: 3; } .area-right { order: 4; } .area-bottom { order: 5; }
                .seat { width: 34px !important; height: 34px !important; }
                
                .header-section { flex-direction: column; gap: 15px; padding: 15px 0; text-align: center; }
                .btn-home-minimal { position: static; transform: none; margin-bottom: 10px; justify-content: center; }
                .header-right { position: static; transform: none; justify-content: center; }
                .header-title-container { margin: 5px 0; }
                .header-section h2 { font-size: 28px; }
                .btn-home-minimal span { display: inline-block; }
                .btn-home-minimal svg { width: 24px; height: 24px; }
            }
        </style>
    </head>
    <body>
        <div class="fog-container">
            <div class="fog-img fog-img-first"></div>
            <div class="fog-img fog-img-second"></div>
        </div>

        <div class="container">
            <div class="header-section">
                <a href="${pageContext.request.contextPath}/" class="btn-home-minimal" title="Trở về Trang chủ">
                    <svg viewBox="0 0 24 24">
                        <path d="M12 3L2 12h3v8h6v-6h2v6h6v-8h3L12 3z"/>
                    </svg>
                    <span>Trang chủ</span>
                </a>

                <div class="header-title-container">
                    <span class="header-icon">🎭</span>
                    <h2>Sơ đồ Nhà Hát</h2>
                </div>

                <div class="header-right">
                    <div id="cartTimer" class="timer-badge" style="display: none; color: var(--gold-primary); font-weight: bold; font-family: 'Courier New', monospace; font-size: 18px;">
                        ⏱️ <span id="timeRemaining">10:00</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/cart" class="btn-cart">
                        Giỏ hàng (${cartSize})
                    </a>
                </div>
            </div>

            <div class="controls-area">
                <div class="schedule-selector">
                    <strong style="font-family: 'Cinzel', serif; color: var(--gold-primary); margin-right: 10px; font-size: 15px;">SUẤT DIỄN:</strong>
                    <select id="scheduleSelect" onchange="changeSchedule()">
                        <option value="">-- Vui lòng chọn --</option>
                        <c:forEach var="sc" items="${schedules}">
                            <option value="${sc.scheduleID}" ${sc.scheduleID == selectedScheduleId ? 'selected' : ''}>
                                ${sc.showID.showName} - <fmt:formatDate value="${sc.showTime}" pattern="HH:mm dd/MM"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="legend">
                    <div class="legend-item"><div class="box-sample bg-vip"></div> VIP</div>
                    <div class="legend-item"><div class="box-sample bg-norm"></div> Thường</div>
                    <div class="legend-item"><div class="box-sample bg-book"></div> Đã bán</div>
                    <div class="legend-item"><div class="box-sample bg-res"></div> Giữ chỗ</div>
                    <div class="legend-item"><div class="box-sample bg-sel"></div> Chọn</div>
                </div>
            </div>

            <!-- 🔒 THÔNG BÁO KHÓA ĐẶT VÉ (THÊM MỚI) -->
            <c:if test="${bookingLocked}">
                <div style="
                    margin: 20px 0;
                    padding: 15px 25px;
                    background: rgba(220, 53, 69, 0.15);
                    border-left: 5px solid #dc3545;
                    border-radius: 4px;
                    color: #fff;
                    font-family: 'Roboto', sans-serif;
                    font-size: 15px;
                    font-weight: 500;
                    text-align: center;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.5);
                    backdrop-filter: blur(10px);
                ">
                    ⚠️ ${bookingMessage}
                </div>
            </c:if>

            <div class="stadium-container">
                <div class="grid-layout">
                    <div class="stage-center">
                        <div class="stage-text">SÂN KHẤU CHÍNH</div>
                    </div>

                    <div class="seat-section area-left">
                        <div class="section-title">Cánh Trái</div>
                        <c:forEach var="seat" items="${seatMap['LEFT']}">
                            <c:set var="stt" value="" />
                            <c:if test="${bookedSeatIds.contains(seat.seatID)}"><c:set var="stt" value="booked"/></c:if>
                            <c:if test="${reservedSeatIds.contains(seat.seatID)}"><c:set var="stt" value="reserved"/></c:if>
                            <c:if test="${cartSeatIds.contains(seat.seatID)}"><c:set var="stt" value="in-cart"/></c:if>
                            <div class="seat ${seat.seatType == 'VIP' ? 'vip' : 'normal'} ${stt}"
                                 onclick="selectSeat(this, '${seat.seatID}', '${seat.price}')"
                                 data-booked="${stt == 'booked' || stt == 'reserved'}"
                                 title="Ghế ${seat.seatNumber} &#10;Giá: <fmt:formatNumber value="${seat.price}" pattern="#,###"/>đ">
                                <span class="seat-txt">${seat.seatNumber}</span>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="seat-section area-top">
                        <div class="section-title">⭐ Trung Tâm (VIP) ⭐</div>
                        <c:forEach var="seat" items="${seatMap['TOP']}">
                            <c:set var="stt" value="" />
                            <c:if test="${bookedSeatIds.contains(seat.seatID)}"><c:set var="stt" value="booked"/></c:if>
                            <c:if test="${reservedSeatIds.contains(seat.seatID)}"><c:set var="stt" value="reserved"/></c:if>
                            <c:if test="${cartSeatIds.contains(seat.seatID)}"><c:set var="stt" value="in-cart"/></c:if>
                            <div class="seat ${seat.seatType == 'VIP' ? 'vip' : 'normal'} ${stt}"
                                 onclick="selectSeat(this, '${seat.seatID}', '${seat.price}')"
                                 data-booked="${stt == 'booked' || stt == 'reserved'}"
                                 title="Ghế ${seat.seatNumber} &#10;Giá: <fmt:formatNumber value="${seat.price}" pattern="#,###"/>đ">
                                <span class="seat-txt">${seat.seatNumber}</span>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="seat-section area-right">
                        <div class="section-title">Cánh Phải</div>
                        <c:forEach var="seat" items="${seatMap['RIGHT']}">
                            <c:set var="stt" value="" />
                            <c:if test="${bookedSeatIds.contains(seat.seatID)}"><c:set var="stt" value="booked"/></c:if>
                            <c:if test="${reservedSeatIds.contains(seat.seatID)}"><c:set var="stt" value="reserved"/></c:if>
                            <c:if test="${cartSeatIds.contains(seat.seatID)}"><c:set var="stt" value="in-cart"/></c:if>
                            <div class="seat ${seat.seatType == 'VIP' ? 'vip' : 'normal'} ${stt}"
                                 onclick="selectSeat(this, '${seat.seatID}', '${seat.price}')"
                                 data-booked="${stt == 'booked' || stt == 'reserved'}"
                                 title="Ghế ${seat.seatNumber} &#10;Giá: <fmt:formatNumber value="${seat.price}" pattern="#,###"/>đ">
                                <span class="seat-txt">${seat.seatNumber}</span>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="seat-section area-bottom">
                        <div class="section-title">--- Tầng Lầu ---</div>
                        <c:forEach var="seat" items="${seatMap['BOTTOM']}">
                            <c:set var="stt" value="" />
                            <c:if test="${bookedSeatIds.contains(seat.seatID)}"><c:set var="stt" value="booked"/></c:if>
                            <c:if test="${reservedSeatIds.contains(seat.seatID)}"><c:set var="stt" value="reserved"/></c:if>
                            <c:if test="${cartSeatIds.contains(seat.seatID)}"><c:set var="stt" value="in-cart"/></c:if>
                            <div class="seat ${seat.seatType == 'VIP' ? 'vip' : 'normal'} ${stt}"
                                 onclick="selectSeat(this, '${seat.seatID}', '${seat.price}')"
                                 data-booked="${stt == 'booked' || stt == 'reserved'}"
                                 title="Ghế ${seat.seatNumber} &#10;Giá: <fmt:formatNumber value="${seat.price}" pattern="#,###"/>đ">
                                <span class="seat-txt">${seat.seatNumber}</span>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <div id="notification" class="notification"></div>

        <form id="bookingForm" method="POST" action="${pageContext.request.contextPath}/cart" style="display:none;">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="seatId" id="inputSeatId">
            <input type="hidden" name="scheduleId" id="inputScheduleId">
            <input type="hidden" name="price" id="inputPrice">
        </form>

        <script>
            const cartSize = ${cartSize != null ? cartSize : 0};

            window.onload = function () {
                if (cartSize > 0) startTimer();
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('openLogin') === 'true') {
                    showNotification('⚠️ Vui lòng đăng nhập để tiếp tục!');
                }
            };

            function startTimer() {
                const timerEl = document.getElementById('cartTimer');
                if (timerEl) timerEl.style.display = 'flex';
                let time = 600; 
                const timerInterval = setInterval(() => {
                    time--;
                    if (time <= 0) { clearInterval(timerInterval); location.reload(); }
                    let m = Math.floor(time / 60);
                    let s = time % 60;
                    const timeSpan = document.getElementById('timeRemaining');
                    if (timeSpan) timeSpan.innerText = m + ':' + (s < 10 ? '0' : '') + s;
                }, 1000);
            }

            function changeSchedule() {
                const id = document.getElementById('scheduleSelect').value;
                if (id) window.location.href = '?scheduleId=' + id;
            }

            function selectSeat(el, seatId, price) {
                const schedId = document.getElementById('scheduleSelect').value;
                if (!schedId) {
                    showNotification('⚠️ Vui lòng chọn suất diễn trước!');
                    document.getElementById('scheduleSelect').focus();
                    const sel = document.getElementById('scheduleSelect');
                    sel.style.borderColor = 'red';
                    setTimeout(() => sel.style.borderColor = 'var(--gold-dark)', 1000);
                    return;
                }
                
                // 🔒 CHẶN NẾU SUẤT DIỄN BỊ KHÓA (THÊM MỚI)
                <c:if test="${bookingLocked}">
                showNotification('⚠️ ${bookingMessage}');
                return;
                </c:if>
                
                if (el.dataset.booked === 'true') {
                    showNotification('❌ Ghế này không thể chọn!');
                    return;
                }
                
                el.style.transform = "scale(0.8)";
                setTimeout(() => {
                    document.getElementById('inputSeatId').value = seatId;
                    document.getElementById('inputScheduleId').value = schedId;
                    document.getElementById('inputPrice').value = price;
                    document.getElementById('bookingForm').submit();
                }, 100);
            }

            function showNotification(message) {
                const notif = document.getElementById('notification');
                notif.innerText = message;
                notif.style.display = 'block';
                notif.style.opacity = '1';
                setTimeout(() => {
                    notif.style.opacity = '0';
                    setTimeout(() => {
                        notif.style.display = 'none';
                    }, 400);
                }, 3000);
            }
        </script>
    </body>
</html>