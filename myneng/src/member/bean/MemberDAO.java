package member.bean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import member.bean.ConnectionDAO;
import member.bean.MemberDTO;

public class MemberDAO {

	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs =null;
	
	//가입시 아이디 중복확인
	public boolean idCheck(String id) {
		boolean result = true;//id 사용가능
		
		try {
			conn=ConnectionDAO.getConnection();
			pstmt=conn.prepareStatement("select* from member where id=?"); 
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = false; //id 사용 불가능
			}
					
		}catch(Exception e){e.printStackTrace();}
		finally {ConnectionDAO.close(rs, pstmt, conn);}	
		return result;
	}
	
	
	//로그인 체크
	public boolean loginCheck(String id, String pw) {
		boolean result = false;
		try{
		conn = ConnectionDAO.getConnection();
		String sql = "select * from member where id=? and password=?";
		pstmt= conn.prepareStatement(sql);
		pstmt.setString(1, id);
		pstmt.setString(2, pw);
		rs=pstmt.executeQuery();
		if(rs.next()) {
			result = true; //로그인 정보가 일치함
		}
		}catch(Exception e) {e.printStackTrace();}
		finally {ConnectionDAO.close(rs, pstmt, conn);}
		
	
		return result;
	}

	//회원추가하기
	public void memberInsert(MemberDTO dto) { 
		try {
			conn = ConnectionDAO.getConnection(); // 그룹비밀번호 회원가입 랜덤으로 그룹비밀번호 지정하기
			
			String sql = "insert into member values(?,?,?,0,?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			//1아이디, 2이름,3비밀번호, 40,5이메일,6전화번호,7주소 8group_id 9.scrap_id 10cart_id 11 그룹 비밀번호
			//'aaa_refrigerator','aaa_scrap','aaa_cart'		
			
			
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getName());
			pstmt.setString(3, dto.getPw());
			pstmt.setString(4, dto.getEmail() );
			pstmt.setString(5,dto.getPhone());
			pstmt.setString(6,dto.getAddress());
			pstmt.setString(7,dto.getGroup_id());
			pstmt.setString(8,dto.getScrap_id());
			pstmt.setString(9,dto.getCart_id());
			pstmt.setString(10,dto.getGroup_pw());	

			//pstmt.setString(7,dto.getId()+"_refrigerator");
			//pstmt.setString(8,dto.getId()+"_scrap");
			//pstmt.setString(9,dto.getId()+"_cart");	

			pstmt.executeUpdate();//insert			
		}catch(Exception e) {e.printStackTrace();}
		finally {ConnectionDAO.close(rs,pstmt,conn);}
	}
	
	/*냉장고 추가하기
	CREATE TABLE aaa_refrigerator (
		    name       VARCHAR2(100),
		    ing_id     NUMBER,
		    amount     VARCHAR2(10),
		    unit       VARCHAR2(10),
		    freshness  VARCHAR2(100),
		    FOREIGN KEY ( ing_id )
		        REFERENCES ingredient ( id )
 create table [table 이름] (colum1 이름 colum1 type 제약조건, ...... )
 
 
 + "("+ "no int primary key auto_increment,"

							+ "name varchar(10)"

							+ ")";



출처: https://sourcestudy.tistory.com/325 [study]
 
 
*/
	//    public void createTable() throws SQLException {

	public void createRefrigerator(String id) { 
		try {
			conn = ConnectionDAO.getConnection();
			String sql = 
			//테이블이름은 ++로 연결한다 ?는 값만 사용가능
			"create table "+id+"_refrigerator("
			+ "name VARCHAR2(100),"
			+ "ing_id NUMBER,"
			+"amount VARCHAR2(10),"
			+"unit VARCHAR2(10),"
			+"freshness VARCHAR2(100),"
			+"FOREIGN KEY ( ing_id )"
			+" REFERENCES ingredient ( id ))";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.executeUpdate();		
		}catch(Exception e) {e.printStackTrace();}
		finally {ConnectionDAO.close(rs,pstmt,conn);}
	}
	

	
	/*
	
	 
	 *내가 찜한레시피 테이블 추가하기
	 *CREATE TABLE aaa_scrap (
    id      NUMBER PRIMARY KEY,
    rec_id  NUMBER,
    FOREIGN KEY (rec_id)
        REFERENCES recipe ( num )
);
*/
	public void createScrap(String id) {
		try {
			conn=ConnectionDAO.getConnection();
			String sql="create table "+id+"_scrap("
					+"id      NUMBER PRIMARY KEY,"
				    +"rec_id  NUMBER,"
				    +"FOREIGN KEY (rec_id) "
				    +"REFERENCES recipe ( num ))";					;
			pstmt = conn.prepareStatement(sql);
			pstmt.executeQuery();
			
		}catch(Exception e) {e.printStackTrace();}
		finally {ConnectionDAO.close(rs, pstmt, conn);	}
	}

	
