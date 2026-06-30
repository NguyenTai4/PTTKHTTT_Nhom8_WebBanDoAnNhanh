<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteSync | Giỏ Hàng</title>
    
    <!-- Custom Style Sheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        .cart-wrapper {
            padding-top: 140px;
            padding-bottom: 80px;
        }
        
        .cart-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 40px;
            align-items: start;
        }
        
        .cart-items-panel {
            background: var(--bg-glass);
            border: 1px solid var(--border-glass);
            border-radius: var(--radius-lg);
            padding: 32px;
            backdrop-filter: blur(12px);
        }
        
        .cart-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 24px;
            border-bottom: 1px solid var(--border-glass);
            padding-bottom: 16px;
        }
        
        .cart-item {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 20px 0;
            border-bottom: 1px solid var(--border-glass);
        }
        
        .cart-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }
        
        .cart-item-img {
            width: 90px;
            height: 90px;
            object-fit: cover;
            border-radius: var(--radius-md);
            border: 1px solid var(--border-glass);
        }
        
        .cart-item-info {
            flex-grow: 1;
        }
        
        .cart-item-name {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 6px;
            text-decoration: none;
            color: var(--text-primary);
            transition: var(--transition-fast);
        }
        
        .cart-item-name:hover {
            color: var(--color-orange);
        }
        
        .cart-item-category {
            font-size: 0.8rem;
            color: var(--color-orange);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .cart-item-qty {
            display: flex;
            align-items: center;
            gap: 12px;
            background: rgba(10, 10, 15, 0.4);
            border: 1px solid var(--border-glass);
            padding: 6px 12px;
            border-radius: 20px;
        }
        
        .qty-btn {
            background: none;
            border: none;
            color: var(--text-primary);
            cursor: pointer;
            font-size: 0.9rem;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: var(--transition-fast);
        }
        
        .qty-btn:hover {
            color: var(--color-orange);
        }
        
        .qty-val {
            font-weight: 600;
            font-size: 0.95rem;
            min-width: 20px;
            text-align: center;
        }
        
        .cart-item-price {
            font-size: 1.25rem;
            font-weight: 700;
            min-width: 80px;
            text-align: right;
        }
        
        .btn-remove-item {
            background: none;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            font-size: 1.1rem;
            transition: var(--transition-fast);
            padding: 8px;
        }
        
        .btn-remove-item:hover {
            color: var(--color-red);
            transform: scale(1.1);
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
        
        .btn-checkout {
            width: 100%;
            padding: 14px;
            border-radius: 30px;
            font-weight: 700;
            font-size: 1rem;
            text-align: center;
        }
        
        @media (max-width: 992px) {
            .cart-grid {
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

    <!-- Cart Layout -->
    <div class="container cart-wrapper">
        <div class="cart-grid">
            <!-- Left: Cart Items -->
            <div class="cart-items-panel">
                <h2 class="cart-title">Giỏ Hàng Của Bạn</h2>
                
                <!-- Mock Cart Items List -->
                <div class="cart-item">
                    <img class="cart-item-img" src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=150&q=80" alt="Double Cheese Burger">
                    <div class="cart-item-info">
                        <span class="cart-item-category">Burgers</span>
                        <div><a href="#" class="cart-item-name">Double Cheese Burger</a></div>
                    </div>
                    <div class="cart-item-qty">
                        <button class="qty-btn"><i class="fa-solid fa-minus"></i></button>
                        <span class="qty-val">1</span>
                        <button class="qty-btn"><i class="fa-solid fa-plus"></i></button>
                    </div>
                    <div class="cart-item-price">$5.99</div>
                    <button class="btn-remove-item"><i class="fa-solid fa-trash-can"></i></button>
                </div>
                
                <div class="cart-item">
                    <img class="cart-item-img" src="https://images.unsplash.com/photo-1579954115545-a95591f28bfc?auto=format&fit=crop&w=150&q=80" alt="Fresh Strawberry Milkshake">
                    <div class="cart-item-info">
                        <span class="cart-item-category">Drinks</span>
                        <div><a href="#" class="cart-item-name">Fresh Strawberry Milkshake</a></div>
                    </div>
                    <div class="cart-item-qty">
                        <button class="qty-btn"><i class="fa-solid fa-minus"></i></button>
                        <span class="qty-val">2</span>
                        <button class="qty-btn"><i class="fa-solid fa-plus"></i></button>
                    </div>
                    <div class="cart-item-price">$5.98</div>
                    <button class="btn-remove-item"><i class="fa-solid fa-trash-can"></i></button>
                </div>
            </div>
            
            <!-- Right: Summary Panel -->
            <div class="summary-panel">
                <h3 class="summary-title">Tóm Tắt Đơn Hàng</h3>
                <div class="summary-row">
                    <span>Tạm tính</span>
                    <span>$11.97</span>
                </div>
                <div class="summary-row">
                    <span>Phí vận chuyển</span>
                    <span>$1.50</span>
                </div>
                <div class="summary-row">
                    <span>Giảm giá</span>
                    <span>-$0.00</span>
                </div>
                <div class="summary-row total">
                    <span>Tổng cộng</span>
                    <span>$13.47</span>
                </div>
                
                <a href="${pageContext.request.contextPath}/pages/checkout.jsp" class="btn-primary btn-checkout">Tiến Hành Thanh Toán</a>
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
