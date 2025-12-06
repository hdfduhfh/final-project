/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
// File: final_project-war/Web Pages/js/login-user.js

// Auto focus vào input email khi load trang
window.addEventListener('DOMContentLoaded', () => {
const emailInput = document.getElementById('email');
if (emailInput) {
emailInput.focus();
}

```
// Xóa thông báo sau 5 giây
setTimeout(() => {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        alert.style.transition = 'opacity 0.5s';
        alert.style.opacity = '0';
        setTimeout(() => alert.remove(), 500);
    });
}, 5000);
```;
});
