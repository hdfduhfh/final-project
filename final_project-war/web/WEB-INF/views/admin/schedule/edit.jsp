<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>Sửa Lịch chiếu</title>

    <script>
        function validateShowForm() {
            let showID = document.querySelector("select[name='showID']").value.trim();
            let showTime = document.querySelector("input[name='showTime']").value.trim();
            let status = document.querySelector("select[name='status']").value.trim();

            let error = "";

            if (showID === "")
                error += "- Chưa chọn vở diễn<br/>";
            if (showTime === "")
                error += "- Chưa chọn giờ chiếu<br/>";
            if (status === "")
                error += "- Chưa chọn trạng thái<br/>";

            if (error !== "") {
                document.getElementById("clientError").innerHTML = error;
                return false;
            }

            return true;
        }
    </script>
</head>

<body>
<h1>Sửa Lịch chiếu</h1>

<!-- thông báo -->
<c:if test="${not empty globalMessage}">
    <div style="color: red; font-weight: bold">${globalMessage}</div>
</c:if>

<c:if test="${not empty error}">
    <div style="color: red; font-weight: bold">${error}</div>
</c:if>

<div id="clientError" style="color: red; font-weight: bold;"></div>

<c:if test="${schedule == null}">
    <div style="color: red; font-weight: bold;">Không tìm thấy lịch chiếu.</div>
</c:if>

<c:if test="${schedule != null}">

    <fmt:formatDate value="${schedule.showTime}" pattern="yyyy-MM-dd'T'HH:mm" var="showTimeValue"/>

    <form method="post"
          action="${pageContext.request.contextPath}/admin/schedule/edit"
          onsubmit="return validateShowForm();">

        <input type="hidden" name="scheduleID" value="${schedule.scheduleID}"/>

        <p>
            <label>Vở diễn (<span style="color:red">*</span>):</label><br/>
            <select name="showID" style="width: 300px;">
                <option value="">-- Chọn vở diễn --</option>

                <c:forEach var="s" items="${shows}">
                    <option value="${s.showID}"
                            <c:if test="${schedule.show.showID == s.showID}">selected</c:if>>
                        ${s.showName}
                    </option>
                </c:forEach>
            </select>
        </p>

        <p>
            <label>Giờ chiếu (<span style="color:red">*</span>):</label><br/>
            <input type="datetime-local" name="showTime"
                   value="${showTimeValue}" style="width: 220px;"/>
        </p>

        <p>
            <label>Trạng thái (<span style="color:red">*</span>):</label><br/>
            <select name="status" style="width: 220px;">
                <option value="">Chọn trạng thái</option>
                <option value="Active" <c:if test="${schedule.status eq 'Active'}">selected</c:if>>Đang chiếu</option>
                <option value="Inactive" <c:if test="${schedule.status eq 'Inactive'}">selected</c:if>>Sắp chiếu</option>
                <option value="Cancelled" <c:if test="${schedule.status eq 'Cancelled'}">selected</c:if>>Hủy</option>
            </select>
        </p>

        <p>
            <strong>Ngày tạo:</strong>
            <fmt:formatDate value="${schedule.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
        </p>

        <p>
            <button type="submit">Cập nhật lịch chiếu</button>
            <a href="${pageContext.request.contextPath}/admin/schedule">Quay lại danh sách</a>
        </p>

    </form>
</c:if>

</body>
</html>

