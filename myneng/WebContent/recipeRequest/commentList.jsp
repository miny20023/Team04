<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import = "recipeRequest.comment.CommentDBBean" %>
<%@ page import = "recipeRequest.comment.CommentDataBean" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ include file="color.jsp"%>

<script language="JavaScript" src="script.js">
</script>

<%
	int comment_listNum = Integer.parseInt(request.getParameter("comment_listNum"));
    int pageSize = 10;				// 한 페이지에 보여질 게시물 수
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");		// 작성 날짜 해당 형식으로 보기 위함 아래 91번 라인에서 사용

    String pageNum = request.getParameter("pageNum");		// 리스트에서 페이지 번호 클릭 시 
    String comment_pageNum = request.getParameter("comment_pageNum");
    if (pageNum == null) {
        pageNum = "1";
    }

    int currentPage = Integer.parseInt(comment_pageNum); //	1
    int startRow = (currentPage - 1) * pageSize + 1;
    int endRow = currentPage * pageSize;	// 1 * 10 = 10
    int count = 0;		// 전체 게시물 수 
    int number=0;		// 화면 글 번호

    List articleList = null;
    int num = Integer.parseInt(request.getParameter("num"));
    CommentDBBean dbPro =new CommentDBBean();
    count = dbPro.getArticleCount_comment(num);
    if (count > 0) {
        articleList = dbPro.getArticles(startRow, endRow, num);
    }

	number=count-(currentPage-1)*pageSize;  
	
	String id = (String)session.getAttribute("memId");
%>
<html>
<head>
<title>게시판</title>
<link href="style.css" rel="stylesheet" type="text/css">
</head>

<body bgcolor="<%=bodyback_c%>">
<center><b>댓글(전체 댓글:<%=count%>)</b>


<%if (count == 0) {%>
	<table width="500" border="1" cellpadding="0" cellspacing="0">
		<tr>
    		<td align="center">
    			게시판에 저장된 글이 없습니다.
    		</td>
    	</tr>
	</table>

<%  } else {    %>
<table border="1" width="600" cellpadding="0" cellspacing="0" align="center"> 
<%	for (int i = 0 ; i < articleList.size() ; i++) {
    	CommentDataBean article = (CommentDataBean)articleList.get(i);
    	int listNum = i+1;
    	String level_space = "";
    	for(int a = 0; a<article.getRe_level(); a++)
    	{
    		level_space = level_space + "&emsp;" + "&emsp;";
    	}
%>
	<tr height="50" >
    	<td width="400" > 
    		<%=level_space%><%=article.getComment_id()%></br>
    	 	<%=level_space%><%=article.getComment_text()%><br>
    	 	<%=level_space%><%= sdf.format(article.getReg_date())%></td>
    	 <td align="center" width="50">
    	 	<%if(comment_listNum != listNum || comment_listNum == 0)
    	 	{%>
    	 		<a href="content.jsp?num=<%=num%>&pageNum=<%=pageNum%>&comment_pageNum=<%=comment_pageNum %>&comment_listNum=<%=listNum%>">
        	 	댓글달기</a>
    	 	<%}
    	 	else
    	 	{%>
    	 		<a href="content.jsp?num=<%=num%>&pageNum=<%=pageNum%>&comment_pageNum=<%=comment_pageNum %>&comment_listNum=0">
        	 	댓글달기</a>
    	 	<%} %>
    	 	
    	 </td>
    	 <%if(article.getComment_id().equals(id)) 
    	 {%>
    	 <td align="center" width="50">
    	 	<a href="commentDeletePro.jsp?num=<%=num %>&pageNum=<%=pageNum %>&comment_pageNum=<%=comment_pageNum %>&listNum=<%=listNum %>"
    	 	onclick="return confirm('댓글을 삭제하시겠습니까?');">
    	 	댓글삭제</a>
    	 </td>
    	 <%}
    	 else
    	 {%>
    		 <td align="center" width="50">

    	 	</td>
    	 <%}%>
	</tr>
	<%
		if(comment_listNum == listNum)
		{%>
			<tr>
				<td colspan="3">
				<form method="post" name="comment_content" action="commentWritePro.jsp" onsubmit="return writeSave()">
				<input type="hidden" name="comment_id" value="<%=id %>"><%=id %>
				<input type="hidden" name="num" value="<%=num %>">
				<input type="hidden" name="comment_listNum" value=<%=listNum %>>
				<input type="hidden" name="pageNum" value=<%=pageNum %>>
				<input type="hidden" name="comment_pageNum" value=<%=comment_pageNum %>>
				<textarea cols = "70" rows "10" name="comment_text"></textarea>
				<input type="submit" value="댓글 등록"></br>
				</form></td>
			</tr>
		<%}
	%>
	
    <%}%>
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
        <a href="content.jsp?num=<%=num %>&pageNum=<%=pageNum %>&coment_pageNum=<%= startPage - 10 %>&comment_listNum=0">[이전]</a>
<%      }
        for (int i = startPage ; i <= endPage ; i++) {  %>
        	<a href="content.jsp?num=<%=num %>&pageNum=<%= pageNum %>&comment_pageNum=<%=i %>&comment_listNum=0">[<%= i %>]</a>
<%		}
        if (endPage < pageCount) {  %>
        	<a href="content.jsp?num=<%=num %>&pageNum=<%=pageNum %>&coment_pageNum=<%= startPage + 10 %>&comment_listNum=0">[다음]</a>
<%		}
    }
%>
</center>
</body>
</html>