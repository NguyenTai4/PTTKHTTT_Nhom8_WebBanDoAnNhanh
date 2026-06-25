<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${empty foodList}">
    <c:redirect url="/home"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteSync | Món Ăn Nhanh, Giao Siêu Tốc</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* CSS CHO POPUP THÔNG BÁO (TOAST NOTIFICATION) */
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
    </style>
</head>
<body>

<header>
    <div class="container nav-container">
        <a href="${pageContext.request.contextPath}/home" class="logo">
            <i class="fa-solid fa-fire-flame-curved"></i> BiteSync
        </a>

        <ul class="nav-links">
            <li><a href="#home" class="active">Trang Chủ</a></li>
            <li><a href="#menu">Thực Đơn</a></li>
            <li><a href="#about">Về Chúng Tôi</a></li>
            <li><a href="#contact">Liên Hệ</a></li>
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

            <c:choose>
                <c:when test="${not empty sessionScope.loggedUser}">
                    <div class="user-logged-info" style="display: flex; align-items: center; gap: 12px; background: rgba(255, 94, 54, 0.1); padding: 6px 14px; border-radius: 20px; border: 1px solid rgba(255, 94, 54, 0.2);">
                            <span style="color: var(--text-primary); font-weight: 600; font-size: 0.95rem; display: flex; align-items: center; gap: 6px;">
                                <i class="fa-solid fa-circle-user" style="color: var(--color-orange); font-size: 1.2rem;"></i>
                                ${sessionScope.loggedUser.fullname}
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

<section id="home" class="hero">
    <div class="container hero-grid">
        <div class="hero-content">
            <div class="hero-badge">
                <i class="fa-solid fa-truck-fast"></i> Giao hàng siêu tốc trong 15 phút
            </div>
            <h1 class="hero-title">
                Thưởng Thức Nhanh,<br>
                Thỏa Cơn <span>Thèm Ăn!</span>
            </h1>
            <p class="hero-desc">
                Trải nghiệm hương vị thức ăn nhanh cao cấp được chế biến từ nguyên liệu tươi ngon nhất trong ngày. Giao hàng nóng hổi tận cửa nhà bạn.
            </p>
            <div class="hero-buttons">
                <a href="#menu" class="btn-primary">Đặt Ngay</a>
                <a href="#menu" class="btn-secondary">Xem Thực Đơn</a>
            </div>
        </div>

        <div class="hero-image-wrapper">
            <div class="hero-image-circle"></div>
            <img class="hero-image" src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=600&q=80" alt="Delicious Cheese Burger">
        </div>
    </div>
</section>

<section id="menu" class="menu-section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">Thực Đơn <span>Đặc Sắc</span></h2>
            <p class="section-subtitle">Lựa chọn các món ăn ngon nhất được chế biến bởi những đầu bếp chuyên nghiệp của chúng tôi.</p>
        </div>

        <div class="filter-tabs">
            <button class="tab-btn active" onclick="filterMenu('all', this)">Tất Cả</button>
            <button class="tab-btn" onclick="filterMenu('Burgers', this)">Burgers</button>
            <button class="tab-btn" onclick="filterMenu('Pizzas', this)">Pizzas</button>
            <button class="tab-btn" onclick="filterMenu('Sides', this)">Món Phụ</button>
            <button class="tab-btn" onclick="filterMenu('Drinks', this)">Đồ Uống</button>
            <button class="tab-btn" onclick="filterMenu('Desserts', this)">Tráng Miệng</button>
        </div>

        <div class="menu-grid" id="menu-grid">
            <c:forEach var="food" items="${foodList}">
                <div class="food-card" data-category="${food.categoryName}">
                    <div class="card-img-wrapper" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/detail?id=${food.id}'">
                        <span class="card-badge">${food.categoryName}</span>
                        <img class="card-img" src="${food.imageUrl}" alt="${food.name}">
                        <div class="card-overlay"></div>
                    </div>
                    <div class="card-body">
                        <h3 class="card-title" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/detail?id=${food.id}'">${food.name}</h3>
                        <p class="card-desc">${food.description}</p>
                        <div class="card-footer">
                            <div class="price-tag">
                                <span>$</span>${food.price}
                            </div>

                            <form action="${pageContext.request.contextPath}/cart" method="POST" style="margin: 0;" onsubmit="ajaxAddToCart(event, this)">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="foodId" value="${food.id}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn-card-order" title="Thêm vào giỏ hàng">
                                    <i class="fa-solid fa-plus"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<footer>
    <div class="container">
        <div class="footer-grid">
            <div class="footer-col footer-about">
                <a href="${pageContext.request.contextPath}/home" class="logo">
                    <i class="fa-solid fa-fire-flame-curved"></i> BiteSync
                </a>
                <p class="footer-desc">
                    Hệ thống cung cấp thức ăn nhanh hàng đầu Việt Nam, mang bữa ăn chất lượng nhất, nóng hổi nhất đến cho bạn mọi lúc mọi nơi.
                </p>
                <div class="social-links">
                    <button class="btn-icon"><i class="fa-brands fa-facebook-f"></i></button>
                    <button class="btn-icon"><i class="fa-brands fa-instagram"></i></button>
                    <button class="btn-icon"><i class="fa-brands fa-tiktok"></i></button>
                </div>
            </div>

            <div class="footer-col">
                <h4>Liên Kết Nhanh</h4>
                <ul class="footer-links">
                    <li><a href="#home">Trang Chủ</a></li>
                    <li><a href="#menu">Thực Đơn</a></li>
                    <li><a href="#about">Về Chúng Tôi</a></li>
                    <li><a href="#contact">Liên Hệ</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>Hỗ Trợ Khách Hàng</h4>
                <ul class="footer-links">
                    <li><a href="#">Điều Khoản Dịch Vụ</a></li>
                    <li><a href="#">Chính Sách Bảo Mật</a></li>
                    <li><a href="#">Chính Sách Vận Chuyển</a></li>
                    <li><a href="#">Phản Hồi & Đóng Góp</a></li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <p class="footer-copy">&copy; 2026 BiteSync. Tất cả các quyền được bảo lưu.</p>
            <div class="footer-bottom-links">
                <a href="#">Chính sách bảo mật</a>
                <a href="#">Điều khoản sử dụng</a>
            </div>
        </div>
    </div>
</footer>

<div id="cart-toast" class="toast-notification">
    <i class="fa-solid fa-circle-check toast-icon"></i>
    <span class="toast-text">Đã thêm món ăn vào giỏ hàng thành công!</span>
</div>

<script src="${pageContext.request.contextPath}/static/js/main.js"></script>

<script>
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
                    return response.text();
                } else {
                    throw new Error("Error");
                }
            })
            .then(totalQty => {
                if (totalQty) {
                    document.getElementById('cart-badge-count').innerText = totalQty;

                    showSuccessToast();
                }
            })
            .catch(error => {
                console.error("Error:", error);
                alert("Có lỗi xảy ra khi thêm vào giỏ hàng!");
            });
    }
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