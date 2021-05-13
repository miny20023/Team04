<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="member.bean.ScrapDAO" %>

    <% 
    	String id = (String) session.getAttribute("memId");
    	int num = Integer.parseInt(request.getParameter("num"));
    	
    	ScrapDAO dao = new ScrapDAO();
    	// 찜 해제 버튼을 누르면 -> id_scrap 테이블(id마다 달라짐)에서 num(rec_id)를 삭제
    	dao.deleteScrap(id, num);
    %>
    
    <script>
    	alert("찜 목록에서 삭제되었습니다.");
    	history.go(-1);
    </script>