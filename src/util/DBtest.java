package util;

import java.sql.Connection;

public class DBtest {

	public static void main(String[] args) {
		Connection conn = DBmanager.getInstance().getDBmanager();
		if(conn != null) {
			System.out.println("接続完了");
		}else {
			System.out.println("接続不可");
		}

	}

}
