// ===== LUXURY EVENT DETAIL JAVASCRIPT =====

// Get context path
function getContextPath() {
    const path = window.location.pathname;
    return path.substring(0, path.indexOf("/", 2));
}

// ===== ĐĂNG KÝ SỰ KIỆN (Có check login) =====
function registerEvent(eventId) {
    // Kiểm tra đã đăng nhập chưa
    const isLoggedIn = document.querySelector('.user-greeting') !== null;
    
    if (!isLoggedIn) {
        // Chưa đăng nhập → Mở modal login
        showLuxuryNotification(
            'Vui lòng đăng nhập để đăng ký sự kiện này!', 
            'warning'
        );
        
        // Delay 500ms rồi mở modal (cho người dùng kịp đọc thông báo)
        setTimeout(() => {
            if (typeof openLoginModal === 'function') {
                openLoginModal();
            } else {
                // Fallback nếu function không tồn tại
                const loginBtn = document.getElementById('loginBtn');
                if (loginBtn) loginBtn.click();
            }
        }, 500);
        
        return;
    }

    // Đã đăng nhập → Tiếp tục đăng ký
    if (!confirm('Bạn có chắc muốn đăng ký tham gia sự kiện này?')) {
        return;
    }

    showLuxuryLoading();

    fetch(`${getContextPath()}/event-register?eventId=${eventId}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        credentials: 'include'
    })
    .then(response => {
        hideLuxuryLoading();
        
        if (response.ok) {
            return response.json();
        } else if (response.status === 401) {
            throw new Error('Vui lòng đăng nhập để đăng ký sự kiện');
        } else {
            return response.json().then(data => {
                throw new Error(data.message || 'Có lỗi xảy ra');
            });
        }
    })
    .then(data => {
        if (data.success) {
            showLuxuryNotification(data.message, 'success');
            setTimeout(() => {
                window.location.reload();
            }, 2000);
        } else {
            showLuxuryNotification(data.message, 'error');
        }
    })
    .catch(error => {
        hideLuxuryLoading();
        showLuxuryNotification(error.message, 'error');
    });
}

// ===== SHARE FUNCTIONS =====
function shareOnFacebook() {
    const url = encodeURIComponent(window.location.href);
    const title = encodeURIComponent(document.querySelector('.event-name').textContent);
    
    window.open(
        `https://www.facebook.com/sharer/sharer.php?u=${url}&quote=${title}`,
        'facebook-share',
        'width=600,height=400'
    );
}

function shareOnTwitter() {
    const url = encodeURIComponent(window.location.href);
    const title = encodeURIComponent(document.querySelector('.event-name').textContent);
    const hashtags = 'BookingStage,SuKien';
    
    window.open(
        `https://twitter.com/intent/tweet?url=${url}&text=${title}&hashtags=${hashtags}`,
        'twitter-share',
        'width=600,height=400'
    );
}

function copyLink() {
    const url = window.location.href;
    
    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(url)
            .then(() => {
                showLuxuryNotification('Đã sao chép link vào clipboard!', 'success');
            })
            .catch(err => {
                fallbackCopyLink(url);
            });
    } else {
        fallbackCopyLink(url);
    }
}

function fallbackCopyLink(url) {
    const textarea = document.createElement('textarea');
    textarea.value = url;
    textarea.style.position = 'fixed';
    textarea.style.opacity = '0';
    document.body.appendChild(textarea);
    textarea.select();
    
    try {
        document.execCommand('copy');
        showLuxuryNotification('Đã sao chép link vào clipboard!', 'success');
    } catch (err) {
        showLuxuryNotification('Không thể sao chép link. Vui lòng copy thủ công.', 'error');
    }
    
    document.body.removeChild(textarea);
}

// ===== LUXURY LOADING OVERLAY =====
function showLuxuryLoading() {
    const overlay = document.createElement('div');
    overlay.id = 'luxury-loading-overlay';
    overlay.innerHTML = `
        <div class="luxury-loading-spinner">
            <div class="spinner-circle"></div>
            <p>Đang xử lý...</p>
        </div>
    `;
    overlay.style.cssText = `
        position: fixed;
        inset: 0;
        background: rgba(0,0,0,0.85);
        backdrop-filter: blur(10px);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 9999;
        animation: luxuryFadeIn 0.3s ease;
    `;
    
    const spinner = overlay.querySelector('.luxury-loading-spinner');
    spinner.style.cssText = `
        text-align: center;
        color: #d4af37;
    `;
    
    // Spinner circle CSS
    const spinnerCircle = overlay.querySelector('.spinner-circle');
    spinnerCircle.style.cssText = `
        width: 60px;
        height: 60px;
        border: 4px solid rgba(212, 175, 55, 0.2);
        border-top: 4px solid #d4af37;
        border-radius: 50%;
        margin: 0 auto 20px;
        animation: luxurySpin 1s linear infinite;
        box-shadow: 0 0 20px rgba(212, 175, 55, 0.3);
    `;
    
    spinner.querySelector('p').style.cssText = `
        margin-top: 20px; 
        font-size: 16px;
        font-family: 'Playfair Display', serif;
        letter-spacing: 1px;
    `;
    
    document.body.appendChild(overlay);
}

