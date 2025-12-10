<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
    <head>
        <title>Sửa Lịch chiếu</title>
    </head>
    <body>
        <h1>Sửa Lịch chiếu</h1>

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
              action="${pageContext.request.contextPath}/admin/schedule/add"
              onsubmit="return validateShowForm();" novalidate>

            <c:if test="${schedule == null}">
                <div style="color: red; font-weight: bold;">
                    Không tìm thấy lịch chiếu.
                </div>
            </c:if>

            <c:if test="${schedule != null}">

                <!-- Format showTime cho input datetime-local -->
                <fmt:formatDate value="${schedule.showTime}"
                                pattern="yyyy-MM-dd'T'HH:mm"
                                var="showTimeValue" />

                <form method="post"
                      action="${pageContext.request.contextPath}/admin/schedule/edit">

                    <!-- ID lịch chiếu (ẩn) -->
                    <input type="hidden" name="scheduleID" value="${schedule.scheduleID}"/>

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
                        <input type="datetime-local"
                               name="showTime"
                               value="${showTimeValue}"
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
                        <!-- Tổng số ghế -->
                        <p>
                            <label>Tổng số ghế (TotalSeats) (<span style="color:red">*</span>):</label><br/>
                            <input type="number"
                                   name="totalSeats"
                                   min="1"
                                   style="width: 100px;"
                                   value="${schedule.totalSeats}"
                            required/>
                    </p>

                    <!-- Số ghế trống -->
                    <p>
                        <label>Số ghế trống (AvailableSeats) (<span style="color:red">*</span>):</label><br/>
                        <input type="number"
                               name="availableSeats"
                               min="0"
                               style="width: 100px;"
                               value="${schedule.availableSeats}"
                               required/>
                    </p>

                    <!-- Thông tin thêm (nếu muốn) -->
                    <p>
                        <strong>Ngày tạo (CreatedAt):</strong>
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
