<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteSync | Thanh Toán</title>
    
    <!-- Custom Style Sheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        .checkout-wrapper {
            padding-top: 140px;
            padding-bottom: 80px;
        }
        
        .checkout-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 40px;
            align-items: start;
        }
        
        .checkout-form-panel {
            background: var(--bg-glass);
            border: 1px solid var(--border-glass);
            border-radius: var(--radius-lg);
            padding: 32px;
            backdrop-filter: blur(12px);
        }
        
        .checkout-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 24px;
            border-bottom: 1px solid var(--border-glass);
            padding-bottom: 16px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-group {
            margin-bottom: 24px;
        }
        
        .form-group label {
            display: block;
            font-size: 0.85rem;
            color: var(--text-secondary);
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .form-input, .form-textarea {
            width: 100%;
            background: rgba(10, 10, 15, 0.4);
            border: 1px solid var(--border-glass);
            padding: 12px 16px;
            border-radius: var(--radius-md);
            color: var(--text-primary);
            font-family: inherit;
            font-size: 0.95rem;
            transition: var(--transition-fast);
        }
        
        .form-textarea {
            resize: vertical;
            height: 100px;
        }
        
        .form-input:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--color-orange);
            box-shadow: 0 0 10px rgba(255, 94, 54, 0.2);
        }
        
        .payment-methods {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-top: 16px;
        }
        
        .payment-option {
            display: flex;
            align-items: center;
            gap: 12px;
            background: rgba(10, 10, 15, 0.4);
            border: 1px solid var(--border-glass);
            padding: 16px;
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: var(--transition-fast);
        }
        
        .payment-option:hover {
            border-color: var(--text-secondary);
        }
        
        .payment-option input[type="radio"] {
            accent-color: var(--color-orange);
            width: 18px;
            height: 18px;
        }
        
        .payment-info {
            display: flex;
            flex-direction: column;
        }
        
        .payment-title {
            font-weight: 600;
            font-size: 0.95rem;
        }
        
        .payment-desc {
            font-size: 0.8rem;
            color: var(--text-secondary);
        }
        
        .summary-panel {
            background: var(--bg-glass);
            border: 1px solid var(--border-glass);
            border-radius: var(--radius-lg);
            padding: 32px;
            backdrop-filter: blur(12px);
        }
        
        .summary-title {
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 24px;
            border-bottom: 1px solid var(--border-glass);
            padding-bottom: 16px;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 16px;
            font-size: 0.95rem;
            color: var(--text-secondary);
        }
        
        .summary-row.total {
            border-top: 1px solid var(--border-glass);
            padding-top: 16px;
            font-size: 1.3rem;
            font-weight: 800;
            color: var(--text-primary);
            margin-top: 16px;
            margin-bottom: 24px;
        }
        
        .summary-row.total span {
            color: var(--color-orange);
        }
        
        .btn-order {
            width: 100%;
            padding: 14px;
            border-radius: 30px;
            font-weight: 700;
            font-size: 1rem;
            text-align: center;
        }
        
        @media (max-width: 992px) {
            .checkout-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

    <!-- Header / Navigation Bar -->
    <header>
        <div class="container nav-container">
            <a href="${pageContext.request.contextPath}/home" class="logo">
                <i class="fa-solid fa-fire-flame-curved"></i> BiteSync
            </a>
            
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/home#menu">Thực Đơn</a></li>
                <li><a href="#">Về Chúng Tôi</a></li>
                <li><a href="#">Liên Hệ</a></li>
            </ul>
            
            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/pages/login.jsp" class="btn-primary">Đăng Nhập</a>
            </div>
        </div>
    </header>

    <!-- Checkout Layout -->
    <div class="container checkout-wrapper">
        <div class="checkout-grid">
            <!-- Left: Checkout Details Form -->
            <div class="checkout-form-panel">
                <h2 class="checkout-title">Thông Tin Giao Hàng</h2>
                
                <form action="${pageContext.request.contextPath}/home" method="POST">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="fullname">Họ và tên người nhận</label>
                            <input type="text" id="fullname" name="fullname" class="form-input" placeholder="Nhập họ và tên" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Số điện thoại liên hệ</label>
                            <input type="tel" id="phone" name="phone" class="form-input" placeholder="Nhập số điện thoại" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="address">Địa chỉ nhận hàng</label>
                        <input type="text" id="address" name="address" class="form-input" placeholder="Nhập số nhà, tên đường, phường, quận" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="notes">Ghi chú giao hàng</label>
                        <textarea id="notes" name="notes" class="form-textarea" placeholder="Ví dụ: Giao giờ hành chính, gọi trước khi giao..."></textarea>
                    </div>
                    
                    <h3 style="font-weight: 700; font-size: 1.25rem; margin-top: 32px; border-bottom: 1px solid var(--border-glass); padding-bottom: 12px; margin-bottom: 16px;">Phương Thức Thanh Toán</h3>
                    
                    <div class="payment-methods">
                        <label class="payment-option">
                            <input type="radio" name="payment" value="cod" checked>
                            <div class="payment-info">
                                <span class="payment-title">Thanh toán khi nhận hàng (COD)</span>
                                <span class="payment-desc">Thanh toán bằng tiền mặt khi shipper giao hàng tới.</span>
                            </div>
                        </label>
                        
                        <label class="payment-option">
                            <input type="radio" name="payment" value="bank">
                            <div class="payment-info">
                                <span class="payment-title">Chuyển khoản ngân hàng</span>
                                <span class="payment-desc">Thanh toán qua quét mã QR MoMo/ZaloPay hoặc chuyển khoản ngân hàng.</span>
                            </div>
                        </label>
                    </div>
                </form>
            </div>
            
            <!-- Right: Summary Panel -->
            <div class="summary-panel">
                <h3 class="summary-title">Đơn Hàng Của Bạn</h3>
                <div class="summary-row">
                    <span>Double Cheese Burger x 1</span>
                    <span>$5.99</span>
                </div>
                <div class="summary-row">
                    <span>Strawberry Milkshake x 2</span>
                    <span>$5.98</span>
                </div>
                <div class="summary-row" style="border-top: 1px solid var(--border-glass); padding-top: 16px; margin-top: 16px;">
                    <span>Tạm tính</span>
                    <span>$11.97</span>
                </div>
                <div class="summary-row">
                    <span>Phí giao hàng</span>
                    <span>$1.50</span>
                </div>
                <div class="summary-row total">
                    <span>Tổng thanh toán</span>
                    <span>$13.47</span>
                </div>
                
                <button type="submit" class="btn-primary btn-order" onclick="alert('Đặt hàng thành công! Đơn hàng của bạn đang được xử lý.'); window.location.href='${pageContext.request.contextPath}/home';">Đặt Hàng Ngay</button>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-bottom" style="border-top: none; padding-top: 0;">
                <p class="footer-copy">&copy; 2026 BiteSync. Tất cả các quyền được bảo lưu.</p>
            </div>
        </div>
    </footer>

</body>
</html>
