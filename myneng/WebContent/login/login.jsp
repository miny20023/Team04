<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "../menu.jsp" %>

<script type="text/javascript">
	function findId(){ open("findId.jsp","check","width=400 height=300");}
</script>

<%
	Cookie [] cookies =request.getCookies();//배열로 리턴 -> 사용자가 가지고 있는 모든 쿠키를 꺼내겠다
	//저장했던 cooId찾기
	String remid="";
	String rempw="";
	String pw="";
	id="";
	
	if(cookies != null){
		for(Cookie coo_id : cookies){
			
			if(!(coo_id.getName().equals("JSESSIONID"))){
				id = coo_id.getName();//쿠키이름꺼내기
				// 쿠키이름이 cooId와 같은가 ->id에 저장
				if(id.equals("cooId")){
					id = coo_id.getValue();	
					remid="checked='checked'";
					 break;
				}
			}
		}for(Cookie coo_pw : cookies){
			if(!(coo_pw.getName().equals("JSESSIONID"))&&!(coo_pw.getName().equals("cooId"))){
				pw = coo_pw.getName();
				if(pw.equals("cooPw")){
					pw = coo_pw.getValue();
					rempw="checked='checked'";
					 break;
				}
			}
		}
	}
%>






<%--로그인 페이지 --%>
 <form action="loginPro.jsp" method="post">
 <br /> <br />  <br />
 
<center><h1>member login</h1></center>
 <br /> <br />

<table align="center" >
<tr>
<td>아이디</td>
<td><input type ="text" size="10" name="id" <%if(id!=""){%> value='<%=id%>'<%} %>/> </td>
<td rowspan="2"><input type ="submit" value ="로그인"  /></td>
</tr>

<tr>
<td>비밀번호</td>
<td><input type ="password" size="10" name="pw" <%if(pw!=""){%> value='<%=pw%>'<%} %> /></td>
<td></td>
</tr>
 
<tr>
<td><input type ="checkbox" name="remid" <%if(remid!=""){%><%=remid%><%}%> />아이디저장</td>
<td><input type ="checkbox" name="rempw" <%if(rempw!=""){%><%=rempw%><%}%> />비밀번호저장</td>
<td></td>
</tr>
	
<tr>
<td><input type ="button" value ="회원가입" onclick ="window.location='join.jsp'" /></td>
<td><input type ="button" value ="아이디/비밀번호찾기" onclick="findId();" /></td>
</tr>	
</table>
</form> 

