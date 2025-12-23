// ================= SHOW DETAIL MODAL =================
function showUserDetail(btn) {
    const fullname = btn.dataset.fullname;
    const role = btn.dataset.role;
    const orderCount = btn.dataset.ordercount || '0';

    document.getElementById('detailUserID').textContent = btn.dataset.id;
    document.getElementById('detailFullName').textContent = fullname;
    document.getElementById('detailEmail').textContent = btn.dataset.email || '---';
    document.getElementById('detailPhone').textContent = btn.dataset.phone || '---';

    // Avatar
    document.getElementById('modalAvatar').textContent = fullname.charAt(0).toUpperCase();

    // Role Badge
    const roleEl = document.getElementById('detailRole');
    roleEl.textContent = role;
    roleEl.className = (role === 'ADMIN') ? 'badge badge-soft badge-soft-danger' : 'badge badge-soft badge-soft-primary';

    document.getElementById('detailCreatedAt').textContent = btn.dataset.created;
    document.getElementById('detailLastLogin').textContent = btn.dataset.lastlogin;
    
    // 🔥 HIỂN THỊ SỐ ĐƠN HÀNG
    const orderCountEl = document.getElementById('detailOrderCount');
    if (orderCountEl) {
        orderCountEl.textContent = orderCount + ' đơn hàng';
        orderCountEl.className = parseInt(orderCount) > 0 ? 'detail-value text-primary fw-bold' : 'detail-value text-secondary';
    }

    new bootstrap.Modal(document.getElementById('userDetailModal')).show();
}

// ================= SHOW EDIT MODAL =================
function showUserEdit(userID, fullName, email, phone) {
    document.getElementById('editUserID').value = userID;
    document.getElementById('editFullName').value = fullName;
    document.getElementById('editEmail').value = email;
    document.getElementById('editPhone').value = (phone && phone !== 'null') ? phone : '';
    new bootstrap.Modal(document.getElementById('userEditModal')).show();
}

// ================= DELETE MODAL - WITH ORDER COUNT CHECK =================
let deleteUserId = null;
function confirmDelete(id, name, role, orderCount) {
    const displayEl = document.getElementById("deleteUserNameDisplay");
    
    // 🔒 Check nếu là ADMIN
    if (role === 'ADMIN') {
        displayEl.innerHTML = '❌ <strong>' + name + '</strong> là ADMIN <br>Không thể xóa!';
        displayEl.className = 'alert alert-danger text-center fw-bold mb-0';
        
        // Ẩn nút "Xóa ngay"
        document.querySelector('#deleteModal .btn-danger').style.display = 'none';
        
        new bootstrap.Modal(document.getElementById("deleteModal")).show();
        return;
    }
    
    // 🛒 Check nếu có đơn hàng
    if (orderCount && parseInt(orderCount) > 0) {
        displayEl.innerHTML = '❌ <strong>' + name + '</strong><br>' +
                             '📦 Đã có <span class="badge bg-danger">' + orderCount + ' đơn hàng</span> trong hệ thống<br>' +
                             '<small class="text-muted">Không thể xóa người dùng này!</small>';
        displayEl.className = 'alert alert-danger text-center fw-bold mb-0';
        
        // Ẩn nút "Xóa ngay"
        document.querySelector('#deleteModal .btn-danger').style.display = 'none';
        
        new bootstrap.Modal(document.getElementById("deleteModal")).show();
        return;
    }
    
    // ✅ Cho phép xóa
    deleteUserId = id;
    displayEl.textContent = name;
    displayEl.className = 'alert alert-warning text-center fw-bold mb-0';
    
    // Hiển thị nút "Xóa ngay"
    document.querySelector('#deleteModal .btn-danger').style.display = 'inline-block';

    // Hide other modals if open
    ['userCreateModal','userEditModal'].forEach(modalId=>{
        const modalEl = document.getElementById(modalId);
        const modalInstance = bootstrap.Modal.getInstance(modalEl);
        if(modalInstance) modalInstance.hide();
    });

    new bootstrap.Modal(document.getElementById("deleteModal")).show();
}

function submitDeleteForm(){
    if(deleteUserId){
        document.getElementById("inputDeleteUserId").value = deleteUserId;
        document.getElementById("deleteUserForm").submit();
    }
}

// ================= VALIDATION CREATE =================
document.getElementById("createUserForm").addEventListener("submit", function(e){
    let valid = true;

    const fullName = this.fullName.value.trim();
    const email = this.email.value.trim();
    const role = this.roleName.value.trim();

    const fullNameError = document.getElementById("createFullNameError");
    const emailError = document.getElementById("createEmailError");
    const roleError = document.getElementById("createRoleError");

    fullNameError.textContent = '';
    emailError.textContent = '';
    roleError.textContent = '';

    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if(!fullName){ fullNameError.textContent="⚠ Vui lòng nhập họ và tên!"; valid=false;}
    if(!email){ emailError.textContent="⚠ Vui lòng nhập email!"; valid=false;}
    else if(!emailPattern.test(email)){ emailError.textContent="⚠ Email không hợp lệ!"; valid=false;}
    if(!role){ roleError.textContent="⚠ Vui lòng chọn vai trò!"; valid=false;}

    if(!valid) e.preventDefault();
});

// ================= VALIDATION EDIT =================
document.getElementById("editUserForm").addEventListener("submit", function(e){
    let valid = true;

    const fullName = this.fullName.value.trim();
    const email = this.email.value.trim();

    document.getElementById("editFullNameError").textContent='';
    document.getElementById("editEmailError").textContent='';

    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if(!fullName){ document.getElementById("editFullNameError").textContent="⚠ Vui lòng nhập họ tên!"; valid=false;}
    if(!email){ document.getElementById("editEmailError").textContent="⚠ Vui lòng nhập email!"; valid=false;}
    else if(!emailPattern.test(email)){ document.getElementById("editEmailError").textContent="⚠ Email không hợp lệ!"; valid=false;}

    if(!valid) e.preventDefault();
});