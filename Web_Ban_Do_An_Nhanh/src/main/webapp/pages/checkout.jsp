<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
            border: none;
            cursor: pointer;
            transition: var(--transition-fast);
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
                <c:choose>
                    <c:when test="${not empty sessionScope.loggedUser}">
                        <div class="user-logged-info" style="display: flex; align-items: center; gap: 12px; background: rgba(255, 94, 54, 0.1); padding: 6px 14px; border-radius: 20px; border: 1px solid rgba(255, 94, 54, 0.2);">
                            <span style="color: var(--text-primary); font-weight: 600; font-size: 0.95rem; display: flex; align-items: center; gap: 6px;">
                                <i class="fa-solid fa-circle-user" style="color: var(--color-orange); font-size: 1.2rem;"></i>
                                Hi, ${sessionScope.loggedUser.fullname}
                            </span>
                            <a href="${pageContext.request.contextPath}/logout" title="Đăng xuất" style="color: var(--text-muted); display: flex; align-items: center;">
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

    <!-- Checkout Layout -->
    <div class="container checkout-wrapper">
        
        <% if (request.getAttribute("error") != null) { %>
            <div style="color: var(--color-red); background: rgba(231, 76, 60, 0.1); border: 1px solid rgba(231, 76, 60, 0.2); padding: 12px 16px; border-radius: var(--radius-md); text-align: center; margin-bottom: 24px; font-weight: 500;">
                <i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/checkout" method="POST" id="checkout-form">
            <div class="checkout-grid">
                <!-- Left: Checkout Details Form -->
                <div class="checkout-form-panel">
                    <h2 class="checkout-title">Thông Tin Giao Hàng</h2>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="fullname">Họ và tên người nhận</label>
                            <input type="text" id="fullname" name="fullname" class="form-input" placeholder="Nhập họ và tên" value="${sessionScope.loggedUser.fullname}" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Số điện thoại liên hệ</label>
                            <input type="tel" id="phone" name="phone" class="form-input" placeholder="Nhập số điện thoại" value="${sessionScope.loggedUser.phone}" required>
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
                                <span class="payment-title">Chuyển khoản ngân hàng (Paypal)</span>
                                <span class="payment-desc">Thanh toán qua quét mã QR hoặc cổng Paypal giả lập trực tuyến.</span>
                            </div>
                        </label>
                    </div>
                </div>
                
                <!-- Right: Summary Panel -->
                <div class="summary-panel">
                    <h3 class="summary-title">Đơn Hàng Của Bạn</h3>
                    
                    <c:forEach var="item" items="${cartItems}">
                        <div class="summary-row">
                            <span>${item.food.name} x ${item.quantity}</span>
                            <span>$${String.format("%.2f", item.food.price * item.quantity)}</span>
                        </div>
                    </c:forEach>
                    
                    <div class="summary-row" style="border-top: 1px solid var(--border-glass); padding-top: 16px; margin-top: 16px;">
                        <span>Tạm tính</span>
                        <span>$${String.format("%.2f", subTotal)}</span>
                    </div>
                    
                    <div class="summary-row">
                        <span>Phí giao hàng</span>
                        <span>$${String.format("%.2f", shippingFee)}</span>
                    </div>

                    <!-- Live Discount Row -->
                    <div class="summary-row" id="discount-row" style="display: none; color: #2ecc71;">
                        <span>Giảm giá</span>
                        <span id="discount-val">-$0.00</span>
                    </div>
                    
                    <!-- Coupon Input Box -->
                    <div style="margin: 20px 0; border-top: 1px solid var(--border-glass); padding-top: 16px;">
                        <label style="display:block; font-size:0.85rem; color:var(--text-secondary); margin-bottom:8px; font-weight: 500;">Mã giảm giá (Coupon Code)</label>
                        <div style="display:flex; gap:10px;">
                            <input type="text" id="promo-code-input" class="form-input" placeholder="Mã giảm giá (ví dụ: BITESYNC10)" style="padding: 8px 12px; font-size: 0.9rem;">
                            <input type="hidden" name="promo_code" id="applied-promo-code" value="">
                            <button type="button" class="btn-secondary" id="apply-promo-btn" style="padding: 8px 16px; font-size: 0.9rem; border-radius: var(--radius-md); border:1px solid var(--border-glass); background:rgba(255,255,255,0.05); font-weight:600; cursor:pointer; color: var(--text-primary);">Áp dụng</button>
                        </div>
                        <div id="promo-message" style="font-size:0.8rem; margin-top:6px; font-weight:500;"></div>
                    </div>
                    
                    <div class="summary-row total">
                        <span>Tổng thanh toán</span>
                        <span id="total-price-val">$${String.format("%.2f", totalPrice)}</span>
                    </div>
                    
                    <button type="submit" class="btn-primary btn-order">Đặt Hàng Ngay</button>
                </div>
            </div>
        </form>
    </div>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-bottom" style="border-top: none; padding-top: 0;">
                <p class="footer-copy">&copy; 2026 BiteSync. Tất cả các quyền được bảo lưu.</p>
            </div>
        </div>
    </footer>

    <!-- Ajax Script for Promo Code -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            document.getElementById("apply-promo-btn").addEventListener("click", function() {
                var code = document.getElementById("promo-code-input").value;
                if (!code || code.trim() === "") return;

                var xhr = new XMLHttpRequest();
                xhr.open("POST", "${pageContext.request.contextPath}/checkout/apply-promo", true);
                xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                xhr.onload = function() {
                    if (xhr.status === 200) {
                        var res = JSON.parse(xhr.responseText);
                        var msgEl = document.getElementById("promo-message");
                        if (res.valid) {
                            msgEl.style.color = "#2ecc71";
                            msgEl.innerHTML = "<i class='fa-solid fa-circle-check'></i> " + res.message;
                            
                            // Calculate values dynamically
                            var subTotal = parseFloat("${subTotal}");
                            var discountPercent = res.discountPercent;
                            var discountAmount = subTotal * (discountPercent / 100.0);
                            var shippingFee = parseFloat("${shippingFee}");
                            var newTotal = subTotal - discountAmount + shippingFee;
                            
                            document.getElementById("discount-row").style.display = "flex";
                            document.getElementById("discount-val").innerText = "-$" + discountAmount.toFixed(2);
                            document.getElementById("total-price-val").innerText = "$" + newTotal.toFixed(2);
                            document.getElementById("applied-promo-code").value = code;
                        } else {
                            msgEl.style.color = "var(--color-red)";
                            msgEl.innerHTML = "<i class='fa-solid fa-circle-exclamation'></i> " + res.message;
                            
                            // Reset values
                            document.getElementById("discount-row").style.display = "none";
                            document.getElementById("total-price-val").innerText = "$" + parseFloat("${totalPrice}").toFixed(2);
                            document.getElementById("applied-promo-code").value = "";
                        }
                    }
                };
                xhr.send("code=" + encodeURIComponent(code));
            });
        });
    </script>

</body>
</html>
