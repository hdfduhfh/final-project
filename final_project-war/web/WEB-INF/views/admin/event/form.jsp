<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${empty event ? 'Thêm' : 'Sửa'} Sự kiện | Admin</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/event-form.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>
    <body>
        <div class="admin-container">
            <!-- Header -->
            <div class="page-header">
                <div class="header-left">
                    <a href="${pageContext.request.contextPath}/admin/events" class="btn-back">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                    <h1>
                        <i class="fas fa-calendar-plus"></i> 
                        ${empty event ? 'Thêm sự kiện mới' : 'Sửa sự kiện'}
                    </h1>
                </div>
            </div>

            <!-- Form -->
            <form method="post" 
                  action="${pageContext.request.contextPath}/admin/events" 
                  enctype="multipart/form-data" 
                  class="event-form"
                  onsubmit="return validateForm()">

                <input type="hidden" name="action" value="${empty event ? 'create' : 'update'}" />
                <c:if test="${not empty event}">
                    <input type="hidden" name="eventId" value="${event.eventID}" />
                </c:if>

                <div class="form-grid">
                    <!-- Thông tin cơ bản -->
                    <div class="form-section">
                        <h2><i class="fas fa-info-circle"></i> Thông tin cơ bản</h2>

                        <div class="form-group">
                            <label>Tên sự kiện <span class="required">*</span></label>
                            <input type="text" name="eventName" value="${event.eventName}" 
                                   placeholder="VD: Giao lưu cùng Nghệ sĩ Hoài Linh" required />
                        </div>

                        <div class="form-group">
                            <label>Mô tả</label>
                            <textarea name="description" rows="4" 
                                      placeholder="Mô tả chi tiết về sự kiện...">${event.description}</textarea>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Loại sự kiện <span class="required">*</span></label>
                                <select name="eventType" required>
                                    <option value="">-- Chọn loại --</option>
                                    <option value="MeetAndGreet" ${event.eventType == 'MeetAndGreet' ? 'selected' : ''}>
                                        Giao lưu (Meet & Greet)
                                    </option>
                                    <option value="Workshop" ${event.eventType == 'Workshop' ? 'selected' : ''}>
                                        Workshop
                                    </option>
                                    <option value="FanMeeting" ${event.eventType == 'FanMeeting' ? 'selected' : ''}>
                                        Fan Meeting
                                    </option>
                                    <option value="TalkShow" ${event.eventType == 'TalkShow' ? 'selected' : ''}>
                                        Talk Show
                                    </option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Trạng thái <span class="required">*</span></label>
                                <select name="status" required>
                                    <option value="Upcoming" ${event.status == 'Upcoming' ? 'selected' : ''}>
                                        Sắp diễn ra
                                    </option>
                                    <option value="Ongoing" ${event.status == 'Ongoing' ? 'selected' : ''}>
                                        Đang diễn ra
                                    </option>
                                    <option value="Completed" ${event.status == 'Completed' ? 'selected' : ''}>
                                        Đã hoàn thành
                                    </option>
                                    <option value="Cancelled" ${event.status == 'Cancelled' ? 'selected' : ''}>
                                        Đã hủy
                                    </option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Thời gian & Địa điểm -->
                    <div class="form-section">
                        <h2><i class="fas fa-map-marker-alt"></i> Thời gian & Địa điểm</h2>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Ngày bắt đầu <span class="required">*</span></label>
                                <input type="datetime-local" name="eventDate" 
                                       value="<fmt:formatDate value='${event.eventDate}' pattern='yyyy-MM-dd\'T\'HH:mm'/>" 
                                       required />
                            </div>

                            <div class="form-group">
                                <label>Ngày kết thúc</label>
                                <input type="datetime-local" name="endDate" 
                                       value="<fmt:formatDate value='${event.endDate}' pattern='yyyy-MM-dd\'T\'HH:mm'/>" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Địa điểm <span class="required">*</span></label>
                            <input type="text" name="venue" value="${event.venue}" 
                                   placeholder="VD: Nhà hát Thành phố" required />
                        </div>

                        <div class="form-group">
                            <label>Địa chỉ chi tiết</label>
                            <input type="text" name="address" value="${event.address}" 
                                   placeholder="VD: 123 Nguyễn Huệ, Quận 1, TP.HCM" />
                        </div>
                    </div>

                    <!-- Nghệ sĩ & Tổ chức -->
                    <div class="form-section">
                        <h2><i class="fas fa-users"></i> Nghệ sĩ & Tổ chức</h2>

                        <div class="form-group">
                            <label>Nghệ sĩ tham gia</label>
                            <input type="text" name="artistNames" value="${event.artistNames}" 
                                   placeholder="VD: Hoài Linh, Trấn Thành" />
                            <small>Nhập tên các nghệ sĩ, cách nhau bằng dấu phẩy</small>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Tổ chức bởi</label>
                                <input type="text" name="hostedBy" value="${event.hostedBy}" 
                                       placeholder="VD: Rạp hát Thành phố" />
                            </div>

                            <div class="form-group">
                                <label>Thông tin liên hệ</label>
                                <input type="text" name="contactInfo" value="${event.contactInfo}" 
                                       placeholder="VD: 0901234567" />
                            </div>
                        </div>
                    </div>

                    <!-- Vé & Đăng ký -->
                    <div class="form-section">
                        <h2><i class="fas fa-ticket-alt"></i> Vé & Đăng ký</h2>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Số người tối đa <span class="required">*</span></label>
                                <input type="number" name="maxAttendees" value="${event.maxAttendees}" 
                                       min="1" placeholder="100" required />
                            </div>

                            <div class="form-group">
                                <label>Giá vé (VNĐ) <span class="required">*</span></label>
                                <input type="number" name="price" value="${event.price}" 
                                       min="0" step="1000" placeholder="0 = Miễn phí" required />
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Hạn chót đăng ký</label>
                            <input type="datetime-local" name="registrationDeadline" 
                                   value="<fmt:formatDate value='${event.registrationDeadline}' pattern='yyyy-MM-dd\'T\'HH:mm'/>" />
                        </div>

                        <div class="form-group">
                            <label>Yêu cầu tham gia</label>
                            <textarea name="requirements" rows="3" 
                                      placeholder="VD: Mang theo CCCD, Dress code...">${event.requirements}</textarea>
                        </div>
                    </div>
