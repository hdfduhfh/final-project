<%-- 
    Document   : index
    Created on : Dec 5, 2025, 2:27:16 PM
    Author     : DANG KHOA
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>BookingStage — Rạp hát nghệ thuật sang trọng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <script src="https://unpkg.com/three@0.160.0/build/three.min.js"></script>
    </head>
    <body>
        <div class="promo-ticker">
            <div class="ticker-track">
                <span class="ticker-item">
                    ✨ ƯU ĐÃI EARLY BIRD: GIẢM 15% KHI ĐẶT TRƯỚC 7 NGÀY &nbsp;&mdash;&nbsp; 🥂 TẶNG WELCOME DRINK & LỐI ĐI RIÊNG CHO HẠNG VÉ DIAMOND &nbsp;&mdash;&nbsp; 🎭 RA MẮT VỞ DIỄN MỚI "DẠ KHÚC MÙA ĐÔNG" &nbsp;&mdash;&nbsp; 📞 HOTLINE HỖ TRỢ 24/7: 1900-9999
                </span>
                <span class="ticker-item">
                    ✨ ƯU ĐÃI EARLY BIRD: GIẢM 15% KHI ĐẶT TRƯỚC 7 NGÀY &nbsp;&mdash;&nbsp; 🥂 TẶNG WELCOME DRINK & LỐI ĐI RIÊNG CHO HẠNG VÉ DIAMOND &nbsp;&mdash;&nbsp; 🎭 RA MẮT VỞ DIỄN MỚI "DẠ KHÚC MÙA ĐÔNG" &nbsp;&mdash;&nbsp; 📞 HOTLINE HỖ TRỢ 24/7: 1900-9999
                </span>
            </div>
        </div>
        <%@ include file="/WEB-INF/views/layout/header.jsp" %>

        <!-- 3D Background -->
        <div id="bg3d"></div>

        <!-- Hero -->
        <section class="hero">
            <div class="hero-inner">
                <h1 class="hero-title">✨ Nghệ thuật đỉnh cao ✨</h1>
                <p class="hero-desc">Rạp hát sang trọng, đẳng cấp, với AI đồng hành hỗ trợ bạn mọi lúc.</p>
                <div>
                    <a class="btn-gold" href="${pageContext.request.contextPath}/shows">Đặt vé ngay</a>
                    <a class="btn-outline" href="${pageContext.request.contextPath}/schedule">Xem lịch diễn</a>
                </div>
            </div>
        </section>

        <!-- Featured Shows -->
        <section class="section">
            <div class="section-header">
                <h2>🌟 Chương trình nổi bật</h2>
                <p>Những show đang được yêu thích nhất</p>
            </div>
            <div class="grid">
                <div class="card">
                    <img src="${pageContext.request.contextPath}/assets/images/show/bong-dan-ong10113.jpeg" 
                         alt="Show 1"
                         onerror="this.src='https://via.placeholder.com/400x220/667eea/ffffff?text=Show+1'">
                    <div class="content">
                        <div class="tag">🎭 Kịch</div>
                        <h4>Dạ Cổ Hoài Lang</h4>
                        <div style="color:#ccc;font-size:14px;margin-top:6px;">📅 25/12/2024 • 🕐 19:30</div>
                        <div class="price">300.000đ - 800.000đ</div>
                    </div>
                </div>
                <div class="card">
                    <img src="${pageContext.request.contextPath}/assets/images/show/chuyen-cu-minh-bo-qua10111.jpg" 
                         alt="Show 2"
                         onerror="this.src='https://via.placeholder.com/400x220/764ba2/ffffff?text=Show+2'">
                    <div class="content">
                        <div class="tag">🎵 Hòa nhạc</div>
                        <h4>Giao Hưởng Việt Nam</h4>
                        <div style="color:#ccc;font-size:14px;margin-top:6px;">📅 30/12/2024 • 🕐 20:00</div>
                        <div class="price">500.000đ - 1.500.000đ</div>
                    </div>
                </div>
                <div class="card">
                    <img src="${pageContext.request.contextPath}/assets/images/show/anh-trai-say-ai32102.jpg" 
                         alt="Show 3"
                         onerror="this.src='https://via.placeholder.com/400x220/4facfe/ffffff?text=Show+3'">
                    <div class="content">
                        <div class="tag">💃 Múa</div>
                        <h4>Văn Hóa Dân Tộc</h4>
                        <div style="color:#ccc;font-size:14px;margin-top:6px;">📅 05/01/2025 • 🕐 19:00</div>
                        <div class="price">200.000đ - 600.000đ</div>
                    </div>
                </div>
            </div>

            <!-- Stats Section -->
            <div class="stats">
                <div class="stat">
                    <h3>500+</h3>
                    <p>Chương trình/năm</p>
                </div>
                <div class="stat">
                    <h3>50K+</h3>
                    <p>Khách hàng hài lòng</p>
                </div>
                <div class="stat">
                    <h3>100+</h3>
                    <p>Nghệ sĩ nổi tiếng</p>
                </div>
                <div class="stat">
                    <h3>10+</h3>
                    <p>Năm kinh nghiệm</p>
                </div>
            </div>
        </section>

        <!-- Chat icon -->
        <div id="chatIcon" class="chat-icon">💬</div>

        <!-- Chat dock with AI -->
        <div class="chat-dock" id="chatDock">
            <div class="chat-header">
                <div class="chat-header-info">
                    <div class="ai-avatar">🤖</div>
                    <div>
                        <div style="font-size:16px;">AI Assistant</div>
                        <div style="font-size:11px;opacity:0.8;">Powered by Claude AI</div>
                    </div>
                </div>
                <span id="chatClose" class="chat-close">×</span>
            </div>

            <div class="chat-body" id="chatBody"></div>

            <div class="chat-input">
                <input id="chatInput" placeholder="Hỏi AI về show, giá vé, lịch diễn..." autocomplete="off"/>
                <button class="send-btn" id="sendBtn">Gửi</button>
            </div>
        </div>

        <!-- Footer -->
        <%@ include file="/WEB-INF/views/layout/footer.jsp" %>
        <!-- Background 3D với Three.js -->
        <script src="${pageContext.request.contextPath}/js/bg3d.js"></script>
        <!-- Chat dock toggle -->
        <script src="${pageContext.request.contextPath}/js/chat-toggle.js"></script>
        <!-- AI Chatbot Script - FIXED VERSION -->
        <script src="${pageContext.request.contextPath}/js/chatbot.js"></script>
    </body>
</html>