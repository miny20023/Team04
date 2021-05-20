<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="member.bean.ScrapDTO" %>
<%@ page import="member.bean.ScrapDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="cook.bean.CookDAO" %>
<%@ page import="cook.bean.CookDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file = "../menu.jsp" %>
<body bgcolor="#f0efea">

<%
	id = (String) session.getAttribute("memId");

	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
		
	ScrapDAO dao = new ScrapDAO(); //ScrapDAO
	CookDAO daoc = new CookDAO();
	
	dao.readCount(num);
	int memberMaster = dao.getMemberMaster(id);
	ScrapDTO recipe = dao.getRecipes(num); //ScrapDTO
	
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

<input type="button" value="찜 목록" onclick="window.location='recipeScrapForm.jsp?PageNum=<%=pageNum %>'" />

</center>
</body>



