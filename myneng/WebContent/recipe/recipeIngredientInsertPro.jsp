<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.util.List" %>
<%@ page import="cook.bean.CookDTO" %>
<%@ page import="cook.bean.CookDAO" %>

<%
request.setCharacterEncoding("UTF-8");

String id = (String) session.getAttribute("memId");
int rec_id = Integer.parseInt(request.getParameter("rec_id"));
int random_id=(int) session.getAttribute("random_id");
String pageNum = request.getParameter("pageNum");
String url = request.getParameter("url");

System.out.println("recipeIngredientInsertPro의 random_id =" +random_id);

CookDAO daoc = new CookDAO();
 
List ingList = (List) session.getAttribute("ingList");
boolean result = false;

for (int i = 0 ; i < ingList.size() ; i++) {	
	CookDTO cook = (CookDTO)ingList.get(i); // 재료 하나당 DTO 하나 생성해서 넣는중
	if(request.getParameter("check"+i)!=null && !request.getParameter("amount"+i).equals("") && !request.getParameter("unit"+i).equals("check")){
		cook.setAmount(request.getParameter("amount"+i)); // 재료 하나의 양
		cook.setUnit(request.getParameter("unit"+i));	// 재료 하나의 단위
		cook.setRec_id(random_id); 						// 재료 하나의 임시 레시피번호 난수 적용
		//ingList.add(cook);
		result = daoc.insertIng(cook);		
	}
}

if(result){
%>
<script>
	alert("재료가 추가되었습니다.");
	window.location=url+"rec_id="+rec_id+"&random_id="+random_id+"&pageNum="+pageNum;
</script>
<%}%>
<script>
	var url = '<%=url%>';
	var rec_id = '<%=rec_id%>';
	var random_id = '<%=random_id%>';
	var pageNum = '<%=pageNum%>';
	window.location = url+"rec_id="+rec_id+"&random_id="+random_id+"&pageNum="+pageNum;
</script>
