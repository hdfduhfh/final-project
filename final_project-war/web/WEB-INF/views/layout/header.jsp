<%-- 
    Document   : header
    Created on : Dec 5, 2025, 2:40:08 PM
    Author     : DANG KHOA
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;1,400&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
<header class="site-header">
    
    <div class="header-inner">
        <a href="${pageContext.request.contextPath}/" class="brand">
            <img src="${pageContext.request.contextPath}/assets/images/logo.jpg"
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
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/showSchedule">
                        Lịch diễn
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/seats/layout">
                        Mua vé
                    </a>
                </li>
                <!-- ✅ THÊM MỚI: Link Sự kiện -->
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/events">
                        <i class="fas fa-calendar-star"></i> Sự kiện
                    </a>
                </li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/new">Tin tức</a></li>
                <li class="nav-item"><a href="${pageContext.request.contextPath}/job">Tuyển dụng</a></li>
                        <!-- ✅ THÊM LINK VÉ VÀO ĐÂY (CHỈ CHECK user, BỎ userOrders) -->
        <c:if test="${not empty sessionScope.user}">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/my-tickets">
                    🎫 
                </a>
            </li>
        </c:if>
            </ul>
        </nav>

        <div class="auth">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">

                    <a href="${pageContext.request.contextPath}/profile"
                       class="user-greeting">
                        <i class="fa-solid fa-user"></i>
                        ${sessionScope.user.fullName}
                    </a>

                    <a href="${pageContext.request.contextPath}/logout"
                       class="btn btn-outline-gold">Đăng xuất</a>
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

        <div id="loginForm">
            <h3 class="modal-title">🎭 Đăng nhập</h3>
            <form id="loginFormElement">
                <input type="text" name="email" placeholder="📧 Email" autocomplete="username">
                <span id="loginEmailError" class="field-error"></span>

                <div class="password-wrapper">
                    <input type="password" id="loginPass" name="password" placeholder="🔒 Mật khẩu" autocomplete="current-password">
                    <i class="fa-regular fa-eye toggle-icon"  style="color: #d4af37" onclick="togglePassword('loginPass', this)">️</i>
                </div>
                <span id="loginPasswordError" class="field-error"></span>

                <button type="submit" class="btn btn-gold w-full">Đăng nhập</button>
            </form>
            <div class="forgot-password">
                <a href="#" onclick="openForgotPasswordModal(); closeAuthModal()">Quên mật khẩu?</a>
            </div>


            <div class="switch-link">
                Chưa có tài khoản? <a href="#" onclick="openRegisterModal()">Đăng ký ngay</a>
            </div>
        </div>

        <div id="registerForm" style="display:none;">
            <h3 class="modal-title">🎭 Đăng ký</h3>
            <form id="registerFormElement">
                <input type="text" name="fullName" placeholder="👤 Họ và tên" autocomplete="name">
                <span id="registerFullNameError" class="field-error"></span>

                <input type="text" name="email" placeholder="📧 Email" autocomplete="email">
                <span id="registerEmailError" class="field-error"></span>

                <div class="password-wrapper">
                    <input type="password" id="regPass" name="password" placeholder="🔒 Mật khẩu" autocomplete="new-password">
                    <i class="fa-regular fa-eye toggle-icon" style="color: #d4af37;"onclick="togglePassword('regPass', this)">️</i>
                </div>
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
<!-- Forgot Password Modal -->
<div id="forgotPasswordModal" class="modal" style="display:none;">
    <div class="modal-content glass">
        <span class="close" onclick="closeForgotPasswordModal()" aria-label="Đóng">&times;</span>
        <h3 class="modal-title">🔑 Quên mật khẩu</h3>

        <form id="forgotPasswordForm">
            <input type="text" name="email" placeholder="📧 Nhập email của bạn">
            <span id="forgotEmailError" class="field-error"></span>

            <div class="password-wrapper">
                <input type="password" id="forgotNewPass" name="newPassword" placeholder="🔒 Mật khẩu mới" autocomplete="new-password">
                <i class="fa-regular fa-eye toggle-icon" style="color: #d4af37;" onclick="togglePassword('forgotNewPass', this)"></i>
            </div>
            <span id="forgotNewPasswordError" class="field-error"></span>


            <div class="password-wrapper">
                <input type="password" id="forgotConfirmPass" name="confirmPassword" placeholder="🔒 Nhập lại mật khẩu" autocomplete="new-password">
                <i class="fa-regular fa-eye toggle-icon" style="color: #d4af37;" onclick="togglePassword('forgotConfirmPass', this)"></i>
            </div>
            <span id="forgotConfirmPasswordError" class="field-error"></span>


            <!-- Thông báo thành công -->
            <span id="forgotSuccessMessage" class="field-success"></span>

            <button type="submit" class="btn btn-gold w-full">Gửi yêu cầu</button>
        </form>



        <div class="switch-link">
            Nhớ mật khẩu? 
            <a href="#" onclick="closeForgotPasswordModal(); openLoginModal(); return false;">Đăng nhập</a>
        </div>

    </div>
</div>


<script>
    const ctx = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>

<script src="${pageContext.request.contextPath}/js/auth.js"></script>