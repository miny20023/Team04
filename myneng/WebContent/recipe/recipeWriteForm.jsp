<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="cook.bean.CookDAO" %>
<%@ page import="cook.bean.CookDTO" %>
<%@ page import="java.util.List" %>
<%@ include file = "../menu.jsp" %>
<body bgcolor="#f0efea">
<% 	
	if(session.getAttribute("memId") == null) {%>
		<script>
			alert("로그인을 해주세요");
			history.go(-1);
		</script>
<%	}
	int random_id = 0;
	if(session.getAttribute("random_id") != null){
		random_id = (int) session.getAttribute("random_id");
	} 
	System.out.println("recipeWriteForm의 random_id =" +random_id);
	
	List <CookDTO> ingList = null;
	if(random_id != 0){
		CookDAO daoc = new CookDAO();
		ingList = daoc.getIng(random_id);
	}
%>

<h1 align="center"> 레시피 등록하기 </h1>
<center>
<form name="recipe" action="recipeWritePro.jsp" method="post" enctype="multipart/form-data">
<table border="1" cellpadding="0" cellspacing="0" align="center">
<tr>
	<td colspan="4" align="center">	
		사진<br />		<input type="file" name="image" />
	</td>
</tr>
<tr>
	<td>요리명 </td>
	<td><input type="text" name="name" /> </td>
	<td>작성자 </td>
	<td><%=id %></td>
</tr>
<tr>
	<td>재료</td>
	<td colspan="3">
		<label id="ings_name"></label>
		<input type="button" value="재료입력" onclick="window.open('recipeIngredientUpdateForm.jsp?num=0&random_id=0','재료입력','width=600,height=600')" />
	</td> 
</tr>
<tr>
	<td>요리시간</td>
	<td><input type="number" name="cooking_time" /> 분</td>
	<td>요리난이도</td>
	<td><input type="number" name="difficulty" /> (쉬움 1 ~ 어려움 5)</td>
</tr>
<tr>
	<td colspan="4" align="center">
		조리방법 <br />
		<textarea rows="10" cols="40" name="process" > </textarea>
	</td>
</tr>
</table>
		<input type="submit" value="등록완료" />
		<input type="button" value="등록취소" onclick="window.location='recipeCanclePro.jsp'"/>	
</form>
</center>
</body>