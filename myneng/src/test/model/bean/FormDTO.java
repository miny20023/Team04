package test.model.bean;

public class FormDTO 
{
	private String address;
	private String gender;
	
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		if(gender.equals("man") || gender.equals("woman"))
		{
			this.gender = gender;
		}
	}
	
	
}
