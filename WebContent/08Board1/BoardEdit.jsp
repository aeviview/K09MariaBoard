<%@page import="util.JavascriptUtil"%>
<%@page import="model.BbsDTO"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- BoardEdit는 글작성 페이지 진입 전 로그인 체크해야한다! --%>
<%@ include file="../common/isLogin.jsp" %>

<%
 //파라미터로 전송된 게시물의 일련번호를 받음
 String num = request.getParameter("num");
 BbsDAO dao = new BbsDAO(application);
 
 //원래 조회수 업데이트도 있었는데 필요없으니깐 삭제한다
 
 //일련번호에 해당하는 게시물을 DTO객체로 반환한다
 BbsDTO dto = dao.selectView(num);
 
 //본인확인 후 작성자가 아니면 뒤로 보내기!
 if(!session.getAttribute("USER_ID").toString().equals(dto.getId()))
 {
	 JavascriptUtil.jsAlertBack("작성자 본인만 수정 가능해요오오오옹", out);
	 return;
 }
 
 dao.close();
 %>

<!DOCTYPE html>
<html lang="en">
<!-- 긴 코드를 잘라내기 위해 include를 사용한다! -->
<jsp:include page="../common/boardHead.jsp" />
<body>
<div class="container">
	<div class="row">		
		<jsp:include page="../common/boardTop.jsp" />
	</div>
	<div class="row">		
		<jsp:include page="../common/boardLeft.jsp" />
		<div class="col-9 pt-3">
		
		<!-- ########## 게시판의 body 부분 start ########## -->
			<h3>게시판 - <small>Edit(글수정하기)</small></h3>
			
			<script>
			/*
				연습문제] 글쓰기 폼에 빈값이 있는 경우
				서버로 전송되지 않도록 아래 validate()함수를 완성하시오.
				모든 값이 입력되었다면 WriteProc.jsp로 submit되어야 한다. (06Session Login.jsp참조)
			*/	
			function checkValidate(fm)
			{
				if(fm.title.value=="")
				{
					alert("제목을 입력하세요");
					fm.title.focus();
					return false;
				}
				
				if(fm.content.value=="")
				{
					alert("내용을 입력하세요");
					fm.content.focus();
					return false;
				}
			}
			</script>
			
			<div class="row mt-3 mr-1">
				<table class="table table-bordered table-striped">
				<!-- 회원제 게시판이므로 post방식이 맞다 -->
				<form name="writeFrm" method="post" action="EditProc.jsp" 
					onsubmit="return checkValidate(this);">
				<!-- DB에서 null값이면 오류가 나기 때문에 checkValidate(this)를 통해서 폼을 확인한다 -->
				
				<!-- 
					해당 게시물의 일련번호를 전송해야지 수정이 가능하다.
					hidden속성으로 처리하면 화면에서는 숨김처리되지만,
					서버로는 값을 전송할 수 있다.
					또한 update의 특성으로 이해할 수도 있다.
					update 테이블 set 컬럼=값 => where절이 없다면 모든게시물에 대한 수정이 된다!
				 -->
				<input type="hidden" name="num" value="<%=num %>" />
				<!-- hidden을 hid-den이라 바꾸면 실제로 웹사이트에 히든창이 보인다 -->
				<!-- 히든창에 나오는 번호랑 웹사이트 주소에 나오는 num값이 일치해야 한다!-->
				
				<colgroup>
					<col width="20%"/>
					<col width="*"/>
				</colgroup>
				<tbody>
<!-- 					<tr> -->
<!-- 						<th class="text-center align-middle">작성자</th> -->
<!-- 						<td> -->
<!-- 							<input type="text" class="form-control"	style="width:100px;"/> -->
<!-- 						</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<th class="text-center"  -->
<!-- 							style="vertical-align:middle;">패스워드</th> -->
<!-- 						<td> -->
<!-- 							<input type="password" class="form-control" -->
<!-- 								style="width:200px;"/> -->
<!-- 						</td> -->
<!-- 					</tr> -->
					<tr>
						<th class="text-center"
							style="vertical-align:middle;">제목</th>
						<td>
							<input type="text" class="form-control" 
								name="title" value="<%=dto.getTitle() %>" />
						</td>
					</tr>
					<tr>
						<th class="text-center"
							style="vertical-align:middle;">내용</th>
						<td>
							<!-- textarea는 못생겼어도 그대로 둔다! 정렬시키면 공백 엄청생김 -->
							<textarea rows="10" 
								class="form-control" name="content"><%=dto.getContent() %></textarea>
						</td>
					</tr>
<!-- 					<tr> -->
<!-- 						<th class="text-center" -->
<!-- 							style="vertical-align:middle;">첨부파일</th> -->
<!-- 						<td> -->
<!-- 							<input type="file" class="form-control" /> -->
<!-- 						</td> -->
<!-- 					</tr> -->
				</tbody>
				</table>
			</div>
			<div class="row mb-3">
				<div class="col text-right">
					<!-- 각종 버튼 부분 -->
					<button type="submit" class="btn btn-danger">전송하기</button>
					<button type="reset" class="btn btn-dark">Reset</button>
					<button type="button" class="btn btn-warning" onclick="location.href='BoardList.jsp';">리스트보기</button>
				</div>
				</form>
			</div>
		<!-- ########## 게시판의 body 부분 end ########## -->
		</div>
	</div>
	<div class="row border border-dark border-bottom-0 border-right-0 border-left-0"></div>
	<jsp:include page="../common/boardBottom.jsp" />

</div>
</body>
</html>