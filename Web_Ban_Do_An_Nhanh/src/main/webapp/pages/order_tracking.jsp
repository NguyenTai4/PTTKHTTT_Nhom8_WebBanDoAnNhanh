<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Theo dõi đơn hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container { max-width: 1000px; margin: 0 auto; padding: 20px; }
        .table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .table th, .table td { border: 1px solid #ddd; padding: 12px; text-align: center; }
        .table th { background-color: #f4f4f4; }
        .status-badge { padding: 5px 10px; border-radius: 15px; font-size: 0.9em; font-weight: bold; }
        .status-PENDING { background-color: #f1c40f; color: #fff; }
        .status-SHIPPING { background-color: #3498db; color: #fff; }
        .status-DELIVERED { background-color: #2ecc71; color: #fff; }
        .btn-view { padding: 5px 15px; background: #34495e; color: #fff; text-decoration: none; border-radius: 4px; }
        .error-message { color: red; font-weight: bold; padding: 10px; border: 1px solid red; background: #ffeeee; margin-bottom: 20px; }
    </style>
</head>
<body>
    <jsp:include page="/views/layout/header.jsp" />

    <!-- 9.1. Yêu cầu xem danh sách đơn hàng -->
    <div class="container">
        <h2>Lịch sử & Theo dõi đơn hàng</h2>
        
        <c:if test="${not empty errorMessage}">
            <!-- 9.14. Hiển thị thông báo lỗi -->
            <div class="error-message">${errorMessage} - Yêu cầu thử lại sau</div>
        </c:if>

        <c:if test="${empty orders}">
            <p>Bạn chưa có đơn hàng nào.</p>
        </c:if>

        <c:if test="${not empty orders}">
            <!-- 9.6. Hiển thị danh sách đơn hàng -->
            <table class="table">
                <thead>
                    <tr>
                        <th>Mã Đơn Hàng</th>
                        <th>Ngày Đặt</th>
                        <th>Tổng Tiền</th>
                        <th>Trạng Thái</th>
                        <th>Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td>#${order.id}</td>
                            <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                            <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                            <td><span class="status-badge status-${order.status}">${order.status}</span></td>
                            <td>
                                <!-- 9.7. Chọn đơn hàng cần theo dõi -->
                                <a href="order-tracking?id=${order.id}" class="btn-view">Chi tiết</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

    <jsp:include page="/views/layout/footer.jsp" />
</body>
</html>
