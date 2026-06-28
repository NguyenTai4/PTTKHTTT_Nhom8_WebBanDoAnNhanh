package com.webbandoan.controller;

import com.webbandoan.dao.UserDAO;
import com.webbandoan.model.User;
import com.webbandoan.utils.EmailService;
import com.webbandoan.utils.HashUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

/**
 * Controller Servlet handling UC3: Forgot Password flow.
 * Handles stages: request email, verify OTP, and reset password.
 */
@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password", "/verify-otp", "/reset-password", "/resend-otp"})
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO();
    private final Random random = new Random();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        HttpSession session = request.getSession();

        if (path.equals("/forgot-password")) {
            request.getRequestDispatcher("/pages/forgot-password.jsp").forward(request, response);
        } 
        else if (path.equals("/verify-otp")) {
            // Must have email in session to verify OTP
            if (session.getAttribute("otp_email") == null) {
                response.sendRedirect(request.getContextPath() + "/forgot-password");
                return;
            }
            request.getRequestDispatcher("/pages/verify-otp.jsp").forward(request, response);
        } 
        else if (path.equals("/reset-password")) {
            // Must have verified OTP successfully
            Boolean otpVerified = (Boolean) session.getAttribute("otp_verified");
            if (otpVerified == null || !otpVerified) {
                response.sendRedirect(request.getContextPath() + "/forgot-password");
                return;
            }
            request.getRequestDispatcher("/pages/reset-password.jsp").forward(request, response);
        } 
        else {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        HttpSession session = request.getSession();

        if (path.equals("/forgot-password")) {
            String email = request.getParameter("email");
            
            // Validate email input
            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Email không được để trống!");
                request.getRequestDispatcher("/pages/forgot-password.jsp").forward(request, response);
                return;
            }

            // Regular expression for email validation
            String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
            if (!email.matches(emailRegex)) {
                request.setAttribute("error", "Định dạng email không hợp lệ!");
                request.getRequestDispatcher("/pages/forgot-password.jsp").forward(request, response);
                return;
            }

            // Check if email exists in database
            User user = userDAO.getUserByEmail(email);
            if (user == null) {
                request.setAttribute("error", "Email không tồn tại trong hệ thống!");
                request.getRequestDispatcher("/pages/forgot-password.jsp").forward(request, response);
                return;
            }

            // Check if account is activated
            if (!user.isActivated()) {
                request.setAttribute("error", "Tài khoản chưa được kích hoạt hoặc đã bị khóa!");
                request.getRequestDispatcher("/pages/forgot-password.jsp").forward(request, response);
                return;
            }

            // Generate 6-digit OTP
            String otpCode = String.format("%06d", random.nextInt(1000000));
            
            // Save to Session with timestamp
            session.setAttribute("otp_email", email);
            session.setAttribute("otp_code", otpCode);
            session.setAttribute("otp_time", System.currentTimeMillis());
            session.removeAttribute("otp_verified"); // clear old verification states
            session.removeAttribute("otp_failed_attempts"); // clear old failed attempts

            // Send OTP
            EmailService.sendEmailOTP(email, otpCode);

            // Redirect to verify OTP screen
            session.setAttribute("success", "Mã xác thực OTP đã được gửi thành công!");
            response.sendRedirect(request.getContextPath() + "/verify-otp");
        } 
        
        else if (path.equals("/verify-otp")) {
            String email = (String) session.getAttribute("otp_email");
            String correctOtp = (String) session.getAttribute("otp_code");
            Long otpTime = (Long) session.getAttribute("otp_time");

            if (email == null || correctOtp == null || otpTime == null) {
                response.sendRedirect(request.getContextPath() + "/forgot-password");
                return;
            }

            String enteredOtp = request.getParameter("otp");

            if (enteredOtp == null || enteredOtp.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập mã OTP!");
                request.getRequestDispatcher("/pages/verify-otp.jsp").forward(request, response);
                return;
            }

            // Check expiration (60 seconds)
            long timeDifference = System.currentTimeMillis() - otpTime;
            if (timeDifference > 60000) {
                request.setAttribute("error", "Mã OTP đã hết hạn! Vui lòng nhấn gửi lại.");
                request.getRequestDispatcher("/pages/verify-otp.jsp").forward(request, response);
                return;
            }

            // Check if OTP matches
            if (enteredOtp.equals(correctOtp)) {
                // Success: Set verified flag
                session.setAttribute("otp_verified", true);
                session.removeAttribute("otp_failed_attempts");
                response.sendRedirect(request.getContextPath() + "/reset-password");
            } else {
                Integer failedAttempts = (Integer) session.getAttribute("otp_failed_attempts");
                if (failedAttempts == null) {
                    failedAttempts = 0;
                }
                failedAttempts++;
                session.setAttribute("otp_failed_attempts", failedAttempts);

                if (failedAttempts >= 3) {
                    // Lock user account
                    userDAO.lockUser(email);

                    // Clear OTP session values
                    session.removeAttribute("otp_email");
                    session.removeAttribute("otp_code");
                    session.removeAttribute("otp_time");
                    session.removeAttribute("otp_failed_attempts");
                    session.removeAttribute("otp_verified");

                    request.setAttribute("error", "Tài khoản của bạn đã bị khóa do nhập sai OTP quá 3 lần!");
                    request.getRequestDispatcher("/pages/forgot-password.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Mã OTP không chính xác! Bạn còn " + (3 - failedAttempts) + " lần thử.");
                    request.getRequestDispatcher("/pages/verify-otp.jsp").forward(request, response);
                }
            }
        } 
        
        else if (path.equals("/resend-otp")) {
            String email = (String) session.getAttribute("otp_email");
            if (email == null) {
                response.sendRedirect(request.getContextPath() + "/forgot-password");
                return;
            }

            // Generate new OTP
            String otpCode = String.format("%06d", random.nextInt(1000000));
            session.setAttribute("otp_code", otpCode);
            session.setAttribute("otp_time", System.currentTimeMillis());
            session.removeAttribute("otp_failed_attempts"); // reset failed attempts counter for new OTP code

            // Resend
            EmailService.sendEmailOTP(email, otpCode);

            session.setAttribute("success", "Đã gửi lại mã OTP mới!");
            response.sendRedirect(request.getContextPath() + "/verify-otp");
        } 
        
        else if (path.equals("/reset-password")) {
            String email = (String) session.getAttribute("otp_email");
            Boolean otpVerified = (Boolean) session.getAttribute("otp_verified");

            if (email == null || otpVerified == null || !otpVerified) {
                response.sendRedirect(request.getContextPath() + "/forgot-password");
                return;
            }

            String newPassword = request.getParameter("new_password");
            String confirmPassword = request.getParameter("confirm_password");

            if (newPassword == null || confirmPassword == null || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin mật khẩu!");
                request.getRequestDispatcher("/pages/reset-password.jsp").forward(request, response);
                return;
            }

            if (newPassword.length() < 6) {
                request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự!");
                request.getRequestDispatcher("/pages/reset-password.jsp").forward(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
                request.getRequestDispatcher("/pages/reset-password.jsp").forward(request, response);
                return;
            }

            // Check if new password is same as old password
            User user = userDAO.getUserByEmail(email);
            if (user != null) {
                String newHashed = HashUtils.sha256(newPassword);
                if (newHashed.equals(user.getPassword())) {
                    request.setAttribute("error", "Mật khẩu mới không được trùng với mật khẩu cũ!");
                    request.getRequestDispatcher("/pages/reset-password.jsp").forward(request, response);
                    return;
                }

                // Update password in Database
                boolean isUpdated = userDAO.updatePassword(email, newHashed);
                if (isUpdated) {
                    // Clear OTP session values
                    session.removeAttribute("otp_email");
                    session.removeAttribute("otp_code");
                    session.removeAttribute("otp_time");
                    session.removeAttribute("otp_verified");

                    session.setAttribute("success", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập.");
                    response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
                } else {
                    request.setAttribute("error", "Lỗi CSDL khi cập nhật mật khẩu. Vui lòng thử lại!");
                    request.getRequestDispatcher("/pages/reset-password.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Tài khoản không tồn tại!");
                request.getRequestDispatcher("/pages/reset-password.jsp").forward(request, response);
            }
        } 
        
        else {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
        }
    }
}
