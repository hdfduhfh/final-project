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
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&family=Playfair+Display:wght@400;700&display=swap" rel="stylesheet">
    
    <link href="https://cdn.jsdelivr.net/npm/@sweetalert2/theme-dark@4/dark.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.js"></script>
<style>
/* ======================================================================
   LUXURY CART STYLES (SYNCED WITH CHECKOUT)
   Updated: Uniform Fonts & Gold Gradient Variables
====================================================================== */

/* 1. ĐỒNG BỘ VARIABLES TỪ TRANG CHECKOUT */
:root {
    --gold-primary: #DFBD69;
    --gold-gradient: linear-gradient(135deg, #DFBD69 0%, #99742E 100%); /* Chuẩn màu Checkout */
    --gold-hover: #FFE08A;
    --bg-dark: #0a0a0a;
    --line-color: rgba(255, 255, 255, 0.15);
    --font-title: 'Playfair Display', serif; /* Font Tiêu đề (Có chân) */
    --font-body: 'Montserrat', sans-serif;   /* Font Nội dung (Không chân) */
}

/* 2. CẤU TRÚC CƠ BẢN */
body {
    font-family: var(--font-body); /* Mặc định là Montserrat */
    margin: 0; padding: 0;
    min-height: 100vh;
    color: #e0e0e0;
    background-color: var(--bg-dark);
    /* Đồng bộ background tối mờ ảo như Checkout */
    background-image: radial-gradient(circle at top center, #1a1500 0%, #000000 70%); 
    -webkit-font-smoothing: antialiased;
}

.main-wrapper { 
    max-width: 1200px; 
    margin: 60px auto; /* Tăng margin cho thoáng giống checkout */
    padding: 0 20px; 
}

/* 3. HEADER */
.cart-page-header {
    margin-bottom: 40px;
    border-bottom: 1px solid var(--line-color);
    padding-bottom: 20px;
    display: flex; justify-content: space-between; align-items: end;
}
.cart-page-header h2 {
    font-family: var(--font-title); /* Dùng Playfair cho tiêu đề lớn */
    color: #fff;
    font-size: 36px; margin: 0;
    text-transform: uppercase; letter-spacing: 2px;
}
.sub-label {
    margin:0; color: var(--gold-primary); font-size: 12px; letter-spacing: 2px; font-weight: 600; text-transform: uppercase;
}

/* --- LAYOUT 2 CỘT --- */
.cart-layout {
    display: grid;
    grid-template-columns: 1fr 380px; /* Cột bên phải rộng hơn chút để thoáng */
    gap: 50px;
    align-items: start;
}

/* --- TICKET CARD DESIGN --- */
.ticket-list { display: flex; flex-direction: column; gap: 20px; }

.ticket-card {
    background: rgba(255, 255, 255, 0.03); /* Glass effect nhẹ */
    border: 1px solid var(--line-color);
    border-left: 4px solid var(--gold-primary);
    border-radius: 6px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 25px;
    position: relative;
    transition: all 0.3s ease;
    overflow: hidden;
}

.ticket-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 30px rgba(0,0,0,0.5);
    background: rgba(255, 255, 255, 0.06);
    border-color: rgba(255,255,255,0.3);
}

/* Đường cắt vé ảo */
.ticket-card::after {
    content: '';
    position: absolute;
    right: 120px; top: -10px; bottom: -10px;
    border-right: 2px dashed rgba(255,255,255,0.1);
}

.ticket-info { flex: 1; padding-right: 20px; }

.ticket-seat { 
    font-family: var(--font-title); /* Ghế là đối tượng VIP -> Dùng Playfair */
    font-size: 32px; color: #fff; font-weight: 700; margin-bottom: 5px; 
}

.ticket-meta { 
    font-family: var(--font-body);
    font-size: 13px; color: #999; display: flex; gap: 15px; text-transform: uppercase; letter-spacing: 1px; 
}

.ticket-type-badge {
    display: inline-block; padding: 4px 10px; border-radius: 4px; 
    font-family: var(--font-body);
    font-size: 10px; font-weight: 700; text-transform: uppercase; margin-left: 10px; vertical-align: middle;
    letter-spacing: 1px;
}
.ticket-type-badge.vip { background: rgba(223, 189, 105, 0.15); color: var(--gold-primary); border: 1px solid var(--gold-primary); }
.ticket-type-badge.standard { background: rgba(255,255,255,0.1); color: #aaa; border: 1px solid rgba(255,255,255,0.2); }

.ticket-price-action {
    width: 100px; text-align: right;
    display: flex; flex-direction: column; align-items: flex-end; justify-content: center;
    z-index: 2;
}
.ticket-price { 
    font-family: var(--font-body); /* Giá tiền dùng Montserrat cho rõ số */
    font-size: 20px; font-weight: 700; color: var(--gold-primary); margin-bottom: 8px; 
}

.btn-remove-text {
    color: #ff4757; font-size: 11px; text-decoration: none; 
    text-transform: uppercase; font-weight: 600; padding: 5px 0;
    transition: color 0.2s; letter-spacing: 0.5px;
}
.btn-remove-text:hover { color: #ff6b81; text-decoration: underline; }

/* --- SUMMARY BOX (GIỐNG ORDER SUMMARY BÊN CHECKOUT) --- */
.cart-summary-box {
    background: rgba(20, 20, 20, 0.6); /* Đồng bộ background box */
    border: 1px solid var(--line-color);
    border-radius: 8px;
    padding: 30px;
    position: sticky; top: 30px;
    backdrop-filter: blur(10px);
}

.summary-title { 
    font-family: var(--font-title); /* Tiêu đề box dùng Playfair */
    font-size: 20px; color: #fff; text-transform: uppercase; letter-spacing: 1px;
    margin-bottom: 25px; border-bottom: 1px solid var(--line-color); padding-bottom: 15px; 
}

.summary-row { display: flex; justify-content: space-between; margin-bottom: 18px; font-size: 14px; color: #ccc; }
.summary-row span:first-child { text-transform: uppercase; font-size: 12px; letter-spacing: 1px; color: #999; }
.summary-row span:last-child { color: #fff; font-weight: 600; }

.summary-total { 
    display: flex; justify-content: space-between; align-items: center;
    margin-top: 20px; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.2); 
}
.summary-total span:first-child { 
    font-family: var(--font-title); /* Chữ "TỔNG CỘNG" dùng Playfair cho sang */
    font-size: 16px; color: #fff; text-transform: uppercase; letter-spacing: 1px;
}
.summary-total span:last-child { 
    font-family: var(--font-body); /* Số tiền dùng Montserrat */
    font-size: 24px; color: var(--gold-primary); font-weight: 800; 
}

/* --- BUTTON THANH TOÁN (COPY TỪ CHECKOUT .btn-primary) --- */
.btn-checkout-full {
    width: 100%; display: block; text-align: center;
    background: var(--gold-gradient); /* Gradient chuẩn */
    color: #000; 
    font-family: var(--font-body); /* QUAN TRỌNG: Dùng Montserrat để không bị lỗi font */
    font-weight: 800; font-size: 15px; letter-spacing: 1.5px;
    padding: 18px; border-radius: 4px; border: none;
    text-decoration: none; text-transform: uppercase; margin-top: 25px;
    cursor: pointer;
    box-shadow: 0 4px 25px rgba(223, 189, 105, 0.4); /* Glow effect */
    transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
}
.btn-checkout-full:hover { 
    transform: translateY(-2px); 
    background: linear-gradient(135deg, #FFE08A 0%, #D4A050 100%);
    box-shadow: 0 6px 30px rgba(223, 189, 105, 0.6); 
}

.btn-clear-text { 
    display: block; text-align: center; margin-top: 20px; 
    color: #666; font-size: 11px; text-decoration: none; text-transform: uppercase; letter-spacing: 1px;
    transition: color 0.3s;
}
.btn-clear-text:hover { color: #999; }

/* Responsive */
@media (max-width: 900px) {
    .cart-layout { grid-template-columns: 1fr; }
    .ticket-card::after { display: none; }
    .cart-summary-box { position: static; margin-top: 30px; }
}

/* --- PAGINATION (UPDATED TO MATCH VARS) --- */
.pagination-container {
    display: flex; justify-content: center; gap: 8px;
    margin-top: 30px; padding-top: 20px;
    border-top: 1px dashed var(--line-color);
}
.page-btn {
    min-width: 36px; height: 36px;
    display: flex; align-items: center; justify-content: center;
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.2);
    color: #ccc; border-radius: 4px; cursor: pointer;
    font-family: var(--font-body); font-size: 14px; font-weight: 600;
    transition: all 0.3s ease;
}
.page-btn:hover {
    border-color: var(--gold-primary); color: var(--gold-primary);
    background: rgba(223, 189, 105, 0.1);
}
.page-btn.active {
    background: var(--gold-gradient);
    color: #000; border-color: transparent;
    box-shadow: 0 0 10px rgba(223, 189, 105, 0.3); font-weight: 800;
}
.page-btn:disabled { opacity: 0.3; cursor: not-allowed; border-color: transparent; }

/* Animation cho Pagination */
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}

/* SWEETALERT OVERRIDE (Cho đồng bộ popup) */
div:where(.swal2-container) div:where(.swal2-popup) {
    background: #141414 !important;
    border: 1px solid var(--gold-primary) !important;
}
div:where(.swal2-container) h2:where(.swal2-title) {
    color: var(--gold-primary) !important;
    font-family: var(--font-title) !important;
}
div:where(.swal2-container) button.swal2-confirm {
    background: var(--gold-gradient) !important;
    color: #000 !important; font-weight: bold !important;
}
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>

    <div class="main-wrapper">
        <div class="cart-page-header">
            <div>
                <p style="margin:0; color:#888; font-size:12px; letter-spacing:1px;">BOOKING STAGE</p>
                <h2>Giỏ hàng của bạn</h2>
            </div>
            <a href="${pageContext.request.contextPath}/seats/layout<c:if test='${not empty cartItems and cartItems.size() > 0}'>?scheduleId=${cartItems[0].scheduleID}</c:if>" class="btn-back" style="color:#aaa; text-decoration:none; font-size:14px;">
                + Chọn thêm ghế
            </a>
        </div>

        <c:choose>
            <c:when test="${empty cartItems or cartItems.size() == 0}">
                <div style="text-align: center; padding: 100px 0; color: #555;">
                    <p style="font-size: 60px; margin:0;">🎫</p>
                    <h3 style="color: #fff; margin: 20px 0 10px;">Chưa có vé nào</h3>
                    <p>Hãy chọn cho mình một vị trí đẹp nhất.</p>
                </div>
            </c:when>
            <c:otherwise>
                
                <div class="cart-layout">
                    
                    <div class="ticket-list">
                        <c:forEach var="item" items="${cartItems}" varStatus="status">
                            <div class="ticket-card">                       
                                <div class="ticket-info">
                                    <div class="ticket-seat">
                                        ${item.seatNumber}
                                        <span class="ticket-type-badge ${item.seatType == 'VIP' ? 'vip' : 'standard'}">
                                            ${item.seatType}
                                        </span>
                                    </div>
                                    <div class="ticket-meta">
                                        <span>Show: ${item.showName}</span>
                                    </div>
                                    
                                </div>
                                    
                                
                                <div class="ticket-price-action">
                                    <div class="ticket-price">
                                        <fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="0"/> đ
                                    </div>
                                    <a href="${pageContext.request.contextPath}/cart?action=remove&index=${status.index}" 
                                       class="btn-remove-text"
                                       onclick="confirmDelete(event, this.href, '${item.seatNumber}')">
                                       Xóa vé
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                        <div id="pagination" class="pagination-container"></div>
                    </div>
                    

                    <div class="cart-summary-box">
                        <div class="summary-title">Thông tin thanh toán</div>
                        <div class="summary-row">
                            <span>Số lượng vé</span>
                            <span>${cartItems.size()} vé</span>
                        </div>
                        <div class="summary-row">
                            <span>Tạm tính</span>
                            <span><fmt:formatNumber value="${total}" type="number" maxFractionDigits="0"/> đ</span>
                        </div>
                        <div class="summary-total">
                            <span>TỔNG CỘNG</span>
                            <span><fmt:formatNumber value="${total}" type="number" maxFractionDigits="0"/> đ</span>
                        </div>

                        <button class="btn-checkout-full" onclick="goCheckout()">
                            TIẾP TỤC THANH TOÁN
                        </button>
                        
                        <a href="${pageContext.request.contextPath}/cart?action=clear" 
                           class="btn-clear-text"
                           onclick="confirmClear(event, this.href)">
                           Xóa toàn bộ giỏ hàng
                        </a>
                    </div>
                </div>

            </c:otherwise>
        </c:choose>
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
<script>
    document.addEventListener("DOMContentLoaded", function () {
        // CẤU HÌNH
        const itemsPerPage = 5; // Số lượng vé hiển thị trên 1 trang
        const ticketList = document.querySelectorAll('.ticket-card'); // Lấy tất cả thẻ vé
        const paginationContainer = document.getElementById('pagination');
        let currentPage = 1;
        const totalItems = ticketList.length;
        const totalPages = Math.ceil(totalItems / itemsPerPage);

        // Hàm hiển thị đúng trang
        function showPage(page) {
            const start = (page - 1) * itemsPerPage;
            const end = start + itemsPerPage;

            ticketList.forEach((item, index) => {
                if (index >= start && index < end) {
                    item.style.display = 'flex'; // Hiển thị vé (dùng flex vì CSS cũ là flex)
                    // Thêm animation nhẹ cho mượt
                    item.style.animation = 'fadeIn 0.5s ease';
                } else {
                    item.style.display = 'none'; // Ẩn vé không thuộc trang này
                }
            });
            
            // Cập nhật trạng thái nút Active
            updateButtons(page);
        }

        // Hàm tạo nút bấm
        function setupPagination() {
            // Nếu ít vé quá (chỉ 1 trang) thì ẩn luôn thanh phân trang cho đẹp
            if (totalPages <= 1) {
                paginationContainer.style.display = 'none';
                return;
            }

            paginationContainer.innerHTML = ""; // Xóa cũ

            // Nút Previous (<)
            const prevBtn = document.createElement('button');
            prevBtn.innerText = '❮';
            prevBtn.classList.add('page-btn');
            prevBtn.onclick = () => {
                if (currentPage > 1) {
                    currentPage--;
                    showPage(currentPage);
                }
            };
            paginationContainer.appendChild(prevBtn);

            // Các nút số (1, 2, 3...)
            for (let i = 1; i <= totalPages; i++) {
                const btn = document.createElement('button');
                btn.innerText = i;
                btn.classList.add('page-btn');
                if (i === currentPage) btn.classList.add('active');

                btn.addEventListener('click', function () {
                    currentPage = i;
                    showPage(currentPage);
                });
                
                paginationContainer.appendChild(btn);
            }

            // Nút Next (>)
            const nextBtn = document.createElement('button');
            nextBtn.innerText = '❯';
            nextBtn.classList.add('page-btn');
            nextBtn.onclick = () => {
                if (currentPage < totalPages) {
                    currentPage++;
                    showPage(currentPage);
                }
            };
            paginationContainer.appendChild(nextBtn);
        }

        function updateButtons(activePage) {
            const buttons = paginationContainer.querySelectorAll('.page-btn');
            // Cập nhật class active cho nút số
            // Nút số bắt đầu từ index 1 (vì index 0 là nút Prev)
            buttons.forEach((btn, index) => {
                btn.classList.remove('active');
                // Logic để tìm đúng nút số và active nó
                if (btn.innerText == activePage) {
                    btn.classList.add('active');
                }
            });
        }

        // CHẠY LẦN ĐẦU
        if (totalItems > 0) {
            setupPagination();
            showPage(1);
        }
    });
</script>

<style>
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}
</style>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/js/auth.js"></script>
</body> 
</html>