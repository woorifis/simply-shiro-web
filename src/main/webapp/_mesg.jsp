<%@ page import="org.apache.shiro.SecurityUtils" %>
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>

    Hello, <shiro:principal/>, how are you today?
    (Remembered: <%= SecurityUtils.getSubject().isRemembered() %>,
        <shiro:user>USER</shiro:user>
        <shiro:authenticated>AUTHENTICATED</shiro:authenticated>)
