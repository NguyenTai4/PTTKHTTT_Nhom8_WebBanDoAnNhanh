package com.webbandoan.dao;

import com.webbandoan.model.User;
import com.webbandoan.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Data Access Object (DAO) for User model.
 * Manages database queries for users.
 */
public class UserDAO {

    /**
     * Checks if an email already exists in the database.
     */
    public boolean isEmailExists(String email) {
        String query = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            System.err.println("Error in UserDAO.isEmailExists: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Checks if a username already exists in the database.
     */
    public boolean isUsernameExists(String username) {
        String query = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            System.err.println("Error in UserDAO.isUsernameExists: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Registers a new user in the database.
     */
    public boolean registerUser(User user) {
        String query = "INSERT INTO users (username, email, phone, password, fullname) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getFullname());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            System.err.println("Error in UserDAO.registerUser: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Authenticates a user by username/email and password hash.
     */
    public User checkLogin(String usernameOrEmail, String hashedPassword) {
        String query = "SELECT * FROM users WHERE (username = ? OR email = ?) AND password = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, usernameOrEmail);
            ps.setString(2, usernameOrEmail);
            ps.setString(3, hashedPassword);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("password"),
                        rs.getString("fullname"),
                        rs.getTimestamp("created_at")
                    );
                    user.setActivated(rs.getInt("is_activated") == 1);
                    return user;
                }
            }
        } catch (Exception e) {
            System.err.println("Error in UserDAO.checkLogin: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Retrieves a user by their email address.
     */
    public User getUserByEmail(String email) {
        String query = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("password"),
                        rs.getString("fullname"),
                        rs.getTimestamp("created_at")
                    );
                    user.setActivated(rs.getInt("is_activated") == 1);
                    return user;
                }
            }
        } catch (Exception e) {
            System.err.println("Error in UserDAO.getUserByEmail: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Updates the password for a user identified by email.
     */
    public boolean updatePassword(String email, String newHashedPassword) {
        String query = "UPDATE users SET password = ? WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, newHashedPassword);
            ps.setString(2, email);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            System.err.println("Error in UserDAO.updatePassword: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Locks a user account by setting is_activated to 0.
     */
    public boolean lockUser(String email) {
        String query = "UPDATE users SET is_activated = 0 WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, email);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            System.err.println("Error in UserDAO.lockUser: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
