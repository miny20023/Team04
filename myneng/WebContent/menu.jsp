<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
.menubar{
border:none;
border:0px;
margin:0px;
padding:0px;
font: 67.5% "Lucida Sans Unicode", "Bitstream Vera Sans", "Trebuchet Unicode MS", "Lucida Grande", Verdana, Helvetica, sans-serif;
font-size:14px;
font-weight:bold;
}

.title {
text-align:center;
background: rgb(150, 150, 150);
padding:0;
margin:0;
height:50px;
}

.login {
align:right;
background:rgb(150, 150, 150);
padding:0;
margin:0;
height:30px;
}

.login input{
vertical-align:middle;
line-height:20px;
float:right;
}

h2{
text-align:center;
vertical-align:middle;
line-height:70px;
}

.menubar ul{
background: rgb(109,109,109);
height:50px;
list-style:none;
margin:0;
padding:0;
}

.menubar li{
float:left;
padding:0px;
}

.menubar li a{
background: rgb(109,109,109);
color:#cccccc;
display:block;
font-weight:normal;
line-height:50px;
margin:0px;
padding:0px 25px;
text-align:center;
text-decoration:none;
}

.menubar li a:hover, .menubar ul li:hover a{
background: rgb(71,71,71);
color:#FFFFFF;
text-decoration:none;
}

.menubar li ul{
background: rgb(109,109,109);
display:none; /* 평상시에는 드랍메뉴가 안보이게 하기 */
height:auto;
padding:0px;
margin:0px;
border:0px;
position:absolute;
width:200px;
z-index:200;
/*top:1em;
/*left:0;*/
}

.menubar li:hover ul{
display:block; /* 마우스 커서 올리면 드랍메뉴 보이게 하기 */
}

.menubar li li {
background: rgb(109,109,109);
display:block;
float:none;
margin:0px;
padding:0px;
width:200px;
}

.menubar li:hover li a{
background:none;
}

.menubar li ul a{
display:block;
height:50px;
font-size:12px;
font-style:normal;
margin:0px;
padding:0px 10px 0px 15px;
text-align:left;
}

.menubar li ul a:hover, .menubar li ul li:hover a{
background: rgb(71,71,71);
border:0px;
color:#ffffff;
text-decoration:none;
}

.menubar p{
clear:left;
}
</style>
<script>
	function spread(id){
		var getId = document.getElementById(id);
		getID.style.display=(getID.style.display=='block') ? 'none' : 'block';
	}
	
	function summary(index){
		var getId = document.getElementById(index);
		getId.style.display=(getId.style.display=='block')?'none':'block';
		if(index.style.display=='none') index.style.display='block';
		else if(index.style.display=='block') index.style.display ='none';
	}
	
	
	function login(){
		alret("로그인 후 사용 가능합니다");
	}
</script>
<title>Insert title here</title>
</head>
<body>
<div class="title" onclick="location.href='/myneng/main.jsp'"><h2><b>Myneng</b></h2></div>
<div class="login">
<%
	String id = (String)session.getAttribute("memId");
if(id!=null){%>

[<%=id%>님] <input type = "button" value="로그아웃" onclick="window.location='/myneng/login/logout.jsp'" />
<%}else{%><input type = "button" value="로그인" onclick="window.location='/myneng/login/login.jsp'"/>	


<%}%>
</div>
<div class="menubar">
<ul>
 <li><a href="#">나의 냉장고</a>
 	<ul>
 	 <li><a>재료추가</a></li>
 	 <li><a>재료정리</a></li>
 	 <li><a>재료조합</a></li>
 	 <li><a>장보기 메모</a></li>
 	</ul>
 </li>
 <li><a href="#" id="current">레시피</a>
	<ul>
     <li><a href="/myneng/cart/groupBuying.jsp">레시피 정보 공유</a></li>
     <li><a href="#">레시피 게시판</a></li>
    </ul>
 </li>
 <li><a href="#">장보기</a>
 	<ul>
     <li><a href="#">마트위치찾기</a></li>
     <li><a href="#">공동구매</a></li>
     <li><a href="#">장보기 정보 공유</a></li>
    </ul>	
 </li>
 <li><a href="#">나의 정보</a>
 	<ul>
     <li><a href="#">찜한 레시피</a></li>
     <li><a href="#">식단 짜기</a></li>
     <li><a href="#">개인 정보</a></li>
     <li><a href="#">회원 탈퇴</a></li>
    </ul>
 </li>
</ul>
</div>
</body>

</html>