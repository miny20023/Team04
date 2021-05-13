<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
//get방식으로 글번호를 넘겨줌 -> 받기
	String diet_date =request.getParameter("diet_date");
	//String pageNum = request.getParameter("pageNum");

//삭제하시겠습니까 ? 출력후 삭제 진행

%>
	<script>
		var re =confirm("<%=diet_date%>일 식단을 삭제하겠습니까?");
		if(re){ window.location = "dietDeletePro.jsp?diet_date=<%=diet_date%>" }//예
		else{history.go(-1)}//아니오
	</script>