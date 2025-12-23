<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <title>Giỏ hàng | BookingStage</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <link href="https://cdn.jsdelivr.net/npm/@sweetalert2/theme-dark@4/dark.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.js"></script>

    <style>
        /* --- GIỮ NGUYÊN CSS CŨ --- */
        body {
            font-family: 'Roboto', sans-serif; 
            margin: 0;
            padding: 0;
            min-height: 100vh;
            color: #fff;
            background-color: #050505;
            background-image:
                radial-gradient(circle at 50% 0%, rgba(255, 215, 0, 0.15) 0%, transparent 60%),
                linear-gradient(0deg, #000000 0%, #1a1a1a 100%);
            background-attachment: fixed;
        }

        .main-wrapper { padding: 20px; }

        .cart-container {
            max-width: 1100px;
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

        .cart-page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .cart-page-header h2 {
            font-family: 'Playfair Display', serif; 
            background: linear-gradient(135deg, #FFD700 0%, #FDB931 50%, #FFD700 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 42px;
            text-transform: uppercase;
            letter-spacing: 2px;
            margin: 0;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 50px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-family: 'Roboto', sans-serif;
        }

        .btn-back {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: #aaa;
        }
        .btn-back:hover {
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
            border-color: #fff;
        }

        .btn-checkout {
            background: linear-gradient(90deg, #FDB931 0%, #FFD700 50%, #FDB931 100%);
            background-size: 200% auto;
            color: #000;
            border: none;
            box-shadow: 0 0 20px rgba(255, 215, 0, 0.4);
            font-weight: 800;
        }
        .btn-checkout:hover {
            background-position: right center;
            box-shadow: 0 0 30px rgba(255, 215, 0, 0.6);
            transform: translateY(-2px);
        }

        .btn-clear {
            background: transparent;
            color: #ff6b6b;
            border: 1px solid rgba(220, 53, 69, 0.3);
        }
        .btn-clear:hover {
            background: rgba(220, 53, 69, 0.1);
            border-color: #ff6b6b;
        }

        .table-responsive { overflow-x: auto; }

        .cart-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
            margin-bottom: 30px;
        }

        .cart-table th {
            color: #FFD700;
            font-family: 'Playfair Display', serif;
            font-size: 16px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 15px 20px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 215, 0, 0.2);
        }

        .cart-table tbody tr {
            background: rgba(255, 255, 255, 0.03);
            transition: background 0.2s ease;
        }
        
        .cart-table td:first-child { border-top-left-radius: 12px; border-bottom-left-radius: 12px; }
        .cart-table td:last-child { border-top-right-radius: 12px; border-bottom-right-radius: 12px; }

        .cart-table tbody tr:hover { background: rgba(255, 255, 255, 0.08); }

        .cart-table td {
            padding: 20px;
            color: #fff;
            vertical-align: middle;
            border: none;
            font-size: 15px;
        }

        .seat-number {
            font-family: 'Playfair Display', serif;
            font-size: 26px;
            font-weight: 700;
            color: #FFD700;
        }

        .seat-type {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
        }
        .seat-type.vip {
            background: rgba(255, 215, 0, 0.15);
            color: #FFD700;
            border: 1px solid rgba(255, 215, 0, 0.4);
        }
        .seat-type.normal { background: rgba(255, 255, 255, 0.1); color: #ccc; }

        .show-name { font-weight: 500; font-size: 16px; }
        .price-tag { font-size: 18px; font-weight: 700; color: #fff; font-family: 'Roboto', sans-serif; }

        .btn-remove-icon {
            width: 36px; height: 36px; border-radius: 50%;
            background: rgba(255, 255, 255, 0.08);
            color: #bbb; display: flex; align-items: center; justify-content: center;
            transition: all 0.2s; text-decoration: none; border: 1px solid rgba(255, 255, 255, 0.1);
            cursor: pointer;
        }
        .btn-remove-icon:hover { background: #ff4757; color: white; border-color: #ff4757; }

        .cart-summary {
            background: linear-gradient(to right, rgba(255, 255, 255, 0.02), rgba(255, 215, 0, 0.05));
            padding: 30px; border-radius: 16px; margin-bottom: 30px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .summary-row {
            display: flex; justify-content: space-between; align-items: center; padding: 12px 0; color: #ccc;
        }

        .summary-row.total {
            margin-top: 15px; padding-top: 20px; border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        .summary-row.total span:first-child {
            font-family: 'Playfair Display', serif; font-size: 20px;
            text-transform: uppercase; letter-spacing: 2px; color: #fff;
        }
        .summary-row.total .total-price {
            font-size: 36px; font-weight: 700; color: #FFD700; font-family: 'Roboto', sans-serif;
        }

        .cart-actions { display: flex; gap: 20px; justify-content: flex-end; align-items: center; }

        /* SweetAlert Style Override */
        .swal2-popup {
            background: #1a1a1a !important;
            border: 1px solid rgba(255, 215, 0, 0.3) !important;
            border-radius: 16px !important;
        }
        .swal2-title { color: #FFD700 !important; font-family: 'Playfair Display', serif !important; }
        .swal2-html-container { color: #ddd !important; }
        .swal2-confirm {
            background: linear-gradient(90deg, #FDB931 0%, #FFD700 100%) !important;
            color: #000 !important; font-weight: bold !important;
        }

        @media (max-width: 768px) {
            .cart-container { padding: 20px; margin: 15px; }
            .cart-actions { flex-direction: column-reverse; }
            .btn { width: 100%; justify-content: center; }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>

    <div class="main-wrapper">
        <div class="cart-container">
            <div class="cart-page-header">
                <h2>🛒 Giỏ hàng của bạn</h2>
                <a href="${pageContext.request.contextPath}/seats/layout<c:if test='${not empty cartItems and cartItems.size() > 0}'>?scheduleId=${cartItems[0].scheduleID}</c:if>" 
                   class="btn btn-back">
                        ← Chọn thêm ghế
                </a>
            </div>

            <c:choose>
                <c:when test="${empty cartItems or cartItems.size() == 0}">
                    <div class="empty-cart" style="text-align: center; padding: 60px 0;">
                        <h3 style="font-family: 'Playfair Display', serif; font-size: 24px;">Giỏ hàng đang trống</h3>
                        <p style="color: #888; margin-bottom: 30px;">Bạn chưa chọn vị trí nào cho đêm diễn tuyệt vời này.</p>
                        <a href="${pageContext.request.contextPath}/seats/layout" class="btn btn-checkout">Đặt ghế ngay</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="cart-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Số ghế</th>
                                    <th>Loại ghế</th>
                                    <th>Suất diễn</th>
                                    <th>Giá vé</th>
                                    <th style="text-align: center;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${cartItems}" varStatus="status">
                                    <tr>
                                        <td style="color: #666;">${status.index + 1}</td>
                                        <td><div class="seat-number">${item.seatNumber}</div></td>
                                        <td>
                                            <span class="seat-type ${item.seatType == 'VIP' ? 'vip' : 'normal'}">
                                                ${item.seatType == 'VIP' ? '👑 VIP' : '🪑 Standard'}
                                            </span>
                                        </td>
                                        <td><span class="show-name">${item.showName}</span></td>
                                        <td><span class="price-tag"><fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="0"/> đ</span></td>
                                        <td style="text-align: center; display: flex; justify-content: center;">
                                            <a href="${pageContext.request.contextPath}/cart?action=remove&index=${status.index}" 
                                               class="btn-remove-icon"
                                               onclick="confirmDelete(event, this.href, '${item.seatNumber}')">
                                                ✕
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="cart-summary">
                        <div class="summary-row">
                            <span>Số lượng ghế:</span>
                            <span><strong>${cartItems.size()}</strong> vé</span>
                        </div>
                        <div class="summary-row total">
                            <span>TỔNG CỘNG:</span>
                            <span><span class="total-price"><fmt:formatNumber value="${total}" type="number" maxFractionDigits="0"/> đ</span></span>
                        </div>
                    </div>

                    <div class="cart-actions">
                        <a href="${pageContext.request.contextPath}/cart?action=clear" 
                           class="btn btn-clear"
                           onclick="confirmClear(event, this.href)">
                            🗑️ Xóa tất cả
                        </a>
                        <button class="btn btn-checkout" onclick="goCheckout()">💳 THANH TOÁN NGAY</button>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        // Xóa 1 ghế
        function confirmDelete(e, url, seatName) {
            e.preventDefault(); 
            Swal.fire({
                title: 'Xóa ghế ' + seatName + '?',
                text: "Bạn có chắc muốn bỏ ghế này khỏi giỏ hàng?",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#FFD700',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Đồng ý xóa',
                cancelButtonText: 'Giữ lại',
                background: '#1a1a1a',
                color: '#fff'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = url;
                }
            });
        }

        // Xóa tất cả
        function confirmClear(e, url) {
            e.preventDefault();
            Swal.fire({
                title: 'Xóa toàn bộ?',
                text: "Bạn có chắc muốn xóa sạch giỏ hàng không?",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Xóa hết',
                cancelButtonText: 'Hủy',
                background: '#1a1a1a',
                color: '#fff'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = url;
                }
            });
        }

        // --- HÀM THANH TOÁN KẾT HỢP SWEETALERT VÀ OPENMODAL ---
        function goCheckout() {
            var ctx = "${pageContext.request.contextPath}";
            fetch(ctx + "/checkout", {
                method: "GET",
                headers: {"X-Requested-With": "XMLHttpRequest"}
            }).then(res => {
                // Nếu chưa đăng nhập (Lỗi 401)
                if (res.status === 401) {
                    // Bước 1: Hiện SweetAlert đẹp trước
                    Swal.fire({
                        title: 'Yêu cầu đăng nhập',
                        text: 'Vui lòng đăng nhập để tiếp tục thanh toán',
                        icon: 'info',
                        showCancelButton: true,
                        confirmButtonText: 'Đăng nhập ngay',
                        cancelButtonText: 'Để sau',
                        background: '#1a1a1a',
                        color: '#fff',
                        confirmButtonColor: '#FFD700',
                        cancelButtonColor: '#666'
                    }).then((result) => {
                        // Bước 2: Nếu người dùng bấm "Đăng nhập ngay"
                        if (result.isConfirmed) {
                            // Kiểm tra xem có hàm mở Modal không?
                            if (typeof openLoginModal === "function") {
                                openLoginModal(); // Mở popup đăng nhập ngay tại đây
                            } else {
                                window.location.href = ctx + "/login"; // Nếu không có popup thì mới chuyển trang
                            }
                        }
                    });
                } else {
                    // Nếu đã đăng nhập thì chuyển sang trang thanh toán
                    window.location.href = ctx + "/checkout";
                }
            }).catch(err => {
                console.error("Lỗi:", err);
                Swal.fire({
                    title: 'Lỗi!',
                    text: 'Có lỗi xảy ra, vui lòng thử lại sau.',
                    icon: 'error',
                    background: '#1a1a1a',
                    color: '#fff',
                    confirmButtonColor: '#d33'
                });
            });
        }
    </script>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/js/auth.js"></script>
</body> 
</html>