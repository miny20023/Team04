package member.bean;

public class ValueCheck {

	
	//���̵���: 4���̻�  	
	//��й�ȣ ��� : 8���̻�, ����+����
	//�̸� ��� : 2��~20�� 

	
	public boolean charLength(String str, int min) {
		//boolean result =false;
		//if(size >=s && size <=e) {
			//result = true;}
		return (str.length() >= min);
	}
	
	
	public boolean charNum(String str) {//���� 48-57 �Էµ� ���� �������� �Ǻ�
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
	
	
	
	
	//��ȭ��ȣ : ���ڸ� ������
	public boolean numCheck(String str) {//���� 48-57 �Էµ� ���� �������� �Ǻ�
		int x=0;
		for(int i =0; i<str.length();i++) {
			char s = str.charAt(i);
			if(s >=48&& s<=57) {
				x++;
			}
		}return (x==str.length());
	}
	
	
	
	
	
	
}
