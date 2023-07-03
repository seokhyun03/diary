<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>

<%
	// 요청값 유효성 검사
	if(request.getParameter("noticeNo") == null
		|| request.getParameter("noticePw") == null
		|| request.getParameter("noticeNo").equals("")
		|| request.getParameter("noticePw") .equals("")) {
		response.sendRedirect("./noticeList.jsp");
		return;
	}
	
	// 요청값 변수에 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	// 디버깅(요청값 저장 확인)
	System.out.println(noticeNo + " <-- deleteNoticeAction param noticeNo");
	System.out.println(noticePw + " <-- deleteNoticeAction param noticePw");
	
	// delete from notice where notice_no = ? and notice_pw = ?
			
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// db 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	// sql 전송
	String sql ="delete from notice where notice_no = ? and notice_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo); // 1번째 ? = startRow
	stmt.setString(2, noticePw);  // 2번째 ? = rowPerPage
	// 디버깅(sql 확인)
	System.out.println(stmt + " <--deleteNoticeAction sql");
	// sql 전송하여 실행 시 영향 받은 행의 수 
	int row = stmt.executeUpdate();
	// 디버깅(영향받은 행의 수 확인)
	System.out.println(row + " <-- deleteNoticeAction row");
	if(row == 0) { // 비밀번호가 틀려서 삭제행이 0행
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo="+noticeNo);
	} else {
		response.sendRedirect("./noticeList.jsp");
	}
%>