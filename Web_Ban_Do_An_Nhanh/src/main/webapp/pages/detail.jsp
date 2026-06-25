<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteSync | Chi Tiết Món Ăn</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">

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
            height: 400px; /* Cố định chiều cao khung ảnh cho cân đối */
        }

        .detail-img {
            width: 100%;
            height: 100%;
            object-fit: cover; /* Đảm bảo ảnh không bị méo */
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

        /* POPUP TOAST THÔNG BÁO THÀNH CÔNG */
        .toast-notification {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: rgba(20, 20, 30, 0.95);
            border: 1px solid var(--color-orange);
            color: #fff;
            padding: 16px 24px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            gap: 12px;
            z-index: 9999;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(8px);
            transform: translateY(100px);
            opacity: 0;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.27, 1.55);
            pointer-events: none;
        }

        .toast-notification.show {
            transform: translateY(0);
            opacity: 1;
            pointer-events: auto;
        }

        .toast-icon {
            color: var(--color-orange);
            font-size: 1.3rem;
        }

        .toast-text {
            font-weight: 600;
            font-size: 0.95rem;
        }

        @media (max-width: 992px) {
            .detail-grid {
                grid-template-columns: 1fr;
                padding: 32px;
                gap: 40px;
            }
            .detail-img-wrapper {
                height: 300px;
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

        <div class="nav-actions" style="display: flex; align-items: center; gap: 15px;">
            <button class="btn-icon" title="Tìm kiếm">
                <i class="fa-solid fa-magnifying-glass"></i>
            </button>

            <button class="btn-icon" style="position: relative;" title="Giỏ hàng" onclick="window.location.href='${pageContext.request.contextPath}/cart'">
                <i class="fa-solid fa-basket-shopping"></i>
                <span id="cart-badge-count" style="position: absolute; top: -4px; right: -4px; background: var(--color-orange); color: white; border-radius: 50%; width: 18px; height: 18px; font-size: 0.7rem; display: flex; align-items: center; justify-content: center; font-weight: 700;">
                    ${not empty sessionScope.cartSize ? sessionScope.cartSize : 0}
                </span>
            </button>

            <%-- ĐỒNG BỘ HIỂN THỊ TRẠNG THÁI ĐĂNG NHẬP --%>
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

<div class="container detail-wrapper">
    <a href="${pageContext.request.contextPath}/home" class="back-link">
        <i class="fa-solid fa-arrow-left"></i> Quay lại thực đơn
    </a>

    <div class="detail-grid">
        <div class="detail-img-wrapper">
            <img class="detail-img" src="${food.imageUrl}" alt="${food.name}">
        </div>

        <div class="detail-info">
            <span class="detail-category">${food.categoryName}</span>
            <h1 class="detail-name">${food.name}</h1>
            <div class="detail-price">
                <span>$</span>${food.price}
            </div>

            <p class="detail-desc">${food.description}</p>

            <form action="${pageContext.request.contextPath}/cart" method="POST" class="action-row" onsubmit="ajaxAddToCart(event, this)">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="foodId" value="${food.id}">

                <div class="quantity-selector">
                    <button type="button" class="qty-btn" onclick="let q=document.getElementById('qty'); if(q.value>1) q.value--;"><i class="fa-solid fa-minus"></i></button>

                    <input type="number" id="qty" name="quantity" value="1" readonly style="width: 30px; background: transparent; border: none; color: white; text-align: center; font-weight: 700; font-size: 1.1rem; outline: none;">

                    <button type="button" class="qty-btn" onclick="document.getElementById('qty').value++;"><i class="fa-solid fa-plus"></i></button>
                </div>

                <button type="submit" class="btn-primary btn-add-cart">
                    <i class="fa-solid fa-basket-shopping"></i> Thêm Vào Giỏ Hàng
                </button>
            </form>
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

<div id="cart-toast" class="toast-notification">
    <i class="fa-solid fa-circle-check toast-icon"></i>
    <span class="toast-text">Đã thêm món ăn vào giỏ hàng thành công!</span>
</div>

<script src="${pageContext.request.contextPath}/static/js/main.js"></script>

<script>
    // XỬ LÝ GỬI FORM NGẦM QUA AJAX FETCH API
    function ajaxAddToCart(event, formElement) {
        event.preventDefault();

        const formData = new FormData(formElement);
        const params = new URLSearchParams();
        for (const pair of formData) {
            params.append(pair[0], pair[1]);
        }

        const URL = formElement.getAttribute('action');

        fetch(URL, {
            method: 'POST',
            body: params,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        })
            .then(response => {
                if (response.status === 401) {
                    alert("Vui lòng đăng nhập để thực hiện tính năng này!");
                    window.location.href = "${pageContext.request.contextPath}/pages/login.jsp";
                    return;
                }

                if (response.ok) {
                    // Đọc dữ liệu số lượng trả về từ Server dạng Text
                    return response.text();
                } else {
                    throw new Error("Error");
                }
            })
            .then(totalQty => {
                if (totalQty) {
                    // CẬP NHẬT SỐ LƯỢNG MỚI LÊN BADGE HEADER NGAY LẬP TỨC
                    document.getElementById('cart-badge-count').innerText = totalQty;

                    showSuccessToast(); // Hiện popup thông báo thành công
                }
            })
            .catch(error => {
                console.error("Error:", error);
                alert("Có lỗi xảy ra khi thêm vào giỏ hàng!");
            });
    }

    // ĐIỀU KHIỂN POPUP HIỂN THỊ TRONG 3 GIÂY
    function showSuccessToast() {
        const toast = document.getElementById('cart-toast');
        toast.classList.add('show');

        setTimeout(() => {
            toast.classList.remove('show');
        }, 3000);
    }
</script>
</body>
</html>