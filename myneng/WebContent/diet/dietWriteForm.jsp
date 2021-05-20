<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "../menu.jsp" %>
<body bgcolor="#f0efea">
<%	

 String diet_date = (String)request.getParameter("diet_date");		
	String year =null;
	String month=null;
if(diet_date !=null) {
	String [] date = diet_date.split("-");
	year = Integer.parseInt(date[0])+"";
	month =Integer.parseInt(date[1])+"";
}
%>
<br /><br /><br /><br />

<%if(id!=null){ %>
<center><h3>식단 내용 작성하기</h3></center>

<form action="dietWritePro.jsp">


<table id=view1  align ="center" border="1" width="400">
	<tr bgcolor="#d6cabc">
		<td colspan="2" align ="center" height="10%" >날짜 <input type="date" name="diet_date" <%if(diet_date!=null){ %>value="<%=diet_date%>"<%}%> ></td>
	</tr>
	
	<tr>
		<td>아침</td>	<td><textarea rows="5" cols="40" name="breakfast"></textarea></td> 		
	</tr>
	<tr>
		<td>점심</td>	<td><textarea rows="5" cols="40" name="lunch"></textarea></td> 		
	</tr><tr>
		<td>저녁</td>	<td><textarea rows="5" cols="40" name="dinner"></textarea></td> 		
	</tr>
	<tr>
		<td colspan="2" align="center">
			<input type = "submit" value="작성하기" />
			<input type="button" value="식단달력" onclick="window.location='dietCalendar.jsp?year=<%=year%>&month=<%=month%>'"/>
		</td>
	</tr>
</table>

</form>

<%}else{%>
	<script>
		alert("로그인 후 사용 가능합니다");
		window.location='/myneng/login/login.jsp';
	</script>
<%}%>
</body>