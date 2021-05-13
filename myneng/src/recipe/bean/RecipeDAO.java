package recipe.bean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.ArrayList;

public class RecipeDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	// ������ ����� �۹�ȣ(rec_id)��ȯ
	public int insertRecipe(RecipeDTO recipe) {
		int num = 0;
		try {
			conn = ConnectionDAO.getConnection();
			String sql = "insert into recipe(num, name, process, writer, difficulty, image, cooking_time, day, status)"
						+"values (rec_seq.NEXTVAL,?,?,?,?,?,?,sysdate,1)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, recipe.getName());
			pstmt.setString(2, recipe.getProcess());
			pstmt.setString(3, recipe.getWriter());
			pstmt.setInt(4, recipe.getDifficulty());
			pstmt.setString(5, recipe.getImage());
			pstmt.setInt(6, recipe.getCooking_time());
			pstmt.executeUpdate();
			
			pstmt = conn.prepareStatement("select num from recipe order by num desc");
			rs = pstmt.executeQuery();
			if(rs.next()) {
				num = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return num;
	}
	
	// ���� id�� ȸ������ ��ȸ 
	public int getMemberMaster(String id) {
		int master = 10;
		try {
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("select master from member where id=?");
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				master = rs.getInt("master");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return master;
	}
	
	// ���Ѻ� �ۼ��� �� �� ��ȯ
	public int getRecipeCount(int master, String id) {
		int x = 0;
		String sql = "";
		try {
			conn = ConnectionDAO.getConnection();
			if(master == 2) {
				sql = "select count(*) from recipe where status in(1, 2)";
				pstmt = conn.prepareStatement(sql);
			}else if(master == 0) {
				sql = "select count(*) from (select * from recipe where status in (1, 2)) where status=2 or writer=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
			}else{
				sql = "select count(*) from recipe where status=2";
				pstmt = conn.prepareStatement(sql);
			}
			rs = pstmt.executeQuery();
			if(rs.next()) {
				x = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return x;
	}
	
	// ��õ ������ ���Ѻ� �ۼ��� �� �� ��ȯ
			public int getRecipeCount(List<Integer> recList, int master, String id) {
				int x = 0;
				String sql = "";
				int recNum = 0;
				try {
					for(int i = 0; i < recList.size(); i++) {
						conn = ConnectionDAO.getConnection();
						if(master == 2) {
							sql = "select count(*) from recipe where num = ? and status in(1, 2)";
							pstmt = conn.prepareStatement(sql);
							recNum = recList.get(i);
							pstmt.setInt(1, recNum);
						}else if(master == 0) {
							sql = "select count(*) from (select * from recipe where num = ? and status in (1, 2)) where status=2 or writer=?";
							pstmt = conn.prepareStatement(sql);
							recNum = recList.get(i);
							pstmt.setInt(1, recNum);
							pstmt.setString(2, id);
						}else{
							sql = "select count(*) from recipe where num = ? and status=2";
							pstmt = conn.prepareStatement(sql);
							recNum = recList.get(i);
							pstmt.setInt(1, recNum);
						}
						rs = pstmt.executeQuery();
						if(rs.next()) {
							x = rs.getInt(1);
						}
					}
				}catch(Exception e) {
					e.printStackTrace();
				}finally {
					ConnectionDAO.close(rs, pstmt, conn);
				}
				return x;
			}
	
	// �Խ��� ���������� ������ ������ ��� ��ȯ
	public List <RecipeDTO> getRecipes(int start, int end, int master, String id) {
		List <RecipeDTO> recipeList = null;
		String sql = "";
			try {
				conn = ConnectionDAO.getConnection();
				if(master == 2) {
					sql = "select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, r " 
							+"from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r "
							+"from (select * from recipe where status in (1, 2) order by num desc)) where r >=? and r <=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, start);
					pstmt.setInt(2, end);
				}else if(master == 0) {
					sql = "select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, r " 
							+"from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r "
							+"from (select * from recipe where status in (1, 2) order by num desc) where status=2 or writer=? order by num desc) where r >=? and r <=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, id);
					pstmt.setInt(2, start);
					pstmt.setInt(3, end);					
				}else {
					sql = "select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, r " 
							+"from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r "
							+"from (select * from recipe where status=2 order by num desc)) where r >=? and r <=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, start);
					pstmt.setInt(2, end);					
				}
				rs = pstmt.executeQuery();
				recipeList = new ArrayList <RecipeDTO> (end);
				while(rs.next()) {
					RecipeDTO recipe = new RecipeDTO();
					recipe.setNum(rs.getInt("num"));
					recipe.setName(rs.getString("name"));
					recipe.setProcess(rs.getString("process"));
					recipe.setWriter(rs.getString("writer"));
					recipe.setDifficulty(rs.getInt("difficulty"));
					recipe.setImage(rs.getString("image"));
					recipe.setCooking_time(rs.getInt("cooking_time"));
					recipe.setDay(rs.getTimestamp("day"));
					recipe.setReadcount(rs.getInt("readcount"));
					recipe.setReccommend(rs.getInt("reccommend"));
					recipe.setStatus(rs.getInt("status"));
					recipeList.add(recipe);
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				ConnectionDAO.close(rs, pstmt, conn);
			}
		return recipeList;
	}
	
	// ��õ ������ �Խ��� ���������� ������ ������ ��� ��ȯ
		public List <RecipeDTO>  getRecipes(List<Integer> recList, int start, int end, int master, String id) {
			List recipeList = null;
			int recNum = 0;
			String sql = "";
				try {
					for(int i = 0; i < recList.size(); i++) {
						conn = ConnectionDAO.getConnection();
						if(master == 2) {
							sql = "select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, r " 
									+"from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r "
									+"from (select * from recipe where num = ? and status in (1, 2) order by num desc)) where r >=? and r <=?";
							pstmt = conn.prepareStatement(sql);
							recNum = recList.get(i);
							pstmt.setInt(1, recNum);
							pstmt.setInt(2, start);
							pstmt.setInt(3, end);
						}else if(master == 0) {
							sql = "select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, r " 
									+"from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r "
									+"from (select * from recipe where num = ? and status in (1, 2) order by num desc) where status=2 or writer=? order by num desc) where r >=? and r <=?";
							pstmt = conn.prepareStatement(sql);
							recNum = recList.get(i);
							pstmt.setInt(1, recNum);
							pstmt.setString(2, id);
							pstmt.setInt(3, start);
							pstmt.setInt(4, end);					
						}else {
							sql = "select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, r " 
									+"from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r "
									+"from (select * from recipe where num = ? and status=2 order by num desc)) where r >=? and r <=?";
							pstmt = conn.prepareStatement(sql);
							recNum = recList.get(i);
							pstmt.setInt(1, recNum);
							pstmt.setInt(2, start);
							pstmt.setInt(3, end);				
						}
						rs = pstmt.executeQuery();
						recipeList = new ArrayList <RecipeDTO> (end);
						while(rs.next()) {
							RecipeDTO recipe = new RecipeDTO();
							recipe.setNum(rs.getInt("num"));
							recipe.setName(rs.getString("name"));
							recipe.setProcess(rs.getString("process"));
							recipe.setWriter(rs.getString("writer"));
							recipe.setDifficulty(rs.getInt("difficulty"));
							recipe.setImage(rs.getString("image"));
							recipe.setCooking_time(rs.getInt("cooking_time"));
							recipe.setDay(rs.getTimestamp("day"));
							recipe.setReadcount(rs.getInt("readcount"));
							recipe.setReccommend(rs.getInt("reccommend"));
							recipe.setStatus(rs.getInt("status"));
							recipeList.add(recipe);
						}
					}
				}catch(Exception e) {
					e.printStackTrace();
				}finally {
					ConnectionDAO.close(rs, pstmt, conn);
				}
			return recipeList;
		}
	
	//�Խñ� ���� Ŭ���� �ش� �Խñ� ��ȸ�� 1����
	public void readCount(int num) {
		try {
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("update recipe set readcount=readcount+1 where num=?"); //��ȸ�� 1 ����
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	// �Խñ� ���� Ŭ���� �ش� �Խñ� ���� ��ȯ
	public RecipeDTO getRecipes(int num) {
			RecipeDTO recipe = null;
			try {
				conn = ConnectionDAO.getConnection();
				pstmt = conn.prepareStatement("select * from recipe where num=?");
				pstmt.setInt(1, num);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					recipe = new RecipeDTO();
					recipe.setNum(rs.getInt("num"));
					recipe.setName(rs.getString("name"));
					recipe.setProcess(rs.getString("process"));
					recipe.setWriter(rs.getString("writer"));
					recipe.setDifficulty(rs.getInt("difficulty"));
					recipe.setImage(rs.getString("image"));
					recipe.setCooking_time(rs.getInt("cooking_time"));
					recipe.setDay(rs.getTimestamp("day"));
					recipe.setReadcount(rs.getInt("readcount"));
					recipe.setReccommend(rs.getInt("reccommend"));
					recipe.setStatus(rs.getInt("status"));
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				ConnectionDAO.close(rs, pstmt, conn);
			}
		return recipe;
	}
	
	//������ ����(�̹��� ����)
	public void updateRecipe(RecipeDTO recipe) {
		try {
			conn = ConnectionDAO.getConnection();
			String sql = "update recipe set name=?, process=?, writer=?, difficulty=?, cooking_time=? where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, recipe.getName());
			pstmt.setString(2, recipe.getProcess());
			pstmt.setString(3, recipe.getWriter());
			pstmt.setInt(4, recipe.getDifficulty());
			pstmt.setInt(5, recipe.getCooking_time());
			pstmt.setInt(6, recipe.getNum());
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	// ������ ���� - �̹����� ���� �߰��Ǿ�����
	public void updateImage(RecipeDTO recipe) {
		try {
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("update recipe set image=? where num=?");
			pstmt.setString(1, recipe.getImage());
			pstmt.setInt(2, recipe.getNum());
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	//������ ���� - status 0���� ����
	public boolean changeRecipeStatus(int num, int status) {
		 boolean result = false;
		 try {
			 conn = ConnectionDAO.getConnection();
			 pstmt = conn.prepareStatement("select * from recipe where num=?");
			 pstmt.setInt(1, num);
			 rs = pstmt.executeQuery();
			 if(rs.next()) {
				 pstmt = conn.prepareStatement("update recipe set status=? where num=?");
				 pstmt.setInt(1, status);
				 pstmt.setInt(2, num);
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
	
	//������ ��õ�� reccommend + 1
	public void reccRecipe(int num) {
		try {
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("update recipe set reccommend=reccommend+1 where num=?");
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	// ���� ������ id_scrap���̺� �����ϴ��� Ȯ��
	// �����ϸ� true  // ������ false
	public boolean isScrap(String id, int num) {
		boolean result = false;			
		try {
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("select rec_id from "+id+"_scrap where rec_id=?"); // ���� ���� ������ Ȯ��
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) {			// �̹� ������ ������
				result = true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return result;
	}
	
	// ���� ������ id_scrap���̺� �߰�
	public void setScrap(String id, int num) {
		try {
			int scrap_id = 1;
			if(!isScrap(id, num)) { 	// ������ ���� 
				conn = ConnectionDAO.getConnection();
				pstmt = conn.prepareStatement("select id from "+id+"_scrap order by id desc");
				rs = pstmt.executeQuery();
				if(rs.next()) {
					scrap_id += rs.getInt("id");		// index ����
				}
				String sql = "insert into "+id+"_scrap values(?,?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, scrap_id);
				pstmt.setInt(2, num);
				pstmt.executeUpdate();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	// ������ - id_scrap ���̺��� ����
	public void cancleScrap(String id, int num) {
		try {
			if(isScrap(id, num)) { 			// ������ ����
				conn = ConnectionDAO.getConnection();
				pstmt = conn.prepareStatement("delete from "+id+"_scrap where rec_id=?");
				pstmt.setInt(1, num);
				pstmt.executeUpdate();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	// �˻��� �� �� ��ȯ
	public int getRecipeCount(String col, String search, int master, String id) {
		int x = 0;
		String sql = "";
		try {
			conn = ConnectionDAO.getConnection();
			if(master == 2) {
				sql = "select count(*) from recipe where "+col+" like '%"+search+"%' and status in(1, 2)";
				pstmt = conn.prepareStatement(sql);
			}else if(master == 0) {
				sql = "select count(*) from (select * from recipe where status in (1, 2)) where "+col+" like '%"+search+"%' and status=2 or writer=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
			}else{
				sql = "select count(*) from recipe where "+col+" like '%"+search+"%' and status=2";
				pstmt = conn.prepareStatement(sql);
			}
			rs = pstmt.executeQuery();
			if(rs.next()) {
				x = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return x;
	}
	
	// �÷��� �˻���� ��ȯ
	public List <RecipeDTO> getRecipes(String col, String search, int start, int end, int master, String id) {
		List <RecipeDTO> recipeList = null;
		String sql = "";
			try {
				conn = ConnectionDAO.getConnection();
				if(master == 2) {
					sql = "select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, r " 
							+"from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r "
							+"from (select * from recipe where "+col+" like '%"+search+"%' and status in(1, 2) order by num desc)"
							+ "order by num desc) where r >=? and r <=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, start);
					pstmt.setInt(2, end);
				}else if(master == 0) {
					sql = "select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, r " 
							+"from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r "
							+"from (select * from (select * from recipe where status in (1, 2) order by num desc) where "+col+" like '%"+search+"%' and status=2 or writer=?)"
							+ "order by num desc) where r >=? and r <=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, id);
					pstmt.setInt(2, start);
					pstmt.setInt(3, end);
				}else {
					sql = "select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, r " 
							+"from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r "
							+"from (select * from recipe where "+col+" like '%"+search+"%' and status=2 order by num desc)"
							+ "order by num desc) where r >=? and r <=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, start);
					pstmt.setInt(2, end);
				}
				rs = pstmt.executeQuery();
				recipeList = new ArrayList <RecipeDTO> (end);
				while(rs.next()) {
					RecipeDTO recipe = new RecipeDTO();
					recipe.setNum(rs.getInt("num"));
					recipe.setName(rs.getString("name"));
					recipe.setProcess(rs.getString("process"));
					recipe.setWriter(rs.getString("writer"));
					recipe.setDifficulty(rs.getInt("difficulty"));
					recipe.setImage(rs.getString("image"));
					recipe.setCooking_time(rs.getInt("cooking_time"));
					recipe.setDay(rs.getTimestamp("day"));
					recipe.setReadcount(rs.getInt("readcount"));
					recipe.setReccommend(rs.getInt("reccommend"));
					recipe.setStatus(rs.getInt("status"));
					recipeList.add(recipe);
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				ConnectionDAO.close(rs, pstmt, conn);
			}
		return recipeList;
	}

	// ��õ�� ������ number���� �� ��� ��ȯ
	public List <RecipeDTO> getBestRecipes(int number) {
		List <RecipeDTO> recipeList = null;
			try {
				conn = ConnectionDAO.getConnection();
				String sql = "select * from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r"+
							" from (select * from recipe where status=2 order by reccommend desc, num desc)) where r <= ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, number);
				rs = pstmt.executeQuery();
				recipeList = new ArrayList <RecipeDTO> (number);
				while(rs.next()) {
					RecipeDTO recipe = new RecipeDTO();
					recipe.setNum(rs.getInt("num"));
					recipe.setName(rs.getString("name"));
					recipe.setProcess(rs.getString("process"));
					recipe.setWriter(rs.getString("writer"));
					recipe.setDifficulty(rs.getInt("difficulty"));
					recipe.setImage(rs.getString("image"));
					recipe.setCooking_time(rs.getInt("cooking_time"));
					recipe.setDay(rs.getTimestamp("day"));
					recipe.setReadcount(rs.getInt("readcount"));
					recipe.setReccommend(rs.getInt("reccommend"));
					recipe.setStatus(rs.getInt("status"));
					recipeList.add(recipe);
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				ConnectionDAO.close(rs, pstmt, conn);
			}
		return recipeList;
	}
	
}
