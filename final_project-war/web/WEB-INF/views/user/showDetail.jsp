<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<style>
    /* --- GIỮ NGUYÊN CSS CƠ BẢN --- */
    body { background-color: #050505; color: #e0e0e0; font-family: 'Segoe UI', sans-serif; }
    .backdrop-blur { position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: -1; background-size: cover; background-position: center; filter: blur(30px) brightness(0.3); transform: scale(1.1); }
    
    .detail-container {
        max-width: 1100px; margin: 60px auto; padding: 40px;
        background: rgba(20, 20, 20, 0.6); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
        border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 24px;
        box-shadow: 0 25px 50px rgba(0,0,0,0.5);
        display: flex; gap: 50px; align-items: flex-start;
    }

    /* --- PHẦN QUAN TRỌNG: CỘT ẢNH & KÍNH LÚP --- */
    .poster-col {
        flex: 1; max-width: 350px;
        position: relative; /* Để kính lúp bay bên trong khung này */
        border-radius: 16px;
        box-shadow: 0 15px 35px rgba(0,0,0,0.8);
        border: 1px solid rgba(212, 175, 55, 0.3);
        cursor: none; /* Ẩn chuột đi để hiện cái kính lúp thay thế */
    }

    .poster-img {
        width: 100%;
        display: block;
        border-radius: 16px;
    }

    /* KÍNH LÚP (Đã chỉnh sửa) */
    .magnifying-lens {
        position: absolute;
        border: 2px solid #d4af37; /* Viền vàng mỏng sang trọng */
        border-radius: 50%;
        width: 150px; /* Kích thước kính lúp vừa phải */
        height: 150px;
        
        /* Hiệu ứng bóng đổ để tạo cảm giác nổi 3D */
        box-shadow: 
            0 0 0 7px rgba(255, 255, 255, 0.1), /* Vòng sáng mờ bên ngoài */
            inset 0 0 10px rgba(0,0,0,0.5), /* Bóng đổ vào trong */
            0 10px 20px rgba(0,0,0,0.5); /* Bóng đổ xuống dưới */
            
        cursor: none;
        display: none; /* Mặc định ẩn */
        background-repeat: no-repeat;
        background-color: #000; /* Màu nền đen lót dưới */
        
        /* QUAN TRỌNG: Để chuột xuyên qua kính lúp chạm vào ảnh gốc bên dưới */
        pointer-events: none; 
        z-index: 100;
    }

    /* --- CỘT THÔNG TIN (GIỮ NGUYÊN) --- */
    .info-col { flex: 2; }
    .show-title { font-family: 'Playfair Display', serif; font-size: 3.5rem; color: #d4af37; margin: 0 0 20px 0; line-height: 1.1; text-transform: capitalize; }
    .tags-row { display: flex; gap: 15px; margin-bottom: 30px; flex-wrap: wrap; }
    .tag-item { background: rgba(255,255,255,0.1); padding: 8px 16px; border-radius: 30px; font-size: 0.9rem; display: flex; align-items: center; gap: 8px; border: 1px solid rgba(255,255,255,0.1); }
    .dot { width: 8px; height: 8px; border-radius: 50%; display: inline-block; }
    .st-active { color: #2ecc71; border-color: rgba(46,204,113,0.3); } .st-active .dot { background: #2ecc71; box-shadow: 0 0 10px #2ecc71; }
    .st-inactive { color: #e74c3c; border-color: rgba(231,76,60,0.3); } .st-inactive .dot { background: #e74c3c; }
    .description-box { font-size: 1.1rem; line-height: 1.8; color: #ccc; margin-bottom: 40px; border-left: 3px solid #d4af37; padding-left: 20px; background: linear-gradient(90deg, rgba(212, 175, 55, 0.05), transparent); }
    .action-bar { display: flex; gap: 20px; align-items: center; margin-top: auto; }
    .btn-book { background: linear-gradient(45deg, #d4af37, #f1c40f); color: #000; font-weight: 800; padding: 15px 40px; border-radius: 50px; text-decoration: none; text-transform: uppercase; letter-spacing: 1px; font-size: 1.1rem; box-shadow: 0 10px 25px rgba(212, 175, 55, 0.4); transition: 0.3s; border: none; cursor: pointer; }
    .btn-book:hover { transform: translateY(-3px); box-shadow: 0 15px 35px rgba(212, 175, 55, 0.6); background: linear-gradient(45deg, #f1c40f, #ffd700); }
    .btn-back { color: #888; text-decoration: none; font-size: 1rem; padding: 10px 20px; transition: 0.3s; display: flex; align-items: center; gap: 8px; }
    .btn-back:hover { color: #fff; }
    
    @media (max-width: 768px) {
        .detail-container { flex-direction: column; padding: 20px; }
        .poster-col { max-width: 100%; width: 100%; cursor: default; }
        .magnifying-lens { display: none !important; } /* Tắt trên mobile */
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
                    <c:when test="${show.status == 'Active'}">
                        <div class="tag-item st-active"><span class="dot"></span> ĐANG DIỄN RA</div>
                    </c:when>
                    <c:otherwise>
                        <div class="tag-item st-inactive"><span class="dot"></span> NGƯNG HOẠT ĐỘNG</div>
                    </c:otherwise>
                </c:choose>
                <div class="tag-item"><span>⏳</span> ${show.durationMinutes} PHÚT</div>
                <div class="tag-item"><span>📅</span> <fmt:formatDate value="${show.createdAt}" pattern="dd/MM/yyyy" /></div>
            </div>
            <div class="description-box">${show.description}</div>
            <div class="action-bar">
                <a href="#" class="btn-book">ĐẶT VÉ NGAY</a>
                <a href="${pageContext.request.contextPath}/shows" class="btn-back">← Quay lại danh sách</a>
            </div>
        </div>
    </div>
</c:if>

<c:if test="${empty show}">
    <div style="text-align: center; padding: 100px; color: #fff;">
        <h2>Không tìm thấy thông tin chương trình!</h2>
        <a href="${pageContext.request.contextPath}/shows" style="color: #d4af37;">Quay lại</a>
    </div>
</c:if>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    window.addEventListener('load', function() { // Chờ tải xong hết trang mới chạy để lấy đúng kích thước ảnh
        const container = document.getElementById('posterContainer');
        const img = document.getElementById('posterImage');
        const lens = document.getElementById('magnifyingLens');
        
        // Cấu hình độ phóng đại (2 lần là đẹp nhất)
        const zoomLevel = 2;

        if (container && img && lens) {
            
            // 1. Cài đặt ảnh nền cho kính lúp
            lens.style.backgroundImage = "url('" + img.src + "')";
            
            // Hàm tính toán và di chuyển
            function moveLens(e) {
                e.preventDefault(); // Ngăn các hành vi mặc định

                // Lấy vị trí và kích thước thực tế của ảnh trên màn hình
                const rect = img.getBoundingClientRect();
                
                // Lấy tọa độ con chuột (x, y) so với ảnh
                let x = e.clientX - rect.left;
                let y = e.clientY - rect.top;

                // Tính toán vị trí của kính lúp (để tâm kính trùng với chuột)
                let lensX = x - (lens.offsetWidth / 2);
                let lensY = y - (lens.offsetHeight / 2);

                // --- XỬ LÝ GIỚI HẠN (Không cho kính chạy ra ngoài ảnh) ---
                // Nếu muốn kính lúp chạy ra ngoài viền tí xíu cho đẹp thì bỏ đoạn này cũng được
                if (lensX > img.width - lens.offsetWidth) { lensX = img.width - lens.offsetWidth; }
                if (lensX < 0) { lensX = 0; }
                if (lensY > img.height - lens.offsetHeight) { lensY = img.height - lens.offsetHeight; }
                if (lensY < 0) { lensY = 0; }

                // Cập nhật vị trí khung kính lúp
                lens.style.left = lensX + 'px';
                lens.style.top = lensY + 'px';

                // --- QUAN TRỌNG: TÍNH TOÁN ẢNH NỀN BÊN TRONG ---
                // Set kích thước ảnh nền to gấp 'zoomLevel' lần ảnh gốc
                lens.style.backgroundSize = (img.width * zoomLevel) + "px " + (img.height * zoomLevel) + "px";
                
                // Di chuyển ảnh nền ngược chiều chuột để tạo hiệu ứng soi
                // Công thức: -(vị trí chuột * độ zoom - nửa bán kính lens)
                const bgX = -((x * zoomLevel) - lens.offsetWidth / 2);
                const bgY = -((y * zoomLevel) - lens.offsetHeight / 2);
                
                lens.style.backgroundPosition = bgX + "px " + bgY + "px";
            }

            // Bắt sự kiện
            container.addEventListener('mousemove', moveLens);
            container.addEventListener('touchmove', moveLens); // Cho màn hình cảm ứng

            // Hiện kính khi chuột vào
            container.addEventListener('mouseenter', function() {
                lens.style.display = 'block';
                // Tính lại kích thước background lần nữa cho chắc ăn (phòng trường hợp resize)
                lens.style.backgroundSize = (img.width * zoomLevel) + "px " + (img.height * zoomLevel) + "px";
            });

            // Ẩn kính khi chuột ra
            container.addEventListener('mouseleave', function() {
                lens.style.display = 'none';
            });
        }
    });
</script>