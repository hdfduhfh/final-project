function openLoginModal() {
    document.getElementById("authModal").style.display = "flex";
    document.getElementById("loginForm").style.display = "block";
    document.getElementById("registerForm").style.display = "none";
}

function openRegisterModal() {
    document.getElementById("authModal").style.display = "flex";
    document.getElementById("loginForm").style.display = "none";
    document.getElementById("registerForm").style.display = "block";
}
function closeAuthModal() {
    document.getElementById("authModal").style.display = "none";
    // reset form login và register
    document.getElementById("loginFormElement").reset();
    document.getElementById("registerFormElement").reset();
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
                    if (data.role === 'ADMIN')
                        window.location.href = `${window.location.origin}/final_project-war/admin/dashboard`;
                    else {
                        closeAuthModal();
                        location.reload();
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
