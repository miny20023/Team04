package test.model.bean;

// �Ķ���͸� ���� �� �������� ���
// request.getParameter �� �Ⱦ��� ����
public class DataBean 
{
	private String id;
	private String pw;
	private String name;
	private String age;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}	
	public String getAge() {
		return age + "��";
	}
	public void setAge(String age) {
		//this.age = age;
		int a = Integer.parseInt(age);		// ��ȿ�� �˻�.
		if(a > 0 && a <= 150)
		{
			this.age = age;
		}
	}
}
