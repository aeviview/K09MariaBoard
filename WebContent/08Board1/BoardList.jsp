<%@page import="util.PagingUtil"%>
<%@page import="model.BbsDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
request.setCharacterEncoding("UTF-8"); //한글처리한다!

//web.xml에 설정된 초기화 파라미터를 가져온다(이미 지정되어 있는 내용이다)
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MariaDBConnectURL");
String mid = application.getInitParameter("MariaUser");
String mpw = application.getInitParameter("MariaPass");

//bbs : Bulletin Board System 으로 전자게시판이라는 뜻이다 
BbsDAO dao = new BbsDAO(drv, url, mid , mpw); //DAO객체생성 및 DB커넥션!

//커넥션풀(DBCP)을 이용한 DB연결
//BbsDAO dao = new BbsDAO();

/*
	파라미터를 저장할 용도로 생성한 Map컬렉션.
	여러개의 파라미터를 한꺼번에 저장한 후 DAO의 메소드를 호출할 때 전달.
	Map은 반드시 있을 필요는 없지만 없으면 귀찮은 일이 생긴다
		=> 차후 프로그램 업데이트에 의해 파라미터가 추가되더라도 Map을 사용하면 편하다!
*/
Map<String, Object> param = new HashMap<String, Object>();
		
//Get방식으로 전달되는 폼값을 페이지 번호로 넘겨주기 위해 문자열로 저장
String queryStr = ""; //queryStr 변수 생성!

//검색어가 입력된 경우 전송된 폼값을 받아 Map에 저장한다
String searchColumn = request.getParameter("searchColumn");
String searchWord = request.getParameter("searchWord");

/*
	리스트 페이지에 최초 진입시에는 파라미터가 없으므로
	if로 구분하여 파라미터가 있을때만 Map에 추가한다.
*/
if(searchWord!=null)
{
	param.put("Column", searchColumn);
	param.put("Word", searchWord);
	
	//검색어가 있을 때 쿼리스트링(queryStr)을 만들어준다
	queryStr += "searchColumn="+searchColumn+"&searchWord="+searchWord+"&";
}

//board테이블에 입력된 전체 레코드 갯수를 카운트하여 반환한다.
//int totalRecordCount = dao.getTotalRecordCount(param); //join X
int totalRecordCount = dao.getTotalRecordCountSearch(param); //join O (작성자이름 검색가능)

/******************** 페이지 처리를 위한 코드 추가 start ********************/
//한 페이지에 출력할 레코드의 갯수 : 10
int pageSize =
	Integer.parseInt(application.getInitParameter("PAGE_SIZE"));
//한 블럭당 출력할 페이지번호의 갯수 : 5
int blockPage =
	Integer.parseInt(application.getInitParameter("BLOCK_PAGE"));

//ceil : 무조건 올림처리!
/*
	전체 페이지 수 계산 : 게시물이 108개라 가정하면 108/10(페이지수) = 10.8
											ceil(10.8) => 11페이지가 된다!
*/
int totalPage = (int)Math.ceil((double)totalRecordCount/pageSize);

/*
	현재페이지번호(nowPage) : 파라미터가 없을 때는 무조건 1페이지로 지정하고,
					값이 있을 때는 해당값을 얻어와서 숫자로 변경한다.
					즉, 리스트에 처음 진입했을 때는 1페이지가 된다.
*/
int nowPage = (request.getParameter("nowPage")==null
				|| request.getParameter("nowPage").equals(""))
				? 1 : Integer.parseInt(request.getParameter("nowPage"));

//현재페이지에 출력할 게시물의 범위를 결정한다. MariaDB에서 LIMIT를 사용하므로 계산식이 조금 달라진다!
int start = (nowPage-1)*pageSize; 	//(nowPage-1)*pageSize + 1;
int end = pageSize; 				//nowPage * pageSize;

//map컬렉션에 게시물의 범위(start랑 end)를 저장하고 DAO로 전달할 준비를 한다! 
param.put("start", start);
param.put("end", end);
/******************** 페이지 처리를 위한 코드 추가 end ********************/

//board테이블의 레코드를 select하여 결과셋을 List컬렉션으로 반환한다.
//List<BbsDTO> bbs = dao.selectList(param); //페이지처리X
//List<BbsDTO> bbs = dao.selectListPage(param); //페이지처리O
List<BbsDTO> bbs = dao.selectListPageSearch(param); //페이지처리O + 회원이름검색O

