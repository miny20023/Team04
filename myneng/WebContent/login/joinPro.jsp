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
	
		//비밀번호 유효성검사
		boolean pw1 =vc.charNum(pw);
		boolean pw2 =vc.charLength(pw,4);

		boolean pwResult = (pw1&&pw2);	
		//pw 4글자이상 & 숫자포함 
		
		//핸드폰번호 숫자만 입력체크
		boolean phone1 = vc.numCheck(dto.getPh1()+dto.getPh2()+dto.getPh3()); 
		boolean phone2 = vc.charLength(dto.getPh1(),3)&&vc.charLength(dto.getPh2(),3)&&vc.charLength(dto.getPh3(),3);
		
		boolean phResult = (phone1&phone2);
				
		//이메일 중복체크
		boolean emailResult = dao.emailCheck(dto.getEmail());
		

		if(pwResult&&phResult&&emailResult){

			//회원추가시 테이블 생성 
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
					alert("사용할 수 없는 아이디입니다.");
					history.go(-1);
					</script>	
				<%}if(pwResult==false){%>
					<script>
					alert("사용할 수 없는 비밀번호입니다.");
					history.go(-1);
					</script>	
				<%}if(phResult==false){%>
					<script>
					alert("사용할 수 없는 핸드폰번호입니다.");
					history.go(-1);
					</script>	
				<%}if(emailResult==false){%>
				<script>
				alert("이미 가입된 이메일입니다.");
				history.go(-1);
				</script>	
			<%}
	}
%>
	






