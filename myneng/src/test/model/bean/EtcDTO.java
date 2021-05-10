package test.model.bean;

public class EtcDTO 
{
	private String ph1;
	private String ph2;
	private String ph3;
	private String ph4;
	private String gender;
	private String [] ch;
	private String day;
	private String content;
	
	public String getPh1() {
		return ph1;
	}
	public void setPh1(String ph1) {
		this.ph1 = ph1;
	}
	public String getPh2() {
		return ph2;
	}
	public void setPh2(String ph2) {
		this.ph2 = ph2;
	}
	public String getPh3() {
		return ph3;
	}
	public void setPh3(String ph3) {
		this.ph3 = ph3;
	}
	public String getPh4() {
		return ph4;
	}
	public void setPh4(String ph4) {
		this.ph4 = ph4;
	}
	// ph1,ph2,ph3,ph4 변수를 모두 연결 후 리턴
	public String getPhone()
	{
		return getPh1()+"-"+getPh2()+"-"+getPh3()+"-"+getPh4();
		// return this.ph1+"-"+this.ph2+"-"+this.ph3+"-"+this.ph4;
	}
	public void setPhone(String phone)
	{
		if(phone != null)
		{
			String [] ph = phone.split("-");
			ph1 = ph[0];
			ph2 = ph[1];
			ph3 = ph[2];
			ph4 = ph[3];
		}
	}
	
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String[] getCh() {
		return ch;
	}
	public void setCh(String[] ch) {
		this.ch = ch;
	}
	public String getDay() {
		return day;
	}
	
	public String getHobby()
	{
		String hobby = "";
		for(String c : ch)
		{
			hobby += c+"/";
		}
		return hobby;
	}
	
	public void setDay(String day) {
		this.day = day;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}


}