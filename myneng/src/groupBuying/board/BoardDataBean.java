package groupBuying.board;

import java.sql.Timestamp;

public class BoardDataBean 
{
	private int num; 
    private String writer;
    private String subject;
    private String email;
    private String content;
    private String passwd;
    private Timestamp reg_date;
    private int readcount;
    private String ip;
    private int pageNum;
    private String comment;
	
    public void setNum(int num){
    	this.num=num;
    }
    public void setWriter (String writer) {
        this.writer = writer;
    }
    public void setSubject (String subject) {
        this.subject = subject;
    }
    public void setEmail (String email) {
        this.email = email;
    }
    public void setContent (String content) {
        this.content = content;
    }
    public void setPasswd (String passwd) {
        this.passwd = passwd;
    }
    public void setReg_date (Timestamp reg_date) {
        this.reg_date = reg_date;
    }
	public void setReadcount(int readcount){
	  	this.readcount=readcount;
	}
    public void setIp (String ip) {
        this.ip = ip;
    }
    public void setPageNum(int pageNum)
    {
    	this.pageNum = pageNum;
    }
    public void setComment(String comment)
    {
    	this.comment = comment;
    }
    
    public int getNum(){
    	return num;
    }
    public int getReadcount(){
   	    return readcount;
    }
    public String getWriter () {
        return writer;
    }
    public String getSubject () {
        return subject;
    }
    public String getEmail () {
        return email;
    }
    public String getContent () {
        return content;
    }
    public String getPasswd () {
        return passwd;
    }
    public Timestamp getReg_date () {
        return reg_date;
    }
    public String getIp () {
        return ip;
    }
    public int getPageNum()
    {
    	return pageNum;
    }
    public String getComment()
    {
    	return comment;
    }
}