/*	
	장보기 메모테이블 추가하기
	CREATE TABLE aaa_cart (
    id      NUMBER PRIMARY KEY,
    ing_id  NUMBER,
    FOREIGN KEY ( ing_id )
        REFERENCES ingredient ( id )
);	 */
	public void createCart(String id) {
		try {
			conn=ConnectionDAO.getConnection();
			String sql= "create table "+id+"_cart("
						+"id      NUMBER PRIMARY KEY,"
						+ "ing_id  NUMBER,"
						+ "FOREIGN KEY ( ing_id ) "
						+ "REFERENCES ingredient ( id ))";
			pstmt = conn.prepareStatement(sql);
			pstmt.executeQuery();			
		}catch(Exception e) {e.printStackTrace();}
		finally {ConnectionDAO.close(rs, pstmt, conn);}
	}
	
	public void createDiet(String id) {
		try {
			conn=ConnectionDAO.getConnection();
			String sql= "create table "+id+"_diet("
						+"diet_date date,"
						+ "breakfast  VARCHAR2(500),"
						+ "lunch VARCHAR2(500),"
						+ "dinner VARCHAR2(500))";
			pstmt = conn.prepareStatement(sql);
			pstmt.executeQuery();			
		}catch(Exception e) {e.printStackTrace();}
		finally {ConnectionDAO.close(rs, pstmt, conn);}
	}
	
	public MemberDTO getMember(String id) {
		MemberDTO dto = null;
		try {
			conn=ConnectionDAO.getConnection();
			String sql = "select * from member where id=?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs=pstmt.executeQuery();
			if(rs.next()){
				dto = new MemberDTO();
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				dto.setPw(rs.getString("password"));
				dto.setEmail(rs.getString("email"));
				dto.setPhone(rs.getString("phone"));
				dto.setAddress(rs.getString("address"));
				dto.setGroup_pw(rs.getString("group_pw"));
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs,pstmt,conn);
		}
		return dto;
	}
	
	public void statusChange(String id) {
		  try {
		       conn = ConnectionDAO.getConnection(); //1, 2占쌤곤옙 占쌨쇽옙占쏙옙 호占쏙옙
		       pstmt = conn.prepareStatement("update member set master=3, group_id=? where id=?");
		       pstmt.setString(1, id+"_refrigerator");
		       pstmt.setString(2, id);
		       
		       pstmt.executeUpdate();
		       
		   }catch(Exception e) {
		        e.printStackTrace();
		   }finally {
		        ConnectionDAO.close(rs,pstmt,conn);
		   }
	  }
	
	public void updateMember(MemberDTO dto) {
		try {
			
			conn=ConnectionDAO.getConnection();
			String sql = "update member set name=?, password=?, email=?, phone=?, address=?, group_pw=? where id=?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getPw());
			//int age = Integer.parseInt(dto.getAge());
			pstmt.setString(3, dto.getEmail());
			pstmt.setString(4, dto.getPhone());
			pstmt.setString(5, dto.getAddress());
			pstmt.setString(6, dto.getGroup_pw());
			pstmt.setString(7, dto.getId());	        
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs,pstmt,conn);
		}
	}
	
	//그룹장의 이름검색
		public MemberDTO getRefrigerator(String g_id) {
			MemberDTO dto = null;
			try{
				conn = ConnectionDAO.getConnection();
				String sql = "select * from member where id=?";
				pstmt= conn.prepareStatement(sql);
				pstmt.setString(1, g_id);
				rs=pstmt.executeQuery();
				if(rs.next()) {
					dto = new MemberDTO();
					dto.setName(rs.getString("name"));
					dto.setId(rs.getString("id"));
					dto.setGroup_id(rs.getString("group_id"));
					dto.setGroup_pw(rs.getString("group_pw"));
				}
				}catch(Exception e) {e.printStackTrace();}
				finally {ConnectionDAO.close(rs, pstmt, conn);}
			return dto;
		}
		
		public boolean certifyPw(String g_id, String g_pw) {
			boolean result = false;
			try{
				conn = ConnectionDAO.getConnection();
				String sql = "select group_pw from member where id=?";
				pstmt= conn.prepareStatement(sql);
				pstmt.setString(1, g_id);
				rs=pstmt.executeQuery();
				if(rs.next()) {
					if(rs.getString("group_pw").equals(g_pw)) {
						result = true;
					}
				}
				}catch(Exception e) {e.printStackTrace();}
				finally {ConnectionDAO.close(rs, pstmt, conn);}
			return result;
		}
	
	public void changeRefri(String id, MemberDTO dto) {
		try{
			conn = ConnectionDAO.getConnection();
			String sql = "update member set group_id=? where id=?";
			pstmt= conn.prepareStatement(sql);
			pstmt.setString(1, dto.getGroup_id());
			pstmt.setString(2, id);
			pstmt.executeUpdate();
			sql = "update member set group_pw=? where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getGroup_pw());
			pstmt.setString(2, id);
			pstmt.executeUpdate();
			}catch(Exception e) {e.printStackTrace();}
			finally {ConnectionDAO.close(rs, pstmt, conn);}
	}
	
	public void quitGroup(String id) {
		try{
			conn = ConnectionDAO.getConnection();
			String sql = "update member set group_id=? where id=?";
			pstmt= conn.prepareStatement(sql);
			String g_id = id + "_refrigerator";
			pstmt.setString(1, g_id);
			pstmt.setString(2, id);
			pstmt.executeUpdate();
			
			sql = "update member set group_pw=? where id=?";
			String text = "";
			String alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@&%?~";
			text += (int) (Math.random() * 999) + 1 + "";
			text += alpha.charAt((int) (Math.random() * alpha.length()));
			text += (int) (Math.random() * 99) + 1 + "";
			text += alpha.charAt((int) (Math.random() * alpha.length()));
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, text);
			pstmt.setString(2, id);
			pstmt.executeUpdate();
			}catch(Exception e) {e.printStackTrace();}
			finally {ConnectionDAO.close(rs, pstmt, conn);}
	}
	
	
}

