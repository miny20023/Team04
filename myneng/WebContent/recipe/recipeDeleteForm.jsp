<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "../menu.jsp" %>

<%
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
%>

<form action="recipeDeletePro.jsp?pageNum=<%=pageNum%>" method="post">
	비밀번호 : <input type="password" name="password" />
			<input type="hidden" name="num" value="<%=num %>" />
			<input type="hidden" name="status" value="0" />
			<input type="submit" value="삭  제" /> <br />
			<input type="button" value="글목록" onclick="window.location='recipeListForm.jsp?PageNum=<%=pageNum %>'" />
</form>