<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Hồ Sơ Của Tôi | BookingStage</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Montserrat:wght@300;400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user.css">
        <style>
            /* CSS Bổ sung cho phần Thống kê */
            .stats-container {
                display: flex;
                justify-content: space-between;
                margin-bottom: 25px;
                gap: 15px;
            }
            .stat-box {
                flex: 1;
                background: rgba(255, 255, 255, 0.05);
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-radius: 8px;
                padding: 15px;
                text-align: center;
            }
            .stat-value {
                display: block;
                font-family: 'Playfair Display', serif;
                font-size: 1.2rem;
                font-weight: 700;
                color: #d4af37;
                margin-bottom: 5px;
            }
            .stat-label {
                font-size: 0.8rem;
                color: #aaa;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .btn-edit {
                margin-top: 10px;
                font-size: 0.9rem;
                color: #aaa;
                text-decoration: underline;
                cursor: pointer;
                background: none;
                border: none;
            }
            .btn-edit:hover { color: #fff; }
        </style>
    </head>
    <body>
        <jsp:useBean id="now" class="java.util.Date" />

        <c:if test="${empty sessionScope.user}">
            <c:redirect url="/" />
        </c:if>

        <div class="profile-page">
            <a href="${pageContext.request.contextPath}/" class="btn-back-home">
                <i class="fa-solid fa-arrow-left-long"></i> Trang chủ
            </a>

            <div class="profile-card">

                <div class="profile-header">
                    <div class="avatar-wrapper">
                        <div class="avatar">
                            <c:out value="${sessionScope.user.fullName.substring(0, 1).toUpperCase()}" default="U"/>
                        </div>
                        <div class="avatar-ring"></div>
                    </div>

                    <div class="profile-info">
                        <h2>${sessionScope.user.fullName}</h2>
                        <span class="user-badge">
                            <i class="fa-solid fa-crown"></i> Membership
                        </span>
                        <div class="user-email-display">
                            <i class="fa-regular fa-envelope"></i> ${sessionScope.user.email}
                        </div>
                    </div>
                </div>

                <div class="profile-body">
                    
                    <c:set var="totalSpent" value="0" />
                    <c:set var="totalTickets" value="0" />
                    <c:if test="${not empty orders}">
                        <c:forEach var="order" items="${orders}">
                            <c:if test="${order.status == 'CONFIRMED' || order.status == 'PAID'}">
                                <c:set var="totalSpent" value="${totalSpent + order.finalAmount}" />
                                <c:set var="totalTickets" value="${totalTickets + order.orderDetailCollection.size()}" />
                            </c:if>
                        </c:forEach>
                    </c:if>

                    <div class="stats-container">
                        <div class="stat-box">
                            <span class="stat-value">
                                <fmt:formatNumber value="${totalSpent}" type="number" maxFractionDigits="0"/> đ
                            </span>
                            <span class="stat-label">Tổng Chi Tiêu</span>
                        </div>
                        <div class="stat-box">
                            <span class="stat-value">${totalTickets}</span>
                            <span class="stat-label">Vé Đã Mua</span>
                        </div>
                        <div class="stat-box">
                            <span class="stat-value">
                                <fmt:formatNumber value="${totalSpent / 10000}" type="number" maxFractionDigits="0"/>
                            </span>
                            <span class="stat-label">Điểm Thưởng</span>
                        </div>
                    </div>
                    <h3>
                        <i class="fa-solid fa-address-card" style="color: #d4af37;"></i>
                        Thông tin tài khoản
                    </h3>

                    <div class="info-row">
                        <span class="info-label">Họ và tên</span>
                        <span class="info-value">${sessionScope.user.fullName}</span>
                    </div>

                    <div class="info-row">
                        <span class="info-label">Email</span>
                        <span class="info-value">${sessionScope.user.email}</span>
                    </div>

                    <div class="info-row">
                        <span class="info-label">Số điện thoại</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.phone}">
                                    ${sessionScope.user.phone}
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #777; font-style: italic;">Chưa cập nhật</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="info-row">
                        <span class="info-label">Trạng thái</span>
                        <span class="info-value" style="color: #4cd137;">● Đang hoạt động</span>
                    </div>
                   
                    <div class="ticket-section-container" style="margin-top: 30px;">
                        <h3>
                            <i class="fa-solid fa-ticket" style="color: #d4af37;"></i>
                            Lịch sử mua vé
                        </h3>

                        <div class="ticket-list-wrapper">
                            <c:choose>
                                <c:when test="${not empty orders}">
                                    <c:forEach var="order" items="${orders}">
                                        <c:forEach var="detail" items="${order.orderDetailCollection}">

                                            <div class="ticket-card">
                                                <div class="ticket-poster"
                                                     style="background-image: url('${pageContext.request.contextPath}/${detail.scheduleID.showID.showImage}');">
                                                </div>

                                                <div class="ticket-info">
                                                    <div class="movie-title" title="${detail.scheduleID.showID.showName}">
                                                        ${detail.scheduleID.showID.showName}
                                                    </div>

                                                    <div class="ticket-detail">
                                                        <i class="fa-regular fa-clock"></i>
                                                        <fmt:formatDate value="${detail.scheduleID.showTime}" pattern="HH:mm - dd/MM/yyyy"/>
                                                    </div>

                                                    <div class="ticket-detail">
                                                        <i class="fa-solid fa-couch"></i>
                                                        Ghế: <strong>${detail.seatID.seatNumber}</strong>
                                                    </div>

                                                    <div class="ticket-status">
                                                        <c:choose>
                                                            <c:when test="${order.status == 'CONFIRMED'}">
                                                                <span style="color: #4cd137;">
                                                                    <i class="fa-solid fa-check-circle"></i> Thành công
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'CANCELLED'}">
                                                                <span style="color: #e74c3c;">
                                                                    <i class="fa-solid fa-times-circle"></i> Đã hủy
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="color: #f39c12;">
                                                                    <i class="fa-solid fa-hourglass-half"></i> Chờ xử lý
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:forEach>
                                </c:when>

                                <c:otherwise>
                                    <div class="empty-state" style="text-align: center; padding: 20px; grid-column: 1 / -1;">
                                        <div class="empty-icon" style="font-size: 2rem; color: #333; margin-bottom: 10px;">
                                            <i class="fa-solid fa-film"></i>
                                        </div>
                                        <div class="empty-text" style="color: #666;">
                                            Bạn chưa đặt vé nào.
                                        </div>
                                        <a href="${pageContext.request.contextPath}/"
                                           style="color: #d4af37; text-decoration: underline; font-size: 0.9rem; margin-top: 10px; display: inline-block;">
                                            Đặt vé ngay
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <div class="actions" style="margin-top: 30px; display: flex; gap: 10px; justify-content: center;">
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-gold">
                            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                        </a>
                    </div>

                </div>
            </div>
        </div>

    </body>
</html>