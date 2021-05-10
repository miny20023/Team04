package member.bean;

public class MemberDTO {
	private String id;
	private String name;
	private String pw;
	private String pwr;

	private String email;
	private String phone;
	private String ph1;
	private String ph2;
	private String ph3;
	private String address;
	
	private String group_id;
	private String scrap_id;
	
	
	
	private String cart_id;
	private String diet_id;

	private String group_pw;
	

	public String getDiet_id() {
		return diet_id;
	}

	public void setDiet_id(String id) {
		this.diet_id = id+"_diet";
	}
	
	public String getGroup_pw() {
		return group_pw;
	}
	
	public void setGroup_pw(String group_pw) {
		this.group_pw = group_pw;

	}
	
	public String getGroup_id() {
		return group_id;
	}
	
	public void setGroup_id(String id) {
		this.group_id = id+"_refrigerator";
	}
	public String getScrap_id() {
		return scrap_id;
	}
	public void setScrap_id(String id) {
		this.scrap_id = id+"_scrap";
	}
	public String getCart_id() {
		return cart_id;
	}
	public void setCart_id(String id) {
		this.cart_id = id+"_cart";
	}
	
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	public String getPwr() {
		return pwr;
	}
	public void setPwr(String pwr) {
		this.pwr = pwr;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhone() {
		return this.ph1+"-"+this.ph2+"-"+this.ph3;
	}
	public void setPhone(String phone) {
		if(phone !=null) {
			String [] ph = phone.split("-");//phone을 -기준으로 잘라서 배열로 저장한다.
			ph1 = ph[0];
			ph2 = ph[1];
			ph3 = ph[2];
		}	
	}	
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}

	public String getPh1() {
		return ph1;
	}
	public String getPh2() {
		return ph2;
	}
	public String getPh3() {
		return ph3;
	}
	
	public void setPh1(String ph1) {
		this.ph1 = ph1;
	}
	
	public void setPh2(String ph2) {
		this.ph2 = ph2;
	}
	public void setPh3(String ph3) {
		this.ph3 = ph3;
	}
	
	
}
