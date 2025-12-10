<%-- 
    Document   : edit
    Created on : Dec 10, 2025, 10:13:45 AM
    Author     : DANG KHOA
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
    <head>
        <title>Sửa show</title>
    </head>
    <body>
        <h1>Sửa show</h1>

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

        <form method="post"
              action="${pageContext.request.contextPath}/admin/show/edit"
              enctype="multipart/form-data"
              onsubmit="return validateShowForm();" novalidate>
            <p>
                <label>Tên vở diễn (<span style="color:red">*</span>):</label><br/>
                <input type="text" name="showName" style="width: 300px;"
                       value="${param.showName != null ? param.showName : ''}" required/>
            </p>

            <p>
                <label>Mô tả(<span style="color:red">*</span>):</label><br/>
                <textarea name="description" rows="4" cols="50"
                          style="width: 400px; height: 100px;" required>${param.description != null ? param.description : ''}</textarea>
            </p>

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

                <!-- NGHỆ SĨ THAM GIA: dropdown -->
                <p>
                    <label>Nghệ sĩ tham gia vở diễn(<span style="color:red">*</span>):</label><br/>
                    <select name="artistID" style="width: 300px;">
                        <option value="">Chọn nghệ sĩ</option>

                    <c:forEach var="a" items="${artists}">
                        <option value="${a.artistID}"
                                <c:if test="${param.artistID == a.artistID}">selected</c:if>>
                            ${a.name}
                            <c:if test="${not empty a.role}">
                                - ${a.role}
                            </c:if>
                        </option>
                    </c:forEach>
                </select>
            </p>

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
            <button type="submit">Cập nhật</button>
            <a href="${pageContext.request.contextPath}/admin/show?action=list">Hủy</a>
        </form>

    </body>
</html>

