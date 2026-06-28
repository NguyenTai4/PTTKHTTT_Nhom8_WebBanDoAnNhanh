package com.webbandoan.controller;

import com.google.gson.Gson;
import com.webbandoan.dao.ProductDAO;
import com.webbandoan.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
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
        String action = request.getParameter("action");
        String criteria = request.getParameter("q");

        if ("suggest".equals(action)) {
            // Xử lý gợi ý
            String partial = criteria != null ? criteria : "";
            List<String> suggestions = getSuggestions(partial);
            // 12.5. return suggestions
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(new Gson().toJson(suggestions));
            out.flush();
            return;
        }

        // 10.1. Truy cập trang sản phẩm (hoặc 10.3. Tương tác với bộ lọc)
        if ("clear".equals(action)) {
            // 10.4. Bấm nút Xóa lọc
            List<Product> products = getDefaultProducts();
            // 10.8. return products
            request.setAttribute("searchResults", products);
        } else if (criteria != null && !criteria.trim().isEmpty()) {
            // Có tìm kiếm và có thể có phân trang
            // 10.10. Bấm nút Áp dụng / 12.7. inputSearchKeyword(keyword, page)
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            // Kết hợp Sequence 10 (filterProducts) và Sequence 12 (processSearch)
            List<Product> pageResult = processSearch(criteria, page);
            // 12.10. return pageResult
            
            if (pageResult == null || pageResult.isEmpty()) {
                // 10.16. return emptyList / 12.13. return emptyResult
                request.setAttribute("emptyList", true);
            }
            request.setAttribute("searchResults", pageResult);
            request.setAttribute("currentPage", page);
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

    // 10.11. filterProducts(criteria) - Giữ lại cho Sequence 10
    private List<Product> filterProducts(String criteria) {
        return productDAO.queryProducts(criteria);
    }

    // 12.2. getSuggestions(partial)
    private List<String> getSuggestions(String partial) {
        List<String> nameList = productDAO.findSuggestedNames(partial);
        // 12.4. return nameList
        return nameList;
    }

    // 12.8. processSearch(keyword, page)
    private List<Product> processSearch(String keyword, int page) {
        List<Product> pageResult = productDAO.getProducts(keyword, page);
        return pageResult;
    }
}
