package test.model.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

public class EtcDAO 
{
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	public void insert(EtcDTO dto)
	{
		try
		{
			conn = ConnectionDAO.getConnection();
			String sql = "insert into etc values(?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getPhone());
			pstmt.setString(2, dto.getGender());
			pstmt.setString(3, dto.getHobby());
			pstmt.setString(4, dto.getDay());
			pstmt.setString(5, dto.getContent());
			
			pstmt.executeUpdate();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	public EtcDTO getEtc()
	{
		EtcDTO dto = null;
		try
		{
			conn = ConnectionDAO.getConnection();
			String sql = "select * from etc";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next())
			{
				dto = new EtcDTO();
				dto.setContent(rs.getString("content"));
				Timestamp d = rs.getTimestamp("day");			// 년 월 일 시 분 초 까지 다 나옴.
				String day = (d.getYear()+1900+"-"+(d.getMonth()+1)+"-"+d.getDate());	// 년 월 일 만 꺼내기
				dto.setDay(day);
				dto.setGender(rs.getString("gender"));
				dto.setPhone(rs.getString("phone"));
				dto.setCh(rs.getString("hobby").split("/"));
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			ConnectionDAO.close(rs, pstmt, conn);
		}
		return dto;
	}
}
