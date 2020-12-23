<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//속성을 개별적으로 삭제
	//session.removeAttribute(속성명) => 세션 개체의 특정 속성을 삭제할 때 사용!
	session.removeAttribute("USER_ID");
	session.removeAttribute("USER_PW");
	
	session.invalidate(); //세션영역 전체를 한꺼번에 삭제
	
	response.sendRedirect("Login.jsp");
	//sendRedirect : 페이지 이동을 위한 메서드
	//response.sendRedirect : 응답 정보를 저장하고 페이지를 이동한다!
%>