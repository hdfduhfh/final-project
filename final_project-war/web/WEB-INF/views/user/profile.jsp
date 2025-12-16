<%-- 
    Document   : profile
    Created on : Dec 15, 2025
    Author     : DANG KHOA
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Montserrat:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user.css">

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
                    <i class="fa-solid fa-user-tie"></i> </div>
                <div class="avatar-ring"></div> </div>

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
            <h3><i class="fa-solid fa-address-card" style="color: #d4af37;"></i> Thông tin tài khoản</h3>

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
            <div class="ticket-section">
                <h3><i class="fa-solid fa-ticket" style="color: #d4af37;"></i> Vé đã mua</h3>

                <c:set var="bookingHistory" value="mockData" /> 

                <c:choose>
                    <%-- TRƯỜNG HỢP 1: CÓ VÉ --%>
                    <c:when test="${not empty bookingHistory}">
                        <div class="ticket-card">
                            <div class="ticket-poster" style="background-image: url('https://image.tmdb.org/t/p/w200/db2243l3r8.jpg');"></div>
                            <div class="ticket-info">
                                <div class="movie-title">The Godfather: Part II</div>
                                <div class="ticket-detail">
                                    <span><i class="fa-regular fa-clock"></i> 19:30 - 20/12/2025</span>
                                    <span><i class="fa-solid fa-couch"></i> Ghế: F5, F6</span>
                                </div>
                                <div class="ticket-status">● Đã thanh toán</div>
                            </div>
                        </div>

                        <div class="ticket-card">
                            <div class="ticket-poster" style="background-image: url('https://image.tmdb.org/t/p/w200/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg');"></div>
                            <div class="ticket-info">
                                <div class="movie-title">The Shawshank Redemption</div>
                                <div class="ticket-detail">
                                    <span><i class="fa-regular fa-clock"></i> 21:00 - 15/12/2025</span>
                                    <span><i class="fa-solid fa-couch"></i> Ghế: J10</span>
                                </div>
                                <div class="ticket-status" style="color: #aaa; background: rgba(255,255,255,0.1);">● Đã xem</div>
                            </div>
                        </div>

                    </c:when>

                    <%-- TRƯỜNG HỢP 2: KHÔNG CÓ VÉ (EMPTY STATE) --%>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="fa-solid fa-film"></i>
                            </div>
                            <div class="empty-text">Bạn chưa đặt vé bộ phim nào gần đây.</div>
                            <a href="${pageContext.request.contextPath}/movies" class="btn btn-outline-gold" style="padding: 8px 20px; font-size: 0.8rem;">
                                Đặt vé ngay
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="actions">

                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-gold">
                    <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                </a>
            </div>
        </div>
    </div>
</div>