<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import = "shoppingInfoShare.board.BoardDBBean" %>
<%@ page import = "shoppingInfoShare.board.BoardDataBean" %>
<%@ page import = "java.sql.Timestamp" %>

<% request.setCharacterEncoding("UTF-8");%>

<jsp:useBean id="article" scope="page" class="shoppingInfoShare.board.BoardDataBean" />
<jsp:setProperty name="article" property="*"/>

<%
 
    String pageNum = request.getParameter("pageNum");
	String num = request.getParameter("num");

	BoardDBBean dbPro = new BoardDBBean();
    int check = dbPro.updateArticle(article);
	System.out.println(num +"  "+ pageNum +"   "+ check);
    if(check==1){
%>
	  <meta http-equiv="Refresh" content="0;url=content.jsp?num=<%=num %>&pageNum=<%=pageNum%>&comment_pageNum=1&comment_listNum=0" >
<% }else{%>
      <script language="JavaScript">      
      <!--      
        alert("비밀번호가 맞지 않습니다");
        history.go(-1);
      -->
     </script>
<%
    }
 %>  

 