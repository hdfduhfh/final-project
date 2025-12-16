<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
    <head>
        <title>Thêm vở diễn</title>
    </head>
    <body>
        <h1>Thêm vở diễn</h1>

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
              action="${pageContext.request.contextPath}/admin/show/add"
              enctype="multipart/form-data"
              onsubmit="return validateShowForm();"
              novalidate>

            <!-- Tên show -->
            <p>
                <label>Tên vở diễn (<span style="color:red">*</span>):</label><br/>
                <input type="text" name="showName" style="width: 300px;"
                       value="${param.showName != null ? param.showName : ''}" required/>
            </p>

            <!-- Mô tả -->
            <p>
                <label>Mô tả(<span style="color:red">*</span>):</label><br/>
                <textarea name="description" rows="4" cols="50"
                          style="width: 400px; height: 100px;" required>${param.description != null ? param.description : ''}</textarea>
            </p>

            <!-- Thời lượng -->
            <p>
                <label>Thời lượng (phút)(<span style="color:red">*</span>):</label><br/>
                <input type="number" name="durationMinutes" min="1" style="width: 100px;"
                       value="${param.durationMinutes != null ? param.durationMinutes : ''}" required/>
            </p>

            <!-- TRẠNG THÁI: dropdown -->
            <p>
                <label>Trạng thái(<span style="color:red">*</span>):</label><br/>
                <select name="status" style="width: 220px;">
                    <option value="">Chọn trạng thái</option>

                    <option value="Active"
                            <c:if test="${empty param.status || param.status eq 'Active'}">selected</c:if>>
                                Đang hoạt động (Active)
                            </option>

                            <option value="Inactive"
                            <c:if test="${param.status eq 'Inactive'}">selected</c:if>>
                                Tạm dừng (Inactive)
                            </option>

                            <option value="Cancelled"
                            <c:if test="${param.status eq 'Cancelled'}">selected</c:if>>
                                Hủy (Cancelled)
                            </option>
                    </select>
                </p>

                <!-- ĐẠO DIỄN -->
                <p>
                    <label>Đạo diễn (<span style="color:red">*</span>):</label><br/>

                <div class="multi-select-dropdown"
                     id="directorContainerAdd"
                     style="position: relative; display: inline-block; width: 300px;">

                    <div id="directorDropdownHeaderAdd"
                         onclick="toggleDropdown('directorDropdownListAdd')"
                         style="border: 1px solid #ccc; padding: 5px 8px; cursor: pointer; user-select: none;">
                        <span id="directorSelectedTextAdd">Chọn đạo diễn...</span>
                        <span style="float: right;">▼</span>
                    </div>

                    <div id="directorDropdownListAdd"
                         style="position: absolute; top: 100%; left: 0; right: 0;
                         border: 1px solid #ccc; background: #fff; max-height: 160px;
                         overflow-y: auto; display: none; z-index: 999;">

                    <c:forEach var="d" items="${directors}">
                        <label style="display:block; padding: 3px 6px;">
                            <input type="radio"
                                   name="directorId"
                                   value="${d.artistID}"
                                   data-director-name="${d.name}"
                                   <c:if test="${param.directorId == d.artistID}">checked</c:if>
                                       onchange="updateDirectorSelectedText('directorDropdownListAdd', 'directorSelectedTextAdd')">
                            ${d.name}
                            <c:if test="${not empty d.role}">
                                - ${d.role}
                            </c:if>
                        </label>
                    </c:forEach>

                </div>
            </div>
        </p>



        <!-- NGHỆ SĨ THAM GIA: cho phép chọn nhiều -->
        <p>
            <label>Nghệ sĩ tham gia vở diễn (<span style="color:red">*</span>):</label><br/>

        <div class="multi-select-dropdown"
             id="artistContainerAdd"
             style="position: relative; display: inline-block; width: 300px;">

            <div id="artistDropdownHeaderAdd"
                 onclick="toggleDropdown('artistDropdownListAdd')"
                 style="border: 1px solid #ccc; padding: 5px 8px; cursor: pointer; user-select: none;">
                <span id="artistSelectedTextAdd">Chọn nghệ sĩ...</span>
                <span style="float: right;">▼</span>
            </div>

            <div id="artistDropdownListAdd"
                 style="position: absolute; top: 100%; left: 0; right: 0;
                 border: 1px solid #ccc; background: #fff; max-height: 160px;
                 overflow-y: auto; display: none; z-index: 999;">

                <c:forEach var="a" items="${artists}">
                    <c:set var="checked" value="false"/>

                    <!-- Nếu vừa submit form lỗi, dùng lại giá trị user đã chọn -->
                    <c:if test="${not empty paramValues.artistIds}">
                        <c:forEach var="aid" items="${paramValues.artistIds}">
                            <!-- ✅ FIX: so sánh String (aid) với Integer (a.artistID) bằng == để JSTL tự convert -->
                            <c:if test="${aid == a.artistID}">
                                <c:set var="checked" value="true"/>
                            </c:if>
                        </c:forEach>
                    </c:if>

                    <label style="display: block; padding: 3px 6px;">
                        <input type="checkbox"
                               name="artistIds"
                               value="${a.artistID}"
                               data-artist-name="${a.name}"
                               <c:if test="${checked}">checked</c:if>
                                   onchange="updateArtistSelectedText('artistDropdownListAdd', 'artistSelectedTextAdd')">
                        ${a.name}
                        <c:if test="${not empty a.role}">
                            - ${a.role}
                        </c:if>
                    </label>
                </c:forEach>

            </div>
        </div>
    </p>


    <!-- HÌNH ẢNH: chọn từ thư mục (dropdown) -->
    <p>
        <label>Chọn hình từ thư mục(<span style="color:red">*</span>):</label><br/>
        <select name="showImageDropdown" style="width: 300px;">
            <option value="">Chọn hình ảnh từ thư mục</option>

            <c:forEach var="img" items="${imageFiles}">
                <option value="${img}"
                        <c:if test="${param.showImageDropdown eq img}">selected</c:if>>
                    ${img}
                </option>
            </c:forEach>
        </select>
        <br/>
    </p>

    <p>
        <button type="submit">Tạo vở diễn</button>
        <a href="${pageContext.request.contextPath}/admin/show">Quay lại danh sách</a>
    </p>

