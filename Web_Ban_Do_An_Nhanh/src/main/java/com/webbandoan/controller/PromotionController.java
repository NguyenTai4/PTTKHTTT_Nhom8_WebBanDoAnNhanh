package com.webbandoan.controller;

import com.webbandoan.dao.PromotionDAO;
import com.webbandoan.model.Voucher;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/promotion")
public class PromotionController extends HttpServlet {
    private PromotionDAO promotionDAO = new PromotionDAO();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        List<Voucher> vouchers = promotionDAO.getAllVoucher();
        req.setAttribute("vouchers", vouchers);
        req.getRequestDispatcher("/pages/promotion.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    }
}
