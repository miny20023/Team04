package member.bean;

public class ValueCheck {

	
	//아이디양식: 4자이상  	
	//비밀번호 양식 : 8자이상, 숫자+영어
	//이름 양식 : 2자~20자 

	
	public boolean charLength(String str, int min) {
		//boolean result =false;
		//if(size >=s && size <=e) {
			//result = true;}
		return (str.length() >= min);
	}
	
	
	public boolean charNum(String str) {//숫자 48-57 입력된 값이 숫지인지 판별
		boolean result = false;
		int x=0;
		for(int i =0; i<str.length();i++) {
			char s = str.charAt(i);
			if(s >=48&& s<=57) {
				result = true;
			}
		}return result;
	}
	

	public boolean charEng(String str) {//44032-55203
		boolean result = false;
		for(int i =0; i <str.length(); i++) {
			char s = str.charAt(i);
			if( s >=65 && s<=122) {
				result = true;
			}
		}	
		return result;
	}
	
	
	
	
	//전화번호 : 숫자만 들어갔는지
	public boolean numCheck(String str) {//숫자 48-57 입력된 값이 숫지인지 판별
		int x=0;
		for(int i =0; i<str.length();i++) {
			char s = str.charAt(i);
			if(s >=48&& s<=57) {
				x++;
			}
		}return (x==str.length());
	}
	
	
	
	
	
	
}
