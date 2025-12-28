<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Vé của tôi | BookingStage</title>
    
    <!-- Fonts -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600&family=Playfair+Display:ital,wght@0,700;1,600&display=swap" rel="stylesheet">
    
    <!-- ✅ LINK CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/my-ticket.css">
</head>
<body>

    <div class="container">
        <div class="page-header">
            <h1>Vé Của Tôi</h1>
            <a href="${pageContext.request.contextPath}/" class="home-btn">
                <i class="fa-solid fa-arrow-left"></i> Trang Chủ
            </a>
        </div>

        <div class="ticket-list" id="ticketList">
            <c:choose>
                <c:when test="${empty orders}">
                    <div style="text-align: center; padding: 80px 20px; color: #777;">
                        <i class="fa-solid fa-film" style="font-size: 4em; margin-bottom: 25px; opacity: 0.3; color: var(--gold-primary);"></i>
                        <h3 style="font-family: 'Playfair Display'; color: #ccc;">Bạn chưa có vé nào</h3>
                        <a href="${pageContext.request.contextPath}/" style="display: inline-block; padding: 12px 30px; background: var(--gold-gradient); color: #000; text-decoration: none; border-radius: 50px; font-weight: bold; margin-top: 20px;">Đặt vé ngay</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <jsp:useBean id="now" class="java.util.Date" />

                    <c:forEach var="order" items="${orders}">
                        <c:set var="firstDetail" value="${order.orderDetailCollection[0]}" />
                        
                        <c:set var="originalTotal" value="0" />
                        <c:forEach var="detail" items="${order.orderDetailCollection}">
                            <c:set var="originalTotal" value="${originalTotal + detail.price}" />
                        </c:forEach>

                        <c:set var="showTimeMillis" value="${firstDetail.scheduleID.showTime.time}" />
                        <c:set var="nowMillis" value="${now.time}" />
                        <c:set var="diffMinutes" value="${(showTimeMillis - nowMillis) / (1000 * 60)}" />

                        <c:set var="seatListString" value="" />
                        <c:set var="hasBrokenSeat" value="false" />
                        
                        <c:forEach var="detail" items="${order.orderDetailCollection}" varStatus="loop">
                            <c:set var="seatListString" value="${seatListString}${detail.seatID.seatNumber}${!loop.last ? ', ' : ''}" />
                            <c:if test="${!detail.seatID.isActive}">
                                <c:set var="hasBrokenSeat" value="true" />
                            </c:if>
                        </c:forEach>

                        <c:set var="qrDate">
                            <fmt:formatDate value="${firstDetail.scheduleID.showTime}" pattern="dd/MM/yyyy HH:mm"/>
                        </c:set>
                        <c:set var="isoShowTime">
                            <fmt:formatDate value="${firstDetail.scheduleID.showTime}" pattern="yyyy-MM-dd'T'HH:mm:ss"/>
                        </c:set>

                        <c:set var="rawQrString" value="#${firstDetail.scheduleID.scheduleID}TICKET-${order.orderID}-${firstDetail.orderDetailID} ${firstDetail.scheduleID.showID.showName} ${qrDate} ${firstDetail.seatID.seatNumber} ${sessionScope.user.fullName} VALID" />
                        
                        <c:url value="https://api.qrserver.com/v1/create-qr-code/" var="encodedQrUrl">
                            <c:param name="size" value="160x160"/>
                            <c:param name="charset-source" value="UTF-8"/>
                            <c:param name="data" value="${rawQrString}"/>
                        </c:url>

                        <div class="ticket-card">
                            <div class="ticket-accent"></div>
                            <div class="ticket-content">
                                <div class="ticket-info">
                                    <c:if test="${order.status == 'CONFIRMED'}">
                                        <c:if test="${diffMinutes <= 0 && diffMinutes > -120}">
                                            <div class="badge-live" style="background: #2ecc71; color: white; padding: 4px 10px; border-radius: 4px; font-size: 0.8em; font-weight: bold; display: inline-block; margin-bottom: 5px;">
                                                <i class="fa-solid fa-video"></i> Đang chiếu
                                            </div>
                                        </c:if>
                                    </c:if>

                                    <h3>${firstDetail.scheduleID.showID.showName}</h3>

                                    <div class="meta-row">
                                        <span class="meta-item">
                                            <i class="fa-regular fa-clock"></i> 
                                            <fmt:formatDate value="${firstDetail.scheduleID.showTime}" pattern="HH:mm dd/MM/yyyy"/>
                                        </span>
                                        <span class="meta-item">
                                            <i class="fa-solid fa-chair"></i> ${seatListString}
                                        </span>
                                        <span class="meta-item">
                                            <i class="fa-solid fa-hashtag"></i> #${order.orderID}
                                        </span>
                                    </div>

                                    <c:if test="${hasBrokenSeat}">
                                        <div class="seat-warning">
                                            <i class="fa-solid fa-triangle-exclamation"></i> 
                                            <strong>Cảnh báo:</strong> Đơn hàng này có ghế đang bảo trì/hỏng.
                                            <div class="warning-text">
                                                Vui lòng liên hệ nhân viên tại quầy để được hỗ trợ đổi ghế mới.
                                            </div>
                                        </div>
                                    </c:if>
                                </div>

