<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Quản lý vé</title>

    <!-- BOOTSTRAP 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
        }
        th {
            background: #667eea;
            color: white;
        }
        .status-valid {
            color: green;
            font-weight: bold;
        }
        .status-used {
            color: gray;
        }
        .status-cancelled {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body class="p-4">

<h2>🎫 Quản lý vé</h2>

<table class="table table-bordered align-middle">
    <thead>
        <tr>
            <th>ID</th>
            <th>QRCode</th>
            <th>Show</th>
            <th>Suất diễn</th>
            <th>Ghế</th>
            <th>Khách hàng</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="ticket" items="${tickets}">
            <tr>
                <td>${ticket.ticketID}</td>
                <td>${ticket.QRCode}</td>
                <td>${ticket.orderDetailID.scheduleID.showID.showName}</td>
                <td>
                    <fmt:formatDate
                        value="${ticket.orderDetailID.scheduleID.showTime}"
                        pattern="dd/MM/yyyy HH:mm"/>
                </td>
                <td>${ticket.orderDetailID.seatID.seatNumber}</td>
                <td>${ticket.orderDetailID.orderID.userID.fullName}</td>
                <td class="status-${ticket.status.toLowerCase()}">
                    ${ticket.status}
                </td>
                <td>
                    <button class="btn btn-sm btn-primary"
                            data-bs-toggle="modal"
                            data-bs-target="#ticketModal-${ticket.ticketID}">
                        Xem
                    </button>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<!-- ================= MODAL ================= -->
<c:forEach var="ticket" items="${tickets}">
<div class="modal fade" id="ticketModal-${ticket.ticketID}" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">
                    🎫 Chi tiết vé #${ticket.ticketID}
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <table class="table table-bordered">
                    <tr>
                        <th>QR Code</th>
                        <td>${ticket.QRCode}</td>
                    </tr>
                    <tr>
                        <th>Show</th>
                        <td>${ticket.orderDetailID.scheduleID.showID.showName}</td>
                    </tr>
                    <tr>
                        <th>Suất diễn</th>
                        <td>
                            <fmt:formatDate
                                value="${ticket.orderDetailID.scheduleID.showTime}"
                                pattern="dd/MM/yyyy HH:mm"/>
                        </td>
                    </tr>
                    <tr>
                        <th>Ghế</th>
                        <td>${ticket.orderDetailID.seatID.seatNumber}</td>
                    </tr>
                    <tr>
                        <th>Khách hàng</th>
                        <td>${ticket.orderDetailID.orderID.userID.fullName}</td>
                    </tr>
                    <tr>
                        <th>Trạng thái</th>
                        <td class="status-${ticket.status.toLowerCase()}">
                            ${ticket.status}
                        </td>
                    </tr>
                    <tr>
                        <th>Phát hành lúc</th>
                        <td>
                            <fmt:formatDate value="${ticket.issuedAt}"
                                            pattern="dd/MM/yyyy HH:mm:ss"/>
                        </td>
                    </tr>
                    <tr>
                        <th>Check-in lúc</th>
                        <td>
                            <c:choose>
                                <c:when test="${not empty ticket.checkInAt}">
                                    <fmt:formatDate value="${ticket.checkInAt}"
                                                    pattern="dd/MM/yyyy HH:mm:ss"/>
                                </c:when>
                                <c:otherwise>Chưa check-in</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <th>Cập nhật</th>
                        <td>
                            <c:choose>
                                <c:when test="${not empty ticket.updatedAt}">
                                    <fmt:formatDate value="${ticket.updatedAt}"
                                                    pattern="dd/MM/yyyy HH:mm:ss"/>
                                </c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </table>
            </div>

            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">
                    Đóng
                </button>
            </div>

        </div>
    </div>
</div>
</c:forEach>

<!-- BOOTSTRAP JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
