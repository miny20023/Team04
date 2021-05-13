<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import = "test.model.food.MaNengDBBean" %>
<%@ page import = "test.model.food.MaNengDataBean" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.util.ArrayList" %>
<%@ include file = "../menu.jsp" %>
<body bgcolor="#f0efea">

<%
	// 인코딩
	request.setCharacterEncoding("UTF-8");
	
	// memId 호출
	String memId = (String)session.getAttribute("memId");
	if (memId == null || memId.trim().isEmpty()) {%>
		<script>
			alert("아이디의 세션이 종료 되어서 aaa 계정으로 로그인합니다.");
		</script>
		<%memId = "aaa";
    }
	
	// 임의 페이지 수 게시글 수 정의
	int pageSize = 10;
	
	// 페이지 유효성 검사
	String pageNum = request.getParameter("pageNum");
	if (pageNum == null || pageNum.trim().isEmpty()) {
        pageNum = "1";
    }
	
	int currentPage = Integer.parseInt(pageNum);		// 현재 페이지
    int startRow = (currentPage - 1) * pageSize + 1;	// 현재 페이지 시작 줄 수
    int endRow = currentPage * pageSize;				// 현재 페이지 마지막 줄 수
    int count = 0;										// 재료 수
    int number = 0;										// 재료 순번
    
 	// 재료 list 가져오기
    List ingList = null;
	MaNengDBBean mnDB = new MaNengDBBean();
	count = mnDB.getRefCount(memId+"_refrigerator");	// 냉장고 재료 수
    if(count>0){										
  		ingList = mnDB.getRefs(memId+"_refrigerator", startRow, endRow);
    }																	
    
	// list session 선언
    session.setAttribute("ingList", ingList);
    
    // tempIngList 설정
    List tempIngList = null;
  	tempIngList = (List) session.getAttribute("tempIngList");
  	session.setAttribute("tempIngList", tempIngList);
  	
 // test(전 페이지 값) 호출
    String test = request.getParameter("test");
	int testNum = 0;
    if(test!=null){
    	String [] testArray = test.split(",");
		String getId="",getName="",getAmount="",getUnit="",getFreshness="";
		for(int i = 0; i < testArray.length; i++){
			switch(i%5){
			case 0 :
				getId = testArray[i];
				break;
			case 1 :
				getName = testArray[i];
				break;
			case 2 :
				getAmount = testArray[i];
				break;
			case 3 :
				getUnit = testArray[i];
				break;
			case 4 :
				getFreshness = testArray[i];
				break;
			}
			if(i%5==4) {
			%>
				<input type ="hidden" id = "setName<%=testNum%>" value="<%=getName%>">
				<input type ="hidden" id = "setAmount<%=testNum%>" value="<%=getAmount%>">
				<input type ="hidden" id = "setUnit<%=testNum%>" value="<%=getUnit%>">
				<input type ="hidden" id = "setId<%=testNum%>" value="<%=getId%>">
				<input type ="hidden" id = "setFreshness<%=testNum%>" value="<%=getFreshness%>">
			<%	
				if(tempIngList != null){
					MaNengDataBean ing = new MaNengDataBean();
					boolean tilCheck = true;
					for(int j = 0; j < tempIngList.size(); j++){
						ing = (MaNengDataBean)tempIngList.get(j);
						if(ing.getIngname().equals(getName)){			
							tilCheck = false;
						}
					}
					if(tilCheck){
						ing = new MaNengDataBean();
						ing.setIngname(getName);
						ing.setIng_id(Integer.parseInt(getId));
						ing.setCheck("true");
						ing.setAmount(getAmount);
						ing.setUnit(getUnit);
						ing.setFreshness(getFreshness);
						tempIngList.add(ing);
					}
				}else{
					MaNengDataBean ing = new MaNengDataBean();
					tempIngList = mnDB.getIngs(getName);
					ing = (MaNengDataBean)tempIngList.get(0);
					ing.setCheck("true");
					ing.setAmount(getAmount);
					ing.setUnit(getUnit);
					ing.setFreshness(getFreshness);
				}
			testNum+=1;
			}
		}
	}
    
    number=count-(currentPage-1)*pageSize;
%>
<form name="f2" action="mixRecipeSearch.jsp" method="post">
<input type="hidden" id="search" name="search">
<input type="text" id="keyword" /><input type="submit" value="검색" onclick="javascript:goSearch()"><br/>
<table> 
	<tr> 
		<td>추가</td><td>재료명</td><td>수량</td><td>단위</td><td>유통기한</td>        
    </tr>
