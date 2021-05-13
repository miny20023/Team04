<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.util.ArrayList" %>
<%@ page import="cook.bean.CookDAO" %>
<%@ page import="cook.bean.CookDTO" %>

<%
	request.setCharacterEncoding("UTF-8");

	String id = (String) session.getAttribute("memId");
	int rec_id = Integer.parseInt(request.getParameter("num"));
	int random_id = Integer.parseInt(request.getParameter("random_id"));
	if(random_id==0 && session.getAttribute("random_id") == null){
		random_id = (int) (Math.random()*90000 + 10000); // 임시값 10000 ~ 100000 사이 난수 생성
		session.setAttribute("random_id", random_id);
	}
	if(session.getAttribute("random_id") != null){
		random_id = (int) session.getAttribute("random_id");
	}
	System.out.println("recipeIngredientUpdateForm의 random_id = "+random_id);
 
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
    
    List ingList = null;							// 기존 재료 리스트
    List ingList2 = null;							// 새로 추가한 재료 리스트
	CookDAO daoc = new CookDAO();
	
	count = daoc.getIngCount(rec_id) + daoc.getIngCount(random_id);	
    if(count>0){
    	 ingList = daoc.getIng(rec_id); 
    	 ingList2 = daoc.getIng(random_id);
    }
    session.setAttribute("ingList", ingList);
    session.setAttribute("ingList2", ingList2);
    
    number=count-(currentPage-1)*pageSize;
%>
<b>재료 목록(전체 재료:<%=count%>)</b><br/>
<form name=f1 action="recipeIngredientUpdatePro.jsp?rec_id=<%=rec_id %>" method="post">
<table> 
	<tr> 
		<td>추가</td>
		<td>재료명</td> 
	    <td>수량</td>
	    <td>단위</td>
    </tr>
</table>
<%if (count == 0) {%>
<table>
	<tr>
   		<td colspan="5">
   			재료를 추가해 주세요
   		</td>
   	</tr>
</table>
<%}else{	
	// 기존 재료 불러오기
	if(daoc.getIngCount(rec_id) > 0){
		for (int i = 0 ; i < ingList.size() ; i++) {
			CookDTO ing = (CookDTO)ingList.get(i);
			if(daoc.getIngCount(random_id) > 0){
				for(int j = 0; j < ingList2.size(); j++){
					CookDTO ing2 = (CookDTO)ingList2.get(j);
					if(ing.getIng_id() == ing2.getIng_id()){
						if(++i != ingList.size()){
							ing = (CookDTO)ingList.get(i);
						} else{
							ing = null;
						}
					}
				}
			}
		if(ing != null){
			String a = "";
			String b = "";
			String c = "";
			String d = "";
			String e = "";
			String f = "";
			
			String w = ing.getUnit();%>
			<table> 
				<tr>
					<td><input type="checkbox" name="check<%=i%>" value="true"></td>
			    	<td><%=ing.getIng_name()%></td>   	
			    	<td>
			    	<button type="button" onclick="return a();" >+</button>
			    	<input type="text" name="amount<%=i%>" value="<%=ing.getAmount()%>" size="1">
			    	<button type="button" onclick="return s();">-</button>
			    	</td>
	    	<td>
	<%
			if(w != null) { 
				if(w.equals("g")){
					b = "selected";
				}else if(w.equals("ml")){
					c = "selected";
				}else if(w.equals("cm^3")){
					d = "selected";
				}else if(w.equals("개")){
					e = "selected";
				}else if(w.equals("마리")){
					f = "selected";
				}else{
					a = "selected";
				}
			}%>
	    	<select name="unit<%=i%>">
	    	<option value="check" <%=a%>>단위선택</option>
			<option value="g" <%=b%>>g</option>
			<option value="ml" <%=c%>>ml</option>
			<option value="cm^3" <%=d%>>cm^3</option>
			<option value="개" <%=e%>>개</option>
			<option value="마리" <%=f%>>마리</option>
			</select>
			</td>
		</tr>
		</table>	
<%	}}}
	
	// 새로 추가한 재료 불러오기
	if(daoc.getIngCount(random_id) > 0){
		for (int i = 0 ; i < ingList2.size() ; i++) {
			CookDTO ing2 = (CookDTO)ingList2.get(i);
			String a = "";
			String b = "";
			String c = "";
			String d = "";
			String e = "";
			String f = "";
			
			String w = ing2.getUnit();%>
		<table>
		<tr>
			<td><input type="checkbox" name="check2<%=i%>" value="true"></td>
	    	<td><%=ing2.getIng_name()%></td>   	
	    	<td>
	    	<button type="button" onclick="return a();" >+</button>
	    	<input type="text" name="amount2<%=i%>" value="<%=ing2.getAmount()%>" size="1">
	    	<button type="button" onclick="return s();">-</button>
	    	</td>
	    	<td>
	<%
			if(w != null) { 
				if(w.equals("g")){
					b = "selected";
				}else if(w.equals("ml")){
					c = "selected";
				}else if(w.equals("cm^3")){
					d = "selected";
				}else if(w.equals("개")){
					e = "selected";
				}else if(w.equals("마리")){
					f = "selected";
				}else{
					a = "selected";
				}
			}%>
	    	<select name="unit2<%=i%>">
	    	<option value="check" <%=a%>>단위선택</option>
			<option value="g" <%=b%>>g</option>
			<option value="ml" <%=c%>>ml</option>
			<option value="cm^3" <%=d%>>cm^3</option>
			<option value="개" <%=e%>>개</option>
			<option value="마리" <%=f%>>마리</option>
			</select>
			</td>
		</tr>
		</table>
	    <%}
	}
}%>
    
