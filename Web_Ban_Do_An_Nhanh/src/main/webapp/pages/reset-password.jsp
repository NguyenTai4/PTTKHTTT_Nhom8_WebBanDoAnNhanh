<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteSync | Đặt Lại Mật Khẩu</title>
    
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
        
        .auth-header p {
            color: var(--text-secondary);
            font-size: 0.85rem;
            margin-top: 8px;
            line-height: 1.4;
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
        
        .btn-auth {
            width: 100%;
            padding: 14px;
            border-radius: 30px;
            font-weight: 700;
            font-size: 1rem;
            margin-bottom: 24px;
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

    <div class="auth-container">
        <!-- Background blurs -->
        <div class="hero-image-circle" style="top: 20%; left: 30%; width: 300px; height: 300px;"></div>
        <div class="hero-image-circle" style="bottom: 10%; right: 25%; width: 350px; height: 350px; background: var(--gradient-accent);"></div>

        <div class="auth-card">
            <div class="auth-header">
                <a href="${pageContext.request.contextPath}/home" class="logo">
                    <i class="fa-solid fa-fire-flame-curved"></i> BiteSync
                </a>
                <h2>Đặt Lại Mật Khẩu</h2>
                <p>Đặt mật khẩu mới cho tài khoản của bạn: <strong><%= session.getAttribute("otp_email") %></strong></p>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div style="color: var(--color-red); text-align: center; margin-bottom: 16px; font-weight: 500; font-size: 0.9rem;">
                    <i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/reset-password" method="POST">
                <div class="form-group">
                    <label for="new_password">Mật khẩu mới</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" id="new_password" name="new_password" class="form-input" placeholder="Tối thiểu 6 ký tự" required minlength="6">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="confirm_password">Nhập lại mật khẩu mới</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-shield-halved"></i>
                        <input type="password" id="confirm_password" name="confirm_password" class="form-input" placeholder="Xác nhận lại mật khẩu" required minlength="6">
                    </div>
                </div>
                
                <button type="submit" class="btn-primary btn-auth">Đặt Lại Mật Khẩu</button>
            </form>
        </div>
    </div>

</body>
</html>
