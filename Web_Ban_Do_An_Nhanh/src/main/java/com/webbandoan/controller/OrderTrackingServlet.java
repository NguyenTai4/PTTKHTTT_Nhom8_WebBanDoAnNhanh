package com.webbandoan.controller;

import com.webbandoan.dao.OrderDAO;
import com.webbandoan.model.Order;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/order-tracking")
public class OrderTrackingServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderCode = request.getParameter("orderCode");
        
        if (orderCode != null && !orderCode.trim().isEmpty()) {
            Order order = orderDAO.queryOrder(orderCode);
            
            if (order == null) {
                request.setAttribute("error", "Không tìm thấy đơn hàng với mã: " + orderCode);
                request.getRequestDispatcher("/pages/order_tracking.jsp").forward(request, response);
            } else {
                request.setAttribute("order", order);
                request.getRequestDispatcher("/pages/order_details.jsp").forward(request, response);
            }
        } else {
            request.getRequestDispatcher("/pages/order_tracking.jsp").forward(request, response);
        }
    }
}