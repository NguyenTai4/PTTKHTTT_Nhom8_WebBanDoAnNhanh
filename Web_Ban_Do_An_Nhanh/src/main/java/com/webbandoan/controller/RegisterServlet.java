package com.webbandoan.controller;

import com.webbandoan.dao.UserDAO;
import com.webbandoan.model.User;
import com.webbandoan.utils.HashUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller Servlet for handling user registration.
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to the registration page
        request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmpass = request.getParameter("confirmpass");

        // Basic validation
        if (fullname == null || email == null || phone == null || password == null || confirmpass == null ||
            fullname.trim().isEmpty() || email.trim().isEmpty() || phone.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ tất cả thông tin!");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải chứa ít nhất 6 ký tự!");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmpass)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }

        // Check if email already registered
        if (userDAO.isEmailExists(email)) {
            request.setAttribute("error", "Email này đã được sử dụng!");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }

        // Using email as username since there's no username input field
        String username = email;
        if (userDAO.isUsernameExists(username)) {
            request.setAttribute("error", "Tên tài khoản trùng lặp!");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }

        // Hashing password
        String hashedPassword = HashUtils.sha256(password);

        // Register user
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(hashedPassword);
        user.setFullname(fullname);

        boolean isRegistered = userDAO.registerUser(user);
        if (isRegistered) {
            // Store success message in session to survive redirect
            request.getSession().setAttribute("success", "Đăng ký tài khoản thành công! Vui lòng đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        } else {
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống trong quá trình đăng ký. Vui lòng thử lại!");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
        }
    }
}