function hideLuxuryLoading() {
    const overlay = document.getElementById('luxury-loading-overlay');
    if (overlay) {
        overlay.style.animation = 'luxuryFadeOut 0.3s ease';
        setTimeout(() => overlay.remove(), 300);
    }
}

// ===== LUXURY NOTIFICATION =====
function showLuxuryNotification(message, type = 'info') {
    const existing = document.querySelector('.luxury-notification');
    if (existing) existing.remove();
    
    const notification = document.createElement('div');
    notification.className = `luxury-notification luxury-notification-${type}`;
    
    const icons = {
        success: 'check-circle',
        error: 'times-circle',
        warning: 'exclamation-triangle',
        info: 'info-circle'
    };
    
    notification.innerHTML = `
        <i class="fas fa-${icons[type] || 'info-circle'}"></i>
        <span>${message}</span>
    `;
    
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: rgba(10, 10, 12, 0.95);
        backdrop-filter: blur(15px);
        padding: 18px 24px;
        border-radius: 12px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.8);
        z-index: 10000;
        display: flex;
        align-items: center;
        gap: 12px;
        min-width: 320px;
        max-width: 400px;
        animation: luxurySlideInRight 0.4s ease;
        border: 1px solid ${getNotificationBorderColor(type)};
        font-family: 'Playfair Display', serif;
        font-size: 15px;
    `;
    
    notification.querySelector('i').style.cssText = `
        color: ${getNotificationColor(type)};
        font-size: 20px;
        filter: drop-shadow(0 0 10px ${getNotificationColor(type)});
    `;
    
    notification.querySelector('span').style.color = '#fff';
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'luxurySlideOutRight 0.4s ease';
        setTimeout(() => notification.remove(), 400);
    }, 4000);
}

function getNotificationColor(type) {
    const colors = {
        success: '#27ae60',
        error: '#e74c3c',
        warning: '#d4af37',
        info: '#3498db'
    };
    return colors[type] || colors.info;
}

function getNotificationBorderColor(type) {
    const colors = {
        success: 'rgba(39, 174, 96, 0.3)',
        error: 'rgba(231, 76, 60, 0.3)',
        warning: 'rgba(212, 175, 55, 0.3)',
        info: 'rgba(52, 152, 219, 0.3)'
    };
    return colors[type] || colors.info;
}

// ===== GOOGLE MAPS INTEGRATION =====
document.addEventListener('DOMContentLoaded', function() {
    const addressElements = document.querySelectorAll('.detail-subtext');
    
    addressElements.forEach(addressElement => {
        const address = addressElement.textContent.trim();
        
        if (address && address.length > 10) {
            const mapButton = document.createElement('a');
            mapButton.href = `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(address)}`;
            mapButton.target = '_blank';
            mapButton.className = 'luxury-map-link';
            mapButton.innerHTML = '<i class="fas fa-map-marked-alt"></i> Xem trên bản đồ';
            mapButton.style.cssText = `
                display: inline-flex;
                align-items: center;
                gap: 8px;
                margin-top: 10px;
                padding: 8px 16px;
                background: linear-gradient(135deg, #ffd700, #b38728);
                color: #000;
                text-decoration: none;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 700;
                transition: all 0.3s ease;
                font-family: 'Playfair Display', serif;
            `;
            
            mapButton.addEventListener('mouseenter', function() {
                this.style.boxShadow = '0 0 20px rgba(212, 175, 55, 0.5)';
                this.style.transform = 'scale(1.05)';
            });
            
            mapButton.addEventListener('mouseleave', function() {
                this.style.boxShadow = 'none';
                this.style.transform = 'scale(1)';
            });
            
            addressElement.parentElement.appendChild(mapButton);
        }
    });
});

// ===== CSS ANIMATIONS =====
const style = document.createElement('style');
style.textContent = `
    @keyframes luxuryFadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }
    
    @keyframes luxuryFadeOut {
        from { opacity: 1; }
        to { opacity: 0; }
    }
    
    @keyframes luxurySlideInRight {
        from {
            transform: translateX(400px);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes luxurySlideOutRight {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(400px);
            opacity: 0;
        }
    }
    
    @keyframes luxurySpin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }
    
    /* Custom scrollbar */
    ::-webkit-scrollbar {
        width: 10px;
    }
    
    ::-webkit-scrollbar-track {
        background: rgba(0, 0, 0, 0.5);
    }
    
    ::-webkit-scrollbar-thumb {
        background: linear-gradient(135deg, #ffd700, #b38728);
        border-radius: 5px;
    }
    
    ::-webkit-scrollbar-thumb:hover {
        background: linear-gradient(135deg, #b38728, #ffd700);
    }
`;
document.head.appendChild(style);

console.log('✅ Luxury Event Detail Scripts Loaded Successfully!');