<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "cartBoard.BoardDBBean" %>
<%@ page import = "cartBoard.BoardDataBean" %>   
<%@ page import = "java.util.List" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ include file = "color.jsp" %> 

<%
	int comment_listNum = 0;
	int pageSize = 10;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null)
	{
		pageNum = "1";
	}
	
	int currentPage = Integer.parseInt(pageNum);
	int startRow = (currentPage - 1) * pageSize + 1;
	int endRow = currentPage * pageSize;
	int count = 0;
	int number = 0;
	
	List articleList = null;
	BoardDBBean dbPro = new BoardDBBean();
	count = dbPro.getArticleCount();
	if(count > 0 )
	{
		articleList = dbPro.getArticles(startRow, endRow);
	}
	
	number = count - (currentPage-1) * pageSize;
	
	String id = (String)session.getAttribute("memId");
%>
    
<html>
<head>
<title>게시판</title>
<link href="style.css" rel="stylesheet" type="text/css">
</head>

<body bgcolor="<%=bodyback_c %>">
	<center><b>글 목록 (전체 글 : <%= count %> )</b>
		<table width="700">
			<tr>
				<td align="right" bgcolor="<%=value_c%>">
					<%if(id != null) 
					{%>
						<a href="writeForm.jsp">글쓰기</a>
						<a href="myList.jsp">나의 작성글 목록</a>
					<%}
					else
					{%>
						<a href="/myneng/tmp/loginForm.jsp">로그인</a>
					<%} %>
				</td>
			</tr>
		</table>
		
	<%if (count == 0) 
	{%>
		<table width="700" border="1" cellpadding="0" cellspacing="0">
			<tr>
    			<td align="center">
    				게시판에 저장된 글이 없습니다.
    			</td>
    		</tr>
		</table>
	<%} 
	else 
	{%>
		<table border="1" width="700" cellpadding="0" cellspacing="0" align="center"> 
			<tr height="30" bgcolor="<%=value_c%>"> 
				<td align="center"  width="50"  >번 호</td> 
				<td align="center"  width="250" >제   목</td> 
	   			<td align="center"  width="100" >작성자</td>
	   			<td align="center"  width="150" >작성일</td> 
	   			<td align="center"  width="50" >조 회</td> 
	   			<td align="center"  width="100" >IP</td>    
    		</tr>
    	<%
    	for(int i = 0; i < articleList.size(); i++)
    	{
    		BoardDataBean article = (BoardDataBean)articleList.get(i);
    	%>
    	<tr height = "30">
    		<td align="center" width="50"> <%=article.getNum()%></td>
    		<td width="250" >
    			<a href="content.jsp?num=<%=article.getNum()%>&pageNum=<%=currentPage%>&comment_listNum=<%=comment_listNum%>">
    				<%=article.getSubject()%>
    			</a>
		</td>
    	<td align="center"  width="100"> 
			<a href="mailto:<%=article.getEmail()%>"><%=article.getWriter()%></a>
		</td>
    	<td align="center"  width="150"><%= sdf.format(article.getReg_date())%></td>
    	<td align="center"  width="50"><%=article.getReadcount()%></td>
    	<td align="center" width="100" ><%=article.getIp()%></td>
	</tr>
    <%}

    %>
</table>
<%}%>

<%
    if (count > 0) {
        int pageCount = count / pageSize + ( count % pageSize == 0 ? 0 : 1);
		 
        int startPage = (int)(currentPage/10)*10+1;
		int pageBlock=10;
        int endPage = startPage + pageBlock-1;
        if (endPage > pageCount) endPage = pageCount;
        
        if (startPage > 10) {    %>
        <a href="groupBuying.jsp?pageNum=<%= startPage - 10 %>">[이전]</a>
<%      }
        for (int i = startPage ; i <= endPage ; i++) {  %>
        	<a href="groupBuying.jsp?pageNum=<%= i %>">[<%= i %>]</a>
<%		}
        if (endPage < pageCount) {  %>
        	<a href="groupBuying.jsp?pageNum=<%= startPage + 10 %>">[다음]</a>
<%		}
    }
%>

		<form action="searchList.jsp" method="post">
			<select name="col">
				<option value="subject">제목</option>
				<option value="writer">작성자</option>
			</select>
			<input type="text" name="search" />
			<input type="submit" value="검색" />
		</form>

	
	</center>
</body>
</html>


    