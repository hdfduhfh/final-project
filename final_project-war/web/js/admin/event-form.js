/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

// ===== ADMIN EVENT FORM JAVASCRIPT =====

// Preview ảnh khi upload
function previewImage(input, previewId) {
    const preview = document.getElementById(previewId);
    
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        
        reader.onload = function(e) {
            preview.innerHTML = `<img src="${e.target.result}" alt="Preview" />`;
        };
        
        reader.readAsDataURL(input.files[0]);
    } else {
        preview.innerHTML = '';
    }
}

// Validate form trước khi submit
function validateForm() {
    const eventName = document.querySelector('input[name="eventName"]').value.trim();
    const eventType = document.querySelector('select[name="eventType"]').value;
    const eventDate = document.querySelector('input[name="eventDate"]').value;
    const venue = document.querySelector('input[name="venue"]').value.trim();
    const maxAttendees = parseInt(document.querySelector('input[name="maxAttendees"]').value);
    const price = parseFloat(document.querySelector('input[name="price"]').value);

    // Validate tên sự kiện
    if (!eventName || eventName.length < 5) {
        alert('Tên sự kiện phải có ít nhất 5 ký tự!');
        return false;
    }

    // Validate loại sự kiện
    if (!eventType) {
        alert('Vui lòng chọn loại sự kiện!');
        return false;
    }

    // Validate ngày diễn ra
    if (!eventDate) {
        alert('Vui lòng chọn ngày diễn ra!');
        return false;
    }

    // Kiểm tra ngày diễn ra không được trong quá khứ
    const selectedDate = new Date(eventDate);
    const now = new Date();
    if (selectedDate < now) {
        const confirm = window.confirm('Ngày diễn ra đã qua. Bạn có chắc muốn tiếp tục?');
        if (!confirm) return false;
    }

    // Validate địa điểm
    if (!venue) {
        alert('Vui lòng nhập địa điểm tổ chức!');
        return false;
    }

    // Validate số người tham gia
    if (isNaN(maxAttendees) || maxAttendees < 1) {
        alert('Số người tham gia tối đa phải lớn hơn 0!');
        return false;
    }

    // Validate giá vé
    if (isNaN(price) || price < 0) {
        alert('Giá vé không hợp lệ!');
        return false;
    }

    // Kiểm tra ngày kết thúc
    const endDate = document.querySelector('input[name="endDate"]').value;
    if (endDate) {
        const endDateTime = new Date(endDate);
        if (endDateTime <= selectedDate) {
            alert('Ngày kết thúc phải sau ngày bắt đầu!');
            return false;
        }
    }

    // Kiểm tra hạn chót đăng ký
    const regDeadline = document.querySelector('input[name="registrationDeadline"]').value;
    if (regDeadline) {
        const deadlineDate = new Date(regDeadline);
        if (deadlineDate >= selectedDate) {
            alert('Hạn chót đăng ký phải trước ngày diễn ra sự kiện!');
            return false;
        }
    }

    return true;
}

// Auto-set giá trị mặc định
document.addEventListener('DOMContentLoaded', function() {
    // Nếu là form thêm mới (không có eventId), set mặc định
    const isNewForm = !document.querySelector('input[name="eventId"]');
    
    if (isNewForm) {
        // Set ngày mặc định là 7 ngày sau
        const eventDateInput = document.querySelector('input[name="eventDate"]');
        if (eventDateInput && !eventDateInput.value) {
            const futureDate = new Date();
            futureDate.setDate(futureDate.getDate() + 7);
            eventDateInput.value = formatDateTime(futureDate);
        }

        // Set trạng thái mặc định là "Upcoming"
        const statusSelect = document.querySelector('select[name="status"]');
        if (statusSelect && !statusSelect.value) {
            statusSelect.value = 'Upcoming';
        }

        // Check mặc định "Cho phép đăng ký"
        const allowRegCheckbox = document.querySelector('input[name="allowRegistration"]');
        if (allowRegCheckbox && !allowRegCheckbox.hasAttribute('checked')) {
            allowRegCheckbox.checked = true;
        }
    }
});

// Format datetime cho input datetime-local
function formatDateTime(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day}T${hours}:${minutes}`;
}

// Auto-calculate endDate dựa trên eventDate (mặc định +2 giờ)
document.addEventListener('DOMContentLoaded', function() {
    const eventDateInput = document.querySelector('input[name="eventDate"]');
    const endDateInput = document.querySelector('input[name="endDate"]');
    
    if (eventDateInput && endDateInput) {
        eventDateInput.addEventListener('change', function() {
            if (this.value && !endDateInput.value) {
                const startDate = new Date(this.value);
                startDate.setHours(startDate.getHours() + 2); // +2 giờ
                endDateInput.value = formatDateTime(startDate);
            }
        });
    }
});

// Format số tiền khi nhập
document.addEventListener('DOMContentLoaded', function() {
    const priceInput = document.querySelector('input[name="price"]');
    
    if (priceInput) {
        priceInput.addEventListener('blur', function() {
            const value = parseFloat(this.value);
            if (!isNaN(value)) {
                this.value = Math.round(value);
            }
        });
    }
});

// Xác nhận trước khi rời trang nếu có thay đổi
let formChanged = false;

document.addEventListener('DOMContentLoaded', function() {
    const formInputs = document.querySelectorAll('.event-form input, .event-form select, .event-form textarea');
    
    formInputs.forEach(input => {
        input.addEventListener('change', function() {
            formChanged = true;
        });
    });

    window.addEventListener('beforeunload', function(e) {
        if (formChanged) {
            e.preventDefault();
            e.returnValue = '';
            return '';
        }
    });

    // Reset flag khi submit form
    document.querySelector('.event-form').addEventListener('submit', function() {
        formChanged = false;
    });
});
