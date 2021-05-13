<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="recipe.bean.RecipeDTO" %>
<%@ page import="recipe.bean.RecipeDAO" %>
<%@ include file = "../menu.jsp" %>
<body bgcolor="#f0efea">
<%	
	// 인코딩
	request.setCharacterEncoding("UTF-8");	
	
	// memId 호출
	String memId = (String)session.getAttribute("memId");
	if (memId == null || memId.trim().isEmpty()) {%>
		<script>
			alert("아이디의 세션이 종료 되어서 aaa 계정으로 로그인합니다.");
		</script>
		<%memId = "aaa";
 	}
	
	// random_id 세션 있으면 삭제
	if(session.getAttribute("random_id") != null){
		session.removeAttribute("random_id");			
	}
	
	int pageSize = 10; 
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	// 페이지 유효성 검사
	String pageNum = request.getParameter("pageNum");
	if (pageNum == null || pageNum.trim().isEmpty()) {
        pageNum = "1";
    }
	 
	int currentPage = Integer.parseInt(pageNum);
	int startRow = (currentPage - 1) * pageSize + 1;
	int endRow = currentPage * pageSize; //
	int count = 0; // 전체게시물 수
	int number = 0; // 한 페이지에 보일 글 목록 수
	
	//DAO 선언
	RecipeDAO dao = new RecipeDAO();
	
	// recList 호출
	List recipeList = null;
	List recList = (List) session.getAttribute("recList");
	int master = dao.getMemberMaster(memId); 		// 회원권한 조회
	count = dao.getRecipeCount(recList, master, memId); 	// 작성된 게시글 숫자
	if(count > 0){
		recipeList = dao.getRecipes(recList, startRow, endRow, master, id);
	}
	
	number = count-(currentPage-1)*pageSize;
%>
	<center> <b>글목록(전체 글: <%=count %>)</b>
	<table >
		<tr>
			<td >
				<%if(master == 0 || master == 2){ %>
				<input type="button" value="레시피 등록" onclick="window.location='recipeWriteForm.jsp?random_id=0'" />
				<%} %>
			</td>
		</tr>
	</table>
	<form action="recipeSearchList.jsp" method="post" align="center">
		<select name="col">
			<option value="name||process||writer">전체</option>
			<option value="name">요리명</option>
			<option value="process">요리과정</option>
			<option value="writer">작성자</option>
		</select>
		<input type="text" name="search" />
		<input type="submit" value="검 색" />
	</form>
	
    <table border="1" width="700" cellpadding="0" cellspacing="0" align="center">
    <tr height="30" bgcolor="#d6cabc">
    	<td align="center" width="50">번 호</td>
    	<td align="center" width="300">요리명</td>
    	<td align="center" width="100">작성자</td>
    	<td align="center" width="100">작성일</td>
    	<td align="center" width="50">조 회</td>
    	<td align="center" width="50">추 천</td>
    	<%if(master == 2) {%>
    		<td align="center" width="50">승 인</td>
    	<%} %>
    </tr>

<%
	if(count != 0){
		for(int i = 0; i < recipeList.size(); i++){
			RecipeDTO recipe = (RecipeDTO)recipeList.get(i);
			int status = recipe.getStatus();%>
			<tr>
	    	<td align="center" width="50"><%=number %></td>
	    	<td align="center" width="300">
	    		<a href="recipeContentForm.jsp?num=<%=recipe.getNum()%>&pageNum=<%=currentPage%>&random_id=0">
	    			<%if(recipe.getReccommend() >= 5){%> <font color="red"> ☆<%} %><%=recipe.getName() %>
	    			<%if(recipe.getReccommend() >= 5){%> ★</font> <%} 			// 인기글(추천수 5이상)%><a>
	    			<%if(status == 1 && recipe.getWriter().equals(id)){ %> 미승인 <%} %>
	    	</td>
	    	<td align="center" width="100"><%=recipe.getWriter() %></td>
	    	<td align="center" width="100"><%=recipe.getDay() %></td>
	    	<td align="center" width="50"><%=recipe.getReadcount() %></td>
	    	<td align="center" width="50"><%=recipe.getReccommend() %></td>
	
	<%		if(master == 2) {%>
	    	<td align="center" width="50"><input type="checkbox" name="status" <%if(status==2){ %>checked <%} %>/></td>
	    </tr>		
	<%		}
		number--;
		}
	} else {%>
	    <tr><td colspan="10" align="center">작성된 글이 없습니다.</td></tr>
	
<%	} %>
    </table>
  
	<% 
		if(count > 0){
			int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
			int startPage = (int)(currentPage/10)*10 + 1;
			int pageBlock = 10;
			int endPage = startPage + pageBlock - 1;
			if(endPage > pageCount){
				endPage = pageCount;
			}
			if(startPage > 10){%>
				<a href="recipeListForm.jsp?pageNum=<%=startPage - 10 %>">[이전]</a>	
<% 			}
			for(int i = startPage; i <= endPage; i++){ %>
				<a href="recipeListForm.jsp?pageNum=<%=i %>">[<%= i%>]</a>	
<% 			}
			if(endPage < pageCount){%>
				<a href="recipeListForm.jsp?pageNum=<%=startPage + 10 %>">[다음]</a>
<% 			}
		}
	
	%>
</center>
</body>