package member.bean;
import java.sql.Timestamp;

public class ScrapDTO {
	private int num; 			// �۹�ȣ&�����ǹ�ȣ
	private String name; 		// �丮��
	private String process; 	// �丮���
	private String writer; 		// �ۼ���
	private int difficulty; 	// �丮���̵�
	private String image;		// ����
	private int cooking_time;	// �丮�ð�
	private Timestamp day;		// �ۼ���¥
	private int readcount;		// ��ȸ��
	private int reccommend;		// ��õ��
	private int status;			// ���� : 0/ �̽��� : 1 / ���� : 2 / �α�� : 10
	
	
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
