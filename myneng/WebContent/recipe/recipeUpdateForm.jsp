<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="recipe.bean.RecipeDTO" %>
<%@ page import="recipe.bean.RecipeDAO" %>
<%@ page import="cook.bean.CookDAO" %>
<%@ page import="cook.bean.CookDTO" %>
<%@ page import="java.util.List" %>
<%@ include file = "../menu.jsp" %>
<body bgcolor="#f0efea">
<% 
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	int random_id = Integer.parseInt(request.getParameter("random_id"));
	if (session.getAttribute("random_id") != null){
		random_id = (int) session.getAttribute("random_id");
	}
	System.out.println("recipeUpdateForm의 random_id = "+random_id);
	
	RecipeDAO dao = new RecipeDAO();
	CookDAO daoc = new CookDAO();
	
	RecipeDTO recipe = dao.getRecipes(num);
	List <CookDTO> ingList = daoc.getIng(num);
	
%>
 
<center>
<form action="recipeUpdatePro.jsp?pageNum=<%=pageNum%>&num=<%=num%>&random_id=<%=random_id %>&conmment_listNum=0" method="post" enctype="multipart/form-data">
<table border="1" cellpadding="0" cellspacing="0" align="center">
<tr>
	<td colspan="4" align="center">
	<%
		if(recipe.getImage() == null){%>
			사진이 등록되지 않았습니다. <br />
	<% 	} else{%>
			<img src="/maneng/recipeSave/<%=recipe.getImage() %>" /> <br />
	<%	} %>
		<input type="file" name="image" /><br />

	</td>
</tr>	
<tr>
	<td align="center">요리명</td>
	<td align="center">
		<input type="text" name="name" value="<%=recipe.getName() %>" /></td>
	<td align="center">작성자</td>
	<td align="center">
		<%=recipe.getWriter() %>
	</td>
</tr>
<tr>
	<td align="center">재료</td>
	<td colspan="3" align="center">
	기존 입력 재료: <%for(int i = 0; i < ingList.size(); i++){
				CookDTO ing = (CookDTO) ingList.get(i); %>
				<%=ing.getIng_name()+" " %> 
			<%} %><br />
	재료 수정 확인 : <label id="ings_name"></label> <br />
		<input type="button" value="재료수정" onclick="window.open('recipeIngredientUpdateForm.jsp?num=<%=num %>&random_id=<%=random_id %>','재료입력','width=600,height=600')"/>
	</td>
</tr>
<tr>
	<td align="center">요리시간</td>
	<td align="center">
		<input type="text" name="cooking_time" value="<%=recipe.getCooking_time()%>" /> 분</td>
	<td align="center">요리난이도</td>
	<td align="center">
		<input type="text" name="difficulty" value="<%=recipe.getDifficulty() %>" /></td>
</tr>
<tr>
	<td colspan="4" align="center">
		<textarea rows="10" cols="40" name="process"><%=recipe.getProcess() %> </textarea>
	</td>
</tr>
</table>
<input type="submit" value="수  정" />
<input type="button" value="수정취소" onclick="window.location='recipeCanclePro.jsp'" />
<input type="button" value="목  록" onclick="window.location='recipeListForm.jsp?PageNum=<%=pageNum %>'" />
</form>
</center>
</body>