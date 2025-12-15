<%-- 
    Document   : faq
    Created on : Dec 11, 2025, 2:23:13 PM
    Author     : DANG KHOA
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Câu hỏi thường gặp - BookingStage</title>
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
        
        .search-box {
            max-width: 600px;
            margin: 0 auto 40px;
        }
        
        .search-box input {
            width: 100%;
            padding: 15px 20px;
            font-size: 1.1rem;
            border: 2px solid #e2e8f0;
            border-radius: 50px;
            outline: none;
            transition: all 0.3s ease;
        }
        
        .search-box input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        .categories {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .category-btn {
            padding: 15px 20px;
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            font-size: 1.1rem;
        }
        
        .category-btn:hover, .category-btn.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: transparent;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }
        
        .faq-section {
            background: white;
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            animation: fadeInUp 0.8s ease;
        }
        
        .faq-item {
            border-bottom: 1px solid #e2e8f0;
            padding: 20px 0;
        }
        
        .faq-item:last-child {
            border-bottom: none;
        }
        
        .faq-question {
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
            user-select: none;
        }
        
        .faq-question h3 {
            font-size: 1.3rem;
            color: #1e293b;
            margin: 0;
            flex: 1;
        }
        
        .faq-icon {
            font-size: 1.5rem;
            color: #667eea;
            transition: transform 0.3s ease;
        }
        
        .faq-question:hover .faq-icon {
            transform: scale(1.2);
        }
        
        .faq-answer {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease;
            padding-top: 0;
        }
        
        .faq-answer.active {
            max-height: 500px;
            padding-top: 20px;
        }
        
        .faq-answer p {
            font-size: 1.1rem;
            color: #64748b;
            line-height: 1.8;
            margin-bottom: 10px;
        }
        
        .faq-answer ul {
            margin: 15px 0;
            padding-left: 25px;
        }
        
        .faq-answer li {
            color: #64748b;
            margin-bottom: 8px;
            line-height: 1.6;
        }
        
        .contact-section {
            text-align: center;
            margin-top: 50px;
            padding: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            color: white;
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
            
            .categories {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/layout/header.jsp" %>
    
    <div class="container">
        <div class="page-header">
            <h1>❓ Câu Hỏi Thường Gặp</h1>
            <p>Tìm câu trả lời nhanh chóng cho các thắc mắc của bạn</p>
        </div>
        
        <div class="search-box">
            <input type="text" id="searchFAQ" placeholder="🔍 Tìm kiếm câu hỏi...">
        </div>
        
        <div class="categories">
            <button class="category-btn active" onclick="filterFAQ('all')">📋 Tất cả</button>
            <button class="category-btn" onclick="filterFAQ('booking')">🎟️ Đặt vé</button>
            <button class="category-btn" onclick="filterFAQ('payment')">💳 Thanh toán</button>
            <button class="category-btn" onclick="filterFAQ('ticket')">🎫 Vé điện tử</button>
            <button class="category-btn" onclick="filterFAQ('refund')">🔄 Đổi/Hoàn</button>
        </div>
        
        <div class="faq-section" id="faqContainer">
            <!-- Booking Questions -->
            <div class="faq-item" data-category="booking">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>🎟️ Làm thế nào để đặt vé?</h3>
                    <span class="faq-icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Đặt vé rất đơn giản với 3 bước:</p>
                    <ul>
                        <li><strong>Bước 1:</strong> Chọn show bạn muốn xem từ danh sách</li>
                        <li><strong>Bước 2:</strong> Chọn ghế và số lượng vé</li>
                        <li><strong>Bước 3:</strong> Điền thông tin và thanh toán</li>
                    </ul>
                    <p>Vé điện tử sẽ được gửi đến email của bạn trong vòng 2-5 phút.</p>
                </div>
            </div>
            
            <div class="faq-item" data-category="booking">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>📅 Có thể đặt vé trước bao lâu?</h3>
                    <span class="faq-icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Bạn có thể đặt vé ngay khi show được công bố bán vé trên website. Thông thường, vé được mở bán từ <strong>1-3 tháng trước</strong> ngày diễn ra show.</p>
                    <p>Chúng tôi khuyên bạn nên đặt sớm để có vị trí ghế đẹp nhất!</p>
                </div>
            </div>
            
            <div class="faq-item" data-category="booking">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>👥 Có thể đặt vé cho nhiều người cùng lúc không?</h3>
                    <span class="faq-icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Có! Bạn có thể chọn nhiều ghế trong cùng một đơn hàng. Tối đa <strong>10 vé/giao dịch</strong>.</p>
                    <p>Nếu cần đặt nhiều hơn cho nhóm lớn, vui lòng liên hệ hotline <strong>1900-xxxx</strong> để được hỗ trợ đặt vé nhóm với giá ưu đãi.</p>
                </div>
            </div>
            
            <!-- Payment Questions -->
            <div class="faq-item" data-category="payment">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>💳 Có những phương thức thanh toán nào?</h3>
                    <span class="faq-icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Chúng tôi hỗ trợ nhiều phương thức thanh toán:</p>
                    <ul>
                        <li>💳 Thẻ tín dụng/ghi nợ quốc tế (Visa, Mastercard, JCB)</li>
                        <li>🏦 Thẻ ATM nội địa (có Internet Banking)</li>
                        <li>📱 Ví điện tử (Momo, ZaloPay, VNPay)</li>
                        <li>🔄 Chuyển khoản ngân hàng</li>
                    </ul>
                    <p>Tất cả giao dịch đều được mã hóa và bảo mật tuyệt đối.</p>
                </div>
            </div>
            
            <div class="faq-item" data-category="payment">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>🔒 Thanh toán online có an toàn không?</h3>
                    <span class="faq-icon">+</span>
                </div>
                <div class="faq-answer">
                    <p><strong>Hoàn toàn an toàn!</strong> Chúng tôi sử dụng:</p>
                    <ul>
                        <li>Mã hóa SSL 256-bit</li>
                        <li>Cổng thanh toán quốc tế uy tín</li>
                        <li>Không lưu trữ thông tin thẻ</li>
                        <li>Xác thực 3D Secure</li>
                    </ul>
                    <p>Thông tin thanh toán của bạn được bảo vệ tuyệt đối!</p>
                </div>
            </div>
            
            <div class="faq-item" data-category="payment">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>💸 Có phải trả thêm phí giao dịch không?</h3>
                    <span class="faq-icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Phí giao dịch tùy theo phương thức:</p>
                    <ul>
                        <li>Thẻ tín dụng/ATM: <strong>Miễn phí</strong></li>
                        <li>Ví điện tử: <strong>Miễn phí</strong></li>
                        <li>Chuyển khoản: <strong>Miễn phí</strong></li>
                    </ul>
                    <p>Giá vé đã bao gồm VAT. Không có phí ẩn!</p>
                </div>
            </div>
            
            <!-- Ticket Questions -->
            <div class="faq-item" data-category="ticket">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>🎫 Vé điện tử là gì?</h3>
                    <span class="faq-icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Vé điện tử là vé dạng file PDF có mã QR code, được gửi qua email ngay sau khi thanh toán thành công.</p>
                    <p>Bạn có thể:</p>
                    <ul>
                        <li>Lưu vào điện thoại</li>
                        <li>In ra giấy</li>
                        <li>Xuất trình khi vào cửa</li>
                    </ul>
                    <p><strong>Không cần đổi vé giấy</strong>, quét QR code là vào!</p>
                </div>
            </div>
            
            <div class="faq-item" data-category="ticket">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>📧 Không nhận được vé qua email?</h3>
                    <span class="faq-icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Nếu sau 10 phút vẫn chưa nhận được vé:</p>
                    <ul>
                        <li>Kiểm tra hộp thư <strong>Spam/Junk</strong></li>
                        <li>Kiểm tra lại email đã nhập đúng chưa</li>
                        <li>Vào <strong>"Tài khoản"</strong> → <strong>"Lịch sử vé"</strong> để tải lại</li>
                        <li>Liên hệ hotline <strong>1900-xxxx</strong> để được gửi lại</li>
                    </ul>
                </div>
            </div>
            
            <div class="faq-item" data-category="ticket">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>🔄 Có thể chuyển vé cho người khác không?</h3>
                    <span class="faq-icon">+</span>
                </div>
                <div class="faq-answer">
                    <p><strong>Có!</strong> Vé điện tử có thể chuyển giao:</p>
                    <ul>
                        <li>Forward email vé cho người nhận</li>
                        <li>Hoặc in/chụp vé gửi qua Zalo, Messenger</li>
                        <li>Người nhận xuất trình vé khi vào cửa là được</li>
                    </ul>
                    <p><strong>Lưu ý:</strong> Mỗi vé chỉ sử dụng được <strong>1 lần duy nhất</strong>!</p>
                </div>
            </div>
            
            <!-- Refund Questions -->
            <div class="faq-item" data-category="refund">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>🔄 Có thể hoàn vé không?</h3>
                    <span class="faq-icon">+</span>
                </div>
                <div class="faq-answer">
                    <p><strong>Có!</strong> Tùy theo thời điểm hoàn:</p>
                    <ul>
                        <li>≥ 7 ngày trước show: Hoàn <strong>100%</strong></li>
                        <li>3-7 ngày trước: Hoàn <strong>70%</strong></li>
                        <li>1-3 ngày trước: Hoàn <strong>50%</strong></li>
                        <li>< 24 giờ: <strong>Không hoàn</strong></li>
                    </ul>
                    <p>Xem chi tiết tại <a href="${pageContext.request.contextPath}/policy" style="color: #667eea;">Chính sách đổi/trả vé</a></p>
                </div>
            </div>
            
            <div class="faq-item" data-category="refund">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>⏰ Hoàn tiền mất bao lâu?</h3>
                    <span class="faq-icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Thời gian hoàn tiền tùy phương thức thanh toán:</p>
                    <ul>
                        <li>Thẻ tín dụng/ATM: <strong>7-14 ngày làm việc</strong></li>
                        <li>Ví điện tử: <strong>3-5 ngày làm việc</strong></li>
                        <li>Chuyển khoản: <strong>5-7 ngày làm việc</strong></li>
                    </ul>
                    <p>Bạn sẽ nhận email xác nhận khi tiền được hoàn về.</p>
                </div>
            </div>
            
            <!-- General Questions -->
            <div class="faq-item" data-category="all">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>🕐 Nên đến trước bao lâu?</h3>
                    <span class="faq-icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Chúng tôi khuyến khích bạn đến trước <strong>30-45 phút</strong> để:</p>
                    <ul>
                        <li>Check-in và quét vé</li>
                        <li>Gửi đồ (nếu cần)</li>
                        <li>Mua đồ ăn/nước uống</li>
                        <li>Tìm chỗ ngồi</li>
                        <li>Tránh bỏ lỡ phần mở đầu</li>
                    </ul>
                </div>
            </div>
            
            <div class="faq-item" data-category="all">
                <div class="faq-question" onclick="toggleAnswer(this)">
                    <h3>👔 Có quy định về trang phục không?</h3>
                    <span class="faq-icon">+</span>
                </div>
                <div class="faq-answer">
                    <p>Trang phục lịch sự, gọn gàng. <strong>Không được:</strong></p>
                    <ul>
                        <li>Mặc áo ba lỗ, quần đùi, dép lê</li>
                        <li>Trang phục quá hở hang</li>
                        <li>Mũ cao, phụ kiện che tầm nhìn</li>
                    </ul>
                    <p>Một số show cao cấp yêu cầu <strong>Smart Casual</strong> hoặc <strong>Formal</strong>.</p>
                </div>
            </div>
        </div>
        
        <div class="contact-section">
            <h3>Không Tìm Thấy Câu Trả Lời?</h3>
            <p style="margin-bottom: 30px; opacity: 0.9;">Liên hệ ngay với chúng tôi, đội ngũ hỗ trợ luôn sẵn sàng!</p>
            <div style="display: flex; justify-content: center; gap: 30px; flex-wrap: wrap;">
                <div>📞 <strong>1900-xxxx</strong></div>
                <div>✉️ <strong>support@bookingstage.vn</strong></div>
                <div>💬 <strong>Live Chat</strong></div>
            </div>
        </div>
    </div>
    
    <%@ include file="/WEB-INF/views/layout/footer.jsp" %>
    
    <script>
        // Toggle FAQ Answer
        function toggleAnswer(element) {
            const answer = element.nextElementSibling;
            const icon = element.querySelector('.faq-icon');
            
            // Close all other answers
            document.querySelectorAll('.faq-answer').forEach(item => {
                if (item !== answer) {
                    item.classList.remove('active');
                    item.previousElementSibling.querySelector('.faq-icon').textContent = '+';
                }
            });
            
            // Toggle current answer
            answer.classList.toggle('active');
            icon.textContent = answer.classList.contains('active') ? '−' : '+';
        }
        
        // Filter FAQs by category
        function filterFAQ(category) {
            const items = document.querySelectorAll('.faq-item');
            const buttons = document.querySelectorAll('.category-btn');
            
            // Update active button
            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            // Filter items
            items.forEach(item => {
                if (category === 'all' || item.dataset.category === category) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        }
        
        // Search FAQs
        document.getElementById('searchFAQ').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const items = document.querySelectorAll('.faq-item');
            
            items.forEach(item => {
                const question = item.querySelector('h3').textContent.toLowerCase();
                const answer = item.querySelector('.faq-answer').textContent.toLowerCase();
                
                if (question.includes(searchTerm) || answer.includes(searchTerm)) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
