package dbConnectionDAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ConnectionDAO 
{	
	// Connection 1,2 단계 하는 메서드
	public static Connection getConnection()
	{
		Connection conn = null;
		try						
		{
			Class.forName("oracle.jdbc.driver.OracleDriver");

			String dbHost = "jdbc:oracle:thin:@masternull.iptime.org:1521:orcl";
			String user = "team04";					// 팀 DB ID로 변경
			String pass = "team";					// 팀 DB PW로 변경
			conn = DriverManager.getConnection(dbHost, user, pass);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return conn;
	}
	
	// Connection을 끊어주는(close()) 해주는 메서드
	public static void close(ResultSet rs, PreparedStatement pstmt, Connection conn)
	{
		if(rs != null)
		{
			try{rs.close();}catch(SQLException s){}
		}
		if(pstmt != null)
		{
			try {pstmt.close();}catch(SQLException s) {}
		}
		if(conn != null)
		{
			try {conn.close();}catch(SQLException s) {}
		}
		
	}
}