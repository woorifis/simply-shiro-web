<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%-- NOTE: 필드 이름들이 마음에 안들면 shiro.ini에서 변경할 것. --%>
<%-- NOTE: action은 반드시 비워두기. shiro필터가 처리. --%>
<form action="" method="post">
    <input type="text" name="username"/><br/>
    <input type="password" name="password"/><br/>
    <input type="checkbox" name="rememberMe" value="true"/>Remember Me?<br/>     
    <input type="submit"/>
</form>