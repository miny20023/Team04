<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "cartBoard.BoardDBBean" %>
<%@ page import = "java.sql.Timestamp" %>

<jsp:useBean id = "article" scope = "page" class="cartBoard.BoardDataBean" />
<jsp:setProperty property="*" name="article"/>

<%
	article.setReg_date(new Timestamp(System.currentTimeMillis()) );
	article.setIp(request.getRemoteAddr());
	
	BoardDBBean dbPro = new BoardDBBean();
	dbPro.insertArticle_comment(article,article.getNum());
	
	response.sendRedirect("content.jsp?num="+ article.getNum() +"&pageNum="+ article.getPageNum());
	
%>