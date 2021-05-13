package test.model.food;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ConnectionDAO {
	public static Connection getConn() {
		Connection conn = null;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			String dbHost = "jdbc:oracle:thin:@masternull.iptime.org:1521:orcl";
			String user = "team04", pass = "team";	
			conn = DriverManager.getConnection(dbHost, user, pass);
		}catch(Exception e) {
			e.printStackTrace();
		}
		return conn;
	}
	
	public static void close(ResultSet rs, PreparedStatement ps, Connection conn){
		if(rs!=null) {try {rs.close();}catch(SQLException s) {s.printStackTrace();}}
		if(ps!=null) {try {ps.close();}catch(SQLException s) {s.printStackTrace();}}
		if(conn!=null) {try {conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
}
