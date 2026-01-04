<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<fmt:setLocale value="vi_VN"/>

<style>
    .schedule-container {
        max-width: 1100px;
        margin: 50px auto;
        font-family: 'Playfair Display', serif;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 5px 25px rgba(0,0,0,0.1);
        padding-bottom: 20px;
    }

    .page-title {
        background: #111;
        color: #d4af37;
        padding: 25px;
        margin: 0;
        text-align: center;
        text-transform: uppercase;
        letter-spacing: 2px;
        font-size: 2rem;
        border-radius: 8px 8px 0 0;
    }

    .table-responsive {
        width: 100%;
        overflow-x: auto;
    }

    .schedule-table {
        width: 100%;
        border-collapse: collapse;
        min-width: 600px;
    }

    .schedule-table th {
        background-color: #f8f8f8;
        color: #111;
        font-weight: 700;
        padding: 18px 15px;
        text-align: center;
        border-bottom: 2px solid #d4af37;
        font-family: 'Playfair Display', serif;
    }

    .schedule-table td {
        padding: 20px 15px;
        border-bottom: 1px solid #eee;
        vertical-align: middle;
        color: #333;
    }

    .schedule-table tr:hover {
        background-color: #fffbf0;
        transition: 0.3s;
    }

    .date-day {
        font-weight: 700;
        font-size: 1.2rem;
        color: #111;
        text-transform: capitalize;
        margin-bottom: 4px;
    }

    .time-badge {
        display: inline-block;
        background: #111;
        color: #d4af37;
        padding: 6px 15px;
        border-radius: 30px;
        font-weight: bold;
        margin-top: 8px;
        font-size: 0.9rem;
        box-shadow: 0 3px 6px rgba(0,0,0,0.2);
    }

    .thumb-img {
        width: 90px;
        height: 125px;
        object-fit: cover;
        border-radius: 4px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        transition: transform 0.3s;
    }
    .thumb-img:hover {
        transform: scale(1.05);
    }

    .show-title-link {
        font-size: 1.3rem;
        font-weight: 700;
        color: #111;
        text-decoration: none;
        display: inline-block;
        margin-bottom: 8px;
        transition: color 0.3s;
        cursor: pointer;
    }
    .show-title-link:hover { color: #d4af37; }

    .btn-book {
        display: inline-block;
        padding: 10px 30px;
        background: linear-gradient(135deg, #d4af37, #C5A028);
        color: #000;
        text-decoration: none;
        border-radius: 50px;
        font-weight: 700;
        transition: all 0.3s ease;
        white-space: nowrap;
        box-shadow: 0 4px 10px rgba(212, 175, 55, 0.3);
    }
    .btn-book:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(212, 175, 55, 0.5);
    }

    /* ====== ADDED: dropdown schedules ====== */
    .schedule-dropdown {
        display: none;
        background: #fffdf6;
        border: 1px solid #f1e3bd;
        border-radius: 8px;
        padding: 14px 14px;
        margin-top: 10px;
    }

    .schedule-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 14px;
        padding: 10px 0;
        border-bottom: 1px dashed #e9e0c7;
    }

    .schedule-row:last-child {
        border-bottom: none;
    }

    .schedule-time {
        text-align: left;
        min-width: 240px;
        color: #333;
    }

    .schedule-time small {
        color: #666;
        font-style: italic;
        display: block;
        margin-top: 4px;
    }

    .schedule-toggle-hint {
        font-size: 0.9rem;
        color: #888;
        margin-top: 6px;
    }

    .toggle-icon {
        display: inline-block;
        margin-left: 8px;
        transition: transform 0.2s ease;
    }
    .toggle-open .toggle-icon {
        transform: rotate(180deg);
    }
</style>

