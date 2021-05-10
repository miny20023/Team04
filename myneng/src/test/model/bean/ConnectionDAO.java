package test.model.bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ConnectionDAO 
{	
	// Connection 1,2 �ܰ� �ϴ� �޼���
	public static Connection getConnection()
	{
		Connection conn = null;
		try						// jsp������ �ڵ����� ����ó���� ���༭ �������� ���⼱ �ؾ���.
		{
			Class.forName("oracle.jdbc.driver.OracleDriver");

			String dbHost = "jdbc:oracle:thin:@masternull.iptime.org:1521:orcl";
			String user = "java03";
			String pass = "java";
			conn = DriverManager.getConnection(dbHost, user, pass);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return conn;
	}
	
	// Connection�� �����ִ�(close()) ���ִ� �޼���
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
