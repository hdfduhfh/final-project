<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý nghệ sĩ</title>
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
        <h1>Quản lý nghệ sĩ</h1>

        <!-- Thông báo thành công (redirect kèm param success) -->
        <c:if test="${not empty param.success}">
            <div style="color: green; font-weight: bold; margin-bottom: 10px;">
                ${param.success}
            </div>
        </c:if>

        <!-- Thông báo lỗi (attribute error trong request) -->
        <c:if test="${not empty error}">
            <div style="color: red; font-weight: bold; margin-bottom: 10px;">
                ${error}
            </div>
        </c:if>

        <!-- Nút thêm nghệ sĩ mới -->
        <p>
            <a href="${pageContext.request.contextPath}/admin/artist/add" class="btn btn-primary">
                ➕ Thêm nghệ sĩ mới
            </a>
        </p>

        <!-- Form tìm kiếm -->
        <form method="get"
              action="${pageContext.request.contextPath}/admin/artist"
              style="margin-bottom: 15px;"
              id="searchForm">

            <div style="position: relative; display: inline-block;">
                <input type="text"
                       id="searchInput"
                       name="search"
                       placeholder="Nhập tên nghệ sĩ cần tìm..."
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

        <!-- Thống kê tổng số nghệ sĩ -->
        <div style="margin-bottom: 10px;">
            <strong>Tổng số nghệ sĩ:</strong> ${totalArtists}
        </div>

        <!-- Bảng danh sách nghệ sĩ -->
        <table>
            <tr>
                <th>Tên nghệ sĩ</th>
                <th>Vai trò</th>
                <th>Giới thiệu</th>
                <th>Hình ảnh</th>
                <th>Hành động</th>
            </tr>

            <c:forEach var="a" items="${artists}" varStatus="st">
                <tr>
                    <td>${a.name}</td>
                    <td>${a.role}</td>
                    <td>${a.bio}</td>
                    <td>
                        <c:if test="${not empty a.artistImage}">
                            <img src="${pageContext.request.contextPath}/${a.artistImage}" alt="${a.name}" style="max-width:100px; max-height:80px;" />

                        </c:if>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/artist/edit?id=${a.artistID}"
                           class="btn">
                            Sửa
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/artist/delete?id=${a.artistID}"
                           class="btn btn-danger"
                           onclick="return confirm('Bạn có chắc chắn muốn xóa nghệ sĩ này?');">
                            Xóa
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:choose>
                <c:when test="${not empty artists}">
                    <c:forEach var="artist" items="${artists}">
                        <!-- in từng dòng -->
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5" style="text-align:center;">
                            Không có nghệ sĩ nào.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>

        </table>

    </body>
</html>
