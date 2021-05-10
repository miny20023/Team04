<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<h1>main 페이지...!!</h1>
<%
	String id = (String)session.getAttribute("memId");
	// 쿠키 처리
	/*Cookie[] cookies = request.getCookies();		// 쿠키를 배열로 리턴
	String id = null;
	for(Cookie coo : cookies)
	{
		String name = coo.getName();
		if(name.equals("cooId"))
		{
			id = coo.getValue();
		}
	}*/
		
%>
<b><%=id %></b> 님 어서오세요~ <br />
<%if(id == null){%>
	<input type="button" value="로그인" onclick="window.location='loginForm.jsp'" />
	<%}else{ %>
<input type="button" value="회원정보변경" onclick="window.location='updateForm.jsp'" />
<input type="button" value="로그아웃" onclick="window.location='logout.jsp'"/>
<input type="button" value="탈 퇴" onclick="window.location='deleteForm.jsp'" />
<%} %>
<br /><br />
<input type="button" value="게시판" onclick="window.location='/myneng/cart/groupBuying.jsp'" />