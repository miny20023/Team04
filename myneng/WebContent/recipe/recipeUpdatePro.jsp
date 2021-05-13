<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="recipe.bean.RecipeDAO" %>
<%@ page import="recipe.bean.RecipeDTO" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.util.List" %>
<%@ page import="cook.bean.CookDAO" %>
<%@ include file = "../menu.jsp" %>
 
<% 
	request.setCharacterEncoding("UTF-8");

	String pageNum = request.getParameter("pageNum");
	int num = Integer.parseInt(request.getParameter("num"));
	int random_id = Integer.parseInt(request.getParameter("random_id"));
	if(session.getAttribute("random_id") != null){
		random_id = (int) session.getAttribute("random_id");
	}
	System.out.println("recipeUpdatePro의 random_id = "+random_id);
	
	String path = request.getRealPath("recipeSave");
	String enc = "UTF-8";
	int size = 1024*1024*10;
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, path, size, enc, dp);
	
	String name = mr.getParameter("name");
	String process = mr.getParameter("process");
	String writer = id;
	int difficulty = Integer.parseInt(mr.getParameter("difficulty"));
	String image = mr.getFilesystemName("image");
	int cooking_time = Integer.parseInt(mr.getParameter("cooking_time"));
	
	RecipeDTO recipe = new RecipeDTO();
	recipe.setNum(num);
	recipe.setName(name);
	recipe.setProcess(process);
	recipe.setWriter(writer);
	recipe.setDifficulty(difficulty);
	recipe.setImage(image);
	recipe.setCooking_time(cooking_time);
	
	RecipeDAO dao = new RecipeDAO();
	dao.updateRecipe(recipe);
	if(image != null){
		dao.updateImage(recipe);
	}
	
	if(random_id != 0){
		CookDAO daoc = new CookDAO();
		daoc.changeRec_id(random_id, num); 		// 임시 rec_id값 0을 실제 rec_id로 변경	
	}
	session.removeAttribute("random_id");
	
%>
<script>
	alert("수정되었습니다.");
	window.location="recipeContentForm.jsp?PageNum=<%=pageNum%>&num=<%=num %>&random_id=<%=random_id%>";
</script>