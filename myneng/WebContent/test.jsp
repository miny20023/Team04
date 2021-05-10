<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript"> 
//<![CDATA[
function calcHeight(){
 //find the height of the internal page

 var the_height=document.getElementById('the_iframe').contentWindow.document.body.scrollHeight;

 //change the height of the iframe
 document.getElementById('the_iframe').height=the_height;

 //document.getElementById('the_iframe').scrolling = "no";
 document.getElementById('the_iframe').style.overflow = "hidden";
}
//
</script>
<body>


	<iframe name="header" src="menu.jsp" onload="calcHeight();" scrolling="no" frameborder="0"
			style="overflow-x:hidden; overflow:auto; width:100%; min-height:350px;"></iframe>
	<iframe name="content" src="center.jsp" onload="calcHeight(); scrolling="auto" frameborder="0"
			style="overflow-x:hidden; overflow:auto; width:100%; min-height:500px;"></iframe>

</body>
</html>