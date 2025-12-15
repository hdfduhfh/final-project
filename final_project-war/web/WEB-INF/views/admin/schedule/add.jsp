<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
    <head>
        <title>Thêm Lịch chiếu</title>
    </head>
    <body>
        <h1>Thêm Lịch chiếu</h1>

        <!-- Thông báo tổng -->
        <c:if test="${not empty globalMessage}">
            <div style="color: red; font-weight: bold; margin-bottom: 5px;">
                ${globalMessage}
            </div>
        </c:if>

        <!-- Thông báo lỗi server-side (từ servlet) -->
        <c:if test="${not empty error}">
            <div style="color: red; font-weight: bold; margin-bottom: 10px;">
                ${error}
            </div>
        </c:if>

        <!-- Thông báo lỗi client-side -->
        <div id="clientError" style="color: red; font-weight: bold; margin-bottom: 10px;"></div>

        <!-- Lưu ý: enctype="multipart/form-data" để upload file hình -->
        <form method="post"
              action="${pageContext.request.contextPath}/admin/schedule/add"
              onsubmit="return validateShowForm();" novalidate>

            <!-- Chọn vở diễn -->
            <p>
                <label>Vở diễn (<span style="color:red">*</span>):</label><br/>
                <select name="showID" style="width: 300px;">
                    <option value="">-- Chọn vở diễn --</option>

                    <c:forEach var="s" items="${shows}">
                        <option value="${s.showID}"
                                <c:if test="${param.showID == s.showID}">selected</c:if>>
                            ${s.showName}
                        </option>
                    </c:forEach>
                </select>
            </p>

            <!-- Giờ chiếu -->
            <p>
                <label>Giờ chiếu (<span style="color:red">*</span>):</label><br/>
                <!-- input type="datetime-local" → format gửi lên: yyyy-MM-dd'T'HH:mm -->
                <input type="datetime-local"
                       name="showTime"
                       value="${param.showTime != null ? param.showTime : ''}"
                       style="width: 220px;"
                       required/>
            </p>

            <!-- Trạng thái -->
            <p>
                <label>Trạng thái(<span style="color:red">*</span>):</label><br/>
                <select name="status" style="width: 220px;">
                    <option value="">Chọn trạng thái</option>

                    <option value="Active"
                            <c:if test="${empty param.status || param.status eq 'Active'}">selected</c:if>>
                                Đang chiếu
                            </option>

                            <option value="Inactive"
                            <c:if test="${param.status eq 'Inactive'}">selected</c:if>>
                                Sắp chiếu
                            </option>

                            <option value="Cancelled"
                            <c:if test="${param.status eq 'Cancelled'}">selected</c:if>>
                                Hủy
                            </option>
                    </select>
                </p>


            <p>
                <button type="submit">Lưu lịch chiếu</button>
                <a href="${pageContext.request.contextPath}/admin/schedule">Quay lại danh sách</a>
            </p>

        </form>

    </body>
</html>
