<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	// 요청값 유효성 검사
	if(request.getParameter("y") == null						// 요청값이 null이거나 공백이면			
		|| request.getParameter("m") == null
		|| request.getParameter("d") == null
		|| request.getParameter("y").equals("")
		|| request.getParameter("m").equals("")
		|| request.getParameter("d").equals("")) {
		response.sendRedirect("./scheduleList.jsp");			// scheduleList.jsp로 가고
		return;													// 코드 종료
	}
	// 요청값 변수에 저장
	int y = Integer.parseInt(request.getParameter("y"));
	int m = Integer.parseInt(request.getParameter("m")) + 1;	// 1 ~ 12월 <-- mariadb에서는 0 ~ 11로 표시
	int d = Integer.parseInt(request.getParameter("d"));
	// 디버깅(요청값 확인)
	System.out.println(y + " <-- scheduleListByDate parameter y");
	System.out.println(m + " <-- scheduleListByDate parameter m");
	System.out.println(d + " <-- scheduleListByDate parameter d");
	
	// 월, 일이 10보다 작을시 앞에 0을 붙여 두자리로 만들기
	String strM = "" + m;
	if(m<10) {
		strM = "0" + m;
	}
	String strD = "" + d;
	if(d<10) {
		strD = "0" + d;
	}
	// yyyy-mm-dd 
	String scheduleDate =  y + "-" + strM + "-" + strD;
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	// schedule 테이블에 scheduleDate가 일치하는 데이터를 조회하는 sql 전송
	String sql = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, createdate, updatedate from schedule where schedule_date = ? order by schedule_time asc;";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, scheduleDate); 	// 1번째 ? = scheduleDate
	// 전송한 sql 실행
	ResultSet rs = stmt.executeQuery();
	// ResultSet -> ArrayList<Schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate");
		s.scheduleTime = rs.getString("scheduleTime");
		s.scheduleMemo = rs.getString("scheduleMemo");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		scheduleList.add(s);
	}
			
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>scheduleListByDate</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<h1>스케줄 입력</h1>
		<form action="./insertScheduleAction.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<th class="table-dark">schedule_date</th>
					<td><input type="date" name="scheduleDate" value="<%=scheduleDate %>" readonly="readonly"></td>
				</tr>
				<tr>
					<th class="table-dark">schedule_time</th>
					<td><input type="time" name="scheduleTime"></td>
				</tr>
				<tr>
					<th class="table-dark">schedule_pw</th>
					<td><input type="password" name="schedulePw"></td>
				</tr>
				<tr>
					<th class="table-dark">schedule_color</th>
					<td><input type="color" name="scheduleColor" value="#000000"></td>
				</tr>
				<tr>
					<th class="table-dark">schedule_memo</th>
					<td><textarea rows="10" cols="50" name="scheduleMemo"></textarea></td>
				</tr>
			</table>
			<button type="submit">등록</button>
		</form>
		<h1><%=y %>년 <%=m %>월 <%=d %>일 스케줄 목록</h1>
		<table class="table table-bordered">
			<tr>
				<th class="table-dark">schedule_time</th>
				<th class="table-dark">schedule_memo</th>
				<th class="table-dark">createdate</th>
				<th class="table-dark">updatedate</th>
				<th class="table-dark">수정</th>
				<th class="table-dark">삭제</th>
			</tr>
			<%
				for(Schedule s : scheduleList){
			%>
				<tr>
					<td>	
						<%=s.scheduleTime %>
					</td>
					<td>
						<%=s.scheduleMemo %>
					</td>
					<td>
						<%=s.createdate %>
					</td>
					<td>
						<%=s.updatedate %>
					</td>
					<td>
						<a href="./updateScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>&y=<%=y %>&m=<%=m %>&d=<%=d %>">수정</a>
					</td>
					<td>
						<a href="./deleteScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>&y=<%=y %>&m=<%=m %>&d=<%=d %>">삭제</a>
					</td>
				</tr>
			<%	
				}
			%>
		</table>
	</div>
</body>
</html>