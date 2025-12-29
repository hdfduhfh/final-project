<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sự kiện Giao lưu Nghệ sĩ | BookingStage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/event.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="hero-overlay"></div>
        <div class="hero-content">
            <h1 class="hero-title">
                <i class="fas fa-star"></i> Sự Kiện Giao Lưu Nghệ Sĩ
            </h1>
            <p class="hero-subtitle">
                Gặp gỡ và trò chuyện cùng các nghệ sĩ yêu thích của bạn
            </p>
            <div class="hero-search">
                <form method="get" action="${pageContext.request.contextPath}/events">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" name="keyword" placeholder="Tìm kiếm sự kiện..." 
                               value="${keyword}" />
                        <button type="submit" class="search-btn">Tìm kiếm</button>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <!-- Filter Section -->
    <section class="filter-section">
        <div class="container">
            <div class="filter-tabs">
                <a href="${pageContext.request.contextPath}/events" 
                   class="filter-tab ${empty typeFilter ? 'active' : ''}">
                    <i class="fas fa-th"></i> Tất cả
                </a>
                <a href="${pageContext.request.contextPath}/events?type=MeetAndGreet" 
                   class="filter-tab ${typeFilter == 'MeetAndGreet' ? 'active' : ''}">
                    <i class="fas fa-handshake"></i> Giao lưu
                </a>
                <a href="${pageContext.request.contextPath}/events?type=Workshop" 
                   class="filter-tab ${typeFilter == 'Workshop' ? 'active' : ''}">
                    <i class="fas fa-chalkboard-teacher"></i> Workshop
                </a>
                <a href="${pageContext.request.contextPath}/events?type=FanMeeting" 
                   class="filter-tab ${typeFilter == 'FanMeeting' ? 'active' : ''}">
                    <i class="fas fa-users"></i> Fan Meeting
                </a>
                <a href="${pageContext.request.contextPath}/events?type=TalkShow" 
                   class="filter-tab ${typeFilter == 'TalkShow' ? 'active' : ''}">
                    <i class="fas fa-microphone"></i> Talk Show
                </a>
            </div>
        </div>
    </section>

    <!-- Upcoming Events Highlight -->
    <c:if test="${not empty upcomingEvents && empty keyword && empty typeFilter}">
        <section class="upcoming-section">
            <div class="container">
                <div class="section-header">
                    <h2><i class="fas fa-fire"></i> Sự kiện sắp diễn ra</h2>
                    <p>Những sự kiện hot nhất đang chờ bạn</p>
                </div>
                <div class="upcoming-grid">
                    <c:forEach var="event" items="${upcomingEvents}" varStatus="status">
                        <c:if test="${status.index < 6}">
                            <div class="upcoming-card" data-aos="fade-up" data-aos-delay="${status.index * 100}">
                                <div class="upcoming-image">
                                    <c:choose>
                                        <c:when test="${not empty event.thumbnailUrl}">
                                            <img src="${event.thumbnailUrl}" alt="${event.eventName}" />
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/assets/images/event-placeholder.jpg" 
                                                 alt="Event" />
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="event-type-badge">
                                        <c:choose>
                                            <c:when test="${event.eventType == 'MeetAndGreet'}">Giao lưu</c:when>
                                            <c:when test="${event.eventType == 'Workshop'}">Workshop</c:when>
                                            <c:when test="${event.eventType == 'FanMeeting'}">Fan Meeting</c:when>
                                            <c:when test="${event.eventType == 'TalkShow'}">Talk Show</c:when>
                                        </c:choose>
                                    </div>
                                    <c:if test="${event.isFull()}">
                                        <div class="sold-out-badge">Hết chỗ</div>
                                    </c:if>
                                </div>
                                <div class="upcoming-content">
                                    <h3>${event.eventName}</h3>
                                    <div class="event-meta">
                                        <div class="meta-item">
                                            <i class="fas fa-calendar"></i>
                                            <fmt:formatDate value="${event.eventDate}" pattern="dd/MM/yyyy" />
                                        </div>
                                        <div class="meta-item">
                                            <i class="fas fa-clock"></i>
                                            <fmt:formatDate value="${event.eventDate}" pattern="HH:mm" />
                                        </div>
                                        <div class="meta-item">
                                            <i class="fas fa-map-marker-alt"></i>
                                            ${event.venue}
                                        </div>
                                    </div>
                                    <div class="event-artists">
                                        <i class="fas fa-user-tie"></i> ${event.artistNames}
                                    </div>
                                    <div class="event-footer">
                                        <div class="event-price">
                                            <c:choose>
                                                <c:when test="${event.price == 0}">
                                                    <span class="price-free">Miễn phí</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="price-amount">
                                                        <fmt:formatNumber value="${event.price}" type="number" 
                                                                         groupingUsed="true" />đ
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="event-attendees">
                                            <i class="fas fa-users"></i> 
                                            ${event.currentAttendees}/${event.maxAttendees}
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/event-detail?id=${event.eventID}" 
                                       class="btn-detail">
                                        Xem chi tiết <i class="fas fa-arrow-right"></i>
                                    </a>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </section>
    </c:if>

    <!-- All Events Section -->
    <section class="events-section">
        <div class="container">
            <div class="section-header">
                <h2>
                    <i class="fas fa-calendar-alt"></i> 
                    <c:choose>
                        <c:when test="${not empty keyword}">Kết quả tìm kiếm: "${keyword}"</c:when>
                        <c:when test="${not empty typeFilter}">
                            <c:choose>
                                <c:when test="${typeFilter == 'MeetAndGreet'}">Sự kiện Giao lưu</c:when>
                                <c:when test="${typeFilter == 'Workshop'}">Workshop</c:when>
                                <c:when test="${typeFilter == 'FanMeeting'}">Fan Meeting</c:when>
                                <c:when test="${typeFilter == 'TalkShow'}">Talk Show</c:when>
                            </c:choose>
                        </c:when>
                        <c:otherwise>Tất cả sự kiện</c:otherwise>
                    </c:choose>
                </h2>
                <p>
                    <c:choose>
                        <c:when test="${not empty events}">
                            Tìm thấy ${events.size()} sự kiện
                        </c:when>
                        <c:otherwise>
                            Không tìm thấy sự kiện nào
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>

            <c:choose>
                <c:when test="${not empty events}">
                    <div class="events-grid">
                        <c:forEach var="event" items="${events}" varStatus="status">
                            <div class="event-card" data-aos="zoom-in" data-aos-delay="${status.index * 50}">
                                <div class="event-image">
                                    <c:choose>
                                        <c:when test="${not empty event.thumbnailUrl}">
                                            <img src="${event.thumbnailUrl}" alt="${event.eventName}" />
                                        </c:when>
                                        <c:otherwise>
                                            <div class="image-placeholder">
                                                <i class="fas fa-image"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="event-status-badge">
                                        <c:choose>
                                            <c:when test="${event.status == 'Upcoming'}">
                                                <span class="badge-upcoming">Sắp diễn ra</span>
                                            </c:when>
                                            <c:when test="${event.status == 'Ongoing'}">
                                                <span class="badge-ongoing">Đang diễn ra</span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="event-content">
                                    <span class="event-category">
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
                                    </span>
                                    <h3 class="event-title">${event.eventName}</h3>
                                    <div class="event-info">
                                        <div class="info-item">
                                            <i class="fas fa-calendar-day"></i>
                                            <span><fmt:formatDate value="${event.eventDate}" pattern="dd/MM/yyyy HH:mm" /></span>
                                        </div>
                                        <div class="info-item">
                                            <i class="fas fa-map-marker-alt"></i>
                                            <span>${event.venue}</span>
                                        </div>
                                        <div class="info-item">
                                            <i class="fas fa-user-friends"></i>
                                            <span>${event.artistNames}</span>
                                        </div>
                                    </div>
                                    <div class="event-bottom">
                                        <div class="event-price-tag">
                                            <c:choose>
                                                <c:when test="${event.price == 0}">
                                                    <span class="free-badge">Miễn phí</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="price-value">
                                                        <fmt:formatNumber value="${event.price}" type="number" />đ
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/event-detail?id=${event.eventID}" 
                                           class="btn-view">
                                            Chi tiết <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-events">
                        <i class="fas fa-calendar-times"></i>
                        <h3>Không có sự kiện nào</h3>
                        <p>Hiện tại chưa có sự kiện phù hợp với tìm kiếm của bạn</p>
                        <a href="${pageContext.request.contextPath}/events" class="btn-primary">
                            <i class="fas fa-redo"></i> Xem tất cả sự kiện
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <!-- Popular Events Sidebar (nếu có) -->
    <c:if test="${not empty popularEvents && empty keyword && empty typeFilter}">
        <section class="popular-section">
            <div class="container">
                <div class="section-header">
                    <h2><i class="fas fa-trophy"></i> Sự kiện phổ biến</h2>
                    <p>Nhiều người quan tâm nhất</p>
                </div>
                <div class="popular-grid">
                    <c:forEach var="event" items="${popularEvents}">
                        <div class="popular-card">
                            <div class="popular-image">
                                <c:choose>
                                    <c:when test="${not empty event.thumbnailUrl}">
                                        <img src="${event.thumbnailUrl}" alt="${event.eventName}" />
                                    </c:when>
                                    <c:otherwise>
                                        <div class="image-placeholder-small">
                                            <i class="fas fa-image"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="popular-info">
                                <h4>${event.eventName}</h4>
                                <p><i class="fas fa-calendar"></i> 
                                   <fmt:formatDate value="${event.eventDate}" pattern="dd/MM/yyyy" />
                                </p>
                                <div class="popular-stats">
                                    <span class="stat-item">
                                        <i class="fas fa-users"></i> ${event.currentAttendees} người
                                    </span>
                                    <a href="${pageContext.request.contextPath}/event-detail?id=${event.eventID}" 
                                       class="link-view">Xem</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>
    </c:if>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script src="${pageContext.request.contextPath}/js/event.js"></script>
</body>
</html>