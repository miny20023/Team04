<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">

	function idCheck(){
		var id=document.joinform.id.value;
		open("idCheck.jsp?id="+id,"check","width=400 height=300");
	}
	
	function pwrCheck(){
		var pw=document.joinform.pw.value;
		var pwr=document.joinform.pwr.value;

		var rpc ="<font color=red>비밀번호가 일치하지 않습니다.</font>" ;
		if(pwr==pw){
			rpc="<font color=green>비밀번호가 일치합니다.</font>";
		}
		document.getElementById("pwresult").innerHTML=rpc;
	}
	
	/*
	function joinCheck(){
		//var str=document.joinform.id.value;
		if(document.joinform.id.value==""{
			alert("id를 입력하지 않았습니다.")		
			joinform.id.focus();
			return false;
		}
		if(document.joinform.pw.value!=document.joinform.pwr.value){
			alret("비밀번호가 일치하지 않습니다.")
			return false
		}
		if(document.joinform.pw.value==""){
			alret("비밀번호를 입력하지 않았습니다.")
			return false
		}
	    if (document.joinform.name.value == "") {
            alert("이름을 입력하지 않았습니다.")
            document.f.name.focus();
            return false;
        }
	    if (document.joinform.adress.value == "") {
            alert("주소를 입력하지 않았습니다.")
            document.f.name.focus();
            return false;
        }
	    document.joinform.submit();
	}
	*/
</script>   

<%
//그릅비밀번호 임의설정
String group_pw = "";
String alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@&%?~";
group_pw += (int) (Math.random() * 999) + 1 + "";
group_pw += alpha.charAt((int) (Math.random() * alpha.length()));
group_pw += (int) (Math.random() * 99) + 1 + "";
group_pw += alpha.charAt((int) (Math.random() * alpha.length()));
	
	
%>

	
<%-- form name="joinform" action ="memberInsertPro.jsp" method="post" onsubmit="return joinCheck();" --%>
<form name="joinform" action ="joinPro.jsp" method="post" onsubmit="return joinCheck();" >

<input type="hidden" name="group_pw" value="<%=group_pw%>" />

<table >

<tr>
<td>아이디</td>
<td><input type ="text" name="id" /> <input type ="button" value ="중복확인" onclick="idCheck();" /></td>
</tr>

<tr>
<td>이름</td>
<td><input type ="text" name="name" /></td>
</tr>

<tr>
<td>비밀번호</td>
<td><input type ="password" name="pw" onchange="pwrCheck()"/></td>
</tr>

<tr>
<td>비밀번호 확인</td>
<td><input type ="password" name="pwr"  onchange="pwrCheck()"/><label id="pwresult"></label></td>
</tr>


<tr>
<td>주소</td>
<td><input type = "text" name="address"/></td>
</tr>

<tr>
<td>연락처</td>
<td>
   <input type ="text" name="ph1"size="3"/>-<input type ="text" name="ph2" size="4" />-<input type ="text" name="ph3" size="4" />
   </td>
</tr>

<tr>
<td>이메일</td>	
<td><input type = "email" name="email" /></td>
</tr>


<tr>
<td><input type ="submit" value="회원가입"  /></td>
<td><input type ="button" value="돌아가기" onclick="history.back()"/></td>
</tr>
</table>
</form>