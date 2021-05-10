<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="member.bean.MemberDAO" %>
<jsp:useBean id ="dto" class="member.bean.MemberDTO" />
<jsp:setProperty name ="dto" property ="*"  />
<%--login 프로 페이지 --%>
<%
	request.setCharacterEncoding("UTF-8");
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	MemberDAO dao = new MemberDAO(); 
	boolean result = dao.loginCheck(id,pw);
	
	
	if(result){ // 값이 있을때 세션 생성
		session.setAttribute("memId",dto.getId());
		response.sendRedirect("/myneng/main.jsp");

	}else{%>
	
		<script>
			alert("아이디 또는 비밀번호가 잘못되었습니다.");
			history.go(-1);
		</script>	
		
	<%}
	
	
	
	
%>