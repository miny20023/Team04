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
<h1>개인 정보 수정</h1>

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
<table>
<tr>
<td>아이디</td> 
<td><input type = "hidden" name = "id" value="<%=id%>"/><%=id%></td>
</tr>

<tr>
<td>이름</td>
<td><input type = "text" name = "name" value="<%=dto.getName()%>"/></td>
</tr>

<tr>
<td>비밀번호</td>
<td><input type = "password" name="pw" value="<%=dto.getPw()%>"/></td>
</tr>

<tr>
<td>이메일</td>
<td><input type = "email" name="email" value="<%=dto.getEmail()%>"/></td>
</tr>

<tr>
<td>연락처</td>
<td>		<input type = "text" name="ph1" value="<%=dto.getPh1()%>">-
			<input type = "text" name="ph2" value="<%=dto.getPh2()%>">-
			<input type = "text" name="ph3" value="<%=dto.getPh3()%>">
			</td>
</tr>

<tr>			
<td>주소</td>
<td><input type = "text" name = "address" value="<%=dto.getAddress()%>"/></td>
</tr>

<tr>
<td>그룹 비밀번호</td>
<td><input type = "text" name = "group_pw" value="<%=dto.getGroup_pw()%>"/></td>
</tr>
</table>
<input type="submit" value="수 정"/>

</form>
</div>
</body>