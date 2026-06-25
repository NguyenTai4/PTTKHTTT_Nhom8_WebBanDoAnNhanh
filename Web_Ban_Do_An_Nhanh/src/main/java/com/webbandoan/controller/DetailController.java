package com.webbandoan.controller;

import com.webbandoan.dao.FoodDAO;
import com.webbandoan.model.Food;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/detail")
public class DetailController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int foodId = Integer.parseInt(request.getParameter("id"));
        Food food = new FoodDAO().getFoodById(foodId);
        request.setAttribute("food", food);
        request.getRequestDispatcher("/pages/detail.jsp").forward(request, response);
    }
}