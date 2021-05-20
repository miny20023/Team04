<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>

	function idCheck(){
		var id=document.joinform.id.value;
		if(id){
		open("idCheck.jsp?id="+id,"check","width=400 height=300");
		}else{
			alert("id를 입력하지 않았습니다.");

		}
		
	}
	
	function pwrCheck(){
		var pw=document.joinform.pw.value;
		var pwr=document.joinform.pwr.value;
		var num = /[0-9]/;
		var eng = /[a-zA-Z]/;
		
		var rpc ="<font color=red>비밀번호가 일치하지 않습니다.</font>" ;
		if(pwr==pw){
			rpc="<font color=green>비밀번호가 일치합니다.</font>";
		}
		document.getElementById("pwresult").innerHTML=rpc;
		
		if(pw.length<4){
			rpc="<font color=red>비밀번호는 4글자이상 이용가능합니다.</font>";
		}
		if(!num.test(pw)){
			rpc="<font color=red>비밀번호는 숫자를 포함해야 합니다.</font>";
		}
		if(!eng.test(pw)){
			rpc="<font color=red>비밀번호는 영어를 포함해야 합니다.</font>";
		}
		if(eng.test(pw)&& num.test(pw) && pw.length>3){
			rpc="<font color=green>사용가능한 비밀번호 입니다.</font>";
		}
		document.getElementById("pwcheck").innerHTML=rpc;

	}
	
	function sub(){
		var id = document.joinform.id.value; // 현재문서의 아이디네임과 그 태그의 값
		
		if(!id){//false 값이 없다는 것
			alert("id를 입력하지 않았습니다.");
			//id입력하는 자리에 커서이동하게 작업
			document.joinform.id.focus();//focus();커서 id에 커서를 갖다대라
			return false;
		}
		
		var pw = document.joinform.pw.value;
		if(!pw){
			alert("비밀번호를 입력하지 않았습니다.");
			document.joinform.pw.focus();
			return false;	
		}
		
		var pwr = document.joinform.pwr.value;
		if(pw !=pwr){//유효성검사
			alert("비밀번호가 일치하지 않습니다.")//
			return false; // 같지않으면 넘어가면 안됨
		}
		
		if(document.joinform.name.value == ""){
            alert("이름을 입력하지 않았습니다.");
            document.joinform.name.focus();
            return false;
        }
		if(document.joinform.address.value == ""){
            alert("주소를 입력하지 않았습니다.")
            document.joinform.address.focus();
            return false;
        }
		
		if(document.joinform.ph1.value == ""){
            alert("번호를 입력하지 않았습니다.")
            document.joinform.ph1.focus();
            return false;
		}
		if(document.joinform.ph2.value == ""){
            alert("번호를 입력하지 않았습니다.")
            document.joinform.ph2.focus();
            return false;
		}
		if(document.joinform.ph3.value == ""){
            alert("번호를 입력하지 않았습니다.")
            document.joinform.ph3.focus();
            return false;
		}
		if(document.joinform.email.value == ''){
            alert("이메일을 입력하지 않았습니다.")
            document.joinform.email.focus();
            return false;
		}
		
	}		
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
 <br /> <br />  <br />
 
<center><h1>회원가입</h1></center>
	
<%-- form name="joinform" action ="memberInsertPro.jsp" method="post" onsubmit="return joinCheck();" --%>
<form name="joinform" action ="joinPro.jsp" method="post" onsubmit="return sub();" >

<input type="hidden" name="group_pw" value="<%=group_pw%>" />

<table align="center" >

<tr>
<td>아이디</td>
<td><input type ="text" name="id" placeholder="3글자 이상 " /> <input type ="button" value ="중복확인" onclick="idCheck();" /></td>
</tr>

<tr>
<td>이름</td>
<td><input type ="text" name="name"  /></td>
</tr>

<tr>
<td>비밀번호</td>
<td><input type ="password" name="pw" placeholder="4글자 이상,영어,숫자 포함" onchange="pwrCheck()"/><label id="pwcheck"></label></td>
</tr>

<tr>
<td>비밀번호 확인</td>
<td><input type ="password" name="pwr"  placeholder="4글자 이상,영어,숫자 포함"  onchange="pwrCheck()"/><label id="pwresult"></label></td>
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
</body>