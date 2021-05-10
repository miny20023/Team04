<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="test.model.bean.TestMemberDAO" %>

<h1>loginPro 페이지..!!</h1>

<jsp:useBean id="dto" class="test.model.bean.TestMemberDTO" />
<jsp:setProperty property="*" name="dto" />

<%
	// TestMemberDAO id/pw 확인
	TestMemberDAO dao = new TestMemberDAO();
	boolean result = dao.loginCheck(dto);
	if(result)
	{
		/*Cookie coo = new Cookie("cooId",dto.getId());
		Cookie coo2 = new Cookie("cooPw",dto.getPw());
		// 쿠키 유효기간 설정
		coo.setMaxAge(60);			// 60초 후 쿠키 자동 삭제
		response.addCookie(coo);*/
		
		// 세션생성 - id 저장	key(아무거나 정해주면됨)/value
		session.setAttribute("memId", dto.getId());
		response.sendRedirect("/myneng/tmp/afterLogin.jsp");
	}
	else
	{%>
		<script>
			alert("아이디/비밀번호 확인하세요...!!");
			history.go(-1);
		</script>
	<%}
%>