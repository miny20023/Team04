package diet.bean;

public class DietCalendar {
	
	//윤년=ture 평달=false 구분하는 메소드
	public static boolean isLeapYear(int year) {	
		return year % 4 ==0 && year % 100 != 0 || year % 400 ==0;
	}
	
	
	//년, 월을 입력받아 마지막 날짜 리턴하는 메소드
	public static int lastDay(int year, int month) {
		int [] m = {31,28,31,30,31,30,31,31,30,31,30,31};
		//2월달
		m[1] = isLeapYear(year)?29:28;
		return m[month-1]; //배열 m은 0부터 시작하기 때문에 -1필요
	}
	
	//??? 1년 1월 1일 부터 지나온 날짜의 합계를 계산해 리턴하는 메소드
	public static int totalDay(int year, int month, int day) {
		int sum = (year-1)*365 + (year-1)/4 - (year -1)/100 + (year-1)/400; 
		//year-1 : 이번년도 빼기,    윤년의 날짜 		평년의 날짜 		윤년날짜
		
		//지나온 달 수 더하기
		for (int i=1; i<month;i++) {
			sum+=lastDay(year,i);
			//1~month까지 출력
		}
		return sum + day;
	}
	
	//년월일을 받아와 요일을 숫자로 리턴하는 메소드
	//일:0 월:1 화:2 수:3 목:4 금:5 토:6 일:7
	public static int weekDay(int year, int month, int day) {
		return totalDay(year,month,day) %7;
	}
	
	
	
	
}
