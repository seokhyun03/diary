<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 요청값 유효성 검사
	if(request.getParameter("noticeNo") == null				// 파라미터가 null이거나
		|| request.getParameter("noticeNo").equals("")) {	// 공백일 때
		response.sendRedirect("./noticeList.jsp");			// redirection(noticeList.jsp) noticeList.jsp을 요청해라
		return; // 1) 코드 진행 종료 2) 값을 반환	
	}
	
	// 요청값 변수에 저장
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
	<title>updateNoticeForm.jsp</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<h1>공지 수정</h1>
		<%
			if(request.getParameter("msg") != null) {
		%>
			<%=request.getParameter("msg") %>
		<%	
			}
		%>
		<form action="./updateNoticeAction.jsp" method="post">
			<table class="table table-bordered">
			<%
				for(Notice n : noticeList){
			%>
				<tr>
					<td class="table-dark">notice_no</td>
					<td>
						<input type="number" name="noticeNo" readonly="readonly" value="<%=n.noticeNo %>">
					</td>
				</tr>
				<tr>
					<td class="table-dark">notice_pw</td>
					<td>
						<input type="password" name="noticePw">
					</td>
				</tr>
				<tr>
					<td class="table-dark">notice_title</td>
					<td>
						<input type="text" name="noticeTitle" value="<%=n.noticeTitle %>">
					</td>
				</tr>
				<tr>
					<td class="table-dark">notice_content</td>
					<td>
						<textarea rows="5" cols="80" name="noticeContent"><%=n.noticeContent %></textarea>
					</td>
				</tr>
				<tr>
					<td class="table-dark">notice_writer</td>
					<td>
						<%=n.noticeWriter %>
					</td>
				</tr>
				<tr>
					<td class="table-dark">createdate</td>
					<td>
						<%=n.createdate %>
					</td>
				</tr>
				<tr>
					<td class="table-dark">updatedate</td>
					<td>
						<%=n.updatedate %>
					</td>
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