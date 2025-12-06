<%-- 
    Document   : login
    Created on : Dec 5, 2025, 2:39:23 PM
    Author     : DANG KHOA
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - BookingStage</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body>
        <%@ include file="/WEB-INF/views/includes/header.jsp" %>

        ```
        <div class="login-page">
            <div class="login-box">
                <div class="login-header">
                    <div class="login-logo">🎭</div>
                    <h1 class="login-title">Đăng nhập</h1>
                    <p class="login-subtitle">Chào mừng bạn trở lại BookingStage</p>
                </div>

                <!-- Hiển thị thông báo lỗi nếu có -->
                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        ⚠️ ${error}
                    </div>
                </c:if>

                <!-- Hiển thị thông báo thành công nếu có -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        ✓ ${success}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="POST">
                    <div class="form-group">
                        <label class="form-label" for="email">Email</label>
                        <input 
                            type="email" 
                            id="email" 
                            name="email" 
                            class="form-input" 
                            placeholder="example@email.com"
                            value="${param.email}"
                            required
                            >
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="password">Mật khẩu</label>
                        <input 
                            type="password" 
                            id="password" 
                            name="password" 
                            class="form-input" 
                            placeholder="••••••••"
                            required
                            >
                    </div>

                    <div class="form-options">
                        <label class="remember-me">
                            <input type="checkbox" name="remember" value="true">
                            <span>Ghi nhớ đăng nhập</span>
                        </label>
                        <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-password">
                            Quên mật khẩu?
                        </a>
                    </div>

                    <button type="submit" class="btn-login">
                        Đăng nhập ngay
                    </button>
                </form>

                <div class="divider">
                    <span>hoặc</span>
                </div>

                <div class="register-link">
                    Chưa có tài khoản? 
                    <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
                </div>

                <div class="back-home">
                    <a href="${pageContext.request.contextPath}/index.jsp">← Quay về trang chủ</a>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/includes/footer.jsp" %>
        <script src="${pageContext.request.contextPath}/js/login-user.js"></script>
        ```

    </body>
</html>
