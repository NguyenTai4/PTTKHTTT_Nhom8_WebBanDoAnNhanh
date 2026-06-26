<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Đơn Hàng #${order.id} - BiteSync</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .details-page { padding-top: 120px; padding-bottom: 60px; min-height: 80vh; }
        .details-container { max-width: 800px; margin: 0 auto; background: var(--bg-glass); border: 1px solid var(--border-glass); border-radius: 16px; padding: 40px; backdrop-filter: blur(12px); }
        .page-header { border-bottom: 1px solid var(--border-glass); padding-bottom: 20px; margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center; }
        .page-header h2 { color: var(--color-orange); font-size: 2rem; margin: 0; display: flex; align-items: center; gap: 12px; }
        .btn-back { display: inline-flex; align-items: center; gap: 8px; background: rgba(255, 255, 255, 0.1); color: var(--text-primary); padding: 8px 16px; border-radius: 8px; text-decoration: none; font-weight: 600; transition: var(--transition-fast); }
        .btn-back:hover { background: rgba(255, 255, 255, 0.2); }
        
        .info-box { background: rgba(10, 10, 15, 0.6); border: 1px solid var(--border-glass); padding: 24px; border-radius: 12px; margin-bottom: 40px; display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .info-item { display: flex; flex-direction: column; gap: 5px; }
        .info-label { color: var(--text-muted); font-size: 0.9rem; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; }
        .info-value { color: var(--text-primary); font-size: 1.1rem; font-weight: 500; }
        .info-value strong { color: var(--color-orange); font-size: 1.3rem; }
        
        /* 9.5 displayOrderStatus() - Neon Timeline */
        .timeline-section { text-align: center; padding: 30px 0; }
        .timeline-section h3 { color: var(--text-primary); margin-bottom: 40px; font-size: 1.5rem; }
        .timeline { display: flex; justify-content: space-between; position: relative; max-width: 600px; margin: 0 auto; }
        
        /* Progress line background */
        .timeline::before { content: ''; position: absolute; top: 25px; left: 10%; width: 80%; height: 4px; background: rgba(255,255,255,0.1); z-index: 1; border-radius: 2px; }
        
        /* Active progress line logic based on status */
        .timeline.status-SHIPPING::after { content: ''; position: absolute; top: 25px; left: 10%; width: 40%; height: 4px; background: var(--color-orange); z-index: 2; border-radius: 2px; box-shadow: 0 0 10px var(--color-orange); }
        .timeline.status-DELIVERED::after { content: ''; position: absolute; top: 25px; left: 10%; width: 80%; height: 4px; background: #2ecc71; z-index: 2; border-radius: 2px; box-shadow: 0 0 10px #2ecc71; }
        
        .step { position: relative; z-index: 3; flex: 1; display: flex; flex-direction: column; align-items: center; gap: 15px; }
        .step-icon { width: 50px; height: 50px; display: flex; align-items: center; justify-content: center; background: #1a1a24; border: 4px solid #2a2a35; color: var(--text-muted); border-radius: 50%; font-size: 1.2rem; transition: all 0.4s ease; }
        .step-label { font-size: 0.95rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px; }
        
        /* Active states */
        .step.active .step-icon { background: var(--gradient-accent); border-color: rgba(255, 94, 54, 0.3); color: white; box-shadow: 0 0 15px rgba(255, 94, 54, 0.5); }
        .step.active .step-label { color: var(--color-orange); }
        
        .step.completed .step-icon { background: #2ecc71; border-color: rgba(46, 204, 113, 0.3); color: white; box-shadow: 0 0 15px rgba(46, 204, 113, 0.5); }
        .step.completed .step-label { color: #2ecc71; }
        
        @media (max-width: 600px) {
            .info-box { grid-template-columns: 1fr; }
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

<section class="details-page">
    <div class="details-container">
        <div class="page-header">
            <h2><i class="fa-solid fa-receipt"></i> Chi Tiết # ${order.id}</h2>
            <a href="${pageContext.request.contextPath}/track-order" class="btn-back"><i class="fa-solid fa-angle-left"></i> Quay lại</a>
        </div>
        
        <div class="info-box">
            <div class="info-item">
                <span class="info-label">Người Nhận</span>
                <span class="info-value"><i class="fa-regular fa-user" style="margin-right: 8px;"></i>${order.receiveName}</span>
            </div>
            <div class="info-item">
                <span class="info-label">Điện Thoại</span>
                <span class="info-value"><i class="fa-solid fa-phone" style="margin-right: 8px;"></i>${order.phoneNumber}</span>
            </div>
            <div class="info-item" style="grid-column: 1 / -1;">
                <span class="info-label">Địa Chỉ Giao Hàng</span>
                <span class="info-value"><i class="fa-solid fa-location-dot" style="margin-right: 8px; color: #e74c3c;"></i>${order.shippingAddress}</span>
            </div>
            <div class="info-item">
                <span class="info-label">Thanh Toán</span>
                <span class="info-value"><i class="fa-brands fa-cc-visa" style="margin-right: 8px;"></i>${order.paymentMethod /* fixed */}</span>
            </div>
            <div class="info-item">
                <span class="info-label">Tổng Cộng</span>
                <span class="info-value"><strong>$<fmt:formatNumber value="${order.finalAmount}" pattern="#,##0.00" /></strong></span>
            </div>
        </div>

        <!-- 9.12 Hiển thị tiến trình chi tiết -->
        <div class="timeline-section" style="display:none;">
            <h3>Tiến Trình Giao Hàng</h3>
            <div class="timeline status-${order.orderStatus}">
                
                <!-- Step 1: PENDING -->
                <c:set var="step1Class" value="${(order.orderStatus == 'PENDING' || order.orderStatus == 'SHIPPING' || order.orderStatus == 'DELIVERED') ? 'completed' : ''}" />
                <c:if test="${order.orderStatus == 'PENDING'}"><c:set var="step1Class" value="active" /></c:if>
                
                <div class="step ${step1Class}">
                    <div class="step-icon"><i class="fa-solid fa-clipboard-check"></i></div>
                    <div class="step-label">Đã Đặt Hàng</div>
                </div>
                
                <!-- Step 2: SHIPPING -->
                <c:set var="step2Class" value="${(order.orderStatus == 'DELIVERED') ? 'completed' : ''}" />
                <c:if test="${order.orderStatus == 'SHIPPING'}"><c:set var="step2Class" value="active" /></c:if>
                
                <div class="step ${step2Class}">
                    <div class="step-icon"><i class="fa-solid fa-truck-fast"></i></div>
                    <div class="step-label">Đang Giao</div>
                </div>
                
                <!-- Step 3: DELIVERED -->
                <c:set var="step3Class" value="" />
                <c:if test="${order.orderStatus == 'DELIVERED'}"><c:set var="step3Class" value="completed" /></c:if>
                
                <div class="step ${step3Class}">
                    <div class="step-icon"><i class="fa-solid fa-house-circle-check"></i></div>
                    <div class="step-label">Thành Công</div>
                </div>
            </div>
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

<!-- commit 5 -->