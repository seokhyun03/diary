<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	// 요청값 유효성 검사
	if(request.getParameter("y") == null										// y, m, d가 null이거나 공백이면			
		|| request.getParameter("m") == null
		|| request.getParameter("d") == null
		|| request.getParameter("y").equals("")
		|| request.getParameter("m").equals("")
		|| request.getParameter("d").equals("")) {
		response.sendRedirect("./scheduleList.jsp");							// scheduleList.jsp로 가고
		return;																	// 코드 종료
	}
	if(request.getParameter("scheduleNo") == null								// scheduleNo가 null이거나 공백이면
		|| request.getParameter("scheduleNo").equals("")) {
		int y = Integer.parseInt(request.getParameter("y"));
		int m = Integer.parseInt(request.getParameter("m"));
		int d = Integer.parseInt(request.getParameter("d"));
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d"+d);	// scheduleListByDate.jsp로 가고 
		return;																	// 코드 종료
	}
	// 요청값 변수에 저장
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	// 디버깅(오청값 확인)
	System.out.println(scheduleNo + " <-- updateScheduleForm parameter scheduleNo");
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	// schedule 테이블에 schedule_no 일치하는 데이터를 조회하는 sql 전송
	String sql = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, createdate, updatedate from schedule where schedule_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, scheduleNo); 	// 1번째 ? = scheduleNo
	// sql 디버깅
	System.out.println(stmt + " <-- updateScheduleForm sql");
	// 전송한 sql 실행하여 반환된 테이블
	ResultSet rs = stmt.executeQuery();
	// ResultSet -> ArrayList<Schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate");
		s.scheduleTime = rs.getString("scheduleTime");
		s.scheduleMemo = rs.getString("scheduleMemo");
		s.scheduleColor = rs.getString("scheduleColor");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
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
		<h1>스케줄 수정</h1>
		<%
			if(request.getParameter("msg") != null) {	// msg가 null이 아니면
		%> 
			<%=request.getParameter("msg") %>			<!-- msg 출력 --> 
		<%	
			}
		%>
		<form action="./updateScheduleAction.jsp" method="post">
			<table class="table table-bordered">
				<%
					for(Schedule s : scheduleList) {
				%>
					<tr>
					<th class="table-dark">schedule_date</th>
						<td>
							<input type="hidden" name="scheduleNo" value="<%=s.scheduleNo %>">
							<input type="date" name="scheduleDate" value="<%=s.scheduleDate %>">
						</td>
					</tr>
					<tr>
						<th class="table-dark">schedule_time</th>
						<td><input type="time" name="scheduleTime" value="<%=s.scheduleTime %>"></td>
					</tr>
					<tr>
						<th class="table-dark">schedule_pw</th>
						<td><input type="password" name="schedulePw"></td>
					</tr>
					<tr>
						<th class="table-dark">schedule_color</th>
						<td><input type="color" name="scheduleColor" value="<%=s.scheduleColor %>"></td>
					</tr>
					<tr>
						<th class="table-dark">schedule_memo</th>
						<td><textarea rows="10" cols="50" name="scheduleMemo"><%=s.scheduleMemo %></textarea></td>
					</tr>
				<%		
					}
				%>
			</table>
			<button type="submit">수정</button>
		</form>
	</div>
</body>
</html>