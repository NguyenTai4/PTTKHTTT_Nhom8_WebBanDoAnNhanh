package com.webbandoan.controller;

import com.webbandoan.dao.AccountDAO;
import com.webbandoan.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private AccountDAO accountDAO;

    @Override
    public void init() {
        accountDAO = new AccountDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Nếu user đã đăng nhập mà vẫn vào /login, chuyển thẳng về home
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. Nhận submitLoginInfo từ UI
        String identifier = request.getParameter("username"); // Lấy giá trị input (có thể là email hoặc username)
        String password = request.getParameter("password");

        // 2. Gọi verifyCredentials() theo Sequence Diagram
        boolean isValid = accountDAO.verifyCredentials(identifier, password);

        // 3. Khối Alternative (Alt) xử lý luồng Đúng/Sai
        if (isValid) {
            // Nhánh Valid: Gọi getAccountDetails()
            User loggedUser = accountDAO.getAccountDetails(identifier);

            if (loggedUser != null) {
                // Lưu dữ liệu vào Session
                HttpSession session = request.getSession();
                session.setAttribute("loggedUser", loggedUser);

                // redirectHomePage() theo Sequence
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                showErrorMessage(request, response, "Lỗi khi lấy thông tin tài khoản!");
            }
        } else {
            // Nhánh Invalid: Gọi showErrorMessage()
            showErrorMessage(request, response, "Tên đăng nhập hoặc mật khẩu không chính xác!");
        }
    }

    // Hàm phụ trợ tương đương showErrorMessage() trong sơ đồ
    private void showErrorMessage(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
    }
}