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
        
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (Exception e) {}
        }
        
        if ("suggest".equals(action)) {
            String partial = request.getParameter("partial");
            // 12.2. getSuggestions(partial)
            if (partial != null && !partial.trim().isEmpty()) {
                // 12.4. return nameList
                List<String> suggestions = productDAO.findSuggestedNames(partial);
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
        } 
        
        int totalPages = 1;
        List<Product> products = null;

        if ("clear".equals(action)) {
            // 10.5. getDefaultProducts()
            products = productDAO.queryDefaultProducts(page);
            totalPages = productDAO.getTotalPagesForDefault();
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
            
            // Limit 12 products per page (ITEMS_PER_PAGE in DAO)
            // 10.11. filterProducts(criteria)
            int offset = (page - 1) * 12; 
            products = productDAO.queryProducts(category, minPrice, maxPrice, offset, 12);
            totalPages = productDAO.getTotalPagesForFilter(category, priceParam);
            
            if (products == null || products.isEmpty()) {
                // 10.16. return emptyList
                request.setAttribute("errorFilter", "Không tìm thấy sản phẩm phù hợp.");
            }
            request.setAttribute("category", category);
            request.setAttribute("price", priceParam);
        } else if (keyword != null && !keyword.trim().isEmpty()) {
            // 12.8. processSearch(keyword, page)
            products = productDAO.getProducts(keyword, page);
            totalPages = productDAO.getTotalPagesForSearch(keyword);
            request.setAttribute("keyword", keyword);
        } else {
            // Truy cập mặc định tương đương clear
            products = productDAO.queryDefaultProducts(page);
            totalPages = productDAO.getTotalPagesForDefault();
        }
        
        // 10.8. return products / 10.14. return filteredList / 12.10. return pageResult
        request.setAttribute("action", action);
        request.setAttribute("products", products);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/pages/search_results.jsp").forward(request, response);
    }
}