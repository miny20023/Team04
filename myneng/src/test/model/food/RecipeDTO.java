package test.model.food;
import java.sql.Timestamp;

public class RecipeDTO {
	private int num; 			// 글번호&레시피번호
	private String name; 		// 요리명
	private String process; 	// 요리방법
	private String writer; 		// 작성자
	private int difficulty; 	// 요리난이도
	private String image;		// 사진
	private int cooking_time;	// 요리시간
	private Timestamp day;		// 작성날짜
	private int readcount;		// 조회수
	private int reccommend;		// 추천수
	private int status;			// 삭제 : 0/ 미승인 : 1 / 승인 : 2 / 인기글 : 10
	
	
	public void setNum(int num) {	this.num = num;	}
	public void setName(String name) {	this.name = name;	}
	public void setProcess(String process) {	this.process = process;	}
	public void setWriter(String writer) {	this.writer = writer;	}
	public void setDifficulty(int difficulty) {	this.difficulty = difficulty;	}
	public void setImage(String image) {	this.image = image;	}
	public void setCooking_time(int cooking_time) {	this.cooking_time = cooking_time;	}
	public void setDay(Timestamp day) {	this.day = day;	}
	public void setReadcount(int readcount) {	this.readcount = readcount;	}
	public void setReccommend(int reccommend) {	this.reccommend = reccommend;	}
	public void setStatus(int status) {	this.status = status;	}
	
	public int getNum() {	return num;	}
	public String getName() {	return name;	}
	public String getProcess() {	return process;	}
	public String getWriter() {	return writer;	}
	public int getDifficulty() {	return difficulty;	}
	public String getImage() {	return image;	}
	public int getCooking_time() {	return cooking_time;	}
	public Timestamp getDay() {	return day;	}
	public int getReadcount() {	return readcount;	}
	public int getReccommend() {	return reccommend;	}
	public int getStatus() {	return status;	}
	
}
