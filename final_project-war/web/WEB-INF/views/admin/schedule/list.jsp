<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
    <head>
        <title>Quản lý Lịch chiếu</title>
        <style>
            table {
                border-collapse: collapse;
                width: 100%;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 6px 8px;
            }
            th {
                background-color: #f0f0f0;
            }
            .btn {
                padding: 6px 10px;
                text-decoration: none;
                border: 1px solid #333;
                border-radius: 4px;
                font-size: 13px;
            }
            .btn-primary {
                background-color: #007bff;
                color: #fff;
            }
            .btn-danger {
                background-color: #dc3545;
                color: #fff;
            }
        </style>
    </head>
    <body>
        <h1>Quản lý Lịch chiếu</h1>

        <!-- Thông báo thành công (từ param success khi redirect) -->
        <c:if test="${not empty param.success}">
            <div style="color: green; font-weight: bold; margin-bottom: 10px;">
                ${param.success}
            </div>
        </c:if>

        <!-- Thông báo lỗi (attribute error khi forward) -->
        <c:if test="${not empty error}">
            <div style="color: red; font-weight: bold; margin-bottom: 10px;">
                ${error}
            </div>
        </c:if>

        <!-- Nút thêm lịch chiếu -->
        <p>
            <a href="${pageContext.request.contextPath}/admin/schedule/add" class="btn btn-primary">
                ➕ Thêm lịch chiếu mới
            </a>
        </p>
        
        <!-- Form tìm kiếm -->
        <form method="get"
              action="${pageContext.request.contextPath}/admin/schedule"
              style="margin-bottom: 15px;"
              id="searchForm">

            <div style="position: relative; display: inline-block;">
                <input type="text"
                       id="searchInput"
                       name="search"
                       placeholder="Nhập tên show cần tìm..."
                       value="${searchKeyword != null ? searchKeyword : ''}"
                       style="width: 250px; padding-right: 24px;"/>

                <!-- Nút X để xóa nhanh nội dung ô tìm kiếm -->
                <span id="clearSearch"
                      style="position: absolute;
                      right: 6px;
                      top: 50%;
                      transform: translateY(-50%);
                      cursor: pointer;
                      font-weight: bold;
                      color: #888;
                      display: none;">
                    &times;
                </span>
            </div>

            <!-- Nút submit là icon kính lúp -->
            <button type="submit"
                    style="margin-left: 5px;
                    padding: 4px 10px;
                    cursor: pointer;">
                &#128269;
            </button>
        </form>

        <script>
            (function () {
                const input = document.getElementById('searchInput');
                const clearBtn = document.getElementById('clearSearch');

                if (!input || !clearBtn)
                    return;

                function toggleClearButton() {
                    if (input.value.trim().length > 0) {
                        clearBtn.style.display = 'inline';
                    } else {
                        clearBtn.style.display = 'none';
                    }
                }

                // Khi gõ chữ -> hiện / ẩn nút X
                input.addEventListener('input', toggleClearButton);

                // Khi bấm X -> xóa nội dung và focus lại vào ô search
                clearBtn.addEventListener('click', function () {
                    input.value = '';
                    toggleClearButton();
                    input.focus();
                });

                // Gọi lần đầu để xử lý trường hợp đã có searchKeyword sẵn
                toggleClearButton();
            })();
        </script>

        <!-- Thống kê tổng số lịch chiếu -->
        <div style="margin-bottom: 10px;">
            <strong>Tổng số lịch chiếu:</strong> ${totalSchedules}
        </div>

        <!-- Bảng danh sách lịch chiếu -->
        <table>
            <tr>
                <th>Vở diễn</th>
                <th>Giờ chiếu</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>

            <c:forEach var="sc" items="${schedules}" varStatus="st">
                <tr>
                    <td>
                        <c:choose>
                            <c:when test="${sc.showID != null}">
                                ${sc.showID.showName}
                            </c:when>
                            <c:otherwise>
                                (Không có vở diễn)
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <fmt:formatDate value="${sc.showTime}" pattern="dd/MM/yyyy HH:mm"/>
                    </td>
                    <td>${sc.status}</td>
                    <td>${sc.totalSeats}</td>
                    <td>${sc.availableSeats}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/schedule/edit?id=${sc.scheduleID}"
                           class="btn">
                            Sửa
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/schedule/delete?id=${sc.scheduleID}"
                           class="btn btn-danger"
                           onclick="return confirm('Bạn có chắc chắn muốn xóa lịch chiếu này?');">
                            Xóa
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty schedules}">
                <tr>
                    <td colspan="8" style="text-align: center; padding: 10px;">
                        Không có lịch chiếu nào.
                    </td>
                </tr>
            </c:if>
        </table>

    </body>
</html>
