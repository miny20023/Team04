<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="recipe.bean.RecipeDTO" %>
<%@ page import="recipe.bean.RecipeDAO" %>
<%@ page import="cook.bean.CookDAO" %>
<%@ page import="cook.bean.CookDTO" %>
<%@ page import="recipe.bean.RecipeCommentDAO" %>
<%@ page import="java.util.List" %>
<%@ include file = "../menu.jsp" %>
 
	<% 
	request.setCharacterEncoding("UTF-8"); 
	
	List ingList = (List) session.getAttribute("ingList");
	int random_id = (int) session.getAttribute("random_id");
	System.out.println("recipeWritePro의 random_id = "+random_id);
	
	String path = request.getRealPath("recipeSave");
	String enc = "UTF-8";
	int size = 1024*1024*10;
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, path, size, enc, dp);

	try{
		String name = mr.getParameter("name"); // 요리명
		String process = mr.getParameter("process"); // 요리방법
		int difficulty = Integer.parseInt(mr.getParameter("difficulty"));
		String image = mr.getFilesystemName("image");
		int cooking_time = Integer.parseInt(mr.getParameter("cooking_time"));
		String ingredient = mr.getParameter("ingredient"); // 재료는 나중에 재료입력으로 다시 구현
		
		RecipeDAO dao = new RecipeDAO();
		CookDAO daoc = new CookDAO();
		RecipeCommentDAO daorc = new RecipeCommentDAO();
		RecipeDTO recipe = new RecipeDTO();
		recipe.setName(name);
		recipe.setProcess(process);
		recipe.setWriter(id);
		recipe.setDifficulty(difficulty);
		recipe.setImage(image);
		recipe.setCooking_time(cooking_time);

		int rec_id = dao.insertRecipe(recipe);

		
		daoc.changeRec_id(random_id, rec_id); 		// 임시 rec_id 난수값을 실제 rec_id로 변경	
		daorc.createCommentTable(rec_id);			// 레시피 등록된 번호로 댓글 게시판 생성

		session.removeAttribute("random_id");		// 레시피 작성 관련 세션 삭제
		session.removeAttribute("ingList");
		session.removeAttribute("ingList2");%>

		<script>
			alert("레시피가 등록되었습니다.");
			window.location="recipeListForm.jsp";
		</script>
<%	} catch(Exception e){%>
		<script>
			alert("내용을 입력해주세요");
			history.go(-1)
		</script>
<%}

	%>
	