<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//요청값 유효성 검사
	String msg = null;
	if(request.getParameter("scheduleNo") == null									// 요청값 중 scheduleNo가 null이거나 공백이면
			|| request.getParameter("scheduleNo").equals("")) { 
		response.sendRedirect("./scheduleList.jsp");								// scheduleList.jsp로 가고
		return;																		// 코드 종료
	} else if(request.getParameter("scheduleDate") == null							// 요청값이 null이거나 공백이면			
		|| request.getParameter("scheduleTime") == null
		|| request.getParameter("schedulePw") == null
		|| request.getParameter("scheduleColor") == null
		|| request.getParameter("scheduleMemo") == null
		|| request.getParameter("scheduleDate").equals("")
		|| request.getParameter("scheduleTime").equals("")
		|| request.getParameter("schedulePw").equals("")
		|| request.getParameter("scheduleColor").equals("")
		|| request.getParameter("scheduleMemo").equals("")) {
		// 다시 요청받아야 할 값 메세지 저장
		if(request.getParameter("scheduleDate") == null								// scheduleDate 값이 null이거나 공백일때
				|| request.getParameter("scheduleDate").equals("")) {
				msg = "scheduleDate is required";
			} else if(request.getParameter("scheduleTime") == null					// scheduleTime 값이 null이거나 공백일때
				|| request.getParameter("scheduleTime").equals("")) {
				msg = "scheduleTime is required";
			} else if(request.getParameter("schedulePw") == null					// schedulePw 값이 null이거나 공백일때
				|| request.getParameter("schedulePw").equals("")) {
				msg = "schedulePw is required";
			} else if(request.getParameter("scheduleColor") == null					// schedulePw 값이 null이거나 공백일때
					|| request.getParameter("scheduleColor").equals("")) {
					msg = "scheduleColor is required";
			} else if(request.getParameter("scheduleMemo") == null					// schedulePw 값이 null이거나 공백일때
					|| request.getParameter("scheduleMemo").equals("")) {
				msg = "scheduleMemo is required";
			}
		int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));								// 값을 보낼 scheduleNo 변수 저장
		String scheduleDate = request.getParameter("scheduleDate");											// scheduleDate를 년월일 나눠서 변수 저장
		String y = null;
		int m = 0;
		String d = null;
		if(scheduleDate != "") {
			y = scheduleDate.substring(0, 4);
			m = Integer.parseInt(scheduleDate.substring(5, 7)) - 1;
			d = scheduleDate.substring(8);
		}
		
		System.out.println(scheduleNo + " <-- updateScheduleAction else if scheduleNo");					// 디버깅				
		System.out.println(scheduleDate + " <-- updateScheduleAction else if scheduleDate");
		System.out.println(y + " <-- updateScheduleAction else if y");
		System.out.println(m + " <-- updateScheduleAction else if m");
		System.out.println(d + " <-- updateScheduleAction else if d");
		
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="+scheduleNo+"&y="+y+"&m="+m+"&d="+d+"&msg="+msg); 	// updateScheduleForm.jsp로 가고
		return;																							  	// 코드 종료
	}

	//request 인코딩 설정
	request.setCharacterEncoding("utf-8");
	// 요청값 변수에 저장
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String schedulePw = request.getParameter("schedulePw");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String y = scheduleDate.substring(0, 4);
	int m = Integer.parseInt(scheduleDate.substring(5, 7)) - 1;
	String d = scheduleDate.substring(8);
	// 디버깅(요청값 확인)
	System.out.println(scheduleNo + " <-- updateScheduleAction parameter scheduleNo");
	System.out.println(scheduleDate + " <-- updateScheduleAction parameter scheduleDate");
	System.out.println(scheduleTime + " <-- updateScheduleAction parameter scheduleTime");
	System.out.println(schedulePw + " <-- updateScheduleAction parameter schedulePw");
	System.out.println(scheduleColor + " <-- updateScheduleAction parameter scheduleColor");
	System.out.println(scheduleMemo + " <-- updateScheduleAction parameter scheduleMemo");
	// 디버깅(년월일 확인)
	System.out.println(y + " <-- updateScheduleAction y");
	System.out.println(m + " <-- updateScheduleAction m");
	System.out.println(d + " <-- updateScheduleAction  d");
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	// schedule 테이블에 schedule_no 일치하는 데이터를 수정하는 sql 전송
	String sql = "update schedule set schedule_date=?, schedule_time=?, schedule_memo=?, schedule_color=?, updatedate=now() where schedule_no=? and schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, scheduleDate); 	// 1번째 ? = scheduleDate
	stmt.setString(2, scheduleTime); 	// 2번째 ? = scheduleTime
	stmt.setString(3, scheduleMemo); 	// 3번째 ? = scheduleMemo
	stmt.setString(4, scheduleColor); 	// 4번째 ? = scheduleColor
	stmt.setInt(5, scheduleNo); 		// 5번째 ? = scheduleNo
	stmt.setString(6, schedulePw); 		// 6번째 ? = schedulePw
	// 디버깅(sql 확인)
	System.out.println(stmt + " <-- updateScheduleAction sql");
	
	// sql 전송하여 실행 시 영향 받은 행의 수 
	int row = stmt.executeUpdate();
	// 디버깅(영향받은 행의 수 확인)
	System.out.println(row + " <-- updateScheduleAction row");
	if(row == 0) {																										// 영향받은 행의 수가 0이면(schedule_pw가 달라서 수정이 안되면)
		msg = "incurret schedulePw";
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="+scheduleNo+"&y="+y+"&m="+m+"&d="+d+"&msg="+msg);	// updateScheduleForm.jsp로 가서 schedule_pw를 다시 입력 받음
		return;
	} if(row > 1) {																										// 1개의 행이 수정되어야하는데 1개 이상의 행이 수정 되면 코드 수정해야한다
		// update문을 실행을 취소(rollback)해야한다
		System.out.println("error row값 :"+ row);
	} else {																											// 영향받은 행의 수가 0이 아니면 (수정되면)
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);											// 수정된 scheduleListByDate.jsp로 가라
	}
%>