package com.webbandoan.dao;

import com.webbandoan.model.Order;
import com.webbandoan.model.OrderDetail;
import com.webbandoan.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    // 9.3. queryOrders(userId)
    public List<Order> queryOrders(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setTotalAmount(rs.getDouble("final_amount"));
                    order.setStatus(rs.getString("order_status"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    orders.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    // 9.9. queryOrderDetails(orderId)
    public List<OrderDetail> queryOrderDetails(int orderId) {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT od.*, p.name, p.image " +
                     "FROM order_items od JOIN products p ON od.product_id = p.id " +
                     "WHERE od.order_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail detail = new OrderDetail();
                    detail.setId(rs.getInt("id"));
                    detail.setOrderId(rs.getInt("order_id"));
                    detail.setFoodId(rs.getInt("product_id"));
                    detail.setFoodName(rs.getString("name"));
                    detail.setImageUrl(rs.getString("image"));
                    detail.setQuantity(rs.getInt("quantity"));
                    detail.setPrice(rs.getDouble("unit_price"));
                    details.add(detail);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 9.10. return orderData
        return details;
    }
}