//DB자원해제
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
			<h3>게시판 - <small>이런저런 기능이 있는 게시판입니다.</small></h3>
			<div class="row">
				<!-- 검색부분 -->
				<form class="form-inline ml-auto">	
					<div class="form-group">
						<select name="searchColumn" class="form-control">
							<!-- 검색부분이 null값이 아니고 title이라면 selected 한다라는 뜻(밑에 표현식) -->
							<option value="title"
								<%=(searchColumn!=null && searchColumn.equals("title")) ? "selected" : "" %>>
							제목</option>
							<option value="content"
								<%=(searchColumn!=null && searchColumn.equals("content")) ? "selected" : "" %>>
							내용</option>
							<option value="name"
								<%=(searchColumn!=null && searchColumn.equals("name")) ? "selected" : "" %>>
							작성자</option>
						</select>
					</div>
					<div class="input-group">
						<input type="text" name="searchWord" class="form-control"/>
						<div class="input-group-btn">
							<button type="submit" class="btn btn-warning">
								<i class='fa fa-search' style='font-size:20px'></i>
							</button>
						</div>
					</div>
				</form>	
			</div>
			<div class="row mt-3">
				<!-- 게시판리스트부분 -->
				<table class="table table-bordered table-hover table-striped">
				<colgroup>
					<col width="60px"/>
					<col width="*"/>
					<col width="150px"/>
					<col width="120px"/>
					<col width="80px"/>
					<col width="60px"/>
				</colgroup>				
				
				<thead>
				<tr style="background-color: rgb(133, 133, 133); " class="text-center text-white">
					<th width="10%">번호</th>
						<th width="50%">제목</th>
						<th width="15%">작성자</th>
						<th width="15%">작성일</th>
						<th width="10%">조회수</th>
					<!-- <th>첨부</th> -->
				</tr>
				</thead>
				<tbody>				
				
				<%
				/*
					List컬렉션에 입력된 데이터가 없을 때 true를 반환하는 if절!
				*/
				if(bbs.isEmpty()) //컬렉션에 데이터가 없을 때 true를 반환하는 함수 isEmpty()
				{
					//게시물이 없는경우!
				%>
					<tr>
						<td colspan="6" align="center" height="100">
							등록된 게시물이 없습니다^^
						</td>
					</tr>
				<%
				}
				else
				{
					//게시물이 있는경우! 가상번호 선언!
					int vNum = 0; //게시물의 가상번호로 사용할 변수
					int countNum = 0;
					
					/*
						컬렉션에 입력된 데이터가 있다면 저장된 BbsDTO의 갯수만큼 증가
						즉, DB가 반환해준 레코드의 갯수만큼 반복하면서 출력한다.
					*/
					for(BbsDTO dto : bbs) //for-each문!
					{
						/*
							전체 레코드수를 이용하여 가상번호를 부여하고
							반복할 시에 1씩 차감한다. (페이지처리 없을 때의 방식!)
							=> 이게 뭐냐면 게시판에 글이 하나 삭제 될 때,
							게시판의 일련번호가 -1되는 거라고 보면 된다!
						*/
						// vNum = totalRecordCount --; (페이지처리 없을 때의 방식!)
						
						//////////////////////////////////////////////////////////////
						///////////////<굉장히 중요한 게시글 페이지 번호 계산하기!!>/////////////
						
						//페이지 처리를 할 때 가상번호 계산 방법(PagingUtil.java 작성 후)
						vNum = totalRecordCount - (((nowPage-1) * pageSize) + countNum++);
						
						/*
							전체게시물 수 : 109개
							페이지사이즈(web.xml에 PAGE_SIZE로설정) : 10
							현재페이지가 2일 때,
								- 첫번째게시물 : 109-(((1-1)*10+0)) = 109
								- 두번째게시물 : 109-(((1-1)*10+1)) = 108
							현재페이지가 2일 때,
								- 첫번째게시물 : 109-(((2-1)*10+0)) = 99
								- 두번째게시물 : 109-(((2-1)*10+1)) = 98
						*/
				%>		
						<!-- 리스트반복 start -->
						<tr>
			               <td class="text-center"><%=vNum %></td>
			               <td class="text-left">
			                  <a href="BoardView.jsp?num=<%=dto.getNum() %>&nowPage=<%=nowPage %>&<%=queryStr%>">
			                     <%=dto.getTitle() %>
			                  </a>
			               </td>
			               <td class="text-center"><%=dto.getName() %><br/>(<%=dto.getId() %>)</td>
			               <td class="text-center"><%=dto.getPostdate() %></td>
			               <td class="text-center"><%=dto.getVisitcount() %></td>
			               <!-- <td class="text-center"><i class="material-icons" style="font-size:20px">
			               								attach_file</i></td> -->
			            </tr>
						<!-- 리스트반복 end-->
				<%
					}//for-each문 끝
				}//if문 끝
				%>
				</tbody>
				</table>
					
			</div>
			
			<div class="row">
				<div class="col text-right">
					<!-- 각종 버튼 부분 -->
