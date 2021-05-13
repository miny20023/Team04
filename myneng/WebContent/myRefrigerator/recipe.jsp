<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="recipe.bean.RecipeDTO" %>
<%@ page import="recipe.bean.RecipeDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import ="test.model.food.MaNengDBBean" %>
<%@ page import ="test.model.food.MaNengDataBean" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%
	String id = (String) session.getAttribute("memId");

	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
		
	RecipeDAO dao = new RecipeDAO();
	MaNengDBBean mnDB = new MaNengDBBean();
	
	dao.readCount(num);
	int status = dao.getMemberMaster(id);
	RecipeDTO recipe = dao.getRecipes(num);
	
	// 레시피번호 -> cook 테이블에서 재료 번호 찾음 -> 재료 테이블에서 재료 호출 -> 재료 반환
	// 재료id -> 재료이름 / amount / unit <== 리스트로 받아야하나? 
	List <MaNengDataBean> ingList = mnDB.getIngs(num); 
%>
<table>
<tr>
	<td colspan="4">
	<%
		if(recipe.getImage() == null){%>
			사진이 등록되지 않았습니다. <br />
	<% 	} else{%>
			<img src="/MaNeng/save/<%=recipe.getImage()%>" /> <br />
	<%} %>
	</td>
</tr>	
<tr>
	<td>요리명</td>
	<td><%=recipe.getName() %></td>
	<td>작성자</td>
	<td><%=recipe.getWriter() %></td>
						
</tr>
<tr>
	<td>재료</td>
	<td>
		<%for(int i = 0; i < ingList.size(); i++){
			MaNengDataBean ing = (MaNengDataBean) ingList.get(i); %>
			<%=ing.getIngname() %>
			<%=ing.getAmount() %>
			<%=ing.getUnit() %> <br />
		<%} %>
	</td>
</tr>
<tr>
	<td>요리시간</td>
	<td><%=recipe.getCooking_time()%> 분</td>
	<td>요리난이도</td>
	<td><%=recipe.getDifficulty() %></td>
</tr>
<tr>
	<td colspan="4"><%=recipe.getProcess() %></td>
</tr>
</table>
<input type="button" value="목  록" onclick="window.location='mixList.jsp?PageNum=<%=pageNum %>'" />

