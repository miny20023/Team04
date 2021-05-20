<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="diet.bean.DietDTO" %>
<%@ page import="diet.bean.DietDAO" %>
<%@ include file = "../menu.jsp" %>
<body bgcolor="#f0efea">

<%--jsp:include page = "/main/top.jsp" /--%>

<%
	String diet_date = request.getParameter("diet_date");
	DietDAO dao = new DietDAO();
	DietDTO diet = dao.getDiet(diet_date,id);
	
	
%>

<br /><br /><br /><br />

<%if(id!=null){%>
<center><h3><%=diet_date%>일 식단 내용</h3></center>

<table id="viewDay" align ="center" border="1" width="400">
	<tr bgcolor="#d6cabc">
		<td colspan="2" align ="center" height="10%"><%=diet.getDiet_date()%></td>
	</tr>	
	<tr>
		<td height="80" width="35">아침</td>
		<td><%if(diet.getBreakfast()!=null){%><%=diet.getBreakfast()%><%}%></td> 		
	</tr>
	<tr>
		<td height="80">점심</td>
		<td><%if(diet.getLunch()!=null){%><%=diet.getLunch()%><%}%></td> 		
	</tr><tr>
		<td height="80">저녁</td>
		<td><%if(diet.getDinner()!=null){%><%=diet.getDinner()%><%}%></td> 		
	</tr>
	<tr>
		<td colspan="2" align="center">
		<!-- 날짜에맞춰서 월표시되도록 값 넘겨주려면 어떻게? -->
			<input type ="button" value="수정하기" onclick="window.location='dietUpdateForm.jsp?diet_date=<%=diet.getDiet_date()%>'"/>
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
</body>