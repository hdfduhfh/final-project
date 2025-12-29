<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Sự kiện | Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/event-list.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="admin-container">
        <!-- Header -->
        <div class="page-header">
            <div class="header-left">
                <h1><i class="fas fa-calendar-alt"></i> Quản lý Sự kiện</h1>
                <p>Quản lý các sự kiện giao lưu nghệ sĩ</p>
            </div>
            <div class="header-right">
                <a href="${pageContext.request.contextPath}/admin/events?action=add" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Thêm sự kiện mới
                </a>
            </div>
        </div>

        <!-- Alert Messages -->
        <c:if test="${param.success == 'create'}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> Tạo sự kiện thành công!
            </div>
        </c:if>
        <c:if test="${param.success == 'update'}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> Cập nhật sự kiện thành công!
            </div>
        </c:if>
        <c:if test="${param.success == 'delete'}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> Xóa sự kiện thành công!
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <!-- Statistics -->
        <div class="stats-grid">
            <div class="stat-card upcoming">
                <div class="stat-icon"><i class="fas fa-clock"></i></div>
                <div class="stat-info">
                    <h3>${upcomingCount}</h3>
                    <p>Sắp diễn ra</p>
                </div>
            </div>
            <div class="stat-card ongoing">
                <div class="stat-icon"><i class="fas fa-play-circle"></i></div>
                <div class="stat-info">
                    <h3>${ongoingCount}</h3>
                    <p>Đang diễn ra</p>
                </div>
            </div>
            <div class="stat-card completed">
                <div class="stat-icon"><i class="fas fa-check-circle"></i></div>
                <div class="stat-info">
                    <h3>${completedCount}</h3>
                    <p>Đã hoàn thành</p>
                </div>
            </div>
            <div class="stat-card cancelled">
                <div class="stat-icon"><i class="fas fa-times-circle"></i></div>
                <div class="stat-info">
                    <h3>${cancelledCount}</h3>
                    <p>Đã hủy</p>
                </div>
            </div>
        </div>

        <!-- Filter & Search -->
        <div class="filter-section">
            <form method="get" action="${pageContext.request.contextPath}/admin/events" class="filter-form">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" name="keyword" placeholder="Tìm kiếm sự kiện..." 
                           value="${keyword}" />
                </div>
                <select name="status" onchange="this.form.submit()">
                    <option value="">Tất cả trạng thái</option>
                    <option value="Upcoming" ${statusFilter == 'Upcoming' ? 'selected' : ''}>Sắp diễn ra</option>
                    <option value="Ongoing" ${statusFilter == 'Ongoing' ? 'selected' : ''}>Đang diễn ra</option>
                    <option value="Completed" ${statusFilter == 'Completed' ? 'selected' : ''}>Đã hoàn thành</option>
                    <option value="Cancelled" ${statusFilter == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                </select>
                <select name="type" onchange="this.form.submit()">
                    <option value="">Tất cả loại</option>
                    <option value="MeetAndGreet" ${typeFilter == 'MeetAndGreet' ? 'selected' : ''}>Giao lưu</option>
                    <option value="Workshop" ${typeFilter == 'Workshop' ? 'selected' : ''}>Workshop</option>
                    <option value="FanMeeting" ${typeFilter == 'FanMeeting' ? 'selected' : ''}>Fan Meeting</option>
                    <option value="TalkShow" ${typeFilter == 'TalkShow' ? 'selected' : ''}>Talk Show</option>
                </select>
                <button type="submit" class="btn btn-secondary">
                    <i class="fas fa-filter"></i> Lọc
                </button>
            </form>
        </div>

        <!-- Events Table -->
        <div class="table-container">
            <table class="events-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên sự kiện</th>
                        <th>Loại</th>
                        <th>Ngày diễn ra</th>
                        <th>Địa điểm</th>
                        <th>Số người</th>
                        <th>Giá vé</th>
                        <th>Trạng thái</th>
                        <th>Công khai</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="event" items="${events}">
                        <tr>
                            <td>${event.eventID}</td>
                            <td class="event-name">
    <div class="event-thumbnail">
        <c:choose>
            <c:when test="${not empty event.thumbnailUrl}">
                <img src="${pageContext.request.contextPath}/${event.thumbnailUrl}" 
                     alt="${event.eventName}" />
            </c:when>
            <c:otherwise>
                <i class="fas fa-image"></i>
            </c:otherwise>
        </c:choose>
    </div>
    <div class="event-info">
        <strong>${event.eventName}</strong>
        <small>${event.artistNames}</small>
    </div>
</td>
                            <td>
                                <span class="badge badge-type">
                                    <c:choose>
                                        <c:when test="${event.eventType == 'MeetAndGreet'}">Giao lưu</c:when>
                                        <c:when test="${event.eventType == 'Workshop'}">Workshop</c:when>
                                        <c:when test="${event.eventType == 'FanMeeting'}">Fan Meeting</c:when>
                                        <c:when test="${event.eventType == 'TalkShow'}">Talk Show</c:when>
                                        <c:otherwise>${event.eventType}</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>
                                <fmt:formatDate value="${event.eventDate}" pattern="dd/MM/yyyy HH:mm" />
                            </td>
                            <td>${event.venue}</td>
                            <td>
                                <span class="attendees-badge">
                                    ${event.currentAttendees}/${event.maxAttendees}
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${event.price == 0}">
                                        <span class="price-free">Miễn phí</span>
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="${event.price}" type="currency" 
                                                         currencySymbol="" maxFractionDigits="0" />đ
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="badge badge-${event.status}">
                                    <c:choose>
                                        <c:when test="${event.status == 'Upcoming'}">Sắp diễn ra</c:when>
                                        <c:when test="${event.status == 'Ongoing'}">Đang diễn ra</c:when>
                                        <c:when test="${event.status == 'Completed'}">Đã hoàn thành</c:when>
                                        <c:when test="${event.status == 'Cancelled'}">Đã hủy</c:when>
                                        <c:otherwise>${event.status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${event.isPublished}">
                                        <span class="published-badge yes">
                                            <i class="fas fa-eye"></i> Công khai
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="published-badge no">
                                            <i class="fas fa-eye-slash"></i> Nháp
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="actions">
<td class="actions">
    <!-- Nút xem chi tiết đăng ký -->
    <a href="${pageContext.request.contextPath}/admin/events?action=registrations&id=${event.eventID}" 
       class="btn-action btn-view" 
       title="Xem đăng ký"
       style="background: #27ae60;">
        <i class="fas fa-chart-bar"></i>
    </a>
    
    <a href="${pageContext.request.contextPath}/admin/events?action=edit&id=${event.eventID}" 
       class="btn-action btn-edit" title="Sửa">
        <i class="fas fa-edit"></i>
    </a>
    
    <a href="javascript:void(0)" 
       onclick="confirmDelete(${event.eventID}, '${event.eventName}')" 
       class="btn-action btn-delete" title="Xóa">
        <i class="fas fa-trash"></i>
    </a>
</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty events}">
                        <tr>
                            <td colspan="10" class="no-data">
                                <i class="fas fa-inbox"></i>
                                <p>Không có sự kiện nào</p>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/admin/event-list.js"></script>
</body>
</html>