<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteSync | Xác Thực OTP</title>
    
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
            font-size: 1.2rem;
            letter-spacing: 4px;
            text-align: center;
            font-weight: 700;
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
        
        .timer-container {
            text-align: center;
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin-bottom: 24px;
        }
        
        .timer-number {
            color: var(--color-orange);
            font-weight: 700;
            font-size: 1.1rem;
        }
        
        .auth-footer {
            text-align: center;
            font-size: 0.9rem;
            color: var(--text-secondary);
        }
        
        .resend-btn {
            color: var(--color-orange);
            text-decoration: none;
            font-weight: 600;
            background: none;
            border: none;
            cursor: pointer;
            padding: 0;
            font-family: inherit;
            font-size: inherit;
            transition: var(--transition-fast);
        }
        
        .resend-btn:hover {
            text-decoration: underline;
        }
        
        .resend-btn:disabled {
            color: var(--text-muted);
            cursor: not-allowed;
            text-decoration: none;
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

    <a href="${pageContext.request.contextPath}/forgot-password" class="back-home">
        <i class="fa-solid fa-arrow-left"></i> Quay lại Nhập Email
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
                <h2>Xác Thực OTP</h2>
                <p>Chúng tôi đã gửi mã xác thực gồm 6 chữ số đến email của bạn: <strong><%= session.getAttribute("otp_email") %></strong></p>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div id="error-alert" style="color: var(--color-red); text-align: center; margin-bottom: 16px; font-weight: 500; font-size: 0.9rem;">
                    <i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("error") %>
                </div>
            <% } %>
            <% 
               String successMsg = null;
               if (request.getAttribute("success") != null) {
                   successMsg = (String) request.getAttribute("success");
               } else if (session.getAttribute("success") != null) {
                   successMsg = (String) session.getAttribute("success");
                   session.removeAttribute("success");
               }
               if (successMsg != null) { 
            %>
                <div style="color: #2ecc71; text-align: center; margin-bottom: 16px; font-weight: 500; font-size: 0.9rem;">
                    <i class="fa-solid fa-circle-check"></i> <%= successMsg %>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/verify-otp" method="POST">
                <div class="form-group">
                    <label for="otp">Mã Xác Thực OTP</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-key" style="left: 18px;"></i>
                        <input type="text" id="otp" name="otp" class="form-input" placeholder="------" maxlength="6" pattern="\d{6}" required autocomplete="off">
                    </div>
                </div>
                
                <div class="timer-container" id="timer-box">
                    Mã OTP hiệu lực còn lại: <span class="timer-number" id="countdown-timer">60s</span>
                </div>
                
                <button type="submit" class="btn-primary btn-auth" id="verify-submit-btn">Xác Minh Mã OTP</button>
            </form>
            
            <div class="auth-footer">
                Chưa nhận được mã? 
                <form action="${pageContext.request.contextPath}/resend-otp" method="POST" style="display:inline;">
                    <button type="submit" id="resend-link" class="resend-btn" disabled>Gửi lại OTP</button>
                </form>
            </div>
        </div>
    </div>

    <!-- JavaScript for Countdown Timer and resend control -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var countdownTimer = document.getElementById("countdown-timer");
            var resendLink = document.getElementById("resend-link");
            var timerBox = document.getElementById("timer-box");
            var verifySubmitBtn = document.getElementById("verify-submit-btn");
            var errorAlert = document.getElementById("error-alert");

            var timeLeft = 60; // 60 seconds limit
            
            var timerInterval = setInterval(function() {
                timeLeft--;
                if (timeLeft <= 0) {
                    clearInterval(timerInterval);
                    countdownTimer.textContent = "0s";
                    timerBox.innerHTML = "<span style='color: var(--color-red); font-weight: 500;'>Mã OTP đã hết hiệu lực. Vui lòng bấm gửi lại!</span>";
                    resendLink.disabled = false;
                } else {
                    countdownTimer.textContent = timeLeft + "s";
                }
            }, 1000);
        });
    </script>

</body>
</html>
