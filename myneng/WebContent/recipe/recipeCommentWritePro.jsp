<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="recipe.bean.RecipeCommentDAO" %>
<%@ page import="java.sql.Timestamp" %>

    
<% request.setCharacterEncoding("UTF-8");%>

<jsp:useBean id="recipeComment" class="recipe.bean.RecipeCommentDTO" />
<jsp:setProperty name="recipeComment" property="*" />

<% 
	String id = (String) session.getAttribute("memId");
	int num = Integer.parseInt(request.getParameter("num"));
	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	String current_url = request.getParameter("current_url");
	int comment_listNum = Integer.parseInt(request.getParameter("comment_listNum"));
	System.out.println("recipeCommentWritePro의 comment_listNum = "+comment_listNum);
	
	recipeComment.setReg_date(new Timestamp(System.currentTimeMillis()));
	
	RecipeCommentDAO daorc = new RecipeCommentDAO();
	if(comment_listNum == 0){
		daorc.insertRecipeComment(recipeComment);
	}else{
		int comment_num = Integer.parseInt(request.getParameter("comment_num"));
		daorc.insertRecipeComment(recipeComment, comment_num);
	}
	
	
%>
<script>
	window.location="recipeContentForm.jsp?pageNum=<%=pageNum%>&num=<%=num%>&random_id=0&comment_listNum=0";
</script>