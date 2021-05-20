<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import = "test.model.food.MaNengDBBean" %>
<%@ page import = "test.model.food.MaNengDataBean" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.util.ArrayList" %>
<%@ include file = "../menu.jsp" %>
<link href="form.css" rel="stylesheet" type="text/css">
<body bgcolor="#f0efea">

<%
	// 인코딩
	request.setCharacterEncoding("UTF-8");

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
	if (pageNum == null || pageNum.trim().isEmpty() || pageNum.equals("null")) {
        pageNum = "1";
    }
	
	int currentPage = Integer.parseInt(pageNum);		// 현재 페이지
    int startRow = (currentPage - 1) * pageSize + 1;	// 현재 페이지 시작 줄 수
    int endRow = currentPage * pageSize;				// 현재 페이지 마지막 줄 수
    int count = 0;										// 재료 수
    int number = 0;										// 재료 순번
    
 	// inglist 호출
    List<MaNengDataBean> ingList = null;			
 	int listSize = 0;
	MaNengDBBean mnDB = new MaNengDBBean();
	count = mnDB.getIngCount();							// 재료 수
    if(count>0){
    	ingList = mnDB.getIngs(startRow, endRow);		// starRow에서 endRow까지 재료 호출
    	listSize = ingList.size();
    }
	
 	// list session 선언
    session.setAttribute("ingList", ingList);
    
    // tempIngList 설정
    List<MaNengDataBean> tempIngList = (List)session.getAttribute("tempIngList");
  	session.setAttribute("tempIngList", tempIngList);
    
  	// test(전 페이지 값) 호출
    String test = request.getParameter("test");
	int testNum = 0;
    if(test!=null){
    	String [] testArray = test.split(",");									// String 배열 split
		String getId="",getName="",getAmount="",getUnit="",getFreshness="";		// 순서대로 String 선언
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
						if(ing.getIngname().equals(getName)){						// 존재하는 값 수정		
							ing.setCheck("true");
							ing.setAmount(getAmount);
							ing.setUnit(getUnit);
							ing.setFreshness(getFreshness);
							tilCheck = false;
						}
					}
					if(tilCheck){														// 존재하지 않을 경우 추가
						ing = new MaNengDataBean();
						ing.setIngname(getName);
						ing.setIng_id(Integer.parseInt(getId));
						ing.setCheck("true");
						ing.setAmount(getAmount);
						ing.setUnit(getUnit);
						ing.setFreshness(getFreshness);
						tempIngList.add(ing);
					}
				}else{																// 리스트가 없을 경우 선언
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
<div class="center">
<form name="f2" action="insertSearch.jsp" method="post">
<input type="hidden" id="search" name="search">
<input type="text" id="keyword" /><input type="submit" value="검색" onclick="javascript:goSearch()"><br/>
<table> 
	<tr> 
		<td class = "name">재료명</td> 
	    <td class = "amount">수량</td>
	    <td class = "unit">단위</td>
	    <td class = "freshness">유통기한</td>
	    <td class = "check">추가</td>        
    </tr>
</table>    
<%	
	// 총 재료 수만큼 반복
	for (int i = 0 ; i < ingList.size() ; i++) {		
		MaNengDataBean ing = (MaNengDataBean)ingList.get(i);
%>
<table>
	<tr>
    	<td class="name">
    	<%=ing.getIngname()%>
    	<input type="hidden" id="hiddenName<%=ing.getIng_id()%>" value="<%=ing.getIngname()%>" >
    	</td>
    	<td class="amount">
    	<button id = "plus<%=ing.getIng_id()%>" type="button" onclick="javascript:add(<%=ing.getIng_id()%>);" >+</button>
    	<input type="text" id="outputAmount<%=ing.getIng_id()%>" name="amount<%=ing.getIng_id()%>" size ="1" placeholder=0>
    	<button id = "minus<%=ing.getIng_id()%>" type="button" onclick="javascript:subtract(<%=ing.getIng_id()%>);">-</button>
    	</td>
    	<td class="unit">
    	<select id ="outputUnit<%=ing.getIng_id()%>" name="unit<%=ing.getIng_id()%>">
		<option>단위선택</option>
		<option value="g">g</option>
		<option value="ml">ml</option>
		<option value="cm^3">cm^3</option>
		<option value="개">개</option>
		<option value="마리">마리</option>
		</select>
		</td>
    	<td class="freshness">
    	<input type="text" id = "outputFreshness<%=ing.getIng_id()%>" name="freshness<%=ing.getIng_id()%>" placeholder ="yy-mm-dd">
    	</td>
    	<td class="check">
		<input type="checkbox" id="ch<%=ing.getIng_id()%>" name="check<%=ing.getIng_id()%>" value="true" onclick="return check(<%=ing.getIng_id()%>);" >
		</td>
	</tr>
</table>
<%}%>
<div class="button">
<button type="button" onclick="javascript:insertCheck();">재료 추가</button>
<br/>
</div>
<%
if (count > 0) {
	int pageCount = count / pageSize + ( count % pageSize == 0 ? 0 : 1);
	int startPage = (int)(currentPage/10)*10+1;
	int pageBlock = 10;
	int endPage = startPage + pageBlock-1;
	if (endPage > pageCount) {
		endPage = pageCount;
	}      
	if (startPage > 10) {%>
		<a href="javascript:page(<%= startPage - 10 %>);">[이전]</a>
 	<%}
	for (int i = startPage ; i <= endPage ; i++) {  %>
		<a href="javascript:page(<%=i%>);">[<%=i%>]</a>
 	<%}
	if (endPage < pageCount) {  %>
		<a href="javascript:page(<%= startPage + 10 %>)">[다음]</a>
	<%}
}%>
<input type="hidden" id="test" name="test">
<input type="hidden" id="pageNum" name="pageNum">
</form>
</div>
</body>
<script type="text/javascript">
var checkedVar = new Array();
var testNum = document.getElementById("testNum").value

if(document.getElementById("setId0")!=null){
	for(let i = 0; i < testNum; i++) {
		var array = new Array();
		var id = document.getElementById("setId"+i).value;
		var chName = document.getElementById("hiddenName"+id);
		var chAmount = document.getElementById("outputAmount"+id);
		var chUnit = document.getElementById("outputUnit"+id);
		var chFreshness = document.getElementById("outputFreshness"+id);	
		var plus = document.getElementById("plus"+id);	
		var minus = document.getElementById("minus"+id);	
		var chCheck = document.getElementById("ch"+id)
		
		array.push(id);
		array.push(document.getElementById("setName"+i).value);
		array.push(document.getElementById("setAmount"+i).value);
		array.push(document.getElementById("setUnit"+i).value);
		array.push(document.getElementById("setFreshness"+i).value);
		checkedVar.push(array);
		
		if(chCheck){
			chCheck.checked = true;
			chAmount.value = document.getElementById("setAmount"+i).value;
			chFreshness.value = document.getElementById("setFreshness"+i).value;
			for(let j = 0; j < chUnit.length; j++){
				if(chUnit[j].value == document.getElementById("setUnit"+i).value){
					chUnit[j].selected = true;
				}
			}
			chAmount.disabled = true;
			chUnit.disabled = true;
			chFreshness.disabled = true;
			plus.disabled = true;
			minus.disabled = true;
		}
	}
	document.getElementById("test").value = checkedVar;
}

function goSearch(){
	document.getElementById("search").value = document.getElementById("keyword").value;
}

function page(pageNum){
	document.f2.action = "insert.jsp";
	document.getElementById("pageNum").value = pageNum;
	document.f2.submit();
}

function insertCheck() {
	if (confirm("냉장고에 넣겠습니까?")){
		document.f2.action = "insertPro.jsp";
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
	var chName = document.getElementById("hiddenName"+ingId);
	var chAmount = document.getElementById("outputAmount"+ingId);
	var chUnit = document.getElementById("outputUnit"+ingId);
	var chFreshness = document.getElementById("outputFreshness"+ingId);	
	var plus = document.getElementById("plus"+ingId);	
	var minus = document.getElementById("minus"+ingId);	
	var chCheck = document.getElementById("ch"+ingId)
	
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
				

				if(chCheck.checked){
					chAmount.disabled = true;
					chUnit.disabled = true;
					chFreshness.disabled = true;
					plus.disabled = true;
					minus.disabled = true;
				}else{
					chAmount.disabled = false;
					chUnit.disabled = false;
					chFreshness.disabled = false;
					plus.disabled = false;
					minus.disabled = false;
				}
				
				alert(chName.value + "이/가 체크 되었습니다");				
				return true;
			}else{
				alert(chName.value + "의 유통기한을 기입해주세요");
				return false;
			}
		}else{
			alert(chName.value + "의 단위를 기입해주세요");
			return false;
		}
	}else{
		alert(chName.value + "의 수량을 기입해주세요");
		return false;
	}		
}
</script>