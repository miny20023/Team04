<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="recipe.bean.RecipeDAO" %>
<%@ include file = "../menu.jsp" %>

<% 
	int num = Integer.parseInt(request.getParameter("num"));
   	String pageNum = request.getParameter("pageNum");
	String alert = "";    	
   	RecipeDAO dao = new RecipeDAO();
   	// 찜 버튼을 누르면 -> id_scrap 테이블(id마다 달라짐)에 num(rec_id)를 추가
   	if(!dao.isScrap(id, num)){
   		dao.setScrap(id, num);
		alert = "찜 목록에 추가되었습니다."; 
   	}else{	
		dao.cancleScrap(id, num); 
		alert = "찜 목록에서 제외되었습니다.";	
	}
%>
<script>
var war = "<%=alert%>";
	alert(war);
	window.location = "recipe.jsp?num=<%=num%>&pageNum=<%=pageNum%>&random_id=0&comment_listNum=0";
</script>
