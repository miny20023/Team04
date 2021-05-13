package cook.bean;

public class CookDTO {
	private int rec_id; // 레시피 번호
	private int ing_id; // 재료 번호
	private String amount;
	private String unit;
	private String ing_name;
	
	public void setRec_id(int rec_id) {	this.rec_id = rec_id;	}
	public void setIng_id(String ing_name) {	
		CookDAO dao = new CookDAO();
		int ing_id = dao.getIng_id(ing_name);
		this.ing_id = ing_id;	
	}
	public void setAmount(String amount) {	this.amount = amount;	}
	public void setUnit(String unit) {	this.unit = unit;	}
	public void setIng_name(String ing_name) {	
		setIng_id(ing_name);
		this.ing_name = ing_name;	
	}
	
	public int getRec_id() {	return rec_id;	}
	public int getIng_id() {	return ing_id;	}
	public String getAmount() {	return amount;	}
	public String getUnit()	{	return unit;	}
	public String getIng_name() {	return ing_name;	}
}
