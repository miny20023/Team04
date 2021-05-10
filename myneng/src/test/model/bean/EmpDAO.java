package test.model.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

// Connection 3,4 �ܰ� �ϴ� Ŭ����
public class EmpDAO 
{
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	// insert�ϴ� �޼���
	public void insert(EmpDTO emp)
	{
		try
		{
			conn = ConnectionDAO.getConnection();
			String sql = "insert into emp values(?,?,?,?,sysdate,?,?,?)";
			pstmt = conn.prepareStatement(sql);									// 3�ܰ�
			pstmt.setInt(1,Integer.parseInt(emp.getEmpno()));
			pstmt.setString(2,emp.getEname());
			pstmt.setString(3,emp.getJob());
			pstmt.setInt(4,Integer.parseInt(emp.getMgr()));
			//pstmt.setString(5,emp.getHiredate());
			pstmt.setInt(5,Integer.parseInt(emp.getSal()));
			pstmt.setInt(6,Integer.parseInt(emp.getComm()));
			pstmt.setInt(7, Integer.parseInt(emp.getDeptno()));
			pstmt.executeUpdate();												// 4�ܰ� ����
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			// �۾� ��ģ �� close()
			ConnectionDAO.close(rs, pstmt, conn);
		}
	}
	
	// select �ϴ� �޼���
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
				// DTO�� �ϳ��ϳ� ���� �־���ϱ� ������ �ݺ��� �ȿ� �����Ѵ�.
				EmpDTO emp = new EmpDTO();
				emp.setEmpno(rs.getInt("empno")+"");		// �� String Ÿ������ �־���ϱ� ������ �ڿ� ""�� �־ String ������ �����.
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
