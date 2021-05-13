<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%@ page import="diet.bean.DietDAO" %>
<%
request.setCharacterEncoding("UTF-8");
%>

<jsp:useBean class="diet.bean.DietDTO" id="diet" />
<jsp:setProperty name="diet" property="*" />
    

<%
    //db에 추가하기

     	String id = (String)session.getAttribute("memId");
    	DietDAO dao = new DietDAO();
    	
    	diet.setYear(diet.getDiet_date());
    	diet.setMonth(diet.getDiet_date());
    	diet.setDay(diet.getDiet_date());

    	boolean date_result = dao.dateCheck(diet.getDiet_date(), id);

    	if(id!=null){
    		if(diet.getDiet_date()!=null && date_result)
    		{
    			dao.insertDiet(diet,id); 
    			int year=diet.getYear();
    			int month=diet.getMonth();%>
    			
	   		<script>
				alert("추가되었습니다.")
				window.location.href='dietCalendar.jsp?year=<%=year%>&month=<%=month%>';
			</script>
			<%}
    		
    		else{%>
		<script>
			alert("날짜를 확인해 주세요.");
			history.go(-1);
		</script>
			<%}	
    	}
    	
    	else
    	{%>
	<script>
		alert("로그인이 필요합니다. ")
		window.location='/myneng/login/login.jsp';
	</script>
		<%}%>
	

