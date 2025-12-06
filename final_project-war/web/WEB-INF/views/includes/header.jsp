<%-- 
    Document   : header
    Created on : Dec 5, 2025, 2:40:08 PM
    Author     : DANG KHOA
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header>
    <nav>
        <div class="logo">🎭 BookingStage</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a></li>
            <li><a href="${pageContext.request.contextPath}/shows">Chương trình</a></li>
            <li><a href="${pageContext.request.contextPath}/schedule">Lịch diễn</a></li>
            <li><a href="${pageContext.request.contextPath}/news">Tin tức</a></li>
            <li><a href="${pageContext.request.contextPath}/recruitment">Tuyển dụng</a></li>
        </ul>
        <div class="auth-buttons">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <span class="user-greeting">Xin chào, ${sessionScope.user.fullName}</span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-login">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-register">Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>
</header>