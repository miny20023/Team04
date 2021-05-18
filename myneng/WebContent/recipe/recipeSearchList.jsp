<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="recipe.bean.RecipeDTO" %>
<%@ page import="recipe.bean.RecipeDAO" %>
<%@ page import="java.net.URLEncoder" %>
<%@ include file = "../menu.jsp" %>
<body bgcolor="#f0efea">
<%
	request.setCharacterEncoding("UTF-8");
	
	String col = request.getParameter("col");
	String search = request.getParameter("search");

	String colUrl = URLEncoder.encode(col, "UTF-8");			// 특수문자 get 방식 보내기 위한 URLEncoding
	String searchUrl = URLEncoder.encode(search, "UTF-8");		// 한글 get 방식 보내기 위한 URLEncoding
	
	int pageSize = 10; 
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null){
		pageNum = "1";
	}
	 
	int currentPage = Integer.parseInt(pageNum);
	int startRow = (currentPage - 1) * pageSize + 1;
	int endRow = currentPage * pageSize; //
	int count = 0; // 전체게시물 수
	int number = 0; // 한 페이지에 보일 글 목록 수
	
	List recipeList = null;
	RecipeDAO dao = new RecipeDAO();
	int master = dao.getMemberMaster(id); 	// 회원권한 조회	
	count = dao.getRecipeCount(col, search, master, id); 			// 작성된 게시글 숫자

	if(count > 0){
		recipeList = dao.getRecipes(col, search, startRow, endRow, master, id);
	}
	
	number = count-(currentPage-1)*pageSize;
%>
	<center> <b>글목록(검색된 글: <%=count %>)</b>
	<table >
		<tr>
			<td >
				<%if(master == 0 || master == 2){ %>
				<input type="button" value="레시피 등록" onclick="window.location='recipeWriteForm.jsp'" />
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
		<input type="button" value="전체목록" onclick="window.location='recipeListForm.jsp?'"/>
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
	    		<a href="recipeContentForm.jsp?num=<%=recipe.getNum()%>&pageNum=<%=currentPage%>&random_id=0&comment_listNum=0">
	    			<%if(recipe.getReccommend() >= 5){%> <font color="red"> ☆<%} %><%=recipe.getName() %>
	    			<%if(recipe.getReccommend() >= 5){%> ★</font> <%} 			// 인기글(추천수 5이상)%><a>
	    			<%if(status == 1 && (recipe.getWriter().equals(id) || master == 2)){ %> 미승인 <%} %>
	    	</td>
	    	<td align="center" width="100"><%=recipe.getWriter() %></td>
	    	<td align="center" width="100"><%=sdf.format(recipe.getDay()) %></td>
	    	<td align="center" width="50"><%=recipe.getReadcount() %></td>
	    	<td align="center" width="50"><%=recipe.getReccommend() %></td>
	
	<%		if(master == 2) {%>
	    	<td align="center" width="50"><input type="checkbox" name="status" <%if(status==2){ %>checked <%} %>/></td>
	    </tr>		
	<%		}
		number--;
		}
    }else{%>
    	<tr><td colspan="10" align="center">검색 결과가 없습니다.</td></tr>
<%  }
    %>
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
				<a href="recipeSearchList.jsp?pageNum=<%=startPage - 10 %>&col=<%=colUrl%>&search=<%=searchUrl%>">[이전]</a>	
<% 			}
			for(int i = startPage; i <= endPage; i++){ %>
				<a href="recipeSearchList.jsp?pageNum=<%=i %>&col=<%=colUrl%>&search=<%=searchUrl%>">[<%= i%>]</a>	
<% 			}
			if(endPage < pageCount){%>
				<a href="recipeSearchList.jsp?pageNum=<%=startPage + 10 %>&col=<%=colUrl%>&search=<%=searchUrl%>">[다음]</a>
<% 			}
		}
	
	%>
	</center>
</body>