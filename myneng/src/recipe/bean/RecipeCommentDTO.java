package recipe.bean;
import java.sql.Timestamp;

public class RecipeCommentDTO {
	private int comment_num;		// 댓글 번호
	private int num;				// 레시피 번호
	private String comment_id;
	private String comment_text;
	private Timestamp reg_date;
	private int ref;
	private int re_step;
	private int re_level;
	
	public void setComment_num(int comment_num) {	this.comment_num = comment_num;	}
	public void setNum(int num) {	this.num = num;	}
	public void setComment_id(String comment_id) {	this.comment_id = comment_id;	}
	public void setComment_text(String comment_text) {	this.comment_text = comment_text;	}
	public void setReg_date(Timestamp reg_date) {	this.reg_date = reg_date;	}
	public void setRef(int ref) {	this.ref = ref;	}
	public void setRe_step(int re_step) {	this.re_step = re_step;	}
	public void setRe_level(int re_level) {	this.re_level = re_level;	}
	
	public int getComment_num() {	return comment_num;	}
	public int getNum() {	return num;	}
	public String getComment_id() {	return comment_id;	}
	public String getComment_text() {	return comment_text;	}
	public Timestamp getReg_date() {	return reg_date;	}
	public int getRef() {	return ref;	}
	public int getRe_step() {	return re_step;	}
	public int getRe_level() {	return re_level;	}
}
