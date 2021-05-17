<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="recipe.bean.RecipeCommentDAO" %>
<%@ page import="recipe.bean.RecipeCommentDTO" %>

<% 
	String id = (String) session.getAttribute("memId");
	
	int comment_listNum = Integer.parseInt(request.getParameter("comment_listNum"));
	System.out.println("recipeCommentList의 comment_listNum ="+comment_listNum);
	
	int num = Integer.parseInt(request.getParameter("num"));
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	String pageNum = request.getParameter("pageNum");
	
	if(pageNum == null){
		pageNum = "1";
	}
	
	int pageSize = 10;
	int currentPage = Integer.parseInt(pageNum);
	int startRow = (currentPage - 1) * pageSize + 1;
	int endRow = currentPage * pageSize;
	int count = 0;
	int number = 0;
	
	RecipeCommentDAO daorc = new RecipeCommentDAO();
	
	List recipeCommentList = null;
	count = daorc.getRecipeCommentCount(num);
	if(count > 0){
		recipeCommentList = daorc.getRecipeComments(startRow, endRow, num);
	}
	
	number = count - (currentPage - 1) * pageSize;
%>
<center><b> 전체 댓글 : <%=count %></b>
<%if(count == 0){ %>
	<table border="1" width="600" cellpadding="0" cellspacing="0" align="center">
		<tr><td align="center">댓글이 없습니다.</td></tr>
	</table>
<%} else{ %>
	<table border="1" width="600" cellpadding="0" cellspacing="0" align="center">
	<%	for(int i = 0; i < recipeCommentList.size(); i++){
			RecipeCommentDTO recipeComment = (RecipeCommentDTO) recipeCommentList.get(i);
			int comment_num = recipeComment.getComment_num();
			int listNum = i + 1;				// 출력된 댓글 번호 (위에 보이는 댓글이 1)
			String level_space = "";		// 대댓글 들여쓰기
			for(int j = 0; j < recipeComment.getRe_level(); j++){
				level_space = level_space + "&emsp;" + "&emsp;";		// 들여쓰기
			}
			
	%>		
			<tr height="50">
				<td width="400">
					<%=level_space%><%=recipeComment.getComment_id() %></br>
					<%=level_space%><%=recipeComment.getComment_text() %></br>
					<%=level_space%><%=sdf.format(recipeComment.getReg_date()) %>
				</td>
				<td align="center" width="50">
					<%if(comment_listNum != listNum || comment_listNum == 0) { 	//대댓글 작성 창 열림%>
					<a href="recipeContentForm.jsp?pageNum=<%=pageNum%>&num=<%=num%>&random_id=0&comment_listNum=<%=listNum %>">댓글달기</a>
				<%	} else {													//대댓글 작성창 열린 상태에서 클릭 -> 대댓글 작성창 닫힘%>
					<a href="recipeContentForm.jsp?pageNum=<%=pageNum%>&num=<%=num%>&random_id=0&comment_listNum=0">댓글달기</a>
				<%	} %>
				</td>
				<td align="center" width="50">
					<a href="recipeCommentDeleteForm.jsp?pageNum=<%=pageNum%>&num=<%=num%>&random_id=0&comment_num=<%=comment_num %>" 
					onclick="window.open(this.href,'댓글삭제','width=200,height=300');return false;">댓글삭제</a>
				</td>
			</tr>
		<%	if(comment_listNum == listNum){ 
				//int comment_num = recipeComment.getComment_num();
				System.out.println("recipeCommentList의 comment_num ="+comment_num);%>
			<tr>
				<td colspan="3">
				<form action="recipeCommentWritePro.jsp" method="post">
				<input type="hidden" name="comment_id" value="<%=id %>" /> <%=id %>
				<input type="hidden" name="num" value="<%=num %>" />
				<input type="hidden" name="comment_listNum" value=<%=listNum %> />
				<input type="hidden" name="pageNum" value=<%=pageNum %> />
				<input type="hidden" name="comment_num" value=<%=comment_num %> />
				<textarea cols="70" rows="5" name="comment_text"></textarea>
				<input type="submit" value="댓글 등록" /> </br>	
				</form>
				</td>
			</tr>
		<%	} %>
	<%	}
	} %>
	</table>
	
<%
    if (count > 0) {
        int pageCount = count / pageSize + ( count % pageSize == 0 ? 0 : 1);
		 
        int startPage = (int)(currentPage/10)*10+1;
		int pageBlock=10;
        int endPage = startPage + pageBlock-1;
        if (endPage > pageCount) endPage = pageCount;
        
        if (startPage > 10) {    %>
        <a href="recipeContentForm.jsp?pageNum=<%= startPage - 10 %>&num=<%=num%>&random_id=0&comment_listNum=<%=comment_listNum%>">[이전]</a>
<%      }
        for (int i = startPage ; i <= endPage ; i++) {  %>
        	<a href="recipeContentForm.jsp?pageNum=<%= i %>&num=<%=num%>&random_id=0&comment_listNum=<%=comment_listNum%>">[<%= i %>]</a>
<%		}
        if (endPage < pageCount) {  %>
        	<a href="recipeContentForm.jsp?pageNum=<%= startPage + 10 %>&num=<%=num%>&random_id=0&comment_listNum=<%=comment_listNum%>">[다음]</a>
        	
<%		}
    }
%>
	
</center>