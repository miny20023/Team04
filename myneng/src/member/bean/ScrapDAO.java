package member.bean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import recipe.bean.ConnectionDAO;

import java.util.ArrayList;

public class ScrapDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	// 
	public int insertRecipe(ScrapDTO recipe) {
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
	
	// 
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
	
	// 
	public int getRecipeCount() {
		int x = 0;
		try {
			conn = ConnectionDAO.getConnection();
			String sql = "select count(*) from recipe";
			pstmt = conn.prepareStatement(sql);
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
	
	// 
	public List <ScrapDTO> getRecipes(int start, int end) {
		List <ScrapDTO> recipeList = null;
			try {
				conn = ConnectionDAO.getConnection();
				String sql = "select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, r " 
							+"from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r "
							+"from recipe order by num desc) where r >=? and r <=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, start);
				pstmt.setInt(2, end);
				rs = pstmt.executeQuery();
				recipeList = new ArrayList <ScrapDTO> (end);
				while(rs.next()) {
					ScrapDTO recipe = new ScrapDTO();
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
	
	//
	public void readCount(int num) {
		try {
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("update recipe set readcount=readcount+1 where num=?"); //ï¿½ï¿½È¸ï¿½ï¿½ 1 ï¿½ï¿½ï¿½ï¿½
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	//
	public ScrapDTO getRecipes(int num) {
			ScrapDTO recipe = null;
			try {
				conn = ConnectionDAO.getConnection();
				pstmt = conn.prepareStatement("select * from recipe where num=?");
				pstmt.setInt(1, num);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					recipe = new ScrapDTO();
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
	
	//
	public void updateRecipe(ScrapDTO recipe) {
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
	
	// 
	public void updateImage(ScrapDTO recipe) {
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
	
	//
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
	
	//·¹½ÃÇÇ ÃßÃµ½Ã recommend+1
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
	
	// ÂòÇÑ ·¹½ÃÇÇ id_scrapÅ×ÀÌºí¿¡ Ãß°¡
	public void setScrap(String id, int num) {
		try {
			int scrap_id = 1;
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("select rec_id from "+id+"_scrap where rec_id=?"); // 
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(!rs.next()) { //  
				pstmt = conn.prepareStatement("select id from "+id+"_scrap order by id desc");
				rs = pstmt.executeQuery();
				if(rs.next()) {
					scrap_id = rs.getInt("id") + 1;
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

	// 
	public List <ScrapDTO> getRecipes(String col, String search, int start, int end) {
		List <ScrapDTO> recipeList = null;
			try {
				conn = ConnectionDAO.getConnection();
				String sql = "select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, r " 
							+"from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r "
							+"from (select * from recipe where "+col+" like '%"+search+"%')"
							+ "order by num desc) where r >=? and r <=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, start);
				pstmt.setInt(2, end);
				rs = pstmt.executeQuery();
				recipeList = new ArrayList <ScrapDTO> (end);
				while(rs.next()) {
					ScrapDTO recipe = new ScrapDTO();
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
	
	// 
		public int getScrapCount(String id) {
			int x = 0;
			try {
				conn = ConnectionDAO.getConnection();
				String sql = "select count(*) from "+id+"_scrap";
				pstmt = conn.prepareStatement(sql);
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
	
	// 
			public List <ScrapDTO> getScrapList(int start, int end, String id) {
				List <ScrapDTO> recipeList = null;
					try {
						conn = ConnectionDAO.getConnection();
						String sql = "select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, r " 
								+"from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r "
								+"from (select * from recipe where num in (select rec_id from "+id+"_scrap) order by num desc)) where r >=? and r <=?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setInt(1, start);
						pstmt.setInt(2, end);
						rs = pstmt.executeQuery();
						recipeList = new ArrayList <ScrapDTO> ();
						while(rs.next()) {
							ScrapDTO recipe = new ScrapDTO();
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
	
			// 
			public boolean deleteScrap(String id, int num) {
				boolean result = false;
				try {
					conn = ConnectionDAO.getConnection();
					String sql="select * from "+id+"_scrap where rec_id=?";
					pstmt=conn.prepareStatement(sql);
					pstmt.setInt(1, num);
					rs=pstmt.executeQuery();
					if(rs.next()) {
						sql="delete from "+id+"_scrap where rec_id=?";
						pstmt=conn.prepareStatement(sql);
						pstmt.setInt(1, num);
						pstmt.executeUpdate();
						result=true;
						}
				}catch(Exception e) {
					
				}finally {
					ConnectionDAO.close(rs, pstmt, conn);
				}
				return result;
			}
			// ÂòÇÑ ·¹½ÃÇÇ id_scrapÅ×ÀÌºí¿¡ Á¸ÀçÇÏ´ÂÁö È®ÀÎ
			// Á¸ÀçÇÏ¸é true  // ¾øÀ¸¸é false
		public boolean isScrap(String id, int num) {
			boolean result = false;			
			try {
				conn = ConnectionDAO.getConnection();
				pstmt = conn.prepareStatement("select rec_id from "+id+"_scrap where rec_id=?"); // ±âÁ¸ ÂòÇÑ ·¹½ÃÇÇ È®ÀÎ
				pstmt.setInt(1, num);
				rs = pstmt.executeQuery();
				if(rs.next()) {			// ÀÌ¹Ì °¡Áö°í ÀÖÀ¸¸é
					result = true;
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				ConnectionDAO.close(rs, pstmt, conn);
			}
			return result;
		}		
	
}
