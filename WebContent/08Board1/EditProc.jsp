<%@page import="model.BbsDAO"%>
<%@page import="model.BbsDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- 파일명 : EditProc.jsp -->

<%@ include file="../common/isLogin.jsp" %>
<%
//한글처리
request.setCharacterEncoding("UTF-8");

//폼값받기
String num = request.getParameter("num");
String title = request.getParameter("title");
String content = request.getParameter("content");

//DTO객체생성
BbsDTO dto = new BbsDTO();
dto.setNum(num); //특정게시물에 대한 수정이므로 일련번호가 추가되었다!
dto.setTitle(title);
dto.setContent(content);

//DAO객체생성
BbsDAO dao = new BbsDAO(application);

//수정 메소드 호출!
int affected = dao.updateEdit(dto);

if(affected==1)
{
	response.sendRedirect("BoardView.jsp?num=" + dto.getNum());
	//수정하기를 완료하면 BoardList가 아닌 BoardView로 간다!(상세보기 페이지로 이동)
}
else
{
%>
	<script>
		alert("수정하기에 실패하였습니다.");
		history.go(-1);
	</script>
<%
}
%>
