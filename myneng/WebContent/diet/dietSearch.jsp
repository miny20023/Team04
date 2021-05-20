<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="diet.bean.DietDAO" %>
<%@	page import="diet.bean.DietDTO" %>
<%@ page import=" java.util.List" %>
<%@ page import ="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
<%@ include file = "../menu.jsp" %>
<body bgcolor="#f0efea">
<style type="text/css">
th{text-align:center; color:black; font-weight:bold; font-size:14px;}
td{text-align:center; color:black; }
</style>
<%
	request.setCharacterEncoding("UTF-8");
	String diet_search =request.getParameter("diet_search");
	//space 공백도 결과가 나옴...
	if(diet_search==""){%>
		<script>
			alert("검색할 내용을 입력해주세요.");
			history.go(-1);
		</script>
	<%}
	
	String search = "";
	if(diet_search!=null){ search = URLEncoder.encode(diet_search, "UTF-8");}// URLEncoding -> 한글 인코딩처리 
	
	//페이지
    String pageNum = request.getParameter("pageNum");//넘어온 페이지번호를 저장
    if(pageNum == null){ pageNum = "1";}	//없다면 "1"
    int currentPage = Integer.parseInt(pageNum);//위에서 받은 pageNum을 숫자로 변환해서 현재페이지로 저장	

    int pageSize = 10;//한페이지에 보여지는 게시글 수 10개
	int startRow = (currentPage - 1) * pageSize + 1;//1페이지:1, 2페이지:11, 3페이지 21...
	int endRow = currentPage * pageSize;//1페이지:10, 2페이지:20, 3페이지:30...
	int count = 0;//검색 게시글 수
	int number =0; //화면에 보이는 글번호
	
	DietDAO dao = new DietDAO();
	ArrayList<DietDTO> dietSearchList = null;
	
	count = dao.getSearchDietCount(diet_search,id);
	if(count>0){ dietSearchList=dao.getSearchList(diet_search,startRow,endRow,id);}
	number = count -(currentPage-1)*pageSize;

	
	
if(count==0){%>
	<script>
		alert("검색 결과가 없습니다.");
		history.go(-1);
	</script>
<%}else{%>
<center><b>검색하신 <%=diet_search%>에 해당하는 식단은 총 <%=count%>개 입니다.</b></center><br />
<table border="1" width="800" cellpadding="0" cellspacing="0" align="center"> 
	<tr height="30" bgcolor="#d6cabc" > 
		<th align="center"  width="50"  >번 호</th> 
		<th align="center"  width="150" >날 짜</th>    
		<th align="center"  width="200" >아 침</th> 
	    <th align="center"  width="200" >점 심</th>
	    <th align="center"  width="200" >저 녁</th> 
    </tr>
<%
	for(DietDTO diet : dietSearchList){%>
	<tr height="30">
    	<td align="center"  width="50" ><%=number--%></td>
    	<td align="center"  width="150"><a href="dietCalendarPro.jsp?diet_date=<%=diet.getDiet_date()%>&pageNum=<%=currentPage%>"> <%=diet.getDiet_date()%> </a></td>
    	<td align="center"  width="200"><%if(diet.getBreakfast()!=null){%><%=diet.getBreakfast()%><%}%></td>
    	<td align="center"  width="200"><%if(diet.getLunch()!=null){%><%=diet.getLunch()%><%}%></td> 
    	<td align="center"  width="200"><%if(diet.getDinner()!=null){%><%=diet.getDinner()%><%}%></td>
	</tr>
<%}
}%>

</table>

<br />
<center>
	<%
 if(count >0){
	 int pageCount = count / pageSize +(count % pageSize == 0? 0:1);//페이지 수
	 int startPage =(int)(currentPage/10)*10 +1;
	 int pageBlock = 10;//페이지 번호 10개씩 보이게함
	 int endPage = startPage + pageBlock-1;
	 if(endPage >pageCount){ endPage = pageCount; }
	 if(startPage >10){%>
	 	<a href="dietSearch.jsp?pageNum=<%=startPage-10%>&diet_search=<%=search%>">[이전]</a>
<%	}for(int i=startPage; i<=endPage ;i++){%>
		<a href="dietSearch.jsp?pageNum=<%=i%>&diet_search=<%=search%>">[<%=i%>]</a>	
<%	}if(endPage<pageCount){%>
	 	<a href="dietSearch.jsp?pageNum=<%=startPage+10%>&diet_search=<%=search%>">[다음]</a>
<%	}
}%>



<br />
<form action = "dietSearch.jsp">
	식단 : <input type="text" name="diet_search" />
	<input type="submit" value="검색" />
	<input type="button" value="달력목록" onclick="window.location='dietCalendar.jsp'" />
</form>
</center>

</body>