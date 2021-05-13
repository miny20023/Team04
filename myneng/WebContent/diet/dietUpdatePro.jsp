<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="diet.bean.DietDAO" %>
<%@ page import="diet.bean.DietDTO" %>
<%@ include file = "../menu.jsp" %>


<%
request.setCharacterEncoding("UTF-8");

 //String year = request.getParameter("year");null
 //String month = request.getParameter("month");null
 String diet_date = request.getParameter("diet_date"); 
%>
    
<jsp:useBean class="diet.bean.DietDTO" id="diet" />
<jsp:setProperty name="diet" property="*" />


<%
//String pageNum = request.getParameter("pageNum");
//if(pageNum ==null){	pageNum="1";}//pageNum 자꾸 null발생함

	DietDAO dao = new DietDAO();
	dao.updateDiet(diet,id);	
	//String year=diet.getYear()+"";
	//String month=diet.getMonth()+"";
	
	String year =null;
	String month=null;
	if(diet_date !=null) {
		String [] date = diet_date.split("-");
		year = Integer.parseInt(date[0])+"";
		month =Integer.parseInt(date[1])+"";
	}
%>


	
<script>
	alert("식단이 수정되었습니다.");
</script>
<meta http-equiv="Refresh" content="0;url=dietCalendar.jsp?year=<%=year%>&month=<%=month%>">