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

    	//식단 작성된 날 확인 . true시 글 작성가능
    	boolean date_result = dao.dateCheck(diet.getDiet_date(), id);
		//식단 공백 방지 아침,점심,저녁중 하나는 작성되어있어야함
    	boolean content = (diet.getBreakfast()!=null) ||(diet.getLunch()!=null)||(diet.getDinner()!=null);
		
		
    	if(id!=null){
    		if(diet.getDiet_date()!=null && date_result&& content)
    		{
    			dao.insertDiet(diet,id); 
    			int year=diet.getYear();
    			int month=diet.getMonth();%>
    			
	   		<script>
				alert("추가되었습니다.")
				window.location.href='dietCalendar.jsp?year=<%=year%>&month=<%=month%>';
			</script>
			<%}
    		else if(!content){%>
    		<script>
    			alert("내용을 입력해 주세요.");
    			history.go(-1);
    		</script>
    			
    		<%}else{%>
		<script>
			alert("해당하는 날짜에 이미 식단이 존재합니다. 날짜를 확인해 주세요.");
			history.go(-1);
		</script>
			<%}	
    	}
    	
    	else{%>
	<script>
		alert("로그인이 필요합니다.")
		window.location='/myneng/login/login.jsp';
	</script>
		<%}%>
	

