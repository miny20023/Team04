<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="recipe.bean.RecipeDAO" %>
<%@ page import="member.bean.MemberDAO" %>
<%@ include file = "../menu.jsp" %>

<% 
	String pageNum = request.getParameter("pageNum");
	int num = Integer.parseInt(request.getParameter("num"));
	String password = request.getParameter("password");
	int status = Integer.parseInt(request.getParameter("status"));
	
	RecipeDAO dao = new RecipeDAO();
	MemberDAO daom = new MemberDAO();

	boolean pwCheck = daom.loginCheck(id, password); 	// 패스워드랑 글번호 받아서 패스워드 확인
	boolean result = false;
	if(pwCheck){
		result = dao.changeRecipeStatus(num, status); 		// 성공시 status 2(승인)로 변경/ 실패시 status 그대로 
	} 
	
	if(result){%>
		<script>
		alert("처리되었습니다.");
		window.location = "recipeContentForm.jsp?num=<%=num%>&pageNum=<%=pageNum%>&random_id=0";
		</script>
<%	}else{%>
		<script>
			alert("관리자 비밀번호와 일치하지 않습니다.");
			history.go(-1);
		</script>
<%}
	
%>