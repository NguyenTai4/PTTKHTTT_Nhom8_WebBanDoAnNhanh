package com.webbandoan.controller;

import com.webbandoan.dao.CartDAO;
import com.webbandoan.model.CartItem;
import com.webbandoan.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/cart")
public class CartController extends HttpServlet {
    private CartDAO cartDAO = new CartDAO();

    // doGet: Hiển thị giao diện giỏ hàng như bình thường
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        // Nếu chưa đăng nhập thì bắt quay về trang login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        int cartId = cartDAO.getOrCreateCartId(user.getId());
        List<CartItem> cartItems = cartDAO.fetchUserCart(cartId);

        // Tính tổng tiền đơn hàng
        double subTotal = 0;
        for(CartItem item : cartItems) {
            subTotal += item.getFood().getPrice() * item.getQuantity();
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subTotal", subTotal);
        request.getRequestDispatcher("/pages/cart.jsp").forward(request, response);
    }

    // doPost: Xử lý các hành động Thêm (AJAX) / Sửa / Xóa
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        String action = request.getParameter("action");

        // =========================================================================
        // TRƯỜNG HỢP 1: THÊM VÀO GIỎ HÀNG (Dùng AJAX từ trang chủ/trang chi tiết)
        // =========================================================================
        if ("add".equals(action)) {
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");

            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("login_required");
                return;
            }

            try {
                int cartId = cartDAO.getOrCreateCartId(user.getId());
                int foodId = Integer.parseInt(request.getParameter("foodId"));
                int qty = Integer.parseInt(request.getParameter("quantity"));

                // 1. Thêm hoặc cập nhật món ăn vào DB
                cartDAO.addOrUpdateItem(cartId, foodId, qty);

                // 2. Tính tổng số lượng (Tổng các quantity) hiện tại trong giỏ hàng
                List<CartItem> cartItems = cartDAO.fetchUserCart(cartId);
                int totalQuantity = 0;
                for (CartItem item : cartItems) {
                    totalQuantity += item.getQuantity();
                }

                // 3. Cập nhật lại vào session để khi chuyển sang các trang khác số lượng vẫn đúng
                session.setAttribute("cartSize", totalQuantity);

                // 4. Trả con số này về cho AJAX frontend nhận
                response.getWriter().write(String.valueOf(totalQuantity));

            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("error");
            }
            return;
        }

        // =========================================================================
        // TRƯỜNG HỢP 2: CẬP NHẬT / XÓA (Chạy bằng Form truyền thống tại cart.jsp)
        // =========================================================================
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        int cartId = cartDAO.getOrCreateCartId(user.getId());
        int foodId = Integer.parseInt(request.getParameter("foodId"));

        if ("update".equals(action)) {
            int newQty = Integer.parseInt(request.getParameter("quantity"));
            cartDAO.updateQuantity(cartId, foodId, newQty);
            response.sendRedirect(request.getContextPath() + "/cart");
        }
        else if ("remove".equals(action)) {
            cartDAO.deleteItem(cartId, foodId);
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}