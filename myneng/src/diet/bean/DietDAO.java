package diet.bean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import diet.bean.ConnectionDAO;
import diet.bean.DietDTO;


public class DietDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	public void insertDiet(DietDTO dto, String id) {
		try {
			
				conn=ConnectionDAO.getConnection();
				pstmt = conn.prepareStatement ("insert into "+id+"_diet"+" values(?,?,?,?,?,?,?)");
				pstmt.setString(1,dto.getDiet_date());//date형식으로 바꿔서 집어넣어야되는가
				pstmt.setString(2, dto.getBreakfast());
				pstmt.setString(3,dto.getLunch());
				pstmt.setString(4,dto.getDinner());
				
				pstmt.setInt(5,dto.getYear());
				pstmt.setInt(6,dto.getMonth());
				pstmt.setInt(7,dto.getDay());
				
				pstmt.executeUpdate();//insert								
		}catch(Exception e) {e.printStackTrace();}
		finally {ConnectionDAO.close(rs, pstmt, conn);}	
	}
	
	//날짜바꾸기기능 x	
	public void updateDiet(DietDTO dto, String id) {
		try {
			conn=ConnectionDAO.getConnection();
			String sql = "update "+id+"_diet"+" set breakfast=?, lunch=?, dinner=? where diet_date=?";
			pstmt= conn.prepareStatement(sql);
			pstmt.setString(1, dto.getBreakfast());
			pstmt.setString(2,dto.getLunch());
			pstmt.setString(3,dto.getDinner());
			pstmt.setString(4, dto.getDiet_date());
			pstmt.executeUpdate();	
		}catch(Exception e) {e.printStackTrace();}
		finally {ConnectionDAO.close(rs, pstmt, conn);}	
	}
	
	public void deleteDiet(String diet_date,String id) {
		try {
			conn=ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("delete from "+id+"_diet"+" where diet_date=?");
			pstmt.setString(1,diet_date);
			//pstmt.setTimestamp(1, diet_date);
			pstmt.executeUpdate();
			
		}catch(Exception e) {e.printStackTrace();}
		finally {ConnectionDAO.close(rs, pstmt, conn);}	
	}
	
	//식단 작성된 날 확인 . true시 작성가능
	public boolean dateCheck(String diet_date, String id) {
		boolean result = true;//가능
		try {
			conn=ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("select * from "+id+"_diet"+" where diet_date=?");
			pstmt.setString(1,diet_date);
			//pstmt.setTimestamp(1, diet_date);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = false;//중복
			}
		}catch(Exception e) {e.printStackTrace();}
		finally {ConnectionDAO.close(rs, pstmt, conn);}	
		return result;
	}
	
	public DietDTO getDiet(String diet_date, String id) {
		DietDTO dto = new DietDTO();
		try {
			conn=ConnectionDAO.getConnection();
			String sql = "select * from "+id+"_diet"+" where diet_date=?";
			pstmt = conn.prepareStatement(sql);
			//pstmt.setTimestamp(1, diet_date);
			pstmt.setString(1, diet_date);
			rs = pstmt.executeQuery();	
			if(rs.next()) {
				/*날짜 꺼내오기
				Timestamp d = rs.getTimestamp("diet_date");
				String month="";
				if(d.getMonth()<9) {	month="0"+(d.getMonth()+1);}
				else { month = d.getMonth()+1+""; }
				String date ="";
				if(d.getDate()<10) { date= "0"+d.getDate();}
				else { date = d.getDate()+"";}
				String day = (d.getYear()+1900)+"-"+month+"-"+date;
				dto.setDiet_date(day);
				*/
				dto.setDiet_date(rs.getString("diet_date"));
				dto.setBreakfast(rs.getString("breakfast"));
				dto.setLunch(rs.getString("lunch"));
				dto.setDinner(rs.getString("dinner"));
				dto.setYear(rs.getString("diet_date"));
				dto.setMonth(rs.getString("diet_date"));
				dto.setDay(rs.getString("diet_date"));

			}
		}catch(Exception e) {e.printStackTrace();}
		finally {ConnectionDAO.close(rs, pstmt, conn);}	
		return dto;
	}
	
	//써둔 모든글을 출력하는 메서드
	public ArrayList<DietDTO> getList(String id){
		ArrayList<DietDTO> list = new ArrayList<DietDTO>();
		try {
			conn=ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("select * from "+id+"_diet"+" order by diet_date desc");
			rs = pstmt.executeQuery();
			//하루단위, 일주일단위, 한달단위..
			while(rs.next()) {
				DietDTO dto = new DietDTO();
				
				//날짜 꺼내오기
				dto.setDiet_date(rs.getString("diet_date"));
				dto.setBreakfast(rs.getString("breakfast"));
				dto.setLunch(rs.getString("lunch"));
				dto.setDinner(rs.getString("dinner"));
				dto.setYear(rs.getString("diet_date"));
				dto.setMonth(rs.getString("diet_date"));
				dto.setDay (rs.getString("diet_date"));
				list.add(dto);
			}			
		}catch(Exception e) {e.printStackTrace();}
		finally {ConnectionDAO.close(rs, pstmt, conn);}	
		return list;
	}
	
	
	public int getDietCount(String id) throws Exception {
		int x=0;
		try {
			conn = ConnectionDAO.getConnection();
			pstmt=conn.prepareStatement("select count (*)from "+id+"_diet");
			rs = pstmt.executeQuery();
			if(rs.next()) {//(총레코드수) 첫번째 값을 꺼내서 x에 저장
				x = rs.getInt(1);
			}
		}catch(Exception ex) {ex.printStackTrace();}
		finally {ConnectionDAO.close(rs, pstmt, conn);}
		return x;
	}
	
	//
	public List getDiet(int start, int end, String id) throws Exception{
		List dietList = null;
		try {
			conn = ConnectionDAO.getConnection();
			String sql ="select diet_date,breakfast,lunch,dinner,r "+
						"from(select diet_date,breakfast,lunch,dinner,rownum r "+
						"from(select diet_date,breakfast,lunch,dinner "+
						"from "+id+"_diet"+" order by diet_date desc) order by diet_date desc) where r >=? and r <=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);//추출할 레코드 개수
			rs = pstmt.executeQuery();
			if(rs.next()) {//값이 존재하면 꺼내기
				dietList = new ArrayList(end);//레코드 한개이상 존재하기 때문에 배열사용
				//몇개의 객체를 저장할지 크기를 지정해서 객체를 생성 ->end크기만큼 객체생성한다
				 do {
					DietDTO dto = new DietDTO();
					 //article에 저장한다 
					dto.setDiet_date(rs.getString("diet_date"));	
					dto.setBreakfast(rs.getString("breakfast"));	
					dto.setLunch(rs.getString("lunch"));	
					dto.setDinner(rs.getString("dinner"));	
					dto.setYear(rs.getString("diet_date"));
					dto.setMonth(rs.getString("diet_date"));
					dto.setDay(rs.getString("diet_date"));
					dietList.add(dto);
					 
				 }while(rs.next());//다음값이 있을때 다시 반복하기
			}		
		}catch(Exception ex) {
			ex.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}return dietList;
	}
	
	
	//캘린더에 집어넣기 객체 하나만 꺼내고 캘린더 반복문을 통해 반복하기
	public DietDTO getDietCalendar(int year, int month, int day, String id) throws Exception{
		DietDTO dto = new DietDTO();
		try {
			conn = ConnectionDAO.getConnection();
			String sql ="select * "+
						"from "+id+"_diet"+" where year=? and month=? and day=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, year);
			pstmt.setInt(2, month);
			pstmt.setInt(3, day);			
			rs = pstmt.executeQuery();	
			if(rs.next()) {//값이 존재하면 꺼내기
				dto.setDiet_date(rs.getString("diet_date"));	
				dto.setBreakfast(rs.getString("breakfast"));	
				dto.setLunch(rs.getString("lunch"));	
				dto.setDinner(rs.getString("dinner"));	
				dto.setYear(rs.getString("diet_date"));
				dto.setMonth(rs.getString("diet_date"));
				dto.setDay(rs.getString("diet_date"));					 
						
			}		
		}catch(Exception ex) {	ex.printStackTrace();}
		finally {ConnectionDAO.close(rs, pstmt, conn);}
		return dto;
	}
	
	
	public DietDTO getDiet(int year,int month, int day, String id) {
		DietDTO dto = new DietDTO();
		try {
			conn=ConnectionDAO.getConnection();
			String sql = "select * from "+id+"_diet"+" where year=? and month=? and day=?";
			pstmt = conn.prepareStatement(sql);
			//pstmt.setTimestamp(1, diet_date);
			pstmt.setInt(1, year);
			pstmt.setInt(2, month);
			pstmt.setInt(3, day);	
			rs = pstmt.executeQuery();	
			if(rs.next()) {
				dto.setDiet_date(rs.getString("diet_date"));
				dto.setBreakfast(rs.getString("breakfast"));
				dto.setLunch(rs.getString("lunch"));
				dto.setDinner(rs.getString("dinner"));
				dto.setYear(rs.getString("diet_date"));
				dto.setMonth(rs.getString("diet_date"));
				dto.setDay(rs.getString("diet_date"));
			}
		}catch(Exception e) {e.printStackTrace();}
		finally {ConnectionDAO.close(rs, pstmt, conn);}	
		return dto;
	}
	
	/*
	 * //검색한 식단 리스트출력 
		public List getSearchDiet(String diet_search, int start, int end,String id) {
			List dietSearchList = null;
			try {
				conn = ConnectionDAO.getConnection();
				String sql ="select * from "+id+"_diet "+;
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, diet_search);
				pstmt.setString(end, sql);
				
				
			}catch(Exception e) {e.printStackTrace();}
			finally {ConnectionDAO.close(rs, pstmt, conn);}
			return dietSearchList;
		}
	
	*/
	
}
