<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
	.bt{ 
		font-size:20px;
		cursor: pointer;
		text-align: center;
    	background: #808080;
		outline: none;
		border: none;
		color:#ffffff;
		width: 200;	
		padding: 10px;
		margin-right:-1px;
		margin-left:-1px;
		
		}

</style>

<%--아이디 찾기 페이지 --%>
<center>
	<input class="bt" type="button" value="아이디 찾기" onclick="window.location='findId.jsp'" />
	<input class="bt" type="button" value="비밀번호 찾기" onclick="window.location='findPw.jsp'" />
<h2>아이디찾기</h2>
</center>
<form action="findIdPro.jsp" method="post">
<table id ="idSearch" align="center" >
<tr>
<td>이름</td>
<td><input type ="text" size="10" name="name" /> </td>
</tr>

<tr>
<td>이메일주소</td>
<td><input type ="email" size="10" name="email" /></td>
</tr>
	
<tr>
<td colspan="2" align = "center"><br /><input type ="submit" value ="확인"  /></td>
</tr>	

</table>
</form> 






