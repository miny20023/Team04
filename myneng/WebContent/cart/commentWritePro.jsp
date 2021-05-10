<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "cartBoardComment.CommentDBBean" %>
<%@ page import = "java.sql.Timestamp" %>

<% request.setCharacterEncoding("UTF-8");%>

<jsp:useBean id="article" scope="page" class="cartBoardComment.CommentDataBean" />
<jsp:setProperty name="article" property="*"/>

<%
	String id = (String)session.getAttribute("memId");
	int num = Integer.parseInt(request.getParameter("num"));
	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	String current_url = request.getParameter("current_url");
	int comment_listNum = Integer.parseInt(request.getParameter("comment_listNum"));
	
    article.setReg_date(new Timestamp(System.currentTimeMillis()) );

   	CommentDBBean dbPro = new CommentDBBean();
   	dbPro.insertArticle_comment(article,comment_listNum);

    response.sendRedirect("content.jsp?num="+num+"&pageNum="+pageNum+"&comment_listNum=0");
%>
