<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "../menu.jsp" %>
<%--로그인 페이지 --%>
 <form action="loginPro.jsp" method="post">
 <br /> <br />  <br />
 
<center><h1>member login</h1></center>
 <br /> <br />

<table align="center" >
<tr>
<td>아이디</td>
<td><input type ="text" size="10" name="id" /> </td>
<td rowspan="2"><input type ="submit" value ="로그인"  /></td>
</tr>

<tr>
<td>비밀번호</td>
<td><input type ="password" size="10" name="pw" /></td>
<td></td>
</tr>
<%-- 
<tr>
<td><input type ="checkbox" name="remid" />아이디저장</td>
<td><input type ="checkbox" name="rempw" />비밀번호저장</td>
<td></td>
</tr>
--%>	
<tr>
<td><input type ="button" value ="회원가입" onclick ="window.location='join.jsp'" /></td>
<td><input type ="button" value ="아이디/비밀번호찾기" onclick="window.location='loginResearch.jsp'" /></td>
</tr>	
</table>
</form> 

