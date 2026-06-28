package com.webbandoan.controller;

import com.webbandoan.dao.ProductDAO;
import com.webbandoan.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class SearchProductServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 10.1. Truy cập trang sản phẩm (hoặc 10.3. Tương tác với bộ lọc)
        String action = request.getParameter("action");
        String criteria = request.getParameter("q");

        if ("clear".equals(action)) {
            // 10.4. Bấm nút Xóa lọc
            List<Product> products = getDefaultProducts();
            // 10.8. return products
            request.setAttribute("searchResults", products);
        } else if (criteria != null && !criteria.trim().isEmpty()) {
            // 10.10. Bấm nút Áp dụng
            List<Product> products = filterProducts(criteria);
            // 10.14. return products
            
            if (products == null || products.isEmpty()) {
                // 10.16. return emptyList
                request.setAttribute("emptyList", true);
            }
            request.setAttribute("searchResults", products);
        } else {
            // Hiển thị mặc định nếu không có query
            List<Product> products = getDefaultProducts();
            request.setAttribute("searchResults", products);
        }
        
        request.setAttribute("query", criteria);
        request.getRequestDispatcher("/pages/search_results.jsp").forward(request, response);
    }

    // 10.5. getDefaultProducts()
    private List<Product> getDefaultProducts() {
        return productDAO.queryDefaultProducts();
    }

    // 10.11. filterProducts(criteria)
    private List<Product> filterProducts(String criteria) {
        return productDAO.queryProducts(criteria);
    }
}
