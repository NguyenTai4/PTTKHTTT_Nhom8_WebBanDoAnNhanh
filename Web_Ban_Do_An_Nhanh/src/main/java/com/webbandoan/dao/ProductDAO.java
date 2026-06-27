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
}

}
// commit 13