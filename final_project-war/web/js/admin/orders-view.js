/* 
 * File: js/admin/orders-view.js
 * Author: DANG KHOA
 */

// ===== UTILITY: Show Toast Notification =====
function showToast(message, type = 'danger') {
    // Tạo toast container nếu chưa có
    let toastContainer = document.querySelector('.toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
        toastContainer.style.zIndex = '9999';
        document.body.appendChild(toastContainer);
    }
    
    // Icon theo type
    const icons = {
        success: '<i class="fa-solid fa-circle-check me-2"></i>',
        danger: '<i class="fa-solid fa-circle-xmark me-2"></i>',
        warning: '<i class="fa-solid fa-triangle-exclamation me-2"></i>',
        info: '<i class="fa-solid fa-circle-info me-2"></i>'
    };
    
    // Tạo toast element
    const toastEl = document.createElement('div');
    toastEl.className = `toast align-items-center text-bg-${type} border-0`;
    toastEl.setAttribute('role', 'alert');
    toastEl.setAttribute('aria-live', 'assertive');
    toastEl.setAttribute('aria-atomic', 'true');
    
    toastEl.innerHTML = `
        <div class="d-flex">
            <div class="toast-body fw-bold">
                ${icons[type] || ''}${message}
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" 
                    data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    `;
    
    toastContainer.appendChild(toastEl);
    
    // Hiển thị toast
    const toast = new bootstrap.Toast(toastEl, {
        animation: true,
        autohide: true,
        delay: 4000
    });
    toast.show();
    
    // Xóa toast sau khi ẩn
    toastEl.addEventListener('hidden.bs.toast', () => {
        toastEl.remove();
    });
}

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

// ===== SEAT CHANGE: Xử lý nút Từ chối =====
document.getElementById('btnReject')?.addEventListener('click', function() {
    // Hiện modal xác nhận Bootstrap thay vì alert
    const confirmModal = new bootstrap.Modal(document.createElement('div'));
    const modalDiv = document.createElement('div');
    modalDiv.className = 'modal fade';
    modalDiv.innerHTML = `
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title fw-bold">
                        <i class="fa-solid fa-ban me-2"></i>Xác nhận từ chối
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger mb-0">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i>
                        Bạn có chắc chắn muốn <strong>TỪ CHỐI</strong> yêu cầu đổi ghế?
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fa-solid fa-xmark me-1"></i>Hủy
                    </button>
                    <button type="button" class="btn btn-danger" id="confirmRejectBtn">
                        <i class="fa-solid fa-ban me-1"></i>Từ chối
                    </button>
                </div>
            </div>
        </div>
    `;
    
    document.body.appendChild(modalDiv);
    const modal = new bootstrap.Modal(modalDiv);
    modal.show();
    
    // Xử lý khi xác nhận
    document.getElementById('confirmRejectBtn').addEventListener('click', function() {
        document.getElementById('actionType').value = 'REJECT';
        document.getElementById('seatChangeForm').submit();
        modal.hide();
    });
    
    // Cleanup khi đóng modal
    modalDiv.addEventListener('hidden.bs.modal', function() {
        modalDiv.remove();
    });
});

// ===== SEAT CHANGE: Xử lý nút Duyệt =====
document.getElementById('btnApprove')?.addEventListener('click', function() {
    const seatSelect = document.getElementById('newSeatSelect');
    
    // ✅ KIỂM TRA CHƯA CHỌN GHẾ - Dùng Toast thay vì alert
    if (!seatSelect || !seatSelect.value) {
        showToast('⚠️ Vui lòng chọn ghế mới trước khi duyệt!', 'warning');
        seatSelect?.focus();
        return;
    }
    
    const selectedSeatText = seatSelect.options[seatSelect.selectedIndex].text;
    
    // Hiện modal xác nhận Bootstrap
    const modalDiv = document.createElement('div');
    modalDiv.className = 'modal fade';
    modalDiv.innerHTML = `
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title fw-bold">
                        <i class="fa-solid fa-check me-2"></i>Xác nhận duyệt đổi ghế
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-success mb-0">
                        <i class="fa-solid fa-circle-check me-2"></i>
                        Bạn có chắc chắn muốn <strong>DUYỆT</strong> đổi sang ghế:<br>
                        <strong class="fs-5 mt-2 d-block">${selectedSeatText}</strong>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fa-solid fa-xmark me-1"></i>Hủy
                    </button>
                    <button type="button" class="btn btn-success" id="confirmApproveBtn">
                        <i class="fa-solid fa-check me-1"></i>Xác nhận duyệt
                    </button>
                </div>
            </div>
        </div>
    `;
    
    document.body.appendChild(modalDiv);
    const modal = new bootstrap.Modal(modalDiv);
    modal.show();
    
    // Xử lý khi xác nhận
    document.getElementById('confirmApproveBtn').addEventListener('click', function() {
        document.getElementById('actionType').value = 'APPROVE';
        document.getElementById('seatChangeForm').submit();
        modal.hide();
    });
    
    // Cleanup
    modalDiv.addEventListener('hidden.bs.modal', function() {
        modalDiv.remove();
    });
});

// ===== MODAL: Confirm Approve Cancel (existing) =====
const confirmMarkPaidModal = document.getElementById('confirmMarkPaidModal');
if (confirmMarkPaidModal) {
    confirmMarkPaidModal.addEventListener('show.bs.modal', function(event) {
        const button = event.relatedTarget;
        const url = button.getAttribute('data-confirm-url');
        document.getElementById('btnConfirmMarkPaid').href = url;
    });
}