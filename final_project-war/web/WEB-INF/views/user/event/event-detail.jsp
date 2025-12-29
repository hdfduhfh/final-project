<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${event.eventName} | BookingStage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/event-detail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- Back Button -->
    <div class="back-nav">
        <div class="container">
            <a href="${pageContext.request.contextPath}/events" class="btn-back">
                <i class="fas fa-arrow-left"></i> Quay lại danh sách
            </a>
        </div>
    </div>

    <!-- Event Hero Banner -->
    <section class="event-hero">
        <div class="hero-banner">
            <c:choose>
                <c:when test="${not empty event.bannerUrl}">
                    <img src="${event.bannerUrl}" alt="${event.eventName}" class="banner-image" />
                </c:when>
                <c:when test="${not empty event.thumbnailUrl}">
                    <img src="${event.thumbnailUrl}" alt="${event.eventName}" class="banner-image" />
                </c:when>
                <c:otherwise>
                    <div class="banner-placeholder">
                        <i class="fas fa-calendar-star"></i>
                    </div>
                </c:otherwise>
            </c:choose>
            <div class="hero-overlay"></div>
        </div>
    </section>

    <!-- Event Main Content -->
    <section class="event-main">
        <div class="container">
            <div class="event-layout">
                <!-- Left Content -->
                <div class="event-content-left">
                    <div class="event-header">
                        <div class="event-type-badge">
                            <c:choose>
                                <c:when test="${event.eventType == 'MeetAndGreet'}">
                                    <i class="fas fa-handshake"></i> Giao lưu
                                </c:when>
                                <c:when test="${event.eventType == 'Workshop'}">
                                    <i class="fas fa-chalkboard-teacher"></i> Workshop
                                </c:when>
                                <c:when test="${event.eventType == 'FanMeeting'}">
                                    <i class="fas fa-users"></i> Fan Meeting
                                </c:when>
                                <c:when test="${event.eventType == 'TalkShow'}">
                                    <i class="fas fa-microphone"></i> Talk Show
                                </c:when>
                            </c:choose>
                        </div>
                        <h1 class="event-name">${event.eventName}</h1>
                        <div class="event-status-tag">
                            <c:choose>
                                <c:when test="${event.status == 'Upcoming'}">
                                    <span class="status-upcoming">
                                        <i class="fas fa-clock"></i> Sắp diễn ra
                                    </span>
                                </c:when>
                                <c:when test="${event.status == 'Ongoing'}">
                                    <span class="status-ongoing">
                                        <i class="fas fa-play-circle"></i> Đang diễn ra
                                    </span>
                                </c:when>
                                <c:when test="${event.status == 'Completed'}">
                                    <span class="status-completed">
                                        <i class="fas fa-check-circle"></i> Đã hoàn thành
                                    </span>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Event Description -->
                    <div class="event-section">
                        <h2><i class="fas fa-align-left"></i> Giới thiệu</h2>
                        <div class="event-description">
                            <c:choose>
                                <c:when test="${not empty event.description}">
                                    ${event.description}
                                </c:when>
                                <c:otherwise>
                                    <p>Chưa có mô tả chi tiết cho sự kiện này.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Event Details -->
                    <div class="event-section">
                        <h2><i class="fas fa-info-circle"></i> Thông tin chi tiết</h2>
                        <div class="event-details-grid">
                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="fas fa-calendar-alt"></i>
                                </div>
                                <div class="detail-content">
                                    <span class="detail-label">Ngày diễn ra</span>
                                    <span class="detail-value">
                                        <fmt:formatDate value="${event.eventDate}" pattern="EEEE, dd/MM/yyyy" />
                                    </span>
                                </div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div class="detail-content">
                                    <span class="detail-label">Thời gian</span>
                                    <span class="detail-value">
                                        <fmt:formatDate value="${event.eventDate}" pattern="HH:mm" />
                                        <c:if test="${not empty event.endDate}">
                                            - <fmt:formatDate value="${event.endDate}" pattern="HH:mm" />
                                        </c:if>
                                    </span>
                                </div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="fas fa-map-marker-alt"></i>
                                </div>
                                <div class="detail-content">
                                    <span class="detail-label">Địa điểm</span>
                                    <span class="detail-value">${event.venue}</span>
                                    <c:if test="${not empty event.address}">
                                        <span class="detail-subtext">${event.address}</span>
                                    </c:if>
                                </div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <i class="fas fa-user-tie"></i>
                                </div>
                                <div class="detail-content">
                                    <span class="detail-label">Nghệ sĩ tham gia</span>
                                    <span class="detail-value">${event.artistNames}</span>
                                </div>
                            </div>

                            <c:if test="${not empty event.hostedBy}">
                                <div class="detail-item">
                                    <div class="detail-icon">
                                        <i class="fas fa-building"></i>
                                    </div>
                                    <div class="detail-content">
                                        <span class="detail-label">Tổ chức bởi</span>
                                        <span class="detail-value">${event.hostedBy}</span>
                                    </div>
                                </div>
                            </c:if>

                            <c:if test="${not empty event.contactInfo}">
                                <div class="detail-item">
                                    <div class="detail-icon">
                                        <i class="fas fa-phone"></i>
                                    </div>
                                    <div class="detail-content">
                                        <span class="detail-label">Liên hệ</span>
                                        <span class="detail-value">${event.contactInfo}</span>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Requirements -->
                    <c:if test="${not empty event.requirements}">
                        <div class="event-section">
                            <h2><i class="fas fa-clipboard-list"></i> Yêu cầu tham gia</h2>
                            <div class="requirements-box">
                                <p>${event.requirements}</p>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Right Sidebar -->
                <div class="event-sidebar">
                    <div class="booking-card">
                        <div class="booking-header">
                            <div class="price-display">
                                <c:choose>
                                    <c:when test="${event.price == 0}">
                                        <span class="price-free">
                                            <i class="fas fa-gift"></i> Miễn phí
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="price-label">Giá vé</span>
                                        <span class="price-amount">
                                            <fmt:formatNumber value="${event.price}" type="number" />đ
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="booking-info">
                            <div class="info-row">
                                <span class="info-label">
                                    <i class="fas fa-users"></i> Số chỗ còn lại
                                </span>
                                <span class="info-value">
                                    ${event.availableSlots}/${event.maxAttendees}
                                </span>
                            </div>
                            <div class="progress-bar">
                                <div class="progress-fill" 
                                     style="width: ${(event.currentAttendees * 100.0) / event.maxAttendees}%">
                                </div>
                            </div>

                            <c:if test="${not empty event.registrationDeadline}">
                                <div class="info-row">
                                    <span class="info-label">
                                        <i class="fas fa-hourglass-end"></i> Hạn đăng ký
                                    </span>
                                    <span class="info-value">
                                        <fmt:formatDate value="${event.registrationDeadline}" 
                                                       pattern="dd/MM/yyyy HH:mm" />
                                    </span>
                                </div>
                            </c:if>
                        </div>

                        <div class="booking-actions">
                            <c:choose>
                                <c:when test="${event.isFull()}">
                                    <button class="btn-register disabled" disabled>
                                        <i class="fas fa-times-circle"></i> Đã hết chỗ
                                    </button>
                                </c:when>
                                <c:when test="${!event.canRegister()}">
                                    <button class="btn-register disabled" disabled>
                                        <i class="fas fa-ban"></i> Không thể đăng ký
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user}">
                                            <button class="btn-register" onclick="registerEvent(${event.eventID})">
                                                <i class="fas fa-ticket-alt"></i> Đăng ký tham gia
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/login?redirect=event-detail&id=${event.eventID}" 
                                               class="btn-register">
                                                <i class="fas fa-sign-in-alt"></i> Đăng nhập để đăng ký
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="booking-note">
                            <i class="fas fa-info-circle"></i>
                            <small>Vui lòng đọc kỹ thông tin và yêu cầu tham gia trước khi đăng ký</small>
                        </div>
                    </div>

                    <!-- Share Section -->
                    <div class="share-card">
                        <h3><i class="fas fa-share-alt"></i> Chia sẻ sự kiện</h3>
                        <div class="share-buttons">
                            <button class="share-btn facebook" onclick="shareOnFacebook()">
                                <i class="fab fa-facebook-f"></i> Facebook
                            </button>
                            <button class="share-btn twitter" onclick="shareOnTwitter()">
                                <i class="fab fa-twitter"></i> Twitter
                            </button>
                            <button class="share-btn copy" onclick="copyLink()">
                                <i class="fas fa-link"></i> Sao chép link
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Related Events -->
    <c:if test="${not empty relatedEvents}">
        <section class="related-events">
            <div class="container">
                <div class="section-header">
                    <h2><i class="fas fa-calendar-check"></i> Sự kiện liên quan</h2>
                    <p>Các sự kiện khác bạn có thể quan tâm</p>
                </div>
                <div class="related-grid">
                    <c:forEach var="related" items="${relatedEvents}">
                        <div class="related-card">
                            <div class="related-image">
                                <c:choose>
                                    <c:when test="${not empty related.thumbnailUrl}">
                                        <img src="${related.thumbnailUrl}" alt="${related.eventName}" />
                                    </c:when>
                                    <c:otherwise>
                                        <div class="image-placeholder">
                                            <i class="fas fa-image"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="related-content">
                                <h4>${related.eventName}</h4>
                                <p class="related-date">
                                    <i class="fas fa-calendar"></i>
                                    <fmt:formatDate value="${related.eventDate}" pattern="dd/MM/yyyy HH:mm" />
                                </p>
                                <p class="related-venue">
                                    <i class="fas fa-map-marker-alt"></i>
                                    ${related.venue}
                                </p>
                                <a href="${pageContext.request.contextPath}/event-detail?id=${related.eventID}" 
                                   class="btn-related">
                                    Xem chi tiết <i class="fas fa-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>
    </c:if>

    <script src="${pageContext.request.contextPath}/js/event-detail.js"></script>
</body>
</html>