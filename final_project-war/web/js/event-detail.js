/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
// ===== USER EVENT DETAIL JAVASCRIPT =====

// Get context path
function getContextPath() {
    const path = window.location.pathname;
    return path.substring(0, path.indexOf("/", 2));
}

function registerEvent(eventId) {
    if (!confirm('Bạn có chắc muốn đăng ký tham gia sự kiện này?')) {
        return;
    }

    showLoading();

    fetch(`${getContextPath()}/event-register?eventId=${eventId}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        credentials: 'include'
    })
    .then(response => {
        hideLoading();
        
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
            showNotification(data.message, 'success');
            setTimeout(() => {
                window.location.reload();
            }, 2000);
        } else {
            showNotification(data.message, 'error');
        }
    })
    .catch(error => {
        hideLoading();
        showNotification(error.message, 'error');
    });
}

// Share on Facebook
function shareOnFacebook() {
    const url = encodeURIComponent(window.location.href);
    const title = encodeURIComponent(document.querySelector('.event-name').textContent);
    
    window.open(
        `https://www.facebook.com/sharer/sharer.php?u=${url}&quote=${title}`,
        'facebook-share',
        'width=600,height=400'
    );
}

// Share on Twitter
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

// Copy link to clipboard
function copyLink() {
    const url = window.location.href;
    
    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(url)
            .then(() => {
                showNotification('Đã sao chép link vào clipboard!', 'success');
            })
            .catch(err => {
                fallbackCopyLink(url);
            });
    } else {
        fallbackCopyLink(url);
    }
}

// Fallback copy method for older browsers
function fallbackCopyLink(url) {
    const textarea = document.createElement('textarea');
    textarea.value = url;
    textarea.style.position = 'fixed';
    textarea.style.opacity = '0';
    document.body.appendChild(textarea);
    textarea.select();
    
    try {
        document.execCommand('copy');
        showNotification('Đã sao chép link vào clipboard!', 'success');
    } catch (err) {
        showNotification('Không thể sao chép link. Vui lòng copy thủ công.', 'error');
    }
    
    document.body.removeChild(textarea);
}

// Show loading overlay
function showLoading() {
    const overlay = document.createElement('div');
    overlay.id = 'loading-overlay';
    overlay.innerHTML = `
        <div class="loading-spinner">
            <i class="fas fa-circle-notch fa-spin"></i>
            <p>Đang xử lý...</p>
        </div>
    `;
    overlay.style.cssText = `
        position: fixed;
        inset: 0;
        background: rgba(0,0,0,0.7);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 9999;
        animation: fadeIn 0.3s ease;
    `;
    
    const spinner = overlay.querySelector('.loading-spinner');
    spinner.style.cssText = `
        text-align: center;
        color: white;
    `;
    spinner.querySelector('i').style.fontSize = '48px';
    spinner.querySelector('p').style.cssText = 'margin-top: 20px; font-size: 16px;';
    
    document.body.appendChild(overlay);
}

// Hide loading overlay
function hideLoading() {
    const overlay = document.getElementById('loading-overlay');
    if (overlay) {
        overlay.style.animation = 'fadeOut 0.3s ease';
        setTimeout(() => overlay.remove(), 300);
    }
}

