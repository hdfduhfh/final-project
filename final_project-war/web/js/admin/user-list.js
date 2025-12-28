/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
function showUserDetail(btn) {
            document.getElementById('detailUserID').textContent = btn.getAttribute('data-id');
            document.getElementById('detailFullName').textContent = btn.getAttribute('data-fullname');
            document.getElementById('detailEmail').textContent = btn.getAttribute('data-email');
            document.getElementById('detailPhone').textContent = btn.getAttribute('data-phone') || 'Chưa cập nhật';
            document.getElementById('detailRole').textContent = btn.getAttribute('data-role');
            document.getElementById('detailOrderCount').textContent = btn.getAttribute('data-ordercount') + ' đơn';
            document.getElementById('detailCreatedAt').textContent = btn.getAttribute('data-created');
            document.getElementById('detailLastLogin').textContent = btn.getAttribute('data-lastlogin');
            
            const name = btn.getAttribute('data-fullname');
            document.getElementById('modalAvatar').textContent = name.charAt(0).toUpperCase();
            
            new bootstrap.Modal(document.getElementById('userDetailModal')).show();
        }

        function showUserEdit(id, name, email, phone) {
            document.getElementById('editUserID').value = id;
            document.getElementById('editFullName').value = name;
            document.getElementById('editEmail').value = email;
            document.getElementById('editPhone').value = phone || '';
            new bootstrap.Modal(document.getElementById('userEditModal')).show();
        }

        function confirmDelete(userId, userName, role, orderCount) {
            document.getElementById('inputDeleteUserId').value = userId;
            document.getElementById('deleteUserNameDisplay').innerHTML = 
                '<i class="fa-solid fa-user"></i> ' + userName + 
                '<br><small>Vai trò: ' + role + ' | Đơn hàng: ' + orderCount + '</small>';
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }

        function submitDeleteForm() {
            document.getElementById('deleteUserForm').submit();
        }

