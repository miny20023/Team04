package test.model.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

// Connection 3,4 단계 하는 클래스
public class EmpDAO 
{
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	// insert하는 메서드
	public void insert(EmpDTO emp)
	{
		try
		{
			conn = ConnectionDAO.getConnection();
			String sql = "insert into emp values(?,?,?,?,sysdate,?,?,?)";
			pstmt = conn.prepareStatement(sql);									// 3단계
			pstmt.setInt(1,Integer.parseInt(emp.getEmpno()));
			pstmt.setString(2,emp.getEname());
			pstmt.setString(3,emp.getJob());
			pstmt.setInt(4,Integer.parseInt(emp.getMgr()));
			//pstmt.setString(5,emp.getHiredate());
			pstmt.setInt(5,Integer.parseInt(emp.getSal()));
			pstmt.setInt(6,Integer.parseInt(emp.getComm()));
			pstmt.setInt(7, Integer.parseInt(emp.getDeptno()));
			pstmt.executeUpdate();												// 4단계 실행
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			// 작업 마친 후 close()
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	// select 하는 메서드
	public ArrayList<EmpDTO> select()
	{
		ArrayList<EmpDTO> list = null;
		try
		{
			conn = ConnectionDAO.getConnection();
			String sql = "select * from emp";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			list = new ArrayList<EmpDTO>();
			while(rs.next())
			{
				// DTO에 하나하나 집어 넣어야하기 때문에 반복문 안에 선언한다.
				EmpDTO emp = new EmpDTO();
				emp.setEmpno(rs.getInt("empno")+"");		// 다 String 타입으로 넣어야하기 때문에 뒤에 ""를 넣어서 String 값으로 만든다.
				emp.setEname(rs.getString("ename"));
				emp.setJob(rs.getString("job"));
				emp.setHiredate(rs.getTimestamp("hiredate").toString());
				emp.setMgr(rs.getInt("mgr")+"");
				emp.setComm(rs.getString("comm"));
				emp.setSal(rs.getInt("sal")+"");
				emp.setDeptno(rs.getInt("deptno")+"");
				list.add(emp);
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
		return list;
	}
}
