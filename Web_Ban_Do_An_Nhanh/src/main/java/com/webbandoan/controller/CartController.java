package com.webbandoan.controller;

import com.webbandoan.dao.CartDAO;
import com.webbandoan.model.CartItem;
import com.webbandoan.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/cart")
public class CartController extends HttpServlet {
    private CartDAO cartDAO = new CartDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        int cartId = cartDAO.getOrCreateCartId(user.getId());
        List<CartItem> cartItems = cartDAO.fetchUserCart(cartId);

        double subTotal = 0;
        for(CartItem item : cartItems) {
            subTotal += item.getFood().getPrice() * item.getQuantity();
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subTotal", subTotal);
        request.getRequestDispatcher("/pages/cart.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        String action = request.getParameter("action");


        if ("add".equals(action)) {
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");

            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("login_required");
                return;
            }

            try {
                int cartId = cartDAO.getOrCreateCartId(user.getId());
                int foodId = Integer.parseInt(request.getParameter("foodId"));
                int qty = Integer.parseInt(request.getParameter("quantity"));

                cartDAO.addOrUpdateItem(cartId, foodId, qty);

                List<CartItem> cartItems = cartDAO.fetchUserCart(cartId);
                int totalQuantity = 0;
                for (CartItem item : cartItems) {
                    totalQuantity += item.getQuantity();
                }

                session.setAttribute("cartSize", totalQuantity);

                response.getWriter().write(String.valueOf(totalQuantity));

            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("error");
            }
            return;
        }

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        int cartId = cartDAO.getOrCreateCartId(user.getId());
        int foodId = Integer.parseInt(request.getParameter("foodId"));

        if ("update".equals(action)) {
            int newQty = Integer.parseInt(request.getParameter("quantity"));
            cartDAO.updateQuantity(cartId, foodId, newQty);
            response.sendRedirect(request.getContextPath() + "/cart");
        }
        else if ("remove".equals(action)) {
            cartDAO.deleteItem(cartId, foodId);
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}