<div class="ticket-actions">
    <!-- ✅ HIỂN THỊ GIÁ THEO TRẠNG THÁI -->
    <c:choose>
        <c:when test="${order.status == 'CANCELLED' && order.refundAmount != null && order.refundAmount > 0}">
            <!-- Vé đã hủy → Hiện tiền hoàn -->
            <div class="price-tag" style="color: #2ecc71;">
                <i class="fa-solid fa-money-bill-wave"></i>
                <fmt:formatNumber value="${order.refundAmount}" type="number" maxFractionDigits="0"/> đ
            </div>
            <small style="color: #2ecc71; font-size: 0.75rem; margin-top: -5px;">
                Tiền hoàn
            </small>
        </c:when>
        <c:otherwise>
            <!-- Vé bình thường → Hiện giá gốc -->
            <div class="price-tag">
                <fmt:formatNumber value="${order.finalAmount}" type="number" maxFractionDigits="0"/> đ
            </div>
        </c:otherwise>
    </c:choose>
    
    <c:choose>
        <c:when test="${order.status == 'CANCELLED'}">
            <span class="status-badge st-cancel">Đã hủy</span>
        </c:when>
        <c:when test="${order.cancellationRequested}">
            <span class="status-badge st-pending">Chờ hủy</span>
        </c:when>
        <c:when test="${order.status == 'CONFIRMED'}">
            <button class="btn-view-ticket" 
                    onclick="openViewTicketModal(
                        '${firstDetail.scheduleID.showID.showName}',
                        '<fmt:formatDate value="${firstDetail.scheduleID.showTime}" pattern="dd/MM/yyyy"/>',
                        '<fmt:formatDate value="${firstDetail.scheduleID.showTime}" pattern="HH:mm"/>',
                        '${seatListString}',
                        '${order.orderDetailCollection.size()}',
                        '${encodedQrUrl}',
                        '${isoShowTime}'
                    )">
                <i class="fa-solid fa-ticket"></i> Xem vé
            </button>
        </c:when>
        <c:otherwise>
            <span class="status-badge st-pending">Chờ xử lý</span>
        </c:otherwise>
    </c:choose>

    <!-- ✅ CÁC NÚT THAO TÁC -->
    <c:if test="${order.status == 'CONFIRMED'}">
        <!-- Nút Hủy vé -->
<button class="btn-action btn-cancel-req" 
        onclick="openCancelModal(
            ${order.orderID}, 
            ${showTimeMillis}, 
            ${originalTotal}, 
            ${order.finalAmount},
            ${order.discountAmount != null ? order.discountAmount : 0}
        )">
    Hủy
</button>
        
        <!-- ✅ NÚT ĐÁNH GIÁ - Chỉ hiện SAU KHI XEM XONG -->
        <c:if test="${diffMinutes < 0}">
            <button class="btn-action btn-feedback" 
                    onclick="openFeedbackModal(${firstDetail.scheduleID.scheduleID}, '${firstDetail.scheduleID.showID.showName}')">
                <i class="fa-solid fa-star"></i> Đánh giá
            </button>
        </c:if>
    </c:if>
