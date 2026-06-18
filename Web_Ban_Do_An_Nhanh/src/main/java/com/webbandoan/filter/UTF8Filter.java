package com.webbandoan.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;

/**
 * Filter to enforce UTF-8 character encoding for all requests and responses.
 * This prevents garbled Vietnamese characters in forms and database queries.
 */
@WebFilter(filterName = "UTF8Filter", urlPatterns = {"/*"})
public class UTF8Filter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        // Enforce UTF-8 request parameter parsing
        request.setCharacterEncoding("UTF-8");
        
        // Enforce UTF-8 response content delivery
        response.setCharacterEncoding("UTF-8");
        
        // Pass the request along the filter chain
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup resources if needed
    }
}
