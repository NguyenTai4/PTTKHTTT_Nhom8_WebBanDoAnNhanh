<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- If the request comes directly to index.jsp without going through HomeServlet, redirect to /home to load data --%>
<c:if test="${empty foodList}">
    <c:redirect url="/home"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteSync | Món Ăn Nhanh, Giao Siêu Tốc</title>
    
    <!-- Custom Style Sheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <!-- Header / Navigation Bar -->
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
            
            <div class="nav-actions">
                <button class="btn-icon" title="Tìm kiếm">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </button>
                <button class="btn-icon" style="position: relative;" title="Giỏ hàng" onclick="window.location.href='${pageContext.request.contextPath}/pages/cart.jsp'">
                    <i class="fa-solid fa-basket-shopping"></i>
                    <span style="position: absolute; top: -4px; right: -4px; background: var(--color-orange); color: white; border-radius: 50%; width: 18px; height: 18px; font-size: 0.7rem; display: flex; align-items: center; justify-content: center; font-weight: 700;">3</span>
                </button>
                <a href="${pageContext.request.contextPath}/pages/login.jsp" class="btn-primary">Đăng Nhập</a>
            </div>
        </div>
    </header>

    <!-- Hero Section -->
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

    <!-- Menu Section -->
    <section id="menu" class="menu-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Thực Đơn <span>Đặc Sắc</span></h2>
                <p class="section-subtitle">Lựa chọn các món ăn ngon nhất được chế biến bởi những đầu bếp chuyên nghiệp của chúng tôi.</p>
            </div>
            
            <!-- Category Filter Tabs -->
            <div class="filter-tabs">
                <button class="tab-btn active" onclick="filterMenu('all', this)">Tất Cả</button>
                <button class="tab-btn" onclick="filterMenu('Burgers', this)">Burgers</button>
                <button class="tab-btn" onclick="filterMenu('Pizzas', this)">Pizzas</button>
                <button class="tab-btn" onclick="filterMenu('Sides', this)">Món Phụ</button>
                <button class="tab-btn" onclick="filterMenu('Drinks', this)">Đồ Uống</button>
                <button class="tab-btn" onclick="filterMenu('Desserts', this)">Tráng Miệng</button>
            </div>
            
            <!-- Menu Grid -->
            <div class="menu-grid" id="menu-grid">
                <c:forEach var="food" items="${foodList}">
                    <div class="food-card" data-category="${food.category}">
                        <div class="card-img-wrapper" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/pages/detail.jsp'">
                            <span class="card-badge">${food.category}</span>
                            <img class="card-img" src="${food.imageUrl}" alt="${food.name}">
                            <div class="card-overlay"></div>
                        </div>
                        <div class="card-body">
                            <h3 class="card-title" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/pages/detail.jsp'">${food.name}</h3>
                            <p class="card-desc">${food.description}</p>
                            <div class="card-footer">
                                <div class="price-tag">
                                    <span>$</span>${food.price}
                                </div>
                                <button class="btn-card-order" title="Thêm vào giỏ hàng">
                                    <i class="fa-solid fa-plus"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Footer -->
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

    <!-- Client-side javascript -->
    <script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
