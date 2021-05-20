<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");

	String id = (String) session.getAttribute("memId");
	int num = Integer.parseInt(request.getParameter("num"));
	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	int comment_listNum = Integer.parseInt(request.getParameter("comment_listNum"));
%>

<center>
<form action="commentWritePro.jsp" method="post">
	<textarea rows="5" cols="70" name="comment_text"> </textarea>
	<input type="hidden" name="comment_id" value="<%=id %>" />
	<input type="hidden" name="num" value="<%=num %>" />
	<input type="hidden" name="pageNum" value="<%=pageNum %>" />
	<input type="hidden" name="comment_listNum" value="0" />
	<input type="submit" value="댓글 등록" />
</form>
</center>
