<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Start Page</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body>
        <h1>PRIVILEGED: Hello World!</h1>
        <%@ include file="_mesg.jsp"%>
        <a href="/index.jsp">INDEX</a>
    </body>
</html>
