package diet.bean;

//import java.sql.Timestamp;

public class DietDTO {
		
	
	private String diet_date;
	private String breakfast;
	private String lunch;
	private String dinner;
	//private Timestamp diet_date
	private int year;
	private int month;
	private int day;
	
	private int date;

	
	/*
	if(diet_date !=null) {
		String [] date = diet_date.split("-");
		year = Integer.parseInt(date[0]);
		month =Integer.parseInt(date[1]);
		day = Integer.parseInt(date[2]);
	}
	 */
	
	public void setDate(String diet_date) {
		if(diet_date !=null) {
			String [] d = diet_date.split("-"); 
			String d_d = d[0]+d[1]+d[2];
			this.date = Integer.parseInt(d_d); 
		}
	}
	
	public int getDate() {return date;}
	
	public int getYear() {return year;}
	//public void setYear( int year) {this.year = year;}	
	public int getMonth() {	return month;	}
	//public void setMonth( int month) {this.month = month;}\
	public int getDay() {	return day;	}
	//public void setDay( int day) {this.day = day;}
		
	public void setYear(String diet_date) {
		if(diet_date !=null) {
			String [] date = diet_date.split("-");
			year = Integer.parseInt(date[0]);
		}
	}
	public void setMonth(String diet_date) {
		if(diet_date !=null) {
			String [] date = diet_date.split("-");
			month =Integer.parseInt(date[1]);
		}
	}public void setDay(String diet_date) {
		if(diet_date !=null) {
			String [] date = diet_date.split("-");
			day = Integer.parseInt(date[2]);	
		}
	}

	
	//public Timestamp getDiet_date() {return diet_date;}
	//public void setDiet_date(Timestamp diet_date) {this.diet_date = diet_date;}
	public String getDiet_date() {return diet_date;}
	public void setDiet_date(String diet_date) {this.diet_date = diet_date;}
	
	public String getBreakfast() {	return breakfast;	}
	public void setBreakfast(String breakfast) {this.breakfast = breakfast;	}
	public String getLunch() {	return lunch;	}
	public void setLunch(String lunch) {this.lunch = lunch;	}
	public String getDinner() {	return dinner;	}
	public void setDinner(String dinner) {this.dinner = dinner;	}
	


	
}
