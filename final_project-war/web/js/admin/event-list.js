/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


// ===== ADMIN EVENT LIST JAVASCRIPT =====

// Xác nhận xóa event
function confirmDelete(eventId, eventName) {
    if (confirm(`Bạn có chắc muốn xóa sự kiện "${eventName}"?\n\nHành động này không thể hoàn tác!`)) {
        window.location.href = `${getContextPath()}/admin/events?action=delete&id=${eventId}`;
    }
}

// Lấy context path
function getContextPath() {
    return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
}

// Auto hide alerts sau 5 giây
document.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.transition = 'opacity 0.5s ease';
            alert.style.opacity = '0';
            setTimeout(() => alert.remove(), 500);
        }, 5000);
    });
});

// Search box - Submit khi nhấn Enter
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.querySelector('.search-box input');
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                this.closest('form').submit();
            }
        });
    }
});

// Highlight active filter
document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    const status = urlParams.get('status');
    const type = urlParams.get('type');
    
    if (status) {
        document.querySelector(`select[name="status"] option[value="${status}"]`)?.setAttribute('selected', 'selected');
    }
    if (type) {
        document.querySelector(`select[name="type"] option[value="${type}"]`)?.setAttribute('selected', 'selected');
    }
});