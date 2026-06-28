package com.webbandoan.controller;

import com.google.gson.Gson;
import com.webbandoan.dao.ProductDAO;
import com.webbandoan.model.Food;

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
        String keyword = request.getParameter("q"); // 12.1 typeKeyword(partialText) and 12.7 inputSearchKeyword(keyword, page) implicitly
        String pageStr = request.getParameter("page");
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        if ("suggest".equals(action)) {
            // 12.2 getSuggestions(partial)
            getSuggestions(keyword, response);
        } else {
            // 12.8 processSearch(keyword, page)
            processSearch(keyword, page, request, response);
        }
    }

    // 12.2 getSuggestions(partial)
    private void getSuggestions(String partial, HttpServletResponse response) throws IOException {
        if (partial == null) partial = "";
        
        // 12.3 findSuggestedNames(partial)
        List<String> suggestions = productDAO.findSuggestedNames(partial);
        // 12.4 return nameList (implied from DAO)
        
        // 12.5 return suggestions
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(new Gson().toJson(suggestions));
        out.flush();
    }

    // 12.8 processSearch(keyword, page)
    private void processSearch(String keyword, int page, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (keyword == null) keyword = "";
        
        // 12.9 getProducts(keyword, page)
        List<Food> pageResult = productDAO.getProducts(keyword, page);
        // 12.10 return pageResult (implied from DAO)
        
        // 12.11 return pageResult (forward to UI)
        request.setAttribute("searchResults", pageResult);
        request.setAttribute("query", keyword);
        request.getRequestDispatcher("/pages/search_results.jsp").forward(request, response);
    }
}
