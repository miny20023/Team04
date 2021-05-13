package test.model.food;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import test.model.food.MaNengDataBean;
import test.model.food.ConnectionDAO;

public class MaNengDBBean implements Serializable {
	private Connection conn = null;
	private PreparedStatement ps = null;
	private ResultSet rs = null;

	public int dateCompare(String freshness) {
		SimpleDateFormat format = new SimpleDateFormat("yy-MM-dd");
		Date t = new Date();
		String d = format.format(t);
		Date today = null; 								// 오늘 날짜
		Date expirationDate = null;  					// 유통기한
		try {
			expirationDate = format.parse(freshness);
			today = format.parse(d);
		}catch(Exception e) {
			e.printStackTrace();
		}
		int compare = expirationDate.compareTo(today);	// 비교
		return compare;
	}
	
	public List getIngs () throws Exception {
		List totalList = new ArrayList();
		try {
			conn = ConnectionDAO.getConn();
			String sql = "select * from ingredient";
			ps = conn.prepareStatement(sql); 			
			rs = ps.executeQuery();
					if (rs.next()) {
						do{
							MaNengDataBean ing = new MaNengDataBean();
							ing.setIngname(rs.getString("name"));
							ing.setIng_id(rs.getInt("id"));
							totalList.add(ing);
						}while(rs.next());
					}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, ps, conn);
		}	
		return totalList;
	}
	
	public List <MaNengDataBean> getIngs(int num) {
		List ingList = new ArrayList <MaNengDataBean> ();
		try {
			conn = ConnectionDAO.getConn();
			String sql = "select i.name, c.amount, c.unit from ingredient i, cook c where c.ing_id=i.id and c.rec_id=?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, num);
			rs = ps.executeQuery();
			while(rs.next()) {
				MaNengDataBean cook = new MaNengDataBean();
				cook.setIngname(rs.getString("name"));
				cook.setAmount(rs.getString("amount"));
				cook.setUnit(rs.getString("unit"));
				ingList.add(cook);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, ps, conn);
		}
		return ingList;
	}
	
	// startRow부터 endRow까지의 재료 가져오기
	public List getIngs (int startRow, int endRow) throws Exception {
		List ingList = null;
		try {
			conn = ConnectionDAO.getConn();
			String sql = "select * from (select id,name,rownum r from (select * from ingredient)) where r >= ? and r <= ?";
			ps = conn.prepareStatement(sql); 
			ps.setInt(1, startRow);
			ps.setInt(2, endRow);			
			rs = ps.executeQuery();
					if (rs.next()) {
						ingList = new ArrayList(); 
						do{
							MaNengDataBean ing = new MaNengDataBean();
							ing.setIngname(rs.getString("name"));
							ing.setIng_id(rs.getInt("id"));
							ingList.add(ing);
						}while(rs.next());
					}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, ps, conn);
		}	
		return ingList;
	}
	
	// search가 포함 된 startRow부터 endRow까지의 재료 가져오기
	public List getIngs (String search, int startRow, int endRow) throws Exception {
		List ingList = null;
		String sql ="";
		try {
			conn = ConnectionDAO.getConn();
			sql = "select * from (select id,name,rownum r from ";
			sql += "(select * from ingredient where name like '%"+search+"%'))where r >= ? and r <= ?";
			ps = conn.prepareStatement(sql); 
			ps.setInt(1, startRow);
			ps.setInt(2, endRow);			
			rs = ps.executeQuery();
					if (rs.next()) {
						ingList = new ArrayList(); 
						do{
							MaNengDataBean ing = new MaNengDataBean();
							ing.setIngname(rs.getString("name"));
							ing.setIng_id(rs.getInt("id"));
							ingList.add(ing);
						}while(rs.next());
					}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, ps, conn);
		}	
		return ingList;
	}
	
	// tempIngList 재료 가져오기
		public MaNengDataBean getIng (String getName) throws Exception {
			MaNengDataBean ing = new MaNengDataBean();
			try {
				conn = ConnectionDAO.getConn();
				String sql = "select * from ingredient where name = '%" + getName +"%'";
				ps = conn.prepareStatement(sql); 
				rs = ps.executeQuery();
				if (rs.next()) { 
					ing.setIngname(rs.getString("name"));
					ing.setIng_id(rs.getInt("id"));
				}
			} catch(Exception ex) {
				ex.printStackTrace();
			} finally {
				ConnectionDAO.close(rs, ps, conn);
			}	
			return ing;
		}
	
	// search가 포함 된 재료 가져오기
	public List getIngs (String search) throws Exception {
		List ingList = null;
		try {
			conn = ConnectionDAO.getConn();
			ps = conn.prepareStatement("select * from ingredient where name like '%"+search+"%'" ); 
			rs = ps.executeQuery();
			if (rs.next()) {
				ingList = new ArrayList(); 
				do{
					MaNengDataBean ing = new MaNengDataBean();
					ing.setIngname(rs.getString("name"));
					ing.setIng_id(rs.getInt("id"));
					ingList.add(ing);
				}while(rs.next());
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, ps, conn);
		}	
		return ingList;
	}
	
	// 재료 수 확인
	public int getIngCount() throws Exception {
		int x=0;
		try {
			conn = ConnectionDAO.getConn();
			String sql = "select count(*) from ingredient";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if (rs.next()) {
				x=rs.getInt(1);
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, ps, conn);
		}
		return x; 
	}
	
	// search가 포함 된 재료 수
	public int getIngCount(String search) throws Exception {
		int x=0;
		try {
			conn = ConnectionDAO.getConn();
			String sql = "select count(*) from ingredient where name like '%"+search+"%'";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if (rs.next()) {
				x = rs.getInt(1);
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, ps, conn);
		}
		return x; 
	}
	
	// mem_id 아이디의 냉장고 기입 된 재료 수
	public int getRefCount(String mem_id) throws Exception {
		int x=0;
		try {
			conn = ConnectionDAO.getConn();
			String sql = "select count(*) from " + mem_id;	
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if (rs.next()) {
				x = rs.getInt(1);
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, ps, conn);
		}
		return x; 
	}
	
	// mem_id 아이디의 냉장고 기입 된 search가 포함된 재료 수
	public int getRefCount(String mem_id, String search) throws Exception {
		int x=0;
		try {
			conn = ConnectionDAO.getConn();
			String sql = "select count(*) from " + mem_id;
			sql += " where name like '%"+search+"%'";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if (rs.next()) {
				x = rs.getInt(1);
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, ps, conn);
		}
		return x; 
	}
	
	// mem_id 아이디의 냉장고에서 startRow부터 endRow까지의 기입 된 재료 수
	public List getRefs(String mem_id, int startRow, int endRow) throws Exception {
		List ingList = new ArrayList();
		String sql ="";
		try {
			conn = ConnectionDAO.getConn();
			sql = "select * from (select name, ing_id, amount, unit, freshness, rownum r from (select * from ";
			sql += mem_id + " )) where r >= ? and r <= ?";			
			ps = conn.prepareStatement(sql);
			ps.setInt(1, startRow);
			ps.setInt(2, endRow);
			rs = ps.executeQuery();
			if (rs.next()) {
				do{
					MaNengDataBean ing = new MaNengDataBean();
					ing.setIngname(rs.getString("name"));
					ing.setIng_id(rs.getInt("ing_id"));
					ing.setAmount(rs.getString("amount"));
					ing.setUnit(rs.getString("unit"));
					ing.setFreshness(rs.getString("freshness"));
					ingList.add(ing);
				}while(rs.next());
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, ps, conn);
		}	
		return ingList;
	}
	
	// mem_id 아이디의 냉장고에서 search가 포함 된 startRow부터 endRow까지의 기입 된 재료 수
		public List getRefs(String mem_id, String search ,int startRow, int endRow) throws Exception {
			List ingList = new ArrayList();
			String sql ="";
			try {
				conn = ConnectionDAO.getConn();
				sql = "select * from (select name, ing_id, amount, unit, freshness, rownum r from (select * from ";
				sql += mem_id + " where name like '%"+search+"%')) where r >= ? and r <= ?";			
				ps = conn.prepareStatement(sql);
				ps.setInt(1, startRow);
				ps.setInt(2, endRow);
				rs = ps.executeQuery();
				if (rs.next()) {
					do{
						MaNengDataBean ing = new MaNengDataBean();
						ing.setIngname(rs.getString("name"));
						ing.setIng_id(rs.getInt("ing_id"));
						ing.setAmount(rs.getString("amount"));
						ing.setUnit(rs.getString("unit"));
						ing.setFreshness(rs.getString("freshness"));
						ingList.add(ing);
					}while(rs.next());
				}
			} catch(Exception ex) {
				ex.printStackTrace();
			} finally {
				ConnectionDAO.close(rs, ps, conn);
			}	
			return ingList;
		}
	
	// mem_id 아이디의 냉장고에 재료 기입하기
	public void insertRef(MaNengDataBean mnData, String mem_id) throws Exception {
		String sql="";
		try {
			conn = ConnectionDAO.getConn(); 
			sql = "select * from " + mem_id;
			sql += " where name = ? and unit = ? and freshness = ?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, mnData.getIngname());
			ps.setString(2, mnData.getUnit());
			ps.setString(3, mnData.getFreshness());
			rs = ps.executeQuery();
			if(rs.next()) {
				int newAmount = Integer.parseInt(rs.getString("amount"))+ Integer.parseInt(mnData.getAmount());
				mnData.setAmount(newAmount+"");
				sql = "update " + mem_id;
				sql += " set amount = ? where name = ? and unit = ? and freshness = ?";
				ps = conn.prepareStatement(sql);
				ps.setString(1, mnData.getAmount());
				ps.setString(2, mnData.getIngname());
				ps.setString(3, mnData.getUnit());
				ps.setString(4, mnData.getFreshness());
				ps.executeUpdate();
			}else {
				sql = "insert into " + mem_id;
				sql+="(name, ing_id, amount, unit, freshness) values(?,?,?,?,?)";
				ps = conn.prepareStatement(sql);
				ps.setString(1, mnData.getIngname());
				ps.setInt(2, mnData.getIng_id());
				ps.setString(3, mnData.getAmount());
				ps.setString(4, mnData.getUnit());
				ps.setString(5, mnData.getFreshness());
				ps.executeUpdate();
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, ps, conn);
		}
	}
	
	public void updateRef(MaNengDataBean ing, MaNengDataBean preIng, String mem_id) throws Exception {
		String sql="";
		try {
			conn = ConnectionDAO.getConn(); 
			sql = "select * from " + mem_id;
			sql+= " where name = ? and unit = ? and freshness = ?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, preIng.getIngname());
			ps.setString(2, preIng.getUnit());
			ps.setString(3, preIng.getFreshness());
			rs = ps.executeQuery();
			if(rs.next()) {
				sql = "update " + mem_id;
				sql += " set amount = ?, unit = ?, freshness = ? where name = ? and unit = ? and freshness = ?";
				ps = conn.prepareStatement(sql);
				ps.setString(1, ing.getAmount());
				ps.setString(2, ing.getUnit());
				ps.setString(3, ing.getFreshness());
				ps.setString(4, preIng.getIngname());
				ps.setString(5, preIng.getUnit());
				ps.setString(6, preIng.getFreshness());
				ps.executeUpdate();
			}else {
				sql = "insert into " + mem_id;
				sql+="(name, ing_id, amount, unit, freshness) values(?,?,?,?,?)";
				ps = conn.prepareStatement(sql);
				ps.setString(1, ing.getIngname());
				ps.setInt(2, ing.getIng_id());
				ps.setString(3, ing.getAmount());
				ps.setString(4, ing.getUnit());
				ps.setString(5, ing.getFreshness());
				ps.executeUpdate();
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, ps, conn);
		}
	}
	
	public void deleteRef(MaNengDataBean ing, String mem_id) throws Exception {
		String sql="";
		try {
			conn = ConnectionDAO.getConn(); 		
			sql = "delete from " + mem_id;
			sql+=" where name = ? and amount = ? and unit = ? and freshness = ?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, ing.getIngname());
			ps.setString(2, ing.getAmount());
			ps.setString(3, ing.getUnit());
			ps.setString(4, ing.getFreshness());
			ps.executeUpdate();
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, ps, conn);
		}
	}
	
	public List fixedList(MaNengDataBean checkedData, List<MaNengDataBean> tempList) {
		List fixedList = tempList;
		for(int i = 0; i < tempList.size(); i++) {
			MaNengDataBean ing = (MaNengDataBean)fixedList.get(i);
			if(checkedData.getIng_id()==ing.getIng_id()) {
				fixedList.set(i,checkedData);
			}else {
				fixedList.add(checkedData);
			}
		}
		return fixedList;
	}
	
	// 체크 된 재료로만 레시피 추천
	public List<Integer> mixRecipe(List<MaNengDataBean> tempIngList) throws Exception { 
		List recList = new ArrayList();
		List<Integer> ing_idList = new ArrayList();									// 재료ID list 생성
		for(int i = 0; i < tempIngList.size() ; i++) {
			MaNengDataBean checkedIng_id = (MaNengDataBean)tempIngList.get(i);
			ing_idList.add(checkedIng_id.getIng_id());
		}
		String sql="";
		int count = 0;
		boolean check = true;
		try {
			conn = ConnectionDAO.getConn();
			sql = "select count(*) AS rowcount from (select distinct rec_id from cook)";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if(rs.next()) {
				count = rs.getInt("rowcount");	// rs.getInt(1)로 되지 않고, count = rs.getBigDecimal(1).intValue()도 안된다.
			}									// AS rowcount로 칼럼을 지정해 직접 레시피 가지 수 호출			
			for(int i = 1 ; i <= count ; i++) {		
				sql = "select distinct ing_id, amount from cook where rec_id = " + i;
				ps = conn.prepareStatement(sql);
				rs = ps.executeQuery();
				while(rs.next()) {	
					if(ing_idList.contains(rs.getInt("ing_id")) ){	// 재료ID 'i'번 리스트의 재료 있는지 확인
						for(int j = 0 ; j < tempIngList.size() ; j++) {
						MaNengDataBean list = tempIngList.get(j);
							if(list.getIng_id()==rs.getInt("ing_id")) {	// 레시피 ing와 맞는 ing 냉장고에서 호출
								MaNengDBBean mnDB = new MaNengDBBean();
								double ing = mnDB.calForm(list.getAmount());
								double cook = mnDB.calForm(rs.getString("amount"));
								if(ing < cook) {			// 레시피와 냉장고 amount 비교
									check = false;
								}
							}
						}
					}else {
						check = false;
					}	
				}	
				if(check) {
					recList.add(i);		// 추천 된 레시피를 리스트에 추가
				}
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, ps, conn);
		}
		return recList;
	}
	
	/* 
	 	Str 분수 및 큰 수 double 타입으로 변환
		10까지 가장 큰 소수 = 7 
		-------1/7 = 0.142857 무한소수임을 감안 하여 소수 6째 자리까지만 계산(더 높은 분모를 계산하려는 변태가 없기를..)
		-------수정 6째 자리 읽지도 못한다.
		double로 표현 가능한지 확인
		분수가 있다면 소수 2째 자리에서 반올림
	*/
	public double calForm(String amount) {
		double value = 0;
		try {
			value = Double.parseDouble(amount);
		}catch(Exception f) {
			//f.printStackTrace();
		}finally {
			if(value==0) {
				String[] fraction = amount.split("/");
				String f1 = fraction[0];
				String f2 = fraction[1];
				double numerator = Double.parseDouble(f1);
				double denominator = Double.parseDouble(f2);
				value = numerator/denominator;
			}
		}
		return value;
	}
	
	public String calUtil(double refAmount, double insertAmount) {
		String addAmount = "";
		return addAmount;
	}
}
