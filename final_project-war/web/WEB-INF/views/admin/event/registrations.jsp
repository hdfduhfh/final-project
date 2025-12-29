<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đăng ký - ${event.eventName}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/event-list.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .registration-header {
            background: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
        }
        
        .event-summary {
            display: grid;
            grid-template-columns: 200px 1fr;
            gap: 30px;
            align-items: start;
        }
        
        .event-thumbnail {
            width: 200px;
            height: 200px;
            border-radius: 12px;
            overflow: hidden;
            background: #f0f0f0;
        }
        
        .event-thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .event-details h2 {
            font-size: 28px;
            margin-bottom: 15px;
            color: #2c3e50;
        }
        
        .detail-row {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
            font-size: 15px;
        }
        
        .detail-row i {
            color: #667eea;
            width: 20px;
        }
        
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card-detail {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            text-align: center;
        }
        
        .stat-card-detail i {
            font-size: 36px;
            margin-bottom: 15px;
        }
        
        .stat-card-detail h3 {
            font-size: 32px;
            margin-bottom: 5px;
            font-weight: 700;
        }
        
        .stat-card-detail p {
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .card-registered {
            border-top: 4px solid #27ae60;
        }
        
        .card-registered i {
            color: #27ae60;
        }
        
        .card-available {
            border-top: 4px solid #3498db;
        }
        
        .card-available i {
            color: #3498db;
        }
        
        .card-percentage {
            border-top: 4px solid #f39c12;
        }
        
        .card-percentage i {
            color: #f39c12;
        }
        
        .card-price {
            border-top: 4px solid #e74c3c;
        }
        
        .card-price i {
            color: #e74c3c;
        }
        
        .info-section {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        
        .info-section h3 {
            font-size: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #2c3e50;
        }
        
        .info-section h3 i {
            color: #667eea;
        }
        
        .progress-bar-wrapper {
            height: 30px;
            background: #ecf0f1;
            border-radius: 15px;
            overflow: hidden;
            position: relative;
            margin: 20px 0;
        }
        
        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            transition: width 0.5s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 14px;
        }
        
        .alert-warning {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-warning i {
            color: #856404;
            font-size: 20px;
        }
        
        .alert-danger {
            background: #f8d7da;
            border-left: 4px solid #e74c3c;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-danger i {
            color: #721c24;
            font-size: 20px;
        }
        
        .table-container {
            overflow-x: auto;
        }
        
        .registrations-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }
        
        .registrations-table thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .registrations-table th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        
        .registrations-table td {
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .registrations-table tbody tr:hover {
            background: #f8f9fa;
        }
        
        .badge-status {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 13px;
            font-weight: 600;
        }
        
        .badge-confirmed {
            background: #d4edda;
            color: #155724;
        }
        
        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        
        .no-data i {
            font-size: 64px;
            margin-bottom: 20px;
            display: block;
            color: #ddd;
        }
        
        .export-btn {
            padding: 10px 20px;
            background: #27ae60;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
        }
        
        .export-btn:hover {
            background: #229954;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- Header -->
        <div class="page-header">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/admin/events" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
                <h1>
                    <i class="fas fa-chart-bar"></i> Chi tiết đăng ký sự kiện
                </h1>
            </div>
        </div>

       <!-- Event Summary -->
<div class="registration-header">
    <div class="event-summary">
        <div class="event-thumbnail">
            <c:choose>
                <c:when test="${not empty event.thumbnailUrl}">
                    <img src="${pageContext.request.contextPath}/${event.thumbnailUrl}"
                         alt="${event.eventName}">
                </c:when>
                <c:otherwise>
                    <div class="no-image">
                        <span>Chưa có hình ảnh</span>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
 <!-- Statistics Cards -->
    <div class="stats-cards">
        <div class="stat-card-detail card-registered">
            <i class="fas fa-user-check"></i>
            <h3>${event.currentAttendees}</h3>
            <p>Người đã đăng ký</p>
        </div>
        <div class="stat-card-detail card-available">
            <i class="fas fa-users"></i>
            <h3>${event.availableSlots}</h3>
            <p>Chỗ còn trống</p>
        </div>
        <div class="stat-card-detail card-percentage">
            <i class="fas fa-percentage"></i>
            <h3>
                <fmt:formatNumber value="${(event.currentAttendees * 100.0) / event.maxAttendees}" 
                                 maxFractionDigits="1" />%
            </h3>
            <p>Tỷ lệ lấp đầy</p>
        </div>
        <div class="stat-card-detail card-price">
            <i class="fas fa-ticket-alt"></i>
            <h3>
                <c:choose>
                    <c:when test="${event.price == 0}">
                        Miễn phí
                    </c:when>
                    <c:otherwise>
                        <fmt:formatNumber value="${event.price}" type="number" />đ
                    </c:otherwise>
                </c:choose>
            </h3>
            <p>Giá vé</p>
        </div>
    </div>

    <!-- Alerts -->
    <c:if test="${event.currentAttendees >= event.maxAttendees * 0.9 && !event.isFull()}">
        <div class="alert-warning">
            <i class="fas fa-exclamation-triangle"></i>
            <span><strong>Cảnh báo:</strong> Sự kiện sắp hết chỗ! Chỉ còn ${event.availableSlots} chỗ trống.</span>
        </div>
    </c:if>
    
    <c:if test="${event.isFull()}">
        <div class="alert-danger">
            <i class="fas fa-times-circle"></i>
            <span><strong>Thông báo:</strong> Sự kiện đã hết chỗ! Không thể đăng ký thêm.</span>
        </div>
    </c:if>

    <!-- Registration Progress -->
    <div class="info-section">
        <h3><i class="fas fa-chart-line"></i> Tiến độ đăng ký</h3>
        <div class="progress-bar-wrapper">
            <div class="progress-bar-fill" 
                 style="width: ${(event.currentAttendees * 100.0) / event.maxAttendees}%">
                ${event.currentAttendees} / ${event.maxAttendees}
            </div>
        </div>
    </div>

    <!-- Danh sách người đăng ký -->
    <div class="info-section">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h3><i class="fas fa-users"></i> Danh sách người đăng ký (${registrations.size()})</h3>
            <c:if test="${not empty registrations}">
                <button class="export-btn" onclick="exportToCSV()">
                    <i class="fas fa-file-excel"></i> Xuất Excel
                </button>
            </c:if>
        </div>
        
        <c:choose>
            <c:when test="${not empty registrations}">
                <div class="table-container">
                    <table class="registrations-table" id="registrationsTable">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Ngày đăng ký</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="reg" items="${registrations}" varStatus="status">
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td>${reg.userID.fullName}</td>
                                    <td>${reg.userID.email}</td>
                                    <td>${reg.userID.phone}</td>
                                    <td>
                                        <fmt:formatDate value="${reg.registrationDate}" 
                                                       pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td>
                                        <span class="badge-status badge-confirmed">${reg.status}</span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-data">
                    <i class="fas fa-inbox"></i>
                    <h3>Chưa có ai đăng ký</h3>
                    <p>Sự kiện chưa có người đăng ký tham gia</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    // Export to CSV
    function exportToCSV() {
        const table = document.getElementById('registrationsTable');
        let csv = [];
        
        // Headers
        const headers = [];
        table.querySelectorAll('thead th').forEach(th => {
            headers.push(th.textContent.trim());
        });
        csv.push(headers.join(','));
        
        // Rows
        table.querySelectorAll('tbody tr').forEach(tr => {
            const row = [];
            tr.querySelectorAll('td').forEach(td => {
                row.push('"' + td.textContent.trim() + '"');
            });
            csv.push(row.join(','));
        });
        
        // Download
        const csvContent = '\uFEFF' + csv.join('\n'); // \uFEFF for UTF-8 BOM
        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = 'danh-sach-dang-ky-${event.eventID}.csv';
        link.click();
    }
</script>