<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="cook.bean.CookDAO" %>
<%@ page import="cook.bean.CookDTO" %>
<%@ page import="java.util.List" %>

<% 
request.setCharacterEncoding("UTF-8");

String id = (String) session.getAttribute("memId");
int rec_id = Integer.parseInt(request.getParameter("rec_id"));
int	random_id = (int) session.getAttribute("random_id");
String c = "변경 사항이 없습니다!";

CookDAO daoc = new CookDAO();
 
List ingList = (List) session.getAttribute("ingList");
List ingList2 = (List) session.getAttribute("ingList2");

if(ingList != null){				// 기존 재료 삭제시 random_id+100000에 임시저장
	for (int i = 0 ; i < ingList.size() ; i++) {	
		CookDTO cook = (CookDTO)ingList.get(i);
		if(request.getParameter("check"+i)!=null){
			cook.setAmount(request.getParameter("amount"+i));
			cook.setUnit(request.getParameter("unit"+i));
			cook.setRec_id(rec_id);
			daoc.changeRec_id(random_id+1000000, rec_id, cook);	
		}
	}
}
if(ingList2 != null){			// 새로 추가한 재료 삭제
	for(int i = 0; i < ingList2.size(); i++){
		CookDTO cook2 = (CookDTO)ingList2.get(i);
		if(request.getParameter("check2"+i) != null){
			cook2.setAmount(request.getParameter("amount2"+i));
			cook2.setUnit(request.getParameter("unit2"+i));
			cook2.setRec_id(random_id);
			if(daoc.isUpdate(random_id, rec_id)){			// 기존재료 수정한뒤 삭제 확인
				daoc.changeRec_id(random_id+1000000, rec_id, cook2);	
			}
			daoc.deleteIng(cook2);
		}
	}
}
%>

<script>
alert("삭제되었습니다.");
window.location = "recipeIngredientUpdateForm.jsp?num=<%=rec_id %>&random_id=<%=random_id %>";
</script>