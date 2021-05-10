<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import = "cartBoard.BoardDBBean" %>
<%@ page import = "cartBoard.BoardDataBean" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ include file="color.jsp"%>
<%@ page import = "java.util.List" %>
<html>
<head>
<jsp:include page="../menu.jsp"/>
<title>게시판</title>
<link href="style.css" rel="stylesheet" type="text/css">
</head>
<%
	int comment_listNum = Integer.parseInt(request.getParameter("comment_listNum"));
	int num = Integer.parseInt(request.getParameter("num"));  						
	String pageNum = request.getParameter("pageNum");								
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
   
	BoardDBBean dbPro = new BoardDBBean();
	BoardDataBean article =  dbPro.getArticle(num);

%>
<body bgcolor="<%=bodyback_c%>">  
<center><b>글내용 보기</b>
<br>
<table width="500" border="1" cellspacing="0" cellpadding="0"  bgcolor="<%=bodyback_c%>" align="center">  
	<tr height="30">
		<td align="center" width="125" bgcolor="<%=value_c%>">글번호</td>
		<td align="center" width="125" align="center"><%=article.getNum()%></td>
	    <td align="center" width="125" bgcolor="<%=value_c%>">조회수</td>
	    <td align="center" width="125" align="center"><%=article.getReadcount()%></td>
  </tr>
  <tr height="30">
	    <td align="center" width="125" bgcolor="<%=value_c%>">작성자</td>
	    <td align="center" width="125" align="center"><%=article.getWriter()%></td>
	    <td align="center" width="125" bgcolor="<%=value_c%>" >작성일</td>
	    <td align="center" width="125" align="center"><%= sdf.format(article.getReg_date())%></td>
  </tr>
  <tr height="30">
		<td align="center" width="125" bgcolor="<%=value_c%>">글제목</td>
		<td align="center" width="375" align="center" colspan="3"><%=article.getSubject()%></td>
  </tr>
  <tr>
	    <td align="center" width="125" bgcolor="<%=value_c%>">글내용</td>
	    <td align="left" width="375" colspan="3"><pre><%=article.getContent()%></pre></td>
  </tr>
  <tr height="30">      
	    <td colspan="4" bgcolor="<%=value_c%>" align="right" > 
	    	
	    	<%
	    		String id = (String)session.getAttribute("memId");
	    		if(id != null){ 
	    			if(id.equals(article.getWriter())){%>
						<input type="button" value="글수정" onclick="window.location='updateForm.jsp?num=<%=article.getNum()%>&pageNum=<%=pageNum%>'">
						<input type="button" value="글삭제" onclick="window.location='deleteForm.jsp?num=<%=article.getNum()%>&pageNum=<%=pageNum%>'">
						</br>
						<%} 
						// 요기 다음 줄(?)에 답글쓰기가 있었음.
						%>
					
				<%} 
			%>
			
			<input type="button" value="글목록" onclick="window.location='groupBuying.jsp?pageNum=<%=pageNum%>'"></br>
					
	    </td>
  </tr>
</table>
<%
	int numForComment = article.getNum();
	int pageNumForComment = article.getPageNum();
	String current_url = request.getRequestURL().toString();
	if(request.getQueryString() != null)
	{
		current_url = current_url +"?"+request.getQueryString();
	}
%>

<jsp:include page = "commentList.jsp">
	<jsp:param name = "num" value ="<%=numForComment %>"/>
	<jsp:param name = "comment_listNum" value = "<%=comment_listNum %>"/>
</jsp:include>

<jsp:include page = "commentWrite.jsp">
	<jsp:param name = "num" value ="<%=numForComment %>" />
	<jsp:param name = "pageNum" value="<%=pageNum %>"/>
	<jsp:param name = "comment_listNum" value = "<%=comment_listNum %>"/>
	<jsp:param name = "current_url" value ="<%=current_url %>"/>
</jsp:include>
</body>
</html>     