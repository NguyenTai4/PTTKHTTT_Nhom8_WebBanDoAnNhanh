package com.webbandoan.dao;

import com.webbandoan.model.Food;
import com.webbandoan.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // 12.3 findSuggestedNames(partial)
    public List<String> findSuggestedNames(String partial) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT name FROM products WHERE name LIKE ? LIMIT 5";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + partial + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getString("name"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list; // 12.4 return nameList
    }

    // 12.9 getProducts(keyword, page)
    public List<Food> getProducts(String keyword, int page) {
        List<Food> list = new ArrayList<>();
        int pageSize = 12; 
        int offset = (page - 1) * pageSize;
        
        String sql = "SELECT p.* FROM products p WHERE p.name LIKE ? LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Food food = new Food();
                    food.setId(rs.getInt("id"));
                    food.setName(rs.getString("name"));
                    food.setDescription(rs.getString("description"));
                    food.setPrice(rs.getDouble("price"));
                    food.setImageUrl(rs.getString("image"));
                    list.add(food);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list; // 12.10 return pageResult
    }
}
