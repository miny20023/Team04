<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import = "test.model.food.MaNengDBBean" %>
<%@ page import = "test.model.food.MaNengDataBean" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.util.ArrayList" %>
<%@ page import = "java.net.URLEncoder" %>
<%@ include file = "../menu.jsp" %>
<body bgcolor="#f0efea">

<%
	// 인코딩
	request.setCharacterEncoding("UTF-8");

	//search 값 가져오기
	String search = request.getParameter("search");
	String se = "";
	if(search == null || search.trim().isEmpty()){%>
		<script>
			alert("검색어가 입력되지 않았습니다.");
			window.location="update.jsp"
		</script>
		<%
	}else{
		se = URLEncoder.encode(search, "UTF-8");
	}

	// memId 호출
	String memId = (String)session.getAttribute("memId");
	if (memId == null || memId.trim().isEmpty()) {%>
		<script>
			alert("아이디의 세션이 종료 되어서 aaa 계정으로 로그인합니다.");
		</script>
		<%memId = "aaa";
	}
	
	// 임의 페이지수 게시글 수 정의
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
    boolean c = false;
    
 	// inglist 호출
    List ingList = null;								
	MaNengDBBean mnDB = new MaNengDBBean();
	count = mnDB.getRefCount(memId+"_refrigerator", search);
    if(count>0){
    	 ingList = mnDB.getRefs(memId+"_refrigerator", search, startRow, endRow);
    }
    
    // list session 선언
    session.setAttribute("ingList", ingList);
 
 	// tempIngList 설정
    List tempIngList = null;
  	tempIngList = (List) session.getAttribute("tempIngList"); // set 하는곳이 어디야? 
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
							ing.setCheck("true");
							ing.setAmount(getAmount);
							ing.setUnit(getUnit);
							ing.setFreshness(getFreshness);
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
<form name="f2" action="updatePro.jsp" method="post">
<input type="hidden" id="search" name="search">
<input type="text" id="keyword" /><input type="submit" value="검색" onclick="javascript:goSearch()"><br/>
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
if(search!=null){
	if(ingList!=null){
if (count == 0) {%>
<table>
	<tr>
   		<td colspan="5">
   			냉장고에 저장된 재료가 없습니다.
   		</td>
   	</tr>
</table>
<%}else{	
	// 총 재료 수만큼 반복
	for (int i = 0 ; i < ingList.size() ; i++) {		
		MaNengDataBean ing = (MaNengDataBean)ingList.get(i);
%>
<table>
	<tr>
		<td>
		<input type="checkbox" id="ch<%=ing.getIng_id()%>" name="check<%=ing.getIng_id()%>" value="true" onclick="return check(<%=ing.getIng_id()%>);" >
		</td>
    	<td>
    	<%=ing.getIngname()%>
    	<input type="hidden" id="hiddenName<%=ing.getIng_id()%>" value="<%=ing.getIngname()%>" >
    	<input type="hidden" name="hiddenIDs[]" value="<%=ing.getIng_id()%>">
    	</td>
    	<td>
    	<button type="button" onclick="javascript:add(<%=ing.getIng_id()%>);" >+</button>
    	<input type="text" id="outputAmount<%=ing.getIng_id()%>" name="amount<%=ing.getIng_id()%>" size ="1" value="<%=ing.getAmount()%>">
    	<button type="button" onclick="javascript:subtract(<%=ing.getIng_id()%>);">-</button>
    	</td>
    	<td>
    	<input type="hidden" id="hiddenUnit<%=ing.getIng_id()%>" value="<%=ing.getUnit()%>">
    	<select id ="outputUnit<%=ing.getIng_id()%>" name="unit<%=ing.getIng_id()%>" >
		<option value="check">단위선택</option>
		<option value="g">g</option>
		<option value="ml">ml</option>
		<option value="cm^3">cm^3</option>
		<option value="개">개</option>
		<option value="마리">마리</option>
		</select>
		</td>
    	<td>
    	<input type="text" id = "outputFreshness<%=ing.getIng_id()%>" name="freshness<%=ing.getIng_id()%>" value="<%=ing.getFreshness()%>">
    	</td>
	</tr>
</table>
<%}}}else{%>
<table> 
<tr>
	<td colspan="5">
 		검색하신 [<%=search%>]를 찾지 못합니다.
	</td>
</tr>
</table>
<%}}else{%> 
<table> 
<tr>
	<td colspan="5">
		검색하신 [<%=search%>]를 찾지 못합니다.
	</td>
</tr>
</table>
<%}%>
<button type="button" onclick="javascript:insertCheck();">재료 추가</button>
<button type="button" onclick="javascript:updateCheck();">재료 수정</button>
<button type="button" onclick="javascript:removeCheck();">꺼내기</button>
<button type="button" onclick="javascript:recipeCheck();">레시피 추천</button></br>
<%
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
var ids = [];
var fields = document.getElementsByName("hiddenIDs[]");
var search = "<%=search%>";

