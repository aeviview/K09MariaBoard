<%@page import="util.JavascriptUtil"%>
<%@page import="model.BbsDAO"%>
<%@page import="model.BbsDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- 파일명 : DeleteProc.jsp --%>

<%@ include file="../common/isLogin.jsp" %>
<%
//한글처리 하지 않아도 상관없음(왜냐면 삭제만 할꺼니까요)
//request.setCharacterEncoding("UTF-8");

//폼값받기
String num = request.getParameter("num");

//DTO객체생성
BbsDTO dto = new BbsDTO();

//DAO객체생성
BbsDAO dao = new BbsDAO(application);

//상세보기에서 봤던 selectView함수를 호출한다!
//작성자 본인확인을 위해 기존 게시물의 내용을 가져온다
dto = dao.selectView(num);

//session 영역에 저장된 id값을 String형태로 가지고 온다!
String session_id = session.getAttribute("USER_ID").toString(); //방법1
//String session_id = (String)session.getAttribute("USER_ID");  //방법2
//위 아래 두개 둘 다 사용 가능하다! toString = (String)으로 형변환해도 사용가능하다^^

int affected = 0;

//작성자 본인이 맞는지 확인하는 if문
//DB에 입력된 작성자와 세션영역에 저장된 속성을 비교한다!
if(session_id.equals(dto.getId()))
{
	dto.setNum(num); //dto에 일련번호를 저장한 후..
	affected = dao.delete(dto); //delete 메소드를 호출한다!
}
else //작성자가 본인이 아닌경우!
{
	JavascriptUtil.jsAlertBack("본인만 삭제가능합니다.", out);
	return;
}

//실제로 삭제가 되었는지 확인하는 if문
if(affected==1)
{
	JavascriptUtil.jsAlertLocation("삭제되었습니다", "BoardList.jsp", out);
	//삭제 이후에는 기존 게시물이 사라지므로 리스트로 이동해서 삭제된 내역을 확인한다.
}
else
{
	out.println(JavascriptUtil.jsAlertBack("삭제 실패하였습니다"));
}
%>