</div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <div id="pagination" class="pagination"></div>
    </div>

    <!-- ===== VIEW TICKET MODAL ===== -->
    <div id="viewTicketModal" class="modal">
        <div style="position: relative;">
            <div class="close-ticket" onclick="closeViewTicketModal()">&times;</div>
            <div class="ticket-visual">
                <div class="ticket-top">
                    <div class="movie-title" id="tktShowName">TÊN PHIM</div>
                    <div class="cinema-name">BOOKING STAGE CINEMA</div>
                </div>
                <div class="ticket-body">
                    <div style="color: #555; font-size: 13px; margin-bottom: 10px; font-style: italic;">
                        Quét mã này tại quầy soát vé
                    </div>
                    <div class="qr-placeholder">
                        <img id="tktQrImage" src="" alt="QR Ticket">
                    </div>
                    <div class="seat-info">
                        <div class="seat-box">
                            <div>NGÀY</div>
                            <div id="tktDate">--/--</div>
                        </div>
                        <div class="seat-box">
                            <div>GIỜ</div>
                            <div id="tktTime">--:--</div>
                        </div>
                        <div class="seat-box">
                            <div>SỐ VÉ</div>
                            <div id="tktCount">0</div>
                        </div>
                    </div>
                    <div style="margin-top: 15px; font-size: 14px; font-weight: 600; color: #333;">
                        Ghế: <span id="tktSeats" style="color: #000;"></span>
                    </div>
                    <div class="countdown-box">
                        <div>Sắp tới giờ chiếu!</div>
                        <div id="tktCountdown" class="countdown-timer">--:--:--</div>
                    </div>
                    <div style="margin-top: 10px; font-size: 11px; color: #aaa;">
                        Vui lòng đến trước giờ chiếu 15 phút.
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== CANCEL MODAL ===== -->
    <div id="cancelModal" class="modal">
        <div class="cancel-content">
            <span onclick="closeCancelModal()" style="position:absolute; right:20px; top:15px; cursor:pointer; font-size:24px; color: #777;">&times;</span>
            <h3 style="color: #ff6b6b; margin-top:0; font-family: 'Playfair Display';">
                ⚠️ Yêu cầu hủy vé
            </h3>
            <div id="modalBody"></div>
            <form id="cancelForm" action="${pageContext.request.contextPath}/my-tickets" method="post" style="display:none;">
                <input type="hidden" name="action" value="requestCancel">
                <input type="hidden" name="orderId" id="modalOrderId">
                <p style="margin-bottom:8px; color: #ccc;">Lý do hủy:</p>
                <textarea name="reason" placeholder="Nhập lý do..." required></textarea>
                <button type="submit" class="btn-confirm">Xác nhận</button>
            </form>
        </div>
    </div>

    <!-- ===== FEEDBACK MODAL ===== -->
    <div id="feedbackModal" class="modal">
        <div class="feedback-content">
            <span onclick="closeFeedbackModal()" style="position:absolute; right:20px; top:15px; cursor:pointer; font-size:24px; color: #777;">&times;</span>
            
            <div style="text-align: center; margin-bottom: 25px;">
                <i class="fa-solid fa-star" style="font-size: 3em; color: var(--gold-primary); margin-bottom: 10px;"></i>
                <h3 style="color: #fff; margin: 0; font-family: 'Playfair Display'; font-size: 1.8rem;">
                    Đánh giá suất chiếu
                </h3>
                <p style="color: #888; font-size: 0.9rem; margin-top: 5px;" id="feedbackShowName"></p>
            </div>
            
            <form id="feedbackForm">
                <input type="hidden" id="feedbackScheduleId" name="scheduleId">
                
                <!-- Rating Stars -->
                <div style="text-align: center; margin-bottom: 25px;">
                    <div class="star-rating">
                        <i class="fa-solid fa-star" data-rating="1"></i>
                        <i class="fa-solid fa-star" data-rating="2"></i>
                        <i class="fa-solid fa-star" data-rating="3"></i>
                        <i class="fa-solid fa-star" data-rating="4"></i>
                        <i class="fa-solid fa-star" data-rating="5"></i>
                    </div>
                    <input type="hidden" id="feedbackRating" name="rating" value="5">
                    <p style="color: var(--gold-primary); margin-top: 10px; font-size: 0.9rem;" id="ratingText">
                        Xuất sắc!
                    </p>
                </div>
                
                <!-- Comment -->
                <div style="margin-bottom: 20px;">
                    <label style="color: #ccc; display: block; margin-bottom: 8px; font-size: 0.9rem;">
                        Chia sẻ trải nghiệm của bạn:
                    </label>
                    <textarea 
                        name="comment" 
                        id="feedbackComment"
                        placeholder="Bạn cảm thấy thế nào về suất chiếu này?..."
                        style="width: 100%; background: #111; border: 1px solid #444; color: white; padding: 12px; border-radius: 8px; min-height: 100px; font-family: inherit; resize: vertical;"
                        maxlength="500"
                    ></textarea>
                    <small style="color: #666; font-size: 0.8rem;">Tối đa 500 ký tự</small>
                </div>
                
                <button type="submit" class="btn-submit-feedback">
                    <i class="fa-solid fa-paper-plane"></i> Gửi đánh giá
                </button>
            </form>
            
            <div id="feedbackMessage" style="display: none; margin-top: 15px; padding: 12px; border-radius: 6px; text-align: center; font-size: 0.9rem;"></div>
        </div>
    </div>

    <!-- ✅ LINK JAVASCRIPT -->
    <script src="${pageContext.request.contextPath}/js/my-ticket.js"></script>
</body>
</html>