if(search == null || search.trim().isEmpty()){
	document.getElementById("keyword").value = search; 
}


for(var i = 0; i < fields.length; i++){
	ids.push(fields[i].value);
}

if(<%=ingList.size()%>!=null){
	for (let i = 0 ; i < <%=ingList.size()%> ; i++) {
		for(let j = 0; j < document.getElementById("outputUnit"+ids[i]).length; j++){
			if(document.getElementById("outputUnit"+ids[i])[j].value == document.getElementById("hiddenUnit"+ids[i]).value){
				document.getElementById("outputUnit"+ids[i])[j].selected = true;
			}
		}
	}
}else{
	alert("재료 정보를 불러오지 못했습니다.");
	window.history.go(-1);
}

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
			document.getElementById("outputAmount"+id).value = document.getElementById("setAmount"+i).value;
			document.getElementById("outputFreshness"+id).value = document.getElementById("setFreshness"+i).value;
			for(let j = 0; j < document.getElementById("outputUnit"+id).length; j++){
				if(document.getElementById("outputUnit"+id)[j] == document.getElementById("setUnit"+i).value){
					document.getElementById("outputUnit"+id)[j].selected = true;
				}
			}
		}
	}
	document.getElementById("test").value = checkedVar;
}

function goSearch(){
	document.getElementById("search").value = document.getElementById("keyword").value;
}

function page(pageNum){
	document.f2.action = "updateSearch.jsp";
	document.getElementById("pageNum").value = pageNum;
	document.getElementById("search").value = document.getElementById("keyword").value;
	document.f2.submit();
}

function insertCheck() {
	if (confirm("재료를 추가하시겠습니까?")){
		window.open="insert.jsp";
	}else{
	return false;
	}
}

function updateCheck() {
	if (confirm("재료를 수정하시겠습니까?")){
		document.f2.action = "updatePro.jsp";
		document.f2.submit();
	}else{
	return false;
	}
}

function removeCheck() {
	if (confirm("제료를 꺼내시겠습니까?")){
		document.f2.action = "deletePro.jsp";
		document.f2.submit();
	}else{
	return false;
	}
}

function recipeCheck() {
	if (confirm("레시피를 추천 받으시겠습니까?")){
		document.f2.action = "mixRecipe.jsp";
		document.f2.submit();
	}else{
	return false;
	}
}

function add(ingId){
	var y = document.getElementById("outputAmount"+ingId).value;
	y++;
	document.getElementById("outputAmount"+ingId).value = y;
}

function subtract(ingId){
	var y = document.getElementById("outputAmount"+ingId).value;
	if(y>0){
		y--;
	}
	document.getElementById("outputAmount"+ingId).value = y;
}

function check(ingId){
	var chName = document.getElementById("hiddenName"+ingId).value;
	var chAmount = document.getElementById("outputAmount"+ingId);
	var chUnit = document.getElementById("outputUnit"+ingId);
	var chFreshness = document.getElementById("outputFreshness"+ingId);	

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
	if(chAmount.value != ""){
		if(chUnit.value != "check"){
			if(chFreshness.value != ""){
				var newArray = new Array();	
				newArray.push(ingId);
				newArray.push(chName.value);
				newArray.push(chAmount.value);
				newArray.push(chUnit.value);
				newArray.push(chFreshness.value);
				checkedVar[checkedVar.length] = newArray;
				document.getElementById("test").value = checkedVar;
				alert(chName + "이/가 체크 되었습니다");
				return true;
			}else{
				alert(chName + "의 유통기한을 기입해주세요");
				return false;
			}
		}else{
			alert(chName + "의 단위를 기입해주세요");
			return false;
		}
	}else{
		alert(chName + "의 수량을 기입해주세요");
		return false;
	}		

}
</script>