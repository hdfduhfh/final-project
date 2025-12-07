window.openLoginModal = openLoginModal;
window.openRegisterModal = openRegisterModal;
window.closeAuthModal = closeAuthModal;
window.showLogin = showLogin;
window.showRegister = showRegister;

function openLoginModal() {
    const modal = document.getElementById("authModal");
    modal.style.display = "flex"; // Hiển thị modal
    showLogin();
}

function openRegisterModal() {
    const modal = document.getElementById("authModal");
    modal.style.display = "flex"; // Hiển thị modal
    showRegister();
}

function closeAuthModal() {
    const modal = document.getElementById("authModal");
    modal.style.display = "none"; // Ẩn modal
}

function showLogin() {
    document.getElementById("loginForm").style.display = "block";   // Hiển thị login
    document.getElementById("registerForm").style.display = "none"; // Ẩn register
}

function showRegister() {
    document.getElementById("loginForm").style.display = "none";    // Ẩn login
    document.getElementById("registerForm").style.display = "block";// Hiển thị register
}
