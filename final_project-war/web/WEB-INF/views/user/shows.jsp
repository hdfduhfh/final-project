<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<style>
    /* --- 1. VŨ TRỤ ĐIỆN ẢNH (CINEMATIC SETUP) --- */
    body {
        background-color: #050505;
        background-image:
            linear-gradient(to bottom, rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.4)),
            url('${pageContext.request.contextPath}/assets/images/background-show.png');
        background-attachment: fixed;
        background-position: center center;
        background-size: cover;
        color: #e0e0e0;
        font-family: 'Segoe UI', sans-serif;
        overflow-x: hidden;
        min-height: 100vh;
    }

    .container-custom {
        max-width: 1200px;
        margin: 0 auto;
        padding: 60px 20px;
        position: relative;
    }

    /* Thử ép tụi nó tách nhau ra */
    header, .header-area, nav {
        display: flex !important; /* Dàn hàng ngang */
        justify-content: space-between !important; /* Đẩy 2 đầu xa nhau ra */
        align-items: center !important; /* Căn giữa theo chiều dọc */
        padding: 0 40px !important; /* Thêm khoảng cách 2 bên lề cho thoáng */
    }

    /* Nếu menu dùng thẻ ul li */
    header ul, nav ul {
        display: flex !important;
        gap: 30px !important; /* Khoảng cách giữa các chữ trong menu */
        list-style: none !important;
        margin: 0 !important;
        padding: 0 !important;
    }

    /* --- 2. TYPOGRAPHY --- */
    h1 {
        font-family: 'Playfair Display', serif;
        font-size: 3.5rem;
        text-align: center;
        text-transform: uppercase;
        letter-spacing: 3px;
        margin-top: 100px; /* Đẩy xuống tránh header che */
        margin-bottom: 50px;
        color: #fff;
        background: linear-gradient(to right, #cfc09f, #ffecb3, #c4a747);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        text-shadow: 0 10px 30px rgba(0,0,0,0.5);
        animation: fadeInDown 1s ease-out;
    }

    /* --- 3. THANH TÌM KIẾM --- */
    .search-wrapper {
        display: flex;
        justify-content: center;
        margin-bottom: 60px;
        animation: fadeInUp 1s ease-out 0.2s backwards;
    }

    .search-box {
        position: relative;
        width: 100%;
        max-width: 650px;
    }

    .search-box input {
        width: 100%;
        padding: 18px 80px 18px 30px;
        border-radius: 50px;
        background: rgba(255, 255, 255, 0.03);
        border: 1px solid rgba(255, 255, 255, 0.15);
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        color: #fff;
        font-size: 1.1rem;
        font-family: 'Playfair Display', serif;
        outline: none;
        transition: all 0.4s ease;
        box-shadow: 0 10px 20px rgba(0,0,0,0.3);
    }

    .search-box input:focus {
        border-color: #d4af37;
        background: rgba(255, 255, 255, 0.08);
        box-shadow: 0 15px 30px rgba(0,0,0,0.5), 0 0 15px rgba(212, 175, 55, 0.2);
    }

    .search-box button {
        position: absolute;
        right: 8px;
        top: 8px;
        height: 42px;
        padding: 0 30px;
        border-radius: 40px;
        border: none;
        background: linear-gradient(135deg, #d4af37, #C5A028);
        color: #000;
        font-weight: 700;
        cursor: pointer;
        transition: 0.3s;
    }

    .search-box button:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 20px rgba(212, 175, 55, 0.5);
    }

    /* --- 4. GRID SYSTEM & CARD (Đã tối ưu kích thước) --- */
    .show-list {
        display: grid;
        /* 👇 SỬA: Giảm từ 260px xuống 220px để card nhỏ gọn, xếp được nhiều hơn */
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
        gap: 25px; /* Giảm gap xíu cho đỡ loãng */
    }

    .show-item {
        display: flex;
        flex-direction: column;
        height: 100%;
        background: #0a0a0a;
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 10px;
        overflow: hidden;
        position: relative;
        transition: all 0.4s cubic-bezier(0.25, 1, 0.5, 1);
        opacity: 0;
        animation: fadeInUp 0.8s ease-out forwards;
    }

    .show-item:hover {
        transform: translateY(-8px);
        border-color: #d4af37;
        box-shadow: 0 15px 30px rgba(0,0,0,0.8), 0 0 15px rgba(212, 175, 55, 0.15) inset;
    }

    .poster-wrapper {
        position: relative;
        width: 100%;
        padding-top: 140%; /* Tỉ lệ 5:7 */
        overflow: hidden;
        border-bottom: 1px solid rgba(255,255,255,0.05);
    }

    .poster-wrapper img {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.6s ease;
        filter: saturate(0.9) brightness(0.9);
    }

    .show-item:hover .poster-wrapper img {
        transform: scale(1.08);
        filter: saturate(1.1) brightness(1.1);
    }

    .card-details {
        padding: 15px; /* 👇 SỬA: Giảm padding từ 20px xuống 15px cho cân đối với card nhỏ */
        flex: 1;
        display: flex;
        flex-direction: column;
        background: linear-gradient(to bottom, #1a1a1a, #050505); /* 👇 SỬA: Nền sáng hơn xíu ở trên để đỡ bị tối om */
    }

    .show-title {
        font-family: 'Playfair Display', serif;
        font-size: 1.1rem; /* 👇 SỬA: Giảm font size xíu cho vừa vặn */
        font-weight: 700;
        margin: 0 0 8px 0;
        color: #fff;
        line-height: 1.3;
        min-height: 2.8rem;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        transition: color 0.3s;
    }

    .show-item:hover .show-title {
        color: #d4af37;
    }

    .meta-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 12px;
        font-size: 0.8rem;
        padding-bottom: 10px; /* Thêm gạch chân mờ để tách biệt */
        border-bottom: 1px solid rgba(255,255,255,0.05);
    }

    .badge-luxury {
        padding: 4px 10px;
        border-radius: 3px;
        font-weight: 700;
        font-size: 0.65rem;
        text-transform: uppercase;
        border: 1px solid;
    }

    .status-active {
        border-color: #d4af37;
        color: #d4af37;
        box-shadow: 0 0 8px rgba(212, 175, 55, 0.1);
    }
    .status-inactive {
        border-color: #555;
        color: #777;
    }

    .duration-info {
        color: #e0e0e0; /* Đổi màu xám tối #888 thành trắng xám sáng sủa */
        font-size: 0.85rem;
        font-weight: 600; /* In đậm lên */
        display: flex;
        align-items: center;
        gap: 6px;
        background: rgba(255, 255, 255, 0.1); /* Thêm nền mờ nhẹ */
        padding: 3px 8px;
        border-radius: 4px;
        border: 1px solid rgba(255, 255, 255, 0.1);
    }

    .duration-info i {
        color: #d4af37; /* Icon đồng hồ màu Vàng Gold */
    }

    .desc-text {
        font-size: 0.85rem;
        color: #aaa;
        line-height: 1.5;
        margin-bottom: 20px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }

    .btn-action-wrapper {
        margin-top: auto;
        display: flex;
        justify-content: flex-end;
    }

    .btn-detail {
        text-decoration: none;
        color: #d4af37; /* Đổi mặc định thành màu vàng luôn cho dễ thấy */
        font-size: 0.75rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        transition: all 0.3s ease;
        border: 1px solid #d4af37; /* Thêm viền */
        padding: 6px 15px;
        border-radius: 20px;
    }

    .btn-detail:hover {
        background: #d4af37;
        color: #000;
    }
    .show-item:hover .btn-detail {
        color: #d4af37;
    }

    /* --- 5. PHÂN TRANG (PAGINATION) --- */
    .pagination-wrapper {
        margin-top: 60px;
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 10px;
        animation: fadeInUp 1s ease-out 0.5s backwards;
    }

    .page-link {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 40px;
        height: 40px;
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 50%; /* Hình tròn */
        color: #fff;
        text-decoration: none;
        font-family: 'Playfair Display', serif;
        font-size: 1rem;
        transition: all 0.3s ease;
        background: rgba(255,255,255,0.02);
    }

    .page-link:hover {
        border-color: #d4af37;
        color: #d4af37;
        background: rgba(212, 175, 55, 0.1);
        transform: translateY(-3px);
    }

    .page-link.active {
        background: linear-gradient(135deg, #d4af37, #C5A028);
        color: #000;
        border-color: transparent;
        font-weight: bold;
        box-shadow: 0 5px 15px rgba(212, 175, 55, 0.4);
    }

    .page-link.disabled {
        opacity: 0.3;
        pointer-events: none;
        border-color: rgba(255,255,255,0.1);
    }

    /* Keyframes */
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
</style>

<div class="container-custom">
    <h1>Danh Sách Chương Trình</h1>

    <div class="search-wrapper">
        <form method="get" action="${pageContext.request.contextPath}/shows" class="search-box">
            <input type="text" name="keyword" placeholder="Tìm tác phẩm kinh điển..." value="${param.keyword}" autocomplete="off"/>
            <button type="submit">TÌM</button>
        </form>
    </div>

    <c:choose>
        <c:when test="${empty shows}">
            <div style="text-align: center; color: #666; padding: 80px 0;">
                <i class="fa fa-film" style="font-size: 3rem; margin-bottom: 20px; color: #333;"></i>
                <p style="font-size: 1.2rem;">Không tìm thấy chương trình nào phù hợp.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="show-list">
                <c:forEach var="show" items="${shows}" varStatus="status">
                    <div class="show-item" style="animation-delay: ${status.index * 0.1}s;">
                        <div class="poster-wrapper">
                            <c:choose>
                                <c:when test="${not empty show.showImage}">
                                    <img src="${pageContext.request.contextPath}/${show.showImage}" alt="${show.showName}" />
                                </c:when>
                                <c:otherwise>
                                    <img src="https://via.placeholder.com/500x700/111/444?text=Poster" alt="No Image" />
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="card-details">
                            <h2 class="show-title">${show.showName}</h2>
                            <div class="meta-row">
                                <c:choose>
                                    <c:when test="${show.status == 'Ongoing'}">
                                        <div class="badge-luxury status-active">Đang diễn ra</div>
                                    </c:when>

                                    <c:when test="${show.status == 'Upcoming'}">
                                        <div class="badge-luxury status-upcoming">Sắp chiếu</div>
                                    </c:when>

                                    <c:when test="${show.status == 'Cancelled'}">
                                        <div class="badge-luxury status-cancelled">Đã hủy</div>
                                    </c:when>

                                    <c:otherwise>
                                        <div class="badge-luxury status-inactive">Không xác định</div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="duration-info"><i class="fa fa-clock-o"></i> ${show.durationMinutes}p</div>
                            </div>
                            <p class="desc-text">${show.description}</p>
                            <div class="btn-action-wrapper">
                                <a href="${pageContext.request.contextPath}/shows/detail/${show.showID}" class="btn-detail">
                                    Xem chi tiết <i class="fa fa-long-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${totalPages > 1}">
                <div class="pagination-wrapper">

                    <a href="?page=${currentPage - 1}&keyword=${param.keyword}" 
                       class="page-link ${currentPage <= 1 ? 'disabled' : ''}">
                        <i class="fa fa-angle-left"></i>
                    </a>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="?page=${i}&keyword=${param.keyword}" 
                           class="page-link ${currentPage == i ? 'active' : ''}">
                            ${i}
                        </a>
                    </c:forEach>

                    <a href="?page=${currentPage + 1}&keyword=${param.keyword}" 
                       class="page-link ${currentPage >= totalPages ? 'disabled' : ''}">
                        <i class="fa fa-angle-right"></i>
                    </a>

                </div>
            </c:if>

        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />