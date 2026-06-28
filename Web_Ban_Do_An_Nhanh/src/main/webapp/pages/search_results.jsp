<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thực Đơn & Tìm Kiếm - BiteSync</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* CSS Bổ sung riêng cho trang Search */
        .search-page { padding-top: 120px; padding-bottom: 60px; }
        .search-layout { display: flex; gap: 32px; }
        
        /* Sidebar */
        .sidebar { width: 280px; flex-shrink: 0; background: var(--bg-glass); border: 1px solid var(--border-glass); border-radius: 16px; padding: 24px; height: fit-content; backdrop-filter: blur(12px); }
        .sidebar h3 { font-size: 1.25rem; font-weight: 700; margin-bottom: 24px; color: var(--color-orange); }
        .filter-group { margin-bottom: 24px; }
        .filter-group label { display: block; font-weight: 600; margin-bottom: 8px; color: var(--text-secondary); font-size: 0.95rem; }
        .filter-group select { width: 100%; background: rgba(10, 10, 15, 0.8); border: 1px solid var(--border-glass); color: var(--text-primary); padding: 12px; border-radius: 8px; outline: none; font-family: inherit; transition: var(--transition-fast); }
        .filter-group select:focus { border-color: var(--color-orange); }
        .btn-filter { width: 100%; }
        
        /* Main Content */
        .main-content { flex: 1; min-width: 0; } /* min-width 0 allows grid to shrink if needed */
        .search-bar-container { background: var(--bg-glass); border: 1px solid var(--border-glass); border-radius: 16px; padding: 24px; margin-bottom: 32px; backdrop-filter: blur(12px); display: flex; align-items: center; gap: 16px; }
        .search-bar-container form { display: flex; width: 100%; gap: 16px; }
        .search-bar-container input { flex: 1; background: rgba(10, 10, 15, 0.8); border: 1px solid var(--border-glass); color: var(--text-primary); padding: 16px 20px; border-radius: 30px; outline: none; font-family: inherit; font-size: 1rem; transition: var(--transition-fast); }
        .search-bar-container input:focus { border-color: var(--color-orange); box-shadow: 0 0 15px rgba(255, 94, 54, 0.2); }
        
        /* Ghi đè CSS cho lưới ngang 4 dọc 3 */
        .menu-grid { 
            display: grid; 
            grid-template-columns: repeat(4, 1fr) !important; 
            gap: 20px !important; 
        }
        
        .food-card { 
            background: var(--bg-glass); 
            border: 1px solid var(--border-glass); 
            border-radius: var(--radius-lg); 
            overflow: hidden; 
            display: flex; 
            flex-direction: column; 
            height: 100%; 
            transition: var(--transition-smooth); 
            backdrop-filter: blur(12px); 
        }
        
        .card-body { padding: 16px; display: flex; flex-direction: column; flex-grow: 1; }
        .card-title { font-size: 1.1rem; font-weight: 700; margin-bottom: 6px; }
        .card-desc { font-size: 0.8rem; margin-bottom: 15px; }
        .price-tag { font-size: 1.2rem; font-weight: 800; }
        .btn-card-order { width: 35px; height: 35px; }
        
        .empty-state { text-align: center; padding: 60px 20px; background: var(--bg-glass); border: 1px solid var(--border-glass); border-radius: 16px; width: 100%; grid-column: 1 / -1; }
        .empty-state i { font-size: 3rem; color: var(--text-muted); margin-bottom: 16px; }
        .empty-state p { color: var(--text-secondary); font-size: 1.1rem; }
        
        .pagination { display: flex; justify-content: center; gap: 8px; margin-top: 48px; }
        .page-link { width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; background: var(--bg-glass); border: 1px solid var(--border-glass); border-radius: 8px; text-decoration: none; color: var(--text-secondary); font-weight: 600; transition: var(--transition-fast); }
        .page-link:hover { color: var(--text-primary); border-color: var(--text-muted); transform: translateY(-2px); }
        .page-link.active { background: var(--gradient-accent); color: var(--text-primary); border-color: transparent; }
        
        @media (max-width: 992px) {
            .search-layout { flex-direction: column; }
            .sidebar { width: 100%; }
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
            <li><a href="${pageContext.request.contextPath}/search" class="active">Thực Đơn</a></li>
            <li><a href="${pageContext.request.contextPath}/home#about">Về Chúng Tôi</a></li>
            <li><a href="${pageContext.request.contextPath}/home#contact">Liên Hệ</a></li>
        </ul>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 15px;">
            <!-- 12.7 inputSearchKeyword(keyword, page) -->
            <form action="${pageContext.request.contextPath}/search" method="GET" class="header-search-form" style="position: relative; display: flex; align-items: center;">
                <!-- 12.1 typeKeyword(partialText) -->
                <input type="text" name="keyword" id="searchInput" value="${keyword}" placeholder="Tìm món ăn..." autocomplete="off" onkeyup="fetchSuggestions(this.value)" style="padding: 8px 35px 8px 15px; border-radius: 20px; border: 1px solid rgba(255,255,255,0.2); background: rgba(0,0,0,0.2); color: white; width: 220px; outline: none; transition: 0.3s;" onfocus="this.style.width='260px'; this.style.borderColor='var(--color-orange)';" onblur="if(this.value==='') this.style.width='220px'; this.style.borderColor='rgba(255,255,255,0.2)';">
                <button type="submit" style="position: absolute; right: 10px; background: none; border: none; color: var(--text-muted); cursor: pointer;"><i class="fa-solid fa-magnifying-glass"></i></button>
                
                <!-- 12.6 renderDropdown(suggestions) -->
                <ul id="suggestionBox" style="display: none; position: absolute; top: 110%; left: 0; right: 0; background: rgba(30, 30, 40, 0.95); backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; z-index: 1000; list-style: none; padding: 0; margin: 0; box-shadow: 0 4px 15px rgba(0,0,0,0.5); text-align: left; overflow: hidden;">
                </ul>
            </form>

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

<section class="search-page">
    <div class="container search-layout">
        <!-- 10.1 Truy cập trang sản phẩm & 10.2 Hiển thị trang sản phẩm -->
        <div class="sidebar" style="display:none;">
            <h3><i class="fa-solid fa-filter"></i> Lọc Sản Phẩm</h3>
            <!-- 10.3 Tương tác với bộ lọc -->
            <form action="${pageContext.request.contextPath}/search" method="GET">
                <input type="hidden" name="action" value="filter">
                <div class="filter-group">
                    <label>Danh mục</label>
                    <select name="category">
                        <option value="all" ${category == 'all' ? 'selected' : ''}>Tất cả</option>
                        <option value="1" ${category == '1' ? 'selected' : ''}>Burgers</option>
                        <option value="2" ${category == '2' ? 'selected' : ''}>Pizzas</option>
                        <option value="3" ${category == '3' ? 'selected' : ''}>Món phụ</option>
                        <option value="4" ${category == '4' ? 'selected' : ''}>Đồ uống</option>
                        <option value="5" ${category == '5' ? 'selected' : ''}>Tráng miệng</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label>Mức giá</label>
                    <select name="price">
                        <option value="all" ${price == 'all' ? 'selected' : ''}>Tất cả mức giá</option>
                        <option value="0-3.00" ${price == '0-3.00' ? 'selected' : ''}>Dưới $3.00</option>
                        <option value="3.00-7.00" ${price == '3.00-7.00' ? 'selected' : ''}>$3.00 - $7.00</option>
                        <option value="7.00-10.00" ${price == '7.00-10.00' ? 'selected' : ''}>$7.00 - $10.00</option>
                        <option value="10.00+" ${price == '10.00+' ? 'selected' : ''}>Trên $10.00</option>
                    </select>
                </div>
                
                <div style="display: flex; gap: 10px;">
                    <!-- 10.10 Bấm nút Áp dụng -->
                    <button type="submit" class="btn-primary btn-filter" style="flex: 1;">Áp dụng</button>
                    <!-- 10.4 Bấm nút Xóa lọc -->
                    <a href="${pageContext.request.contextPath}/search?action=clear" class="btn-secondary" style="flex: 1; text-align: center; display: inline-block; padding: 10px; background: rgba(255,255,255,0.1); border-radius: 8px; color: white; text-decoration: none; font-weight: 500; transition: 0.3s;">Xóa lọc</a>
                </div>
            </form>
        </div>

        <div class="main-content">
            <!-- Lưới sản phẩm (10.9 Hiển thị DS SP mặc định / 10.15 Hiển thị DS SP phù hợp / 12.12 renderProductList) -->
            <c:if test="${not empty errorFilter}">
                <!-- 10.17 Hiển thị thông báo Không tìm thấy -->
                <div style="background: rgba(231, 76, 60, 0.1); border: 1px solid #e74c3c; color: #e74c3c; padding: 15px; border-radius: 8px; margin-bottom: 20px; text-align: center; font-weight: 600;">
                    <i class="fa-solid fa-circle-exclamation"></i> ${errorFilter}
                </div>
            </c:if>
            
            <c:if test="${not empty errorSearch}">
                <!-- 12.14 renderErrorMsg() -->
                <div style="background: rgba(231, 76, 60, 0.1); border: 1px solid #e74c3c; color: #e74c3c; padding: 15px; border-radius: 8px; margin-bottom: 20px; text-align: center; font-weight: 600;">
                    <i class="fa-solid fa-magnifying-glass-minus"></i> ${errorSearch}
                </div>
            </c:if>

            <div class="menu-grid">
                <c:choose>
                    <c:when test="${not empty products}">
                        <c:forEach var="p" items="${products}">
                            <div class="food-card" data-category="${p.categoryId}">
                                <div class="card-img-wrapper" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/detail?id=${p.id}'">
                                    <span class="card-badge">HOT</span>
                                    <img class="card-img" src="${p.image}" alt="${p.name}" onerror="this.src='https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=80'">
                                    <div class="card-overlay"></div>
                                </div>
                                <div class="card-body">
                                    <h3 class="card-title" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/detail?id=${p.id}'"><c:out value="${p.name}" /></h3>
                                    <p class="card-desc">${p.description}</p>
                                    <div class="card-footer">
                                        <div class="price-tag">
                                            <span>$</span><fmt:formatNumber value="${p.price}" pattern="#,##0.00" />
                                        </div>
                                        <!-- UC6 Add to cart -->
                                        <form action="${pageContext.request.contextPath}/cart" method="POST" style="margin: 0;" onsubmit="ajaxAddToCart(event, this)">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="foodId" value="${p.id}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit" class="btn-card-order" title="Thêm vào giỏ hàng">
                                                <i class="fa-solid fa-plus"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- 12.13 return emptyResult -->
                        <div class="empty-state">
                            <i class="fa-solid fa-magnifying-glass-minus"></i>
                            <p>Không tìm thấy món ăn nào phù hợp với yêu cầu của bạn.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Phân trang -->
            <!-- 12.11 return pageResult -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="?keyword=${keyword}&page=${i}" class="page-link ${currentPage == i ? 'active' : ''}">${i}</a>
                    </c:forEach>
                </div>
            </c:if>
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
            </div>
            <div class="footer-col">
                <h4>Liên Kết Nhanh</h4>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/search">Thực Đơn</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <p class="footer-copy">&copy; 2026 BiteSync. Tất cả các quyền được bảo lưu.</p>
        </div>
    </div>
</footer>

<div id="cart-toast" class="toast-notification" style="position: fixed; bottom: 30px; right: 30px; background: rgba(20, 20, 30, 0.95); border: 1px solid var(--color-orange); color: #fff; padding: 16px 24px; border-radius: 8px; display: flex; align-items: center; gap: 12px; z-index: 9999; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5); transform: translateY(100px); opacity: 0; transition: all 0.4s; pointer-events: none;">
    <i class="fa-solid fa-circle-check toast-icon" style="color: var(--color-orange); font-size: 1.3rem;"></i>
    <span class="toast-text" style="font-weight: 600; font-size: 0.95rem;">Đã thêm món ăn vào giỏ hàng thành công!</span>
</div>

<script>
    function ajaxAddToCart(event, formElement) {
        event.preventDefault();
        const formData = new FormData(formElement);
        const params = new URLSearchParams();
        for (const pair of formData) { params.append(pair[0], pair[1]); }
        const URL = formElement.getAttribute('action');

        fetch(URL, {
            method: 'POST',
            body: params,
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        })
        .then(response => {
            if (response.status === 401) {
                alert("Vui lòng đăng nhập để thực hiện tính năng này!");
                window.location.href = "${pageContext.request.contextPath}/pages/login.jsp";
                return;
            }
            if (response.ok) return response.text();
            throw new Error("Error");
        })
        .then(totalQty => {
            if (totalQty) {
                document.getElementById('cart-badge-count').innerText = totalQty;
                const toast = document.getElementById('cart-toast');
                toast.style.transform = 'translateY(0)';
                toast.style.opacity = '1';
                setTimeout(() => {
                    toast.style.transform = 'translateY(100px)';
                    toast.style.opacity = '0';
                }, 3000);
            }
        })
        .catch(error => console.error("Error:", error));
    }

    function fetchSuggestions(partial) {
        let box = document.getElementById("suggestionBox");
        if (!partial || partial.trim() === "") {
            box.style.display = "none";
            return;
        }
        
        // 12.2 getSuggestions(partial)
        fetch("${pageContext.request.contextPath}/search?action=suggest&partial=" + encodeURIComponent(partial))
            .then(response => response.json())
            .then(data => {
                box.innerHTML = "";
                if (data.length > 0) {
                    box.style.display = "block";
                    data.forEach(item => {
                        let li = document.createElement("li");
                        li.style.padding = "10px 15px";
                        li.style.cursor = "pointer";
                        li.style.color = "white";
                        li.style.borderBottom = "1px solid rgba(255,255,255,0.1)";
                        li.innerHTML = '<i class="fa-solid fa-magnifying-glass" style="color: var(--text-muted); margin-right: 10px;"></i>' + item;
                        
                        li.onmouseover = function() { this.style.background = "rgba(255,255,255,0.1)"; };
                        li.onmouseout = function() { this.style.background = "transparent"; };
                        li.onclick = function() {
                            document.getElementById("searchInput").value = item;
                            box.style.display = "none";
                            // Submit the form immediately after selection
                            document.getElementById("searchInput").closest("form").submit();
                        };
                        box.appendChild(li);
                    });
                } else {
                    box.style.display = "none";
                }
            })
            .catch(e => console.error("Error fetching suggestions:", e));
    }
    
    // Hide dropdown when clicking outside
    document.addEventListener("click", function(e) {
        if (!e.target.closest(".header-search-form")) {
            const box = document.getElementById("suggestionBox");
            if(box) box.style.display = "none";
        }
    });
</script>
</body>
</html>
