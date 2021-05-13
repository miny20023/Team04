<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="diet.bean.DietDAO" %>
<%@ include file = "../menu.jsp" %>

<%
	String diet_date = request.getParameter("diet_date");

	
	DietDAO dao = new DietDAO();
	
	dao.deleteDiet(diet_date,id);
	
	String year =null;
	String month=null;
	if(diet_date !=null) {
		String [] date = diet_date.split("-");
		year = Integer.parseInt(date[0])+"";
		month =Integer.parseInt(date[1])+"";
	}
	
	
	
%>
<script>
	alert("삭제되었습니다.");
</script>
<%--meta http-equiv="Refresh" content="1;url=dietList.jsp?pageNum=1" --%>
<meta http-equiv="Refresh" content="0;url=dietCalendar.jsp?year=<%=year%>&month=<%=month%>" >

