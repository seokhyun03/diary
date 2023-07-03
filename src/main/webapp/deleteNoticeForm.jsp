<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 요청값 유효성 검사
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");
		return;
	}

	// 요청값 변수에 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	// 디버깅(요청값 확인)
	System.out.println(noticeNo + " <-- deleteNoticeForm param noticeNo");
	
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
	<h1>공지 삭제</h1>
	<form action="deleteNoticeAction.jsp" method="post">
		<table class="table table-bordered">
			<tr>
				<td class="table-dark">notice_no</td>
				<td>
					<!-- 게시글 번호 수정 X -->
					<!-- 페이지에 표시 X
					<input type="hidden" name="noticeNo" value="<%=noticeNo %>">
					 -->
					 <!-- 읽기만 가능 -->
					<input type="text" name="noticeNo" value="<%=noticeNo %>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="table-dark">notice_pw</td>
				<td>
					<input type="password" name="noticePw">
				</td>
			</tr>
		</table>
		<button type="submit">삭제</button>
	</form>
	</div>
</body>
</html>