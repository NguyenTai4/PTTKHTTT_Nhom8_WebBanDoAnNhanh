package com.webbandoan.dao;
import com.webbandoan.utils.DBContext;
import com.webbandoan.model.Food;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FoodDAO {
    public Food getFoodById(int id) {
        String query = "SELECT f.*, c.name as category_name FROM foods f JOIN categories c ON f.category_id = c.id WHERE f.id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Food food = new Food();
                food.setId(rs.getInt("id"));
                food.setName(rs.getString("name"));
                food.setDescription(rs.getString("description"));
                food.setPrice(rs.getDouble("price"));
                food.setImageUrl(rs.getString("image_url"));
                food.setCategoryName(rs.getString("category_name"));
                food.setStock(rs.getInt("stock"));
                return food;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
    public List<Food> getAllFoods() {
        List<Food> list = new ArrayList<>();
        String query = "SELECT f.*, c.name as category_name, c.code_name as category_code " +
                "FROM foods f JOIN categories c ON f.category_id = c.id " +
                "ORDER BY f.id DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Food food = new Food();
                food.setId(rs.getInt("id"));
                food.setName(rs.getString("name"));
                food.setDescription(rs.getString("description"));
                food.setPrice(rs.getDouble("price"));
                food.setImageUrl(rs.getString("image_url"));
                food.setCategoryName(rs.getString("category_code"));
                food.setStock(rs.getInt("stock"));

                list.add(food);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStock(int foodId, int qtyChange) {
        String query = "UPDATE foods SET stock = stock + ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, qtyChange);
            ps.setInt(2, foodId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}