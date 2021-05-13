<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "member.bean.MemberDTO" %>
<%@ page import = "member.bean.MemberDAO" %>
<%@ include file = "../menu.jsp" %>
<head>
<style type="text/css">

</style>
</head>
<body bgcolor="#f0efea">
<h1>myInfoUpdate 페이지</h1>

<%
	id = (String)session.getAttribute("memId");
	if(id == null) {%>
	<script>
		alert("로그인을 해주세요.");
		history(-1);
	</script>
	<%}
	MemberDAO dao = new MemberDAO();
	MemberDTO dto = dao.getMember(id);

	
%> 
<div>
<form action="myInfoUpdatePro.jsp" method="post">
	id : <input type = "hidden" name = "id" value="<%=id%>"/><%=id%><br/>
	name : <input type = "text" name = "name" value="<%=dto.getName()%>"/><br/>
	pw : <input type = "password" name="pw" value="<%=dto.getPw()%>"/><br/>
	email : <input type = "email" name="email" value="<%=dto.getEmail()%>"/><br/>
	phone : 
			<input type = "text" name="ph1" value="<%=dto.getPh1()%>">-
			<input type = "text" name="ph2" value="<%=dto.getPh2()%>">-
			<input type = "text" name="ph3" value="<%=dto.getPh3()%>">
			<br/>
	address : <input type = "text" name = "address" value="<%=dto.getAddress()%>"/><br/>
	group_pw : <input type = "text" name = "group_pw" value="<%=dto.getGroup_pw()%>"/><br/>
			<input type="submit" value="수 정"/>

</form>
</div>
</body>