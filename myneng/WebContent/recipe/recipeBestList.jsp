<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="recipe.bean.RecipeDTO" %>
<%@ page import="recipe.bean.RecipeDAO" %>
<%@ include file = "../menu.jsp" %>

<%
	int pageSize = 10; 
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null){
		pageNum = "1";
	} 
	
	int currentPage = Integer.parseInt(pageNum);
	int number = 5; // 한 페이지에 보일 글 목록 수
	
	List recipeList = null;
	RecipeDAO dao = new RecipeDAO();
	recipeList = dao.getBestRecipes(number);

%>
	<center> <b>인기레시피</b>
    <table border="1" width="700" cellpadding="0" cellspacing="0" align="center">
    <tr height="30">
    	<td align="center" width="50">번 호</td>
    	<td align="center" width="300">요리명</td>
    	<td align="center" width="100">작성자</td>
    	<td align="center" width="100">작성일</td>
    	<td align="center" width="50">조 회</td>
    	<td align="center" width="50">추 천</td>
    </tr>

<%
	for(int i = 0; i < recipeList.size(); i++){
		RecipeDTO recipe = (RecipeDTO)recipeList.get(i);
		int status = recipe.getStatus();%>
		<tr>
	    <td align="center" width="50"><%=number %></td>
	    <td align="center" width="300">
	    	<a href="recipeContentForm.jsp?num=<%=recipe.getNum()%>&pageNum=<%=currentPage%>&random_id=0&comment_listNum=0">
	    		<%if(recipe.getReccommend() >= 5){%> <font color="red"> ☆<%} %><%=recipe.getName() %>
	    		<%if(recipe.getReccommend() >= 5){%> ★</font> <%} 			// 인기글(추천수 5이상)%><a>
	   	</td>
	   	<td align="center" width="100"><%=recipe.getWriter() %></td>
	   	<td align="center" width="100"><%=recipe.getDay() %></td>
	   	<td align="center" width="50"><%=recipe.getReadcount() %></td>
	   	<td align="center" width="50"><%=recipe.getReccommend() %></td>
<%		number--;
		}%>
		
    </table>
	</center>
	