<%@page import="model.MemberDAO"%>
<%@page import="model.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
//폼값 받기
String id = request.getParameter("user_id");
String pw = request.getParameter("user_pw");

//web.xml에 저장된 컨텍스트 초기화 파라미터 가져오기
String drv = application.getInitParameter("JDBCDriver");
String url = application.getInitParameter("ConnectionURL");

//DAO객체생성 및 DB연결 => ctrl+좌클릭해서 경로를 보고 알 수 있다~
MemberDAO dao = new MemberDAO(drv, url); 

/*
	연습문제] 작성용 교안에 있는 getMemberDTO()를
		MemberDAO 클래스에 작성한 후 아래 코드를 수정해서
		로그인 페이지에 회원의 이름이 출력되도록 해라 
*/
//폼값으로 받은 아이디, 패스워드를 통해 로그인 처리 함수를 호출한다
MemberDTO memberDTO = dao.getMemberDTO(id, pw); //(1)memberDTO 참조변수를 만든다

if(memberDTO.getId()!=null) //(2)if문 수정한다
{
	//로그인 성공시 세션영역에 아래 속성을 저장한다
	session.setAttribute("USER_ID", memberDTO.getId());
	session.setAttribute("USER_PW", memberDTO.getPass());
	session.setAttribute("USER_NAME", memberDTO.getName());	
	//로그인 페이지로 이동한다
	response.sendRedirect("Login.jsp");
}
else
{
	//로그인 실패시 리퀘스트 영역에 속성을 저장 한 후 로그인 페이지로 포워드한다
	request.setAttribute("ERROR_MSG", "넌 회원이 아니시군 ㅡㅡ");
	request.getRequestDispatcher("Login.jsp").forward(request, response);
}
%>