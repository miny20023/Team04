package cartBoardComment;

import java.sql.*;
import java.util.*;
import dbConnectionDAO.ConnectionDAO;
import cartBoardComment.CommentDataBean;

public class CommentDBBean 
{
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	public void insertArticle_comment(CommentDataBean article, int comment_listNum) throws Exception {
		String sql="";
		try {
			if(comment_listNum == 0)
			{
			String tableNum = "comment_"+article.getNum();
			// table명 자리에 ? 넣고 pstmt로 받으면 ' 이게 들어가서 테이블명 부적합나옴
			sql = "insert into "+tableNum+" values("+tableNum+"_seq.NEXTVAL,?,?,?,?,"+tableNum+"_seq.CURRVAL,?,?)";
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, article.getComment_id());
			pstmt.setString(2, article.getComment_text());
			pstmt.setTimestamp(3, article.getReg_date());
			pstmt.setInt(4, article.getNum());
			//pstmt.setInt(5, article.getRef());
			pstmt.setInt(5, article.getRe_step());
			pstmt.setInt(6, article.getRe_level());
			pstmt.executeUpdate();
			}
			else
			{
				conn = ConnectionDAO.getConnection();
				String tableNum = "comment_"+article.getNum();
				//sql = "select "+tableNum+"_seq,ref,re_step,re_level,rownum from "+tableNum+" where rownum ="+comment_listNum;
				sql = "select comment_id,comment_text,reg_date,ref,re_step,re_level,r "
						+"from (select comment_id,comment_text,reg_date,ref,re_step,re_level,rownum r "
							     +"from (select comment_id,comment_text,reg_date,ref,re_step,re_level "
							            +"from "+tableNum+" order by ref asc, re_step asc) order by ref asc, re_step asc ) "
							+"where r="+comment_listNum;
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				int dbRef = 0;
				int dbRe_step =0;
				int dbRe_level = 0;
				int insertRe_step=0;
				int maxRe_step=0;
				if(rs.next())
				{
					dbRef = rs.getInt("ref");
					dbRe_step = rs.getInt("re_step");
					dbRe_level = rs.getInt("re_level");
					System.out.println(dbRe_step);
					sql = "select MAX(re_step) from "+tableNum+" where ref = "+dbRef;
					pstmt = conn.prepareStatement(sql);
					rs = pstmt.executeQuery();
					if(rs.next())
					{
						maxRe_step = rs.getInt("MAX(re_step)");
					}
					
					if(dbRe_step == 0)
					{
						insertRe_step = maxRe_step+1;
					}
					else
					{
						sql = "update "+tableNum+" set re_step=re_step+1 where ref="+dbRef+"and Re_step > ?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setInt(1, dbRe_step);
						pstmt.executeUpdate();
						insertRe_step = dbRe_step+1;
					}
				}
				
				// table명 자리에 ? 넣고 pstmt로 받으면 ' 이게 들어가서 테이블명 부적합나옴
				sql = "insert into "+tableNum+" values("+tableNum+"_seq.NEXTVAL,?,?,?,?,?,?,?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, article.getComment_id());
				pstmt.setString(2, article.getComment_text());
				pstmt.setTimestamp(3, article.getReg_date());
				pstmt.setInt(4, article.getNum());
				pstmt.setInt(5, dbRef);
				pstmt.setInt(6, insertRe_step);
				pstmt.setInt(7, dbRe_level+1);
				pstmt.executeUpdate();
			}
			
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	public int deleteArticle_comment(int num,int listNum, String id) throws Exception
	{
		int x = -1;
		String seqName = "comment_"+num+"_seq";
		String tableName = "comment_"+num;
		try 
		{
			conn = ConnectionDAO.getConnection();
			String sql = "select "+seqName+",comment_id,comment_text,reg_date,ref,re_step,re_level,r "
					+"from (select "+seqName+",comment_id,comment_text,reg_date,ref,re_step,re_level,rownum r "
				     +"from (select "+seqName+",comment_id,comment_text,reg_date,ref,re_step,re_level "
				            +"from "+tableName+" order by ref asc, re_step asc) order by ref asc, re_step asc ) "
				+"where r="+listNum;
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			int dbRef = 0;
			int dbRe_step = 0;
			if(rs.next())
			{
				dbRef = rs.getInt("ref");
				dbRe_step = rs.getInt("re_step");
				System.out.println(dbRef +""+ dbRe_step);
				
				sql = "delete from "+tableName+" where ref = "+dbRef+" and re_step="+dbRe_step;
				pstmt = conn.prepareStatement(sql);
				pstmt.executeUpdate();
				x = 1;
			}
			else 
			{
				x = 0;
			}
			/*while(rs.next() && x != 1)
			{
				String dbId = rs.getString("comment_id");
				int rowNum = rs.getInt("rownum");
				int seqNum = rs.getInt(seqName);
				if(dbId.equals(id) && rowNum == listNum)
				{
					sql="delete from "+tableName+" where "+seqName+"="+seqNum;
					pstmt = conn.prepareStatement(sql);
					pstmt.executeUpdate();
					x = 1;
				}
				else
				{
					x = 0;
				}
			}*/
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally
		{
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return x;
	}
	
	
	public int getArticleCount_comment(int tableNum) throws Exception
	{
		int y = 0;
		int x = 0;
		String sql ="";
		String tableName = "comment_"+tableNum;
		String seqName = tableName+"_seq";
		String searchTable = "COMMENT_"+tableNum;
		try
		{
			conn = ConnectionDAO.getConnection();
			pstmt = conn.prepareStatement("select count(*) from all_tables where table_name= ?");
			pstmt.setString(1,searchTable);
			rs = pstmt.executeQuery();
			if(rs.next())
			{
				y = rs.getInt(1);
			}
			
			if(y != 1)
			{
				int count = 0;
				sql = "create sequence "+tableName+"_seq nocycle nocache";
				pstmt = conn.prepareStatement(sql);
				pstmt.executeUpdate();
				count = 1;
				if(count == 1)
				{
					sql = "create table "+tableName+" ("+seqName+" number primary key,comment_id varchar2(100),comment_text varchar2(4000),reg_date date,num number, ref number, re_step number, re_level number)";
					pstmt = conn.prepareStatement(sql);
					pstmt.executeUpdate();
				}
			}
			pstmt = conn.prepareStatement("select count(*) from "+tableName);
			rs = pstmt.executeQuery();
			if(rs.next())
			{
				x = rs.getInt(1);
			}
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally
		{
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return x;
	}
	
	public List getArticles(int start,int end,int tableNum ) throws Exception
	{
		List articleList=null;
		String tableName = "comment_"+tableNum;
		try
		{
			conn = ConnectionDAO.getConnection();
			String sql = "select comment_id,comment_text,reg_date,ref,re_step,re_level,r "+
					"from (select comment_id,comment_text,reg_date,ref,re_step,re_level,rownum r " +
					"from (select comment_id,comment_text,reg_date,ref,re_step,re_level " +
					"from "+tableName+" order by ref asc, re_step asc) order by ref asc, re_step asc ) where r >= ? and r <= ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			
			rs = pstmt.executeQuery();

			if(rs.next())
			{
				articleList = new ArrayList(end);
				do
				{
					CommentDataBean article = new CommentDataBean();
					article.setComment_id(rs.getString("comment_id"));
					article.setComment_text(rs.getString("comment_text"));
					article.setReg_date(rs.getTimestamp("reg_date"));
					article.setRe_level(rs.getInt("re_level"));
					articleList.add(article);
				}
				while(rs.next());
			}
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally
		{
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return articleList;
	}
}
