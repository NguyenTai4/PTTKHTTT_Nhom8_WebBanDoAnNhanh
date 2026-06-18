<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteSync | Chi Tiết Món Ăn</title>
    
    <!-- Custom Style Sheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        .detail-wrapper {
            padding-top: 140px;
            padding-bottom: 80px;
        }
        
        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
            background: var(--bg-glass);
            border: 1px solid var(--border-glass);
            border-radius: var(--radius-lg);
            padding: 48px;
            backdrop-filter: blur(12px);
            margin-bottom: 60px;
        }
        
        .detail-img-wrapper {
            border-radius: var(--radius-lg);
            overflow: hidden;
            border: 1px solid var(--border-glass);
            box-shadow: var(--shadow-lg);
        }
        
        .detail-img {
            width: 100%;
            height: auto;
            display: block;
            transition: var(--transition-smooth);
        }
        
        .detail-img:hover {
            transform: scale(1.03);
        }
        
        .detail-category {
            font-size: 0.85rem;
            color: var(--color-orange);
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 12px;
            display: inline-block;
        }
        
        .detail-name {
            font-size: 2.5rem;
            font-weight: 800;
            line-height: 1.2;
            margin-bottom: 16px;
        }
        
        .detail-meta {
            display: flex;
            align-items: center;
            gap: 24px;
            margin-bottom: 24px;
            font-size: 0.9rem;
            color: var(--text-secondary);
        }
        
        .rating-stars {
            color: #ffb800;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        
        .detail-price {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 24px;
            color: var(--text-primary);
        }
        
        .detail-price span {
            font-size: 1.25rem;
            color: var(--color-orange);
            font-weight: 600;
        }
        
        .detail-desc {
            color: var(--text-secondary);
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 32px;
            padding-bottom: 24px;
            border-bottom: 1px solid var(--border-glass);
        }
        
        .action-row {
            display: flex;
            align-items: center;
            gap: 24px;
        }
        
        .quantity-selector {
            display: flex;
            align-items: center;
            gap: 16px;
            background: rgba(10, 10, 15, 0.4);
            border: 1px solid var(--border-glass);
            padding: 10px 20px;
            border-radius: 30px;
        }
        
        .qty-btn {
            background: none;
            border: none;
            color: var(--text-primary);
            cursor: pointer;
            font-size: 1.1rem;
            transition: var(--transition-fast);
        }
        
        .qty-btn:hover {
            color: var(--color-orange);
        }
        
        .qty-val {
            font-weight: 700;
            font-size: 1.1rem;
            min-width: 24px;
            text-align: center;
        }
        
        .btn-add-cart {
            flex-grow: 1;
            padding: 14px 28px;
            border-radius: 30px;
            font-weight: 700;
            font-size: 1rem;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }
        
        .back-link {
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95rem;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 24px;
            transition: var(--transition-fast);
        }
        
        .back-link:hover {
            color: var(--text-primary);
            transform: translateX(-4px);
        }
        
        @media (max-width: 992px) {
            .detail-grid {
                grid-template-columns: 1fr;
                padding: 32px;
                gap: 40px;
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

    <!-- Detail Layout -->
    <div class="container detail-wrapper">
        <a href="${pageContext.request.contextPath}/home" class="back-link">
            <i class="fa-solid fa-arrow-left"></i> Quay lại thực đơn
        </a>
        
        <div class="detail-grid">
            <!-- Left: Image -->
            <div class="detail-img-wrapper">
                <img class="detail-img" src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=600&q=80" alt="Double Cheese Burger">
            </div>
            
            <!-- Right: Info Details -->
            <div class="detail-info">
                <span class="detail-category">Burgers</span>
                <h1 class="detail-name">Double Cheese Burger</h1>
                
                <div class="detail-meta">
                    <div class="rating-stars">
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star-half-stroke"></i>
                        <span style="color: var(--text-secondary); margin-left: 6px; font-weight: 600;">4.8</span>
                    </div>
                    <span>|</span>
                    <span>120 đánh giá</span>
                    <span>|</span>
                    <span style="color: #2ed573; font-weight: 600;"><i class="fa-solid fa-circle-check"></i> Còn hàng</span>
                </div>
                
                <div class="detail-price">
                    <span>$</span>5.99
                </div>
                
                <p class="detail-desc">
                    Món Burger bò phô mai kép nướng trực tiếp trên lửa thơm lừng, phủ 2 lát phô mai cheddar tan chảy béo ngậy, rau xà lách tươi sạch, cà chua mọng nước và sốt đặc trưng BiteSync kẹp giữa vỏ bánh mì nướng mềm mịn. Món ăn hoàn hảo cho các tín đồ burger bò!
                </p>
                
                <div class="action-row">
                    <div class="quantity-selector">
                        <button class="qty-btn"><i class="fa-solid fa-minus"></i></button>
                        <span class="qty-val">1</span>
                        <button class="qty-btn"><i class="fa-solid fa-plus"></i></button>
                    </div>
                    
                    <button class="btn-primary btn-add-cart" onclick="alert('Đã thêm món ăn vào giỏ hàng!');">
                        <i class="fa-solid fa-basket-shopping"></i> Thêm Vào Giỏ Hàng
                    </button>
                </div>
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
