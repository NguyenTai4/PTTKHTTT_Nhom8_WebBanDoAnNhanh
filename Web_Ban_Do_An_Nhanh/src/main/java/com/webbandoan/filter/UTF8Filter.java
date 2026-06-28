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
            throws java.io.IOException, ServletException {
        
        // Enforce UTF-8 request parameter parsing
        request.setCharacterEncoding("UTF-8");
        
        // Enforce UTF-8 response content delivery
        response.setCharacterEncoding("UTF-8");
        
        // Synchronize 'user' and 'loggedUser' attributes in the session
        if (request instanceof javax.servlet.http.HttpServletRequest) {
            javax.servlet.http.HttpServletRequest httpRequest = (javax.servlet.http.HttpServletRequest) request;
            javax.servlet.http.HttpSession session = httpRequest.getSession(false);
            if (session != null) {
                Object user = session.getAttribute("user");
                Object loggedUser = session.getAttribute("loggedUser");
                if (user != null && loggedUser == null) {
                    session.setAttribute("loggedUser", user);
                } else if (loggedUser != null && user == null) {
                    session.setAttribute("user", loggedUser);
                }
            }
        }
        
        // Pass the request along the filter chain
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup resources if needed
    }
}
