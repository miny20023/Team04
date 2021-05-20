<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "../menu.jsp" %>
<body bgcolor="#f0efea">
<h1>회원 탈퇴</h1>

<form action="myInfoDeletePro.jsp" method="post">
<table>
<tr>
<td>비밀번호:</td>
<td><input type="password" name="pw"/></td>
</tr>
</table><br/>
		 <input type="submit" value="탈퇴"/><br/>
</form>
</body>