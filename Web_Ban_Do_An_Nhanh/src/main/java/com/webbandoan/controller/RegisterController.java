package com.webbandoan.controller;

import com.webbandoan.dao.AccountDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private AccountDAO accountDAO;

    @Override
    public void init() {
        accountDAO = new AccountDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward tới trang đăng ký nếu user truy cập bằng phương thức GET
        request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy dữ liệu từ Form
        request.setCharacterEncoding("UTF-8");
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmpass = request.getParameter("confirmpass");

        // 1. validateFormat() theo Sequence
        if (!password.equals(confirmpass)) {
            showErrorMessage(request, response, "Mật khẩu xác nhận không khớp!");
            return;
        }

        // Tạo username từ email (Vd: abc@gmail.com -> username = abc)
        String username = email.split("@")[0];

        // 2. checkUsernameExists() theo Sequence
        // Nếu bị trùng username do có người đăng ký email tương tự ở domain khác, ta thêm số random
        if (accountDAO.checkUsernameExists(username)) {
            username = username + System.currentTimeMillis() % 1000;
        }

        // 3. checkExistEmail() theo Sequence
        if (accountDAO.checkExistEmail(email)) {
            showErrorMessage(request, response, "Email này đã được sử dụng!");
            return;
        }

        // 4. createNewAccount() theo Sequence
        boolean isCreated = accountDAO.createNewAccount(username, email, phone, password, fullname);

        // 5. Trả về thông báo thành công / thất bại
        if (isCreated) {
            // showSuccessMessage() và redirectToLoginPage()
            request.setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        } else {
            showErrorMessage(request, response, "Có lỗi xảy ra trong quá trình đăng ký. Vui lòng thử lại sau.");
        }
    }

    private void showErrorMessage(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
    }
}