<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="member.bean.MemberDAO" %>
<jsp:useBean id ="dto" class="member.bean.MemberDTO" />
<jsp:setProperty name ="dto" property ="*"  />
<%--login 프로 페이지 --%>
<%
	request.setCharacterEncoding("UTF-8");
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	//5월 14일 추가
	String remid = request.getParameter("remid");
	String rempw = request.getParameter("rempw");
	
	
	MemberDAO dao = new MemberDAO(); 
	boolean result = dao.loginCheck(id,pw);
	
	
	if(result){ // 값이 있을때 세션 생성
		session.setAttribute("memId",dto.getId());
		
		/////5월 14일 추가
		//쿠키생성
		Cookie coo_id = new Cookie("cooId",dto.getId());
		Cookie coo_pw = new Cookie("cooPw",dto.getPw());
		
	


		//체크가 안되어있으면 쿠키삭제
		if(remid==null){
			coo_id.setMaxAge(0);
			coo_pw.setMaxAge(0);}
		
		if(rempw==null){coo_pw.setMaxAge(0);}
		/////////////////
		
		response.addCookie(coo_id);// 사용자에게 전달
		response.addCookie(coo_pw);// 사용자에게 전달
		
		response.sendRedirect("/myneng/main.jsp");	
	
	
	}else{%>
	
		<script>
			alert("아이디 또는 비밀번호가 잘못되었습니다.");
			history.go(-1);
		</script>	
		
	<%}
	
	
	
	
%>