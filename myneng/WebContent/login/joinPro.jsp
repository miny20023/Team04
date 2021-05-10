<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="member.bean.MemberDAO"%>
<%@ page import ="member.bean.ValueCheck"%>

<%--member insert pro 페이지 --%>
<%	request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean class="member.bean.MemberDTO" id="dto" />
<jsp:setProperty name="dto" property="*" />

<%

	
	
	

	MemberDAO dao = new MemberDAO();
	ValueCheck vc = new ValueCheck();

	dto.setCart_id(dto.getId());
	dto.setGroup_id(dto.getId());
	dto.setScrap_id(dto.getId());
	
	
	
	//id 3글자 이상, DB중복X 
		boolean idResult = vc.charLength(dto.getId(),3)&&dao.idCheck(dto.getId());
		 
		String pw = dto.getPw();
		String pwr = dto.getPwr();
		boolean pw1 =vc.charNum(pw);
		//boolean pw2 =(pw==pwr);
		boolean pw3 =vc.charLength(pw,4);

		boolean pwResult = (pw1&&pw3);	
		//pw 8글자이상 & 숫자포함 //pw와 pwr 비밀번호 일치
		//핸드폰번호 숫자만 입력
		boolean phResult = vc.numCheck(dto.getPh1()+dto.getPh2()+dto.getPh3()); 
		
		
		if(pwResult&&phResult){
			
			dao.memberInsert(dto);
			dao.createRefrigerator(dto.getId());
			dao.createScrap(dto.getId());
			dao.createCart(dto.getId());
			dao.createDiet(dto.getId());

			%>
			<script>
				alert("회원가입되었습니다.");
				window.location = "login.jsp";
			</script>
		<% 
		}else{
				if(idResult==false){%>
					<script>
					alert("아이디오류");
					history.go(-1);
					</script>	
				<%} 
				if(pwResult==false){%>
					<script>
					alert("비밀번호오류");
					history.go(-1);
					</script>	
			<%} if(phResult==false){%>
					<script>
					alert("핸드폰번호오류");
					history.go(-1);
					</script>	
			<%}
		}


%>




