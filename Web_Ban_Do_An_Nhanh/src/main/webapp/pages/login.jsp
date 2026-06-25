<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteSync | Đăng Nhập</title>
    
    <!-- Custom Style Sheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
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
            max-width: 420px;
            padding: 40px;
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            box-shadow: var(--shadow-lg);
            z-index: 10;
            position: relative;
        }
        
        .auth-header {
            text-align: center;
            margin-bottom: 32px;
        }
        
        .auth-header .logo {
            display: inline-flex;
            margin-bottom: 16px;
            font-size: 2rem;
        }
        
        .auth-header h2 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
        }
        
        .form-group {
            margin-bottom: 24px;
            position: relative;
        }
        
        .form-group label {
            display: block;
            font-size: 0.85rem;
            color: var(--text-secondary);
            margin-bottom: 8px;
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
        
        .auth-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.85rem;
            margin-bottom: 24px;
        }
        
        .checkbox-container {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            color: var(--text-secondary);
        }
        
        .checkbox-container input {
            cursor: pointer;
        }
        
        .forgot-link {
            color: var(--color-orange);
            text-decoration: none;
            transition: var(--transition-fast);
        }
        
        .forgot-link:hover {
            text-decoration: underline;
        }
        
        .btn-auth {
            width: 100%;
            padding: 14px;
            border-radius: 30px;
            font-weight: 700;
            font-size: 1rem;
            margin-bottom: 24px;
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
        <div class="hero-image-circle" style="top: 20%; left: 30%; width: 300px; height: 300px;"></div>
        <div class="hero-image-circle" style="bottom: 10%; right: 25%; width: 350px; height: 350px; background: var(--gradient-accent);"></div>

        <div class="auth-card">
            <div class="auth-header">
                <a href="${pageContext.request.contextPath}/home" class="logo">
                    <i class="fa-solid fa-fire-flame-curved"></i> BiteSync
                </a>
                <h2>Chào mừng bạn trở lại!</h2>
            </div>
            <c:if test="${not empty errorMessage}">
                <div style="color: #ff5e36; text-align: center; margin-bottom: 20px; font-size: 0.95rem; font-weight: 500; background: rgba(255, 94, 54, 0.1); padding: 10px; border-radius: 8px; border: 1px solid rgba(255, 94, 54, 0.2);">
                    <i class="fa-solid fa-circle-exclamation"></i> ${errorMessage}
                </div>
            </c:if>

            <c:if test="${not empty successMessage}">
                <div style="color: #4cd964; text-align: center; margin-bottom: 20px; font-size: 0.95rem; font-weight: 500; background: rgba(76, 217, 100, 0.1); padding: 10px; border-radius: 8px; border: 1px solid rgba(76, 217, 100, 0.2);">
                    <i class="fa-solid fa-circle-check"></i> ${successMessage}
                </div>
            </c:if>
            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="form-group">
                    <label for="username">Tên đăng nhập / Email</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-user"></i>
                        <input type="text" id="username" name="username" class="form-input" placeholder="Nhập tài khoản của bạn" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" id="password" name="password" class="form-input" placeholder="Nhập mật khẩu" required>
                    </div>
                </div>
                
                <div class="auth-options">
                    <label class="checkbox-container">
                        <input type="checkbox" name="remember"> Nhớ mật khẩu
                    </label>
                    <a href="#" class="forgot-link">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="btn-primary btn-auth">Đăng Nhập</button>

                <div style="text-align: center; margin: 15px 0; color: var(--text-secondary); font-size: 0.9rem;">
                    <span>HOẶC</span>
                </div>

                <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile&redirect_uri=http://localhost:8080${pageContext.request.contextPath}/login-google&response_type=code&client_id=797549044266-n1h5cl113p3s5pjgm9krg4e1343o16lc.apps.googleusercontent.com"
                   class="btn-secondary"
                   style="display: flex; align-items: center; justify-content: center; gap: 10px; width: 100%; padding: 12px; border-radius: 30px; text-decoration: none; font-weight: 600; font-size: 0.95rem; background: rgba(255,255,255,0.05); border: 1px solid var(--border-glass); color: var(--text-primary); transition: var(--transition-fast);"
                   onmouseover="this.style.background='rgba(255,255,255,0.1)'"
                   onmouseout="this.style.background='rgba(255,255,255,0.05)'">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg" alt="Google Logo" style="width: 18px; height: 18px;">
                    Đăng nhập bằng Google
                </a>
            </form>
            
            <div class="auth-footer">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/pages/register.jsp">Đăng ký ngay</a>
            </div>
        </div>
    </div>

</body>
</html>
