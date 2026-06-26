<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Theo Dõi Đơn Hàng - BiteSync</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .tracking-page { padding-top: 120px; padding-bottom: 60px; min-height: 80vh; }
        .tracking-container { max-width: 900px; margin: 0 auto; background: var(--bg-glass); border: 1px solid var(--border-glass); border-radius: 16px; padding: 40px; backdrop-filter: blur(12px); }
        .page-header { border-bottom: 1px solid var(--border-glass); padding-bottom: 20px; margin-bottom: 30px; }
        .page-header h2 { color: var(--color-orange); font-size: 2rem; margin-bottom: 10px; display: flex; align-items: center; gap: 12px; }
        .page-header p { color: var(--text-secondary); font-size: 1.1rem; }
        
        .order-list { list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; gap: 16px; }
        .order-item { background: rgba(10, 10, 15, 0.6); border: 1px solid var(--border-glass); border-radius: 12px; padding: 24px; display: flex; justify-content: space-between; align-items: center; transition: var(--transition-fast); }
        .order-item:hover { border-color: var(--color-orange); transform: translateY(-3px); box-shadow: 0 10px 20px rgba(0,0,0,0.2); }
        
        .order-info { flex: 1; }
        .order-id { font-weight: 700; font-size: 1.2rem; color: var(--text-primary); margin-bottom: 8px; }
        .order-date { color: var(--text-secondary); font-size: 0.95rem; margin-bottom: 8px; }
        .order-amount { font-weight: 700; color: var(--color-orange); font-size: 1.1rem; }
        
        .order-status-wrap { display: flex; flex-direction: column; align-items: flex-end; gap: 16px; }
        .status-badge { padding: 8px 16px; border-radius: 30px; font-size: 0.85rem; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; }
        .status-PENDING { background: rgba(243, 156, 18, 0.2); color: #f1c40f; border: 1px solid #f39c12; }
        .status-SHIPPING { background: rgba(52, 152, 219, 0.2); color: #3498db; border: 1px solid #2980b9; box-shadow: 0 0 10px rgba(52, 152, 219, 0.4); }
        .status-DELIVERED { background: rgba(46, 204, 113, 0.2); color: #2ecc71; border: 1px solid #27ae60; box-shadow: 0 0 10px rgba(46, 204, 113, 0.4); }
        .status-CANCELED { background: rgba(231, 76, 60, 0.2); color: #e74c3c; border: 1px solid #c0392b; }
        
        .btn-view { display: inline-flex; align-items: center; gap: 8px; background: transparent; color: var(--text-primary); border: 1px solid var(--border-glass); padding: 10px 20px; border-radius: 8px; text-decoration: none; font-weight: 600; transition: var(--transition-fast); }
        .btn-view:hover { background: var(--gradient-accent); border-color: transparent; }
        
        .empty-orders { text-align: center; padding: 60px 20px; }
        .empty-orders i { font-size: 4rem; color: var(--text-muted); margin-bottom: 20px; }
        .empty-orders p { color: var(--text-secondary); font-size: 1.2rem; margin-bottom: 30px; }
        
        @media (max-width: 768px) {
            .order-item { flex-direction: column; align-items: flex-start; gap: 20px; }
            .order-status-wrap { width: 100%; flex-direction: row; justify-content: space-between; align-items: center; }
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
            <li><a href="${pageContext.request.contextPath}/search">Thực Đơn</a></li>
        </ul>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 15px;">
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

<section class="tracking-page">
    <div class="tracking-container">
        <!-- 9.1 Yêu cầu xem danh sách đơn hàng (qua URL /track-order) -->
        <div class="page-header">
            <h2><i class="fa-solid fa-box-open"></i> Đơn Hàng Của Bạn</h2>
            <p>Xin chào <strong style="color: white;">${sessionScope.loggedUser.fullname}</strong>, theo dõi tiến độ các đơn hàng gần đây của bạn tại đây.</p>
        </div>

        <!-- 9.14 Hiển thị thông báo lỗi (nếu có lỗi truy xuất dữ liệu) -->
        <!-- error handling -->
<c:if test="${not empty error}">
            <div style="background: rgba(231, 76, 60, 0.1); border: 1px solid #e74c3c; color: #e74c3c; padding: 15px; border-radius: 8px; margin-bottom: 20px; text-align: center; font-weight: 600;">
                <i class="fa-solid fa-circle-exclamation"></i> ${error}
            </div>
        </c:if>

        <!-- 9.6 Hiển thị danh sách đơn hàng -->
        <ul class="order-list" style="display:none;">
            <c:choose>
                <c:when test="${not empty orders}">
                    <c:forEach var="order" items="${orders}">
                        <li class="order-item">
                            <div class="order-info">
                                <div class="order-id"><i class="fa-solid fa-hashtag" style="color: var(--text-muted);"></i> ${order.id}</div>
                                <div class="order-date">
                                    <i class="fa-regular fa-clock" style="margin-right: 5px;"></i> Đặt lúc: <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </div>
                                <div class="order-amount">
                                    <i class="fa-solid fa-money-bill-wave" style="margin-right: 5px;"></i> Tổng tiền: $<fmt:formatNumber value="${order.finalAmount}" pattern="#,##0.00" />
                                </div>
                            </div>
                            
                            <div class="order-status-wrap">
                                <div class="status-badge status-${order.orderStatus}">
                                    ${order.orderStatus}
                                </div>
                                
                                <!-- 9.7 Chọn đơn hàng cần theo dõi -->
                                <a href="${pageContext.request.contextPath}/track-order?orderId=${order.id}" class="btn-view">
                                    Chi tiết <i class="fa-solid fa-arrow-right"></i>
                                </a>
                            </div>
                        </li>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-orders">
                        <i class="fa-solid fa-receipt"></i>
                        <p>Bạn chưa có đơn hàng nào trong hệ thống.</p>
                        <a href="${pageContext.request.contextPath}/search" class="btn-primary">Đặt món ngay</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</section>

<footer>
    <div class="container">
        <div class="footer-grid">
            <div class="footer-col footer-about">
                <a href="${pageContext.request.contextPath}/home" class="logo">
                    <i class="fa-solid fa-fire-flame-curved"></i> BiteSync
                </a>
                <p class="footer-desc">Hệ thống cung cấp thức ăn nhanh hàng đầu Việt Nam.</p>
            </div>
            <div class="footer-col">
                <p class="footer-copy">&copy; 2026 BiteSync.</p>
            </div>
        </div>
    </div>
</footer>

</body>
</html>

<!-- commit 4 -->