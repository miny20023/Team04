<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="diet.bean.DietDTO" %>
<%@ page import="diet.bean.DietDAO" %>
<%@ include file = "../menu.jsp" %>

<%request.setCharacterEncoding("UTF-8");%>
<%
	
	String diet_date = request.getParameter("diet_date");
	//String pageNum = request.getParameter("pageNum");
	//if(pageNum==null){pageNum="1";}

	DietDAO dao = new DietDAO();
	DietDTO diet = dao.getDiet(diet_date,id);
%>

<br /><br /><br /><br />
<%if(id!=null){%>
<!-- 날짜는 수정안됨 -->
<center><h3>식단 내용 수정하기</h3></center>

<form action="dietUpdatePro.jsp?diet_date=<%=diet_date%>" > 
<table  align ="center" border="1" width="400">
	<tr>
		<td colspan="2" align ="center" height="10%">날짜 : <%=diet.getDiet_date()%><input type="hidden" name="diet_date" value="<%=diet.getDiet_date()%>" /></td>
	</tr>	
	<tr>
		<td>아침</td>
		<td><textarea rows="5" cols="40" name="breakfast"><%if(diet.getBreakfast()!=null){%><%=diet.getBreakfast()%><%}%></textarea></td> 		
	</tr>
	<tr>
		<td>점심</td>
		<td><textarea rows="5" cols="40" name="lunch"><%if(diet.getLunch()!=null){%><%=diet.getLunch()%><%}%></textarea></td> 		
	</tr><tr>
		<td>저녁</td>
		<td><textarea rows="5" cols="40" name="dinner"><%if(diet.getDinner()!=null){%><%=diet.getDinner()%><%}%></textarea></td> 		
	</tr>
	<tr>
		<td colspan="2" align="center">
			<input type="submit" value="수정하기"/>
			<input type="button" value="삭제하기" onclick="window.location='dietDeleteForm.jsp?diet_date=<%=diet.getDiet_date()%>'"/>
			<input type="button" value="식단달력" onclick="window.location='dietCalendar.jsp?year=<%=diet.getYear()%>&month=<%=diet.getMonth()%>'"/>	
		</td>
	</tr>
</table>
<%}else{%>
	<script>
		alert("로그인 후 사용 가능합니다");
		window.location='/myneng/login/login.jsp';
		</script>
<%}%>


</form>