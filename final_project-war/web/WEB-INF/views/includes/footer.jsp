<%-- 
    Document   : footer
    Created on : Dec 5, 2025, 2:40:14 PM
    Author     : DANG KHOA
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer>
    <div class="footer-content">
        <div class="footer-section">
            <h3>🎭 BookingStage</h3>
            <p style="color: #94a3b8;">Rạp hát nghệ thuật hàng đầu Việt Nam. Mang đến những trải nghiệm văn hóa nghệ thuật đỉnh cao.</p>
        </div>
        <div class="footer-section">
            <h3>Liên kết nhanh</h3>
            <a href="${pageContext.request.contextPath}/about">Về chúng tôi</a>
            <a href="${pageContext.request.contextPath}/shows">Chương trình</a>
            <a href="${pageContext.request.contextPath}/schedule">Lịch diễn</a>
            <a href="${pageContext.request.contextPath}/news">Tin tức</a>
            <a href="${pageContext.request.contextPath}/contact">Liên hệ</a>
        </div>
        <div class="footer-section">
            <h3>Hỗ trợ</h3>
            <a href="${pageContext.request.contextPath}/guide">Hướng dẫn đặt vé</a>
            <a href="${pageContext.request.contextPath}/policy">Chính sách đổi/trả</a>
            <a href="${pageContext.request.contextPath}/faq">Câu hỏi thường gặp</a>
            <a href="${pageContext.request.contextPath}/terms">Điều khoản sử dụng</a>
        </div>
        <div class="footer-section">
            <h3>Liên hệ</h3>
            <a href="#">📍 123 Đường Văn Hóa, Q.1, TP.HCM</a>
            <a href="tel:1900xxxx">📞 1900-xxxx</a>
            <a href="mailto:support@bookingstage.vn">✉️ support@bookingstage.vn</a>
            <a href="#">🕐 8:00 - 22:00 hàng ngày</a>
        </div>
    </div>
    <div class="footer-bottom">
        <p>© 2024 BookingStage. All rights reserved. Made with ❤️</p>
    </div>
</footer>
