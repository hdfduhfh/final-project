/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
// ===== MY-TICKET.JS =====
// Vị trí: js/my-ticket.js

// ===== PAGINATION =====
const itemsPerPage = 5;
const tickets = Array.from(document.querySelectorAll('.ticket-card'));
const paginationContainer = document.getElementById('pagination');
const totalPages = Math.ceil(tickets.length / itemsPerPage);
let currentPage = 1;

function showPage(page) {
    currentPage = page;
    const start = (page - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    tickets.forEach((ticket, index) => {
        if (index >= start && index < end) {
            ticket.classList.add('visible');
            ticket.style.display = 'block';
        } else {
            ticket.classList.remove('visible');
            ticket.style.display = 'none';
        }
    });
    renderPagination();
}

function renderPagination() {
    paginationContainer.innerHTML = '';
    if (totalPages <= 1) return;
    for (let i = 1; i <= totalPages; i++) {
        const btn = document.createElement('button');
        btn.innerText = i;
        btn.className = 'page-btn ' + (i === currentPage ? 'active' : '');
        btn.onclick = function () { showPage(i); };
        paginationContainer.appendChild(btn);
    }
}

if (tickets.length > 0) showPage(1);

// ===== HELPER FUNCTIONS =====
function formatVND(num) {
    return num.toLocaleString('vi-VN', {style: 'currency', currency: 'VND'});
}

// ===== VIEW TICKET MODAL =====
let countdownInterval;

function startCountdown(showTimeString) {
    if (countdownInterval) clearInterval(countdownInterval);
    const showTime = new Date(showTimeString).getTime();
    const timerElement = document.getElementById('tktCountdown');
    const boxElement = document.querySelector('.countdown-box');

    countdownInterval = setInterval(function() {
        const now = new Date().getTime();
        const distance = showTime - now;
        
        if (distance < 0) {
            clearInterval(countdownInterval);
            timerElement.innerHTML = "ĐANG CHIẾU / ĐÃ KẾT THÚC";
            timerElement.style.color = "#888";
            boxElement.style.background = "#eee"; 
            boxElement.style.borderColor = "#ddd"; 
            boxElement.style.color = "#555";
            return;
        }
        
        const days = Math.floor(distance / (1000 * 60 * 60 * 24));
        const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((distance % (1000 * 60)) / 1000);
        
        let display = "";
        if (days > 0) display += days + "d ";
        display += hours + "h " + minutes + "m " + seconds + "s";
        timerElement.innerHTML = display;
    }, 1000);
}

function openViewTicketModal(showName, date, time, seats, count, qrUrl, showTimeISO) {
    document.getElementById('tktShowName').innerText = showName;
    document.getElementById('tktDate').innerText = date;
    document.getElementById('tktTime').innerText = time;
    document.getElementById('tktSeats').innerText = seats;
    document.getElementById('tktCount').innerText = count;
    document.getElementById('tktQrImage').src = qrUrl;
    startCountdown(showTimeISO);
    document.getElementById('viewTicketModal').style.display = 'flex';
}

function closeViewTicketModal() {
    document.getElementById('viewTicketModal').style.display = 'none';
    if (countdownInterval) clearInterval(countdownInterval);
}

// ===== CANCEL MODAL =====
function openCancelModal(orderId, showTimeMillis, originalTotal, finalPaid) {
    const modal = document.getElementById('cancelModal');
    const modalBody = document.getElementById('modalBody');
    const cancelForm = document.getElementById('cancelForm');
    
    document.getElementById('modalOrderId').value = orderId;
    
    const now = new Date().getTime();
    const diffHours = (showTimeMillis - now) / (1000 * 60 * 60);
    
    if (diffHours < 24) {
        modalBody.innerHTML = '<div style="background:rgba(231,76,60,0.15); padding:20px; border-radius:8px; text-align:center; color:#ff6b6b; border: 1px solid rgba(231,76,60,0.3);">' +
            '<i class="fa-solid fa-circle-exclamation" style="font-size: 2em; margin-bottom: 10px;"></i><br>' +
            '<strong>Không thể hủy vé</strong><br>' +
            '<span style="font-size:0.9em; opacity:0.8;">Suất chiếu sẽ diễn ra trong vòng 24h tới.</span>' +
            '</div>';
        cancelForm.style.display = 'none';
    } else {
        const refund = finalPaid * 0.7;
        const fee = finalPaid * 0.3;
        
        let html = '<div class="calc-box">';
        html += '<div class="calc-row"><span>Đã thanh toán:</span> <span>' + formatVND(finalPaid) + '</span></div>';
        html += '<div class="calc-row" style="color:#e74c3c;"><span>Phí hủy (30%):</span> <span>-' + formatVND(fee) + '</span></div>';
        html += '<div class="calc-row refund"><span>HOÀN LẠI:</span> <span>' + formatVND(refund) + '</span></div>';
        html += '</div>';
        html += '<p style="font-size:0.85em; color:#888; font-style: italic;">*Tiền hoàn sẽ được gửi về ví/tài khoản trong 3-7 ngày làm việc.</p>';
        
        modalBody.innerHTML = html;
        cancelForm.style.display = 'block';
    }
    
    modal.style.display = 'flex';
}

function closeCancelModal() { 
    document.getElementById('cancelModal').style.display = 'none'; 
}

// ===== FEEDBACK MODAL =====
let selectedRating = 5;

function openFeedbackModal(scheduleId, showName) {
    document.getElementById('feedbackScheduleId').value = scheduleId;
    document.getElementById('feedbackShowName').innerText = showName;
    document.getElementById('feedbackModal').style.display = 'flex';
    
    // Reset form
    document.getElementById('feedbackForm').reset();
    document.getElementById('feedbackRating').value = '5';
    document.getElementById('feedbackMessage').style.display = 'none';
    updateStarRating(5);
}

function closeFeedbackModal() {
    document.getElementById('feedbackModal').style.display = 'none';
}

// Star rating handlers
document.addEventListener('DOMContentLoaded', function() {
    const starRatingContainer = document.querySelector('.star-rating');
    
    if (starRatingContainer) {
        document.querySelectorAll('.star-rating i').forEach(star => {
            star.addEventListener('click', function() {
                selectedRating = parseInt(this.getAttribute('data-rating'));
                document.getElementById('feedbackRating').value = selectedRating;
                updateStarRating(selectedRating);
            });
            
            star.addEventListener('mouseenter', function() {
                const hoverRating = parseInt(this.getAttribute('data-rating'));
                updateStarRating(hoverRating, true);
            });
        });

        starRatingContainer.addEventListener('mouseleave', function() {
            updateStarRating(selectedRating);
        });
    }
});

function updateStarRating(rating, isHover = false) {
    const stars = document.querySelectorAll('.star-rating i');
    const ratingText = document.getElementById('ratingText');
    
    const texts = {
        1: 'Rất tệ',
        2: 'Tệ', 
        3: 'Bình thường',
        4: 'Tốt',
        5: 'Xuất sắc!'
    };
    
    stars.forEach((star, index) => {
        if (index < rating) {
            star.classList.add('active');
        } else {
            star.classList.remove('active');
        }
    });
    
    if (!isHover && ratingText) {
        ratingText.innerText = texts[rating] || 'Chọn đánh giá';
    }
}

// Submit feedback form
document.addEventListener('DOMContentLoaded', function() {
    const feedbackForm = document.getElementById('feedbackForm');
    
    if (feedbackForm) {
        feedbackForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const btn = document.querySelector('.btn-submit-feedback');
            const messageDiv = document.getElementById('feedbackMessage');
            
            btn.disabled = true;
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang gửi...';
            
            const formData = new FormData(this);
            const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
            
            fetch(contextPath + '/feedback', {
                method: 'POST',
                body: new URLSearchParams(formData)
            })
            .then(response => response.json())
            .then(data => {
                btn.disabled = false;
                btn.innerHTML = '<i class="fa-solid fa-paper-plane"></i> Gửi đánh giá';
                
                messageDiv.style.display = 'block';
                
                if (data.success) {
                    messageDiv.style.background = 'rgba(46, 204, 113, 0.2)';
                    messageDiv.style.border = '1px solid #2ecc71';
                    messageDiv.style.color = '#2ecc71';
                    messageDiv.innerHTML = '<i class="fa-solid fa-check-circle"></i> ' + data.message;
                    
                    setTimeout(() => {
                        closeFeedbackModal();
                        location.reload();
                    }, 2000);
                } else {
                    messageDiv.style.background = 'rgba(231, 76, 60, 0.2)';
                    messageDiv.style.border = '1px solid #e74c3c';
                    messageDiv.style.color = '#e74c3c';
                    messageDiv.innerHTML = '<i class="fa-solid fa-times-circle"></i> ' + data.message;
                }
            })
            .catch(error => {
                btn.disabled = false;
                btn.innerHTML = '<i class="fa-solid fa-paper-plane"></i> Gửi đánh giá';
                
                messageDiv.style.display = 'block';
                messageDiv.style.background = 'rgba(231, 76, 60, 0.2)';
                messageDiv.style.border = '1px solid #e74c3c';
                messageDiv.style.color = '#e74c3c';
                messageDiv.innerHTML = '<i class="fa-solid fa-times-circle"></i> Lỗi kết nối!';
            });
        });
    }
});

// ===== GLOBAL EVENT LISTENERS =====
window.addEventListener('click', function(e) {
    if (e.target === document.getElementById('cancelModal')) {
        closeCancelModal();
    }
    if (e.target === document.getElementById('viewTicketModal')) {
        closeViewTicketModal();
    }
    if (e.target === document.getElementById('feedbackModal')) {
        closeFeedbackModal();
    }
});

// Initialize star rating on page load
document.addEventListener('DOMContentLoaded', function() {
    updateStarRating(5);
});

