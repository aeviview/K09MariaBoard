<%@page import="model.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <!-- 로그인 하기 위한 첫번째 Process! 각종 정보를 설정한다! -->
    
<%
//폼값 받기
String id = request.getParameter("user_id");
String pw = request.getParameter("user_pw");

//web.xml에 저장된 컨텍스트 "초기화 파라미터" 가져오기
//application.getInitParameter : 웹어플리케이션의 초기화 파라미터를 가져온다!
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MariaDBConnectURL");
String mid = application.getInitParameter("MariaUser");
String mpw = application.getInitParameter("MariaPass");

//DAO객체생성 및 DB연결 => ctrl+좌클릭해서 경로를 보고 알 수 있다~
MemberDAO dao = new MemberDAO(drv, url, mid, mpw);
//DAO(Data Access Object : DB를 사용해 데이터를 조회하거나 조작하는 것)

//폼값으로 받은 아이디, 패스워드를 통해 로그인 처리 함수를 호출한다
boolean isMember = dao.isMember(id, pw); 
/*
	해당 함수는 count()를 사용하므로
	로그인 시 사용한 아이디, 패스워드 외의 정보는 얻을 수 없다!
*/
if(isMember==true)
{
	//로그인 성공시 세션영역에 아래 속성을 저장한다
	session.setAttribute("USER_ID", id);
	session.setAttribute("USER_PW", pw);
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