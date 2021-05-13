<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "../menu.jsp" %>
    <body bgcolor="#f0efea">
<h1> 관리자만 접근 가능합니다.</h1>
<%
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	int status = Integer.parseInt(request.getParameter("status"));
%>

<form action="recipeAcceptPro.jsp?pageNum=<%=pageNum%>" method="post">
	관리자 비밀번호 확인 : <input type="password" name="password" />
				<input type="hidden" name="num" value="<%=num %>" />
				<input type="hidden" name="status" value="<%=status %>" />
				<input type="submit" value="승  인" /> <br />
				<input type="button" value="글목록" onclick="window.location='recipeListForm.jsp?PageNum=<%=pageNum %>'" />
</form>
</body>

