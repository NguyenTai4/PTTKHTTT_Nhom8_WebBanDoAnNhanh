package com.webbandoan.controller;

import com.webbandoan.dao.OrderDAO;
import com.webbandoan.model.Order;
import com.webbandoan.model.OrderDetail;
import com.webbandoan.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/order-tracking")
public class OrderTrackingServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        int userId = 1; // Mock user id
        if (user != null) {
            userId = user.getId();
        }

        String orderIdParam = request.getParameter("id");
        if (orderIdParam != null && !orderIdParam.isEmpty()) {
            // 9.7. Chọn đơn hàng cần theo dõi
            try {
                int orderId = Integer.parseInt(orderIdParam);
                List<OrderDetail> data = getOrderDetails(orderId);
                
                if (data != null && !data.isEmpty()) {
                    // 9.11. return data
                    request.setAttribute("orderDetails", data);
                    request.setAttribute("orderId", orderId);
                    request.getRequestDispatcher("/pages/order_details.jsp").forward(request, response);
                } else {
                    // 9.13. return error
                    request.setAttribute("errorMessage", "Lỗi truy xuất dữ liệu");
                    request.getRequestDispatcher("/pages/order_tracking.jsp").forward(request, response);
                }
            } catch (Exception e) {
                // 9.13. return error
                request.setAttribute("errorMessage", "Lỗi truy xuất dữ liệu");
                request.getRequestDispatcher("/pages/order_tracking.jsp").forward(request, response);
            }
        } else {
            // 9.1. Yêu cầu xem danh sách đơn hàng
            List<Order> orders = getOrders(userId);
            // 9.5. return orders
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/pages/order_tracking.jsp").forward(request, response);
        }
    }

    // 9.2. getOrders(userId)
    private List<Order> getOrders(int userId) {
        List<Order> orderList = orderDAO.queryOrders(userId);
        // 9.4. return orderList
        return orderList;
    }

    // 9.8. getOrderDetails(orderId)
    private List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> orderData = orderDAO.queryOrderDetails(orderId);
        // 9.10. return orderData
        return orderData;
    }
}