</form>

<script>
    function toggleDropdown(listId) {
        var list = document.getElementById(listId);
        if (!list)
            return;
        list.style.display = (list.style.display === "block") ? "none" : "block";
    }

    function updateDirectorSelectedText(listId, textId) {
        var list = document.getElementById(listId);
        var textSpan = document.getElementById(textId);
        if (!list || !textSpan)
            return;

        var checked = list.querySelector("input[name='directorId']:checked");
        if (checked) {
            textSpan.textContent = checked.getAttribute("data-director-name");
        } else {
            textSpan.textContent = "Chọn đạo diễn...";
        }
    }

    // ✅ QUAN TRỌNG: khi load lại trang (submit lỗi)
    window.addEventListener("load", function () {
        updateDirectorSelectedText('directorDropdownListAdd', 'directorSelectedTextAdd');
    });

    // đóng dropdown khi click ra ngoài
    document.addEventListener("click", function (e) {
        var container = document.getElementById("directorContainerAdd");
        var list = document.getElementById("directorDropdownListAdd");
        if (container && list && !container.contains(e.target)) {
            list.style.display = "none";
        }
    });
</script>
<script>
    function toggleDropdown(listId) {
        var list = document.getElementById(listId);
        if (!list)
            return;
        list.style.display = (list.style.display === "block") ? "none" : "block";
    }

    function updateArtistSelectedText(listId, textId) {
        var list = document.getElementById(listId);
        var textSpan = document.getElementById(textId);
        if (!list || !textSpan)
            return;

        var selected = [];
        var checkedBoxes = list.querySelectorAll("input[type='checkbox'][name='artistIds']:checked");
        checkedBoxes.forEach(function (cb) {
            selected.push(cb.getAttribute("data-artist-name"));
        });

        textSpan.textContent = (selected.length > 0) ? selected.join(", ") : "Chọn nghệ sĩ...";
    }

    // ✅ QUAN TRỌNG: load trang (khi submit lỗi) phải tự update text
    window.addEventListener("load", function () {
        updateArtistSelectedText('artistDropdownListAdd', 'artistSelectedTextAdd');
    });

    // ✅ click ngoài -> đóng dropdown
    document.addEventListener("click", function (e) {
        var container = document.getElementById("artistContainerAdd");
        var list = document.getElementById("artistDropdownListAdd");
        if (container && list && !container.contains(e.target)) {
            list.style.display = "none";
        }
    });
</script>

</body>
</html>
