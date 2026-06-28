package com.webbandoan.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class to manage database connections.
 * Customize the parameters below to connect to your local MySQL database.
 */
public class DBContext {
    
    // Database connection details
    private static final String HOST = "localhost";
    private static final String PORT = "3306";
    private static final String DATABASE_NAME = "web_ban_do_an_nhanh";
    private static final String USERNAME = "root";
    private static final String PASSWORD = ""; // Add your MySQL password here

        /**
     * Obtains a connection to the MySQL database.
     * @return Connection object
     * @throws ClassNotFoundException if the JDBC Driver is not found
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        // Load the MySQL JDBC Driver (automatically registered in modern JDBC, but good for university standards)
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Construct connection URL
        String url = String.format("jdbc:mysql://%s:%s/%s?useSSL=false&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=UTF-8", 
                HOST, PORT, DATABASE_NAME);
        
        return DriverManager.getConnection(url, USERNAME, PASSWORD);
    }
    
    /**
     * Quick connection test helper.
     */
    public static void main(String[] args) {
        try {
            Connection conn = getConnection();
            if (conn != null) {
                System.out.println("Database connection established successfully!");
                conn.close();
            }
        } catch (Exception e) {
            System.err.println("Database connection failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
