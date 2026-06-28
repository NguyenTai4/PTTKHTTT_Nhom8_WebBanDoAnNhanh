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

// @WebServlet("/login")
public class LoginController extends HttpServlet {
    private AccountDAO accountDAO;

    @Override
    public void init() {
        accountDAO = new AccountDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        String identifier = request.getParameter("username"); // Lấy giá trị input (có thể là email hoặc username)
        String password = request.getParameter("password");

        boolean isValid = accountDAO.verifyCredentials(identifier, password);

        if (isValid) {
            User loggedUser = accountDAO.getAccountDetails(identifier);

            if (loggedUser != null) {
                HttpSession session = request.getSession();
                session.setAttribute("loggedUser", loggedUser);

                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                showErrorMessage(request, response, "Lỗi khi lấy thông tin tài khoản!");
            }
        } else {
            showErrorMessage(request, response, "Tên đăng nhập hoặc mật khẩu không chính xác!");
        }
    }

    private void showErrorMessage(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
    }
}