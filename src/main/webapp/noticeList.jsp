<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>

<%
	// 요청 분석(currentPage, ...)
	// 현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 디버깅
	System.out.println(currentPage + "<--currentPage"); 
	// 페이지당 출력 행의 수
	int rowPerPage = 10;
	// 시작 행 번호
	int startRow = 0 + (currentPage-1) * rowPerPage;
	/*
		currentPage		startrow(rowPerPage가 10일때)
		1				0	<-- (currentPage-1) * rowPerPage
		2				10
		3				20
		4				30
	*/
	//int startRow = 0; // 1page일때만 startRow가 0
	
	
	// DB연결
	// select notice_no notice_title, createdate from notice order by createdate desc limit ?, ?;

	// 1) 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 2) db 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	// 3) sql 전송
	PreparedStatement stmt = conn.prepareStatement("select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit ?, ?");
	// select notice_no notice_title, createdate from notice order by createdate desc limit ?, ? 에서 ?값 대입
	stmt.setInt(1, startRow); // 1번째 ? = startRow
	stmt.setInt(2, rowPerPage);  // 2번째 ? = rowPerPage
	// 3)을 디버깅
	System.out.println(stmt + " <--stmt");
	// 4) 출력할 공지 데이터 (sql 전송한 결과값)
	ResultSet rs = stmt.executeQuery();
	// 자료구조 ResultSet타입을 일반적인 자료구조타입(자바 배열 or 기본 API 자료구조타입 List, Set, Map)
	// ResultSet -> ArrayList<Notice>
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()){
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.createdate = rs.getString("createdate");
		noticeList.add(n);
	}
	
	//마지막 페이지
	// select count(*) from notice
	PreparedStatement stmt2 = conn.prepareStatement("select count(*) from notice");
	ResultSet rs2 = stmt2.executeQuery();
	int totalRow = 0; // SELECT COUNT(*) FROM notice;
	if(rs2.next()){
		totalRow = rs2.getInt("count(*)");
	}
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0){
		lastPage = lastPage + 1;
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
	
	<h1>공지사항 리스트</h1>
	<a href="./insertNoticeForm.jsp">공지입력</a>
	</div>
	
	<!-- 날짜순 최근 공지 5개 -->
	<div class="container">
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
		<%
			if(currentPage > 1) {
		%>
				<a href="./noticeList.jsp?currentPage=<%=currentPage-1%>">이전</a>
		<%	
			}
		%>
			<%=currentPage%>
		<%
			if(currentPage < lastPage){
		%>
				<a href="./noticeList.jsp?currentPage=<%=currentPage+1%>">다음</a>
		<%	
			}
		%>
	</div>
</body>
</html>