<div class="schedule-container">
    <h2 class="page-title">Lịch Diễn Sắp Tới</h2>

    <c:if test="${empty schedules}">
        <div style="padding: 60px; text-align: center; color: #666;">
            <i class="fa fa-calendar-times-o" style="font-size: 3rem; margin-bottom: 15px; color: #ccc;"></i>
            <p style="font-size: 1.1rem;">Hiện chưa có lịch diễn nào được cập nhật.</p>
        </div>
    </c:if>

    <c:if test="${not empty schedules}">
        <div class="table-responsive">
            <table class="schedule-table">
                <thead>
                    <tr>
                        <!-- ✅ POSTER ra đầu -->
                        <th style="width: 18%">POSTER</th>

                        <!-- ✅ Vở diễn chuyển qua chỗ cột đặt vé -->
                        <th style="width: 82%; text-align: left; padding-left: 20px;">VỞ DIỄN</th>
                    </tr>
                </thead>

                <tbody>
                    <c:set var="prevShowId" value="-1" />

                    <c:forEach var="sc" items="${schedules}" varStatus="st">
                        <c:set var="curShowId" value="${sc.showID.showID}" />

                        <!-- Nếu show mới => render 1 dòng chính (poster + title) -->
                        <c:if test="${curShowId != prevShowId}">
                            <!-- tính rowspan cho show này -->
                            <c:set var="rs" value="0" />
                            <c:forEach var="x" items="${schedules}">
                                <c:if test="${x.showID.showID == curShowId}">
                                    <c:set var="rs" value="${rs + 1}" />
                                </c:if>
                            </c:forEach>

                            <tr>
                                <!-- ✅ Poster gọi 1 lần bằng rowspan -->
                                <td rowspan="${rs}" style="text-align:center;">
                                    <c:choose>
                                        <c:when test="${not empty sc.showID.showImage}">
                                            <img src="${pageContext.request.contextPath}/${sc.showID.showImage}"
                                                 alt="${sc.showID.showName}"
                                                 class="thumb-img" />
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://via.placeholder.com/100x140"
                                                 alt="Poster"
                                                 class="thumb-img" />
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- ✅ Cột Vở diễn (thay vị trí đặt vé cũ) -->
                                <td style="text-align:left; padding-left:20px;">
                                    <a class="show-title-link"
                                       data-toggle="dropdown-${curShowId}"
                                       id="toggle-${curShowId}">
                                        ${sc.showID.showName}
                                        <span class="toggle-icon">▼</span>
                                    </a>

                                    <div style="font-size: 0.95rem; color: #555;">
                                        <i class="fa fa-map-marker" style="color:#d4af37; margin-right: 5px;"></i>
                                        Sân khấu Hoàng Gia
                                    </div>

                                    <div style="font-size: 0.9rem; color: #777; margin-top: 5px;">
                                        Thời lượng: ${sc.showID.durationMinutes} phút
                                    </div>

                                    <div class="schedule-toggle-hint">
                                        Nhấn vào tên vở diễn để xem lịch diễn và chọn suất phù hợp.
                                    </div>

                                    <!-- ✅ Dropdown: chứa toàn bộ lịch + nút chọn ghế -->
                                    <div class="schedule-dropdown" id="dropdown-${curShowId}">
                                        <c:forEach var="s2" items="${schedules}">
                                            <c:if test="${s2.showID.showID == curShowId}">
                                                <div class="schedule-row">
                                                    <div class="schedule-time">
                                                        <b><fmt:formatDate value="${s2.showTime}" pattern="EEEE"/></b>
                                                        <small>
                                                            <fmt:formatDate value="${s2.showTime}" pattern="dd 'tháng' MM, yyyy"/>
                                                            • <fmt:formatDate value="${s2.showTime}" pattern="HH:mm"/>
                                                        </small>
                                                    </div>

                                                    <div>
                                                        <a href="${pageContext.request.contextPath}/seats/layout?id=${s2.scheduleID}"
                                                           class="btn-book">
                                                            CHỌN GHẾ
                                                        </a>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </td>
                            </tr>
                        </c:if>

                        <!-- Nếu cùng show => không render gì thêm (vì poster đã rowspan, lịch đã nằm trong dropdown) -->
                        <c:set var="prevShowId" value="${curShowId}" />
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- ✅ GIỮ NGUYÊN PHÂN TRANG -->
        <c:if test="${totalPages > 1}">
            <div style="padding: 30px; text-align: center; border-top: 1px solid #eee;">
                <ul style="list-style:none; display:inline-flex; gap:8px; padding:0; align-items: center;">
                    <c:if test="${currentPage > 1}">
                        <li>
                            <a href="?page=${currentPage - 1}" class="btn-book" style="padding: 8px 15px;">«</a>
                        </li>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li>
                            <a href="?page=${i}"
                               class="btn-book"
                               style="padding: 8px 15px; ${i == currentPage ? 'background:#111; color:#d4af37; cursor:default;' : 'background:#f0f0f0; color:#333; box-shadow:none;'}">
                                ${i}
                            </a>
                        </li>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <li>
                            <a href="?page=${currentPage + 1}" class="btn-book" style="padding: 8px 15px;">»</a>
                        </li>
                    </c:if>
                </ul>
            </div>
        </c:if>
    </c:if>
</div>

<script>
    // Toggle dropdown lịch theo show
    document.addEventListener("DOMContentLoaded", function () {
        const links = document.querySelectorAll(".show-title-link[data-toggle]");
        links.forEach(function (a) {
            a.addEventListener("click", function (e) {
                e.preventDefault();
                const id = a.getAttribute("data-toggle");
                const box = document.getElementById(id);
                if (!box) return;

                const isOpen = box.style.display === "block";
                // đóng tất cả dropdown khác
                document.querySelectorAll(".schedule-dropdown").forEach(function (x) {
                    x.style.display = "none";
                });
                document.querySelectorAll(".show-title-link").forEach(function (x) {
                    x.classList.remove("toggle-open");
                });

                // toggle cái hiện tại
                if (!isOpen) {
                    box.style.display = "block";
                    a.classList.add("toggle-open");
                } else {
                    box.style.display = "none";
                    a.classList.remove("toggle-open");
                }
            });
        });
    });
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
