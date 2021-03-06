package test.model.food;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import test.model.food.ConnectionDAO;
import java.util.ArrayList;

public class RecipeDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	// 레시피 등록후 글번호(rec_id)반환
	public int insertRecipe(RecipeDTO recipe) {
		int num = 0;
		try {
			conn = ConnectionDAO.getConn();
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
	
	// 세션 id로 회원권한 조회 
	public int getMemberMaster(String id) {
		int master = 10;
		try {
			conn = ConnectionDAO.getConn();
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
	
	// 권한별 작성된 글 수 반환
	public int getRecipeCount(int master, String id) {
		int x = 0;
		String sql = "";
		try {
			conn = ConnectionDAO.getConn();
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
	
	// 게시판 한페이지에 보여줄 레시피 목록 반환
	public List <RecipeDTO> getRecipes(int start, int end, int master, String id) {
		List <RecipeDTO> recipeList = null;
		String sql = "";
			try {
				conn = ConnectionDAO.getConn();
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
	
	//게시글 제목 클릭시 해당 게시글 조회수 1증가
	public void readCount(int num) {
		try {
			conn = ConnectionDAO.getConn();
			pstmt = conn.prepareStatement("update recipe set readcount=readcount+1 where num=?"); //조회수 1 증가
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	// 게시글 제목 클릭시 해당 게시글 내용 반환
	public RecipeDTO getRecipes(int num) {
			RecipeDTO recipe = null;
			try {
				conn = ConnectionDAO.getConn();
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
	
	//레시피 수정(이미지 제외)
	public void updateRecipe(RecipeDTO recipe) {
		try {
			conn = ConnectionDAO.getConn();
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
	
	// 레시피 수정 - 이미지가 새로 추가되었을때
	public void updateImage(RecipeDTO recipe) {
		try {
			conn = ConnectionDAO.getConn();
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
	
	//레시피 삭제 - status 0으로 변경
	public boolean changeRecipeStatus(int num, int status) {
		 boolean result = false;
		 try {
			 conn = ConnectionDAO.getConn();
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
	
	//레시피 추천시 reccommend + 1
	public void reccRecipe(int num) {
		try {
			conn = ConnectionDAO.getConn();
			pstmt = conn.prepareStatement("update recipe set reccommend=reccommend+1 where num=?");
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	// 찜한 레시피 id_scrap테이블에 존재하는지 확인
	// 존재하면 true  // 없으면 false
	public boolean isScrap(String id, int num) {
		boolean result = false;			
		try {
			conn = ConnectionDAO.getConn();
			pstmt = conn.prepareStatement("select rec_id from "+id+"_scrap where rec_id=?"); // 기존 찜한 레시피 확인
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) {			// 이미 가지고 있으면
				result = true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return result;
	}
	
	// 찜한 레시피 id_scrap테이블에 추가
	public void setScrap(String id, int num) {
		try {
			int scrap_id = 1;
			if(!isScrap(id, num)) { 	// 없으면 진행 
				conn = ConnectionDAO.getConn();
				pstmt = conn.prepareStatement("select id from "+id+"_scrap order by id desc");
				rs = pstmt.executeQuery();
				if(rs.next()) {
					scrap_id += rs.getInt("id");		// index 설정
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
	
	// 찜해제 - id_scrap 테이블에서 삭제
	public void cancleScrap(String id, int num) {
		try {
			if(isScrap(id, num)) { 			// 있으면 삭제
				conn = ConnectionDAO.getConn();
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
	
	// 검색된 글 수 반환
	public int getRecipeCount(String col, String search, int master, String id) {
		int x = 0;
		String sql = "";
		try {
			conn = ConnectionDAO.getConn();
			if(master == 2) {
				sql = "select count(*) from recipe where "+col+" like '%"+search+"%' and status in(1, 2)";
				pstmt = conn.prepareStatement(sql);
			}else if(master == 0) {
				sql = "select count(*) from (select * from recipe where status in (1, 2)) where "+col+" like '%"+search+"%' and (status=2 or writer=?)";
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
	
	// 컬럼별 검색결과 반환
	public List <RecipeDTO> getRecipes(String col, String search, int start, int end, int master, String id) {
		List <RecipeDTO> recipeList = null;
		String sql = "";
			try {
				conn = ConnectionDAO.getConn();
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
							+"from (select * from (select * from recipe where status in (1, 2) order by num desc) where "+col+" like '%"+search+"%' and (status=2 or writer=?))"
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

	// 추천수 순으로 number개의 글 목록 반환
	public List <RecipeDTO> getBestRecipes(int number) {
		List <RecipeDTO> recipeList = null;
			try {
				conn = ConnectionDAO.getConn();
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
	
	// 추천 레시피 게시판 한페이지에 보여줄 레시피 목록 반환
	public List <RecipeDTO>  getRecipes(List<Integer> recList, int start, int end, int master, String id) {
		List<RecipeDTO> recipeList = null;
		int recNum = 0;
		int n = recList.size();
		String sql = "";
		String qms = "";
		for(int i = 0; i < n; i++) {
			if(qms.contains("?")){
				qms += ",";
			}
			qms += "?";
		}
			try {
					conn = ConnectionDAO.getConn();
					if(master == 2) {
						sql = "select * from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r from (select * from recipe where num in(";
						sql += qms;
						sql += ")status in (1, 2) order by num desc)) where r >=? and r <=?";
						pstmt = conn.prepareStatement(sql);
						for(int i = 0; i < n; i++) {
							recNum = recList.get(i);
							pstmt.setInt(i+1, recNum);
						}
						pstmt.setInt(n+1, start);
						pstmt.setInt(n+2, end);
					}else if(master == 0) {
						sql = "select * from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r from (select * from recipe where num in (";
						sql += qms;
						sql += ") and status in (1, 2) order by num desc) where status=2 or writer=? order by num desc) where r >=? and r <=?";;
						pstmt = conn.prepareStatement(sql);
						for(int i = 0; i < n; i++) {
							recNum = recList.get(i);
							pstmt.setInt(i+1, recNum);
						}
						pstmt.setString(n+1, id);
						pstmt.setInt(n+2, start);
						pstmt.setInt(n+3, end);
					}else {
						sql = "select * from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r from (select * from recipe where num in(";
						sql += qms;
						sql	+= ") and status=2 order by num desc)) where r >=? and r <=?";
						pstmt = conn.prepareStatement(sql);
						for(int i = 0; i < n; i++) {
							recNum = recList.get(i);
							pstmt.setInt(i+1, recNum);
						}
						pstmt.setInt(n+1, start);
						pstmt.setInt(n+2, end);				
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

	// 추천 레시피 권한별 작성된 글 수 반환
	public int getRecipeCount(List<Integer> recList, int master, String id) {
		String sql = "";
		String qms = "";
		int x = 0;
		int rp = recList.size();
		int recNum = 0;
		for(int i = 0; i < rp; i++) {
			if(qms.contains("?")) {
				qms+=",";
			}
			qms += "?";
		}						
		try {
			conn = ConnectionDAO.getConn();
			if(master == 2) {
				sql = "select count(*) from recipe where num in (";
				sql += qms;
				sql	+= ") and status in(1, 2)";
				pstmt = conn.prepareStatement(sql);
				for(int i = 0; i < rp; i++) {
					recNum = recList.get(i);
					pstmt.setInt(i+1, recNum);
				}
			}else if(master == 0) {
				sql = "select count(*) from (select * from recipe where num in (";
				sql += qms;
				sql	+= ") and status in (1, 2)) where status=2 or writer=?";
				pstmt = conn.prepareStatement(sql);
				for(int i = 0; i < rp; i++) {
					recNum = recList.get(i);
					pstmt.setInt(i+1, recNum);
				}
				pstmt.setString(rp+1, id);
			}else{
				sql = "select count(*) from recipe where num in (";
				sql += qms;
				sql += ") and status=2";
				pstmt = conn.prepareStatement(sql);
				for(int i = 0; i < rp; i++) {
					recNum = recList.get(i);
					pstmt.setInt(i+1, recNum);
				}
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
	
	// search로 검색 된 추천 레시피 게시판 한페이지에 보여줄 레시피 목록 반환
	public List <RecipeDTO>  getRecipes(List<Integer> recList, String search, int start, int end, int master, String id) {
		List<RecipeDTO> recipeList = null;
		int recNum = 0;
		int n = recList.size();
		String sql = "";
		String qms = "";
		for(int i = 0; i < n; i++) {
			if(qms.contains("?")){
				qms += ",";
			}
			qms += "?";
		}
			try {
					conn = ConnectionDAO.getConn();
					if(master == 2) {
						sql = "select * from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r from (select * from recipe where num in(";
						sql += qms;
						sql += ") and name like '%"+search+"%' and status in (1, 2) order by num desc)) where r >=? and r <=?";
						pstmt = conn.prepareStatement(sql);
						for(int i = 0; i < n; i++) {
							recNum = recList.get(i);
							pstmt.setInt(i+1, recNum);
						}
						pstmt.setInt(n+1, start);
						pstmt.setInt(n+2, end);
					}else if(master == 0) {
						sql = "select * from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r from (select * from recipe where num in (";
						sql += qms;
						sql += ") and name like '%"+search+"%' and status in (1, 2) order by num desc) where status=2 or writer=? order by num desc) where r >=? and r <=?";;
						pstmt = conn.prepareStatement(sql);
						for(int i = 0; i < n; i++) {
							recNum = recList.get(i);
							pstmt.setInt(i+1, recNum);
						}
						pstmt.setString(n+1, id);
						pstmt.setInt(n+2, start);
						pstmt.setInt(n+3, end);
					}else {
						sql = "select * from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r from (select * from recipe where num in(";
						sql += qms;
						sql	+= ") and name like '%"+search+"%' and status=2 order by num desc)) where r >=? and r <=?";
						pstmt = conn.prepareStatement(sql);
						for(int i = 0; i < n; i++) {
							recNum = recList.get(i);
							pstmt.setInt(i+1, recNum);
						}
						pstmt.setInt(n+1, start);
						pstmt.setInt(n+2, end);				
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

	// search로 검색 된 추천 레시피 권한별 작성된 글 수 반환
	public int getRecipeCount(List<Integer> recList, String search ,int master, String id) {
		String sql = "";
		String qms = "";
		int x = 0;
		int rp = recList.size();
		int recNum = 0;
		for(int i = 0; i < rp; i++) {
			if(qms.contains("?")) {
				qms+=",";
			}
			qms += "?";
		}						
		try {
			conn = ConnectionDAO.getConn();
			if(master == 2) {
				sql = "select count(*) from recipe where num in (";
				sql += qms;
				sql	+= ") and name like '%"+search+"%' and status in(1, 2)";
				pstmt = conn.prepareStatement(sql);
				for(int i = 0; i < rp; i++) {
					recNum = recList.get(i);
					pstmt.setInt(i+1, recNum);
				}
			}else if(master == 0) {
				sql = "select count(*) from (select * from recipe where num in (";
				sql += qms;
				sql	+= ") and name like '%"+search+"%' and status in (1, 2)) where status=2 or writer=?";
				pstmt = conn.prepareStatement(sql);
				for(int i = 0; i < rp; i++) {
					recNum = recList.get(i);
					pstmt.setInt(i+1, recNum);
				}
				pstmt.setString(rp+1, id);
			}else{
				sql = "select count(*) from recipe where num in (";
				sql += qms;
				sql += ") and name like '%"+search+"%' and status=2";
				pstmt = conn.prepareStatement(sql);
				for(int i = 0; i < rp; i++) {
					recNum = recList.get(i);
					pstmt.setInt(i+1, recNum);
				}
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
		System.out.println(sql);
		return x;
	}
		
	// search로 검색 된 추천 레시피 게시판 한페이지에 보여줄 레시피 목록 반환
	public List <RecipeDTO>  getRecipes(List<Integer> recList, String col, String search, int start, int end, int master, String id) {
		List<RecipeDTO> recipeList = null;
		int recNum = 0;
		int n = recList.size();
		String sql = "";
	String qms = "";
	for(int i = 0; i < n; i++) {
		if(qms.contains("?")){
	qms += ",";
	}
	qms += "?";
	}
		try {
				conn = ConnectionDAO.getConn();
				if(master == 2) {
					sql = "select * from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r from (select * from recipe where num in(";
		sql += qms;
		sql += ") and "+col+" like '%"+search+"%' and status in (1, 2) order by num desc)) where r >=? and r <=?";
		pstmt = conn.prepareStatement(sql);
		for(int i = 0; i < n; i++) {
			recNum = recList.get(i);
			pstmt.setInt(i+1, recNum);
		}
		pstmt.setInt(n+1, start);
		pstmt.setInt(n+2, end);
	}else if(master == 0) {
		sql = "select * from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r from (select * from recipe where num in (";
		sql += qms;
		sql += ") and "+col+" like '%"+search+"%' and status in (1, 2) order by num desc) where status=2 or writer=? order by num desc) where r >=? and r <=?";;
		pstmt = conn.prepareStatement(sql);
		for(int i = 0; i < n; i++) {
			recNum = recList.get(i);
			pstmt.setInt(i+1, recNum);
		}
		pstmt.setString(n+1, id);
		pstmt.setInt(n+2, start);
		pstmt.setInt(n+3, end);
	}else {
		sql = "select * from (select num, name, process, writer, difficulty, image, cooking_time, day, readcount, reccommend, status, rownum r from (select * from recipe where num in(";
		sql += qms;
		sql	+= ") and "+col+" like '%"+search+"%' and status=2 order by num desc)) where r >=? and r <=?";
		pstmt = conn.prepareStatement(sql);
		for(int i = 0; i < n; i++) {
			recNum = recList.get(i);
			pstmt.setInt(i+1, recNum);
		}
		pstmt.setInt(n+1, start);
		pstmt.setInt(n+2, end);				
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
	
	// search로 검색 된 추천 레시피 권한별 작성된 글 수 반환
	public int getRecipeCount(List<Integer> recList, String col, String search ,int master, String id) {
		String sql = "";
	String qms = "";
	int x = 0;
	int rp = recList.size();
	int recNum = 0;
	for(int i = 0; i < rp; i++) {
		if(qms.contains("?")) {
	qms+=",";
	}
	qms += "?";
	}						
	try {
		conn = ConnectionDAO.getConn();
		if(master == 2) {
			sql = "select count(*) from recipe where num in (";
	sql += qms;
	sql	+= ") and "+col+" like '%"+search+"%' and status in(1, 2)";
		pstmt = conn.prepareStatement(sql);
		for(int i = 0; i < rp; i++) {
			recNum = recList.get(i);
			pstmt.setInt(i+1, recNum);
		}
	}else if(master == 0) {
		sql = "select count(*) from (select * from recipe where num in (";
	sql += qms;
	sql	+= ") and "+col+" like '%"+search+"%' and status in (1, 2)) where status = 2 or writer = ?";
		pstmt = conn.prepareStatement(sql);
		for(int i = 0; i < rp; i++) {
			recNum = recList.get(i);
			pstmt.setInt(i+1, recNum);
		}
		pstmt.setString(rp+1, id);
	}else{
		sql = "select count(*) from recipe where num in (";
	sql += qms;
	sql += ") and "+col+" like '%"+search+"%' and status=2";
				pstmt = conn.prepareStatement(sql);
				for(int i = 0; i < rp; i++) {
					recNum = recList.get(i);
					pstmt.setInt(i+1, recNum);
				}
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
		System.out.println(sql);	
		return x;
	}
}
