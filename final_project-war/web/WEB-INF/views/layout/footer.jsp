<%-- 
    Document   : footer
    Created on : Dec 5, 2025, 2:40:14 PM
    Author     : DANG KHOA
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="site-footer">
    <div class="footer-content">
        <div class="footer-section about">
            <div class="footer-logo">
                <img src="${pageContext.request.contextPath}/assets/images/logo.jpg"
                     alt="BookingStage Logo"
                     class="footer-logo-img"
                     onerror="this.style.display='none';">
                <span class="footer-brand">BookingStage</span>
            </div>
            <p style="line-height: 1.6;">Rạp hát nghệ thuật hàng đầu Việt Nam. Mang đến trải nghiệm văn hóa nghệ thuật đỉnh cao cho khán giả trong nước và quốc tế.</p>
            <div class="social-icons mt-3">
                <a href="#" class="social-link"><i class="fab fa-facebook-f"></i></a>
                <a href="#" class="social-link"><i class="fab fa-instagram"></i></a>
                <a href="#" class="social-link"><i class="fab fa-youtube"></i></a>
                <a href="#" class="social-link"><i class="fab fa-tiktok"></i></a>
            </div>
        </div>

        <div class="footer-section">
            <h3 class="footer-heading">LIÊN KẾT NHANH</h3>
            <ul class="footer-links list-unstyled">
                <li><a href="${pageContext.request.contextPath}/about">Về chúng tôi</a></li>
                <li><a href="${pageContext.request.contextPath}/shows">Chương trình</a></li>
                <li><a href="${pageContext.request.contextPath}/schedule">Lịch diễn</a></li>
                <li><a href="${pageContext.request.contextPath}/news">Tin tức & Sự kiện</a></li>
                <li><a href="${pageContext.request.contextPath}/contact">Liên hệ</a></li>
            </ul>
        </div>

        <div class="footer-section">
            <h3 class="footer-heading">HỖ TRỢ KHÁCH HÀNG</h3>
            <ul class="footer-links list-unstyled">
                <li><a href="${pageContext.request.contextPath}/pages/guide.jsp">Hướng dẫn đặt vé</a></li>
                <li><a href="${pageContext.request.contextPath}/pages/policy.jsp">Chính sách đổi/trả vé</a></li>
                <li><a href="${pageContext.request.contextPath}/pages/faq.jsp">Câu hỏi thường gặp</a></li>
                <li><a href="${pageContext.request.contextPath}/pages/terms.jsp">Điều khoản sử dụng</a></li>
                <li><a href="${pageContext.request.contextPath}/pages/privacy.jsp">Chính sách bảo mật</a></li>
            </ul>
        </div>

        <div class="footer-section">
            <h3 class="footer-heading">LIÊN HỆ</h3>
            <div class="contact-list">
                <a href="https://maps.google.com" target="_blank" class="contact-item">
                    <span class="contact-icon"><i class="fas fa-map-marker-alt"></i></span>
                    <span class="text-content">123 Đường Văn Hóa, Quận 1<br>TP. Hồ Chí Minh, Việt Nam</span>
                </a>

                <a href="tel:1900xxxx" class="contact-item">
                    <span class="contact-icon"><i class="fas fa-phone-alt"></i></span>
                    <span class="text-content">Hotline: 1900-xxxx</span>
                </a>

                <a href="mailto:support@bookingstage.vn" class="contact-item">
                    <span class="contact-icon"><i class="fas fa-envelope"></i></span>
                    <span class="text-content">support@bookingstage.vn</span>
                </a>

                <div class="contact-item">
                    <span class="contact-icon"><i class="far fa-clock"></i></span>
                    <span class="text-content">8:00 - 22:00 hàng ngày</span>
                </div>
            </div>
        </div>
    </div>

    <div class="footer-bottom">
        <span>&copy; 2025 BookingStage. All rights reserved. Made with &hearts; in Vietnam</span>
    </div>
</footer>