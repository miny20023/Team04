<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "recipeRequest.comment.CommentDBBean" %>
<%@ page import = "recipeRequest.comment.CommentDataBean" %>
<%@ page import = "java.sql.Timestamp" %>

<% request.setCharacterEncoding("UTF-8");%>
<%
	int num = Integer.parseInt(request.getParameter("num"));
	int listNum = Integer.parseInt(request.getParameter("listNum"));
	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	String id = (String)session.getAttribute("memId");
	int comment_pageNum = Integer.parseInt(request.getParameter("comment_pageNum"));
	
	CommentDBBean dbPro = new CommentDBBean();
	int check = dbPro.deleteArticle_comment(num,listNum, id,pageNum);
	
	if(check==1 || check == 2)
	{
		if(check == 1)
		{
			response.sendRedirect("content.jsp?num="+num+"&pageNum="+pageNum+"&comment_pageNum="+comment_pageNum+"&comment_listNum=0");
		}
		else if(check == 2)
		{
			response.sendRedirect("content.jsp?num="+num+"&pageNum="+pageNum+"&comment_pageNum="+(comment_pageNum-1)+"&comment_listNum=0");
		}
		else
		{
			System.out.println("ERROR");
		}
	}
	else if(check==0)
	{%>
		<script language="JavaScript">
		alert("자신의 글이 아닙니다.");
		history.go(-1);
	</script>
	<%}
	else
	{%>
		<script language="JavaScript">
			alert("삭제 XXX");
			history.go(-1);
		</script>
	<%}
%>