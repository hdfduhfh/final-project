<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
    <head>
        <title>Quản lý Show - Nghệ sĩ</title>
        <style>
            table {
                border-collapse: collapse;
                width: 100%;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 8px;
            }
            th {
                background: #f3f3f3;
            }
            .msg {
                font-weight: bold;
                margin: 10px 0;
            }
        </style>
    </head>
    <body>
        <h2>Danh sách nghệ sĩ tham gia các show</h2>

        <c:if test="${not empty param.success}">
            <div class="msg" style="color: green;">${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="msg" style="color: red;">${param.error}</div>
        </c:if>

        <table>
            <thead>
                <tr>
                    <th>Show</th>
                    <th>Nghệ sĩ</th>
                    <th>Vai trò</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="sa" items="${links}">
                    <tr>
                        <td>${sa.showID.showName}</td>
                        <td>${sa.artistID.name}</td>
                        <td>${sa.artistID.role}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/showArtist/delete?showId=${sa.showID.showID}&artistId=${sa.artistID.artistID}"
                               onclick="return confirm('Xóa nghệ sĩ này khỏi show này?');">
                                Xóa khỏi show
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <p style="margin-top: 12px;">
            <a href="${pageContext.request.contextPath}/admin/show">← Quay về Show</a>
        </p>
    </body>
</html>
