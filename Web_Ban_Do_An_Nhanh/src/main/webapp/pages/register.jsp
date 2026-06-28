<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteSync | Đăng Ký</title>
    
    <!-- Custom Style Sheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* Reusing matching auth styles */
        .auth-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            position: relative;
            overflow: hidden;
        }

        .auth-card {
            background: var(--bg-glass);
            border: 1px solid var(--border-glass);
            border-radius: var(--radius-lg);
            width: 100%;
            max-width: 460px;
            padding: 40px;
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            box-shadow: var(--shadow-lg);
            z-index: 10;
            position: relative;
        }

        .auth-header {
            text-align: center;
            margin-bottom: 24px;
        }

        .auth-header .logo {
            display: inline-flex;
            margin-bottom: 12px;
            font-size: 2rem;
        }

        .auth-header h2 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        .form-group {
            margin-bottom: 16px;
            position: relative;
        }

        .form-group label {
            display: block;
            font-size: 0.85rem;
            color: var(--text-secondary);
            margin-bottom: 6px;
            font-weight: 500;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 0.95rem;
        }

        .form-input {
            width: 100%;
            background: rgba(10, 10, 15, 0.5);
            border: 1px solid var(--border-glass);
            padding: 12px 16px 12px 48px;
            border-radius: var(--radius-md);
            color: var(--text-primary);
            font-family: inherit;
            font-size: 0.95rem;
            transition: var(--transition-fast);
        }

        .form-input:focus {
            outline: none;
            border-color: var(--color-orange);
            box-shadow: 0 0 10px rgba(255, 94, 54, 0.2);
        }

        .btn-auth {
            width: 100%;
            padding: 14px;
            border-radius: 30px;
            font-weight: 700;
            font-size: 1rem;
            margin-top: 16px;
            margin-bottom: 20px;
        }

        .auth-footer {
            text-align: center;
            font-size: 0.9rem;
            color: var(--text-secondary);
        }

        .auth-footer a {
            color: var(--color-orange);
            text-decoration: none;
            font-weight: 600;
        }

        .auth-footer a:hover {
            text-decoration: underline;
        }

        .back-home {
            position: absolute;
            top: 24px;
            left: 24px;
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: var(--transition-fast);
            z-index: 10;
        }

        .back-home:hover {
            color: var(--text-primary);
        }
    </style>
</head>
<body>

    <a href="${pageContext.request.contextPath}/home" class="back-home">
        <i class="fa-solid fa-arrow-left"></i> Quay lại trang chủ
    </a>

    <div class="auth-container">
        <!-- Background blurs -->
        <div class="hero-image-circle" style="top: 15%; right: 20%; width: 320px; height: 320px;"></div>
        <div class="hero-image-circle" style="bottom: 15%; left: 15%; width: 380px; height: 380px; background: var(--gradient-accent);"></div>

        <div class="auth-card">
            <div class="auth-header">
                <a href="${pageContext.request.contextPath}/home" class="logo">
                    <i class="fa-solid fa-fire-flame-curved"></i> BiteSync
                </a>
                <h2>Tạo tài khoản của bạn</h2>
            </div>
            <% 
               String errorMsg = null;
               if (request.getAttribute("error") != null) {
                   errorMsg = (String) request.getAttribute("error");
               } else if (request.getAttribute("errorMessage") != null) {
                   errorMsg = (String) request.getAttribute("errorMessage");
               }
               if (errorMsg != null) { 
            %>
                <div style="color: var(--color-red); text-align: center; margin-bottom: 16px; font-weight: 500; font-size: 0.9rem;">
                    <i class="fa-solid fa-circle-exclamation"></i> <%= errorMsg %>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/register" method="POST">
                <div class="form-group">
                    <label for="fullname">Họ và Tên</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-signature"></i>
                        <input type="text" id="fullname" name="fullname" class="form-input" placeholder="Nhập họ và tên" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="email">Địa chỉ Email</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-envelope"></i>
                        <input type="email" id="email" name="email" class="form-input" placeholder="example@gmail.com" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="phone">Số điện thoại</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-phone"></i>
                        <input type="tel" id="phone" name="phone" class="form-input" placeholder="Nhập số điện thoại" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" id="password" name="password" class="form-input" placeholder="Tối thiểu 6 ký tự" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmpass">Xác nhận mật khẩu</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-shield-halved"></i>
                        <input type="password" id="confirmpass" name="confirmpass" class="form-input" placeholder="Nhập lại mật khẩu" required>
                    </div>
                </div>
                
                <button type="submit" class="btn-primary btn-auth">Đăng Ký</button>
            </form>
            
            <div class="auth-footer">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/pages/login.jsp">Đăng nhập</a>
            </div>
        </div>
    </div>

</body>
</html>
