package com.webbandoan.controller;

import com.webbandoan.dao.DashboardDAO;
import com.webbandoan.model.DashboardDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        DashboardDAO dashboardDAO = new DashboardDAO();
        DashboardDTO dashboard = dashboardDAO.getAllDashboard();
        System.out.println(dashboard);
        req.setAttribute("dash", dashboard);
        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }
}
