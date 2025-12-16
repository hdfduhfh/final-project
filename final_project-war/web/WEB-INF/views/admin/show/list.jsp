<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách Show</title>
        <style>
            body {
                font-family: Cambria, Georgia, serif;
                background-color: #f4f6f9;
                margin: 20px;
            }
            h2 {
                text-align: center;
                margin-bottom: 20px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }
            table, th, td {
                border: 1px solid #ccc;
            }
            th {
                background-color: #1c9ad6;
                color: white;
                padding: 10px;
            }
            td {
                padding: 8px;
                vertical-align: top;
            }

            img {
                border-radius: 6px;
            }

            /* BUTTONS */
            .btn {
                padding: 6px 12px;
                font-size: 14px;
                border-radius: 4px;
                border: none;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
            }
            .btn-info {
                background-color: #17a2b8;
                color: #fff;
            }
            .btn-primary {
                background-color: #007bff;
                color: #fff;
            }
            .btn-danger {
                background-color: #dc3545;
                color: #fff;
            }
            .btn-outline {
                background-color: #fff;
                color: #28a745;
                border: 1px solid #28a745;
            }

            /* OVERLAY + POPUP */
            .show-detail-overlay {
                position: fixed;
                inset: 0;
                background: rgba(0,0,0,0.6);
                display: none;
                align-items: center;
                justify-content: center;
                z-index: 9999;
            }

            .show-detail-modal {
                background: white;
                border-radius: 16px;
                max-width: 960px;
                width: 90%;
                max-height: 90vh;
                display: flex;
                overflow: hidden;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
                position: relative;
            }

            .show-detail-left {
                flex: 0 0 45%;
                background: black;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .show-detail-left img {
                max-width: 100%;
                max-height: 100%;
                object-fit: cover;
            }

            .show-detail-right {
                flex: 1;
                padding: 20px 24px;
                overflow-y: auto;
            }

            .show-detail-title {
                font-size: 22px;
                font-weight: bold;
                color: #1c9ad6;
                margin-bottom: 8px;
            }

            .show-detail-meta {
                font-size: 14px;
                margin-bottom: 6px;
            }

            .show-detail-artists {
                margin-top: 10px;
                font-size: 14px;
                line-height: 1.5;
                white-space: normal; /* ✅ đảm bảo không bị cắt */
                word-break: break-word;
            }

            .show-detail-footer {
                margin-top: 18px;
                display: flex;
                gap: 10px;
            }

            .show-detail-close {
                position: absolute;
                top: 10px;
                right: 20px;
                font-size: 28px;
                color: #fff;
                cursor: pointer;
                z-index: 10000;
            }

            /* Search bar */
            .search-container {
                margin: 10px 0;
                text-align: center;
            }
        </style>
    </head>

    <body>
        <h2>Danh sách Show</h2>

        <!-- Search box -->
        <div class="search-container">
            <form method="get" action="${pageContext.request.contextPath}/admin/show" style="margin-bottom:10px;">
                <input type="text"
                       name="keyword"
                       value="${searchKeyword}"
                       placeholder="Nhập tên show..."
                       style="width:260px; padding:6px;" />
                <button type="submit">Tìm</button>
            </form>

            <p>
                <a href="${pageContext.request.contextPath}/admin/show/add" class="btn btn-primary">
                    ➕ Thêm show mới
                </a>
            </p>
        </div>

        <a href="${pageContext.request.contextPath}/admin/showArtist">Go ShowArtist</a>
        
         <a href="${pageContext.request.contextPath}/admin/dashboard">← Quay về dashboard</a>

        <table>
            <tr>
                <th>#</th>
                <th>Tên Show</th>
                <th>Mô tả</th>
                <th>Thời lượng</th>
                <th>Trạng thái</th>
                <th>Poster</th>
                <th>Ngày tạo</th>
                <th>Hành động</th>
            </tr>

            <c:forEach var="s" items="${shows}" varStatus="loop">
                <%-- ✅ CHỈ LẤY DATA TỪ directorMap + actorMap (đã build đầy đủ trong Servlet) --%>
                <c:set var="directorName" value="${directorMap[s.showID]}" />
                <c:set var="actorNames" value="${actorMap[s.showID]}" />

                <tr>
                    <td>${loop.index + 1}</td>

                    <td>${s.showName}</td>
                    <td>${s.description}</td>
                    <td>${s.durationMinutes} phút</td>
                    <td>${s.status}</td>

                    <td>
                        <c:if test="${not empty s.showImage}">
                            <img src="${pageContext.request.contextPath}/${s.showImage}"
                                 width="100">
                        </c:if>
                    </td>

                    <td>
                        <fmt:formatDate value="${s.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                    </td>

                    <td>
                        <button type="button"
                                class="btn btn-info"
                                data-show-name="${fn:escapeXml(s.showName)}"
                                data-poster-url="${pageContext.request.contextPath}/${s.showImage}"
                                data-director="${fn:escapeXml(directorName)}"
                                data-actors="${fn:escapeXml(actorNames)}"
                                onclick="openShowDetail(this)">
                            Detail
                        </button>
                        &nbsp;

                        <a href="${pageContext.request.contextPath}/admin/show/edit?id=${s.showID}"
                           class="btn btn-primary">Sửa</a>
                        &nbsp;

                        <a href="${pageContext.request.contextPath}/admin/show/delete?id=${s.showID}"
                           class="btn btn-danger"
                           onclick="return confirm('Bạn có chắc muốn xóa show này?');">
                            Xóa
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty shows}">
                <tr>
                    <td colspan="8" style="text-align:center;">Không có show nào.</td>
                </tr>
            </c:if>
        </table>

        <!-- ✅ PAGINATION -->
        <div style="margin-top: 14px; text-align:center;">
            <c:if test="${totalPages > 1}">

                <!-- Prev -->
                <c:if test="${currentPage > 1}">
                    <a class="btn btn-outline"
                       href="${pageContext.request.contextPath}/admin/show?page=${currentPage - 1}&keyword=${fn:escapeXml(searchKeyword)}">
                        ← Trước
                    </a>
                </c:if>

                <span style="margin: 0 10px;">
                    Trang <b>${currentPage}</b> / <b>${totalPages}</b>
                    &nbsp; (Tổng: ${totalItems} show)
                </span>

                <!-- Next -->
                <c:if test="${currentPage < totalPages}">
                    <a class="btn btn-outline"
                       href="${pageContext.request.contextPath}/admin/show?page=${currentPage + 1}&keyword=${fn:escapeXml(searchKeyword)}">
                        Sau →
                    </a>
                </c:if>

            </c:if>
        </div>


        <!-- POPUP DETAIL SHOW -->
        <div id="showDetailOverlay" class="show-detail-overlay">
            <div class="show-detail-close" onclick="closeShowDetail()">&times;</div>

            <div class="show-detail-modal">

                <!-- LEFT: POSTER -->
                <div class="show-detail-left">
                    <img id="detailPoster" src="" alt="Poster">
                </div>

                <!-- RIGHT: INFO -->
                <div class="show-detail-right">
                    <div id="detailTitle" class="show-detail-title"></div>

                    <div class="show-detail-meta">
                        <strong>Đạo diễn:</strong>
                        <span id="detailDirector"></span>
                    </div>

                    <div class="show-detail-artists">
                        <strong>Với sự tham gia của nghệ sĩ:</strong><br>
                        <span id="detailArtists"></span>
                    </div>

                    <div class="show-detail-footer">
                        <button class="btn btn-outline" onclick="closeShowDetail()">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function openShowDetail(btn) {
                var overlay = document.getElementById("showDetailOverlay");

                document.getElementById("detailTitle").textContent =
                        btn.getAttribute("data-show-name") || "";

                document.getElementById("detailDirector").textContent =
                        btn.getAttribute("data-director") || "(Chưa có)";

                // ✅ Hiển thị đầy đủ chuỗi diễn viên từ actorMap (không bị cắt)
                document.getElementById("detailArtists").textContent =
                        btn.getAttribute("data-actors") || "";

                document.getElementById("detailPoster").src =
                        btn.getAttribute("data-poster-url") || "";

                overlay.style.display = "flex";
            }

            function closeShowDetail() {
                document.getElementById("showDetailOverlay").style.display = "none";
            }

            document.addEventListener("click", function (e) {
                var overlay = document.getElementById("showDetailOverlay");
                var modal = document.querySelector(".show-detail-modal");

                if (overlay.style.display === "flex") {
                    if (!modal.contains(e.target) && !e.target.classList.contains("btn-info")) {
                        closeShowDetail();
                    }
                }
            });
        </script>
    </body>
</html>
