<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="cook.bean.CookDAO" %>
<%@ page import="cook.bean.CookDTO" %>
<%@ page import="java.util.List" %>

<% 
	request.setCharacterEncoding("UTF-8");

	String id = (String) session.getAttribute("memId");
	int rec_id = Integer.parseInt(request.getParameter("rec_id"));
	int random_id = (int) session.getAttribute("random_id");
	System.out.println("recipeIngredientUpdatePro의 random_id = "+random_id);
	
	CookDAO daoc = new CookDAO();
	 
	List ingList = (List) session.getAttribute("ingList");
	List ingList2 = (List) session.getAttribute("ingList2");
	
	boolean result = false;
	String ings_alert = "";
	
	if(ingList!=null){									// 기존 재료 수정시
		for (int i = 0 ; i < ingList.size() ; i++) {	
			CookDTO cook = (CookDTO)ingList.get(i);
			if(request.getParameter("check"+i)!=null){
				cook.setAmount(request.getParameter("amount"+i));
				cook.setUnit(request.getParameter("unit"+i));
				cook.setRec_id(random_id);
				result = daoc.updateIng(cook);
				ings_alert += cook.getIng_name()+"  수정되었습니다. \\n";
			}
		}
	}
	if(ingList2 != null){							// 새로 추가한 재료 수정시
		for(int i = 0; i < ingList2.size(); i++){
			CookDTO cook2 = (CookDTO)ingList2.get(i);
			if(request.getParameter("check2"+i) != null){
				cook2.setAmount(request.getParameter("amount2"+i));
				cook2.setUnit(request.getParameter("unit2"+i));
				cook2.setRec_id(random_id);
				result = daoc.updateIng(cook2);
				ings_alert += cook2.getIng_name()+"  수정되었습니다. \\n";
			}
		}
	}
%>

<script>
	var rec_id = '<%=rec_id%>';
	var random_id = '<%=random_id%>';
	var ings_alert = '<%=ings_alert%>';
	var result = '<%=result%>';
	if(result == "true"){
		alert(ings_alert);
	}else if (result == "false"){
		alert("수정내역이 없습니다.");
	}
	window.location = "recipeIngredientUpdateForm.jsp?num="+rec_id+"&random_id="+random_id;

</script>