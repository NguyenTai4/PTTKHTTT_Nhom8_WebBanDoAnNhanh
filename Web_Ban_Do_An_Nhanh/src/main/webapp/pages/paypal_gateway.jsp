<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PayPal: Thanh Toán Đơn Hàng</title>
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --paypal-blue: #003087;
            --paypal-light-blue: #0079C1;
            --paypal-gold: #ffc439;
            --paypal-gray: #f2f2f2;
            --text-dark: #333333;
            --text-muted: #666666;
            --border-color: #dcdcdc;
            --radius: 4px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }

        body {
            background-color: #ffffff;
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        header {
            border-bottom: 1px solid var(--border-color);
            padding: 15px 0;
            background-color: #ffffff;
        }

        .header-container {
            max-width: 950px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }

        .paypal-logo {
            font-style: italic;
            font-weight: 900;
            font-size: 24px;
            color: var(--paypal-blue);
            display: flex;
            align-items: center;
            gap: 2px;
            text-decoration: none;
            user-select: none;
        }

        .paypal-logo span {
            color: var(--paypal-light-blue);
        }

        .cart-summary {
            font-size: 0.9rem;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .cart-summary .price {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--text-dark);
        }

        main {
            flex-grow: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
            background-color: #faf8f6;
        }

        .gateway-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            width: 100%;
            max-width: 460px;
            padding: 40px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .gateway-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 24px;
            text-align: center;
            color: var(--paypal-blue);
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-muted);
            margin-bottom: 6px;
        }

        .form-control {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border-color);
            border-radius: var(--radius);
            font-size: 0.95rem;
            color: var(--text-dark);
            transition: border-color 0.2s;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--paypal-light-blue);
        }

        .sandbox-badge {
            background-color: #e2f0fe;
            color: var(--paypal-light-blue);
            font-size: 0.75rem;
            font-weight: 700;
            padding: 3px 8px;
            border-radius: 12px;
            display: inline-block;
            margin-bottom: 20px;
            text-align: center;
            width: 100%;
            text-transform: uppercase;
        }

        .btn-paypal-login {
            background-color: var(--paypal-blue);
            color: white;
            border: none;
            padding: 14px;
            font-size: 1rem;
            font-weight: 700;
            border-radius: 25px;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.2s;
            margin-bottom: 12px;
        }

        .btn-paypal-login:hover {
            background-color: #002266;
        }

        .btn-paypal-cancel {
            background: none;
            border: 1px solid var(--border-color);
            color: var(--text-muted);
            padding: 12px;
            font-size: 0.95rem;
            font-weight: 600;
            border-radius: 25px;
            cursor: pointer;
            width: 100%;
            text-align: center;
            text-decoration: none;
            display: block;
            transition: background-color 0.2s;
        }

        .btn-paypal-cancel:hover {
            background-color: var(--paypal-gray);
            color: var(--text-dark);
        }

        /* Step 2 Approval Screen styling */
        .approval-screen {
            display: none;
        }

        .merchant-info {
            background-color: var(--paypal-gray);
            padding: 16px;
            border-radius: var(--radius);
            margin-bottom: 24px;
            font-size: 0.9rem;
        }

        .merchant-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
        }

        .merchant-row:last-child {
            margin-bottom: 0;
            border-top: 1px solid rgba(0,0,0,0.05);
            padding-top: 8px;
            font-weight: 700;
        }

        .payment-method-box {
            border: 1px solid var(--border-color);
            border-radius: var(--radius);
            padding: 16px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .payment-method-box i {
            font-size: 1.5rem;
            color: var(--paypal-light-blue);
        }

        .btn-pay-now {
            background-color: var(--paypal-gold);
            color: #111111;
            border: none;
            padding: 14px;
            font-size: 1rem;
            font-weight: 700;
            border-radius: 25px;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.2s;
            margin-bottom: 12px;
        }

        .btn-pay-now:hover {
            background-color: #e5af2f;
        }

        footer {
            border-top: 1px solid var(--border-color);
            padding: 20px 0;
            background-color: var(--paypal-gray);
            font-size: 0.75rem;
            color: var(--text-muted);
        }

        .footer-container {
            max-width: 950px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            padding: 0 20px;
        }

        .footer-links {
            display: flex;
            gap: 15px;
            list-style: none;
        }

        .footer-links a {
            color: var(--text-muted);
            text-decoration: none;
        }

        .footer-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <header>
        <div class="header-container">
            <a href="#" class="paypal-logo">
                <i class="fa-brands fa-paypal"></i> Pay<span>Pal</span>
            </a>
            
            <div class="cart-summary">
                <span>Tổng cộng:</span>
                <span class="price">$${param.total}</span>
            </div>
        </div>
    </header>

    <main>
        <!-- STEP 1: LOGIN -->
        <div class="gateway-card" id="login-card">
            <div class="sandbox-badge"><i class="fa-solid fa-flask"></i> Sandbox Simulator</div>
            <h2 class="gateway-title">Đăng Nhập PayPal</h2>
            
            <form id="paypal-login-form" onsubmit="handleLogin(event)">
                <div class="form-group">
                    <label class="form-label" for="email">Địa chỉ Email</label>
                    <input type="email" id="email" class="form-control" placeholder="example@email.com" value="${sessionScope.loggedUser.email}" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="password">Mật khẩu</label>
                    <input type="password" id="password" class="form-control" placeholder="••••••••" required>
                </div>
                
                <button type="submit" class="btn-paypal-login">Đăng Nhập</button>
                <a href="${pageContext.request.contextPath}/checkout/paypal-cancel?orderId=${param.orderId}" class="btn-paypal-cancel">Hủy và quay lại cửa hàng</a>
            </form>
        </div>

        <!-- STEP 2: APPROVAL -->
        <div class="gateway-card approval-screen" id="approval-card">
            <div class="sandbox-badge"><i class="fa-solid fa-flask"></i> Sandbox Simulator</div>
            <h2 class="gateway-title" style="text-align: left; font-size: 1.4rem;">Xác Nhận Thanh Toán</h2>
            
            <div class="merchant-info">
                <div class="merchant-row">
                    <span>Nhà cung cấp:</span>
                    <span>BiteSync Fast Food</span>
                </div>
                <div class="merchant-row">
                    <span>Mã đơn hàng:</span>
                    <span>#${param.orderId}</span>
                </div>
                <div class="merchant-row">
                    <span>Số tiền:</span>
                    <span>$${param.total}</span>
                </div>
            </div>

            <h4 style="font-size: 0.9rem; font-weight: 700; margin-bottom: 12px;">Phương thức thanh toán</h4>
            <div class="payment-method-box">
                <i class="fa-solid fa-wallet"></i>
                <div>
                    <div style="font-weight: 700; font-size: 0.9rem;">Số dư tài khoản PayPal</div>
                    <div style="color: var(--text-muted); font-size: 0.8rem;">Liên kết: ${sessionScope.loggedUser.email}</div>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/checkout/paypal-success" method="POST">
                <input type="hidden" name="orderId" value="${param.orderId}">
                <!-- Simulated PayPal response fields -->
                <input type="hidden" name="paymentId" value="PAYID-MOCK-${param.orderId}-${System.currentTimeMillis()}">
                <input type="hidden" name="token" value="EC-MOCK-${param.orderId}">
                <input type="hidden" name="PayerID" value="PAYER-${sessionScope.loggedUser.id}">
                
                <button type="submit" class="btn-pay-now">Thanh Toán Ngay</button>
                <a href="${pageContext.request.contextPath}/checkout/paypal-cancel?orderId=${param.orderId}" class="btn-paypal-cancel">Hủy và quay lại cửa hàng</a>
            </form>
        </div>
    </main>

    <footer>
        <div class="footer-container">
            <span>© 2026 PayPal Sandbox. Chỉ dùng cho mục đích học tập/thử nghiệm.</span>
            <ul class="footer-links">
                <li><a href="#">Bảo mật</a></li>
                <li><a href="#">Pháp lý</a></li>
                <li><a href="#">Liên hệ</a></li>
            </ul>
        </div>
    </footer>

    <script>
        function handleLogin(event) {
            event.preventDefault();
            // Simple animation transition between Step 1 and Step 2
            document.getElementById('login-card').style.display = 'none';
            document.getElementById('approval-card').style.display = 'block';
        }
    </script>
</body>
</html>
