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
	
	//�Ĵ��߰�
	public void insertDiet(DietDTO dto, String id) {
		try {
				conn=ConnectionDAO.getConnection();
				pstmt = conn.prepareStatement ("insert into "+id+"_diet"+" values(?,?,?,?,?,?,?)");
				pstmt.setString(1,dto.getDiet_date());//date�������� �ٲ㼭 ����־�ߵǴ°�
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
	
	//��¥�ٲٱ��� x, �Ĵܳ��븸 ��������	
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
	
	//��¥�Է��ϸ� �Ĵܻ���
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
	
	//�Ĵ� �ۼ��� �� Ȯ�� . true�� �ۼ�����
	public boolean dateCheck(String diet_date, String id) {
		boolean result = true;//����
		try {
			conn=ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("select * from "+id+"_diet"+" where diet_date=?");
			pstmt.setString(1,diet_date);
			//pstmt.setTimestamp(1, diet_date);
			rs = pstmt.executeQuery();
			if(rs.next()) {	result = false;} //�ߺ�
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
	
	//��� ������ ����ϴ� �޼��� // ?????
	public ArrayList<DietDTO> getList(String id){
		ArrayList<DietDTO> list = new ArrayList<DietDTO>();
		try {
			conn=ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("select * from "+id+"_diet"+" order by diet_date desc");
			rs = pstmt.executeQuery();
			//�Ϸ����, �����ϴ���, �Ѵ޴���..
			while(rs.next()) {
				DietDTO dto = new DietDTO();
				
				//��¥ ��������
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
			if(rs.next()) {//(�ѷ��ڵ��) ù��° ���� ������ x�� ����
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
			pstmt.setInt(2, end);//������ ���ڵ� ����
			rs = pstmt.executeQuery();
			if(rs.next()) {//���� �����ϸ� ������
				dietList = new ArrayList(end);//���ڵ� �Ѱ��̻� �����ϱ� ������ �迭���
				//��� ��ü�� �������� ũ�⸦ �����ؼ� ��ü�� ���� ->endũ�⸸ŭ ��ü�����Ѵ�
				 do {
					DietDTO dto = new DietDTO();
					 //article�� �����Ѵ� 
					dto.setDiet_date(rs.getString("diet_date"));	
					dto.setBreakfast(rs.getString("breakfast"));	
					dto.setLunch(rs.getString("lunch"));	
					dto.setDinner(rs.getString("dinner"));	
					dto.setYear(rs.getString("diet_date"));
					dto.setMonth(rs.getString("diet_date"));
					dto.setDay(rs.getString("diet_date"));
					dietList.add(dto);
					 
				 }while(rs.next());//�������� ������ �ٽ� �ݺ��ϱ�
			}		
		}catch(Exception ex) {
			ex.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}return dietList;
	}
	
	
	//Ķ������ ����ֱ� ��ü �ϳ��� ������ Ķ����jsp���� �ݺ����� ���� �ݺ��ϱ�
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
			if(rs.next()) {//���� �����ϸ� ������
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
	
	
	  //�˻��� �Ĵ� ����Ʈ��� (x)
		public List<DietDTO> getSearchDiet(String diet_search, int start, int end, String id) {
			List<DietDTO> dietSearchList = null;
			try {
				conn = ConnectionDAO.getConnection();
				String sql ="select diet_date,breakfast,lunch,dinner,r "
							+"from (select diet_date,breakfast,lunch,dinner,rownum r "
							+"from(select diet_date,breakfast,lunch,dinner from "+id+"_diet "
							+"where breakfast like '%"+diet_search+"+%' or lunch like '%"+diet_search+"%' or dinner like '%"
							+diet_search+"%' order by diet_date desc) order by diet_date desc) where r >=? and r <=?";	

				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, start);
				pstmt.setInt(2, end);
				rs = pstmt.executeQuery();
				dietSearchList = new ArrayList<DietDTO>(end);
				//dietSearchList = new ArrayList<DietDTO>();

				while(rs.next()){
					DietDTO dto = new DietDTO();
					dto.setDiet_date(rs.getString("diet_date"));	
					dto.setBreakfast(rs.getString("breakfast"));	
					dto.setLunch(rs.getString("lunch"));	
					dto.setDinner(rs.getString("dinner"));	
					dto.setYear(rs.getString("diet_date"));
					dto.setMonth(rs.getString("diet_date"));
					dto.setDay(rs.getString("diet_date"));
					dietSearchList.add(dto); 
				 }
			}catch(Exception e) {e.printStackTrace();}
			finally {ConnectionDAO.close(rs, pstmt, conn);}
			return dietSearchList;
		}
	
		//�˻��� �Ĵ� ��� ���� 
		public int getSearchDietCount(String diet_search, String id) {
			int x=0;
			try {
				conn = ConnectionDAO.getConnection();
				String sql ="select count(*) from "+id+"_diet where breakfast like '%"+diet_search+"%' or lunch like '%"+diet_search+"%' or dinner like '%"+diet_search+"%'";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					x=rs.getInt(1);//���ǹ��� �˸´� ���� �� ����
				}
			}catch(Exception e) {e.printStackTrace();}
			finally {ConnectionDAO.close(rs, pstmt, conn);}
			return x;
		}
	
		
		//�׽�Ʈ
		public List<DietDTO> getSearch(String diet_search, String id) throws Exception{
			List<DietDTO> dietSearchList = null;
			try {
				conn = ConnectionDAO.getConnection();
				String sql =
						"select diet_date,breakfast,lunch,dinner from "+id+"_diet "
						+"where breakfast like '%"+diet_search+"+%' or lunch like '%"+diet_search+"%' or dinner like '%"
						+diet_search+"%' order by diet_date desc";	
				pstmt = conn.prepareStatement(sql);
					dietSearchList = new ArrayList<DietDTO>();
					//dietSearchList = new ArrayList<DietDTO>();
						do{
						DietDTO dto = new DietDTO();
						dto.setDiet_date(rs.getString("diet_date"));	
						dto.setBreakfast(rs.getString("breakfast"));	
						dto.setLunch(rs.getString("lunch"));	
						dto.setDinner(rs.getString("dinner"));	
						dto.setYear(rs.getString("diet_date"));
						dto.setMonth(rs.getString("diet_date"));
						dto.setDay(rs.getString("diet_date"));
						dietSearchList.add(dto); 
					 }while(rs.next());
			}catch(Exception e) {e.printStackTrace();}
			finally {ConnectionDAO.close(rs, pstmt, conn);}
			return dietSearchList;
		}
	
		
		//�׽�Ʈ ����¡���ϰ� �˻���� ��� ��������(��� ��µ�)
		 public ArrayList<DietDTO> getList(String diet_search, String id){
			   //ArrayList utill��Ű�� =>java.util.ArrayList����Ʈ
			   ArrayList<DietDTO> list = new ArrayList<DietDTO>();
			   
			   try {
					conn = ConnectionDAO.getConnection();
					String sql="select * from "+id+"_diet where breakfast like '%"+diet_search+"%' or lunch like '%"+diet_search+"%' or dinner like '%"+diet_search+"%'";
				   pstmt=conn.prepareStatement(sql);
				   rs = pstmt.executeQuery();
				   //rs�� sql���๮�� ������� ������.
				   //������� ���� ->�ݺ������
				   while(rs.next()) {
					   //�ݺ��Ҷ����� dto��ü����
						DietDTO dto = new DietDTO();
					  //��񿡼� ���� ��dto�� �־��ֱ�
						dto.setDiet_date(rs.getString("diet_date"));	
						dto.setBreakfast(rs.getString("breakfast"));	
						dto.setLunch(rs.getString("lunch"));	
						dto.setDinner(rs.getString("dinner"));	
						dto.setYear(rs.getString("diet_date"));
						dto.setMonth(rs.getString("diet_date"));
						dto.setDay(rs.getString("diet_date"));
						list.add(dto);//���� ������ dto��ü�� list�� �߰���Ų��
				   }  
			   }catch(Exception e) {e.printStackTrace();}
				finally {ConnectionDAO.close(rs, pstmt, conn);}
			   return list;
		   }
		 
		 //�˻���� ����¡ó��
		 public ArrayList<DietDTO> getSearchList(String diet_search,int start, int end, String id){
			   ArrayList<DietDTO> list = new ArrayList<DietDTO>();   
			   try {
					conn = ConnectionDAO.getConnection();
					String sql=	"select diet_date,breakfast,lunch,dinner, r "
							+"from (select diet_date,breakfast,lunch,dinner, rownum r "
							+"from (select diet_date,breakfast,lunch,dinner from "+id+"_diet "
							+"where breakfast like '%"+diet_search+"%' or lunch like '%"+diet_search+"%' or dinner like '%"+diet_search+"%' "
							+"order by diet_date desc) order by diet_date desc) where r>=? and r<=?";
					pstmt=conn.prepareStatement(sql);
					pstmt.setInt(1, start);
					pstmt.setInt(2, end);
				    rs = pstmt.executeQuery();//rs�� sql���๮�� ������� ������.
				   while(rs.next()) {
					   //�ݺ��Ҷ����� dto��ü����
						DietDTO dto = new DietDTO();
					  //��񿡼� ���� ��dto�� �־��ֱ�
						dto.setDiet_date(rs.getString("diet_date"));	
						dto.setBreakfast(rs.getString("breakfast"));	
						dto.setLunch(rs.getString("lunch"));	
						dto.setDinner(rs.getString("dinner"));	
						dto.setYear(rs.getString("diet_date"));
						dto.setMonth(rs.getString("diet_date"));
						dto.setDay(rs.getString("diet_date"));
						list.add(dto);//���� ������ dto��ü�� list�� �߰���Ų��
				   }  
			   }catch(Exception e) {e.printStackTrace();}
				finally {ConnectionDAO.close(rs, pstmt, conn);}
			   return list;
		   }
		 
		
}
