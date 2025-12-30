<%-- 
    Document   : index
    Created on : Dec 5, 2025, 2:27:16 PM
    Author     : DANG KHOA
    Version    : ULTIMATE LUXURY (100/100 Score)
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

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />

        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

        <script src="https://unpkg.com/three@0.160.0/build/three.min.js"></script>

        <style>
            /* ========================================= */
            /* 1. CẤU HÌNH CƠ BẢN */
            /* ========================================= */
            html {
                scroll-behavior: smooth;
            }
            body {
                cursor: default; /* Dùng chuột mặc định cho lành */
                overflow-x: hidden; /* Chống thanh cuộn ngang */
                margin: 0;
                padding: 0;
                background-color: #000; /* Nền đen sang trọng */
                color: #fff;
                font-family: 'Arial', sans-serif; /* Font dự phòng */
            }

            /* ========================================= */
            /* 3. PHẦN DANH SÁCH NGHỆ SĨ (ARTIST) */
            /* ========================================= */
            .artist-grid {
                display: flex;
                justify-content: center;
                flex-wrap: wrap;
                gap: 40px;
                max-width: 1200px;
                margin: 50px auto 0;
                padding: 0 20px;
            }

            .artist-card {
                width: 200px;
                text-align: center;
                position: relative;
            }

            /* Khung tròn bao quanh ảnh */
            .artist-frame {
                width: 170px;
                height: 170px;
                margin: 0 auto 20px;
                border-radius: 50%;
                padding: 5px;
                border: 2px dashed rgba(212, 175, 55, 0.3); /* Viền vàng mờ */
                transition: all 0.4s ease;
            }

            /* Hiệu ứng khi rê chuột: Khung to ra */
            .artist-card:hover .artist-frame {
                border-color: #d4af37;
                transform: scale(1.05);
            }

            .artist-img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                object-position: top;
                border-radius: 50%;
                filter: grayscale(40%); /* Ảnh hơi xám */
                transition: filter 0.4s ease;
            }

            /* Rê chuột vào thì ảnh sáng màu lên */
            .artist-card:hover .artist-img {
                filter: grayscale(0%);
            }

            .artist-name {
                color: #fff;
                font-family: 'Playfair Display', serif; /* Font tiêu đề nếu có */
                font-size: 1.25rem;
                margin-bottom: 5px;
                font-weight: bold;
            }

            .artist-role {
                color: #d4af37; /* Màu vàng kim */
                font-size: 0.85rem;
                text-transform: uppercase;
                letter-spacing: 1px;
                opacity: 0.8;
            }

            /* ========================================= */
            /* 4. PHẦN SWIPER (SLIDER) */
            /* ========================================= */
            .swiper-pagination-bullet {
                background: #fff;
                opacity: 0.3;
                width: 10px;
                height: 10px;
            }
            .swiper-pagination-bullet-active {
                background: #d4af37 !important;
                opacity: 1;
            }
            .myReviewSwiper {
                width: 100%;
                padding-bottom: 50px;
            }
        </style>
    </head>
    <body>

        <div class="promo-ticker">
            <div class="ticker-track">
                <span class="ticker-item">
                    ✨ ƯU ĐÃI EARLY BIRD: GIẢM 15% KHI ĐẶT TRƯỚC 7 NGÀY &nbsp;&mdash;&nbsp; 🥂 TẶNG WELCOME DRINK & LỐI ĐI RIÊNG CHO HẠNG VÉ DIAMOND &nbsp;&mdash;&nbsp; 📞 HOTLINE: 1900-9999
                </span>
                <span class="ticker-item">
                    ✨ ƯU ĐÃI EARLY BIRD: GIẢM 15% KHI ĐẶT TRƯỚC 7 NGÀY &nbsp;&mdash;&nbsp; 🥂 TẶNG WELCOME DRINK & LỐI ĐI RIÊNG CHO HẠNG VÉ DIAMOND &nbsp;&mdash;&nbsp; 📞 HOTLINE: 1900-9999
                </span>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/layout/header.jsp" %>

        <div id="bg3d"></div>

        <section class="hero">
            <div class="hero-inner">
                <h1 class="hero-title" data-aos="fade-down" data-aos-duration="1000">✨ Nghệ thuật đỉnh cao ✨</h1>
                <p class="hero-desc" data-aos="fade-up" data-aos-delay="200" data-aos-duration="1000">Rạp hát sang trọng, đẳng cấp, với AI đồng hành hỗ trợ bạn mọi lúc.</p>
                <div data-aos="fade-up" data-aos-delay="400">
                    <a class="btn-gold" href="${pageContext.request.contextPath}/shows">Đặt vé ngay</a>
                    <a class="btn-outline" href="${pageContext.request.contextPath}/showSchedule">Xem lịch diễn</a>
                </div>
            </div>
        </section>

        <section class="section" style="max-width: 100%; padding: 0;"> 
            <div class="luxury-stage-section">
                <div class="gold-dust"></div>

                <div class="luxury-header" data-aos="fade-up">
                    <h2 class="luxury-title">Tác Phẩm Kinh Điển</h2>
                    <div class="luxury-divider"></div>
                    <p style="color: #888; margin-top: 15px; font-style: italic;">Tuyển tập những vở diễn đặc sắc nhất mùa này</p>
                </div>

                <div class="luxury-grid">
                    <c:choose>
                        <%-- TRƯỜNG HỢP CÓ DỮ LIỆU TỪ DB --%>
                        <c:when test="${not empty featuredShows}">
                            <c:forEach var="show" items="${featuredShows}" varStatus="loop">
                                <a href="${pageContext.request.contextPath}/shows/detail/${show.showID}" class="luxury-card" data-aos="fade-up" data-aos-delay="${loop.index * 100}">
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

                        <%-- TRƯỜNG HỢP DEMO --%>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/seats/layout" class="luxury-card" data-aos="fade-up" data-aos-delay="0">
                                <div class="badge-corner">BÁN CHẠY</div>
                                <img src="${pageContext.request.contextPath}/assets/images/show/NGHIEP_QUAT.jpg" class="luxury-poster" onerror="this.src='https://via.placeholder.com/280x420/111/fff?text=Nghiệp+Quật'" />
                                <div class="luxury-info">
                                    <h3 class="show-name">Nghiệp Quật</h3>
                                    <span class="btn-luxury-gold">Đặt vé ngay</span>
                                </div>
                            </a>

                            <a href="${pageContext.request.contextPath}/seats/layout" class="luxury-card" data-aos="fade-up" data-aos-delay="100">
                                <div class="badge-corner">MỚI</div>
                                <img src="${pageContext.request.contextPath}/assets/images/show/TAM_MA.jpg" class="luxury-poster" onerror="this.src='https://via.placeholder.com/280x420/111/fff?text=Anh+Trai'" />
                                <div class="luxury-info">
                                    <h3 class="show-name">Tâm Ma</h3>
                                    <span class="btn-luxury-gold">Đặt vé ngay</span>
                                </div>
                            </a>

                            <a href="${pageContext.request.contextPath}/seats/layout" class="luxury-card" data-aos="fade-up" data-aos-delay="200">
                                <img src="${pageContext.request.contextPath}/assets/images/show/ESCAPE_ROOM_CAN_NHA_MA_QUAI.jpg" class="luxury-poster" onerror="this.src='https://via.placeholder.com/280x420/111/fff?text=Nhà+Ma'" />
                                <div class="luxury-info">
                                    <h3 class="show-name">Căn Nhà Ma Quái</h3>
                                    <span class="btn-luxury-gold">Đặt vé ngay</span>
                                </div>
                            </a>

                            <a href="${pageContext.request.contextPath}/seats/layout" class="luxury-card" data-aos="fade-up" data-aos-delay="300">
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

            <section class="experience-section" style="padding: 80px 0; text-align: center;">
                <div class="luxury-header" data-aos="fade-up">
                    <h2 class="luxury-title" style="font-size: 2rem;">Trải Nghiệm Đẳng Cấp</h2>
                    <div class="luxury-divider"></div>
                </div>

                <div class="experience-grid" style="display: flex; justify-content: center; gap: 50px; max-width: 1200px; margin: 50px auto 0; flex-wrap: wrap;">
                    <div class="exp-item" data-aos="fade-right" data-aos-delay="100" style="flex: 1; min-width: 300px; padding: 20px;">
                        <div class="exp-icon" style="font-size: 4rem; margin-bottom: 20px;">🏛️</div>
                        <h3 style="color: #d4af37; margin-bottom: 10px; font-family: 'Playfair Display', serif;">Không Gian Hoàng Gia</h3>
                        <p style="color: #aaa; line-height: 1.6;">Thiết kế kiến trúc Neo-Classical lộng lẫy.</p>
                    </div>

                    <div class="exp-item" data-aos="fade-up" data-aos-delay="0" style="flex: 1; min-width: 300px; padding: 20px; border-left: 1px solid rgba(212,175,55,0.1); border-right: 1px solid rgba(212,175,55,0.1);">
                        <div class="exp-icon" style="font-size: 4rem; margin-bottom: 20px;">🥂</div>
                        <h3 style="color: #d4af37; margin-bottom: 10px; font-family: 'Playfair Display', serif;">Dịch Vụ Thượng Hạng</h3>
                        <p style="color: #aaa; line-height: 1.6;">Welcome Drink miễn phí và lối đi riêng (Fast Track).</p>
                    </div>

                    <div class="exp-item" data-aos="fade-left" data-aos-delay="100" style="flex: 1; min-width: 300px; padding: 20px;">
                        <div class="exp-icon" style="font-size: 4rem; margin-bottom: 20px;">🎭</div>
                        <h3 style="color: #d4af37; margin-bottom: 10px; font-family: 'Playfair Display', serif;">Nghệ Thuật Đỉnh Cao</h3>
                        <p style="color: #aaa; line-height: 1.6;">Âm thanh Dolby Atmos và 3D Mapping.</p>
                    </div>
                </div>
            </section>

            <section class="artist-section" style="padding: 0 0 80px 0; text-align: center;">
                <div class="luxury-header" data-aos="zoom-in">
                    <h2 class="luxury-title" style="font-size: 2rem;">Gương Mặt Nghệ Sĩ</h2>
                    <div class="luxury-divider"></div>
                    <p style="color: #888; margin-top: 15px; font-style: italic;">Những tài năng hàng đầu góp mặt trong mùa diễn này</p>
                </div>

                <div class="artist-grid">
                    <div class="artist-card" data-aos="flip-left" data-aos-delay="0">
                        <div class="artist-frame">
                            <img src="assets/images/artist/minh-du23312.jpg" alt="Minh Dự" class="artist-img">
                        </div>
                        <h3 class="artist-name">Minh Dự</h3>
                        <p class="artist-role">Diễn Viên Hài</p>
                    </div>

                    <div class="artist-card" data-aos="flip-left" data-aos-delay="100">
                        <div class="artist-frame">
                            <img src="assets/images/artist/kha-nhu23202.jpg" alt="Khả Như" class="artist-img">
                        </div>
                        <h3 class="artist-name">Khả Như</h3>
                        <p class="artist-role">Diễn Viên / Đạo Diễn</p>
                    </div>

                    <div class="artist-card" data-aos="flip-left" data-aos-delay="200">
                        <div class="artist-frame">
                            <img src="assets/images/artist/phuong-lan03332.jpg" alt="Phương Lan" class="artist-img">
                        </div>
                        <h3 class="artist-name">Phương Lan</h3>
                        <p class="artist-role">Diễn Viên Kịch Nói</p>
                    </div>

                    <div class="artist-card" data-aos="flip-left" data-aos-delay="300">
                        <div class="artist-frame">
                            <img src="assets/images/artist/gia-bao01312.jpg" alt="Gia Bảo" class="artist-img">
                        </div>
                        <h3 class="artist-name">Gia Bảo</h3>
                        <p class="artist-role">Đạo Diễn Sân Khấu</p>
                    </div>
                </div>
            </section>
            <div class="swiper myReviewSwiper" data-aos="fade-up" data-aos-duration="1500" style="max-width: 1200px; margin: 0 auto; padding: 0 20px;">
                <div class="swiper-wrapper">
                    <div class="swiper-slide">
                        <div style="background: rgba(0,0,0,0.6); border: 1px solid #333; padding: 30px; border-radius: 8px; height: 100%;">
                            <div style="color: #d4af37; font-size: 1.5rem;">★★★★★</div>
                            <p style="color: #ccc; font-style: italic; margin: 15px 0; min-height: 80px;">"Một trải nghiệm thị giác choáng ngợp! Tôi chưa từng thấy sân khấu nào tại Việt Nam được đầu tư công phu đến vậy."</p>
                            <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px;">
                                <img src="https://i.pravatar.cc/150?img=32" style="width: 50px; height: 50px; border-radius: 50%; border: 2px solid #d4af37;">
                                <div><strong style="color: #fff; display: block;">Ngọc Nữ</strong><span style="color: #888; font-size: 0.85rem;">Influencer</span></div>
                            </div>
                        </div>
                    </div>
                    <div class="swiper-slide">
                        <div style="background: rgba(0,0,0,0.6); border: 1px solid #333; padding: 30px; border-radius: 8px; height: 100%;">
                            <div style="color: #d4af37; font-size: 1.5rem;">★★★★★</div>
                            <p style="color: #ccc; font-style: italic; margin: 15px 0; min-height: 80px;">"Âm thanh vòm quá đỉnh. Vở 'Dạ Khúc Mùa Đông' đã lấy đi nước mắt của tôi."</p>
                            <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px;">
                                <img src="https://i.pravatar.cc/150?img=11" style="width: 50px; height: 50px; border-radius: 50%; border: 2px solid #d4af37;">
                                <div><strong style="color: #fff; display: block;">Minh Quân</strong><span style="color: #888; font-size: 0.85rem;">Doanh nhân</span></div>
                            </div>
                        </div>
                    </div>
                    <div class="swiper-slide">
                        <div style="background: rgba(0,0,0,0.6); border: 1px solid #333; padding: 30px; border-radius: 8px; height: 100%;">
                            <div style="color: #d4af37; font-size: 1.5rem;">★★★★★</div>
                            <p style="color: #ccc; font-style: italic; margin: 15px 0; min-height: 80px;">"Tuyệt vời! Không chỉ là xem kịch, đó là sự tận hưởng. AI hỗ trợ đặt vé rất nhanh."</p>
                            <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px;">
                                <img src="https://i.pravatar.cc/150?img=5" style="width: 50px; height: 50px; border-radius: 50%; border: 2px solid #d4af37;">
                                <div><strong style="color: #fff; display: block;">Lan Khuê</strong><span style="color: #888; font-size: 0.85rem;">Nhà phê bình</span></div>
                            </div>
                        </div>
                    </div>
                    <div class="swiper-slide">
                        <div style="background: rgba(0,0,0,0.6); border: 1px solid #333; padding: 30px; border-radius: 8px; height: 100%;">
                            <div style="color: #d4af37; font-size: 1.5rem;">★★★★★</div>
                            <p style="color: #ccc; font-style: italic; margin: 15px 0; min-height: 80px;">"Không gian sang trọng, nhân viên phục vụ tận tình. Chắc chắn sẽ quay lại."</p>
                            <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px;">
                                <img src="https://i.pravatar.cc/150?img=60" style="width: 50px; height: 50px; border-radius: 50%; border: 2px solid #d4af37;">
                                <div><strong style="color: #fff; display: block;">Tiến Đạt</strong><span style="color: #888; font-size: 0.85rem;">Khán giả</span></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="swiper-pagination"></div>
            </div>

            <div class="stats" style="margin-top: 80px; padding-bottom: 50px;">
                <div class="stat" data-aos="zoom-in" data-aos-delay="0">
                    <h3 class="stat-number" data-target="500">0+</h3> 
                    <p>Chương trình/năm</p>
                </div>
                <div class="stat" data-aos="zoom-in" data-aos-delay="100">
                    <h3 class="stat-number" data-target="50000">0+</h3>
                    <p>Khách hàng hài lòng</p>
                </div>
                <div class="stat" data-aos="zoom-in" data-aos-delay="200">
                    <h3 class="stat-number" data-target="100">0+</h3>
                    <p>Nghệ sĩ nổi tiếng</p>
                </div>
                <div class="stat" data-aos="zoom-in" data-aos-delay="300">
                    <h3 class="stat-number" data-target="10">0+</h3>
                    <p>Năm kinh nghiệm</p>
                </div>
            </div>
        </section>

        <div id="chatIcon" class="chat-icon">💬</div>

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

        <%@ include file="/WEB-INF/views/layout/footer.jsp" %>

        <script src="${pageContext.request.contextPath}/js/bg3d.js"></script>
        <script src="${pageContext.request.contextPath}/js/chat-toggle.js"></script>
        <script src="${pageContext.request.contextPath}/js/chatbot.js"></script>

        <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>

        <script>
            window.addEventListener('scroll', () => {
                const scrolled = window.pageYOffset;

                // Background chậm hơn
                document.querySelector('.hero').style.transform =
                        `translateY(${scrolled * 0.5}px)`;

                // Text nhanh hơn
                document.querySelector('.hero-title').style.transform =
                        `translateY(${scrolled * -0.3}px)`;
            });
            document.addEventListener("DOMContentLoaded", function () {
                // 1. KÍCH HOẠT ANIMATION AOS (Hiệu ứng cuộn trang)
                AOS.init({
                    once: true, // Chỉ chạy hiệu ứng 1 lần
                    offset: 100, // Cách đáy 100px thì chạy
                    duration: 800 // Tốc độ mặc định
                });

                // 2. HIỆU ỨNG HOVER (Thêm class vào body để CSS xử lý nếu cần)
                const links = document.querySelectorAll('a, button, .luxury-card, .artist-card');
                links.forEach(link => {
                    link.addEventListener('mouseenter', () => {
                        document.body.classList.add('hovering');
                    });
                    link.addEventListener('mouseleave', () => {
                        document.body.classList.remove('hovering');
                    });
                });

                // 3. CẤU HÌNH SWIPER REVIEW
                var mySwiper = new Swiper(".myReviewSwiper", {
                    slidesPerView: 1,
                    spaceBetween: 20,
                    loop: true,
                    autoplay: {delay: 3000, disableOnInteraction: false}, // Chậm lại xíu cho dễ đọc
                    speed: 1000,
                    pagination: {el: ".swiper-pagination", clickable: true},
                    breakpoints: {
                        768: {slidesPerView: 2, spaceBetween: 30},
                        1024: {slidesPerView: 3, spaceBetween: 30}
                    }
                });

                // 4. CẤU HÌNH SỐ NHẢY (Number Counter) - Chỉ chạy khi cuộn tới
                function animateCounter(obj, start, end, duration) {
                    let startTimestamp = null;
                    const step = (timestamp) => {
                        if (!startTimestamp)
                            startTimestamp = timestamp;
                        const progress = Math.min((timestamp - startTimestamp) / duration, 1);
                        obj.innerHTML = Math.floor(progress * (end - start) + start) + (progress === 1 ? "+" : "");
                        if (progress < 1) {
                            window.requestAnimationFrame(step);
                        }
                    };
                    window.requestAnimationFrame(step);
                }

                let observer = new IntersectionObserver((entries, observer) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            let target = parseInt(entry.target.getAttribute('data-target'));
                            // Nếu không lấy được số (NaN) thì mặc định là 0 để không lỗi
                            if (isNaN(target))
                                target = 0;

                            animateCounter(entry.target, 0, target, 2000);
                            observer.unobserve(entry.target);
                        }
                    });
                }, {threshold: 0.5});

                document.querySelectorAll('.stat-number').forEach(counter => {
                    observer.observe(counter);
                });
            });
        </script>
    </body>
</html>