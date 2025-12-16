<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<style>
    /* --- 1. VŨ TRỤ ĐIỆN ẢNH (CINEMATIC SETUP) --- */
    body {
        background-color: #050505;
        /* Nếu ní có ảnh nền ở body, dòng này sẽ giúp ảnh đứng yên tạo hiệu ứng chiều sâu */
        background-attachment: fixed;
        background-position: center;
        background-size: cover;
        color: #e0e0e0;
        font-family: 'Segoe UI', sans-serif;
        overflow-x: hidden; /* Chặn thanh cuộn ngang */
    }

    /* Hiệu ứng sương mù nền (Tùy chọn, tạo độ sâu) */
    body::before {
        content: "";
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: radial-gradient(circle at 50% 50%, rgba(241, 196, 15, 0.05), transparent 70%);
        pointer-events: none;
        z-index: -1;
    }

    .container-custom {
        max-width: 1200px;
        margin: 0 auto;
        padding: 60px 20px;
        position: relative;
    }

    /* --- 2. TYPOGRAPHY QUYỀN LỰC --- */
    h1 {
        font-family: 'Playfair Display', serif;
        font-size: 3rem;
        text-align: center;
        text-transform: uppercase;
        letter-spacing: 5px;
        margin-bottom: 50px;
        position: relative;
        color: #fff;
        text-shadow: 0 0 20px rgba(241, 196, 15, 0.5); /* Chữ tỏa sáng */
        animation: fadeInDown 1s ease-out;
    }

    /* Đường gạch chân nghệ thuật dưới tiêu đề */
    h1::after {
        content: "";
        display: block;
        width: 100px;
        height: 3px;
        background: linear-gradient(90deg, transparent, #d4af37, transparent);
        margin: 20px auto 0;
    }

    /* --- 3. THANH TÌM KIẾM "TƯƠNG LAI" --- */
    .search-wrapper {
        display: flex;
        justify-content: center;
        margin-bottom: 80px;
        animation: fadeInUp 1s ease-out 0.3s backwards; /* Xuất hiện trễ hơn tiêu đề chút */
    }

    .search-box {
        position: relative;
        width: 100%;
        max-width: 600px;
    }

    .search-box input {
        width: 100%;
        padding: 18px 70px 18px 30px;
        border-radius: 50px;
        border: 1px solid rgba(255, 255, 255, 0.1);
        background: rgba(20, 20, 20, 0.6); /* Nền kính tối */
        backdrop-filter: blur(15px); /* Làm mờ hậu cảnh */
        color: #fff;
        font-size: 1.1rem;
        outline: none;
        transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
        box-shadow: 0 10px 30px rgba(0,0,0,0.5);
    }

    .search-box input:focus {
        border-color: #d4af37;
        background: rgba(0, 0, 0, 0.8);
        box-shadow: 0 0 25px rgba(212, 175, 55, 0.3), inset 0 0 10px rgba(212, 175, 55, 0.1);
        transform: scale(1.02);
    }

    .search-box button {
        position: absolute;
        right: 8px;
        top: 8px;
        height: 46px;
        padding: 0 35px;
        border-radius: 40px;
        border: none;
        background: linear-gradient(135deg, #d4af37, #b8860b);
        color: #000;
        font-weight: 800;
        letter-spacing: 1px;
        cursor: pointer;
        transition: 0.3s;
        box-shadow: 0 5px 15px rgba(212, 175, 55, 0.4);
    }

    .search-box button:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(212, 175, 55, 0.6);
    }

    /* --- 4. GRID & ANIMATION --- */
    .show-list {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
        gap: 40px;
    }

    .show-item {
        /* GLASSMORPHISM - Kính đen mờ */
        background: rgba(255, 255, 255, 0.03);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.08);

        border-radius: 20px;
        overflow: hidden;
        display: flex;
        flex-direction: column;
        transition: all 0.5s cubic-bezier(0.25, 0.8, 0.25, 1);
        position: relative;

        /* Animation setup: Ban đầu ẩn đi */
        opacity: 0;
        animation: fadeInUp 0.8s ease-out forwards;
    }

    /* Hiệu ứng so le (Stagger): Mỗi card hiện trễ nhau 0.1s */
    .show-item:nth-child(1) {
        animation-delay: 0.1s;
    }
    .show-item:nth-child(2) {
        animation-delay: 0.2s;
    }
    .show-item:nth-child(3) {
        animation-delay: 0.3s;
    }
    .show-item:nth-child(4) {
        animation-delay: 0.4s;
    }
    .show-item:nth-child(5) {
        animation-delay: 0.5s;
    }
    .show-item:nth-child(6) {
        animation-delay: 0.6s;
    }
    /* ... Nếu nhiều hơn nó sẽ chạy theo delay mặc định */

    /* Hover vào Card */
    .show-item:hover {
        transform: translateY(-15px) scale(1.02);
        border-color: rgba(212, 175, 55, 0.6);
        box-shadow: 0 20px 50px rgba(0,0,0,0.8), 0 0 30px rgba(212, 175, 55, 0.15); /* Glow vàng tỏa ra */
        background: rgba(255, 255, 255, 0.07);
    }

    /* Ảnh Poster */
    .poster-wrapper {
        position: relative;
        width: 100%;
        height: 240px; /* Cao hơn chút cho đẹp */
        overflow: hidden;
    }

    .poster-wrapper img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.8s ease;
        filter: brightness(0.85); /* Tối nhẹ để chữ nổi bật */
    }

    .show-item:hover .poster-wrapper img {
        transform: scale(1.15);
        filter: brightness(1.1); /* Sáng lên khi hover */
    }

    /* --- 5. NỘI DUNG CARD --- */
    .card-details {
        padding: 25px;
        flex: 1;
        display: flex;
        flex-direction: column;
    }

    .show-title {
        font-family: 'Playfair Display', serif;
        font-size: 1.5rem;
        font-weight: 700;
        margin: 0 0 8px 0;
        color: #fff;
        line-height: 1.3;
        text-transform: capitalize; /* Tự động viết hoa chữ cái đầu */

        /* Giới hạn 2 dòng */
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }

    .show-item:hover .show-title {
        color: #f1c40f; /* Tên phim hóa vàng khi hover */
        text-shadow: 0 0 10px rgba(241, 196, 15, 0.3);
    }

    /* Metadata Row */
    .meta-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding-bottom: 15px;
        margin-bottom: 15px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        font-size: 0.85rem;
    }

    /* Đèn tín hiệu Neon */
    .status-neon {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.75rem;
        letter-spacing: 1px;
        padding: 4px 10px;
        border-radius: 20px;
        background: rgba(0,0,0,0.3); /* Nền nhỏ cho badge */
    }

    .dot-light {
        width: 6px;
        height: 6px;
        border-radius: 50%;
        animation: pulse 2s infinite; /* Chấm nhấp nháy */
    }

    .st-active {
        color: #2ecc71;
        border: 1px solid rgba(46, 204, 113, 0.3);
    }
    .st-active .dot-light {
        background: #2ecc71;
        box-shadow: 0 0 8px #2ecc71;
    }

    .st-inactive {
        color: #e74c3c;
        border: 1px solid rgba(231, 76, 60, 0.3);
    }
    .st-inactive .dot-light {
        background: #e74c3c;
        box-shadow: 0 0 8px #e74c3c;
    }

    .duration-tag {
        color: #aaa;
        display: flex;
        align-items: center;
        gap: 5px;
    }

    .desc-text {
        font-size: 0.95rem;
        color: #bbb;
        line-height: 1.6;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        margin-bottom: 25px;
    }

    /* Nút bấm vô hình (Ghost Button) */
    .btn-ghost {
        margin-top: auto;
        align-self: flex-end;
        text-decoration: none;
        color: #d4af37;
        font-size: 0.9rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        display: flex;
        align-items: center;
        gap: 8px;
        transition: 0.3s;
        padding: 8px 15px;
        border: 1px solid transparent;
        border-radius: 30px;
    }

    .btn-ghost:hover {
        background: rgba(212, 175, 55, 0.1);
        border-color: #d4af37;
        padding-right: 20px; /* Hiệu ứng kéo dài nút */
        box-shadow: 0 0 15px rgba(212, 175, 55, 0.2);
    }

    /* --- KEYFRAMES ANIMATION --- */
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(40px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    @keyframes fadeInDown {
        from {
            opacity: 0;
            transform: translateY(-40px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

</style>

<div class="container-custom">
    <h1>Danh sách chương trình</h1>

    <div class="search-wrapper">
        <form method="get" action="${pageContext.request.contextPath}/shows" class="search-box">
            <input type="text" name="keyword" placeholder="Tìm tác phẩm bạn yêu thích..." value="${searchKeyword}" />
            <button type="submit">TÌM</button>
        </form>
    </div>

    <c:choose>
        <c:when test="${empty shows}">
            <div style="text-align: center; color: #666; padding: 50px;">
                <p style="font-size: 1.2rem;">Không tìm thấy chương trình nào phù hợp.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="show-list">
                <c:forEach var="show" items="${shows}">
                    <div class="show-item">
                        <div class="poster-wrapper">
                            <c:choose>
                                <c:when test="${not empty show.showImage}">
                                    <img src="${pageContext.request.contextPath}/${show.showImage}" alt="${show.showName}" />
                                </c:when>
                                <c:otherwise>
                                    <img src="https://via.placeholder.com/500x350/111/444?text=No+Preview" alt="No Image" />
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="card-details">
                            <h2 class="show-title">${show.showName}</h2>

                            <div class="meta-row">
                                <c:choose>
                                    <c:when test="${show.status == 'Active'}">
                                        <div class="status-neon st-active">
                                            <span class="dot-light"></span> Đang diễn ra
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="status-neon st-inactive">
                                            <span class="dot-light"></span> Ngưng hoạt động
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="duration-tag">
                                    <span>⏳</span> ${show.durationMinutes} phút
                                </div>
                            </div>

                            <p class="desc-text">
                                ${show.description}
                            </p>

                            <a href="${pageContext.request.contextPath}/shows/detail/${show.showID}" class="btn-ghost">
                                Xem chi tiết <i class="fa fa-arrow-right" aria-hidden="true">→</i>
                            </a>

                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />