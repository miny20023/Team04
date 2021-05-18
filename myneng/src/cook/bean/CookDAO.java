package cook.bean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CookDAO {
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	// ��� �ҷ����� - cook ���̺� �̿�
	public List <CookDTO> getIng(int num) {
		List ingList = new ArrayList <CookDTO> ();
		try {
			conn = ConnectionDAO.getConnection();
			String sql = "select i.name, c.amount, c.unit from ingredient i, cook c where c.ing_id=i.id and c.rec_id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				CookDTO cook = new CookDTO();
				cook.setIng_name(rs.getString("name"));
				cook.setAmount(rs.getString("amount"));
				cook.setUnit(rs.getString("unit"));
				ingList.add(cook);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return ingList;
	}
	
	// ����̸��� �޾Ƽ� ���_id ��ȯ
	public int getIng_id(String ing_name) {
		int ing_id = 0;
		try {
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("select id from ingredient where name=?");
			pstmt.setString(1, ing_name);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				ing_id = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return ing_id;
	}
	
	// ��� Cook���̺� insert(�ӽ� rec_id ����) 
	public boolean insertIng(CookDTO cook) {
		boolean result = false;
		try {
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("select * from cook where rec_id=? and ing_id=?");
			pstmt.setInt(1, cook.getRec_id());
			pstmt.setInt(2, cook.getIng_id());
			rs = pstmt.executeQuery();
			if(rs.next()) {				// ��ᰡ ������
				result = updateIng(cook);
			}else {
				pstmt = conn.prepareStatement("insert into cook values(?,?,?,?)");
				pstmt.setInt(1, cook.getRec_id());
				pstmt.setInt(2, cook.getIng_id());
				pstmt.setString(3, cook.getAmount());
				pstmt.setString(4, cook.getUnit());
				pstmt.executeUpdate();
				result = true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return result;
	}
	
	// rec_id �����ΰ��� ���� rec_id�� ����
	public void changeRec_id(int random_id, int rec_id) {
		try {
			conn = ConnectionDAO.getConnection();
			String sql = "select c1.* from (select * from cook where rec_id=?) c1, (select * from cook where rec_id=?) c2 where c1.ing_id=c2.ing_id";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, rec_id);
			pstmt.setInt(2, random_id);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				sql = "delete from cook where rec_id=? and ing_id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, rec_id);
				pstmt.setInt(2, rs.getInt("ing_id"));
				pstmt.executeUpdate();
			}			
			pstmt = conn.prepareStatement("update cook set rec_id=? where rec_id=?");
			pstmt.setInt(1, rec_id);
			pstmt.setInt(2, random_id);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	// ���� ��� �����Ǿ����� true/ �ƴϸ� false
	// c1 = ������� / c2 = ������ ����� �ӽ����
	public boolean isUpdate(int random_id, int rec_id) {
		boolean result = false;
		try {
			conn = ConnectionDAO.getConnection();
			String sql = "select c1.ing_id from (select * from cook where rec_id=?) c1, (select * from cook where rec_id=?) c2 where c1.ing_id=c2.ing_id";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, rec_id);
			pstmt.setInt(2, random_id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return result;
	}
	
	// ��� �ҷ����� - ingredient ���̺� �̿�
	public List <CookDTO> getIng (int startRow, int endRow) throws Exception {
		List ingList = null;
		try {
			conn = ConnectionDAO.getConnection();
			String sql = "select * from (select id,name,rownum r from (select * from ingredient)) where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);			
			rs = pstmt.executeQuery();
				if (rs.next()) {
					ingList = new ArrayList(); 
					do{
						CookDTO ing = new CookDTO();
						ing.setIng_name(rs.getString("name"));
						ingList.add(ing);
					}while(rs.next());
				}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}	
		return ingList;
	}
	
	// �Է��� ���� ��ȯ
	public int getIngCount(int rec_id) throws Exception {
		int count=0;
		try {
			conn = ConnectionDAO.getConnection();
			String sql = "select count(*) from cook where rec_id=?";	// count�� ���� ���� ��ɾ�
			pstmt = conn.prepareStatement(sql);	
			pstmt.setInt(1, rec_id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1); 								// �˻��Ǵ� Į�� ����ŭ count ����
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return count; 
	}
	
	//������̺��� ���� ��ȯ
	public int getIngCount() throws Exception {
		int x=0;
		try {
			conn = ConnectionDAO.getConnection();
			String sql = "select count(*) from ingredient";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				x=rs.getInt(1);
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return x; 
	}
	
	// ��� ����
	public boolean updateIng(CookDTO cook) {
		boolean result = false;
		try {
			conn = ConnectionDAO.getConnection();
			String sql = "select * from cook where rec_id=? and ing_id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cook.getRec_id());
			pstmt.setInt(2, cook.getIng_id());
			rs = pstmt.executeQuery();
			if(rs.next() && cook.getRec_id() >= 10000) {	// ��ᰡ �ְ�, rec_id�� �����̸�
				sql = "update cook set amount=?, unit=? where rec_id=? and ing_id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, cook.getAmount());
				pstmt.setString(2, cook.getUnit());
				pstmt.setInt(3, cook.getRec_id());
				pstmt.setInt(4, cook.getIng_id());
				pstmt.executeUpdate();
				result = true;
			}else {
				result = insertIng(cook);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return result;
	}
	
	//��� ����
	public void deleteIng(CookDTO cook) {
		try {
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("delete from cook where rec_id=? and ing_id=?");
			pstmt.setInt(1, cook.getRec_id());
			pstmt.setInt(2, cook.getIng_id());
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	// ��� �Է��� �� ���
	public void cancleIng(int rec_id) {
		try {
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("delete from cook where rec_id=?");
			pstmt.setInt(1, rec_id);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	//������̺��� �˻��� ���� ��ȯ
	public int getIngCount(String search) throws Exception {
		int x=0;
		try {
			conn = ConnectionDAO.getConnection();
			String sql = "select count(*) from ingredient where name like '%"+search+"%'";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				x=rs.getInt(1);
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return x; 
	}

	// �˻��� ��� �ҷ����� - ingredient ���̺� �̿�
	public List <CookDTO> getIng (String search, int startRow, int endRow) throws Exception {
		List ingList = null;
		try {
			conn = ConnectionDAO.getConnection();
			String sql = "select * from (select id,name,rownum r from (select * from ingredient where name like '%"+search+"%')) where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);			
			rs = pstmt.executeQuery();
				if (rs.next()) {
					ingList = new ArrayList(); 
					do{
						CookDTO ing = new CookDTO();
						ing.setIng_name(rs.getString("name"));
						ingList.add(ing);
					}while(rs.next());
				}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}	
		return ingList;
	}
	
	// ������� ������ rec_id�� �ӽ÷� ����+100000�� �Űܵ�
	public void changeRec_id(int random_id, int rec_id, CookDTO cook) {
		try {
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("update cook set rec_id=? where rec_id=? and ing_id=?");
			pstmt.setInt(1,random_id);
			pstmt.setInt(2, rec_id);
			pstmt.setInt(3, cook.getIng_id());
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	//��� ����
	public void deleteIng(int random_id) {
		try {
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("delete from cook where rec_id=?");
			pstmt.setInt(1, random_id);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
}
