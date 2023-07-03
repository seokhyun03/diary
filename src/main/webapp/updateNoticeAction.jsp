<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%
	if(request.getParameter("noticeNo") == null
		|| request.getParameter("noticeTitle").equals("")) {	// noticeNo null이거나 공백이면
		response.sendRedirect("./noticeList.jsp");	// redirection(NoticeList.jsp) NoticeList.jsp을 요청해라
		return; // 코드는 여기서 더 진행하지 않는다
	}
	// request 인코딩 설정
	request.setCharacterEncoding("utf-8");
	// 요청값 유효성 검사
	String msg = null;
	if(request.getParameter("noticeTitle") == null		// noticeTitle 값이 null이거나 공백일때
		|| request.getParameter("noticeTitle").equals("")) {
		msg = "noticeTitle is required";
	} else if(request.getParameter("noticePw") == null			// noticePw 값이 null이거나 공백일때
		|| request.getParameter("noticePw").equals("")) {
		msg = "noticePw is required";
	} else if(request.getParameter("noticeContent") == null		// noticeContent 값이 null이거나 공백일때
		|| request.getParameter("noticeContent").equals("")) {
		msg = "noticeContent is required";
	}
	
	if(msg != null) {
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="+request.getParameter("noticeNo")+"&msg="+msg);// redirection(upddateNoticeForm.jsp) upddateNoticeForm.jsp을 요청해라
		return; // 코드는 여기서 더 진행하지 않는다
	}

	// 요청값 변수에 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticeTitle = request.getParameter("noticeTitle");
	String noticePw = request.getParameter("noticePw");
	String noitceContent = request.getParameter("noticeContent");
	// 디버깅(요청값 확인)
	System.out.println(noticeNo + " <-- updateNoticeAction parameter noticeNo");
	System.out.println(noticeTitle + " <-- updateNoticeAction parameter noticeTitle");
	System.out.println(noticePw + " <-- updateNoticeAction parameter noticePw");
	System.out.println(noitceContent + " <-- updateNoticeAction parameter noitceContent");
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// db 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	// notice_no와 notice_pw가 일치하면 notice_title, notice_content, updatedate를 수정하는 sql 전송
	String sql = "update notice set notice_title=?, notice_content=?, updatedate=now() where notice_no=? and notice_pw=?"; 
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, noticeTitle); 	// 1번째 ? = noticeTitle
	stmt.setString(2, noitceContent); 	// 1번째 ? = noitceContent
	stmt.setInt(3, noticeNo); 			// 3번째 ? = noticeNo
	stmt.setString(4, noticePw); 		// 4번째 ? = noticePw
	// 디버깅(sql 확인)
	System.out.println(stmt + " <-- updateNoticeAction sql");
	
	// sql 전송하여 실행 시 영향 받은 행의 수 
	int row = stmt.executeUpdate();
	// 디버깅(영향받은 행의 수 확인)
	System.out.println(row + " <-- updateNoticeAction row");
	if(row > 1) {	// 1개의 행이 수정되어야하는데 1개 이상의 행이 수정 되면 코드 수정해야한다
		// update문을 실행을 취소(rollback)해야한다
		System.out.println("error row값 :"+ row);
	}
	if(row == 0) {															// 영향받은 행의 수가 0이면(notice_pw가 달라서 수정이 안되면)
		msg = "incurret noticePw";
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="+noticeNo+"&msg="+msg);	// updateNoticeForm.jsp로 가서 notice_pw를 다시 입력 받음
		return;
	} if(row > 1) {															// 1개의 행이 수정되어야하는데 1개 이상의 행이 수정 되면 코드 수정해야한다
		// update문을 실행을 취소(rollback)해야한다
		System.out.println("error row값 :"+ row);
	} else {																// 영향받은 행의 수가 0이 아니면 (수정되면)
		response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo);		// 수정된 noticeOne.jsp로 가라
	}
	
%>
