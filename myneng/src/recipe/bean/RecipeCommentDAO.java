package recipe.bean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RecipeCommentDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	// 레시피 작성시 해당레시피 번호로 댓글테이블 생성
	public void createCommentTable(int num) {
		try {
			conn = ConnectionDAO.getConnection();
			String sql = "create sequence recipe_comment_"+num+"_seq nocycle nocache";
			pstmt = conn.prepareStatement(sql);
			pstmt.executeUpdate();
			
			sql = "create table recipe_comment_"+num+" (comment_num number primary key,"
					+ "comment_id varchar2(100),comment_text varchar2(4000),reg_date date, num number,"
					+ "ref number, re_step number, re_level number)";
			pstmt = conn.prepareStatement(sql);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	// 댓글 입력
	public void insertRecipeComment(RecipeCommentDTO recipeComment) {
		try {
			conn = ConnectionDAO.getConnection();
			String tableName = "recipe_comment_"+recipeComment.getNum(); 	// 댓글테이블 이름
			String sql = "insert into "+tableName+" values("+tableName+"_seq.NEXTVAL,?,?,?,?,"+tableName+"_seq.CURRVAL,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, recipeComment.getComment_id());
			pstmt.setString(2, recipeComment.getComment_text());
			pstmt.setTimestamp(3, recipeComment.getReg_date());
			pstmt.setInt(4, recipeComment.getNum());
			pstmt.setInt(5, recipeComment.getRe_step());
			pstmt.setInt(6, recipeComment.getRe_level());
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	// 대댓글 입력
	public void insertRecipeComment(RecipeCommentDTO recipeComment, int comment_num) {
		try {
			String sql = "";
			String tableName = "recipe_comment_"+recipeComment.getNum(); 	// 댓글테이블 이름
			int ref = 0;
			int re_step = 0;
			int re_level = 0;
			
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("select * from "+tableName+" where comment_num=?");
			pstmt.setInt(1, comment_num);
			rs = pstmt.executeQuery();
			if(rs.next()) {	 			// 대댓글 작성
				ref = rs.getInt("ref");
				re_step = rs.getInt("re_step");
				re_level = rs.getInt("re_level");
				
				if(ref == 0) {			// 새로둔 대댓글인 경우
					pstmt = conn.prepareStatement("select max(re_step) from "+tableName+" where ref=?");
					pstmt.setInt(1, ref);
					rs = pstmt.executeQuery();
					if(rs.next()) {
						re_step = rs.getInt(1) + 1;
					}
				}else {					// 기존 대댓글의 대댓글인 경우
					sql = "update "+tableName+" set re_step=re_step+1 where ref=? and re_step > ?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, ref);
					pstmt.setInt(2, re_step);
					pstmt.executeUpdate();
					re_step = re_step + 1;
				}
			}
			
			sql = "insert into "+tableName+" values("+tableName+"_seq.NEXTVAL,?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, recipeComment.getComment_id());
			pstmt.setString(2, recipeComment.getComment_text());
			pstmt.setTimestamp(3, recipeComment.getReg_date());
			pstmt.setInt(4, recipeComment.getNum());
			pstmt.setInt(5, ref);
			pstmt.setInt(6, re_step);
			pstmt.setInt(7, re_level + 1);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	// 댓글 리스트 반환
	public List getRecipeComments(int start, int end, int num) {
		List recipeCommentList = new ArrayList(end);
		String tableName = "recipe_comment_"+num;
		String seqName = tableName+"_seq";
		try {
			conn = ConnectionDAO.getConnection();
			String sql = "select comment_num, comment_id, comment_text, reg_date, ref, re_step, re_level, r "
					+ "from (select comment_num, comment_id, comment_text, reg_date, ref, re_step, re_level, rownum r "
					+ "from (select * from "+tableName+" order by ref asc, re_step asc) order by ref asc, re_step asc) where r>=? and r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				RecipeCommentDTO recipeComment = new RecipeCommentDTO();
				recipeComment.setComment_id(rs.getString("comment_id"));
				recipeComment.setComment_text(rs.getString("comment_text"));
				recipeComment.setReg_date(rs.getTimestamp("reg_date"));
				recipeComment.setRe_level(rs.getInt("re_level"));
				recipeComment.setComment_num(rs.getInt("comment_num"));
				recipeCommentList.add(recipeComment);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return recipeCommentList;
	}
	
	// 댓글 수 반환
	public int getRecipeCommentCount(int num) {
		int count = 0;
		try {
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("select count(*) from recipe_comment_"+num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				count = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return count;
	}
	
	// 댓글 삭제시 '삭제된 댓글입니다'로 내용 변경
	public boolean deleteRecipeComment(int num, int comment_num) {
		String tableName = "recipe_comment_"+num;
		boolean result = false;
		try {
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("update "+tableName+" set comment_text='삭제된 댓글입니다.' where comment_num=?");
			pstmt.setInt(1, comment_num);
			pstmt.executeUpdate();
			result = true;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return result;
	}
	
	// 댓글 작성자 반환
	public String getRecipeComment_id(int num, int comment_num) {
		String comment_id = null;
		String tableName = "recipe_comment_"+num;
		try {
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("select comment_id from "+tableName+" where comment_num=?");
			pstmt.setInt(1, comment_num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				comment_id = rs.getString("comment_id");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return comment_id;
	}
}
