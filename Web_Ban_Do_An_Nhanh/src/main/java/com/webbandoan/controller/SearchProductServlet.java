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
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String keyword = request.getParameter("keyword");
        
        if ("suggest".equals(action)) {
            // 12.2. getSuggestions(partial)
            if (keyword != null && !keyword.trim().isEmpty()) {
                // 12.4. return nameList
                List<String> suggestions = productDAO.findSuggestedNames(keyword);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < suggestions.size(); i++) {
                    json.append("\"").append(suggestions.get(i).replace("\"", "\\\"")).append("\"");
                    if (i < suggestions.size() - 1) json.append(",");
                }
                json.append("]");
                // 12.5. return suggestions
                response.getWriter().write(json.toString());
            } else {
                response.getWriter().write("[]");
            }
            return;
        } else if ("clear".equals(action)) {
            // 10.5. getDefaultProducts()
            List<Product> products = productDAO.queryDefaultProducts();
            // 10.8. return products
            request.setAttribute("products", products);
            request.getRequestDispatcher("/pages/search_results.jsp").forward(request, response);
            return;
        } else if ("filter".equals(action)) {
            String category = request.getParameter("category");
            String priceParam = request.getParameter("price");
            int minPrice = 0;
            int maxPrice = Integer.MAX_VALUE;
            if (priceParam != null && priceParam.contains("-")) {
                String[] parts = priceParam.split("-");
                try {
                    minPrice = Integer.parseInt(parts[0]);
                    maxPrice = Integer.parseInt(parts[1]);
                } catch (Exception e) {}
            }
            // 10.11. filterProducts(criteria)
            List<Product> products = productDAO.queryProducts(category, minPrice, maxPrice, 0, 20);
            if (products == null || products.isEmpty()) {
                // 10.16. return emptyList
                request.setAttribute("errorFilter", "Không tìm thấy sản phẩm phù hợp.");
            }
            request.setAttribute("products", products);
            request.getRequestDispatcher("/pages/search_results.jsp").forward(request, response);
            return;
        }
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            // 12.8. processSearch(keyword, page)
            List<Product> products = productDAO.getProducts(keyword, 1);
            // 12.10. return pageResult
            request.setAttribute("products", products);
        } else {
            List<Product> products = productDAO.queryDefaultProducts();
            request.setAttribute("products", products);
        }
        request.getRequestDispatcher("/pages/search_results.jsp").forward(request, response);
    }
}