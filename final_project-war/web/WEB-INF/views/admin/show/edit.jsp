<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>Chỉnh sửa show</title>
</head>
<body>
<h1>Chỉnh sửa show</h1>

<c:if test="${not empty globalMessage}">
    <div style="color: blue; font-weight: bold">${globalMessage}</div>
</c:if>
<c:if test="${not empty error}">
    <div style="color: red; font-weight: bold">${error}</div>
</c:if>

<form method="post" action="${pageContext.request.contextPath}/admin/show/edit"
      enctype="multipart/form-data" onsubmit="return validateForm();">

    <input type="hidden" name="showID" value="${show.showID}" />

    <p>
        <label>Tên vở diễn (*)</label><br/>
        <input type="text" name="showName" value="${show.showName}" required />
    </p>

    <p>
        <label>Mô tả (*)</label><br/>
        <textarea name="description" rows="4" cols="50" required>${show.description}</textarea>
    </p>

    <p>
        <label>Thời lượng (phút) (*)</label><br/>
        <input type="number" name="durationMinutes" min="1" value="${show.durationMinutes}" required />
    </p>

    <p>
        <label>Trạng thái (*)</label><br/>
        <select name="status" required>
            <option value="">Chọn trạng thái</option>
            <option value="Active" <c:if test="${show.status=='Active'}">selected</c:if>>Active</option>
            <option value="Inactive" <c:if test="${show.status=='Inactive'}">selected</c:if>>Inactive</option>
            <option value="Cancelled" <c:if test="${show.status=='Cancelled'}">selected</c:if>>Cancelled</option>
        </select>
    </p>

    <p>
        <label>Nghệ sĩ tham gia (*)</label><br/>
        <select name="artistIDs" multiple size="5">
            <c:forEach var="a" items="${artists}">
                <option value="${a.artistID}" <c:if test="${selectedArtistIDs.contains(a.artistID)}">selected</c:if>>
                    ${a.name}
                </option>
            </c:forEach>
        </select><br/>
        <small>(Giữ Ctrl để chọn nhiều nghệ sĩ)</small>
    </p>

    <p>
        <label>Hình ảnh (*)</label><br/>
        <select name="showImageDropdown">
            <option value="">Hoặc chọn từ thư mục</option>
            <c:forEach var="img" items="${imageFiles}">
                <option value="${img}" <c:if test="${img==show.showImage}">selected</c:if>>${img}</option>
            </c:forEach>
        </select>
        <input type="hidden" name="showImage" value="${show.showImage}" />
    </p>

    <button type="submit">Cập nhật</button>
    <a href="${pageContext.request.contextPath}/admin/show">Hủy</a>
</form>

<script>
function validateForm() {
    const name = document.querySelector('input[name="showName"]').value.trim();
    if (!name) { alert('Tên vở diễn không được để trống'); return false; }
    return true;
}
</script>

</body>
</html>
