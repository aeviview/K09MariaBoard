package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

public class MemberDAO 
{
	Connection con;
	PreparedStatement psmt;
	ResultSet rs;

	//기본생성자를 통한 DB연결
	public MemberDAO() 
	{
		String driver = "org.mariadb.jdbc.Driver";
		String url = "jdbc:mariadb://127.0.0.1:3306/kosmo_db";
		
		try 
		{
			Class.forName(driver);
			String id = "kosmo_user";
			String pw = "1234";
			con = DriverManager.getConnection(url, id, pw);
			System.out.println("DB연결성공(디폴트생성자)");
		}
		catch (Exception e) 
		{
			System.out.println("DB연결실패(디폴트생성자)");
			e.printStackTrace();
		}
	}
	
	//JSP에서 컨텍스트 초기화 파라미터를 인자로 전달하여 DB연결
	public MemberDAO(String driver, String url, String id, String pw) 
	{
		
		try 
		{
			Class.forName(driver);
			con = DriverManager.getConnection(url, id, pw);
			System.out.println("DB연결성공(디폴트생성자)");
		}
		catch (Exception e) 
		{
			System.out.println("DB연결실패(디폴트생성자)");
			e.printStackTrace();
		}
	}
	
	//로그인방법3 : DTO객체 대신 Map 컬렉션에 회원정보를 저장 후 반환한다.
	public Map<String, String> getMemberMap(String id, String pwd)
	{
		//회원정보를 저장할 Map컬렉션을 생성한다
		Map<String, String> maps = new HashMap<String, String>();
		
		String query = "SELECT id, pass, name FROM "
				+ " member WHERE id=? AND pass=?";
		
		try
		{
			psmt = con.prepareStatement(query); //prepare 객체생성
			psmt.setString(1, id); //인파라미터 설정
			psmt.setString(2, pwd); //인파라미터 설정
			rs = psmt.executeQuery(); //쿼리실행
			
			//회원정보가 있다면 put()을 통해 정보를 저장한다
			if(rs.next()) //오라클이 반환해준 ResultSet을 통해 결과값이 있는지 확인하고
			{
				maps.put("id", rs.getString(1)); //결과값이 있으면 maps 객체에 저장한다
				maps.put("pass", rs.getString("pass"));
				maps.put("name", rs.getString("name"));
			}
			else
			{
				System.out.println("결과값이 없습니다");
			}
		}
		catch(Exception e)
		{
			System.out.println("getMemberDTO오류");
			e.printStackTrace();
		}
		return maps;
	}
	
	//그룹함수 count()를 통해 회원의 존재유무만 판단한다.
	public boolean isMember(String id, String pass) 
	{
		
		//쿼리문 작성
		String sql = "SELECT COUNT(*) FROM member "
				+ " WHERE id=? AND pass=? ";
		
		int isMember = 0;
		boolean isFlag = false;

		try 
		{
			//prepare객체를 통해 쿼리문을 전송한다. 
			//생성자에서 연결정보를 저장한 커넥션 객체를 사용한다!
			psmt = con.prepareStatement(sql);
			//쿼리문의 인파라미터 설정(DB의 인덱스는 1부터 시작)
			psmt.setString(1, id);
			psmt.setString(2, pass);
			//쿼리문 실행후 결과는 ResultSet객체를 통해 반환 받는다
			rs = psmt.executeQuery();
			//실행결과를 가져오기 위해 next()를 호출한다. 
			rs.next();
			//select절의 첫번째 결과값을 얻어오기 위해 getInt()사용함.
			isMember = rs.getInt(1); //읽어 온 내용을 변수에 저장함!
			System.out.println("affected:"+isMember);
			if(isMember==0) //회원이 아닌경우
				isFlag = false;
			else //회원인 경우(해당 아이디,패스워드가 일치함)
				isFlag = true; 
		}
		catch(Exception e) 
		{
			//예외가 발생한다면 확인이 불가능하므로 무조건 false를 반환한다.
			isFlag = false;
			e.printStackTrace();
		}
		return isFlag;
	}
	
	//LoginProcessDTO.jsp에서 객체 생성
	//인자생성자 : 오라클 드라이버와 url을 매개변수로 받아 연결한다.
	public MemberDAO(String driver, String url) 
	{		
		try 
		{
			Class.forName(driver);
			String id = "kosmo";
			String pw = "1234";
			//DB에 연결된 정보를 멤버변수에 저장
			con = DriverManager.getConnection(url, id, pw); //커넥션 객체가 중요하다 con
			System.out.println("DB연결성공(인자생성자)");
		}
		catch (Exception e) 
		{
			System.out.println("DB연결실패(인자생성자)");
			e.printStackTrace();
		}
	}
	
	//LoginProcessDTO.jsp에서 객체 생성
	//로그인방법2 : 회원인증 후 MemberDTO객체에 회원정보를 저장한 후 JSP쪽으로 반환해준다.
	public MemberDTO getMemberDTO(String uid, String upass)
	{
		MemberDTO dto = new MemberDTO(); //회원정보 저장을 위해 DTO객체 생성
		
		//회원정보를 가져오기 위한 쿼리문 작성
		String query = "SELECT id, pass, name FROM "
				+ " member WHERE id=? AND pass=?";
		
		try
		{
			
			psmt = con.prepareStatement(query); //prepare 객체생성
			psmt.setString(1, uid); //인파라미터 설정
			psmt.setString(2, upass); //인파라미터 설정
			rs = psmt.executeQuery(); //쿼리실행
			
			if(rs.next()) //오라클이 반환해준 ResultSet을 통해 결과값이 있는지 확인하고
			{
				dto.setId(rs.getString("id")); //결과값이 있으면 dto 객체에 저장한다
				dto.setPass(rs.getString("pass"));
				dto.setName(rs.getString(3));
			}
			else
			{
				System.out.println("결과값이 없습니다");
			}
		}
		catch(Exception e)
		{
			System.out.println("getMemberDTO오류");
			e.printStackTrace();
		}
		return dto;
	}
	
		
	public static void main(String[] args)
	{
		new MemberDAO();
	}
}
