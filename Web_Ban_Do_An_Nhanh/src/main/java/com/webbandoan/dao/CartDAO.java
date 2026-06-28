package com.webbandoan.dao;
import com.webbandoan.utils.DBContext;
import com.webbandoan.model.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    public int getOrCreateCartId(int userId) {
        try (Connection conn = DBContext.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT id FROM carts WHERE user_id = ?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("id");

            PreparedStatement psInsert = conn.prepareStatement("INSERT INTO carts (user_id) VALUES (?)", Statement.RETURN_GENERATED_KEYS);
            psInsert.setInt(1, userId);
            psInsert.executeUpdate();
            ResultSet rsGen = psInsert.getGeneratedKeys();
            if (rsGen.next()) return rsGen.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    public List<CartItem> fetchUserCart(int cartId) {
        List<CartItem> list = new ArrayList<>();
        String query = "SELECT ci.food_id, ci.quantity, f.name, f.price, f.image_url, c.name as category_name " +
                "FROM cart_items ci JOIN foods f ON ci.food_id = f.id JOIN categories c ON f.category_id = c.id " +
                "WHERE ci.cart_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setFoodId(rs.getInt("food_id"));
                item.setQuantity(rs.getInt("quantity"));

                Food food = new Food();
                food.setId(rs.getInt("food_id"));
                food.setName(rs.getString("name"));
                food.setPrice(rs.getDouble("price"));
                food.setImageUrl(rs.getString("image_url"));
                food.setCategoryName(rs.getString("category_name"));
                item.setFood(food);
                list.add(item);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    public void addOrUpdateItem(int cartId, int foodId, int qtyToAdd) {
        try (Connection conn = DBContext.getConnection()) {
            PreparedStatement psCheck = conn.prepareStatement("SELECT quantity FROM cart_items WHERE cart_id = ? AND food_id = ?");
            psCheck.setInt(1, cartId); psCheck.setInt(2, foodId);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                PreparedStatement psUpdate = conn.prepareStatement("UPDATE cart_items SET quantity = quantity + ? WHERE cart_id = ? AND food_id = ?");
                psUpdate.setInt(1, qtyToAdd); psUpdate.setInt(2, cartId); psUpdate.setInt(3, foodId);
                psUpdate.executeUpdate();
            } else {
                PreparedStatement psInsert = conn.prepareStatement("INSERT INTO cart_items (cart_id, food_id, quantity) VALUES (?, ?, ?)");
                psInsert.setInt(1, cartId); psInsert.setInt(2, foodId); psInsert.setInt(3, qtyToAdd);
                psInsert.executeUpdate();
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void updateQuantity(int cartId, int foodId, int newQty) {
        if (newQty <= 0) { deleteItem(cartId, foodId); return; }
        String query = "UPDATE cart_items SET quantity = ? WHERE cart_id = ? AND food_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, newQty); ps.setInt(2, cartId); ps.setInt(3, foodId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void deleteItem(int cartId, int foodId) {
        String query = "DELETE FROM cart_items WHERE cart_id = ? AND food_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, cartId); ps.setInt(2, foodId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}