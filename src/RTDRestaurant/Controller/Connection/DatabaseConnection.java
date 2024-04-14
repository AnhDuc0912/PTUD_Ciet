
package RTDRestaurant.Controller.Connection;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.util.logging.Level;
import java.util.logging.Logger;

// Kết nối tới DataBase của hệ thống

public class DatabaseConnection {

    private static DatabaseConnection instance;
    private Connection connection;

    public static DatabaseConnection getInstance() {
        if (instance == null) {
            instance = new DatabaseConnection();
        }
        return instance;
    }

    private DatabaseConnection() {

    }

    // Thực hiện kết nối tới Database
    public void connectToDatabase() throws SQLException {
        // Kiểm tra driver
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException ex) {
        }
        System.out.println(this.instance);
        try {
            connection = DriverManager.getConnection(
                    "jdbc:sqlserver://localhost"
                            + ":1435;DatabaseName=QuanLyNhaHang;encrypt=false;trustServerCertificate=true",
                    "sa", "Abc@123456789");
            System.out.println("kết nối thành công");
        } catch (SQLException ex) {
            System.out.println("kết nối thất bại");
            ex.printStackTrace();
        }
    }

    public Connection getConnection() {
        return connection;
    }

    public void setConnection(Connection connection) {
        this.connection = connection;
    }
}
