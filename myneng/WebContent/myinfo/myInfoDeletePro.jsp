<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="member.bean.MemberDTO" %>
<%@ page import="member.bean.MemberDAO" %>
<h1>myInfoDeletePro 페이지</h1>

<%
	String pw = request.getParameter("pw");
	String id = (String)session.getAttribute("memId"); //로그인상태
	MemberDAO dao = new MemberDAO();
	boolean result = dao.loginCheck(id,pw);
	if(result){
		dao.statusChange(id);
		session.invalidate(); // 세션 모두삭제
%> 
		<script>
			alert("탈퇴되었습니다.");
			window.location='/maneng/main/main.jsp';
		</script>
	<%}else{%>
		<script>
			alert("비밀번호가 틀렸습니다.");
			history.go(-1);
		</script>
	<%}%>