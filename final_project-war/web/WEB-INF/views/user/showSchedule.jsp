<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<fmt:setLocale value="vi_VN"/>

<style>
    /* Tổng thể vùng lịch diễn */
    .schedule-container {
        max-width: 1100px;
        margin: 50px auto;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #fff; /* Nền trắng cho sạch sẽ */
        border-radius: 8px;
        box-shadow: 0 5px 25px rgba(0,0,0,0.1); /* Đổ bóng nhẹ tạo chiều sâu */
        overflow: hidden;
    }

    /* Tiêu đề */
    .page-title {
        background: #111; /* Giữ header đen cho ngầu */
        color: #d4af37; /* Màu vàng thương hiệu */
        padding: 20px;
        margin: 0;
        text-align: center;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    /* Bảng lịch diễn */
    .schedule-table {
        width: 100%;
        border-collapse: collapse;
    }

    .schedule-table th {
        background-color: #f4f4f4;
        color: #333;
        font-weight: bold;
        padding: 15px;
        text-align: center;
        border-bottom: 2px solid #ddd;
    }

    .schedule-table td {
        padding: 15px;
        border-bottom: 1px solid #eee;
        vertical-align: middle;
        color: #333; /* Chữ màu đen dễ đọc */
    }

    /* Hiệu ứng khi di chuột vào dòng */
    .schedule-table tr:hover {
        background-color: #fffbf0; /* Màu vàng nhạt khi hover */
        transition: 0.3s;
    }

    /* Cột Ngày & Giờ */
    .date-box {
        text-align: center;
    }
    .date-day {
        font-weight: bold;
        font-size: 1.1rem;
        color: #2c3e50;
        text-transform: capitalize;
    }
    .date-full {
        font-size: 0.9rem;
        color: #777;
    }
    .time-badge {
        display: inline-block;
        background: #2c3e50;
        color: #fff;
        padding: 5px 12px;
        border-radius: 20px;
        font-weight: bold;
        margin-top: 5px;
    }

    /* Cột Tên vở diễn */
    .show-title {
        font-size: 1.2rem;
        font-weight: bold;
        color: #d4af37; /* Vàng thương hiệu */
        margin-bottom: 5px;
        text-transform: uppercase;
    }

    /* Ảnh Thumbnail */
    .thumb-img {
        width: 80px;
        height: 110px;
        object-fit: cover;
        border-radius: 6px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    }

    /* Nút bấm */
    .btn-book {
        display: inline-block;
        padding: 8px 25px;
        background-color: #d4af37;
        color: #fff;
        text-decoration: none;
        border-radius: 4px;
        font-weight: bold;
        transition: 0.2s;
        white-space: nowrap;
    }
    .btn-book:hover {
        background-color: #b39028;
        transform: translateY(-2px);
    }
</style>

<div class="schedule-container">
    <h2 class="page-title">📅 Lịch Diễn Sắp Tới</h2>

    <c:if test="${empty schedules}">
        <div style="padding: 40px; text-align: center; color: #666;">
            Hiện chưa có lịch diễn nào được cập nhật.
        </div>
    </c:if>

    <c:if test="${not empty schedules}">
        <table class="schedule-table">
            <thead>
                <tr>
                    <th style="width: 20%">THỜI GIAN</th>
                    <th style="width: 15%">HÌNH ẢNH</th>
                    <th style="width: 45%; text-align: left; padding-left: 20px;">VỞ DIỄN</th>
                    <th style="width: 20%">THAO TÁC</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="sc" items="${schedules}">
                    <c:set var="imgLink" 
                           value="${not empty sc.showID.showImage 
                                    ? pageContext.request.contextPath.concat('/').concat(sc.showID.showImage) 
                                    : 'https://via.placeholder.com/100x140'}" />

                    <tr>
                        <td class="date-box">
                            <div class="date-day">
                                <fmt:formatDate value="${sc.showTime}" pattern="EEEE"/> </div>
                            <div class="date-full">
                                <fmt:formatDate value="${sc.showTime}" pattern="dd/MM/yyyy"/>
                            </div>
                            <div class="time-badge">
                                <fmt:formatDate value="${sc.showTime}" pattern="HH:mm"/>
                            </div>
                        </td>

                        <td style="text-align: center;">
                            <img src="${imgLink}" alt="${sc.showID.showName}" class="thumb-img">
                        </td>

                        <td style="text-align: left; padding-left: 20px;">
                            <div class="show-title">${sc.showID.showName}</div>
                            <span style="font-size: 0.9rem; color: #666;">
                                🎭 Sân khấu chính
                            </span>
                        </td>

                        <td style="text-align: center;">
                            <a href="${pageContext.request.contextPath}/shows/detail/${sc.showID.showID}" class="btn-book">
                                ĐẶT VÉ
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <c:if test="${totalPages > 1}">
            <div style="padding: 25px; text-align: center;">
                <ul style="list-style:none; display:inline-flex; gap:10px; padding:0;">

                    <!-- Trang trước -->
                    <c:if test="${currentPage > 1}">
                        <li>
                            <a href="${pageContext.request.contextPath}/showSchedule?page=${currentPage - 1}"
                               class="btn-book">«</a>
                        </li>
                    </c:if>

                    <!-- Các trang -->
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li>
                            <a href="${pageContext.request.contextPath}/showSchedule?page=${i}"
                               class="btn-book"
                               style="${i == currentPage ? 'background:#111;color:#d4af37;' : ''}">
                                ${i}
                            </a>
                        </li>
                    </c:forEach>

                    <!-- Trang sau -->
                    <c:if test="${currentPage < totalPages}">
                        <li>
                            <a href="${pageContext.request.contextPath}/showSchedule?page=${currentPage + 1}"
                               class="btn-book">»</a>
                        </li>
                    </c:if>

                </ul>
            </div>
        </c:if>

    </c:if>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />