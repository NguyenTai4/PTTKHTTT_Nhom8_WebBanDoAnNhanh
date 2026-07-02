package com.webbandoan.controller;

import com.webbandoan.dao.FoodDAO;
import com.webbandoan.dao.CartDAO;
import com.webbandoan.model.Food;
import com.webbandoan.model.CartItem;
import com.webbandoan.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;


@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Khởi tạo các lớp DAO để giao tiếp với DB
    private FoodDAO foodDAO = new FoodDAO();
    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        if (user != null) {
            try {
                int cartId = cartDAO.getOrCreateCartId(user.getId());

                List<CartItem> cartItems = cartDAO.fetchUserCart(cartId);

                int totalQuantity = 0;
                for (CartItem item : cartItems) {
                    totalQuantity += item.getQuantity();
                }

                session.setAttribute("cartSize", totalQuantity);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        List<Food> foodList = foodDAO.getAllFoods();

        request.setAttribute("foodList", foodList);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}