</table>
<%if (count == 0) {%>
<table>
	<tr>
   		<td colspan="5">
   			냉장고에 저장된 재료가 없습니다.
   		</td>
   	</tr>
</table>
<%}else{
	for (int i = 0 ; i < ingList.size() ; i++) {	
		MaNengDataBean ing = (MaNengDataBean)ingList.get(i);	// 받은 DB들 풀기
%>	
<table> 
	<tr>
		<td>
		<input type="checkbox" id="ch<%=ing.getIng_id()%>" value="true" onclick="return check(<%=ing.getIng_id()%>);"/>
		</td>
    	<td>
    	<%=ing.getIngname()%>
    	<input type="hidden" id="hiddenName<%=ing.getIng_id()%>" value="<%=ing.getIngname()%>">
    	</td>   	
    	<td>
    	<%=ing.getAmount()%>
    	<input type="hidden" id="hiddenAmount<%=ing.getIng_id()%>" value="<%=ing.getAmount()%>"></td>
    	<td>
    	<%=ing.getUnit()%>
    	<input type="hidden" id="hiddenUnit<%=ing.getIng_id()%>" value="<%=ing.getUnit()%>">
    	</td>
    	<td>
    	<%=ing.getFreshness()%>
    	<input type="hidden" id = "hiddenFreshness<%=ing.getIng_id()%>" value="<%=ing.getFreshness()%>">
    	</td>
	</tr>
<%}}%>
</table>
<button type="button" onclick="javascript:mixCheck();">조합하기</button></br>
<%
	// 페이지 이동
		if (count > 0) {
			int pageCount = count / pageSize + ( count % pageSize == 0 ? 0 : 1);
			int startPage = (int)(currentPage/10)*10+1;
			int pageBlock = 10;
			int endPage = startPage + pageBlock-1;
			if (endPage > pageCount) {endPage = pageCount;}      
			if (startPage > 10) {%>
		<a href="javascript:page(<%= startPage - 10 %>);">[이전]</a>
		 <%}
		for (int i = startPage ; i <= endPage ; i++) {  %>
			<a href="javascript:page(<%=i%>)";>[<%=i%>]</a>
		<%}
		if (endPage < pageCount) {  %>
		<a href="javascript:page(<%= startPage + 10 %>)">[다음]</a>
		<%}}%>
<input type="hidden" id="test" name="test">
<input type="hidden" id="pageNum" name="pageNum">
</form>
</body>
<script type="text/javascript">
var checkedVar = new Array();

if(document.getElementById("setId0")!=null){
	for(let i = 0; i < <%=testNum%>; i++) {
		var array = new Array();
		var id = document.getElementById("setId"+i).value;
		array.push(id);
		array.push(document.getElementById("setName"+i).value);
		array.push(document.getElementById("setAmount"+i).value);
		array.push(document.getElementById("setUnit"+i).value);
		array.push(document.getElementById("setFreshness"+i).value);
		checkedVar.push(array);
		
		if(document.getElementById("ch"+id)){
			document.getElementById("ch"+id).checked = true;			
		}
	}
	document.getElementById("test").value = checkedVar;
}

function goSearch(){
	document.getElementById("search").value = document.getElementById("keyword").value;
}

function page(pageNum){
	document.f2.action = "mixRecipe.jsp";
	document.getElementById("pageNum").value = pageNum;
	document.f2.submit();
}

function mixCheck() {
	if (confirm("선택하신 재료로 조합하시겠습니까?")){
		document.f2.action = "mixRecipePro.jsp";
		document.f2.submit();
	}else{
	return false;
	}
}

function check(ingId){
	var chName = document.getElementById("hiddenName"+ingId).value;
	for(let i = 0; i < checkedVar.length; i++) {
		var newArray = checkedVar[i];
		var verId = newArray[0];
		
		if(verId == ingId) {
			checkedVar.splice(i, 1);
			i--;
			document.getElementById("test").value = checkedVar;
			alert(chName + "이/가 체크 해제 되었습니다");
			return true;
		}
	}
	var newArray = new Array();	
	newArray.push(ingId);
	newArray.push(chName);
	newArray.push(document.getElementById("hiddenAmount"+ingId).value);
	newArray.push(document.getElementById("hiddenUnit"+ingId).value);
	newArray.push(document.getElementById("hiddenFreshness"+ingId).value);
	checkedVar[checkedVar.length] = newArray;
	document.getElementById("test").value = checkedVar;
	alert(chName + "이/가 체크 되었습니다");
	return true;	
}
</script>
