package com.webbandoan.controller;

import com.webbandoan.dao.FoodDAO;
import com.webbandoan.dao.CartDAO;      // Thêm import để làm việc với Giỏ hàng
import com.webbandoan.model.Food;
import com.webbandoan.model.CartItem;  // Thêm import Model dữ liệu giỏ hàng
import com.webbandoan.model.User;      // Thêm import Model User

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;  // Thêm import Quản lý Session
import java.io.IOException;
import java.util.List;

/**
 * Controller Servlet cho trang chủ - Lấy dữ liệu thức ăn và số lượng giỏ hàng từ Database
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Khởi tạo các lớp DAO để giao tiếp với DB
    private FoodDAO foodDAO = new FoodDAO();
    private CartDAO cartDAO = new CartDAO(); // THÊM: Khởi tạo CartDAO

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // =========================================================================
        // LOGIC THÊM: ĐỒNG BỘ SỐ LƯỢNG SẢN PHẨM TRONG GIỎ HÀNG LÊN HEADER BADGE
        // =========================================================================
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        if (user != null) {
            try {
                // Lấy hoặc tạo mới ID giỏ hàng dựa trên ID của User đang đăng nhập
                int cartId = cartDAO.getOrCreateCartId(user.getId());

                // Lấy danh sách toàn bộ món ăn đang có trong giỏ hàng
                List<CartItem> cartItems = cartDAO.fetchUserCart(cartId);

                // Vòng lặp tính tổng số lượng (Cộng dồn quantity của từng món)
                int totalQuantity = 0;
                for (CartItem item : cartItems) {
                    totalQuantity += item.getQuantity();
                }

                // Đẩy con số tổng này vào Session với tên "cartSize"
                // Từ đó các trang index.jsp, detail.jsp chỉ cần dùng ${sessionScope.cartSize} để hiển thị
                session.setAttribute("cartSize", totalQuantity);

            } catch (Exception e) {
                // Log lỗi ra màn hình Console của IDE nếu có lỗi truy vấn DB giỏ hàng
                e.printStackTrace();
            }
        }

        // =========================================================================
        // LOGIC CŨ: LẤY DANH SÁCH MÓN ĂN VÀ ĐIỀU HƯỚNG TRANG
        // =========================================================================
        // 1. Gọi DAO để lấy toàn bộ danh sách món ăn từ Database
        List<Food> foodList = foodDAO.getAllFoods();

        // 2. Gắn danh sách vào request scope để JSP có thể đọc được
        request.setAttribute("foodList", foodList);

        // 3. Chuyển hướng về trang index.jsp để hiển thị
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}