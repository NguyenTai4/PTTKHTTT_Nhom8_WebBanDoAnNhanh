<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sản phẩm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .search-container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; }
        .product-card { border: 1px solid #ddd; border-radius: 8px; padding: 15px; text-align: center; }
        .product-card img { max-width: 100%; height: 200px; object-fit: cover; border-radius: 4px; }
        .price { color: #e74c3c; font-weight: bold; font-size: 1.2em; }
        .filter-form { margin-bottom: 20px; display: flex; gap: 10px; align-items: center; }
        .pagination { display: flex; justify-content: center; gap: 5px; margin-top: 20px; }
        .page-link { padding: 8px 12px; border: 1px solid #ddd; text-decoration: none; color: #333; border-radius: 4px; }
        .page-link.active { background: var(--color-orange); color: white; border-color: var(--color-orange); }
    </style>
</head>
<body>
    <jsp:include page="/views/layout/header.jsp" />

    <!-- 10.2. Hiển thị trang sản phẩm / 12.11. return pageResult -->
    <div class="search-container">
        <h2>Danh sách sản phẩm</h2>
        
        <form action="${pageContext.request.contextPath}/search" method="get" class="filter-form">
            <input type="hidden" name="page" value="1">
            <input type="text" name="q" value="${query}" placeholder="Nhập từ khóa lọc..." style="padding: 8px; border-radius: 4px; border: 1px solid #ccc; width: 300px;">
            <button type="submit" class="btn btn-primary">Áp dụng</button>
            <a href="${pageContext.request.contextPath}/search?action=clear" class="btn btn-secondary">Xóa lọc</a>
        </form>

        <c:choose>
            <c:when test="${emptyList}">
                <!-- 10.17. Hiển thị thông báo "Không tìm thấy" / 12.13. return emptyResult -->
                <!-- 12.14. renderErrorMsg() -->
                <p>Không tìm thấy sản phẩm nào phù hợp với từ khóa/bộ lọc.</p>
            </c:when>
            <c:otherwise>
                <div class="product-grid">
                    <c:choose>
                        <c:when test="${not empty query}">
                            <!-- 10.15. Hiển thị DS SP phù hợp / 12.12. renderProductList(pageResult) -->
                        </c:when>
                        <c:otherwise>
                            <!-- 10.9. Hiển thị DS SP mặc định / 12.12. renderProductList(pageResult) -->
                        </c:otherwise>
                    </c:choose>
                    
                    <c:forEach var="product" items="${searchResults}">
                        <div class="product-card">
                            <img src="${product.image}" alt="${product.name}">
                            <h3>${product.name}</h3>
                            <p class="price">${product.price} VND</p>
                            <p>${product.brand}</p>
                            <button class="btn btn-primary"><i class="fas fa-cart-plus"></i> Thêm vào giỏ</button>
                        </div>
                    </c:forEach>
                </div>

                <!-- Phân trang -->
                <div class="pagination">
                    <c:set var="pageNum" value="${not empty currentPage ? currentPage : 1}" />
                    <c:if test="${pageNum > 1}">
                        <a href="?q=${query}&page=${pageNum - 1}" class="page-link">&laquo; Trước</a>
                    </c:if>
                    
                    <a href="?q=${query}&page=${pageNum}" class="page-link active">${pageNum}</a>
                    
                    <a href="?q=${query}&page=${pageNum + 1}" class="page-link">Sau &raquo;</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <jsp:include page="/views/layout/footer.jsp" />
</body>
</html>
