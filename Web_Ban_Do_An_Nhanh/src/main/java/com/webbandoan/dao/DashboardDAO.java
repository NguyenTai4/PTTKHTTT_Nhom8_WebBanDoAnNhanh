package com.webbandoan.dao;

import com.webbandoan.model.DashboardDTO;
import com.webbandoan.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DashboardDAO {
    public DashboardDTO getAllDashboard(){
        DashboardDTO dashboardDTO = new DashboardDTO();
        try(Connection conn = DBContext.getConnection()){
           String sql = "SELECT COUNT(*) FROM users";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                dashboardDTO.setTotalCustomers(rs.getInt(1));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
        return dashboardDTO;
    }
}
