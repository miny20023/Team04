<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "recipeRequest.board.BoardDBBean" %>
<%@ page import = "java.sql.Timestamp" %>
<% request.setCharacterEncoding("UTF-8");%>

<jsp:useBean id="article" scope="page" class="recipeRequest.board.BoardDataBean" />
<jsp:setProperty name="article" property="*"/>

<%
    article.setReg_date(new Timestamp(System.currentTimeMillis()) );
	article.setIp(request.getRemoteAddr());

    BoardDBBean dbPro = new BoardDBBean();
    dbPro.insertArticle(article);

    response.sendRedirect("recipeRequest.jsp");
%>