// Show notification
function showNotification(message, type = 'info') {
    // Remove existing notifications
    const existing = document.querySelector('.notification');
    if (existing) existing.remove();
    
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    
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
        background: white;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.3);
        z-index: 10000;
        display: flex;
        align-items: center;
        gap: 10px;
        min-width: 300px;
        animation: slideInRight 0.3s ease;
    `;
    
    // Color based on type
    const colors = {
        success: '#27ae60',
        error: '#e74c3c',
        warning: '#f39c12',
        info: '#3498db'
    };
    
    notification.style.borderLeft = `4px solid ${colors[type] || colors.info}`;
    notification.querySelector('i').style.color = colors[type] || colors.info;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'slideOutRight 0.3s ease';
        setTimeout(() => notification.remove(), 300);
    }, 4000);
}

// Add Google Maps integration (if address available)
document.addEventListener('DOMContentLoaded', function() {
    const addressElement = document.querySelector('.detail-item [class*="address"]');
    
    if (addressElement) {
        const address = addressElement.textContent.trim();
        
        if (address) {
            const mapButton = document.createElement('a');
            mapButton.href = `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(address)}`;
            mapButton.target = '_blank';
            mapButton.className = 'map-link';
            mapButton.innerHTML = '<i class="fas fa-map-marked-alt"></i> Xem trên bản đồ';
            mapButton.style.cssText = `
                display: inline-flex;
                align-items: center;
                gap: 8px;
                margin-top: 10px;
                padding: 8px 16px;
                background: #667eea;
                color: white;
                text-decoration: none;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 600;
                transition: all 0.3s ease;
            `;
            
            mapButton.addEventListener('mouseenter', function() {
                this.style.background = '#764ba2';
            });
            
            mapButton.addEventListener('mouseleave', function() {
                this.style.background = '#667eea';
            });
            
            addressElement.parentElement.appendChild(mapButton);
        }
    }
});

// Event countdown timer
document.addEventListener('DOMContentLoaded', function() {
    const eventDateElement = document.querySelector('[data-event-date]');
    
    if (eventDateElement) {
        const eventDate = new Date(eventDateElement.dataset.eventDate).getTime();
        const countdownContainer = document.createElement('div');
        countdownContainer.className = 'event-countdown';
        countdownContainer.style.cssText = `
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            margin: 20px 0;
        `;
        
        const updateCountdown = () => {
            const now = new Date().getTime();
            const distance = eventDate - now;
            
            if (distance < 0) {
                countdownContainer.innerHTML = '<h3>Sự kiện đã diễn ra</h3>';
                return;
            }
            
            const days = Math.floor(distance / (1000 * 60 * 60 * 24));
            const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((distance % (1000 * 60)) / 1000);
            
            countdownContainer.innerHTML = `
                <div style="font-size: 14px; margin-bottom: 10px; opacity: 0.9;">Sự kiện bắt đầu sau</div>
                <div style="display: flex; justify-content: center; gap: 15px; font-size: 24px; font-weight: 700;">
                    <div><span>${days}</span><br><small style="font-size: 12px; opacity: 0.8;">Ngày</small></div>
                    <div><span>${hours}</span><br><small style="font-size: 12px; opacity: 0.8;">Giờ</small></div>
                    <div><span>${minutes}</span><br><small style="font-size: 12px; opacity: 0.8;">Phút</small></div>
                    <div><span>${seconds}</span><br><small style="font-size: 12px; opacity: 0.8;">Giây</small></div>
                </div>
            `;
        };
        
        // Insert countdown after event header
        const eventHeader = document.querySelector('.event-header');
        if (eventHeader) {
            eventHeader.after(countdownContainer);
            updateCountdown();
            setInterval(updateCountdown, 1000);
        }
    }
});

// Sticky sidebar behavior
document.addEventListener('DOMContentLoaded', function() {
    const sidebar = document.querySelector('.event-sidebar');
    const content = document.querySelector('.event-content-left');
    
    if (sidebar && content) {
        window.addEventListener('scroll', function() {
            const contentBottom = content.offsetTop + content.offsetHeight;
            const sidebarHeight = sidebar.offsetHeight;
            const scrollTop = window.pageYOffset;
            
            if (scrollTop + sidebarHeight + 100 > contentBottom) {
                sidebar.style.position = 'absolute';
                sidebar.style.top = `${contentBottom - sidebarHeight}px`;
            } else {
                sidebar.style.position = 'sticky';
                sidebar.style.top = '20px';
            }
        });
    }
});

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }
    
    @keyframes fadeOut {
        from { opacity: 1; }
        to { opacity: 0; }
    }
    
    @keyframes slideInRight {
        from {
            transform: translateX(400px);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOutRight {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(400px);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);

console.log('✅ Event detail scripts loaded successfully!');

