<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vé của tôi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 1000px; margin: 0 auto; }
        h1 { color: #667eea; margin-bottom: 20px; }
        
        .order-card { background: white; border-radius: 12px; padding: 20px; margin-bottom: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .ticket-item { background: #f8f9fa; padding: 15px; border-radius: 10px; margin-bottom: 10px; border-left: 4px solid #667eea; }
        
        .status-badge { padding: 5px 15px; border-radius: 20px; font-weight: bold; font-size: 0.9em; display: inline-block;}
        .status-confirmed { background: #d4edda; color: #155724; }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
        .status-request { background: #cce5ff; color: #004085; }

        .btn-cancel {
            background-color: #ff4d4d; color: white; border: none; padding: 6px 12px;
            border-radius: 20px; cursor: pointer; margin-left: 10px; font-size: 0.9em; transition: 0.3s;
        }
        .btn-cancel:hover { background-color: #cc0000; }

        /* --- MODAL --- */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; }
        .modal-hidden { display: none !important; }
        
        .modal-content {
            background-color: #fff; padding: 25px; border-radius: 12px; width: 500px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3); position: relative;
        }
        
        .close { position: absolute; top: 15px; right: 20px; font-size: 24px; cursor: pointer; color: #aaa; }
        
        /* CSS cho bảng tính tiền trong Modal */
        .calc-box { background: #f8f9fa; padding: 15px; border-radius: 8px; margin-bottom: 15px; border: 1px solid #eee; }
        .calc-row { display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.95em; }
        .calc-row.total { border-top: 1px solid #ddd; padding-top: 8px; font-weight: bold; font-size: 1.1em; color: #2d3436; }
        .calc-row.discount { color: #27ae60; }
        .calc-row.fee { color: #d63031; }
        .calc-row.refund { color: #0984e3; font-size: 1.2em; font-weight: bold; margin-top: 5px; }

        .policy-note { font-size: 0.85em; color: #666; font-style: italic; margin-top: 10px; }
        
        textarea { width: 100%; height: 80px; margin: 10px 0; padding: 10px; border-radius: 5px; border: 1px solid #ddd; box-sizing: border-box;}
        .btn-confirm { background: #667eea; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; width: 100%; margin-top: 10px; }
        .btn-confirm:disabled { background: #ccc; cursor: not-allowed; }
    </style>
</head>
<body>
    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <h1>🎫 Vé của tôi</h1>
            <a href="${pageContext.request.contextPath}/" style="text-decoration: none; color: #667eea;">← Về trang chủ</a>
        </div>

        <c:choose>
            <c:when test="${empty orders}">
                <div style="text-align: center; padding: 40px;">
                    <h3>Bạn chưa đặt vé nào.</h3>
                    <a href="${pageContext.request.contextPath}/seats/layout" style="color: white; background: #667eea; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Đặt vé ngay</a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="order" items="${orders}">
                    
                    <c:set var="originalTotal" value="0" />
                    <c:forEach var="detail" items="${order.orderDetailCollection}">
                        <c:set var="originalTotal" value="${originalTotal + detail.price}" />
                    </c:forEach>
                    
                    <c:set var="firstDetail" value="${order.orderDetailCollection[0]}" />

                    <div class="order-card">
                        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 15px;">
                            <div>
                                <strong>Đơn hàng #${order.orderID}</strong> 
                                <span style="color: #777; font-size: 0.9em;">
                                    (<fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>)
                                </span>
                            </div>
                            
                            <div>
                                <c:choose>
                                    <c:when test="${order.status == 'CANCELLED'}">
                                        <span class="status-badge status-cancelled">🚫 Đã hủy</span>
                                    </c:when>
                                    <c:when test="${order.cancellationRequested}">
                                        <span class="status-badge status-request">⏳ Đang chờ duyệt</span>
                                    </c:when>
                                    <c:when test="${order.status == 'CONFIRMED'}">
                                        <span class="status-badge status-confirmed">✓ Đã thanh toán</span>
                                        
                                        <button class="btn-cancel" 
                                                onclick="openCancelModal(
                                                    ${order.orderID}, 
                                                    ${firstDetail.scheduleID.showTime.time}, 
                                                    ${originalTotal}, 
                                                    ${order.finalAmount}
                                                )">
                                            <i class="fa-solid fa-ban"></i> Yêu cầu hủy
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-pending">⏳ Chờ xử lý</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <c:forEach var="detail" items="${order.orderDetailCollection}">
                            <div class="ticket-item">
                                <div style="display: flex; justify-content: space-between;">
                                    <div>
                                        <strong>Phim: ${detail.scheduleID.showID.showName}</strong><br/>
                                        <small><i class="fa-regular fa-clock"></i> <fmt:formatDate value="${detail.scheduleID.showTime}" pattern="HH:mm dd/MM/yyyy"/></small>
                                    </div>
                                    <div style="text-align: right;">
                                        Ghế: <strong>${detail.seatID.seatNumber}</strong> 
                                        <c:if test="${detail.seatID.seatType == 'VIP'}"><span style="color:gold">★VIP</span></c:if>
                                        <br/>
                                        <span style="color: #666; font-size: 0.9em;">Giá vé: <fmt:formatNumber value="${detail.price}" type="number" maxFractionDigits="0"/> đ</span>
                                    </div>
                                </div>
                                <c:forEach var="ticket" items="${detail.ticketCollection}">
                                    <c:if test="${not empty ticket.QRCode}">
                                        <div style="margin-top: 10px; font-size: 0.85em; color: #555;">
                                            <i class="fa-solid fa-qrcode"></i> QR: ${ticket.QRCode}
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:forEach>
                        
                        <div style="text-align: right; margin-top: 10px;">
                            <c:if test="${originalTotal > order.finalAmount}">
                                <span style="text-decoration: line-through; color: #999; margin-right: 10px;">
                                    <fmt:formatNumber value="${originalTotal}" type="number" maxFractionDigits="0"/> đ
                                </span>
                            </c:if>
                            Thực trả: <strong style="font-size: 1.2em; color: #d63031;"><fmt:formatNumber value="${order.finalAmount}" type="number" maxFractionDigits="0"/> đ</strong>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <div id="cancelModal" class="modal modal-hidden">
        <div class="modal-content">
            <span class="close" onclick="closeCancelModal()">&times;</span>
            <h3 style="margin-top: 0; color: #d63031;">⚠️ Yêu cầu hủy vé</h3>
            
            <div id="modalBody">
                </div>

            <form id="cancelForm" action="${pageContext.request.contextPath}/user/tickets" method="post" style="display:none;">
                <input type="hidden" name="action" value="requestCancel">
                <input type="hidden" name="orderId" id="modalOrderId">
                <label style="font-weight: bold;">Lý do hủy:</label>
                <textarea name="reason" placeholder="Nhập lý do hủy vé..." required></textarea>
                <button type="submit" class="btn-confirm">Xác nhận Hủy & Chịu phí</button>
            </form>
        </div>
    </div>
<script>
    // Định dạng tiền tệ kiểu Việt Nam (thay thế cho hàm JS cũ)
    function formatVND(num) {
        return num.toLocaleString('vi-VN', {style : 'currency', currency : 'VND'});
    }

    function openCancelModal(orderId, showTimeMillis, originalTotal, finalPaid) {
        var modal = document.getElementById('cancelModal');
        var modalBody = document.getElementById('modalBody');
        var cancelForm = document.getElementById('cancelForm');
        var orderInput = document.getElementById('modalOrderId');

        // Gán ID vào input hidden
        orderInput.value = orderId;

        // Tính thời gian
        var now = new Date().getTime();
        var diffHours = (showTimeMillis - now) / (1000 * 60 * 60);
        
        if (diffHours < 24) {
            // TRƯỜNG HỢP: QUÁ HẠN HỦY
            modalBody.innerHTML = 
                '<div style="background:#f8d7da; color:#721c24; padding:15px; border-radius:5px; text-align:center;">' +
                    '<strong>🚫 KHÔNG THỂ HỦY VÉ</strong><br>' +
                    'Suất chiếu sẽ diễn ra trong vòng ' + Math.floor(diffHours) + ' giờ tới.<br>' +
                    '(Quy định: Chỉ được hủy trước 24h).' +
                '</div>';
            cancelForm.style.display = 'none';
        } else {
            // TRƯỜNG HỢP: ĐƯỢC HỦY
            var voucherDiscount = originalTotal - finalPaid; 
            var refundAmount = finalPaid * 0.7; // Hoàn 70%
            var feeAmount = finalPaid * 0.3;    // Phí 30%

            var html = '<div class="calc-box">';
            
            // Dòng 1: Giá gốc
            html += '<div class="calc-row"><span>Tổng giá vé niêm yết:</span> <span>' + formatVND(originalTotal) + '</span></div>';
            
            // Dòng 2: Voucher (Nếu có)
            if (voucherDiscount > 0) {
                html += '<div class="calc-row discount"><span>Voucher/Giảm giá:</span> <span>-' + formatVND(voucherDiscount) + '</span></div>';
            }

            // Dòng 3: Thực trả
            html += '<div class="calc-row total"><span>Số tiền bạn thực trả:</span> <span>' + formatVND(finalPaid) + '</span></div>';
            
            html += '<hr style="margin: 10px 0; border: 0; border-top: 1px dashed #ccc;">';
            
            // Dòng 4: Phí hủy
            html += '<div class="calc-row fee"><span>Phí hủy vé (30%):</span> <span>-' + formatVND(feeAmount) + '</span></div>';
            
            // Dòng 5: Cảnh báo Voucher
            if (voucherDiscount > 0) {
                 html += '<div class="calc-row" style="color:#666; font-size:0.85em;"><i>(Lưu ý: Không hoàn lại giá trị Voucher)</i></div>';
            }

            // Dòng 6: Tiền nhận về
            html += '<div class="calc-row refund"><span>💰 TIỀN HOÀN LẠI:</span> <span>' + formatVND(refundAmount) + '</span></div>';
            html += '</div>';
            
            html += '<p class="policy-note">Tiền sẽ được hoàn về ví/tài khoản thanh toán trong 3-7 ngày làm việc.</p>';

            modalBody.innerHTML = html;
            cancelForm.style.display = 'block';
        }

        // Hiện modal (Xóa class ẩn)
        modal.classList.remove('modal-hidden');
    }

    function closeCancelModal() {
        document.getElementById('cancelModal').classList.add('modal-hidden');
    }

    // Đóng khi click ra ngoài
    window.onclick = function(event) {
        var modal = document.getElementById('cancelModal');
        if (event.target == modal) {
            closeCancelModal();
        }
    }
</script>
</body>
</html>