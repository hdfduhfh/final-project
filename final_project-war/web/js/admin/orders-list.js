/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
/* 
 * File: js/admin/orders-list.js
 * Author: DANG KHOA
 */

// ===== FILTER ORDERS =====
function filterOrders() {
    const statusFilter = document.getElementById('filterStatus').value;
    const paymentFilter = document.getElementById('filterPayment').value;
    const rows = document.querySelectorAll('#ordersTable tbody tr');
    
    rows.forEach(row => {
        const status = row.getAttribute('data-status');
        const payment = row.getAttribute('data-payment');
        
        const statusMatch = !statusFilter || status === statusFilter;
        const paymentMatch = !paymentFilter || payment === paymentFilter;
        
        row.style.display = (statusMatch && paymentMatch) ? '' : 'none';
    });
}

// ===== MODAL: Approve Cancel =====
let selectedCancelOrderId = null;

const cancelModalEl = document.getElementById('confirmApproveCancelModal');
if (cancelModalEl) {
    cancelModalEl.addEventListener('show.bs.modal', function (event) {
        const trigger = event.relatedTarget;
        selectedCancelOrderId = trigger.getAttribute('data-order-id');
        
        const txt = document.getElementById('cancelOrderIdText');
        if (txt) {
            txt.textContent = '#' + selectedCancelOrderId;
        }
    });
}

const btnConfirm = document.getElementById('btnConfirmApproveCancel');
if (btnConfirm) {
    btnConfirm.addEventListener('click', function () {
        if (!selectedCancelOrderId) return;
        
        const form = document.getElementById('approveCancelForm-' + selectedCancelOrderId);
        if (form) {
            form.submit();
        }
    });
}

// ===== EVENT LISTENERS =====
document.addEventListener('DOMContentLoaded', function() {
    // Filter change listeners
    const filterStatus = document.getElementById('filterStatus');
    const filterPayment = document.getElementById('filterPayment');
    
    if (filterStatus) {
        filterStatus.addEventListener('change', filterOrders);
    }
    
    if (filterPayment) {
        filterPayment.addEventListener('change', filterOrders);
    }
});

