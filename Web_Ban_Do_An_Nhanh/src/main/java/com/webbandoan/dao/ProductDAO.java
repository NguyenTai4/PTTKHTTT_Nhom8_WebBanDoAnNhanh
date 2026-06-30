package com.webbandoan.dao;

import com.webbandoan.model.Product;
import com.webbandoan.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    private static final int ITEMS_PER_PAGE = 12; // Yêu cầu: 1 trang 12 sản phẩm

    

    // Hàm phụ để lấy tổng số trang cho tính năng Lọc
    public int getTotalPagesForFilter(String category, String priceRange) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM foods WHERE 1=1 ");
        
        double minPrice = 0;
        double maxPrice = Double.MAX_VALUE;
        
        if (priceRange != null && !priceRange.isEmpty() && !priceRange.equals("all")) {
            String[] parts = priceRange.split("-");
            if (parts.length == 2) {
                minPrice = Double.parseDouble(parts[0]);
                maxPrice = Double.parseDouble(parts[1]);
            } else if (priceRange.endsWith("+")) {
                minPrice = Double.parseDouble(priceRange.replace("+", ""));
            }
            sql.append(" AND price >= ? AND price <= ? ");
        }
        
        if (category != null && !category.isEmpty() && !category.equals("all")) {
            sql.append(" AND category_id = ? ");
        }
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            
            if (priceRange != null && !priceRange.isEmpty() && !priceRange.equals("all")) {
                ps.setDouble(paramIndex++, minPrice);
                ps.setDouble(paramIndex++, maxPrice);
            }
            
            if (category != null && !category.isEmpty() && !category.equals("all")) {
                ps.setInt(paramIndex++, Integer.parseInt(category));
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int totalProducts = rs.getInt(1);
                return (int) Math.ceil((double) totalProducts / ITEMS_PER_PAGE);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy tổng số trang cho DS Mặc định
    public int getTotalPagesForDefault() {
        String sql = "SELECT COUNT(*) FROM foods";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int totalProducts = rs.getInt(1);
                return (int) Math.ceil((double) totalProducts / ITEMS_PER_PAGE);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy tổng số trang cho Tìm kiếm
    public int getTotalPagesForSearch(String keyword) {
        String sql = "SELECT COUNT(*) FROM foods WHERE name LIKE ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int totalProducts = rs.getInt(1);
                return (int) Math.ceil((double) totalProducts / ITEMS_PER_PAGE);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    // 10.6. queryDefaultProducts()
    public List<Product> queryDefaultProducts(int page) {
        List<Product> list = new ArrayList<>();
        int offset = (page - 1) * ITEMS_PER_PAGE;
        String sql = "SELECT * FROM foods LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ITEMS_PER_PAGE);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(
                        rs.getLong("id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getString("image_url"),
                        100 // dummy quantity
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 10.7. return defaultList
        return list;
    }

    // 10.12. queryProducts(criteria)
    public List<Product> queryProducts(String category, int minPrice, int maxPrice, int offset, int limit) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM foods WHERE price >= ? AND price <= ? ");
        
        if (category != null && !category.isEmpty() && !category.equals("all")) {
            sql.append(" AND category_id = ? ");
        }
        sql.append(" LIMIT ? OFFSET ?");
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            ps.setDouble(1, minPrice);
            ps.setDouble(2, maxPrice);
            int paramIndex = 3;
            
            if (category != null && !category.isEmpty() && !category.equals("all")) {
                ps.setInt(paramIndex++, Integer.parseInt(category));
            }
            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex, offset);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(
                        rs.getLong("id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getString("image_url"),
                        100
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 10.13. return filteredList
        return list;
    }

    // 12.3. findSuggestedNames(partial)
    public List<String> findSuggestedNames(String partial) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT name FROM foods WHERE name LIKE ? LIMIT 5";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + partial + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 12.4. return nameList
        return list;
    }

    // 12.9. getProducts(keyword, page)
    public List<Product> getProducts(String keyword, int page) {
        List<Product> list = new ArrayList<>();
        int offset = (page - 1) * ITEMS_PER_PAGE;
        String sql = "SELECT * FROM foods WHERE name LIKE ? LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, ITEMS_PER_PAGE);
            ps.setInt(3, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(
                        rs.getLong("id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getString("image_url"),
                        100
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}