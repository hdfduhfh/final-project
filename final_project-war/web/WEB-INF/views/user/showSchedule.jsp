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
        border-radius: 8px 8px 0 0; /* Bo tròn góc trên */
    }

    /* Bọc table để scroll ngang trên điện thoại */
    .table-responsive {
        width: 100%;
        overflow-x: auto;
    }

    .schedule-table {
        width: 100%;
        border-collapse: collapse;
        min-width: 600px; /* Đảm bảo bảng không bị co quá nhỏ */
    }

    .schedule-table th {
        background-color: #f8f8f8;
        color: #111;
        font-weight: 700;
        padding: 18px 15px;
        text-align: center;
        border-bottom: 2px solid #d4af37; /* Viền vàng phân cách header */
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

    /* Date Styling */
    .date-day {
        font-weight: 700;
        font-size: 1.2rem;
        color: #111;
        text-transform: capitalize; /* Viết hoa chữ cái đầu: Thứ Hai */
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

    /* Show Info */
    .thumb-img {
        width: 90px;
        height: 125px; /* Tỉ lệ poster chuẩn */
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
        display: block;
        margin-bottom: 8px;
        transition: color 0.3s;
    }
    .show-title-link:hover {
        color: #d4af37;
    }

    /* Button */
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
                        <th style="width: 20%">THỜI GIAN</th>
                        <th style="width: 15%">POSTER</th>
                        <th style="width: 45%; text-align: left; padding-left: 20px;">VỞ DIỄN</th>
                        <th style="width: 20%">ĐẶT VÉ</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="sc" items="${schedules}">
                        <c:set var="imgLink" 
                               value="${not empty sc.showID.showImage 
                                      ? pageContext.request.contextPath.concat('/').concat(sc.showID.showImage) 
                                      : 'https://via.placeholder.com/100x140'}" />
                        
                        <c:set var="detailLink" value="${pageContext.request.contextPath}/shows/detail/${sc.showID.showID}" />

                        <tr>
                            <td class="date-box" style="text-align: center;">
                                <div class="date-day">
                                    <fmt:formatDate value="${sc.showTime}" pattern="EEEE"/>
                                </div>
                                <div class="date-full" style="color: #666; font-style: italic;">
                                    <fmt:formatDate value="${sc.showTime}" pattern="dd 'tháng' MM, yyyy"/>
                                </div>
                                <div class="time-badge">
                                    <fmt:formatDate value="${sc.showTime}" pattern="HH:mm"/>
                                </div>
                            </td>

                            <td style="text-align: center;">
                                <a href="${detailLink}">
                                    <img src="${imgLink}" alt="${sc.showID.showName}" class="thumb-img">
                                </a>
                            </td>

                            <td style="text-align: left; padding-left: 20px;">
                                <a href="${detailLink}" class="show-title-link">${sc.showID.showName}</a>
                                <div style="font-size: 0.95rem; color: #555;">
                                    <i class="fa fa-map-marker" style="color: #d4af37; margin-right: 5px;"></i> Sân khấu Hoàng Gia
                                </div>
                                <div style="font-size: 0.9rem; color: #777; margin-top: 5px;">
                                    Thời lượng: ${sc.showID.durationMinutes} phút
                                </div>
                            </td>

                            <td style="text-align: center;">
                                <a href="${pageContext.request.contextPath}/seats/layout?id=${sc.scheduleID}" class="btn-book">
                                    CHỌN GHẾ
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

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

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />