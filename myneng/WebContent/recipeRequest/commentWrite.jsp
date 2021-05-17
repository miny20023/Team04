<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="color.jsp"%>
<html>
<link href="style.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="script.js"></script>   

<%
	request.setCharacterEncoding("UTF-8");
	int comment_listNum = Integer.parseInt(request.getParameter("comment_listNum"));
	int num = Integer.parseInt(request.getParameter("num"));
	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	String current_url = request.getParameter("current_url");
	String id = (String)session.getAttribute("memId");
	if(id==null)
	{%>
		<script>
			alert("로그인 후 글쓰기 가능합니다...!!");
			window.location='recipeRequest.jsp';
		</script>
	<%}
%>



<body bgcolor="<%=bodyback_c%>"> 
<form method="post" name="comment_content" action="commentWritePro.jsp" onsubmit="return writeSave()">
<input type="hidden" name="comment_id" value="<%=id %>"><%=id %>
<input type="hidden" name="num" value="<%=num %>">
<input type="hidden" name="current_url" value ="<%=current_url %>">
<input type="hidden" name="pageNum" value="<%=pageNum %>">
<input type="hidden" name="comment_listNum" value="0">
<textarea cols = "70" rows "10" name="comment_text"></textarea>
<input type="submit" value="댓글 등록"></br>
</form>
</body>
</html>