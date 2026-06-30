<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
<head>
    <title>BiteSync | Khuyến mãi</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/promotion.css">
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
    .no-voucher {
      display: flex;
      justify-content: center;
      align-items: center;
      max-width: 500px;
      width: 90%;
      min-height: 120px;
      margin: 20px auto;
      padding: 20px;
      background: rgba(255, 94, 54, 0.12);
      color: #ffd8cc;
      border: 1px solid rgba(255, 94, 54, 0.35);
      border-radius: 12px;
      font-size: 22px;
      font-weight: bold;
      text-align: center;
      box-sizing: border-box;
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
      <li><a href="${pageContext.request.contextPath}/search">Thực Đơn</a></li>
      <li><a href="#about">Về Chúng Tôi</a></li>
      <li><a href="#contact">Liên Hệ</a></li>
      <li><a href="${pageContext.request.contextPath}/promotion">Khuyến mãi</a></li>

    </ul>

    <div class="nav-actions" style="display: flex; align-items: center; gap: 15px;">
      <!-- 12.7 inputSearchKeyword(keyword, page) -->
      <form action="${pageContext.request.contextPath}/search" method="GET" style="position: relative; display: flex; align-items: center;">
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
<section class="hero">
  <h1 class="voucher-page-title">DANH SÁCH VOUCHER GIẢM GIÁ</h1>
  <div class="voucher-grid">
<c:choose>
    <c:when test="${not empty vouchers}">
  <c:forEach var="v" items="${vouchers}">
  <div class="voucher-card">
    <div class="voucher-discount">
      <fmt:setLocale value="vi_VN"/>
      <fmt:formatNumber value="${v.discountAmount}" type="number" groupingUsed="true"/>đ
    </div>
    <img src="${v.voucherImage}" alt="${v.voucherName}" class="voucher-image"/>
    <div class="voucher-body">
      <h3 class="voucher-name">${v.voucherName}</h3>
      <a href="#" class="voucher-detail-btn">Copy</a>
    </div>
  </div>
  </c:forEach>
    </c:when>
  <c:otherwise>
      <p class="no-voucher">Xin lỗi, Hiện chưa có voucher. Xin vui lòng thử lại</p>
  </c:otherwise>
</c:choose>

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
          <li><a href="${pageContext.request.contextPath}/search">Thực Đơn</a></li>
          <li><a href="#about">Về Chúng Tôi</a></li>
          <li><a href="#contact">Liên Hệ</a></li>
          <li><a href="#promotion">Khuyến mãi</a></li>
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

  function fetchSuggestions(partial) {
    // 12.1. typeKeyword(partialText)
    let box = document.getElementById("suggestionBox");
    if (!partial || partial.trim() === "") {
      box.style.display = "none";
      return;
    }

    fetch("${pageContext.request.contextPath}/search?action=suggest&partial=" + encodeURIComponent(partial))
            .then(response => response.json())
            .then(data => {
              box.innerHTML = "";
              if (data.length > 0) {
                // 12.6. renderDropdown(suggestions)
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
                    // 12.7. inputSearchKeyword(keyword, page)
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

  document.addEventListener("click", function(e) {
    if (!e.target.closest(".header-search-form")) {
      const box = document.getElementById("suggestionBox");
      if(box) box.style.display = "none";
    }
  });
</script>
</body>
</html>
