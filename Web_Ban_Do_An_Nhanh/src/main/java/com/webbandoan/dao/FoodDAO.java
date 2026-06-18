package com.webbandoan.dao;

import com.webbandoan.model.FoodItem;
import com.webbandoan.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object (DAO) for FoodItem model.
 * Implements SQL database operations using JDBC templates.
 */
public class FoodDAO {

    /**
     * Fetches all food items from the database.
     * Fallback to static mock data can be implemented if database table does not exist yet.
     */
    public List<FoodItem> getAllFoods() {
        List<FoodItem> list = new ArrayList<>();
        String query = "SELECT * FROM food_items";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                FoodItem item = new FoodItem(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("image_url"),
                    rs.getString("category")
                );
                list.add(item);
            }
        } catch (Exception e) {
            System.err.println("Database query failed in FoodDAO.getAllFoods: " + e.getMessage());
            // Optionally insert default items as template fallback if table is missing
        }
        return list;
    }

    /**
     * Fetches a specific food item by its primary key ID.
     */
    public FoodItem getFoodById(int id) {
        String query = "SELECT * FROM food_items WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new FoodItem(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getString("image_url"),
                        rs.getString("category")
                    );
                }
            }
        } catch (Exception e) {
            System.err.println("Database query failed in FoodDAO.getFoodById: " + e.getMessage());
        }
        return null;
    }

    /**
     * Inserts a new food item into the database.
     */
    public boolean addFood(FoodItem food) {
        String query = "INSERT INTO food_items (name, description, price, image_url, category) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setString(1, food.getName());
            ps.setString(2, food.getDescription());
            ps.setDouble(3, food.getPrice());
            ps.setString(4, food.getImageUrl());
            ps.setString(5, food.getCategory());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            System.err.println("Database insertion failed in FoodDAO.addFood: " + e.getMessage());
            return false;
        }
    }
}
