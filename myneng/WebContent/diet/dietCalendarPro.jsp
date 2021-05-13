<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="diet.bean.DietDAO"  %>
<%@ page import="java.util.Date" %>
<%@ include file = "../menu.jsp" %>

<%request.setCharacterEncoding("UTF-8"); %>
<%
	String diet_date =request.getParameter("diet_date");

	if(diet_date==null||diet_date.equals("")){
		Date date = new Date();
		int year = date.getYear()+1900;
		int month = date.getMonth()+1;
		int day = date.getDate();
		String y = year+"";
		String m= month+"";
		String d= day+"";
		if(month <10){ m ="0"+month;}
		if(day <10){d ="0"+day;}	
		 diet_date = y+"-"+m+"-"+d;
	}

	DietDAO dao = new DietDAO();
	boolean result = dao.dateCheck(diet_date, id);
	if(result){ // 새글작성
		response.sendRedirect("dietWriteForm.jsp?diet_date="+diet_date);
	}else{ //작성글로 이동
		response.sendRedirect("dietContent.jsp?diet_date="+diet_date);
	}

%>