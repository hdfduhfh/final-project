<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hỗ Trợ - BookingStage Elite</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600&family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --bg-color: #080808; /* Đen sâu hơn */
            --gold-primary: #d4af37;
            --gold-light: #f3e5ab;
            --text-primary: #e0e0e0;
            --text-muted: #999;
            --glass-bg: rgba(255, 255, 255, 0.02);
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-primary);
            font-family: 'Montserrat', sans-serif; /* Font mặc định cho toàn trang */
            margin: 0;
            padding-top: 80px;
            min-height: 100vh;
            /* Hiệu ứng nền noise nhẹ tạo cảm giác chất liệu giấy cao cấp */
            background-image: radial-gradient(circle at 50% 0%, #1a1a1a 0%, #080808 60%);
        }

        .luxury-container {
            max-width: 900px; /* Gọn gàng, dễ đọc */
            margin: 0 auto;
            padding: 60px 20px 100px;
        }

        /* --- HEADER SECTION --- */
        .page-header {
            text-align: center;
            margin-bottom: 70px;
        }

        .page-header h1 {
            font-family: 'Playfair Display', serif; /* Font Tiêu Đề Sang Trọng */
            font-size: 3.8rem;
            font-weight: 700;
            font-style: italic; /* Chữ nghiêng nhẹ tạo nét điệu đà */
            background: linear-gradient(135deg, #fff 0%, #d4af37 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 15px;
            letter-spacing: -1px;
        }

        .page-header p {
            font-size: 1.1rem;
            color: var(--text-muted);
            font-weight: 300;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        /* --- SEARCH BAR (Minimalist Line) --- */
        .search-wrapper {
            position: relative;
            max-width: 500px;
            margin: 0 auto 60px;
        }

        .search-input {
            width: 100%;
            padding: 15px 0;
            background: transparent;
            border: none;
            border-bottom: 1px solid #333;
            color: #fff;
            font-size: 1.5rem;
            font-family: 'Playfair Display', serif; /* Dùng font tiêu đề cho input để lạ mắt */
            text-align: center;
            transition: all 0.4s ease;
        }

        .search-input:focus {
            outline: none;
            border-bottom-color: var(--gold-primary);
        }

        .search-input::placeholder {
            color: #444;
            font-family: 'Montserrat', sans-serif;
            font-size: 1rem;
            font-weight: 300;
            font-style: normal;
        }

        /* --- CATEGORIES --- */
        .categories {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-bottom: 50px;
            flex-wrap: wrap;
        }

        .category-btn {
            background: transparent;
            border: 1px solid rgba(255,255,255,0.1);
            color: var(--text-muted);
            font-family: 'Montserrat', sans-serif;
            font-size: 0.9rem;
            font-weight: 500;
            padding: 10px 25px;
            border-radius: 50px; /* Bo tròn viên thuốc */
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .category-btn:hover, .category-btn.active {
            border-color: var(--gold-primary);
            color: var(--gold-primary);
            background: rgba(212, 175, 55, 0.05);
        }

        /* --- FAQ LIST --- */
        .faq-list {
            display: flex;
            flex-direction: column;
            gap: 0; /* Liền mạch */
        }

        .faq-item {
            padding: 35px 0;
            border-bottom: 1px solid rgba(255,255,255,0.08);
            position: relative;
        }
        
        /* Hiệu ứng hover cho cả dòng */
        .faq-item:hover .faq-question h3 {
            color: #fff;
            padding-left: 10px; /* Dịch nhẹ chữ */
        }

        .faq-question {
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
        }

        .faq-question h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.6rem;
            font-weight: 400;
            color: #ccc;
            margin: 0;
            transition: all 0.3s ease;
            line-height: 1.4;
        }

        /* Icon mũi tên tinh tế */
        .faq-icon {
            font-size: 1.2rem;
            color: var(--gold-primary);
            transition: transform 0.4s ease;
            font-family: 'Montserrat', sans-serif; /* Đảm bảo icon là ký tự text */
        }

        .faq-item.active .faq-icon {
            transform: rotate(45deg); /* Xoay dấu + thành x, hoặc mũi tên */
        }
        
        .faq-answer {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.5s ease, opacity 0.5s ease, padding-top 0.5s ease;
            opacity: 0;
        }

        .faq-item.active .faq-answer {
            max-height: 500px;
            opacity: 1;
            padding-top: 20px;
        }

        .faq-answer-content {
            font-size: 1rem;
            line-height: 1.8;
            color: #888;
            width: 90%; /* Nội dung ngắn hơn tiêu đề 1 chút cho đẹp */
        }
        
        /* Dropcap cho chữ cái đầu câu trả lời - rất Luxury */
        .faq-answer-content p::first-letter {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            float: left;
            margin-right: 10px;
            line-height: 0.8;
            color: var(--gold-primary);
        }

        /* --- FOOTER LINK --- */
        .support-link {
            margin-top: 80px;
            text-align: center;
            font-size: 0.9rem;
            color: #555;
        }
        
        .support-link a {
            color: var(--gold-primary);
            text-decoration: none;
            font-family: 'Playfair Display', serif;
            font-style: italic;
            font-size: 1.1rem;
            border-bottom: 1px solid transparent;
            transition: border-color 0.3s;
        }
        
        .support-link a:hover {
            border-bottom-color: var(--gold-primary);
        }
        
        @media (max-width: 768px) {
            .page-header h1 { font-size: 2.5rem; }
            .search-input { font-size: 1.2rem; }
            .faq-question h3 { font-size: 1.3rem; }
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/layout/header.jsp" %>
    
    <div class="luxury-container">
        
        <div class="page-header">
            <h1>Câu Hỏi Thường Gặp</h1>
            <p>BookingStage Elite Support</p>
        </div>

        <div class="search-wrapper">
            <input type="text" id="searchFAQ" class="search-input" placeholder="Nhập từ khóa tìm kiếm...">
        </div>

        <div class="categories">
            <button class="category-btn active" onclick="filterFAQ('all')">Tất cả</button>
            <button class="category-btn" onclick="filterFAQ('booking')">Đặt vé</button>
            <button class="category-btn" onclick="filterFAQ('payment')">Thanh toán</button>
            <button class="category-btn" onclick="filterFAQ('refund')">Hoàn hủy</button>
        </div>

        <div class="faq-list" id="faqContainer">
            
            <div class="faq-item" data-category="booking">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <h3>Quy trình đặt vé như thế nào?</h3>
                    <div class="faq-icon">＋</div>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-content">
                        <p>Việc đặt vé được tối giản hóa. Quý khách chỉ cần chọn show diễn trên lịch, chọn vị trí ghế mong muốn và tiến hành thanh toán. Vé điện tử QR-Code sẽ được gửi ngay lập tức.</p>
                    </div>
                </div>
            </div>

            <div class="faq-item" data-category="payment">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <h3>Các phương thức thanh toán được chấp nhận?</h3>
                    <div class="faq-icon">＋</div>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-content">
                        <p>Chúng tôi chấp nhận thẻ tín dụng quốc tế (Visa, Master), thẻ nội địa và các loại ví điện tử phổ biến. Mọi giao dịch đều được mã hóa bảo mật tuyệt đối.</p>
                    </div>
                </div>
            </div>

            <div class="faq-item" data-category="refund">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <h3>Chính sách hoàn tiền khi hủy vé?</h3>
                    <div class="faq-icon">＋</div>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-content">
                        <p>Quý khách được hoàn tiền 100% nếu hủy trước 48h. Trong khoảng 24h-48h hoàn 30%. Rất tiếc chúng tôi không hỗ trợ hoàn tiền nếu hủy sát giờ diễn.</p>
                    </div>
                </div>
            </div>

            <div class="faq-item" data-category="booking">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <h3>Tôi có thể chọn chỗ ngồi cụ thể không?</h3>
                    <div class="faq-icon">＋</div>
                </div>
                <div class="faq-answer">
                    <div class="faq-answer-content">
                        <p>Tất nhiên. Hệ thống sơ đồ trực quan cho phép quý khách nhìn thấy view sân khấu từ vị trí ghế chọn trước khi quyết định đặt chỗ.</p>
                    </div>
                </div>
            </div>

        </div>

        <div class="support-link">
            Vẫn chưa tìm thấy câu trả lời? <a href="#">Liên hệ Đội ngũ hỗ trợ</a>
        </div>

    </div>

    <%@ include file="/WEB-INF/views/layout/footer.jsp" %>

    <script>
        function toggleFAQ(element) {
            const item = element.parentElement;
            const icon = element.querySelector('.faq-icon');
            const isActive = item.classList.contains('active');
            
            // Đóng các tab khác
            document.querySelectorAll('.faq-item').forEach(i => {
                i.classList.remove('active');
                // Reset icon về dấu +
                const iIcon = i.querySelector('.faq-icon');
                if(iIcon) iIcon.textContent = '＋'; 
            });

            if (!isActive) {
                item.classList.add('active');
                // Đổi icon thành dấu x (xoay 45 độ bằng CSS rồi, nên vẫn dùng dấu + hoặc đổi text đều được)
                // Ở đây mình dùng CSS rotate cho mượt, text giữ nguyên hoặc đổi tùy ý
            }
        }

        function filterFAQ(category) {
            document.querySelectorAll('.category-btn').forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            const items = document.querySelectorAll('.faq-item');
            items.forEach(item => {
                item.style.display = (category === 'all' || item.dataset.category === category) 
                    ? 'block' : 'none';
            });
        }
        
        document.getElementById('searchFAQ').addEventListener('input', function(e) {
            const term = e.target.value.toLowerCase();
            document.querySelectorAll('.faq-item').forEach(item => {
                const text = item.innerText.toLowerCase();
                item.style.display = text.includes(term) ? 'block' : 'none';
            });
        });
    </script>
</body>
</html>