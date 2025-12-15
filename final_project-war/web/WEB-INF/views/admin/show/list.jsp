<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
    <head>
        <title>Danh sách show</title>
    </head>
    <body>
        <h1>Danh sách show</h1>

        <!-- Thông báo -->
        <c:if test="${not empty param.success}">
            <div style="color: blue; font-weight: bold">${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div style="color: red; font-weight: bold">${param.error}</div>
        </c:if>

        <!-- Thống kê -->
        <p>Tổng số show: ${totalShows}, Active: ${activeShows}, Inactive: ${inactiveShows}</p>

        <!-- Form tìm kiếm -->
        <form method="get" action="${pageContext.request.contextPath}/admin/show">
            <input type="text" name="search" placeholder="Tìm theo tên..." value="${searchKeyword}" />
            <button type="submit">Tìm kiếm</button>
            <a href="${pageContext.request.contextPath}/admin/show/add">Thêm mới show</a>
        </form>

        <!-- Bảng danh sách -->
        <table border="1" cellpadding="5" cellspacing="0">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên</th>
                    <th>Thời lượng (phút)</th>
                    <th>Trạng thái</th>
                    <th>Hình ảnh</th>
                    <th>Nghệ sĩ</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="s" items="${shows}">
                    <tr>
                        <td>${s.showID}</td>
                        <td>${s.showName}</td>
                        <td>${s.durationMinutes}</td>
                        <td>${s.status}</td>
                        <td>
                            <c:if test="${not empty s.showImage}">
                                <img src="${pageContext.request.contextPath}/${s.showImage}" width="80" />
                            </c:if>
                        </td>
                        <td>
                            <c:forEach var="sa" items="${s.showArtistCollection}">
                                ${sa.artistID.artistName}<br/>
                            </c:forEach>
                        </td>
                   
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/show/edit?id=${s.showID}">Sửa</a> |
                            <a href="${pageContext.request.contextPath}/admin/show/delete?id=${s.showID}"
                               onclick="return confirm('Xóa show này?');">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </body>
</html>