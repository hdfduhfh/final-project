<%-- 
    Document   : header
    Created on : Dec 5, 2025, 2:40:08 PM
    Author     : DANG KHOA
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user.css">

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
                    <button id="loginBtn" onclick="openLoginModal()">Đăng nhập</button>
                    <button id="registerBtn" onclick="openRegisterModal()">Đăng ký</button>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>
</header>

<!-- Modal -->
<div id="authModal" class="modal" style="display:none;">
    <div class="modal-content">
        <span class="close" onclick="closeAuthModal()">&times;</span>

        <!-- Login Form -->
        <div id="loginForm">
            <h3>Đăng nhập</h3>
            <form id="loginFormElement">
                <input type="text" name="email" placeholder="Email" autocomplete="username">
                <span id="loginEmailError" style="color:red; font-size:13px;"></span>

                <input type="password" name="password" placeholder="Mật khẩu" autocomplete="current-password">
                <span id="loginPasswordError" style="color:red; font-size:13px;"></span>

                <button type="submit">Đăng nhập</button>
            </form>
            <div class="switch-link">
                <a href="#" onclick="showRegister(event)">Đăng ký</a>
            </div>
        </div>

        <!-- Register Form -->
        <div id="registerForm" style="display:none;">
            <h3>Đăng ký</h3>
            <form id="registerFormElement">
                <input type="text" name="fullName" placeholder="Họ và tên" autocomplete="name">
                <span id="registerFullNameError" style="color:red; font-size:13px;"></span>

                <input type="text" name="email" placeholder="Email" autocomplete="email">
                <span id="registerEmailError" style="color:red; font-size:13px;"></span>

                <input type="password" name="password" placeholder="Mật khẩu" autocomplete="new-password">
                <span id="registerPasswordError" style="color:red; font-size:13px;"></span>

                <button type="submit">Tạo tài khoản</button>
            </form>
            <div class="switch-link">
                <a href="#" onclick="showLogin(event)">Đăng nhập</a>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/auth.js"></script>