<!-- 					<button type="button" class="btn">Basic</button> -->
						<button type="button" class="btn btn-primary"
						onclick="location.href='BoardWrite.jsp';">글쓰기</button>
<!-- 						바깥쪽에는 더블쿼테이션 안쪽에는 싱글쿼테이션을 써야지 에러가 생기지 않는다! -->
<!-- 					<button type="button" class="btn btn-secondary">수정하기</button> -->
<!-- 					<button type="button" class="btn btn-success">삭제하기</button> -->
<!-- 					<button type="button" class="btn btn-info">답글쓰기</button> -->
<!-- 					<button type="button" class="btn btn-warning">리스트보기</button> -->
<!-- 					<button type="button" class="btn btn-danger">전송하기</button> -->
<!-- 					<button type="button" class="btn btn-dark">Reset</button> -->
<!-- 					<button type="button" class="btn btn-light">Light</button> -->
<!-- 					<button type="button" class="btn btn-link">Link</button> -->
				</div>
			</div>
			<div class="row mt-3">
				<div class="col">
					<!-- 페이지번호 부분 -->
					<ul class="pagination justify-content-center">
					<!--
					<매개변수 설명>
					totalRecordCount : 게시물의 전체 갯수
					pageSize : 한페이지에 출력할 게시물의 갯수
					blockPage : 한블럭에 출력할 페이지 번호의 갯수(맨 밑에 있는 그거)
					nowPage : 현재 페이지 번호
					"BoardList.jsp?" : 해당 게시판의 실행 파일명 
					-->
					
					<%= PagingUtil.pagingBS4(totalRecordCount, pageSize,
						blockPage, nowPage, "BoardList.jsp?"+queryStr) %>
						
					</ul>
				</div>
			</div>		
		<!-- ########## 게시판의 body 부분 end ########## -->
			<div class="text-center">
				<%-- 텍스트 기반의 페이지번호 출력하기 PagingUtil.java참고--%>
				<%= PagingUtil.pagingTxt(totalRecordCount, pageSize,
						blockPage, nowPage, "BoardList.jsp?"+queryStr) %>
							
			</div>
		</div>
	</div>
	
	<div class="row border border-dark border-bottom-0 border-right-0 border-left-0"></div>
	
	<jsp:include page="../common/boardBottom.jsp" />

</div>
</body>
</html>

<!-- 
	<i class='fas fa-edit' style='font-size:20px'></i>
	<i class='fa fa-cogs' style='font-size:20px'></i>
	<i class='fas fa-sign-in-alt' style='font-size:20px'></i>
	<i class='fas fa-sign-out-alt' style='font-size:20px'></i>
	<i class='far fa-edit' style='font-size:20px'></i>
	<i class='fas fa-id-card-alt' style='font-size:20px'></i>
	<i class='fas fa-id-card' style='font-size:20px'></i>
	<i class='fas fa-id-card' style='font-size:20px'></i>
	<i class='fas fa-pen' style='font-size:20px'></i>
	<i class='fas fa-pen-alt' style='font-size:20px'></i>
	<i class='fas fa-pen-fancy' style='font-size:20px'></i>
	<i class='fas fa-pen-nib' style='font-size:20px'></i>
	<i class='fas fa-pen-square' style='font-size:20px'></i>
	<i class='fas fa-pencil-alt' style='font-size:20px'></i>
	<i class='fas fa-pencil-ruler' style='font-size:20px'></i>
	<i class='fa fa-cog' style='font-size:20px'></i>

	아~~~~힘들다...ㅋ
 -->