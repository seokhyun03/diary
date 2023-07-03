<%@page import="java.time.Year"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	int targetYear = 0;
	int targetMonth = 0;
	// 요청값 유효성 검사
	if(request.getParameter("targetYear") == null || request.getParameter("targetMonth") == null) {	// targetYear이나 targetMonth이 null이면
		Calendar c = Calendar.getInstance();														// 현재 년, 월 대입
		targetYear = c.get(Calendar.YEAR);	
		targetMonth = c.get(Calendar.MONTH);
	} else {																						// targetYear이나 targetMonth이 null이 아니면 요청값 대입
		targetYear = Integer.parseInt(request.getParameter("targetYear"));	
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	// 디버깅(요청값 확인)
	System.out.println(targetYear + " <-- scheduleList parameter targetYear");
	System.out.println(targetMonth + " <-- scheduleList parameter targetMonth");
	
	// 오늘 날짜
	Calendar today = Calendar.getInstance();
	int todayDate = today.get(Calendar.DATE);
	// 디버깅(오늘 날짜 확인)
	System.out.println(todayDate + " <-- scheduleList todayDate");
	
	// targetMonth 1일의 요일
	Calendar firstDay = Calendar.getInstance();
	firstDay.set(Calendar.YEAR, targetYear);
	firstDay.set(Calendar.MONTH, targetMonth);
	firstDay.set(Calendar.DATE, 1);
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK);	// 일요일: 1 ~ 토요일: 7
	// 디버깅(1일 요일 확인)
	System.out.println(firstYoil + " <-- scheduleList firstYoil");
	
	// API 내부에서 바뀐 년/월 다시 저장
	targetYear = firstDay.get(Calendar.YEAR);	
	targetMonth = firstDay.get(Calendar.MONTH);
	// 디버깅(API 내부에서 바뀐 년/월 확인)
	System.out.println(targetYear + " <-- scheduleList change targetYear");
	System.out.println(targetMonth + " <-- scheduleList change targetMonth");
	
	// 1일 앞의 공백 수
	int startBlank = firstYoil - 1;
	// 디버깅(앞 공백 수 확인)
	System.out.println(startBlank + " <-- scheduleList startBlank");
	
	// targetMonth 마지막일;
	int lastDate = firstDay.getActualMaximum(Calendar.DATE);
	// 디버깅(마지막 일 확인)
	System.out.println(lastDate + " <-- scheduleList lastDate");
	
	// 전체 td의 개수는 7의 배수
	// 마지막 일 뒤의 공백 수
	int endBlank = 7 - ((startBlank + lastDate) % 7); 	// (startBlank + lastDate + endBlank) % 7 == 0
	// 디버깅(뒷 공백 수 확인)
	System.out.println(endBlank + " <-- scheduleList endBlank");
	
	// 전체 td의 개수
	int totalTd = startBlank + lastDate + endBlank;
	// 디버깅(전체 td의 개수 확인)
	System.out.println(totalTd + " <-- scheduleList totalTd");
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	// schedule 테이블에 schedule_date에 년 월이 target 년 월과 일치하는 데이터를 조회하는 sql 전송
	String sql = "select schedule_no scheduleNo, day(schedule_date) scheduleDate, substr(schedule_memo,1,5) scheduleMemo, schedule_color scheduleColor from schedule where year(schedule_date) = ? and month(schedule_date) = ? order by  month(schedule_date) asc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, targetYear); 	// 1번째 ? = targetYear
	stmt.setInt(2, targetMonth+1); 	// 2번째 ? = targetMonth+1
	// 전송한 sql 실행
	ResultSet rs = stmt.executeQuery();
	// ResultSet -> ArrayList<Schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate"); 
		s.scheduleMemo = rs.getString("scheduleMemo");
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);
	}
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<!-- 메인메뉴 -->
		<a href="./home.jsp">홈으로</a>
		<a href="./noticeList.jsp">공지 리스트</a>
		<a href="./scheduleList.jsp">일정 리스트</a>
		
		<h1><%=targetYear %>년 <%=targetMonth + 1 %>월</h1>
		<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>">이전달</a>
		<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>">다음달</a>
		<table class="table table-bordered">
			<tr>
				<th class="table-dark">일</th>
				<th class="table-dark">월</th>
				<th class="table-dark">화</th>
				<th class="table-dark">수</th>
				<th class="table-dark">목</th>
				<th class="table-dark">금</th>
				<th class="table-dark">토</th>
			</tr>
			<tr>
			<%
				for(int i=0; i<totalTd; i+=1) {
					int num = i - startBlank + 1;
					if(i%7 == 0){					// 7칸마다 줄 바꿈
			%>
						</tr><tr>
			<%	
					}
					String tdClass = "";
					if(num>0 && num<=lastDate) {						// 1일 부터 lastDate까지 출력						
						if(today.get(Calendar.YEAR) == targetYear 		// 오늘 날짜는 노란 배경으로 표시
						&& today.get(Calendar.MONTH) == targetMonth 
						&& today.get(Calendar.DATE) == num) {
							tdClass = "table-warning";			
						} else {
							tdClass = "";			
						}
			%>
					<td class="<%=tdClass %>">
					<div>
						<a href="./scheduleListByDate.jsp?y=<%=targetYear %>&m=<%=targetMonth %>&d=<%=num %>" class="text-body">
							<%=num %>
						</a>
					</div>
					<div>
					<%
							for(Schedule s : scheduleList) {
								if(num == Integer.parseInt(s.scheduleDate)){
					%>
									<div style="color: <%=s.scheduleColor%>">
											<%=s.scheduleMemo %>
									</div>
					<%
								}
							}
					%>
					</div>
					</td>
			<%
					} else {											// 아니면 공백
			%>
						<td>&nbsp;</td>
			<%				
					}
				}
			%>
			</tr>
		</table>
	</div>
</body>
</html>