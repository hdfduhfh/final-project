<%-- 
    Document   : header
    Created on : Dec 5, 2025, 2:40:08 PM
    Author     : DANG KHOA
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<header class="site-header">
    <div class="header-inner">
        <a href="${pageContext.request.contextPath}/" class="brand">
            <img src="${pageContext.request.contextPath}/assets/images/logo.png"
                 alt="BookingStage Logo"
                 class="brand-logo"
                 onerror="this.style.display='none'; this.nextElementSibling.style.display='inline';">
            <span class="brand-fallback" style="display:none;">🎭</span>
            <span class="brand-name">BookingStage</span>
        </a>

        <nav class="nav">
            <ul class="nav-list">
                <li class="nav-item"><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/shows">Chương trình</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/schedule">Lịch diễn</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/news">Tin tức</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/recruitment">Tuyển dụng</a></li>
            </ul>
        </nav>

        <div class="auth">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <span class="user-greeting">Xin chào, ${sessionScope.user.fullName}</span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-gold">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <button id="loginBtn" class="btn btn-gold" onclick="openLoginModal()">Đăng nhập</button>
                    <button id="registerBtn" class="btn btn-outline-gold" onclick="openRegisterModal()">Đăng ký</button>
                </c:otherwise>
            </c:choose>
        </div>

        <button class="hamburger" id="hamburger" aria-label="Mở menu">
            <span></span><span></span><span></span>
        </button>
    </div>
</header>

<!-- Auth modal -->
<div id="authModal" class="modal" style="display:none;">
    <div class="modal-content glass">
        <span class="close" onclick="closeAuthModal()" aria-label="Đóng">&times;</span>

        <!-- Login form -->
        <div id="loginForm">
            <h3 class="modal-title">🎭 Đăng nhập</h3>
            <form id="loginFormElement">
                <input type="text" name="email" placeholder="📧 Email" autocomplete="username">
                <span id="loginEmailError" class="field-error"></span>

                <input type="password" name="password" placeholder="🔒 Mật khẩu" autocomplete="current-password">
                <span id="loginPasswordError" class="field-error"></span>

                <button type="submit" class="btn btn-gold w-full">Đăng nhập</button>
            </form>
            <div class="switch-link">
                Chưa có tài khoản? <a href="#" onclick="openRegisterModal()">Đăng ký ngay</a>
            </div>
        </div>

        <!-- Register form -->
        <div id="registerForm" style="display:none;">
            <h3 class="modal-title">🎭 Đăng ký</h3>
            <form id="registerFormElement">
                <input type="text" name="fullName" placeholder="👤 Họ và tên" autocomplete="name">
                <span id="registerFullNameError" class="field-error"></span>

                <input type="text" name="email" placeholder="📧 Email" autocomplete="email">
                <span id="registerEmailError" class="field-error"></span>

                <input type="password" name="password" placeholder="🔒 Mật khẩu" autocomplete="new-password">
                <span id="registerPasswordError" class="field-error"></span>

                <span id="registerSuccessMessage" class="field-success"></span>

                <button type="submit" class="btn btn-gold w-full">Tạo tài khoản</button>
            </form>
            <div class="switch-link">
                Đã có tài khoản? <a href="#" onclick="openLoginModal()">Đăng nhập</a>
            </div>
        </div>
    </div>
</div>


<script>
  const ctx = "${pageContext.request.contextPath}";

  // Mobile menu toggle (optional expansion)
  const hamburger = document.getElementById('hamburger');
  const nav = document.querySelector('.nav');
  if (hamburger && nav) {
    hamburger.addEventListener('click', () => {
      const isOpen = nav.style.display === 'block';
      nav.style.display = isOpen ? 'none' : 'block';
    });
  }
</script>

<script src="${pageContext.request.contextPath}/js/auth.js"></script>
