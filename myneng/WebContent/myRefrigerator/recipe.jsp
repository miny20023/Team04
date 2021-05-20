<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="recipe.bean.RecipeDTO" %>
<%@ page import="recipe.bean.RecipeDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="cook.bean.CookDAO" %>
<%@ page import="cook.bean.CookDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file = "../menu.jsp" %>
<link href="form.css" rel="stylesheet" type="text/css">
<body bgcolor="#f0efea">
<%
	//인코딩
	request.setCharacterEncoding("UTF-8");	

	//memId 호출
	String memId = (String)session.getAttribute("memId");
	if (memId == null || memId == "") {%>
		<script>
			alert("아이디의 세션이 종료 되어\n로그인 화면으로 돌아갑니다.");
			window.location = "<%=request.getContextPath()%>/menu.jsp";
		</script>
		<%
	}
	
	int random_id = Integer.parseInt(request.getParameter("random_id"));
	if(session.getAttribute("random_id") != null){
		random_id = (int) session.getAttribute("random_id");
	}
	
	int num = Integer.parseInt(request.getParameter("num"));
	String comment_listNum = request.getParameter("comment_listNum");
	
	String url = (String) session.getAttribute("url");
	
	String pageNum = request.getParameter("pageNum");
		
	RecipeDAO dao = new RecipeDAO();
	CookDAO daoc = new CookDAO();
	
	dao.readCount(num);										// 해당 게시물 열람했으므로 조회수 1 증가
	int memberMaster = dao.getMemberMaster(memId);
	RecipeDTO recipe = dao.getRecipes(num);
	
	List <CookDTO> ingList = daoc.getIng(num);  
	boolean scrap = dao.isScrap(id, num);
%>
<div class = "center">
<form name = "f2">
<table>
<tr>
	<td colspan="4">
	<%
		if(recipe.getImage() == null){%>
			사진이 등록되지 않았습니다. <br />
	<% 	}else{%>
			<img src="<%=request.getContextPath()%>/recipeSave/<%=recipe.getImage() %>" /> <br />
	<%	} %>
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
	<td colspan="3">
		<%for(int i = 0; i < ingList.size(); i++){
			CookDTO ing = (CookDTO) ingList.get(i); %>
			<%=ing.getIng_name() %> <%=ing.getAmount() %> <%=ing.getUnit() %> <br />
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
	<td colspan="4" style = "word-break:breakall"><%=recipe.getProcess() %></td>
</tr>
</table>
<input type="button" value="추  천" onclick="javascript:recipeRec();"/>
<%
if (memberMaster == 0 && recipe.getStatus() == 2){
	if(!scrap){%>
		<input type="button" value="  찜  " onclick="javascript:recipeScrap();" />
<%	}else{%>
		<input type="button" value="찜해제" onclick="javascript:recipeScrap();" />
<%	}
}%>
<input type="button" value="목  록" onclick="javascript:recipeReturn();" /><br/>
<input type="hidden" id = "pageNum" name ="pageNum" >
<input type="hidden" id = "num" name ="num" value = "<%=num%>">
<input type="hidden" id = "random_id" name ="random_id" value = "<%=random_id%>">
<input type="hidden" id = "status" name ="status" value = "<%=recipe.getStatus()%>">

<%if(recipe.getStatus() == 2){ %>
	<jsp:include page="comment.jsp" >
		<jsp:param name="num" value="<%=num %>" />  
		<jsp:param name="comment_listNum" value="<%=comment_listNum%>" />
	</jsp:include>
	<jsp:include page="commentWrite.jsp">   
		<jsp:param name="num" value="<%=num%>" />
		<jsp:param name="pageNum" value="<%=pageNum%>" />
		<jsp:param name="comment_listNum" value="<%=comment_listNum%>" />
	</jsp:include>
<%	} %>
</form>
</div>
</body>
<script>
function recipeRec(){
	document.f2.action = "<%=request.getContextPath()%>/recipe/recipeReccPro.jsp";
	document.f2.submit();
}

function recipeScrap(){
	document.f2.action = "recipeScrap.jsp";
	document.f2.submit();
}

function recipeReturn(){
	document.f2.action = "mixList.jsp";
	document.f2.submit();
}
</script>
