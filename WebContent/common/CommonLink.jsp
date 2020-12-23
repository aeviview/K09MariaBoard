<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CommonLink.jsp</title>
</head>
<body>
	<h2>공통링크</h2>
	<table border="1" width="90%">
		<tr>
			<td>
				<% 
				if(session.getAttribute("USER_ID")==null) //USER_ID가 null값 = 로그인 전 뜬다
				{ %>
					<a href="../06Session/Login.jsp">로그인</a> <%
				} 
				else //로그인 한 후에 "로그아웃" a태그가 뜬다
				{ %>
					<a href="../06Session/Logout.jsp">로그아웃</a> <%
				} %>
				&nbsp&nbsp&nbsp
				<a href="../08Board1/BoardList.jsp">회원제게시판1[PageX]</a>
				&nbsp&nbsp&nbsp
				<a href="../08Board2/BoardList.jsp">회원제게시판2[PageO]</a>
				&nbsp&nbsp&nbsp
				<a href="../DataRoom/DataList">자료실(Mode12)</a>
			</td>
		</tr>
	</table>
</body>
</html>