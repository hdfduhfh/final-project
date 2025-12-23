<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<style>
    /* --- CẤU HÌNH FONT CHUNG --- */
    body {
        background-color: #050505;
        color: #e0e0e0;
        font-family: 'Playfair Display', serif; /* Font gốc */
    }

    .backdrop-blur {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        z-index: -1;
        background-size: cover;
        background-position: center;
        filter: blur(30px) brightness(0.3);
        transform: scale(1.1);
    }

    .detail-container {
        max-width: 1100px;
        margin: 60px auto;
        padding: 40px;
        background: rgba(20, 20, 20, 0.6);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 24px;
        box-shadow: 0 25px 50px rgba(0,0,0,0.5);
        display: flex;
        gap: 50px;
        align-items: flex-start;
    }

    /* --- CỘT ẢNH & KÍNH LÚP --- */
    .poster-col {
        flex: 1;
        max-width: 350px;
        position: relative;
        border-radius: 16px;
        box-shadow: 0 15px 35px rgba(0,0,0,0.8);
        border: 1px solid rgba(212, 175, 55, 0.3);
        cursor: none; 
    }

    .poster-img {
        width: 100%;
        display: block;
        border-radius: 16px;
    }

    .magnifying-lens {
        position: absolute;
        border: 2px solid #d4af37;
        border-radius: 50%;
        width: 150px;
        height: 150px;
        box-shadow:
            0 0 0 7px rgba(255, 255, 255, 0.1),
            inset 0 0 10px rgba(0,0,0,0.5),
            0 10px 20px rgba(0,0,0,0.5);
        cursor: none;
        display: none;
        background-repeat: no-repeat;
        background-color: #000;
        pointer-events: none;
        z-index: 100;
        box-sizing: border-box; /* Fix viền kính */
    }

    /* --- CỘT THÔNG TIN --- */
    .info-col {
        flex: 2;
    }
    .show-title {
        font-family: 'Playfair Display', serif; /* Đã có, giữ nguyên */
        font-size: 3.5rem;
        color: #d4af37;
        margin: 0 0 20px 0;
        line-height: 1.1;
        text-transform: capitalize;
    }
    .tags-row {
        display: flex;
        gap: 15px;
        margin-bottom: 30px;
        flex-wrap: wrap;
    }
    .tag-item {
        background: rgba(255,255,255,0.1);
        padding: 8px 16px;
        border-radius: 30px;
        font-size: 0.9rem;
        display: flex;
        align-items: center;
        gap: 8px;
        border: 1px solid rgba(255,255,255,0.1);
        
        /* --- BỔ SUNG FONT --- */
        font-family: 'Playfair Display', serif;
    }
    .dot {
        width: 8px;
        height: 8px;
        border-radius: 50%;
        display: inline-block;
    }
    .st-active {
        color: #2ecc71;
        border-color: rgba(46,204,113,0.3);
    }
    .st-active .dot {
        background: #2ecc71;
        box-shadow: 0 0 10px #2ecc71;
    }
    .st-inactive {
        color: #e74c3c;
        border-color: rgba(231,76,60,0.3);
    }
    .st-inactive .dot {
        background: #e74c3c;
    }
    .description-box {
        font-size: 1.1rem;
        line-height: 1.8;
        color: #ccc;
        margin-bottom: 40px;
        border-left: 3px solid #d4af37;
        padding-left: 20px;
        background: linear-gradient(90deg, rgba(212, 175, 55, 0.05), transparent);
    }
    .action-bar {
        display: flex;
        gap: 20px;
        align-items: center;
        margin-top: auto;
    }

    /* --- NÚT BẤM (QUAN TRỌNG) --- */
    .btn-book {
        background: linear-gradient(45deg, #d4af37, #f1c40f);
        color: #000;
        font-weight: 800;
        padding: 15px 40px;
        border-radius: 50px;
        text-decoration: none;
        text-transform: uppercase;
        letter-spacing: 1px;
        font-size: 1.1rem;
        box-shadow: 0 10px 25px rgba(212, 175, 55, 0.4);
        transition: 0.3s;
        border: none;
        cursor: pointer;

        /* --- BẮT BUỘC PHẢI CÓ DÒNG NÀY ĐỂ HIỆN FONT ĐÚNG TRÊN NÚT --- */
        font-family: 'Playfair Display', serif;
    }
    .btn-book:hover {
        transform: translateY(-3px);
        box-shadow: 0 15px 35px rgba(212, 175, 55, 0.6);
        background: linear-gradient(45deg, #f1c40f, #ffd700);
    }
    .btn-back {
        color: #888;
        text-decoration: none;
        font-size: 1rem;
        padding: 10px 20px;
        transition: 0.3s;
        display: flex;
        align-items: center;
        gap: 8px;
        
        /* --- BẮT BUỘC PHẢI CÓ --- */
        font-family: 'Playfair Display', serif;
    }
    .btn-back:hover {
        color: #fff;
    }

    @media (max-width: 768px) {
        .detail-container {
            flex-direction: column;
            padding: 20px;
        }
        .poster-col {
            max-width: 100%;
            width: 100%;
            cursor: default;
        }
        .magnifying-lens {
            display: none !important;
        }
    }
</style>

<c:if test="${not empty show}">
    <c:set var="imageUrl" value="${not empty show.showImage ? pageContext.request.contextPath.concat('/').concat(show.showImage) : 'https://via.placeholder.com/400x600/111/fff?text=No+Poster'}" />

    <div class="backdrop-blur" style="background-image: url('${imageUrl}');"></div>

    <div class="detail-container">
        <div class="poster-col" id="posterContainer">
            <img src="${imageUrl}" alt="${show.showName}" class="poster-img" id="posterImage" />
            <div class="magnifying-lens" id="magnifyingLens"></div>
        </div>

        <div class="info-col">
            <h1 class="show-title">${show.showName}</h1>
            <div class="tags-row">
                <c:choose>
                    <c:when test="${show.status == 'Ongoing'}">
                        <div class="tag-item st-active">
                            <span class="dot"></span> ĐANG DIỄN RA
                        </div>
                    </c:when>
                    <c:when test="${show.status == 'Upcoming'}">
                        <div class="tag-item st-upcoming">
                            <span class="dot"></span> SẮP CHIẾU
                        </div>
                    </c:when>
                    <c:when test="${show.status == 'Cancelled'}">
                        <div class="tag-item st-cancelled">
                            <span class="dot"></span> ĐÃ HỦY
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="tag-item st-unknown">
                            <span class="dot"></span> KHÔNG XÁC ĐỊNH
                        </div>
                    </c:otherwise>
                </c:choose>
                <div class="tag-item"><span>⏳</span> ${show.durationMinutes} PHÚT</div>
                <div class="tag-item"><span>📅</span> <fmt:formatDate value="${show.createdAt}" pattern="dd/MM/yyyy" /></div>
            </div>
            <div class="description-box">${show.description}</div>
            
            <div style="margin-top: 40px;">
                <h3 style="color:#d4af37; margin-bottom:15px; font-family: 'Playfair Display', serif;">
                    🎭 Suất chiếu
                </h3>

                <c:if test="${empty schedules}">
                    <p style="color:#aaa;">
                        Hiện chưa có suất chiếu cho vở diễn này
                    </p>
                </c:if>

                <c:forEach items="${schedules}" var="sc">
                    <div class="tag-item" style="margin-bottom:10px;">
                         🕒 
                        <fmt:formatDate value="${sc.showTime}" pattern="dd/MM/yyyy HH:mm"/>
                        &nbsp; | &nbsp;

                        <c:choose>
                            <c:when test="${sc.status == 'Active'}">
                                <span style="color:#2ecc71;">Đang mở bán</span>
                            </c:when>
                            <c:when test="${sc.status == 'Cancelled'}">
                                <span style="color:#e74c3c;">Đã hủy</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color:#aaa;">${sc.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
            </div>

            <div class="action-bar">
                <a href="${pageContext.request.contextPath}/seats/layout" class="btn-book">ĐẶT VÉ NGAY</a>
                <a href="${pageContext.request.contextPath}/shows" class="btn-back">← Quay lại danh sách</a>
            </div>
        </div>
    </div>
</c:if>

<c:if test="${empty show}">
    <div style="text-align: center; padding: 100px; color: #fff;">
        <h2 style="font-family: 'Playfair Display', serif;">Không tìm thấy thông tin chương trình!</h2>
        <a href="${pageContext.request.contextPath}/shows" style="color: #d4af37; font-family: 'Playfair Display', serif;">Quay lại</a>
    </div>
</c:if>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    window.addEventListener('load', function () {
        const container = document.getElementById('posterContainer');
        const img = document.getElementById('posterImage');
        const lens = document.getElementById('magnifyingLens');
        const zoomLevel = 2;

        if (container && img && lens) {
            lens.style.backgroundImage = "url('" + img.src + "')";

            function moveLens(e) {
                e.preventDefault();
                const rect = img.getBoundingClientRect();
                let x = e.clientX - rect.left;
                let y = e.clientY - rect.top;
                let lensX = x - (lens.offsetWidth / 2);
                let lensY = y - (lens.offsetHeight / 2);

                if (lensX > img.width - lens.offsetWidth) lensX = img.width - lens.offsetWidth;
                if (lensX < 0) lensX = 0;
                if (lensY > img.height - lens.offsetHeight) lensY = img.height - lens.offsetHeight;
                if (lensY < 0) lensY = 0;

                lens.style.left = lensX + 'px';
                lens.style.top = lensY + 'px';
                lens.style.backgroundSize = (img.width * zoomLevel) + "px " + (img.height * zoomLevel) + "px";

                const bgX = -((x * zoomLevel) - lens.offsetWidth / 2);
                const bgY = -((y * zoomLevel) - lens.offsetHeight / 2);
                lens.style.backgroundPosition = bgX + "px " + bgY + "px";
            }

            container.addEventListener('mousemove', moveLens);
            container.addEventListener('touchmove', moveLens);
            container.addEventListener('mouseenter', function () {
                lens.style.display = 'block';
                lens.style.backgroundSize = (img.width * zoomLevel) + "px " + (img.height * zoomLevel) + "px";
            });
            container.addEventListener('mouseleave', function () {
                lens.style.display = 'none';
            });
        }
    });
</script>