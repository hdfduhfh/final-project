<%-- 
    Document   : edit
    Created on : Dec 10, 2025, 10:10:03 AM
    Author     : gpt plus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cập nhật Show</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f4f4f4;
                margin: 0;
                padding: 0;
            }
            .container {
                width: 600px;
                margin: 30px auto;
                background: #fff;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            h1 {
                text-align: center;
                margin-bottom: 20px;
            }
            label {
                font-weight: bold;
            }
            input[type="text"], input[type="number"], select, textarea {
                padding: 6px;
                border-radius: 4px;
                border: 1px solid #ccc;
            }
            button {
                padding: 8px 14px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                background: #2e89ff;
                color: white;
                font-weight: bold;
                margin-right: 10px;
            }
            a {
                text-decoration: none;
                color: #444;
                font-weight: bold;
            }
            .dropdown-container {
                position: relative;
                display: inline-block;
                width: 400px;
            }
            .dropdown-header {
                border: 1px solid #ccc;
                border-radius: 4px;
                padding: 8px;
                cursor: pointer;
                background: #fff;
                user-select: none;
            }
            .dropdown-list {
                position: absolute;
                z-index: 999;
                border: 1px solid #ccc;
                border-radius: 4px;
                background: white;
                max-height: 200px;
                overflow-y: auto;
                width: 100%;
                display: none;
                padding: 8px;
            }
            table, th, td {
                border: 1px solid #ddd;
            }

            /* giữ nguyên style multi-select cũ của bạn */
            .multi-select-dropdown {
                position: relative;
                display: inline-block;
                width: 300px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Cập nhật Show</h1>

            <!-- Thông báo lỗi server-side -->
            <c:if test="${not empty globalMessage}">
                <div style="color: red; font-weight: bold; margin-bottom: 10px;">
                    ${globalMessage}
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div style="color: red; font-weight: bold; margin-bottom: 10px;">
                    ${error}
                </div>
            </c:if>

            <!-- Thông báo lỗi client-side -->
            <div id="clientError" style="color: red; font-weight: bold; margin-bottom: 10px;"></div>

            <div id="clientErrors"
                 style="display:none;
                 margin:12px 0;
                 padding:12px;
                 border:1px solid #dc3545;
                 background:#fff5f5;
                 border-radius:6px;">
                <strong style="color:#dc3545;">Vui lòng kiểm tra:</strong>
                <ul id="clientErrorsList"
                    style="margin:6px 0 0 18px; color:#dc3545;"></ul>
            </div>


            <form method="post"
                  action="${pageContext.request.contextPath}/admin/show/edit"
                  enctype="multipart/form-data"
                  onsubmit="return validateShowForm();" novalidate>

                <!-- BẮT BUỘC: gửi showID về servlet để update -->
                <input type="hidden" name="showID" value="${show.showID}" />

                <p>
                    <label>Tên vở diễn (<span style="color:red">*</span>):</label><br/>
                    <input type="text" name="showName" style="width: 300px;"
                           value="${not empty param.showName ? param.showName : show.showName}" required/>
                </p>

                <p>
                    <label>Mô tả(<span style="color:red">*</span>):</label><br/>
                    <textarea name="description" rows="4" cols="50"
                              style="width: 400px; height: 100px;" required>${not empty param.description ? param.description : show.description}</textarea>
                </p>

                <p>
                    <label>Thời lượng (phút)(<span style="color:red">*</span>):</label><br/>
                    <input type="number" name="durationMinutes" min="1" style="width: 100px;"
                           value="${not empty param.durationMinutes ? param.durationMinutes : show.durationMinutes}" required/>
                </p>

                <p>
                    <label>Trạng thái(<span style="color:red">*</span>):</label><br/>
                    <c:set var="currentStatus"
                           value="${not empty param.status ? param.status : show.status}" />

                    <select name="status" style="width: 220px;">
                        <option value="">Chọn trạng thái</option>

                        <option value="Active"
                                <c:if test="${currentStatus eq 'Active'}">selected</c:if>>
                                    Đang hoạt động (Active)
                                </option>

                                <option value="Inactive"
                                <c:if test="${currentStatus eq 'Inactive'}">selected</c:if>>
                                    Tạm dừng (Inactive)
                                </option>

                                <option value="Cancelled"
                                <c:if test="${currentStatus eq 'Cancelled'}">selected</c:if>>
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
                            <c:set var="directorChecked" value="false"/>

                            <!-- Ưu tiên param khi submit lỗi -->
                            <c:if test="${not empty param.directorId}">
                                <c:if test="${param.directorId == d.artistID}">
                                    <c:set var="directorChecked" value="true"/>
                                </c:if>
                            </c:if>

                            <!-- Nếu không có param -> tick theo DB (selectedDirectorId) -->
                            <c:if test="${empty param.directorId and not empty selectedDirectorId}">
                                <c:if test="${selectedDirectorId == d.artistID}">
                                    <c:set var="directorChecked" value="true"/>
                                </c:if>
                            </c:if>

                            <label style="display:block; padding: 3px 6px;">
                                <input type="radio"
                                       name="directorId"
                                       value="${d.artistID}"
                                       data-director-name="${d.name}"
                                       <c:if test="${directorChecked}">checked</c:if>
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

                            <!-- Ưu tiên paramValues khi submit lỗi -->
                            <c:if test="${not empty paramValues.artistIds}">
                                <c:forEach var="aid" items="${paramValues.artistIds}">
                                    <c:if test="${aid == a.artistID}">
                                        <c:set var="checked" value="true"/>
                                    </c:if>
                                </c:forEach>
                            </c:if>

                            <!-- Nếu không có paramValues -> tick theo DB (selectedArtistIds) -->
                            <c:if test="${empty paramValues.artistIds and not empty selectedArtistIds}">
                                <c:forEach var="aidDb" items="${selectedArtistIds}">
                                    <c:if test="${aidDb == a.artistID}">
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


                <p>
                    <label>Poster hiện tại:</label><br/>
                    <c:if test="${not empty show.showImage}">
                        <img src="${pageContext.request.contextPath}/${show.showImage}"
                             alt="Poster"
                             style="max-width: 220px; border: 1px solid #ddd; padding: 4px; border-radius: 6px;"/>
                        <br/><small>${show.showImage}</small>
                    </c:if>
                </p>

                <p>
                    <label>Chọn hình từ thư mục(<span style="color:red">*</span>):</label><br/>

                    <c:set var="currentImage"
                           value="${not empty param.showImageDropdown ? param.showImageDropdown : show.showImage}" />

                    <select name="showImageDropdown" style="width: 300px;">
                        <option value="">Chọn hình ảnh từ thư mục</option>

                        <c:forEach var="img" items="${imageFiles}">
                            <option value="${img}"
                                    <c:if test="${img eq currentImage}">selected</c:if>>
                                ${img}
                            </option>
                        </c:forEach>
                    </select>
                    <br/>
                </p>

                <button type="submit">Cập nhật</button>
                <a href="${pageContext.request.contextPath}/admin/show">Hủy</a>
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
        </div>
    </body>
</html>
