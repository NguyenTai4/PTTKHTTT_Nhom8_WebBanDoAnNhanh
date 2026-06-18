package com.webbandoan.controller;

import com.webbandoan.model.FoodItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller Servlet for the home page listing fast-food items.
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Prepare list of mock fast-food items
        List<FoodItem> foodList = new ArrayList<>();
        
        foodList.add(new FoodItem(
                1, 
                "Double Cheese Burger", 
                "Flame-grilled double beef patty, melted cheddar cheese, lettuce, tomatoes, and signature sauce.", 
                5.99, 
                "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=80", 
                "Burgers"
        ));
        
        foodList.add(new FoodItem(
                2, 
                "Pepperoni Premium Pizza", 
                "Crispy thin crust topped with rich marinara sauce, mozzarella cheese, and loaded with spicy pepperoni.", 
                8.99, 
                "https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&w=500&q=80", 
                "Pizzas"
        ));
        
        foodList.add(new FoodItem(
                3, 
                "Crispy Chicken Wings", 
                "Golden-fried crunchy chicken wings tossed in your choice of sweet and spicy BBQ or hot buffalo sauce.", 
                4.99, 
                "https://images.unsplash.com/photo-1567620832903-9fc6debc209f?auto=format&fit=crop&w=500&q=80", 
                "Sides"
        ));

        foodList.add(new FoodItem(
                4, 
                "Fresh Strawberry Milkshake", 
                "Thick and creamy vanilla milkshake blended with fresh strawberries and topped with whipped cream.", 
                2.99, 
                "https://images.unsplash.com/photo-1579954115545-a95591f28bfc?auto=format&fit=crop&w=500&q=80", 
                "Drinks"
        ));

        foodList.add(new FoodItem(
                5, 
                "Loaded Cheesy Fries", 
                "Crispy golden fries smothered in melted cheddar cheese sauce, crispy bacon bits, and chopped chives.", 
                3.49, 
                "https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=500&q=80", 
                "Sides"
        ));

        foodList.add(new FoodItem(
                6, 
                "Fudge Chocolate Brownie", 
                "Rich, warm chocolate brownie loaded with chocolate chips, served with a scoop of vanilla ice cream.", 
                3.99, 
                "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=500&q=80", 
                "Desserts"
        ));

        // Set list of food items to request scope
        request.setAttribute("foodList", foodList);
        
        // Forward request to index.jsp for rendering
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
