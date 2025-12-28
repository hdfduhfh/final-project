/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
/**
 * PROMOTIONS LIST JAVASCRIPT
 * File: js/admin/promotions-list.js
 */

// ===== GLOBAL VARIABLES =====
let usageModal = null;
let deleteModal = null;

// ===== INIT =====
document.addEventListener('DOMContentLoaded', function() {
    // Initialize modals
    const usageModalEl = document.getElementById('usageModal');
    if (usageModalEl) {
        usageModal = new bootstrap.Modal(usageModalEl);
    }
    
    const deleteModalEl = document.getElementById('deletePromotionModal');
    if (deleteModalEl) {
        deleteModal = new bootstrap.Modal(deleteModalEl);
    }
    
    console.log('✅ Promotions List JS initialized');
});

// ===== DELETE PROMOTION MODAL =====
function openDeletePromotionModal(deleteUrl, code, name) {
    const codeEl = document.getElementById('delPromoCode');
    const nameEl = document.getElementById('delPromoName');
    const confirmBtn = document.getElementById('deletePromotionConfirmBtn');
    
    if (codeEl) codeEl.textContent = code || '';
    if (nameEl) nameEl.textContent = name || '';
    if (confirmBtn) confirmBtn.setAttribute('href', deleteUrl || '#');
    
    if (deleteModal) {
        deleteModal.show();
    }
}

// ===== USAGE MODAL =====
function openUsageModal(promotionId, code, name) {
    if (!usageModal) {
        console.error('❌ Usage modal not initialized');
        return;
    }
    
    // Reset UI
    document.getElementById('usagePromoCode').textContent = code;
    document.getElementById('usagePromoName').textContent = name;
    document.getElementById('usageLoading').classList.remove('d-none');
    document.getElementById('usageError').classList.add('d-none');
    document.getElementById('usageContent').classList.add('d-none');
    
    // Show modal
    usageModal.show();
    
    // Fetch data
    const url = window.APP_CONTEXT_PATH + '/admin/promotions?action=usage&id=' + promotionId;
    
    console.log('📡 Fetching usage data from:', url);
    
    fetch(url)
        .then(response => {
            console.log('📥 Response status:', response.status);
            if (!response.ok) {
                throw new Error('HTTP error! status: ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            console.log('✅ Data received:', data);
            displayUsageData(data);
        })
        .catch(error => {
            console.error('❌ Fetch error:', error);
            showUsageError('Không thể tải dữ liệu: ' + error.message);
        });
}

// ===== DISPLAY USAGE DATA =====
function displayUsageData(data) {
    document.getElementById('usageLoading').classList.add('d-none');
    
    if (!data.success) {
        showUsageError(data.error || 'Lỗi không xác định');
        return;
    }
    
    document.getElementById('usageContent').classList.remove('d-none');
    document.getElementById('usageTotalCount').textContent = data.total || 0;
    
    const tbody = document.getElementById('usageTableBody');
    const emptyDiv = document.getElementById('usageEmpty');
    
    if (!data.usages || data.usages.length === 0) {
        tbody.innerHTML = '';
        emptyDiv.classList.remove('d-none');
        console.log('ℹ️ No usage data');
        return;
    }
    
    emptyDiv.classList.add('d-none');
    
    // Build table rows
    let html = '';
    data.usages.forEach((item, index) => {
        const statusClass = getStatusClass(item.status);
        const statusText = getStatusText(item.status);
        
        html += '<tr>';
        html += '<td class="text-center fw-bold">' + (index + 1) + '</td>';
        html += '<td class="fw-bold">' + escapeHtml(item.userName) + '</td>';
        html += '<td><small>' + escapeHtml(item.userEmail) + '</small></td>';
        html += '<td class="text-center"><span class="badge bg-primary">#' + item.orderId + '</span></td>';
        html += '<td><small>' + escapeHtml(item.createdAt) + '</small></td>';
        html += '<td class="text-danger fw-bold">' + formatCurrency(item.discountAmount) + '</td>';
        html += '<td class="text-success fw-bold">' + formatCurrency(item.finalAmount) + '</td>';
        html += '<td><span class="badge bg-' + statusClass + '">' + statusText + '</span></td>';
        html += '</tr>';
    });
    
    tbody.innerHTML = html;
    console.log('✅ Table rendered with', data.usages.length, 'rows');
}

// ===== SHOW ERROR =====
function showUsageError(message) {
    document.getElementById('usageLoading').classList.add('d-none');
    document.getElementById('usageError').classList.remove('d-none');
    document.getElementById('usageErrorText').textContent = message;
}

// ===== HELPER FUNCTIONS =====

function getStatusClass(status) {
    switch(status) {
        case 'CONFIRMED': return 'success';
        case 'CANCELLED': return 'danger';
        default: return 'warning';
    }
}

function getStatusText(status) {
    switch(status) {
        case 'CONFIRMED': return 'Đã xác nhận';
        case 'CANCELLED': return 'Đã hủy';
        default: return 'Đang chờ';
    }
}

function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function formatCurrency(value) {
    const num = parseFloat(value) || 0;
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(num);
}

