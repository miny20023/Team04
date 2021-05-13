<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="member.bean.ScrapDTO" %>
<%@ page import="member.bean.ScrapDAO" %>
<%@ include file = "../menu.jsp" %>
<body bgcolor="#f0efea">
<%
	id = (String) session.getAttribute("memId");
	if(id == null) {%>
		<script>
			alert("로그인을 해주세요.");
			history(-1);
		</script>
<%	}
	int pageSize = 10; 
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null){
		pageNum = "1";
	}
	
	int currentPage = Integer.parseInt(pageNum);
	int startRow = (currentPage - 1) * pageSize + 1;
	int endRow = currentPage * pageSize + 1; //
	int count = 0; // 전체게시물 수
	int number = 0; // 한 페이지에 보일 글 목록 수
	
	List recipeList = null;
	ScrapDAO dao = new ScrapDAO();
	count = dao.getScrapCount(id); 			// 찜한 게시글 숫자
	int master = dao.getMemberMaster(id); 	// 회원권한 조회
	if(count > 0){
		recipeList = dao.getScrapList(startRow, endRow, id);
	}
	
	number = count-(currentPage-1)*pageSize;
%>
	<center> <b><%=id%>님의 찜목록(<%=count %>)</b>
	

    <table border="1" width="700" cellpadding="0" cellspacing="0" align="center">
    <tr height="30" bgcolor="#d6cabc">
    	<td align="center" width="50">번 호</td>
    	<td align="center" width="300">요리명</td>
    	<td align="center" width="100">작성자</td>
    	<td align="center" width="100">작성일</td>
    	<td align="center" width="50">조 회</td>
    	<td align="center" width="50">추 천</td>
    	<%if(master == 2) {%>
    		<td align="center" width="50">승 인</td>
    	<%} %>
    </tr>

    <%
    	for(int i = 0; i < count; i++){
    		ScrapDTO recipe = (ScrapDTO)recipeList.get(i);
    		int status = recipe.getStatus();
    		if(status != 0 ){
    			if(master == 2){ %>
    			<tr>
    		    	<td align="center" width="50"><%=number %></td>
    		    	<td align="center" width="300">
    		    		<a href="recipeScrapContentForm.jsp?num=<%=recipe.getNum()%>&pageNum=<%=currentPage%>">
    		    			<%if(recipe.getReccommend() >= 5){%> <font color="red"> ☆<%} %><%=recipe.getName() %>
    		    			<%if(recipe.getReccommend() >= 5){%> ★</font> <%} 			// 인기글(추천수 5이상)%><a>
    		    	</td>
    		    	<td align="center" width="100"><%=recipe.getWriter() %></td>
    		    	<td align="center" width="100"><%=recipe.getDay() %></td>
    		    	<td align="center" width="50"><%=recipe.getReadcount() %></td>
    		    	<td align="center" width="50"><%=recipe.getReccommend() %></td>
    		    	<td align="center" width="50"><input type="checkbox" name="status" <%if(status==2){ %>checked <%} %>/></td>
    		    </tr>
<%    			}else{ 
					if(status == 2 || recipe.getWriter().equals(id)){%>
				    <tr>
				    	<td align="center" width="50"><%=number %></td>
				    	<td align="center" width="300">
				    		<%if(master == 0) {%>
		    		    		<a href="recipeScrapContentForm.jsp?num=<%=recipe.getNum()%>&pageNum=<%=currentPage%>">
		    		    			<%if(recipe.getReccommend() >= 5){%> <font color="red"> ☆<%} %><%=recipe.getName() %>
		    		    			<%if(recipe.getReccommend() >= 5){%> ★</font> <%}		// 인기글(추천수 5이상)%><a>	
		    		    		<%if (recipe.getStatus() == 1){ %>							
		    		    			미승인
		    		    		<% }%>				    		
		    		    	<%}else{ %>
				    			<%if(recipe.getReccommend() >= 5){%> <font color="red"> ☆<%} %><%=recipe.getName() %>
		    		    		<%if(recipe.getReccommend() >= 5){%> ★</font> <%} 			// 인기글(추천수 5이상)%>
				    		<%}%>
				    	</td>
				    	<td align="center" width="100"><%=recipe.getWriter() %></td>
				    	<td align="center" width="100"><%=recipe.getDay() %></td>
				    	<td align="center" width="50"><%=recipe.getReadcount() %></td>
				    	<td align="center" width="50"><%=recipe.getReccommend() %></td>
				    </tr>
			    <%	}
				}
    		}%>
    <%	number--;
    	}
    %>
    </table>
  
	<% 
		if(count > 0){
			int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
			int startPage = (int)(currentPage/10)*10 + 1;
			int pageBlock = 10;
			int endPage = startPage + pageBlock - 1;
			if(endPage > pageCount){
				endPage = pageCount;
			}
			if(startPage > 10){%>
				<a href="recipeScrapForm.jsp?pageNum=<%=startPage - 10 %>">[이전]</a>	
<% 			}
			for(int i = startPage; i <= endPage; i++){ %>
				<a href="recipeScrapForm.jsp?pageNum=<%=i %>">[<%= i%>]</a>	
<% 			}
			if(endPage < pageCount){%>
				<a href="recipeScrapForm.jsp?pageNum=<%=startPage + 10 %>">[다음]</a>
<% 			}
		}
	
	%>
	</center>
	
	</body>
	