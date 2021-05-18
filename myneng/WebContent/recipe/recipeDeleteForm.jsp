<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "../menu.jsp" %>

<%
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	String status = request.getParameter("status");
	String url = (String) session.getAttribute("url");
%>

<form action="recipeDeletePro.jsp?pageNum=<%=pageNum%>" method="post">
	비밀번호 : <input type="password" name="password" />
			<input type="hidden" name="num" value="<%=num %>" />
			<input type="hidden" name="status" value="<%=status %>" />
			<input type="submit" value="확  인" /> <br />
			<input type="button" value="글목록" onclick="window.location='<%=url %>'" />
</form>