<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="recipe.bean.RecipeDAO" %>
<%@ page import="recipe.bean.RecipeDTO" %>
<%@ page import="member.bean.MemberDAO" %>

<% 
	String id = (String) session.getAttribute("memId");

	String pageNum = request.getParameter("pageNum");
	int num = Integer.parseInt(request.getParameter("num"));
	String password = request.getParameter("password");
	int status = Integer.parseInt(request.getParameter("status"));
	 
	RecipeDAO dao = new RecipeDAO();
	MemberDAO daom = new MemberDAO();
	RecipeDTO recipe = dao.getRecipes(num);
	
	String writer = recipe.getWriter();
	int master = dao.getMemberMaster(id);
	boolean result = false;
	if(writer.equals(id) || master == 2){  // 작성한 본인 || 관리자
		boolean pwCheck = daom.loginCheck(id, password); 	// 패스워드랑 글번호 받아서 패스워드 확인
		if(pwCheck){
			result = dao.changeRecipeStatus(num, status); 	// 성공시 status 0으로 변경/ 실패시 status 그대로
		}
	}
	
	if(result){ %>
		<script>
		alert("삭제되었습니다");
		window.location="recipeListForm.jsp";
		</script>
<%	}else{%>
		<script>
			alert("비밀번호를 확인해주세요");
			history.go(-1);
		</script>
<%	}%>