<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import = "java.net.URLEncoder" %>
<%@ page import="test.model.food.RecipeDTO" %>
<%@ page import="test.model.food.RecipeDAO" %>
<%@ include file = "../menu.jsp" %>
<link href="form.css" rel="stylesheet" type="text/css">
<body bgcolor="#f0efea">
<%	
	// 인코딩
	request.setCharacterEncoding("UTF-8");	
	
	// memId 호출
	String memId = (String)session.getAttribute("memId");
	if (memId == null || memId == "") {%>
		<script>
			alert("아이디의 세션이 종료 되어\n로그인 화면으로 돌아갑니다.");
			window.location = "<%=request.getContextPath()%>/menu.jsp";
		</script>
		<%
	}
	
	// 검색 컬럼 가져오기
	String col = request.getParameter("col");
	System.out.println("col 값 : "+col);
	
	//search 값 가져오기
	String search = request.getParameter("search");
	String se = "";
	System.out.println("search 값 : "+search);
	
	// random_id 세션 있으면 삭제
	if(session.getAttribute("random_id") != null){
		session.removeAttribute("random_id");			
	}
	
	int pageSize = 10; 
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	// 페이지 유효성 검사
	String pageNum = request.getParameter("pageNum");
	if (pageNum == null || pageNum == "") {
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
	List<RecipeDTO> recipeList = null;
	List<Integer> recList = (List) session.getAttribute("recList");
	int master = dao.getMemberMaster(memId); 		// 회원권한 조회
	if (recList == null) {%>
		<script>
			alert("입력이 잘못 되었습니다! 해당 담당자에게 문의해주세요!");
			window.history.go(-1);
		</script>
	<%
	}else{
		if(search == null || search.trim().isEmpty() || search.equals("null")){%>
		<script>
			alert("검색어가 입력되지 않았습니다.");
		</script>
		<%
			count = dao.getRecipeCount(recList, col, search, master, memId); 	// 작성된 게시글 숫자
			if(count > 0){
				recipeList = dao.getRecipes(recList, col, startRow, endRow, master, id);
			}
		}else{
			se = URLEncoder.encode(search, "UTF-8");
			count = dao.getRecipeCount(recList, col, search, master, memId); 	// 작성된 게시글 숫자
			if(count > 0){
				recipeList = dao.getRecipes(recList, col, search, startRow, endRow, master, id);
			}
		}
	}
	
	number = count-(currentPage-1)*pageSize;
%>
<input type = "hidden" id = "setCol" value = "<%=col%>">
<input type = "hidden" id = "setSearch" value = "<%=search%>">
<div class = "center">
<form name="f2" action="mixListSearch.jsp" method="post" >
	<select id = "col" name="col">
		<option value="name||process||writer">전체</option>
		<option value="name">요리명</option>
		<option value="process">요리과정</option>
		<option value="writer">작성자</option>
	</select>
	<input type="hidden" id="search" name="search">
	<input type="text" id="keyword" /><input type="submit" value="검색" onclick="javascript:goSearch()"><br/>
<table>
<tr>
	<td >번 호</td>
	<td >요리명</td>
	<td >작성자</td>
	<td >작성일</td>
	<td >조 회</td>
	<td >추 천</td>
	<%if(master == 2) {%>
		<td >승 인</td>
	<%}%>
</tr>
<%
for(int i = 0; i < recipeList.size(); i++){
	RecipeDTO recipe = (RecipeDTO)recipeList.get(i);
	int status = recipe.getStatus();%>
<tr>
  	<td>
  	<%=number%>
  	</td>
	<td >
	<a href="javascript:goRecipe(<%=recipe.getNum()%>);">
<%	if(recipe.getReccommend() >= 5){%> 
		<font color="red"> ☆
<%	}%>
	<%=recipe.getName() %>
<%	if(recipe.getReccommend() >= 5){%> 
		★</font></a>
<%	}%>
</td>
<td ><%=recipe.getWriter() %></td>
<td ><%=recipe.getDay() %></td>
<td ><%=recipe.getReadcount() %></td>
<td ><%=recipe.getReccommend() %></td>
<%	number --;
}%>
</table>
<%
if (count > 0) {
	int pageCount = count / pageSize + ( count % pageSize == 0 ? 0 : 1);
	int startPage = (int)(currentPage/10)*10+1;
	int pageBlock = 10;
	int endPage = startPage + pageBlock-1;
	if (endPage > pageCount) {
		endPage = pageCount;
	}      
	if (startPage > 10) {%>
		<a href="javascript:page(<%= startPage - 10 %>);">[이전]</a>
<%	}
	for (int i = startPage ; i <= endPage ; i++) {  %>
		<a href="javascript:page(<%=i%>);">[<%=i%>]</a>
<%	}
	if (endPage < pageCount) {%>
		<a href="javascript:page(<%= startPage + 10 %>);">[다음]</a>
	<%}
}%>
<input type="hidden" id="comment_listNum" name="comment_listNum">
<input type="hidden" id="currentPage" name="currentPage" value = "<%=currentPage%>">
<input type="hidden" id="pageNum" name="pageNum" value = "<%=pageNum%>">
<input type="hidden" id="num" name="num">
<input type="hidden" id="random_id" name="random_id">
</form>
</div>
</body>
<script>
var search = document.getElementById("setSearch").value;
var setCol = document.getElementById("setCol").value;

if(search != null){
	document.getElementById("keyword").value = search;
	document.getElementById("search").value = search;
}

for(let j = 0; j < document.getElementById("col").length; j++){
	if(document.getElementById("col")[j].value == setCol){
		document.getElementById("col")[j].selected = true;
	}
}

function goSearch(){
	var key = document.getElementById("keyword").value;
	
	document.getElementById("search").value = key;
	
	if(key == null || key == ""){
		alert("검색어가 입력되지 않았습니다!")
		document.f2.action = "mixList.jsp";
		document.f2.submit();
	}
}

function page(pageNum){
	document.f2.action = "mixListSearch.jsp";
	document.getElementById("pageNum").value = pageNum;
	document.f2.submit();
}

function goRecipe (recipeNum){
	document.f2.action = "recipe.jsp";
	document.getElementById("random_id").value = "0";
	document.getElementById("num").value = recipeNum;
	document.getElementById("comment_listNum").value = "0"
	document.f2.submit();
}
</script>