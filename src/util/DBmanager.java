package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBmanager {
	
	private static DBmanager Instance = new DBmanager();
	private DBmanager() {};
	
	public static DBmanager getInstance() {
		return Instance;
	}
	
	
	public Connection getDBmanager() {
		Connection conn = null;
		
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		String id = "draw";
		String pw = "1399";
		
		try {
			Class.forName(driver);
			conn = DriverManager.getConnection(url,id,pw);
		}catch(Exception e) {
			e.printStackTrace();
		}
		return conn;
	}

	
	
	

}
