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
                            <i class="fa-solid fa-user-tie"></i>
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
                    <h3>
                        <i class="fa-solid fa-address-card" style="color: #d4af37;"></i>
                        Thông tin tài khoản
                    </h3>

                    <div class="info-row">
                        <span class="info-label">Họ và tên</span>
                        <span class="info-value">${sessionScope.user.fullName}</span>
                    </div>

                    <div class="info-row">
                        <span class="info-label">Email đăng ký</span>
                        <span class="info-value">${sessionScope.user.email}</span>
                    </div>

                    <div class="info-row">
                        <span class="info-label">Trạng thái</span>
                        <span class="info-value" style="color: #4cd137;">● Đang hoạt động</span>
                    </div>

                    <div class="ticket-section-container">
                        <h3>
                            <i class="fa-solid fa-ticket" style="color: #d4af37;"></i>
                            Vé đã mua
                        </h3>

                        <div class="ticket-list-wrapper"> <c:choose>
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

                                                        <c:if test="${!detail.seatID.isActive}">
                                                            <div class="seat-warning" style="margin-top: 8px; padding: 8px; background: rgba(231, 76, 60, 0.1); border: 1px solid #e74c3c; border-radius: 4px; color: #e74c3c; font-size: 0.85rem;">
                                                                <i class="fa-solid fa-triangle-exclamation"></i> 
                                                                <strong>Cảnh báo:</strong> Ghế này đang bảo trì/hỏng.
                                                                <div style="margin-top: 4px; font-size: 0.8rem; color: #c0392b;">
                                                                    Vui lòng liên hệ nhân viên để đổi ghế mới.
                                                                </div>
                                                            </div>
                                                        </c:if>
                                                    </div>

                                                    <div class="ticket-status">
                                                        <c:choose>
                                                            <%-- TRƯỜNG HỢP VÉ ĐÃ THANH TOÁN THÀNH CÔNG --%>
                                                            <c:when test="${order.status == 'CONFIRMED'}">
                                                                <c:choose>
                                                                    <%-- Logic mới: Nếu giờ chiếu nhỏ hơn (<) giờ hiện tại (now) -> Đã hết hạn --%>
                                                                    <c:when test="${detail.scheduleID.showTime lt now}">
                                                                        <span style="color: #95a5a6; font-weight: bold;">
                                                                            <i class="fa-solid fa-clock-rotate-left" style="color:#95a5a6; width:auto;"></i> Đã chiếu
                                                                        </span>
                                                                    </c:when>

                                                                    <%-- Ngược lại: Vẫn còn hạn sử dụng -> Thành công --%>
                                                                    <c:otherwise>
                                                                        <span style="color: #4cd137; font-weight: bold;">
                                                                            <i class="fa-solid fa-check-circle" style="color:#4cd137; width:auto;"></i> Thành công
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>

                                                            <%-- CÁC TRƯỜNG HỢP KHÁC (Hủy, Pending...) GIỮ NGUYÊN --%>
                                                            <c:when test="${order.status == 'CANCELLED'}">
                                                                <span style="color: #e74c3c;">
                                                                    <i class="fa-solid fa-times-circle" style="color:#e74c3c; width:auto;"></i> Đã hủy
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'PENDING'}">
                                                                <span style="color: #f39c12;">
                                                                    <i class="fa-solid fa-hourglass-half" style="color:#f39c12; width:auto;"></i> Chờ xử lý
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="color: #95a5a6;">● N/A</span>
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
                    <div class="actions">
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-gold">
                            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                        </a>
                    </div>

                </div>
            </div>
        </div>

    </body>
</html>