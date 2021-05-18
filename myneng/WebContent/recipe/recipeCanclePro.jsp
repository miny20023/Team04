<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="cook.bean.CookDAO" %>

<% 
	String id = (String) session.getAttribute("memId");

	if(session.getAttribute("random_id") != null){
		int random_id = (int) session.getAttribute("random_id");
		CookDAO daoc = new CookDAO();
		daoc.cancleIng(random_id);
		session.removeAttribute("random_id");
	}
%>
 
<script>
	alert("레시피 입력이 취소되었습니다.");
	history.go(-2);
</script>