<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "shoppingInfoShare.comment.CommentDBBean" %>
<%@ page import = "java.sql.Timestamp" %>

<% request.setCharacterEncoding("UTF-8");%>

<jsp:useBean id="article" scope="page" class="shoppingInfoShare.comment.CommentDataBean" />
<jsp:setProperty name="article" property="*"/>

<%
if(String.valueOf(article.getComment_text()).equals("null"))
{%>
	<script>
	alert("내용을 입력해주세요");
	window.history.back();
	</script>
<%}
else
{
	String id = (String)session.getAttribute("memId");
	int num = Integer.parseInt(request.getParameter("num"));
	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	String current_url = request.getParameter("current_url");
	int comment_listNum = Integer.parseInt(request.getParameter("comment_listNum"));
	
	
    article.setReg_date(new Timestamp(System.currentTimeMillis()) );

   	CommentDBBean dbPro = new CommentDBBean();
   	int return_comment_pageNum = dbPro.insertArticle_comment(article,comment_listNum);
   	if(return_comment_pageNum%10 ==0)
   	{
   		return_comment_pageNum = return_comment_pageNum/10;
   	}
   	else
   	{
   		return_comment_pageNum = (return_comment_pageNum/10)+1;
   	}

    response.sendRedirect("content.jsp?num="+num+"&pageNum="+pageNum+"&comment_pageNum="+return_comment_pageNum+"&comment_listNum=0");
}
%>
