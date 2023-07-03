<%@page import="javax.print.attribute.HashPrintRequestAttributeSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	if(request.getParameter("noticeNo") == null){
		response.sendRedirect("./noticeList.jsp");
		return; // 1) 코드 진행 종료 2) 값을 반환
	}
		
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	// 1) 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 2) db 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	// 3) sql 전송
	String sql = "select notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate from notice where notice_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo); // 1번째 ?에 (int)noticeNo 대입
	// 3)을 디버깅
	System.out.println(stmt + " <--stmt");
	// 4) sql 전송한 결과값 대입
	ResultSet rs = stmt.executeQuery();
	// ResultSet -> ArrayList<Notice>
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()){
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.noticeContent = rs.getString("noticeContent");
		n.noticeWriter = rs.getString("noticeWriter");
		n.createdate = rs.getString("createdate");
		n.updatedate = rs.getString("updatedate");
		noticeList.add(n);
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

	
		<h1>공지 상세</h1>
	</div>
	<%
		for(Notice n : noticeList){
	%>
		<div class="container">
			<table class="table table-bordered">
				<tr>
					<td class="table-dark">notice_no</td>
					<td><%=n.noticeNo %></td>
				</tr>
				<tr>
					<td class="table-dark">notice_title</td>
					<td><%=n.noticeTitle %></td>
				</tr>
				<tr>
					<td class="table-dark">notice_content</td>
					<td><%=n.noticeContent %></td>
				</tr>
				<tr>
					<td class="table-dark">notice_writer</td>
					<td><%=n.noticeWriter %></td>
				</tr>
				<tr>
					<td class="table-dark">createdate</td>
					<td><%=n.createdate %></td>
				</tr>
				<tr>
					<td class="table-dark">updatedate</td>
					<td><%=n.updatedate %></td>
				</tr>
			</table>
		</div>
	<%	
		}
	%>
	<div class="container">
		<a href="./updateNoticeForm.jsp?noticeNo=<%=noticeNo %>">수정</a>
		<a href="./deleteNoticeForm.jsp?noticeNo=<%=noticeNo %>">삭제</a>
	</div>
</body>
</html>