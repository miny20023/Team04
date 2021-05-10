package test.model.bean;

// 파라미터를 저장 할 목적으로 사용
// request.getParameter 를 안쓰기 위해
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
		return age + "세";
	}
	public void setAge(String age) {
		//this.age = age;
		int a = Integer.parseInt(age);		// 유효성 검사.
		if(a > 0 && a <= 150)
		{
			this.age = age;
		}
	}
}
