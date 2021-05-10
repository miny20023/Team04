<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="member.bean.MemberDAO" %>
<%	request.setCharacterEncoding("UTF-8"); %>
<%--ID 확인 페이지  --%>
<%
	//get으로 넘어오는 id 파라미터를 받기
	String id = request.getParameter("id");
	MemberDAO dao = new MemberDAO();
	
	boolean result = dao.idCheck(id);
	if(result){%>
	<h3>입력한 id:[<%=id %>] 사용가능합니다.</h3>
	<%}else{%>
		<h3>입력한 id:[<%=id %>] 사용중입니다. 다른 id를 사용하세요.</h3>
	<%}
%>

	<input type = "button" value ="닫기" onclick="self.close();" />
<%-- <script type="text/javascript">
	function selfClose(){
	var r = <%=result%>
	var h = "<b><font color=red>사용불가능</font></b>"
	if(r){
		h="<b><font color =green>사용가능</font></b>";
	}
	
	--%>