package com.webbandoan.dao;

import com.webbandoan.model.Order;
import com.webbandoan.model.CartItem;
import com.webbandoan.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    // 9.3 queryOrders(userId)
    public List<Order> queryOrders(long userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT id, user_id, fullname AS receive_name, phone AS phone_number, address AS shipping_address, payment_method, payment_status AS order_status, total_price AS total_amount, total_price AS final_amount, created_at FROM orders WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Order(
                        rs.getLong("id"),
                        rs.getLong("user_id"),
                        rs.getString("receive_name"),
                        rs.getString("phone_number"),
                        rs.getString("shipping_address"),
                        rs.getString("payment_method"),
                        rs.getString("order_status"),
                        rs.getDouble("total_amount"),
                        rs.getDouble("final_amount"),
                        rs.getTimestamp("created_at")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 9.4 return orderList
        return list;
    }

    // 9.9. queryOrderDetails(orderId)
    public Order queryOrder(String orderId) {
        Order order = null;
        String sql = "SELECT id, user_id, fullname AS receive_name, phone AS phone_number, address AS shipping_address, payment_method, payment_status AS order_status, total_price AS total_amount, total_price AS final_amount, created_at FROM orders WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, Long.parseLong(orderId));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                order = new Order(
                        rs.getLong("id"),
                        rs.getLong("user_id"),
                        rs.getString("receive_name"),
                        rs.getString("phone_number"),
                        rs.getString("shipping_address"),
                        rs.getString("payment_method"),
                        rs.getString("order_status"),
                        rs.getDouble("total_amount"),
                        rs.getDouble("final_amount"),
                        rs.getTimestamp("created_at"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 9.10. return orderData
        return order;
    }

    /**
     * Checks if the user has any unpaid bank/paypal orders in 'Chờ thanh toán'
     * status.
     */
    public boolean checkUnpaidOrder(int userId) {
        String query = "SELECT COUNT(*) FROM orders WHERE user_id = ? AND payment_method = 'bank' AND payment_status = 'Chờ thanh toán'";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            System.err.println("Error in OrderDAO.checkUnpaidOrder: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cancels any unpaid bank/paypal orders for the user and releases (restores)
     * their stock.
     */
    public boolean cancelOldOrderAndReleaseStock(int userId) {
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false); // Start Transaction

            // 1. Get all unpaid order IDs for this user
            String getOrdersQuery = "SELECT id FROM orders WHERE user_id = ? AND payment_method = 'bank' AND payment_status = 'Chờ thanh toán'";
            List<Integer> unpaidOrderIds = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(getOrdersQuery)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        unpaidOrderIds.add(rs.getInt("id"));
                    }
                }
            }

            if (unpaidOrderIds.isEmpty()) {
                conn.commit();
                return true; // No orders to cancel
            }

            // 2. Cancel the orders and release stock for each item
            String cancelOrderQuery = "UPDATE orders SET payment_status = 'Đã hủy' WHERE id = ?";
            String getItemsQuery = "SELECT food_id, quantity FROM order_items WHERE order_id = ?";
            String releaseStockQuery = "UPDATE foods SET stock = stock + ? WHERE id = ?";

            try (PreparedStatement psCancel = conn.prepareStatement(cancelOrderQuery);
                    PreparedStatement psGetItems = conn.prepareStatement(getItemsQuery);
                    PreparedStatement psRelease = conn.prepareStatement(releaseStockQuery)) {

                for (int orderId : unpaidOrderIds) {
                    // Update order status
                    psCancel.setInt(1, orderId);
                    psCancel.executeUpdate();

                    // Get order items
                    psGetItems.setInt(1, orderId);
                    try (ResultSet rsItems = psGetItems.executeQuery()) {
                        while (rsItems.next()) {
                            int foodId = rsItems.getInt("food_id");
                            int quantity = rsItems.getInt("quantity");

                            // Restore stock
                            psRelease.setInt(1, quantity);
                            psRelease.setInt(2, foodId);
                            psRelease.executeUpdate();
                        }
                    }
                }
            }

            conn.commit(); // Commit Transaction
            System.out.println(
                    "[BiteSync OrderDAO] Successfully cancelled old unpaid orders and released stock for user ID: "
                            + userId);
            return true;
        } catch (Exception e) {
            System.err.println("Error in OrderDAO.cancelOldOrderAndReleaseStock: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return false;
    }

    /**
     * Creates a new order, saves order items, updates inventory, and clears user's
     * cart.
     * Everything is run under a single database transaction.
     */
    public int createOrder(Order order, List<CartItem> cartItems) {
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false); // Start Transaction

            // 1. Insert into orders table
            String insertOrderQuery = "INSERT INTO orders (user_id, fullname, phone, address, notes, payment_method, payment_status, total_price, promo_code, discount_amount, shipping_fee) "
                    +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            int orderId = -1;
            try (PreparedStatement ps = conn.prepareStatement(insertOrderQuery, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, order.getUserId());
                ps.setString(2, order.getFullname());
                ps.setString(3, order.getPhone());
                ps.setString(4, order.getAddress());
                ps.setString(5, order.getNotes());
                ps.setString(6, order.getPaymentMethod());
                ps.setString(7, order.getPaymentStatus());
                ps.setDouble(8, order.getTotalPrice());
                ps.setString(9, order.getPromoCode());
                ps.setDouble(10, order.getDiscountAmount());
                ps.setDouble(11, order.getShippingFee());

                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    }
                }
            }

            if (orderId == -1) {
                throw new SQLException("Failed to retrieve generated Order ID.");
            }

            // 2. Insert order items & deduct stock
            String insertItemQuery = "INSERT INTO order_items (order_id, food_id, quantity, price) VALUES (?, ?, ?, ?)";
            String deductStockQuery = "UPDATE foods SET stock = stock - ? WHERE id = ?";

            try (PreparedStatement psItem = conn.prepareStatement(insertItemQuery);
                    PreparedStatement psDeduct = conn.prepareStatement(deductStockQuery)) {

                for (CartItem item : cartItems) {
                    // Save item
                    psItem.setInt(1, orderId);
                    psItem.setInt(2, item.getFoodId());
                    psItem.setInt(3, item.getQuantity());
                    psItem.setDouble(4, item.getFood().getPrice());
                    psItem.executeUpdate();

                    // Deduct stock
                    psDeduct.setInt(1, item.getQuantity());
                    psDeduct.setInt(2, item.getFoodId());
                    psDeduct.executeUpdate();
                }
            }

            // 3. Clear user cart items
            String deleteCartItemsQuery = "DELETE ci FROM cart_items ci JOIN carts c ON ci.cart_id = c.id WHERE c.user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteCartItemsQuery)) {
                ps.setInt(1, order.getUserId());
                ps.executeUpdate();
            }

            conn.commit(); // Commit Transaction
            System.out.println("[BiteSync OrderDAO] Successfully created order ID: " + orderId);
            return orderId;
        } catch (Exception e) {
            System.err.println("Error in OrderDAO.createOrder: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return -1;
    }

    /**
     * Cancels a specific unpaid order and releases (restores) its items stock.
     */
    public boolean cancelSpecificOrderAndReleaseStock(int orderId) {
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false); // Start Transaction

            // Check if order exists and is in 'Chờ thanh toán' status
            String checkQuery = "SELECT id FROM orders WHERE id = ? AND payment_status = 'Chờ thanh toán'";
            boolean canCancel = false;
            try (PreparedStatement ps = conn.prepareStatement(checkQuery)) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        canCancel = true;
                    }
                }
            }

            if (!canCancel) {
                conn.commit();
                return true; // Already processed or not found
            }

            // 1. Cancel the specific order
            String cancelOrderQuery = "UPDATE orders SET payment_status = 'Đã hủy' WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(cancelOrderQuery)) {
                ps.setInt(1, orderId);
                ps.executeUpdate();
            }

            // 2. Release/Restore stock for order items
            String getItemsQuery = "SELECT food_id, quantity FROM order_items WHERE order_id = ?";
            String releaseStockQuery = "UPDATE foods SET stock = stock + ? WHERE id = ?";

            try (PreparedStatement psGetItems = conn.prepareStatement(getItemsQuery);
                 PreparedStatement psRelease = conn.prepareStatement(releaseStockQuery)) {
                psGetItems.setInt(1, orderId);
                try (ResultSet rsItems = psGetItems.executeQuery()) {
                    while (rsItems.next()) {
                        int foodId = rsItems.getInt("food_id");
                        int quantity = rsItems.getInt("quantity");

                        // Restore stock
                        psRelease.setInt(1, quantity);
                        psRelease.setInt(2, foodId);
                        psRelease.executeUpdate();
                    }
                }
            }

            conn.commit(); // Commit Transaction
            System.out.println("[BiteSync OrderDAO] Successfully cancelled order ID: " + orderId + " and released stock.");
            return true;
        } catch (Exception e) {
            System.err.println("Error in OrderDAO.cancelSpecificOrderAndReleaseStock: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return false;
    }
}
