<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
	
	<!-- 날짜순 최근 공지 5개 & 오늘 일정(전부) -->
	<%
		// select notice_no notice_title, createdate from notice order by createdate desc limit 0, 5;
		
		// 1) 드라이버 로딩
		Class.forName("org.mariadb.jdbc.Driver");
		// 2) db 접속
		Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
		// 최근 공지 5개
		// 3) sql 전송
		String sql1 = "select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit 0, 5";
		PreparedStatement stmt1 = conn.prepareStatement(sql1);
		// 3)을 디버깅
		System.out.println(stmt1 + " <--stmt1");
		// 4) sql 전송한 결과값 대입
		ResultSet rs1 = stmt1.executeQuery();
		ArrayList<Notice> noticeList = new ArrayList<Notice>();
		while(rs1.next()){
			Notice n = new Notice();
			n.noticeNo = rs1.getInt("noticeNo");
			n.noticeTitle = rs1.getString("noticeTitle");
			n.createdate = rs1.getString("createdate");
			noticeList.add(n);
		}
		
		// 오늘 일정 전부
		// 오늘 일정을 오늘 날짜, 시간, 메모(10자)을 시간 오름차순으로 표시하는 sql 전송
		String sql2 = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, substr(schedule_memo,1,10) scheduleMemo from schedule where schedule_date = curdate() order by schedule_time asc";
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		// 디버깅(sql 확인)
		System.out.println(stmt2 + " <--stmt2");
		// 전송한 sql 실행
		ResultSet rs2 = stmt2.executeQuery();
		// ResultSet -> ArrayList<Schedule> 
		ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
		while(rs2.next()){
			Schedule s = new Schedule();
			s.scheduleNo = rs2.getInt("scheduleNo");
			s.scheduleDate = rs2.getString("scheduleDate");
			s.scheduleTime = rs2.getString("scheduleTime"); 
			s.scheduleMemo = rs2.getString("scheduleMemo");
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
	<div class="container"><!-- 메인메뉴 -->
		<a href="./home.jsp">홈으로</a>
		<a href="./noticeList.jsp">공지 리스트</a>
		<a href="./scheduleList.jsp">일정 리스트</a>
	</div>
	<div class="container">
		<h1>공지사항</h1>
		<table class="table table-bordered">
			<tr>
				<th class="table-dark">notice_title</th>
				<th class="table-dark">createdate</th>
			</tr>
			<%
				for(Notice n : noticeList){
			%>
				<tr>
					<td>
						<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo %>">
							<%=n.noticeTitle %>
						</a>
					</td>
					<td><%=n.createdate.substring(0, 10) %></td>
				</tr>
			<%	
				}
			%>
		</table>
		
		<h1>오늘 일정</h1>
		<table class="table table-bordered">
			<tr>
				<th class="table-dark">schedule_date</th>
				<th class="table-dark">schedule_time</th>
				<th class="table-dark">schedule_memo</th>
			</tr>
			<%
				for(Schedule s : scheduleList){
			%>
				<tr>
					<td>	
						<%=s.scheduleDate %>
					</td>
					<td><%=s.scheduleTime %></td>
					<td>
						<a href="./scheduleOne.jsp?scheduleNo=<%=s.scheduleNo %>">
						<%=s.scheduleMemo %>
						</a>
					</td>
				</tr>
			<%	
				}
			%>
		</table>
	</div>
</body>
</html>