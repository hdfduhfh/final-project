<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
    <head>
        <title>Thêm show mới</title>
    </head>
    <body>
        <h1>Thêm show mới</h1>

        <c:if test="${not empty globalMessage}">
            <div style="color: blue; font-weight: bold">${globalMessage}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div style="color: red; font-weight: bold">${error}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/admin/show/add"
              enctype="multipart/form-data" onsubmit="return validateForm();">

            <p>
                <label>Tên vở diễn (*)</label><br/>
                <input type="text" name="showName" value="${param.showName}" required />
            </p>

            <p>
                <label>Mô tả (*)</label><br/>
                <textarea name="description" rows="4" cols="50" required>${param.description}</textarea>
            </p>

            <p>
                <label>Thời lượng (phút) (*)</label><br/>
                <input type="number" name="durationMinutes" min="1" value="${param.durationMinutes}" required />
            </p>

            <p>
                <label>Trạng thái (*)</label><br/>
                <select name="status" required>
                    <option value="">Chọn trạng thái</option>
                    <option value="Active" <c:if test="${param.status=='Active'}">selected</c:if>>Active</option>
                    <option value="Inactive" <c:if test="${param.status=='Inactive'}">selected</c:if>>Inactive</option>
                    <option value="Cancelled" <c:if test="${param.status=='Cancelled'}">selected</c:if>>Cancelled</option>
                    </select>
                </p>

                <p>
                    <label>Nghệ sĩ tham gia (*)</label><br/>
                    <select name="artistIDs" multiple required>
                    <c:forEach var="a" items="${artists}">
                        <option value="${a.artistID}"
                                <c:choose>
                                    <c:when test="${param.artistIDs != null}">
                                        <c:forEach var="pid" items="${param.artistIDs}">
                                            <c:if test="${pid == a.artistID.toString()}">selected</c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:when test="${selectedArtistIDs != null && selectedArtistIDs.contains(a.artistID)}">
                                        selected
                                    </c:when>
                                </c:choose>
                                >
                            ${a.name}
                        </option>
                    </c:forEach>
                </select>
                <small>(Giữ Ctrl để chọn nhiều nghệ sĩ)</small>
            </p>

            <p>
                <label>Hình ảnh (*)</label><br/>
                <select name="showImageDropdown">
                    <option value="">Hoặc chọn từ thư mục</option>
                    <c:forEach var="img" items="${imageFiles}">
                        <option value="${img}">${img}</option>
                    </c:forEach>
                </select>
            </p>

            <button type="submit">Thêm mới</button>
            <a href="${pageContext.request.contextPath}/admin/show">Hủy</a>
        </form>

        <script>
            function validateForm() {
                const name = document.querySelector('input[name="showName"]').value.trim();
                if (!name) {
                    alert('Tên vở diễn không được để trống');
                    return false;
                }
                return true;
            }
        </script>

    </body>
</html>
