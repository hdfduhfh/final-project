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
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
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
                        <label class="payment-option" data-method="vnpay">
                            <input type="radio" name="paymentMethod" value="VNPAY">
                            <div class="payment-icon">💳</div>
                            <div class="payment-info">
                                <h4>VNPay</h4>
                                <p>Thẻ ATM / QR Code</p>
                            </div>
                        </label>

                        <label class="payment-option" data-method="momo">
                            <input type="radio" name="paymentMethod" value="MOMO">
                            <div class="payment-icon">📱</div>
                            <div class="payment-info">
                                <h4>Ví MoMo</h4>
                                <p>Quét mã thanh toán</p>
                            </div>
                        </label>

                        <label class="payment-option" data-method="banking">
                            <input type="radio" name="paymentMethod" value="BANKING">
                            <div class="payment-icon">🏦</div>
                            <div class="payment-info">
                                <h4>Chuyển khoản</h4>
                                <p>Quét mã QR Code</p>
                            </div>
                        </label>
                    </div>

                    <!-- ✨ VNPAY DETAILS -->
                    <div class="payment-details" id="vnpay-details">
                        <h4 style="color: #DFBD69; margin-bottom: 15px; font-size: 16px;">Chọn Ngân Hàng</h4>
                        <div class="bank-grid">
                            <div class="bank-item" data-bank="VCB">
                                <img src="https://api.vietqr.io/img/VCB.png" alt="Vietcombank">
                                <span>Vietcombank</span>
                            </div>
                            <div class="bank-item" data-bank="TCB">
                                <img src="https://api.vietqr.io/img/TCB.png" alt="Techcombank">
                                <span>Techcombank</span>
                            </div>
                            <div class="bank-item" data-bank="MB">
                                <img src="https://api.vietqr.io/img/MB.png" alt="MBBank">
                                <span>MBBank</span>
                            </div>
                            <div class="bank-item" data-bank="VIB">
                                <img src="https://api.vietqr.io/img/VIB.png" alt="VIB">
                                <span>VIB</span>
                            </div>
                            <div class="bank-item" data-bank="ACB">
                                <img src="https://api.vietqr.io/img/ACB.png" alt="ACB">
                                <span>ACB</span>
                            </div>
                            <div class="bank-item" data-bank="TPB">
                                <img src="https://api.vietqr.io/img/TPB.png" alt="TPBank">
                                <span>TPBank</span>
                            </div>
                            <div class="bank-item" data-bank="BIDV">
                                <img src="https://api.vietqr.io/img/BIDV.png" alt="BIDV">
                                <span>BIDV</span>
                            </div>
                            <div class="bank-item" data-bank="VPB">
                                <img src="https://api.vietqr.io/img/VPB.png" alt="VPBank">
                                <span>VPBank</span>
                            </div>
                        </div>
                        <input type="text" class="demo-input" placeholder="Số thẻ (demo)">
                        <input type="text" class="demo-input" placeholder="Tên chủ thẻ (demo)">
                        <input type="text" class="demo-input" placeholder="Mã OTP (demo)">
                        <div class="demo-notice">🚨 Nhập bất kỳ thông tin gì cũng được</div>
                    </div>

                    <!-- ✨ MOMO DETAILS -->
                    <div class="payment-details" id="momo-details">
                        <div class="qr-display">
                            <h4 style="color: #DFBD69; margin-bottom: 10px;">Quét Mã MoMo</h4>
                            <div class="qr-wrapper" title="Click để giả lập quét thành công">
                                <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=MOMO_DEMO_ORDER" alt="Momo QR">
                            </div>
                            <div class="qr-info">
                                Mở ứng dụng MoMo → Quét mã<br>
                                <strong>Hoặc CLICK vào QR để giả lập</strong>
                            </div>
                            <div class="demo-notice">CLICK VÀO QR ĐỂ GIẢ LẬP QUÉT THÀNH CÔNG</div>
                        </div>
                    </div>

                    <!-- ✨ BANKING DETAILS -->
                    <div class="payment-details" id="banking-details">
                        <div class="qr-display">
                            <h4 style="color: #DFBD69; margin-bottom: 10px;">Chuyển Khoản Ngân Hàng</h4>
                            <div class="qr-wrapper" title="Click để giả lập quét thành công">
                                <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=BANK_DEMO_ORDER" alt="Banking QR">
                            </div>
                            <div class="qr-info">
                                Ngân hàng: <strong>MB Bank (Demo)</strong><br>
                                Số TK: <strong>0123456789</strong><br>
                                Chủ TK: <strong>LUXURY STAGE</strong><br>
                                Nội dung: <strong>THANHTOAN VE</strong>
                            </div>
                            <div class="demo-notice">CLICK VÀO QR ĐỂ GIẢ LẬP QUÉT THÀNH CÔNG</div>
                        </div>
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
                    XÁC NHẬN THANH TOÁN
                </button>
                <a href="${pageContext.request.contextPath}/cart" class="btn btn-secondary">
                    Quay lại giỏ hàng
                </a>
            </div>
        </div>
    </div>

    <!-- ✅ LINK JS EXTERNAL -->
    <script src="${pageContext.request.contextPath}/js/checkout.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>
</html>