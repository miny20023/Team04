<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import ="diet.bean.DietCalendar" %>
<%@ page import ="diet.bean.DietDAO" %>
<%@ page import="diet.bean.DietDTO" %>
<%@ include file = "../menu.jsp" %>
   
<%
	DietDAO dao = new DietDAO();
	DietDTO diet = null;
	
	Date date = new Date();
	int year = date.getYear()+1900;
	int month = date.getMonth()+1;
	
	try{
		year = Integer.parseInt(request.getParameter("year"));
		month = Integer.parseInt(request.getParameter("month"));
		if(month>=13){
			year++;
			month=1;
		}else if(month <=0){
			year--;
			month=12;
		}
	}catch(Exception e){}
	
	//year, month 넘겨받기
	if(request.getParameter("year")!=null && !(request.getParameter("year")!="0")){ year=Integer.parseInt(request.getParameter("year"));}
	if(request.getParameter("month")!=null && !(request.getParameter("month")!="0")){month = Integer.parseInt(request.getParameter("month"));}
	
%>

<center>
<form>
<br><br>
<table id=viewMonth align ="center" border="1" width="1050" cellpadding ="5" cellspacing="0">
<tr>
	<th colspan="7">
	<input type ="button" value="◀이전달" onclick ="location.href='?year=<%=year%>&month=<%=month-1%>'" >
	 <%=year%>년  <%=month%>월 
	<input type = "button" value="다음달▶" onclick="location.href='?year=<%=year%>&month=<%=month+1%>'" >
	</th>
	<tr>
		<td class="sunday">일</td>
		<td class="etcday">월</td>
		<td class="etcday">화</td>
		<td class="etcday">수</td>
		<td class="etcday">목</td>
		<td class="etcday">금</td>
		<td class="saturday">토</td>	
	</tr>
	<!-- 날짜 넣기 -->
	<tr>
<%
	//첫날이 무슨요일인지 알아보기
	int first = DietCalendar.weekDay(year,month,1);
	//월요일이면 1칸 공백, 화요일 2칸공백, 수요일 3칸, 목요일 4칸, 금요일5칸 토요일 6칸
	//first숫자만큼 <td></td>생성
	
	for(int i=0; i<first;i++){out.println("<td> </td>");}
	
	
	//i는 날짜	
	for(int i=1; i<=DietCalendar.lastDay(year,month); i++){
		
		String y = year+"";
		String m= month+"";
		String d= i+"";
		
		if(month <10){ m ="0"+month;}
		if(i <10){d ="0"+i;}
		
		String diet_date =y+"-"+m+"-"+d;
		
			switch(DietCalendar.weekDay(year,month,i)){
			//일:0 월:1 화:2 수:3 목:4 금:5 토:6 
				case 0:
					%><td class='sunday' onclick="location.href='dietCalendarPro.jsp?diet_date=<%=diet_date%>'" style='cursor:pointer;'><%
					out.println(i+"<br />");
					break;
				case 6:
					%><td class='saturday' onclick="location.href='dietCalendarPro.jsp?diet_date=<%=diet_date%>'" style='cursor:pointer;'><%					
					out.println(i+"<br />");
					break;
				default :
					%><td class='ectday' onclick="location.href='dietCalendarPro.jsp?diet_date=<%=diet_date%>'" style='cursor:pointer;'><%	
					out.println(i+"<br />");
					break;
			}
			//식단내용 넣어주기	
			diet = dao.getDietCalendar(year,month,i,id);		
			if(diet.getDiet_date()!=null){
				//아침,점심,저녁중 null값이 있을때 null안보이게 처리해야됨...
				if(diet.getBreakfast()!=null){out.println("아침: "+diet.getBreakfast()+"<br />");}
				else{out.println("아침: "+"<br />");}
				
				if(diet.getLunch()!=null){out.println("점심: "+diet.getLunch()+"<br />");}
				else{out.println("점심: "+"<br />");}
				
				if(diet.getDinner()!=null){out.println("저녁: "+diet.getDinner()+"</td>");}
				else{out.println("저녁: "+"</td>");}
				
			}else{out.println("</td>");}
			
			//토요일일때 줄바꿈 </tr><tr>	
			if(DietCalendar.weekDay(year,month,i)==6){out.println("</tr><tr>");	}
		}
	
	//마지막날이 일요일 0일경우 공백 6개, 월1 5개, 화2 4개, 수3 3개, 목4 2개, 금5 1개 토6 0개 
	int last =DietCalendar.weekDay(year,month,(DietCalendar.lastDay(year,month))); 
	for(int i=0; i<6-last;i++){	out.println("<td></td>");}
	
%>
	</tr>
	
	<tr border ="0">
		<td colspan="7" align ="center">
			<input type = "button" value="식단작성하기"  onclick="window.location='dietWriteForm.jsp'" />
			<%-- input type = "button" value="식단목록"  onclick="window.location='dietList.jsp'" />--%>
		</td>
	</tr>
		
</table>
</form>
</center>
<%--
<form action = "dietSearch.jsp">
식단 : <input type="text" name="diet_search" /><input type="button" value="검색" />

</form>
 --%>