<input type="submit" value="수정하기" onclick="return updateCheck();"/>
<input type="button" value="추가하기" onclick="window.open('recipeIngredientInsertForm.jsp?rec_id=<%=rec_id%>&random_id=<%=random_id %>','재료추가','width=600,height=600')" />
<input type="submit" value="삭제하기" onclick="return removeCheck();"/>
<input type="button" value="수정/추가 취소하기" onclick="window.location='recipeIngredientCanclePro.jsp?rec_id=<%=rec_id %>'" /> 
<input type="button" value="돌아가기" onclick="window.close()"/><br/>
<%
if (count > 0) {
	int pageCount = count / pageSize + ( count % pageSize == 0 ? 0 : 1);
	int startPage = (int)(currentPage/10)*10+1;
	int pageBlock = 10;
	int endPage = startPage + pageBlock-1;
	if (endPage > pageCount) {endPage = pageCount;}      
	if (startPage > 10) {%>
<a href="recipeIngredientUpdateForm.jsp?num=<%=rec_id%>&random_id=<%=random_id %>&pageNum=<%= startPage - 10 %>">[이전]</a>
 <%}
for (int i = startPage ; i <= endPage ; i++) {  %>
 	<a href="recipeIngredientUpdateForm.jsp?num=<%=rec_id%>&random_id=<%=random_id %>&pageNum=<%=i%>">[<%=i%>]</a>
 <%}
if (endPage < pageCount) {  %>
	<a href="recipeIngredientUpdateForm.jsp?num=<%=rec_id%>&random_id=<%=random_id %>&pageNum=<%= startPage + 10 %>">[다음]</a>
<%}}%>

</form>
<script type=text/javascript>
function updateCheck() {
	if (confirm("수정하시겠습니까?")){
	}else{
	return false;
	}
}

function removeCheck() {
	if (confirm("삭제하시겠습니까?")){
		var rec_id = <%=rec_id%>;
		f1.action='recipeIngredientDeletePro.jsp?rec_id='+rec_id;
	}else{
	return false;
	}
}

</script>
