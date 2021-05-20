<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import = "test.model.food.MaNengDBBean" %>
<%@ page import = "test.model.food.MaNengDataBean" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.util.ArrayList" %>
<%@ page import = "java.net.URLEncoder" %>
<%@ include file = "../menu.jsp" %>
<link href="form.css" rel="stylesheet" type="text/css">
<body bgcolor="#f0efea">

<%
	// 인코딩
	request.setCharacterEncoding("UTF-8");
	
	//search 값 가져오기
	String search = request.getParameter("search");
	String se = "";

	// memId 호출
	String memId = (String)session.getAttribute("memId");
	if (memId == null || memId == "") {%>
		<script>
			alert("아이디의 세션이 종료 되어\n로그인 화면으로 돌아갑니다.");
			window.location="<%=request.getContextPath()%>/menu.jsp"
		</script>
		<%
	}
	
	// 임의 페이지 수 게시글 수 정의
	int pageSize = 10;
	
	// 페이지 유효성 검사
	String pageNum = request.getParameter("pageNum");
	if (pageNum == null || pageNum == "") {
        pageNum = "1";
    }
	
	int currentPage = Integer.parseInt(pageNum);		// 현재 페이지
    int startRow = (currentPage - 1) * pageSize + 1;	// 현재 페이지 시작 줄 수
    int endRow = currentPage * pageSize;				// 현재 페이지 마지막 줄 수
    int count = 0;										// 재료 수
    int number = 0;										// 재료 순번
    
 	// 재료 list 가져오기
    List<MaNengDataBean> ingList = null;
	MaNengDBBean mnDB = new MaNengDBBean();
	if(search == null || search.trim().isEmpty() || search.equals("null")){	%>
		<script>
			alert("검색어가 입력되지 않았습니다.");
		</script>
		<%
		count = mnDB.getRefCount(memId+"_refrigerator");	// 냉장고 재료 수
	    if(count>0){										
	  		ingList = mnDB.getRefs(memId+"_refrigerator", startRow, endRow);
	    }	
	}else{
		se = URLEncoder.encode(search, "UTF-8");
		count = mnDB.getRefCount(memId+"_refrigerator", search);	// 냉장고 재료 수
	    if(count>0){										
	  		ingList = mnDB.getRefs(memId+"_refrigerator", search ,startRow, endRow);
	    }
	}
    
	// list session 선언
    session.setAttribute("ingList", ingList);
    
    // tempIngList 설정
    List<MaNengDataBean> tempIngList = (List) session.getAttribute("tempIngList");
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
					tempIngList = mnDB.getIng(getName);
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
<input type = "hidden" id = "testNum" value = "<%=testNum%>">
<input type = "hidden" id = "setSearch" value = "<%=search%>">
<div class="center">
<form name="f2" action="mixRecipeSearch.jsp" method="post">
<input type="hidden" id="search" name="search">
<input type="text" id="keyword" /><input type="submit" value="검색" onclick="javascript:goSearch()"><br/>
<table> 
	<tr> 
		<td>재료명</td>
		<td>수량</td>
		<td>단위</td>
		<td>유통기한</td>
		<td>추가</td>        
    </tr>
</table>
<%
// 총 재료 수만큼 반복 
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
<%		}else{
			for (int i = 0 ; i < ingList.size() ; i++) {	
				MaNengDataBean ing = (MaNengDataBean)ingList.get(i);	// 받은 DB들 풀기
%>	
<table> 
	<tr>
    	<td class = "name">
    	<%=ing.getIngname()%>
    	<input type="hidden" id="hiddenName<%=ing.getIng_id()%>" value="<%=ing.getIngname()%>">
    	</td>   	
    	<td class = "amount">
    	<%=ing.getAmount()%>
    	<input type="hidden" id="hiddenAmount<%=ing.getIng_id()%>" value="<%=ing.getAmount()%>"></td>
    	<td class = "unit">
    	<%=ing.getUnit()%>
    	<input type="hidden" id="hiddenUnit<%=ing.getIng_id()%>" value="<%=ing.getUnit()%>">
    	</td>
    	<td class = "freshness">
    	<%=ing.getFreshness()%>
    	<input type="hidden" id = "hiddenFreshness<%=ing.getIng_id()%>" value="<%=ing.getFreshness()%>">
    	</td>
    	<td class = "check">
		<input type="checkbox" id="ch<%=ing.getIng_id()%>" value="true" onclick="return check(<%=ing.getIng_id()%>);"/>
		</td>
	</tr>
			<%}
		}
	}else{%>
		<script>
			alert("<%=memId%>님의 냉장고를 불러오기를 실패했습니다");
			window.history.go(-1);
		</script>

	<%}
}else{%>
	<table> 
		<tr>
		<td colspan="5">
				검색하신 [<%=search%>]를 찾지 못합니다.
		</td>
		</tr>
</table>	
<%}%>
</table>
<button type="button" onclick="javascript:mixCheck();">조합하기</button><br/>
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
	<a href="javascript:page(<%=i%>);">[<%=i%>]</a>
<%}
if (endPage < pageCount) {  %>
<a href="javascript:page(<%= startPage + 10 %>)">[다음]</a>
	<%}}%>
<input type="hidden" id="test" name="test">
<input type="hidden" id="pageNum" name="pageNum">
</form>
</div>
</body>
<script type="text/javascript">
var checkedVar = new Array();
var search = document.getElementById("search").value;
var testNum = document.getElementById("testNum").value;

if(search != null){
	document.getElementById("keyword").value = search;
	document.getElementById("search").value = search;
}

if(document.getElementById("search")!=null){
	document.getElementById("keyword").value = document.getElementById("search").value;
}

if(document.getElementById("setId0")!=null){
	for(let i = 0; i < testNum; i++) {
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
	var key = document.getElementById("keyword").value;
	
	document.getElementById("search").value = key;
	
	if(key == null || key == ""){
		alert("검색어가 입력되지 않았습니다!")
		document.f2.action = "mixRecipe.jsp";
		document.f2.submit();
	}
}

function page(pageNum){
	document.f2.action = "mixRecipe.jsp";
	document.getElementById("pageNum").value = pageNum;
	document.getElementById("search").value = document.getElementById("keyword").value;
	document.f2.submit();
}

function mixCheck() {
	if (confirm("선택하신 재료로 조합하시겠습니까?")){
		document.f2.action = "mixRecipe.jsp";
		document.f2.submit();
	}else{
	return false;
	}
}

function check(ingId){
	var chName = document.getElementById("hiddenName"+ingId);
	for(let i = 0; i < checkedVar.length; i++) {
		var newArray = checkedVar[i];
		var verId = newArray[0];
		
		if(verId == ingId) {
			checkedVar.splice(i, 1);
			i--;
			document.getElementById("test").value = checkedVar;
			alert(chName.value + "이/가 체크 해제 되었습니다");
			return true;
		}
	}
	var newArray = new Array();	
	newArray.push(ingId);
	newArray.push(chName.value);
	newArray.push(document.getElementById("hiddenAmount"+ingId).value);
	newArray.push(document.getElementById("hiddenUnit"+ingId).value);
	newArray.push(document.getElementById("hiddenFreshness"+ingId).value);
	checkedVar[checkedVar.length] = newArray;
	document.getElementById("test").value = checkedVar;
	alert(chName.value + "이/가 체크 되었습니다");
	return true;	
}
</script>
