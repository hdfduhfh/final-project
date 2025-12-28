/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

/* 
 * File: js/admin/orders-view.js
 * Author: DANG KHOA
 */

// ===== MODAL: Confirm Mark Paid =====
const markPaidModal = document.getElementById('confirmMarkPaidModal');
if (markPaidModal) {
    markPaidModal.addEventListener('show.bs.modal', function (event) {
        const trigger = event.relatedTarget;
        const url = trigger.getAttribute('data-confirm-url');
        document.getElementById('btnConfirmMarkPaid').setAttribute('href', url);
    });
}

// ===== MODAL: Approve Cancel =====
const btnApproveCancel = document.getElementById('btnConfirmApproveCancel');
if (btnApproveCancel) {
    btnApproveCancel.addEventListener('click', function () {
        const form = document.getElementById('approveCancelForm');
        if (form) {
            form.submit();
        }
    });
}
