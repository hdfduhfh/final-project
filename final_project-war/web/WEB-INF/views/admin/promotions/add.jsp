<%--
    Document   : add
    Created on : Dec 19, 2025, 1:49:28 AM
    Author     : DANG KHOA
    Updated    : UI upgraded (Bootstrap 5 + FA + Glass theme) + Validation display & retention
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm khuyến mãi</title>

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome 6 -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <style>
            :root{
                --bg:#0b1220;
                --panel:#0f1b33;
                --muted:#8ea0c4;
                --line:rgba(255,255,255,.08);
            }

            body{
                background:
                    radial-gradient(1200px 700px at 20% -10%, rgba(79,70,229,.28), transparent 55%),
                    radial-gradient(900px 500px at 80% 0%, rgba(6,182,212,.22), transparent 60%),
                    linear-gradient(180deg, var(--bg), #070b14);
                min-height:100vh;
                color:#e6ecff;
                font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, "Noto Sans", "Helvetica Neue", sans-serif;
            }

            /* Layout */
            .admin-wrap{
                display:flex;
                min-height:100vh;
            }
            .sidebar{
                width:270px;
                background: rgba(15,27,51,.86);
                border-right:1px solid var(--line);
                reveal: none;
                backdrop-filter: blur(10px);
                padding:18px 14px;
                position:sticky;
                top:0;
                height:100vh;
            }
            .brand{
                display:flex;
                align-items:center;
                gap:10px;
                padding:10px 12px;
                border-radius:14px;
                background: rgba(255,255,255,.06);
                border:1px solid var(--line);
            }
            .brand .logo{
                width:38px;
                height:38px;
                border-radius:12px;
                display:grid;
                place-items:center;
                background: linear-gradient(135deg, rgba(79,70,229,.9), rgba(6,182,212,.9));
                box-shadow: 0 14px 35px rgba(0,0,0,.35);
            }
            .brand .title{
                line-height:1.1;
                font-weight:950;
                letter-spacing:.2px;
            }
            .brand small{
                color:var(--muted);
                font-weight:650;
            }

            .nav-group{
                margin-top:14px;
            }
            .nav-item{
                display:flex;
                align-items:center;
                gap:10px;
                padding:10px 12px;
                border-radius:12px;
                color:#dbe5ff;
                text-decoration:none;
                border:1px solid transparent;
            }
            .nav-item:hover{
                background: rgba(255,255,255,.06);
                border-color: var(--line);
            }
            .nav-item.active{
                background: rgba(6,182,212,.16);
                border-color: rgba(6,182,212,.35);
            }
            .nav-item i{
                width:20px;
                text-align:center;
                color:#bcd0ff;
            }

            .content{
                flex:1;
                padding:22px 22px 28px;
            }

            .topbar{
                display:flex;
                gap:12px;
                align-items:center;
                justify-content:space-between;
                padding:14px 16px;
                border-radius:18px;
                background: rgba(255,255,255,.06);
                border:1px solid var(--line);
                backdrop-filter: blur(10px);
                box-shadow: 0 18px 55px rgba(0,0,0,.35);
            }
            .page-h{
                display:flex;
                gap:12px;
                align-items:center;
            }
            .page-h h1{
                font-size:18px;
                margin:0;
                font-weight:950;
                letter-spacing:.2px;
            }
            .page-h .crumb{
                color:var(--muted);
                font-weight:650;
                font-size:12px;
            }

            .panel{
                margin-top:14px;
                padding:14px;
                border-radius:18px;
                background: rgba(255,255,255,.06);
                border:1px solid var(--line);
                backdrop-filter: blur(10px);
            }

            .form-card{
                border-radius: 18px;
                overflow:hidden;
                background: rgba(255,255,255,.96);
                box-shadow: 0 22px 70px rgba(0,0,0,.35);
            }

            .form-label{
                font-weight:900;
                color:#0b1220;
            }
            .helper{
                font-size:12px;
                color:#6b7280;
                font-weight:650;
            }

            @media (max-width: 992px){
                .sidebar{
                    display:none;
                }
            }
        </style>
    </head>

    <body>
        <div class="admin-wrap">

            <!-- SIDEBAR -->
            <aside class="sidebar">
                <div class="brand">
                    <div class="logo"><i class="fa-solid fa-masks-theater"></i></div>
                    <div>
                        <div class="title">Theater Admin</div>
                        <small>Quản lý khuyến mãi</small>
                    </div>
                </div>

                <div class="nav-group">
                </div>

                <hr style="border-color: var(--line);">

                <div class="px-2">
                    <div class="text-uppercase" style="font-size:12px; color:var(--muted); font-weight:950; letter-spacing:.3px;">
                        Quick actions
                    </div>
                    <div class="mt-2 d-grid gap-2">
                        <a class="btn btn-outline-light fw-bold" href="${pageContext.request.contextPath}/admin/promotions" style="border-radius:14px;">
                            <i class="fa-solid fa-arrow-left"></i> Quay về danh sách
                        </a>
                    </div>
                </div>
            </aside>

            <!-- CONTENT -->
            <main class="content">

                <!-- TOPBAR -->
                <div class="topbar">
                    <div class="page-h">
                        <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                            <i class="fa-solid fa-circle-plus"></i>
                        </div>
                        <div>
                            <h1>Thêm khuyến mãi mới</h1>
                            <div class="crumb">Admin / Promotions / Create</div>
                        </div>
                    </div>
                </div>

                <!-- ERRORS -->
                <c:if test="${not empty errors}">
                    <div class="alert alert-danger mt-3 mb-0">
                        <div class="fw-bold mb-1">
                            <i class="fa-solid fa-triangle-exclamation"></i> Vui lòng sửa các lỗi sau:
                        </div>
                        <ul class="mb-0">
                            <c:forEach var="err" items="${errors}">
                                <li>${err}</li>
                                </c:forEach>
                        </ul>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger mt-3 mb-0">
                        <i class="fa-solid fa-triangle-exclamation"></i> ${error}
                    </div>
                </c:if>

                <!-- FORM -->
                <div class="panel">
                    <div class="form-card">
                        <div class="p-4">
                            <form action="${pageContext.request.contextPath}/admin/promotions" method="post" class="row g-3">
                                <input type="hidden" name="action" value="insert"/>

                                <div class="col-12">
                                    <label class="form-label">Tên khuyến mãi <span class="text-danger">*</span></label>
                                    <input type="text" name="name" value="${oldName}" class="form-control" placeholder="Ví dụ: Sale cuối tuần">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Mã khuyến mãi (Code) <span class="text-danger">*</span></label>
                                    <input type="text" name="code" value="${oldCode}"  class="form-control" placeholder="Ví dụ: SALE50">
                                    <div class="helper mt-1">
                                        Gợi ý: viết HOA, không dấu, không khoảng trắng.
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Trạng thái</label>
                                    <select name="status" class="form-select">
                                        <option value="ACTIVE" ${oldStatus == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                        <option value="INACTIVE" ${oldStatus == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Loại giảm giá <span class="text-danger">*</span></label>
                                    <select name="discountType" class="form-select" id="discountType">
                                        <option value="PERCENT" ${oldType == 'PERCENT' ? 'selected' : ''}>Phần trăm (%)</option>
                                        <option value="FIXED" ${oldType == 'FIXED' ? 'selected' : ''}>Số tiền cố định (VNĐ)</option>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Giá trị giảm <span class="text-danger">*</span></label>
                                    <input type="number" step="0.01" name="discountValue" value="${oldValue}" class="form-control"
                                           placeholder="Nhập số % hoặc số tiền">
                                    <div class="helper mt-1" id="discountValueHelp"></div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Đơn hàng tối thiểu (VNĐ)</label>
                                    <input type="number" step="0.01" name="minOrderAmount" value="${oldMinOrder}" class="form-control" placeholder="0">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Giảm tối đa (VNĐ)</label>
                                    <input type="number" step="0.01" name="maxDiscount" value="${oldMaxDiscount}" class="form-control"
                                           placeholder="Chỉ dùng cho loại %">
                                    <div class="helper mt-1">Nếu giảm theo %, hệ thống sẽ giới hạn số tiền giảm tối đa.</div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
                                    <input type="datetime-local" name="startDate" value="${oldStartDate}"  class="form-control">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
                                    <input type="datetime-local" name="endDate" value="${oldEndDate}"  class="form-control">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Số lượt sử dụng tối đa (Toàn hệ thống)</label>
                                    <input type="number" name="maxUsage" value="${oldMaxUsage}" class="form-control"
                                           placeholder="Để trống nếu không giới hạn">
                                    <div class="helper mt-1">0 hoặc để trống = không giới hạn (tùy servlet xử lý).</div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Số lượt dùng tối đa (Mỗi user)</label>
                                    <input type="number" name="maxUsagePerUser" value="${oldMaxPerUser}" class="form-control"
                                           placeholder="Để trống nếu không giới hạn">
                                </div>

                                <div class="col-12 d-flex gap-2 justify-content-end pt-2">
                                    <button type="submit" class="btn btn-warning fw-bold">
                                        <i class="fa-solid fa-floppy-disk"></i> Lưu khuyến mãi
                                    </button>
                                </div>

                            </form>
                        </div>
                    </div>
                </div>

            </main>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // UI helper: đổi hint theo discountType (không thay đổi server)
            (function () {
                const typeEl = document.getElementById('discountType');
                const helpEl = document.getElementById('discountValueHelp');
                if (!typeEl || !helpEl)
                    return;

                function render() {
                    if (typeEl.value === 'PERCENT') {
                        helpEl.textContent = 'Nhập % giảm (ví dụ: 10, 20, 50). Có thể dùng “Giảm tối đa” để giới hạn tiền.';
                    } else {
                        helpEl.textContent = 'Nhập số tiền giảm trực tiếp (VNĐ). “Giảm tối đa” sẽ không cần thiết.';
                    }
                }
                typeEl.addEventListener('change', render);
                render();
            })();
        </script>

    </body>
</html>
