<%@ page import="org.apache.shiro.SecurityUtils" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Start Page</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body>
        <h1>Hello World!</h1>
        <%@ include file="_mesg.jsp"%>
        <hr/>
        <ul>
            <li><a href="/restricted.jsp">RESTRICTED</a>: authentication needs.</li>
            <li><a href="/privileged.jsp">PRIVILEGED</a>: only 'special' roles allowed.</li>
            <li><a href="/logout">LOGOUT</a></li>
        </ul>
    </body>
</html>

