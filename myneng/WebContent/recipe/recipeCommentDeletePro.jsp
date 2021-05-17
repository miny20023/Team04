<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="recipe.bean.RecipeCommentDAO" %>
<%@ page import="recipe.bean.RecipeDAO" %>
<%@ page import="member.bean.MemberDAO" %>
    
<% 	request.setCharacterEncoding("UTF-8"); 

	String id = (String) session.getAttribute("memId");
	int num = Integer.parseInt(request.getParameter("num"));
	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	int random_id = Integer.parseInt(request.getParameter("random_id"));
	int comment_num = Integer.parseInt(request.getParameter("comment_num"));
	String password = request.getParameter("password");
	
	RecipeDAO dao = new RecipeDAO();
	RecipeCommentDAO daorc = new RecipeCommentDAO();
	MemberDAO daom = new MemberDAO();
	String comment_id = daorc.getRecipeComment_id(num, comment_num);
	int master = dao.getMemberMaster(id);
	
	boolean result = false;
	if(comment_id.equals(id) || master ==2){
		boolean pwCheck = daom.loginCheck(id, password);
		if(pwCheck){
			result = daorc.deleteRecipeComment(num, comment_num);
		}
	}
	
	if(result){%>
		<script>
		alert("댓글이 삭제되었습니다.");
		var pageNum = <%=pageNum%>;
		var num = <%=num%>;
		self.close();
		opener.window.location="recipeContentForm.jsp?pageNum="+pageNum+"&num="+num+"&random_id=0&comment_listNum=0";
		</script>
<%	}else{ %>
		<script>
		alert("비밀번호를 확인해주세요.");
		history.go(-1);
		</script>
<%	}
%>
