<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// 캐릭터 인코딩 utf-8로 설정
	request.setCharacterEncoding("utf-8");
	//요청값 유효성 검사
	if(request.getParameter("scheduleDate") == null							// 요청값 중 scheduleDate가 null이거나 공백이면
			|| request.getParameter("scheduleDate").equals("")) {
		response.sendRedirect("./scheduleList.jsp");								// scheduleList.jsp로 가고
		return;																		// 코드 종료
	}else if(request.getParameter("scheduleTime") == null									// 요청값이 null이거나 공백이면			
		|| request.getParameter("scheduleColor") == null
		|| request.getParameter("scheduleMemo") == null
		|| request.getParameter("schedulePw") == null
		|| request.getParameter("scheduleTime").equals("")
		|| request.getParameter("scheduleColor").equals("")
		|| request.getParameter("scheduleMemo").equals("")
		|| request.getParameter("schedulePw").equals("")) {
		String scheduleDate = request.getParameter("scheduleDate");
		String y = scheduleDate.substring(0, 4);
		int m = Integer.parseInt(scheduleDate.substring(5, 7)) - 1;
		String d = scheduleDate.substring(8);
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);		// scheduleList.jsp로 가고
		return;																		// 코드 종료
	}
	// 요청값 변수에 저장
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	// 디버깅(요청값 확인)
	System.out.println(scheduleDate + " <-- insertScheduleAction parameter scheduleDate");
	System.out.println(scheduleTime + " <-- insertScheduleAction parameter scheduleTime");
	System.out.println(scheduleColor + " <-- insertScheduleAction parameter scheduleColor");
	System.out.println(scheduleMemo + " <-- insertScheduleAction parameter scheduleMemo");
	System.out.println(schedulePw + " <-- insertScheduleAction parameter schedulePw");
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	// schedule 테이블에 새로운 데이터를 삽입하는 sql 전송
	String sql = "insert into schedule(schedule_date, schedule_time, schedule_memo, schedule_color, createdate, updatedate, schedule_pw) values(?,?,?,?,now(),now(),?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, scheduleDate); 	// 1번째 ? = scheduleDate
	stmt.setString(2, scheduleTime); 	// 2번째 ? = scheduleTime
	stmt.setString(3, scheduleMemo); 	// 3번째 ? = scheduleMemo
	stmt.setString(4, scheduleColor); 	// 4번째 ? = scheduleColor
	stmt.setString(5, schedulePw); 		// 5번째 ? = schedulePw
	// sql 디버깅
	System.out.println(stmt + " <-- insertScheduleAction stmt");
	// sql 전송하여 실행시 영향 받은 행의 수
	int row = stmt.executeUpdate();		// 디버깅 : 1(ex:2)이면 1행(ex:2행) 입력성공, 0이면 입력된 행이 없다
	// row값을 이용한 디버깅
	System.out.println(row + " <-- insertScheduleAction row");
	
	// 년, 월, 일 쪼개서 변수에 저장
	String y = scheduleDate.substring(0, 4);
	int m = Integer.parseInt(scheduleDate.substring(5, 7)) - 1;
	String d = scheduleDate.substring(8);
	// 디버깅(년, 월, 일 확인)
	System.out.println(y + " <-- insertScheduleAction y");
	System.out.println(m + " <-- insertScheduleAction m");
	System.out.println(d + " <-- insertScheduleAction d");
	// scheduleListByDate.jsp로 년, 월, 일 데이터 가지고 가라
	response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
%>