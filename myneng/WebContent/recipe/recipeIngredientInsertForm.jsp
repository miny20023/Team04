<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.util.ArrayList" %>
<%@ page import="cook.bean.CookDTO" %>
<%@ page import="cook.bean.CookDAO" %>

<%
	request.setCharacterEncoding("UTF-8");

	String id = (String) session.getAttribute("memId");
	int rec_id = Integer.parseInt(request.getParameter("rec_id"));
	//int random_id = Integer.parseInt(request.getParameter("random_id"));
	int random_id = (int) session.getAttribute("random_id");
	
	System.out.println("recipeIngredientInsertForm의 random_id ="+random_id);
	int pageSize = 10;
	
	String pageNum = request.getParameter("pageNum");
	if (pageNum == null) {
        pageNum = "1";
    }
	 
	int currentPage = Integer.parseInt(pageNum);
    int startRow = (currentPage - 1) * pageSize + 1;
    int endRow = currentPage * pageSize;
    int count = 0;
    int number = 0;
    
    List ingList = null;
	CookDAO daoc = new CookDAO();
	count = daoc.getIngCount();
    if(count>0){
    	ingList = daoc.getIng(startRow, endRow);
    }
    session.setAttribute("ingList", ingList);
    
    number=count-(currentPage-1)*pageSize;
%>

<form name="f1" action="recipeIngredientInsertForm.jsp" method="post">
<input type="text" name="search" /><input type="submit" value="검색" /><br/>
</form>
<form name="f2" action="recipeIngredientInsertPro.jsp?rec_id=<%=rec_id %>&random_id=<%=random_id %>" method="post">
<table> 
	<tr> 
		<td>추가</td>
		<td>재료명</td> 
	    <td>수량</td>
	    <td>단위</td>
	    <td>유통기한</td>        
    </tr>
</table>    
<%	
	for (int i = 0 ; i < ingList.size() ; i++) {	// 제너릭을 안 쓰기 때문에 바꿔주는 작업	
	CookDTO ing = (CookDTO)ingList.get(i); 
%>
<table>
	<tr>
		<td><input type="checkbox" name="check<%=i%>" value="true"></td>
    	<td><%=ing.getIng_name()%></td>
    	<td><input type="text" name="amount<%=i%>"></td>
    	<td>
		<select name="unit<%=i%>">
      		<option value="check">단위선택</option>
      		<option value="g">g</option>
      		<option value="ml">ml</option>
      		<option value="cm^3">cm^3</option>
      		<option value="개">개</option>
      		<option value="마리">마리</option>
      </select>		
      </td>
	</tr>
</table>
<%}%>
<input type="submit" value="추가하기"/>
<input type="button" value="완료하기" onclick="sendClose()"/><br />
<%
if (count > 0) {
	int pageCount = count / pageSize + ( count % pageSize == 0 ? 0 : 1);
	int startPage = (int)(currentPage/10)*10+1;
	int pageBlock = 10;
	int endPage = startPage + pageBlock-1;
	if (endPage > pageCount) {endPage = pageCount;}      
	if (startPage > 10) {%>

<a href="recipeIngredientInsertForm.jsp?rec_id=<%=rec_id %>&pageNum=<%= startPage - 10 %>&random_id=<%=random_id%>">[이전]</a>
 <%}
for (int i = startPage ; i <= endPage ; i++) {  %>
 		<a href="recipeIngredientInsertForm.jsp?rec_id=<%=rec_id %>&pageNum=<%=i%>&random_id=<%=random_id%>">[<%=i%>]</a>
 <%}
if (endPage < pageCount) {  %>
<a href="recipeIngredientInsertForm.jsp?rec_id=<%=rec_id %>&pageNum=<%= startPage + 10 %>&random_id=<%=random_id%>">[다음]</a>
<%}}%>
</form>

<script>
	function sendClose(){
		var random_id = <%=random_id%>;
		var num = <%=rec_id%>;
		self.close();
		opener.window.location="recipeIngredientUpdateForm.jsp?num="+num+"&random_id="+random_id;
	}
</script>

