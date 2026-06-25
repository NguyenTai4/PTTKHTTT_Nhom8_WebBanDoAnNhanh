package com.webbandoan.dao; // Đổi lại package theo cấu trúc dự án của bạn

import com.webbandoan.model.User;
import com.webbandoan.utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AccountDAO {

    // Thực hiện hàm checkExistEmail() theo Sequence Diagram
    public boolean checkExistEmail(String email) {
        String query = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Trả về true nếu email đã tồn tại
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thực hiện hàm checkUsernameExists() theo Sequence Diagram
    public boolean checkUsernameExists(String username) {
        String query = "SELECT id FROM users WHERE username = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Trả về true nếu username đã tồn tại
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thực hiện hàm createNewAccount() theo Sequence Diagram
    public boolean createNewAccount(String username, String email, String phone, String password, String fullname) {
        String query = "INSERT INTO users (username, email, phone, password, fullname) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, phone);
            // Nên thêm logic mã hóa mật khẩu ở đây trước khi lưu
            ps.setString(4, password);
            ps.setString(5, fullname);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean verifyCredentials(String identifier, String password) {
        // Cho phép đăng nhập bằng cả username hoặc email
        String query = "SELECT id FROM users WHERE (username = ? OR email = ?) AND password = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, identifier);
            ps.setString(2, identifier);
            ps.setString(3, password);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Trả về true nếu thông tin khớp
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Tương ứng với phương thức getAccountDetails(username) trong Sequence
     * Trả về đối tượng User để lưu vào phiên làm việc (Session).
     */
    public User getAccountDetails(String identifier) {
        String query = "SELECT * FROM users WHERE username = ? OR email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, identifier);
            ps.setString(2, identifier);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setFullname(rs.getString("fullname"));
                    // Lưu ý: Không nên lưu password vào Object model để mang đi khắp nơi nhằm bảo mật
                    return user;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
}
