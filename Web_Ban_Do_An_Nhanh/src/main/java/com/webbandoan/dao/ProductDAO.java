package com.webbandoan.dao;

import com.webbandoan.model.Product;
import com.webbandoan.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // 10.6. queryDefaultProducts()
    public List<Product> queryDefaultProducts() {
        List<Product> defaultList = new ArrayList<>();
        String sql = "SELECT * FROM products LIMIT 20";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getDouble("price"),
                    rs.getInt("stock_quantity"),
                    rs.getString("image"),
                    rs.getString("brand"),
                    rs.getInt("category_id"),
                    rs.getString("status"),
                    rs.getString("description")
                );
                defaultList.add(product);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 10.7. return defaultList
        return defaultList;
    }

    // 10.12. queryProducts(criteria)
    public List<Product> queryProducts(String criteria) {
        List<Product> filteredList = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE name LIKE ? OR brand LIKE ? OR description LIKE ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + criteria + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getInt("stock_quantity"),
                        rs.getString("image"),
                        rs.getString("brand"),
                        rs.getInt("category_id"),
                        rs.getString("status"),
                        rs.getString("description")
                    );
                    filteredList.add(product);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 10.13. return filteredList
        return filteredList;
    }
}
