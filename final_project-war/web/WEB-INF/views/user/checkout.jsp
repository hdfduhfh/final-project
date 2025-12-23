<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thanh toán | Luxury Checkout</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Montserrat:wght@300;400;500;600;700&display=swap" rel="stylesheet">

        <style>

            /* --- 1. SETUP & BACKGROUND --- */
            :root {
                --gold-gradient: linear-gradient(135deg, #DFBD69 0%, #926F34 100%);
                --gold-glow: 0 0 15px rgba(223, 189, 105, 0.3);
                --glass-bg: rgba(20, 20, 20, 0.85);
                --glass-border: 1px solid rgba(255, 255, 255, 0.1);
                --text-main: #e0e0e0;
                --text-muted: #aaa;
                --font-title: 'Playfair Display', serif;
                --font-body: 'Montserrat', sans-serif;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                background: url('${pageContext.request.contextPath}/assets/images/background-payment.jpg') no-repeat center center fixed;
                background-size: cover;
                color: #fff;
                font-family: var(--font-body);
                position: relative;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 40px 0;
            }

            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0, 0, 0, 0.75);
                z-index: -1;
                backdrop-filter: blur(5px);
            }

            /* --- 2. LAYOUT --- */
            .container {
                width: 95%;
                max-width: 1200px;
                margin: 0 auto;
                display: grid;
                grid-template-columns: 1.8fr 1.2fr;
                gap: 30px;
                align-items: start;
            }

            /* --- 3. GLASS CARD STYLE --- */
            .section {
                background: var(--glass-bg);
                border: var(--glass-border);
                border-radius: 16px;
                padding: 40px;
                box-shadow: 0 20px 50px rgba(0, 0, 0, 0.6);
                position: relative;
                overflow: hidden;
            }

            .section::before {
                content: '';
                position: absolute;
                inset: 0;
                border-radius: 16px;
                padding: 1px;
                background: linear-gradient(135deg, rgba(255,215,0,0.4), transparent 60%);
                -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
                -webkit-mask-composite: xor;
                mask-composite: exclude;
                pointer-events: none;
            }

            h2 {
                font-family: var(--font-title);
                font-weight: 700;
                font-size: 28px;
                margin-bottom: 30px;
                padding-bottom: 15px;
                border-bottom: 1px solid rgba(255, 215, 0, 0.2);
                color: #DFBD69;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            h3 {
                font-family: var(--font-title);
                color: #fff;
                margin-bottom: 20px;
                font-size: 20px;
                display: flex;
                align-items: center;
                gap: 12px;
                text-transform: capitalize;
            }

            h3::before {
                content: '';
                display: block;
                width: 4px;
                height: 20px;
                background: var(--gold-gradient);
                border-radius: 2px;
            }

            /* --- 4. INFO SECTIONS --- */
            .user-info, .payment-method, .promotion-section {
                margin-bottom: 35px;
            }

            .info-row {
                display: flex;
                padding: 14px 0;
                border-bottom: 1px solid rgba(255,255,255,0.08);
                font-size: 15px;
            }

            .info-label {
                color: var(--text-muted);
                width: 140px;
                font-weight: 500;
            }

            .info-value {
                color: #fff;
                font-weight: 600;
                flex: 1;
                font-family: var(--font-body);
            }

            /* --- 5. PAYMENT OPTIONS --- */
            .payment-options {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
            }

            .payment-option {
                background: rgba(255, 255, 255, 0.05);
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-radius: 10px;
                padding: 15px;
                cursor: pointer;
                transition: all 0.3s ease;
                position: relative;
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: center;
                gap: 8px;
            }

            .payment-option:hover {
                background: rgba(255, 255, 255, 0.1);
                border-color: rgba(223, 189, 105, 0.6);
                transform: translateY(-2px);
            }

            .payment-option.selected {
                background: linear-gradient(135deg, rgba(223, 189, 105, 0.2) 0%, rgba(0,0,0,0) 100%);
                border-color: #DFBD69;
                box-shadow: 0 0 15px rgba(223, 189, 105, 0.15);
            }

            .payment-option input[type="radio"] {
                display: none;
            }

            .payment-icon {
                font-size: 26px;
                margin-bottom: 5px;
            }

            .payment-info h4 {
                font-size: 14px;
                font-weight: 700;
                color: #fff;
                margin-bottom: 2px;
                font-family: var(--font-body);
                text-transform: uppercase;
            }

            .payment-info p {
                font-size: 11px;
                color: #aaa;
            }

            .payment-option.selected::after {
                content: '✓';
                position: absolute;
                top: 8px;
                right: 8px;
                color: #DFBD69;
                font-weight: 900;
                font-size: 14px;
            }

            /* --- 6. PROMOTION --- */
            #promotionSelect {
                width: 100%;
                padding: 14px 15px;
                background: rgba(0,0,0,0.4);
                color: #fff;
                border: 1px solid rgba(255,255,255,0.15);
                border-radius: 8px;
                font-family: var(--font-body);
                font-size: 14px;
                cursor: pointer;
                outline: none;
                transition: border 0.3s;
            }

            #promotionSelect:focus {
                border-color: #DFBD69;
            }
            option {
                background: #1a1a1a;
                color: #fff;
                padding: 10px;
            }

            /* --- 7. ORDER SUMMARY --- */
            .order-summary {
                position: sticky;
                top: 20px;
                background: rgba(15, 15, 15, 0.9);
            }

            .cart-items {
                max-height: 350px;
                overflow-y: auto;
                margin-bottom: 25px;
                padding-right: 8px;
            }

            .cart-items::-webkit-scrollbar {
                width: 4px;
            }
            .cart-items::-webkit-scrollbar-thumb {
                background: #555;
                border-radius: 2px;
            }

            .cart-item {
                padding: 15px 0;
                border-bottom: 1px dashed rgba(255, 255, 255, 0.15);
            }
            .cart-item:last-child {
                border-bottom: none;
            }

            .cart-item-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 8px;
            }

            .seat-number {
                font-family: var(--font-title);
                font-weight: 700;
                font-size: 18px;
                color: #DFBD69;
                letter-spacing: 0.5px;
            }

            .seat-price {
                color: #fff;
                font-size: 15px;
                font-weight: 600;
                font-family: var(--font-body);
            }

            .seat-info {
                font-size: 12px;
                color: #bbb;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .seat-type {
                font-size: 10px;
                padding: 3px 8px;
                border-radius: 4px;
                text-transform: uppercase;
                font-weight: 700;
                letter-spacing: 0.5px;
            }

            .seat-type.vip {
                background: linear-gradient(45deg, #DFBD69, #926F34);
                color: #000;
                box-shadow: 0 0 5px rgba(223, 189, 105, 0.4);
            }

            .seat-type.normal {
                background: #444;
                color: #ddd;
            }

            /* --- 8. TOTAL & BUTTONS --- */
            .summary-row {
                display: flex;
                justify-content: space-between;
                padding: 12px 0;
                color: #ccc;
                font-size: 15px;
                font-family: var(--font-body);
            }

            .summary-row.total {
                border-top: 1px solid rgba(255, 255, 255, 0.2);
                margin-top: 20px;
                padding-top: 25px;
                align-items: center;
            }

            .summary-row.total span:first-child {
                font-size: 18px;
                font-family: var(--font-title);
                text-transform: uppercase;
                color: #fff;
            }

            .summary-row.total span:last-child {
                font-size: 32px;
                font-family: var(--font-body);
                font-weight: 700;
                color: #DFBD69;
                text-shadow: 0 0 25px rgba(223, 189, 105, 0.2);
            }

            .discount-row {
                color: #4cd137 !important;
                font-weight: 600;
            }

            /* BUTTONS */
            .btn {
                width: 100%;
                padding: 18px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-family: var(--font-body);
                font-weight: 700;
                font-size: 16px;
                text-transform: uppercase;
                transition: all 0.3s ease;
                text-decoration: none;
                display: block;
                text-align: center;
                letter-spacing: 1px;
            }

            .btn-primary {
                background-image: var(--gold-gradient);
                background-size: 200% auto;
                color: #111;
                margin-bottom: 15px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            }

            .btn-primary:hover {
                background-position: right center;
                box-shadow: 0 0 25px rgba(223, 189, 105, 0.6);
                transform: translateY(-2px);
            }

            .btn-secondary {
                background: transparent;
                color: #888;
                font-size: 14px;
                border: 1px solid rgba(255,255,255,0.1);
            }

            .btn-secondary:hover {
                color: #fff;
                border-color: #fff;
                background: rgba(255,255,255,0.05);
            }

            /* --- MESSAGES --- */
            .promotion-success {
                background: rgba(76, 209, 55, 0.15);
                color: #4cd137;
                padding: 12px;
                border-radius: 6px;
                font-size: 13px;
                margin-top: 12px;
                border: 1px solid rgba(76, 209, 55, 0.2);
                font-weight: 500;
            }
            .promotion-error, .error-message {
                background: rgba(255, 71, 87, 0.15);
                color: #ff4757;
                padding: 12px;
                border-radius: 6px;
                font-size: 13px;
                margin-top: 12px;
                border: 1px solid rgba(255, 71, 87, 0.2);
                font-weight: 500;
                transition: opacity 0.5s ease;
            }

            /* --- 9. CUSTOM MODAL (THÊM MỚI ĐỂ BỎ LOCALHOST ALERT) --- */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.85);
                z-index: 9999;
                display: none; /* Ẩn mặc định */
                align-items: center;
                justify-content: center;
                backdrop-filter: blur(8px);
            }

            .modal-box {
                background: #1a1a1a;
                border: 1px solid #DFBD69;
                padding: 30px;
                border-radius: 12px;
                max-width: 400px;
                width: 90%;
                text-align: center;
                box-shadow: 0 0 40px rgba(223, 189, 105, 0.3);
                transform: scale(0.9);
                transition: transform 0.3s ease;
                position: relative;
            }
            
            /* Viền bóng cho modal */
            .modal-box::before {
                content: '';
                position: absolute;
                inset: -1px;
                border-radius: 12px;
                background: linear-gradient(45deg, #DFBD69, transparent);
                z-index: -1;
                opacity: 0.5;
            }

            .modal-title {
                font-family: var(--font-title);
                color: #DFBD69;
                font-size: 24px;
                margin-bottom: 15px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .modal-text {
                color: #e0e0e0;
                font-size: 16px;
                margin-bottom: 25px;
                line-height: 1.5;
            }

            .modal-buttons {
                display: flex;
                gap: 15px;
                justify-content: center;
            }

            .btn-modal {
                padding: 10px 25px;
                border-radius: 6px;
                border: none;
                cursor: pointer;
                font-weight: 600;
                font-size: 14px;
                font-family: var(--font-body);
                transition: all 0.2s;
            }

            .btn-modal-confirm {
                background: var(--gold-gradient);
                color: #000;
            }
            .btn-modal-confirm:hover {
                box-shadow: 0 0 15px rgba(223, 189, 105, 0.5);
            }

            .btn-modal-cancel {
                background: transparent;
                border: 1px solid #555;
                color: #aaa;
            }
            .btn-modal-cancel:hover {
                border-color: #fff;
                color: #fff;
            }

            /* --- RESPONSIVE --- */
            @media (max-width: 900px) {
                .container {
                    display: flex;
                    flex-direction: column;
                    gap: 20px;
                    padding: 10px;
                    width: 100%;
                }
                .order-summary {
                    order: -1;
                    position: static;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="section">
                <h2>Xác Nhận Thanh Toán</h2>

                <c:if test="${not empty error}">
                    <div class="error-message">⚠️ ${error}</div>
                </c:if>

                <div class="user-info">
                    <h3>Thông Tin Khách Hàng</h3>
                    <div class="info-row">
                        <div class="info-label">Họ tên</div>
                        <div class="info-value">${user.fullName}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Email</div>
                        <div class="info-value">${user.email}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Điện thoại</div>
                        <div class="info-value">${user.phone != null ? user.phone : 'Chưa cập nhật'}</div>
                    </div>
                </div>

                <div class="payment-method">
                    <h3>Phương Thức Thanh Toán</h3>
                    <form method="post" action="${pageContext.request.contextPath}/checkout" id="checkoutForm">
                        <div class="payment-options">
                            <label class="payment-option selected">
                                <input type="radio" name="paymentMethod" value="CASH" checked>
                                <div class="payment-icon">💵</div>
                                <div class="payment-info">
                                    <h4>Tiền mặt</h4>
                                    <p>Thanh toán tại quầy</p>
                                </div>
                            </label>

                            <label class="payment-option">
                                <input type="radio" name="paymentMethod" value="BANKING">
                                <div class="payment-icon">🏦</div>
                                <div class="payment-info">
                                    <h4>Chuyển khoản</h4>
                                    <p>Quét mã QR Code</p>
                                </div>
                            </label>

                            <label class="payment-option">
                                <input type="radio" name="paymentMethod" value="MOMO">
                                <div class="payment-icon">📱</div>
                                <div class="payment-info">
                                    <h4>Ví MoMo</h4>
                                    <p>Siêu tốc 24/7</p>
                                </div>
                            </label>

                            <label class="payment-option">
                                <input type="radio" name="paymentMethod" value="VNPAY">
                                <div class="payment-icon">💳</div>
                                <div class="payment-info">
                                    <h4>VNPay</h4>
                                    <p>Thẻ ATM / QR</p>
                                </div>
                            </label>
                        </div>
                    </form>
                </div>

                <div class="promotion-section">
                    <h3>Mã Ưu Đãi</h3>
                    <select id="promotionSelect" name="promotionId" form="checkoutForm" onchange="calculateDiscount()">
                        <option value="0">Chọn mã giảm giá của bạn</option>
                        <c:forEach var="promo" items="${promotions}">
                            <option value="${promo.promotionID}" 
                                    data-type="${promo.discountType}"
                                    data-value="${promo.discountValue}"
                                    data-min="${promo.minOrderAmount != null ? promo.minOrderAmount : 0}"
                                    data-max="${promo.maxDiscount != null ? promo.maxDiscount : 0}">
                                ${promo.code} - ${promo.name} 
                                <c:choose>
                                    <c:when test="${promo.discountType == 'PERCENT'}">
                                        (Giảm <fmt:formatNumber value="${promo.discountValue}" type="number" maxFractionDigits="0"/>%)
                                    </c:when>
                                    <c:otherwise>
                                        (Giảm <fmt:formatNumber value="${promo.discountValue}" type="number" maxFractionDigits="0"/>đ)
                                    </c:otherwise>
                                </c:choose>
                            </option>
                        </c:forEach>
                    </select>
                    <div id="promotionMessage"></div>
                </div>
            </div>

            <div class="section order-summary">
                <h2>Vé Của Bạn</h2>

                <div class="cart-items">
                    <c:forEach var="item" items="${cartItems}">
                        <div class="cart-item">
                            <div class="cart-item-header">
                                <span class="seat-number">GHẾ ${item.seatNumber}</span>
                                <span class="seat-price">
                                    <fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="0"/> 
                                    <small style="font-size: 0.8em;">₫</small>
                                </span>
                            </div>
                            <div class="seat-info">
                                <span class="seat-type ${item.seatType == 'VIP' ? 'vip' : 'normal'}">
                                    ${item.seatType}
                                </span>
                                <span style="font-style: italic;">• ${item.showName}</span>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="summary-row">
                    <span>Số lượng vé</span>
                    <span style="font-weight: 600; color: #fff;">${cartItems.size()} vé</span>
                </div>

                <div class="summary-row">
                    <span>Tạm tính</span>
                    <span id="originalTotal">
                        <fmt:formatNumber value="${total}" type="number" maxFractionDigits="0"/> 
                        <small>₫</small>
                    </span>
                </div>

                <div id="discountRow" style="display: none;" class="summary-row discount-row">
                    <span>Giảm giá</span>
                    <span id="discountValue">- 0 ₫</span>
                </div>

                <div class="summary-row total">
                    <span>Tổng cộng</span>
                    <span id="finalTotal">
                        <fmt:formatNumber value="${total}" type="number" maxFractionDigits="0"/> 
                        <small>₫</small>
                    </span>
                </div>

                <div style="margin-top: 40px;">
                    <button type="submit" form="checkoutForm" class="btn btn-primary">
                        THANH TOÁN NGAY
                    </button>
                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-secondary">
                        Quay lại giỏ hàng
                    </a>
                </div>
            </div>
        </div>

        <div id="customConfirmModal" class="modal-overlay">
            <div class="modal-box">
                <div class="modal-title">Xác Nhận</div>
                <div class="modal-text" id="modalMessage">
                    </div>
                <div class="modal-buttons">
                    <button class="btn-modal btn-modal-cancel" onclick="closeModal()">Hủy bỏ</button>
                    <button class="btn-modal btn-modal-confirm" onclick="submitRealForm()">Đồng ý</button>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const errorMsg = document.querySelector('.error-message');
                if (errorMsg) {
                    setTimeout(function () {
                        errorMsg.style.opacity = '0';
                        setTimeout(function () {
                            errorMsg.style.display = 'none';
                        }, 500);
                    }, 5000);
                }
            });

            const originalTotal = ${total};
            let currentDiscount = 0;

            document.querySelectorAll('.payment-option').forEach(option => {
                option.addEventListener('click', function () {
                    document.querySelectorAll('.payment-option').forEach(opt => {
                        opt.classList.remove('selected');
                    });
                    this.classList.add('selected');
                    this.querySelector('input[type="radio"]').checked = true;
                });
            });

            function calculateDiscount() {
                const select = document.getElementById('promotionSelect');
                const selectedOption = select.options[select.selectedIndex];
                const messageDiv = document.getElementById('promotionMessage');

                if (select.value === '0') {
                    currentDiscount = 0;
                    document.getElementById('discountRow').style.display = 'none';
                    document.getElementById('finalTotal').innerHTML = formatNumber(originalTotal) + ' <small>₫</small>';
                    messageDiv.innerHTML = '';
                    return;
                }

                const type = selectedOption.getAttribute('data-type');
                const value = parseFloat(selectedOption.getAttribute('data-value'));
                const minOrder = parseFloat(selectedOption.getAttribute('data-min'));
                const maxDiscount = parseFloat(selectedOption.getAttribute('data-max'));

                if (minOrder > 0 && originalTotal < minOrder) {
                    messageDiv.innerHTML = '<div class="promotion-error">Yêu cầu đơn hàng tối thiểu ' +
                            formatNumber(minOrder) + ' ₫</div>';
                    select.value = '0';
                    currentDiscount = 0;
                    document.getElementById('discountRow').style.display = 'none';
                    document.getElementById('finalTotal').innerHTML = formatNumber(originalTotal) + ' <small>₫</small>';
                    return;
                }

                if (type === 'PERCENT') {
                    currentDiscount = originalTotal * (value / 100);
                    if (maxDiscount > 0 && currentDiscount > maxDiscount) {
                        currentDiscount = maxDiscount;
                    }
                } else {
                    currentDiscount = value;
                    if (currentDiscount > originalTotal) {
                        currentDiscount = originalTotal;
                    }
                }

                const finalAmount = originalTotal - currentDiscount;

                messageDiv.innerHTML = '<div class="promotion-success">Đã áp dụng mã giảm giá! Tiết kiệm ' +
                        formatNumber(currentDiscount) + ' ₫</div>';
                document.getElementById('discountRow').style.display = 'flex';
                document.getElementById('discountValue').innerHTML = '- ' + formatNumber(currentDiscount) + ' <small>₫</small>';
                document.getElementById('finalTotal').innerHTML = formatNumber(finalAmount) + ' <small>₫</small>';
            }

            function formatNumber(num) {
                return Math.round(num).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
            }

            /* --- LOGIC MODAL MỚI --- */
            
            // Hàm đóng Modal
            function closeModal() {
                const modal = document.getElementById('customConfirmModal');
                modal.style.display = 'none';
            }

            // Hàm submit form thật sau khi user đã đồng ý
            function submitRealForm() {
                document.getElementById('checkoutForm').submit();
            }

            // Ghi đè sự kiện submit mặc định
            document.getElementById('checkoutForm').addEventListener('submit', function (e) {
                e.preventDefault(); // Chặn hành động gửi form ngay lập tức

                const finalAmount = originalTotal - currentDiscount;
                const formattedAmount = formatNumber(finalAmount);

                // Điền nội dung vào Modal tùy chỉnh
                const modalMsg = document.getElementById('modalMessage');
                modalMsg.innerHTML = 'Thanh toán số tiền <br> <strong style="font-size: 24px; color: #DFBD69; display:block; margin-top:10px;">' + formattedAmount + ' ₫</strong>';

                // Hiển thị Modal
                const modal = document.getElementById('customConfirmModal');
                modal.style.display = 'flex';
                
                // Hiệu ứng scale nhẹ cho đẹp
                setTimeout(() => {
                    document.querySelector('.modal-box').style.transform = 'scale(1)';
                }, 10);
            });
        </script>
    </body>
</html>