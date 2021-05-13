<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "test.model.food.MaNengDBBean" %>
<%@ page import = "test.model.food.MaNengDataBean" %>
<%@ page import = "java.util.List" %>

<%
	// 인코딩
	request.setCharacterEncoding("UTF-8");
	
	// 경고 메시지
	String alert = "변경 사항이 없습니다!";

	// memId 가져오기
	String memId = (String)session.getAttribute("memId");
	if (memId == null || memId.trim().isEmpty()) {%>
	<script>
	alert("아이디의 세션이 종료 되어서 aaa 계정으로 로그인합니다.");
	</script>
		<%memId = "aaa";
    }
	
	// tempIngList 호출
	List tempIngList = (List) session.getAttribute("tempIngList");
	
	// DAO 선언
	MaNengDBBean mnDB = new MaNengDBBean(); 
	
	// test(전 페이지 값) 호출
	String test = request.getParameter("test");
	System.out.println(test);
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
  
	try{
		if(tempIngList!=null){										// list 유효성 검사
			for (int i = 0 ; i < tempIngList.size() ; i++) {	
				MaNengDataBean ing = (MaNengDataBean)tempIngList.get(i);	// 총 재료 순서 고정임을 이용
				if(mnDB.dateCompare(ing.getFreshness())<0){					// 분수 double값으로 변환 후 현재 시간과 비교
				%>
					<script type="text/javascript">
						var check = confirm("<%=ing.getIngname()%>의 유통기한이 지났습니다! 계속 진행하겠습니까?");
						if(!check){
							window.location="insert.jsp";			// 유통기한 여부 confirm창
						}
					</script>
				<%}
				if(mnDB.getIngCount(ing.getIngname())>0){%>
					<script type="text/javascript">
						alert("<%=ing.getIngname()%>가 이미 있습니다! 유통기한 최대치로 갱신되었습니다");
					</script>
				<%
				}
				mnDB.insertRef(ing, memId+ "_refrigerator");
				alert = "냉장고가 수정 되었습니다!";
			}
		}else{
			alert = "입력이 잘못 되었습니다! 해당 담당자에게 문의해주세요!";		// session이 남거나 기타 오류 생길 경우
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(session!=null){										
			session.removeAttribute("tempIngList");								// session 종료
		}
	}
%>
<script>
	alert("<%=alert%>");
	window.location="insert.jsp";
</script>