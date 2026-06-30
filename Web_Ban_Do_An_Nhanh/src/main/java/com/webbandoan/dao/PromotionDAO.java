package com.webbandoan.dao;

import com.webbandoan.model.Promotion;
import com.webbandoan.model.Voucher;
import com.webbandoan.utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

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

    public List<Voucher> getAllVoucher() {
        List<Voucher> vouchers = new ArrayList<>();

        String query = "SELECT * FROM vouchers ORDER BY voucher_id DESC";

        try (
                Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(query);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                Voucher voucher = new Voucher();

                voucher.setVoucherId(rs.getInt("voucher_id"));
                voucher.setVoucherCode(rs.getString("voucher_code"));
                voucher.setVoucherName(rs.getString("voucher_name"));
                voucher.setDiscountAmount(rs.getInt("discount_amount"));
                voucher.setVoucherImage(rs.getString("voucher_image"));
                voucher.setDescription(rs.getString("description"));

                vouchers.add(voucher);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return vouchers;
    }
}
