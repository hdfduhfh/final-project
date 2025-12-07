<%-- 
    Document   : dashboard
    Created on : Dec 5, 2025, 2:36:00 PM
    Author     : DANG KHOA
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="mypack.User" %>

<%
    User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
</head>
<body>
    <h1>Xin chào Admin: <%= user.getFullName() %></h1>
    <a href="<%= request.getContextPath() %>/logout">Đăng xuất</a>
</body>
</html>
