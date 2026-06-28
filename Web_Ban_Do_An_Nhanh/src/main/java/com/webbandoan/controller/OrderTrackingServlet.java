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
        String orderIdStr = request.getParameter("orderId");
        
        // Giả lập lấy userId từ session
        com.webbandoan.model.Account account = (com.webbandoan.model.Account) request.getSession().getAttribute("loggedUser");
        long userId = account != null ? account.getId() : 1L; // Fallback for test
        
        if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
            try {
                long orderId = Long.parseLong(orderIdStr);
                // 9.8. getOrderDetails(orderId)
                Order order = orderDAO.queryOrder(String.valueOf(orderId));
                
                if (order == null) {
                    // 9.13. return error
                    request.setAttribute("error", "Không tìm thấy đơn hàng với mã: " + orderId);
                    request.getRequestDispatcher("/pages/order_tracking.jsp").forward(request, response);
                } else {
                    // 9.11. return data
                    request.setAttribute("order", order);
                    request.getRequestDispatcher("/pages/order_details.jsp").forward(request, response);
                }
            } catch (Exception e) {
                request.setAttribute("error", "Mã đơn hàng không hợp lệ.");
                request.getRequestDispatcher("/pages/order_tracking.jsp").forward(request, response);
            }
        } else {
            // 9.2. getOrders(userId)
            List<Order> orders = orderDAO.queryOrders(userId);
            // 9.5. return orders
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/pages/order_tracking.jsp").forward(request, response);
        }
    }
}