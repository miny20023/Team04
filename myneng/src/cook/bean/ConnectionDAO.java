package cook.bean;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;

public class ConnectionDAO {
	public static Connection getConnection() {
		Connection conn = null;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			String dbHost = "jdbc:oracle:thin:@masternull.iptime.org:1521:orcl";
			String user = "team04";
			String pass = "team";
			conn = DriverManager.getConnection(dbHost, user, pass);
		}catch(Exception e) {
			e.printStackTrace();
		}
		return conn;
	}
	
	public static void close(ResultSet rs, PreparedStatement pstmt, Connection conn) {
		if(rs != null) { try {rs.close();} catch(SQLException s) {s.printStackTrace();}}
		if(pstmt != null) { try{pstmt.close();} catch(SQLException s) {s.printStackTrace();}}
		if(conn != null) {try{conn.close();} catch(SQLException s) {s.printStackTrace();}}
	}
}