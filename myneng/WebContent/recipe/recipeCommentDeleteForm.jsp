<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% 	request.setCharacterEncoding("UTF-8"); 


	String id = (String) session.getAttribute("memId");
	int num = Integer.parseInt(request.getParameter("num"));
	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	int random_id = Integer.parseInt(request.getParameter("random_id"));
	int comment_num = Integer.parseInt(request.getParameter("comment_num"));
%>

<form action="recipeCommentDeletePro.jsp" method="post">
	비밀번호 : <input type="password" name="password" />
			<input type="hidden" name="num" value="<%=num %>" />
			<input type="hidden" name="pageNum" value="<%=pageNum %>" />
			<input type="hidden" name="random_id" value="<%=random_id %>" />
			<input type="hidden" name="comment_num" value="<%=comment_num %>" />
			<input type="submit" value="댓글삭제" /> <br />
			<input type="button" value="돌아가기" onclick="window.close()" />
</form>
