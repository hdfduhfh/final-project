function openLoginModal() {
    document.getElementById("authModal").style.display = "flex";
    document.getElementById("loginForm").style.display = "block";
    document.getElementById("registerForm").style.display = "none";

    // Reset form + lỗi + success
    const form = document.getElementById("loginFormElement");
    form.reset();
    document.getElementById('loginEmailError').textContent = '';
    document.getElementById('loginPasswordError').textContent = '';
}

function openRegisterModal() {
    document.getElementById("authModal").style.display = "flex";
    document.getElementById("loginForm").style.display = "none";
    document.getElementById("registerForm").style.display = "block";

    const form = document.getElementById("registerFormElement");
    form.reset();
    document.getElementById('registerFullNameError').textContent = '';
    document.getElementById('registerEmailError').textContent = '';
    document.getElementById('registerPasswordError').textContent = '';
    document.getElementById('registerSuccessMessage').textContent = '';
}
function closeAuthModal() {
    document.getElementById("authModal").style.display = "none";
    // reset form login và register
    document.getElementById("loginFormElement").reset();
    document.getElementById("registerFormElement").reset();
}
function openForgotPasswordModal() {
    document.getElementById('forgotPasswordModal').style.display = 'block';

    const form = document.getElementById("forgotPasswordForm");
    form.reset();
    document.getElementById('forgotEmailError').textContent = '';
    document.getElementById('forgotNewPasswordError').textContent = '';
    document.getElementById('forgotConfirmPasswordError').textContent = '';
    document.getElementById('forgotSuccessMessage').textContent = '';
}
function closeForgotPasswordModal() {
    document.getElementById('forgotPasswordModal').style.display = 'none';
}

// Login AJAX
document.getElementById('loginFormElement').addEventListener('submit', function (e) {
    e.preventDefault();

    let email = this.email.value.trim();
    let password = this.password.value.trim();

    document.getElementById('loginEmailError').textContent = '';
    document.getElementById('loginPasswordError').textContent = '';

    let valid = true;
    let emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!email) {
        document.getElementById('loginEmailError').textContent = 'Vui lòng nhập email!';
        valid = false;
    } else if (!emailPattern.test(email)) {
        document.getElementById('loginEmailError').textContent = 'Email không hợp lệ!';
        document.getElementById('loginFormElement').email.value = ""; // xoá email sai
        valid = false;
    }
    if (!password) {
        document.getElementById('loginPasswordError').textContent = 'Vui lòng nhập mật khẩu!';
        document.getElementById('loginFormElement').password.value = ""; // xoá mật khẩu trống
        valid = false;
    }
    if (!valid)
        return;

    fetch(ctx + "/login", {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `email=${encodeURIComponent(email)}&password=${encodeURIComponent(password)}`
    })
            .then(res => res.json())
            .then(data => {
                if (!data.success) {
                    document.getElementById('loginPasswordError').textContent = data.message;
                } else {
                    // ===== FIX Ở ĐÂY =====
                    if (data.role === 'ADMIN') {
                        window.location.href = `${window.location.origin}/final_project-war/admin/dashboard`;
                    } else {
                        closeAuthModal();

                        // 🔥 nếu server có redirectAfterLogin (vd: /checkout)
                        if (data.redirectUrl) {
                            window.location.href = data.redirectUrl;
                        } else {
                            location.reload();
                        }
                    }
                }
            })
            .catch(err => console.error(err));
});

// Register AJAX
document.getElementById('registerFormElement').addEventListener('submit', function (e) {
    e.preventDefault();

    let fullName = this.fullName.value.trim();
    let email = this.email.value.trim();
    let password = this.password.value.trim();

    document.getElementById('registerFullNameError').textContent = '';
    document.getElementById('registerEmailError').textContent = '';
    document.getElementById('registerPasswordError').textContent = '';

    let valid = true;
    let emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!fullName) {
        document.getElementById('registerFullNameError').textContent = 'Vui lòng nhập họ và tên!';
        valid = false;
    }
    if (!email) {
        document.getElementById('registerEmailError').textContent = 'Vui lòng nhập email!';
        valid = false;
    } else if (!emailPattern.test(email)) {
        document.getElementById('registerEmailError').textContent = 'Email không hợp lệ!';
        valid = false;
    }
    if (!password) {
        document.getElementById('registerPasswordError').textContent = 'Vui lòng nhập mật khẩu!';
        valid = false;
    }
    if (!valid)
        return;

    fetch(ctx + "/register", {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `fullName=${encodeURIComponent(fullName)}&email=${encodeURIComponent(email)}&password=${encodeURIComponent(password)}`
    })
            .then(res => res.json())
            .then(data => {
                if (!data.success) {
                    document.getElementById('registerPasswordError').textContent = data.message;
                } else {
                    // hiện thông báo thành công màu xanh lá
                    document.getElementById('registerSuccessMessage').textContent =
                            "Đăng ký thành công! Bạn có thể đăng nhập ngay.";

                    // reset form lỗi
                    document.getElementById('registerFullNameError').textContent = '';
                    document.getElementById('registerEmailError').textContent = '';
                    document.getElementById('registerPasswordError').textContent = '';
                }
            })
            .catch(err => console.error(err));
});
// Forgot pass
document.getElementById('forgotPasswordForm').addEventListener('submit', function (e) {
    e.preventDefault();

    // reset lỗi
    document.getElementById('forgotEmailError').textContent = '';
    document.getElementById('forgotNewPasswordError').textContent = '';
    document.getElementById('forgotConfirmPasswordError').textContent = '';
    document.getElementById('forgotSuccessMessage').textContent = '';

    const email = this.email.value.trim();
    const newPassword = this.newPassword.value.trim();
    const confirmPassword = this.confirmPassword.value.trim();
    let valid = true;

    // Kiểm tra local trước
    if (!email) {
        document.getElementById('forgotEmailError').textContent = 'Vui lòng nhập email!';
        valid = false;
    }
    if (!newPassword) {
        document.getElementById('forgotNewPasswordError').textContent = 'Vui lòng nhập mật khẩu mới!';
        valid = false;
    }
    if (!confirmPassword) {
        document.getElementById('forgotConfirmPasswordError').textContent = 'Vui lòng nhập lại mật khẩu!';
        valid = false;
    }

    if (!valid)
        return;

    // gửi AJAX
    fetch(ctx + "/reset-password", {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `email=${encodeURIComponent(email)}&newPassword=${encodeURIComponent(newPassword)}&confirmPassword=${encodeURIComponent(confirmPassword)}`
    })
            .then(res => res.json())
            .then(data => {
                if (!data.success) {
                    // kiểm tra message từ server
                    if (data.message.includes("Email")) {
                        document.getElementById('forgotEmailError').textContent = data.message;
                    } else if (data.message.includes("khớp")) {
                        document.getElementById('forgotConfirmPasswordError').textContent = data.message;
                    } else {
                        alert(data.message); // các lỗi khác
                    }
                } else {
                    document.getElementById('forgotSuccessMessage').textContent = data.message;
                    this.reset();
                }
            })
            .catch(err => console.error(err));
});
