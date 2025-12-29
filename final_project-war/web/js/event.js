/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
// ===== USER EVENT LIST JAVASCRIPT =====

// Initialize AOS (Animate On Scroll)
document.addEventListener('DOMContentLoaded', function() {
    if (typeof AOS !== 'undefined') {
        AOS.init({
            duration: 800,
            easing: 'ease-in-out',
            once: true,
            offset: 100
        });
    }
});

// Smooth scroll to sections
document.addEventListener('DOMContentLoaded', function() {
    const links = document.querySelectorAll('a[href^="#"]');
    
    links.forEach(link => {
        link.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            if (href !== '#' && document.querySelector(href)) {
                e.preventDefault();
                const target = document.querySelector(href);
                const offsetTop = target.offsetTop - 80;
                
                window.scrollTo({
                    top: offsetTop,
                    behavior: 'smooth'
                });
            }
        });
    });
});

// Search form enhancement
document.addEventListener('DOMContentLoaded', function() {
    const searchForm = document.querySelector('.hero-search form');
    const searchInput = document.querySelector('.hero-search input[name="keyword"]');
    
    if (searchForm && searchInput) {
        // Auto-focus search input
        searchInput.focus();
        
        // Prevent empty search
        searchForm.addEventListener('submit', function(e) {
            const keyword = searchInput.value.trim();
            if (!keyword) {
                e.preventDefault();
                searchInput.focus();
                showNotification('Vui lòng nhập từ khóa tìm kiếm', 'warning');
            }
        });
        
        // Clear search button
        const clearBtn = document.createElement('button');
        clearBtn.type = 'button';
        clearBtn.className = 'clear-search-btn';
        clearBtn.innerHTML = '<i class="fas fa-times"></i>';
        clearBtn.style.cssText = 'position:absolute;right:120px;top:50%;transform:translateY(-50%);background:none;border:none;color:#999;cursor:pointer;display:none;';
        
        searchInput.parentElement.appendChild(clearBtn);
        
        searchInput.addEventListener('input', function() {
            clearBtn.style.display = this.value ? 'block' : 'none';
        });
        
        clearBtn.addEventListener('click', function() {
            searchInput.value = '';
            this.style.display = 'none';
            searchInput.focus();
        });
    }
});

// Filter tabs active state
document.addEventListener('DOMContentLoaded', function() {
    const filterTabs = document.querySelectorAll('.filter-tab');
    const currentUrl = new URL(window.location.href);
    const typeParam = currentUrl.searchParams.get('type');
    
    filterTabs.forEach(tab => {
        const tabUrl = new URL(tab.href);
        const tabType = tabUrl.searchParams.get('type');
        
        if ((!typeParam && !tabType) || (typeParam === tabType)) {
            tab.classList.add('active');
        }
    });
});

// Card hover effects
document.addEventListener('DOMContentLoaded', function() {
    const eventCards = document.querySelectorAll('.event-card, .upcoming-card, .popular-card');
    
    eventCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-8px)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });
});

// Show notification
function showNotification(message, type = 'info') {
    // Remove existing notifications
    const existing = document.querySelector('.notification');
    if (existing) existing.remove();
    
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <i class="fas fa-${getNotificationIcon(type)}"></i>
        <span>${message}</span>
    `;
    
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: white;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.2);
        z-index: 9999;
        display: flex;
        align-items: center;
        gap: 10px;
        animation: slideInRight 0.3s ease;
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'slideOutRight 0.3s ease';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

function getNotificationIcon(type) {
    const icons = {
        success: 'check-circle',
        error: 'times-circle',
        warning: 'exclamation-triangle',
        info: 'info-circle'
    };
    return icons[type] || 'info-circle';
}

// Add animations CSS
const style = document.createElement('style');
style.textContent = `
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
    
    .notification-success {
        border-left: 4px solid #27ae60;
        color: #27ae60;
    }
    
    .notification-error {
        border-left: 4px solid #e74c3c;
        color: #e74c3c;
    }
    
    .notification-warning {
        border-left: 4px solid #f39c12;
        color: #f39c12;
    }
    
    .notification-info {
        border-left: 4px solid #3498db;
        color: #3498db;
    }
`;
document.head.appendChild(style);

// Lazy load images
document.addEventListener('DOMContentLoaded', function() {
    const images = document.querySelectorAll('img[data-src]');
    
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.src = img.dataset.src;
                img.removeAttribute('data-src');
                observer.unobserve(img);
            }
        });
    });
    
    images.forEach(img => imageObserver.observe(img));
});

// Back to top button
document.addEventListener('DOMContentLoaded', function() {
    const backToTopBtn = document.createElement('button');
    backToTopBtn.innerHTML = '<i class="fas fa-arrow-up"></i>';
    backToTopBtn.className = 'back-to-top';
    backToTopBtn.style.cssText = `
        position: fixed;
        bottom: 30px;
        right: 30px;
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        cursor: pointer;
        box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        opacity: 0;
        visibility: hidden;
        transition: all 0.3s ease;
        z-index: 1000;
    `;
    
    document.body.appendChild(backToTopBtn);
    
    window.addEventListener('scroll', function() {
        if (window.pageYOffset > 300) {
            backToTopBtn.style.opacity = '1';
            backToTopBtn.style.visibility = 'visible';
        } else {
            backToTopBtn.style.opacity = '0';
            backToTopBtn.style.visibility = 'hidden';
        }
    });
    
    backToTopBtn.addEventListener('click', function() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
});

// Event countdown timer (for upcoming events)
document.addEventListener('DOMContentLoaded', function() {
    const eventCards = document.querySelectorAll('[data-event-date]');
    
    eventCards.forEach(card => {
        const eventDate = new Date(card.dataset.eventDate).getTime();
        const countdownEl = card.querySelector('.countdown');
        
        if (countdownEl) {
            const updateCountdown = () => {
                const now = new Date().getTime();
                const distance = eventDate - now;
                
                if (distance < 0) {
                    countdownEl.textContent = 'Đã diễn ra';
                    return;
                }
                
                const days = Math.floor(distance / (1000 * 60 * 60 * 24));
                const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                
                countdownEl.textContent = `${days} ngày ${hours} giờ ${minutes} phút`;
            };
            
            updateCountdown();
            setInterval(updateCountdown, 60000); // Update every minute
        }
    });
});

// Print helper
window.printEvent = function(eventId) {
    window.print();
};

console.log('✅ Event list scripts loaded successfully!');

