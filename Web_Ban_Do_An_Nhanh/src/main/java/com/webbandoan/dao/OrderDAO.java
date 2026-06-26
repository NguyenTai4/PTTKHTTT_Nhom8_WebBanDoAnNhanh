package com.webbandoan.dao;

import com.webbandoan.model.Order;
import com.webbandoan.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    // 9.3 queryOrders(userId)
    public List<Order> queryOrders(long userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        
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
                        rs.getTimestamp("created_at")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // 9.4 return orderList
        return list;
    }

    
}

}
// TODO: Implement queryOrderDetails
}
// commit 0