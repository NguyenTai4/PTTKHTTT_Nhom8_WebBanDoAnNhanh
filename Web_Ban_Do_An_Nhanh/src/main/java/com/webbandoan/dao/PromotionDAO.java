package com.webbandoan.dao;

import com.webbandoan.model.Promotion;
import com.webbandoan.utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class PromotionDAO {
    public Promotion getPromotionByCode(String code) {
        if (code == null || code.trim().isEmpty()) {
            return null;
        }
        String query = "SELECT * FROM promotions WHERE code = ? AND is_active = 1";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, code.trim().toUpperCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Promotion promo = new Promotion();
                    promo.setCode(rs.getString("code"));
                    promo.setDiscountPercent(rs.getInt("discount_percent"));
                    promo.setActive(rs.getInt("is_active") == 1);
                    return promo;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
