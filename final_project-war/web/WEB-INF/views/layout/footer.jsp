<%-- 
    Document   : footer
    Created on : Dec 5, 2025, 2:40:14 PM
    Author     : DANG KHOA
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="site-footer">
    <div class="footer-content">
        <!-- About -->
        <div class="footer-section about">
            <div class="footer-logo">
                <img src="${pageContext.request.contextPath}/assets/images/logo.png"
                     alt="BookingStage Logo"
                     class="footer-logo-img"
                     onerror="this.style.display='none';">
                <span class="footer-brand">BookingStage</span>
            </div>
            <p>Rạp hát nghệ thuật hàng đầu Việt Nam. Mang đến trải nghiệm văn hóa nghệ thuật đỉnh cao cho khán giả trong nước và quốc tế.</p>
            <div class="social-links">
                <a href="#" title="Facebook">📘</a>
                <a href="#" title="Instagram">📷</a>
                <a href="#" title="YouTube">▶️</a>
                <a href="#" title="Twitter">🐦</a>
            </div>
        </div>

        <!-- Quick Links -->
        <div class="footer-section">
            <h3>📌 Liên kết nhanh</h3>
            <a href="${pageContext.request.contextPath}/about">Về chúng tôi</a>
            <a href="${pageContext.request.contextPath}/shows">Chương trình</a>
            <a href="${pageContext.request.contextPath}/schedule">Lịch diễn</a>
            <a href="${pageContext.request.contextPath}/news">Tin tức & Sự kiện</a>
            <a href="${pageContext.request.contextPath}/contact">Liên hệ</a>
        </div>

        <!-- Support -->
        <div class="footer-section">
            <h3>💡 Hỗ trợ khách hàng</h3>
            <a href="${pageContext.request.contextPath}/pages/guide.jsp">Hướng dẫn đặt vé</a>
            <a href="${pageContext.request.contextPath}/pages/policy.jsp">Chính sách đổi/trả vé</a>
            <a href="${pageContext.request.contextPath}/pages/faq.jsp">Câu hỏi thường gặp</a>
            <a href="${pageContext.request.contextPath}/pages/terms.jsp">Điều khoản sử dụng</a>
            <a href="${pageContext.request.contextPath}/pages/privacy.jsp">Chính sách bảo mật</a>
        </div>


        <!-- Contact -->
        <div class="footer-section">
            <h3>📞 Liên hệ</h3>
            <a href="https://maps.google.com" target="_blank" class="contact-item">
                <span class="contact-icon">📍</span>
                <span>123 Đường Văn Hóa, Quận 1<br>TP. Hồ Chí Minh, Việt Nam</span>
            </a>
            <a href="tel:1900xxxx" class="contact-item">
                <span class="contact-icon">📞</span>
                <span>Hotline: 1900-xxxx</span>
            </a>
            <a href="mailto:support@bookingstage.vn" class="contact-item">
                <span class="contact-icon">✉️</span>
                <span>support@bookingstage.vn</span>
            </a>
            <a href="#" class="contact-item">
                <span class="contact-icon">🕐</span>
                <span>8:00 - 22:00 hàng ngày</span>
            </a>
        </div>
    </div>

    <div class="footer-bottom">
        <p>© 2025 BookingStage. All rights reserved. Made with <span style="color:#ef4444;">❤️</span> in Vietnam</p>
    </div>
</footer>
