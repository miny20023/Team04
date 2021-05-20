<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="recipe.bean.RecipeCommentDAO" %>
<%@ page import="java.sql.Timestamp" %>

    
<% request.setCharacterEncoding("UTF-8");%>

<jsp:useBean id="recipeComment" class="recipe.bean.RecipeCommentDTO" />
<jsp:setProperty name="recipeComment" property="*" />

<% 
	System.out.println("여기는 되니?");
	String id = (String) session.getAttribute("memId");
	int num = Integer.parseInt(request.getParameter("num"));
	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	int comment_listNum = Integer.parseInt(request.getParameter("comment_listNum"));
	
	recipeComment.setReg_date(new Timestamp(System.currentTimeMillis()));
	String alert = "댓글을 입력해주세요.";
	
	RecipeCommentDAO daorc = new RecipeCommentDAO();
	if(!recipeComment.getComment_text().equals(" ")){
		if(comment_listNum == 0){
			daorc.insertRecipeComment(recipeComment);
		}else{
			int comment_num = Integer.parseInt(request.getParameter("comment_num"));
			daorc.insertRecipeComment(recipeComment, comment_num);
		}
		alert = "댓글이 입력되었습니다.";
	}
%>
<script>
	alert('<%=alert%>');
	window.location="recipe.jsp?pageNum=<%=pageNum%>&num=<%=num%>&random_id=0&comment_listNum=0";
</script>