<!-- Hình ảnh -->
<div class="form-section">
    <h2><i class="fas fa-image"></i> Hình ảnh</h2>

    <!-- THUMBNAIL -->
    <div class="form-group">
        <label>Thumbnail <span class="required">*</span></label>
        <select name="thumbnailSelect" 
                onchange="previewSelectedImage(this, 'thumbPreview')" 
                required>
            <option value="">-- Chọn hình ảnh từ thư mục --</option>
            <c:forEach var="img" items="${imageList}">
                <option value="${img}" 
                        ${fn:endsWith(event.thumbnailUrl, img) ? 'selected' : ''}>
                    ${img}
                </option>
            </c:forEach>
        </select>
        
        <div id="thumbPreview" class="preview-box">
            <c:if test="${not empty event.thumbnailUrl}">
                <img src="${pageContext.request.contextPath}/${event.thumbnailUrl}" 
                     alt="Thumbnail">
            </c:if>
        </div>
        <small>📁 Chọn ảnh ở dropdown để xem trước</small>
    </div>

    <!-- BANNER -->
    <div class="form-group">
        <label>Banner</label>
        <select name="bannerSelect" 
                onchange="previewSelectedImage(this, 'bannerPreview')">
            <option value="">-- Chọn hình ảnh từ thư mục --</option>
            <c:forEach var="img" items="${imageList}">
                <option value="${img}" 
                        ${fn:endsWith(event.bannerUrl, img) ? 'selected' : ''}>
                    ${img}
                </option>
            </c:forEach>
        </select>
        
        <div id="bannerPreview" class="preview-box">
            <c:if test="${not empty event.bannerUrl}">
                <img src="${pageContext.request.contextPath}/${event.bannerUrl}" 
                     alt="Banner">
            </c:if>
        </div>
        <small>📁 Chọn ảnh ở dropdown để xem trước</small>
    </div>
</div>
                    <!-- Tùy chọn -->
                    <div class="form-section">
                        <h2><i class="fas fa-cog"></i> Tùy chọn</h2>

                        <div class="form-group-checkbox">
                            <label>
                                <input type="checkbox" name="isPublished" 
                                       ${event.isPublished ? 'checked' : ''} />
                                <span>Công khai sự kiện (Hiển thị trên trang User)</span>
                            </label>
                        </div>

                        <div class="form-group-checkbox">
                            <label>
                                <input type="checkbox" name="allowRegistration" 
                                       ${empty event || event.allowRegistration ? 'checked' : ''} />
                                <span>Cho phép đăng ký tham gia</span>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/events" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Hủy
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> ${empty event ? 'Tạo sự kiện' : 'Cập nhật'}
                    </button>
                </div>
            </form>
        </div>
<script>
function previewSelectedImage(selectElement, previewId) {
    const preview = document.getElementById(previewId);
    const fileName = selectElement.value;
    
    preview.innerHTML = "";
    
    if (fileName) {
        const img = document.createElement("img");
        img.src = "${pageContext.request.contextPath}/assets/images/events/" + fileName;
        img.style.maxWidth = "100%";
        img.style.maxHeight = "200px";
        img.style.borderRadius = "8px";
        img.style.objectFit = "cover";
        preview.appendChild(img);
    }
}
</script>

        <script src="${pageContext.request.contextPath}/js/admin/event-form.js"></script>
    </body>
</html>