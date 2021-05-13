<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "test.model.food.MaNengDBBean" %>
<%@ page import = "test.model.food.MaNengDataBean" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.util.ArrayList" %>

<%
	// 인코딩
	request.setCharacterEncoding("UTF-8");

	// 경고 메시지
	String alert = "해당 재료로 조리할 레시피가 없습니다! 재료 선택을 더 해주세요!";	
	boolean sendCheck = false ;
	
	//memId 가져오기
	String memId = (String)session.getAttribute("memId");
	if (memId == null || memId.trim().isEmpty()) {%>
		<script>
			alert("아이디의 세션이 종료 되어서 aaa 계정으로 로그인합니다.");
		</script>
		<%memId = "aaa";
	}	
	
	// DAO 선언
	MaNengDBBean mnDB = new MaNengDBBean();
	
	// ingList 호출
	List ingList = (List) session.getAttribute("ingList");
		
	// tempIngList 호출
	List tempIngList = (List) session.getAttribute("tempIngList");

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
		if(ingList!=null){
			List<Integer> recList = mnDB.mixRecipe(tempIngList);		// 체크 된 재료로만 레시피 추천
			if(recList.isEmpty()){										// 레시피 여부 확인
			}else{
				session.setAttribute("recList", recList);
				alert = "레시피를 조회하였습니다!";
				sendCheck = true;
			}
		}else{
			alert = "입력이 잘못 되었습니다! 해당 담당자에게 문의해주세요!";
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(tempIngList!=null){
			session.removeAttribute("tempIngList");
			session.removeAttribute("ingList");
		}
	}
%>
<script type="text/javascript">
	alert("<%=alert%>");
	if(<%=sendCheck%>){
		window.location="mixList.jsp";
	}else{
		window.location="mixRecipe.jsp";
	}	
</script>