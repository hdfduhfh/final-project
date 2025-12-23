<%-- 
    Document   : ticket-checkin
    Created on : Dec 21, 2025, 4:31:14 PM
    Author     : DANG KHOA
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty message}">
    <p style="color:green">${message}</p>
</c:if>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h2>🎟 Check-in vé</h2>

        <form method="post" action="${pageContext.request.contextPath}/admin/ticket-checkin">
            <input type="text"
                   name="qrCode"
                   placeholder="Nhập hoặc quét QR"
                   autofocus
                   required
                   style="width:300px;padding:8px">

            <button type="submit">Check-in</button>
        </form>

    <c:if test="${not empty message}">
        <p style="color:green">${message}</p>
    </c:if>

    <c:if test="${not empty error}">
        <p style="color:red">${error}</p>
    </c:if>

</body>
</html>
