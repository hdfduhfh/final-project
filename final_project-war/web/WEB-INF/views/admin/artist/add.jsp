<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
    <head>
        <title>Thêm nghệ sĩ</title>
    </head>
    <body>

        <h1>Thêm nghệ sĩ</h1>

        <!-- Thông báo tổng -->
        <c:if test="${not empty globalMessage}">
            <div style="color:red; font-weight:bold; margin-bottom:5px;">
                ${globalMessage}
            </div>
        </c:if>
        <!-- Thông báo lỗi cụ thể từ ArtistManagementServlet -->
        <c:if test="${not empty error}">
            <div style="color:red; font-weight:bold; margin-bottom:10px;">
                ${error}
            </div>
        </c:if>

        <form method="post"
              action="${pageContext.request.contextPath}/admin/artist/add"
              novalidate>

            <!-- Tên nghệ sĩ (name) -->
            <p>
                <label>Tên nghệ sĩ (<span style="color:red">*</span>):</label><br/>
                <input type="text"
                       name="name"
                       style="width: 300px;"
                       value="${param.name != null ? param.name : ''}"/>
            </p>

            <!-- Vai trò (role) -->
            <p>
                <label>Vai trò (<span style="color:red">*</span>):</label><br/>
                <input type="text"
                       name="role"
                       style="width: 250px;"
                       value="${param.role != null ? param.role : ''}"/>
            </p>

            <!-- Tiểu sử (bio) -->
            <p>
                <label>Tiểu sử (<span style="color:red">*</span>):</label><br/>
                <textarea name="bio"
                          rows="4"
                          cols="50"
                          style="width: 380px; height: 100px;">${param.bio != null ? param.bio : ''}</textarea>
            </p>

            <!-- Hình ảnh nghệ sĩ: dropdown chọn từ thư mục -->
            <p>
                <label>Hình ảnh nghệ sĩ (<span style="color:red">*</span>):</label><br/>
                <select name="artistImage" style="width: 300px;">
                    <option value="">Chọn hình ảnh nghệ sĩ từ thư mục</option>

                    <c:forEach var="img" items="${imageFiles}">
                        <option value="${img}"
                                <c:if test="${param.artistImage eq img}">selected</c:if>>
                            ${img}
                        </option>
                    </c:forEach>
                </select>
            </p>

            <p>
                <button type="submit">Thêm Nghệ Sĩ</button>
                <a href="${pageContext.request.contextPath}/admin/artist">Quay lại danh sách</a>
            </p>

        </form>

    </body>
</html>
