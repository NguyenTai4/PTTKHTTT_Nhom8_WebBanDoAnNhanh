<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết đơn hàng #${orderId}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container { max-width: 1000px; margin: 0 auto; padding: 20px; }
        .table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .table th, .table td { border: 1px solid #ddd; padding: 12px; text-align: center; }
        .table th { background-color: #f4f4f4; }
        .product-img { width: 80px; height: 80px; object-fit: cover; border-radius: 4px; }
        .btn-back { padding: 8px 15px; background: #95a5a6; color: #fff; text-decoration: none; border-radius: 4px; display: inline-block; margin-bottom: 20px; }
    </style>
</head>
<body>
    <jsp:include page="/views/layout/header.jsp" />

    <!-- 9.12. Hiển thị tiến trình chi tiết -->
    <div class="container">
        <a href="order-tracking" class="btn-back">&laquo; Quay lại danh sách đơn hàng</a>
        <h2>Chi tiết tiến trình đơn hàng #${orderId}</h2>
        
        <table class="table">
            <thead>
                <tr>
                    <th>Hình ảnh</th>
                    <th>Tên sản phẩm</th>
                    <th>Số lượng</th>
                    <th>Đơn giá</th>
                    <th>Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="total" value="0"/>
                <c:forEach var="item" items="${orderDetails}">
                    <tr>
                        <td><img src="${item.imageUrl}" class="product-img" alt="${item.foodName}"></td>
                        <td>${item.foodName}</td>
                        <td>${item.quantity}</td>
                        <td><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                        <td><fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                    </tr>
                    <c:set var="total" value="${total + (item.price * item.quantity)}"/>
                </c:forEach>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="4" style="text-align: right;">Tổng cộng:</th>
                    <th><fmt:formatNumber value="${total}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></th>
                </tr>
            </tfoot>
        </table>
    </div>

    <jsp:include page="/views/layout/footer.jsp" />
</body>
</html>
