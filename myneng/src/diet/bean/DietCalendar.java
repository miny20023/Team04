package diet.bean;

public class DietCalendar {
	
	//����=ture ���=false �����ϴ� �޼ҵ�
	public static boolean isLeapYear(int year) {	
		return year % 4 ==0 && year % 100 != 0 || year % 400 ==0;
	}
	
	
	//��, ���� �Է¹޾� ������ ��¥ �����ϴ� �޼ҵ�
	public static int lastDay(int year, int month) {
		int [] m = {31,28,31,30,31,30,31,31,30,31,30,31};
		//2����
		m[1] = isLeapYear(year)?29:28;
		return m[month-1]; //�迭 m�� 0���� �����ϱ� ������ -1�ʿ�
	}
	
	//??? 1�� 1�� 1�� ���� ������ ��¥�� �հ踦 ����� �����ϴ� �޼ҵ�
	public static int totalDay(int year, int month, int day) {
		int sum = (year-1)*365 + (year-1)/4 - (year -1)/100 + (year-1)/400; 
		//year-1 : �̹��⵵ ����,    ������ ��¥ 		����� ��¥ 		���⳯¥
		
		//������ �� �� ���ϱ�
		for (int i=1; i<month;i++) {
			sum+=lastDay(year,i);
			//1~month���� ���
		}
		return sum + day;
	}
	
	//������� �޾ƿ� ������ ���ڷ� �����ϴ� �޼ҵ�
	//��:0 ��:1 ȭ:2 ��:3 ��:4 ��:5 ��:6 ��:7
	public static int weekDay(int year, int month, int day) {
		return totalDay(year,month,day) %7;
	}
	
	
	
	
}
