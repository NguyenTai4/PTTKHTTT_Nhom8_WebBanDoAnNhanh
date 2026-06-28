<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteSync | Giỏ Hàng</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">

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
            display: block;
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
            display: block;
            text-decoration: none;
        }

        .empty-cart-msg {
            text-align: center;
            padding: 40px 20px;
            color: var(--text-secondary);
        }

        .empty-cart-msg i {
            font-size: 3rem;
            margin-bottom: 15px;
            color: var(--border-glass);
        }

        @media (max-width: 992px) {
            .cart-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

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
        <button class="btn-icon" style="position: relative;" title="Giỏ hàng" onclick="window.location.href='${pageContext.request.contextPath}/cart'">
            <i class="fa-solid fa-basket-shopping"></i>
            <span id="cart-badge-count" style="position: absolute; top: -4px; right: -4px; background: var(--color-orange); color: white; border-radius: 50%; width: 18px; height: 18px; font-size: 0.7rem; display: flex; align-items: center; justify-content: center; font-weight: 700;">
                ${not empty sessionScope.cartSize ? sessionScope.cartSize : 0}
            </span>
        </button>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 15px;">
            <c:choose>
                <c:when test="${not empty sessionScope.loggedUser}">
                    <div class="user-logged-info" style="display: flex; align-items: center; gap: 12px; background: rgba(255, 94, 54, 0.1); padding: 6px 14px; border-radius: 20px; border: 1px solid rgba(255, 94, 54, 0.2);">
                            <span style="color: var(--text-primary); font-weight: 600; font-size: 0.95rem; display: flex; align-items: center; gap: 6px;">
                                <i class="fa-solid fa-circle-user" style="color: var(--color-orange); font-size: 1.2rem;"></i>
                                Hi, ${sessionScope.loggedUser.fullname}
                            </span>
                        <a href="${pageContext.request.contextPath}/logout" title="Đăng xuất" style="color: var(--text-muted); transition: var(--transition-fast); display: flex; align-items: center;" onmouseover="this.style.color='var(--color-orange)'" onmouseout="this.style.color='var(--text-muted)'">
                            <i class="fa-solid fa-right-from-bracket"></i>
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/pages/login.jsp" class="btn-primary">Đăng Nhập</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<div class="container cart-wrapper">
    <div class="cart-grid">
        <div class="cart-items-panel">
            <h2 class="cart-title">Giỏ Hàng Của Bạn</h2>

            <c:if test="${not empty sessionScope.error}">
                <div style="color: var(--color-red); background: rgba(231, 76, 60, 0.1); border: 1px solid rgba(231, 76, 60, 0.2); padding: 12px 16px; border-radius: var(--radius-md); text-align: center; margin-bottom: 20px; font-weight: 500;">
                    <i class="fa-solid fa-circle-exclamation"></i> ${sessionScope.error}
                </div>
                <% session.removeAttribute("error"); %>
            </c:if>

            <c:if test="${empty cartItems}">
                <div class="empty-cart-msg">
                    <i class="fa-solid fa-basket-shopping"></i>
                    <h3>Giỏ hàng của bạn đang trống</h3>
                    <p>Hãy quay lại thực đơn và chọn cho mình những món ăn thật ngon nhé!</p>
                    <a href="${pageContext.request.contextPath}/home" class="btn-primary" style="display: inline-block; margin-top: 15px;">Xem Thực Đơn</a>
                </div>
            </c:if>

            <c:forEach var="item" items="${cartItems}">
                <div class="cart-item">
                    <a href="${pageContext.request.contextPath}/detail?id=${item.foodId}">
                        <img class="cart-item-img" src="${item.food.imageUrl}" alt="${item.food.name}">
                    </a>

                    <div class="cart-item-info">
                        <span class="cart-item-category">${item.food.categoryName}</span>
                        <a href="${pageContext.request.contextPath}/detail?id=${item.foodId}" class="cart-item-name">${item.food.name}</a>
                    </div>

                    <form action="${pageContext.request.contextPath}/cart" method="POST" style="margin: 0;">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="foodId" value="${item.foodId}">
                        <div class="cart-item-qty">
                            <button type="submit" class="qty-btn" name="quantity" value="${item.quantity - 1}">
                                <i class="fa-solid fa-minus"></i>
                            </button>
                            <span class="qty-val">${item.quantity}</span>
                            <button type="submit" class="qty-btn" name="quantity" value="${item.quantity + 1}">
                                <i class="fa-solid fa-plus"></i>
                            </button>
                        </div>
                    </form>

                    <div class="cart-item-price">
                        $${String.format("%.2f", item.food.price * item.quantity)}
                    </div>

                    <form action="${pageContext.request.contextPath}/cart" method="POST" style="margin: 0;">
                        <input type="hidden" name="action" value="remove">
                        <input type="hidden" name="foodId" value="${item.foodId}">
                        <button type="submit" class="btn-remove-item" onclick="return confirm('Bạn có chắc chắn muốn xóa món này khỏi giỏ hàng?');">
                            <i class="fa-solid fa-trash-can"></i>
                        </button>
                    </form>
                </div>
            </c:forEach>
        </div>

        <div class="summary-panel">
            <h3 class="summary-title">Tóm Tắt Đơn Hàng</h3>
            <div class="summary-row">
                <span>Tạm tính</span>
                <span>$${String.format("%.2f", subTotal != null ? subTotal : 0.0)}</span>
            </div>
            <div class="summary-row">
                <span>Phí vận chuyển</span>
                <span>$${(subTotal != null && subTotal > 0) ? "1.50" : "0.00"}</span>
            </div>
            <div class="summary-row">
                <span>Giảm giá</span>
                <span>-$0.00</span>
            </div>
            <div class="summary-row total">
                <span>Tổng cộng</span>
                <span>$${String.format("%.2f", (subTotal != null && subTotal > 0) ? (subTotal + 1.50) : 0.0)}</span>
            </div>

            <c:choose>
                <c:when test="${empty cartItems}">
                    <button class="btn-primary btn-checkout" style="opacity: 0.5; cursor: not-allowed;" disabled>Tiến Hành Thanh Toán</button>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/checkout" class="btn-primary btn-checkout">Tiến Hành Thanh Toán</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<footer>
    <div class="container">
        <div class="footer-bottom" style="border-top: none; padding-top: 0;">
            <p class="footer-copy">&copy; 2026 BiteSync. Tất cả các quyền được bảo lưu.</p>
        </div>
    </div>
</footer>

</body>
</html>