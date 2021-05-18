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
<body bgcolor="#f0efea">
<%
if(session.getAttribute("memId") != null){
 
	int num = Integer.parseInt(request.getParameter("num"));
	int random_id = Integer.parseInt(request.getParameter("random_id"));
	String comment_listNum = request.getParameter("comment_listNum");
	if(session.getAttribute("random_id") != null){
		random_id = (int) session.getAttribute("random_id");
	}
	System.out.println("recipeContentForm의 random_id =" +random_id);
	System.out.println("recipeContentForm의 comment_listNum =" +comment_listNum);
	
	String pageNum = request.getParameter("pageNum");
	String url = (String) session.getAttribute("url");
	System.out.println("url = "+url);
	
	RecipeDAO dao = new RecipeDAO();
	CookDAO daoc = new CookDAO();
	
	dao.readCount(num);
	int memberMaster = dao.getMemberMaster(id);
	RecipeDTO recipe = dao.getRecipes(num);
	
	// 레시피번호 -> cook 테이블에서 재료 번호 찾음 -> 재료 테이블에서 재료 호출 -> 재료 반환
	List <CookDTO> ingList = daoc.getIng(num); 
%>
<center>
<table border="1" cellpadding="0" cellspacing="0" align="center">
<tr>
	<td colspan="4" align="center">
	<%
		if(recipe.getImage() == null){%>
			사진이 등록되지 않았습니다. <br />
	<% 	} else{%>
			<img src="/myneng/recipeSave/<%=recipe.getImage() %>" /> <br />
	<%	} %>
	</td>
</tr>	
<tr>
	<td align="center">요리명</td>
	<td align="center"><%=recipe.getName() %></td>
	<td align="center">작성자</td>
	<td align="center"><%=recipe.getWriter() %></td>
						
</tr>
<tr>
	<td align="center">재료</td>
	<td colspan="3" align="center">
		<%for(int i = 0; i < ingList.size(); i++){
			CookDTO ing = (CookDTO) ingList.get(i); %>
			<%=ing.getIng_name() %> <%=ing.getAmount() %> <%=ing.getUnit() %> <br />
		<%} %>
	</td>
</tr>
<tr>
	<td align="center">요리시간</td>
	<td align="center"><%=recipe.getCooking_time()%> 분</td>
	<td align="center">요리난이도</td>
	<td align="center"><%=recipe.getDifficulty() %></td>
</tr>
<tr>
	<td colspan="4"><%=recipe.getProcess().replaceAll("\n", "<br />") %></td>
</tr>
</table>
<%	if(id.equals(recipe.getWriter()) && recipe.getStatus() != 0){%>
		<input type="button" value="수  정" onclick="window.location='recipeUpdateForm.jsp?pageNum=<%=pageNum%>&num=<%=num%>&random_id=0'"/>
	<%} else{
		if(recipe.getStatus() != 0){%>
			<input type="button" value="추  천" onclick="window.location='recipeReccPro.jsp?num=<%=num%>'"/>
<%		}
	} %>
<%	if((id.equals(recipe.getWriter()) || memberMaster == 2) && recipe.getStatus() != 0){ %>
		<input type="button" value="삭  제" onclick="window.location='recipeDeleteForm.jsp?pageNum=<%=pageNum%>&num=<%=num%>&status=0'"/>
<% }%>
<%	if(memberMaster == 2){ 
		if(recipe.getStatus() == 0){%>
			<input type="button" value="삭제취소" onclick="window.location='recipeDeleteForm.jsp?pageNum=<%=pageNum%>&num=<%=num%>&status=1'"/>
<%		}%>
<%		if(recipe.getStatus() == 1){%>
			<input type="button" value="승  인" onclick="window.location='recipeAcceptForm.jsp?pageNum=<%=pageNum%>&num=<%=num%>&status=2'" />
<% 		} else if(recipe.getStatus() == 2){%>
			<input type="button" value="승인취소" onclick="window.location='recipeAcceptForm.jsp?pageNum=<%=pageNum%>&num=<%=num%>&status=1'" />
<%		} %>	
<%	} else if (memberMaster == 0 && recipe.getStatus() == 2){
		if(!dao.isScrap(id, num)){%>
			<input type="button" value="  찜  " onclick="window.location='recipeScrapPro.jsp?pageNum=<%=pageNum%>&num=<%=num%>'" />
		<%}else{ %>
			<input type="button" value="찜해제" onclick="window.location='recipeScrapPro.jsp?pageNum=<%=pageNum%>&num=<%=num%>'" />
<%		}
	} %>

<input type="button" value="목  록" onclick="window.location='<%=url %>'" />

<%	if(recipe.getStatus() == 2){ %>
	<jsp:include page="recipeCommentList.jsp" >
		<jsp:param name="num" value="<%=num %>" />
		<jsp:param name="comment_listNum" value="<%=comment_listNum %>" />
	</jsp:include>
	
	<jsp:include page = "recipeCommentWriteForm.jsp">
		<jsp:param name="num" value="<%=num %>" />
		<jsp:param name="pageNum" value="<%=pageNum %>" />
		<jsp:param name="comment_listNum" value="<%=comment_listNum %>" />
	</jsp:include>
<%	} %>
</center>
<%}else{ %>
	<script>
		alert("로그인을 해주세요");
		history.go(-1);
	</script>
<%} %>

<script>
	function historyBack(){
		location.reload();
		history.go(-1);
	}
</script>
</body>




