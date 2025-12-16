// ================= SHOW DETAIL MODAL =================
function showUserDetail(btn) {
    const fullname = btn.dataset.fullname;
    const role = btn.dataset.role;

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

// ================= DELETE MODAL =================
let deleteUserId = null;
function confirmDelete(id, name, role) {
    if (role === 'ADMIN') {
        document.getElementById("deleteUserNameDisplay").innerHTML = '❌ <strong>' + name + '</strong> là ADMIN <br>Không thể xóa!';
        new bootstrap.Modal(document.getElementById("deleteModal")).show();
        return;
    }
    deleteUserId = id;
    document.getElementById("deleteUserNameDisplay").textContent = name;

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
