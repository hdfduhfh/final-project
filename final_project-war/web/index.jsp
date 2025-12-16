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
        <section class="section" style="max-width: 100%; padding: 0;"> <div class="luxury-stage-section">
                <div class="gold-dust"></div>

                <div class="luxury-header">
                    <h2 class="luxury-title">Tác Phẩm Kinh Điển</h2>
                    <div class="luxury-divider"></div>
                    <p style="color: #888; margin-top: 15px; font-style: italic;">Tuyển tập những vở diễn đặc sắc nhất mùa này</p>
                </div>

                <div class="luxury-grid">
                    <c:choose>
                        <%-- TRƯỜNG HỢP CÓ DỮ LIỆU TỪ DB --%>
                        <c:when test="${not empty featuredShows}">
                            <c:forEach var="show" items="${featuredShows}">
                                <a href="${pageContext.request.contextPath}/shows/detail/${show.showID}" class="luxury-card">
                                    <div class="badge-corner">HOT</div>

                                    <img src="${pageContext.request.contextPath}/${show.showImage}" 
                                         alt="${show.showName}" class="luxury-poster"
                                         onerror="this.src='https://via.placeholder.com/300x450?text=BookingStage'" />

                                    <div class="luxury-info">
                                        <h3 class="show-name">${show.showName}</h3>
                                        <span class="btn-luxury-gold">Xem Chi Tiết</span>
                                    </div>
                                </a>
                            </c:forEach>
                        </c:when>

                        <%-- TRƯỜNG HỢP DEMO (KHÔNG CÓ DỮ LIỆU) --%>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/shows/detail/1" class="luxury-card">
                                <div class="badge-corner">BÁN CHẠY</div>
                                <img src="${pageContext.request.contextPath}/assets/images/show/NGHIEP_QUAT.jpg" class="luxury-poster" onerror="this.src='https://via.placeholder.com/280x420/111/fff?text=Nghiệp+Quật'" />
                                <div class="luxury-info">
                                    <h3 class="show-name">Nghiệp Quật</h3>
                                    <span class="btn-luxury-gold">Đặt vé ngay</span>
                                </div>
                            </a>

                            <a href="${pageContext.request.contextPath}/shows/detail/2" class="luxury-card">
                                <div class="badge-corner">MỚI</div>
                                <img src="${pageContext.request.contextPath}/assets/images/show/ANH_TRAI_SAY_AI.jpg" class="luxury-poster" onerror="this.src='https://via.placeholder.com/280x420/111/fff?text=Anh+Trai'" />
                                <div class="luxury-info">
                                    <h3 class="show-name">Anh Trai Say Hi</h3>
                                    <span class="btn-luxury-gold">Đặt vé ngay</span>
                                </div>
                            </a>

                            <a href="${pageContext.request.contextPath}/shows/detail/3" class="luxury-card">
                                <img src="${pageContext.request.contextPath}/assets/images/show/ESCAPE_ROOM_CAN_NHA_MA_QUAI.jpg" class="luxury-poster" onerror="this.src='https://via.placeholder.com/280x420/111/fff?text=Nhà+Ma'" />
                                <div class="luxury-info">
                                    <h3 class="show-name">Căn Nhà Ma Quái</h3>
                                    <span class="btn-luxury-gold">Đặt vé ngay</span>
                                </div>
                            </a>

                            <a href="${pageContext.request.contextPath}/shows/detail/4" class="luxury-card">
                                <img src="${pageContext.request.contextPath}/assets/images/show/DAI_NAO_THANH_BOMBAY.jpg" class="luxury-poster" onerror="this.src='https://via.placeholder.com/280x420/111/fff?text=Đại+Náo'" />
                                <div class="luxury-info">
                                    <h3 class="show-name">Đại Náo Bombay</h3>
                                    <span class="btn-luxury-gold">Đặt vé ngay</span>
                                </div>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="stats" style="margin-top: 60px; max-width: 1100px; margin-left: auto; margin-right: auto;">
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