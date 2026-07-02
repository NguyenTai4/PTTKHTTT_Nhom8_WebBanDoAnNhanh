package com.webbandoan.controller;

import com.google.gson.JsonObject;
import com.webbandoan.dao.CartDAO;
import com.webbandoan.dao.FoodDAO;
import com.webbandoan.dao.OrderDAO;
import com.webbandoan.dao.PromotionDAO;
import com.webbandoan.model.CartItem;
import com.webbandoan.model.Food;
import com.webbandoan.model.Order;
import com.webbandoan.model.Promotion;
import com.webbandoan.model.User;
import com.webbandoan.utils.DBContext;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout", "/checkout/apply-promo", "/checkout/confirm-payment"})
public class CheckoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CartDAO cartDAO = new CartDAO();
    private final FoodDAO foodDAO = new FoodDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final PromotionDAO promotionDAO = new PromotionDAO();
    private static final double SHIPPING_FEE = 1.50; // Shipping fee in dollars

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        if (path.equals("/checkout/confirm-payment")) {
            String orderIdStr = request.getParameter("orderId");
            if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
                try {
                    int orderId = Integer.parseInt(orderIdStr);
                    try (java.sql.Connection conn = DBContext.getConnection();
                         java.sql.PreparedStatement ps = conn.prepareStatement("UPDATE orders SET payment_status = 'Đã thanh toán' WHERE id = ?")) {
                        ps.setInt(1, orderId);
                        ps.executeUpdate();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect(request.getContextPath() + "/pages/success-online.jsp?orderId=" + orderIdStr);
            return;
        }

        if (path.equals("/checkout")) {
            int cartId = cartDAO.getOrCreateCartId(user.getId());
            List<CartItem> cartItems = cartDAO.fetchUserCart(cartId);

            if (cartItems.isEmpty()) {
                session.setAttribute("error", "Giỏ hàng của bạn đang trống! Vui lòng chọn món ăn trước.");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // [BR1] Check for unpaid Paypal orders and cancel/release stock
            if (orderDAO.checkUnpaidOrder(user.getId())) {
                System.out.println("[BiteSync Checkout] Found unpaid Paypal order. Cancelling and releasing stock...");
                orderDAO.cancelOldOrderAndReleaseStock(user.getId());
            }

            // Check inventory stock for all items
            double subTotal = 0;
            for (CartItem item : cartItems) {
                Food currentDbFood = foodDAO.getFoodById(item.getFoodId());
                if (currentDbFood == null || currentDbFood.getStock() < item.getQuantity()) {
                    session.setAttribute("error", "Sản phẩm \"" + item.getFood().getName() + "\" không đủ số lượng tồn kho (Chỉ còn: " + (currentDbFood != null ? currentDbFood.getStock() : 0) + "). Vui lòng giảm số lượng!");
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
                subTotal += item.getFood().getPrice() * item.getQuantity();
            }

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("subTotal", subTotal);
            request.setAttribute("shippingFee", SHIPPING_FEE);
            request.setAttribute("totalPrice", subTotal + SHIPPING_FEE);
            request.getRequestDispatcher("/pages/checkout.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        if (path.equals("/checkout/apply-promo")) {
            // Handles Ajax code validation
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            String code = request.getParameter("code");
            Promotion promo = promotionDAO.getPromotionByCode(code);
            JsonObject jsonResponse = new JsonObject();

            if (promo != null) {
                jsonResponse.addProperty("valid", true);
                jsonResponse.addProperty("discountPercent", promo.getDiscountPercent());
                jsonResponse.addProperty("message", "Áp dụng mã giảm giá thành công! Giảm " + promo.getDiscountPercent() + "%.");
            } else {
                jsonResponse.addProperty("valid", false);
                jsonResponse.addProperty("message", "Mã giảm giá không hợp lệ hoặc đã hết hạn!");
            }

            response.getWriter().write(jsonResponse.toString());
            return;
        }

        if (path.equals("/checkout")) {
            String fullname = request.getParameter("fullname");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String notes = request.getParameter("notes");
            String payment = request.getParameter("payment");
            String promoCode = request.getParameter("promo_code");

            int cartId = cartDAO.getOrCreateCartId(user.getId());
            List<CartItem> cartItems = cartDAO.fetchUserCart(cartId);

            if (cartItems.isEmpty()) {
                session.setAttribute("error", "Giỏ hàng của bạn đang trống!");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Input Validation
            if (fullname == null || phone == null || address == null || payment == null ||
                    fullname.trim().isEmpty() || phone.trim().isEmpty() || address.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin giao hàng!");
                reloadCheckoutPage(request, response, cartItems);
                return;
            }

            // Phone format validation (simple regex: 10-11 digits)
            if (!phone.trim().matches("^\\d{10,11}$")) {
                request.setAttribute("error", "Số điện thoại không hợp lệ! Vui lòng nhập từ 10-11 chữ số.");
                reloadCheckoutPage(request, response, cartItems);
                return;
            }

            // Inventory Check
            double subTotal = 0;
            for (CartItem item : cartItems) {
                Food currentDbFood = foodDAO.getFoodById(item.getFoodId());
                if (currentDbFood == null || currentDbFood.getStock() < item.getQuantity()) {
                    session.setAttribute("error", "Sản phẩm \"" + item.getFood().getName() + "\" không đủ số lượng tồn kho (Chỉ còn: " + (currentDbFood != null ? currentDbFood.getStock() : 0) + "). Vui lòng cập nhật giỏ hàng!");
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
                subTotal += item.getFood().getPrice() * item.getQuantity();
            }

            // Apply promotion if any
            double discountAmount = 0.00;
            int discountPercent = 0;
            if (promoCode != null && !promoCode.trim().isEmpty()) {
                Promotion promo = promotionDAO.getPromotionByCode(promoCode);
                if (promo != null) {
                    discountPercent = promo.getDiscountPercent();
                    discountAmount = subTotal * (discountPercent / 100.0);
                } else {
                    request.setAttribute("error", "Mã giảm giá không hợp lệ!");
                    reloadCheckoutPage(request, response, cartItems);
                    return;
                }
            }

            double totalPrice = subTotal - discountAmount + SHIPPING_FEE;

            // Prepare Order Object
            Order order = new Order();
            order.setUserId(user.getId());
            order.setFullname(fullname.trim());
            order.setPhone(phone.trim());
            order.setAddress(address.trim());
            order.setNotes(notes != null ? notes.trim() : "");
            order.setPaymentMethod(payment);
            order.setShippingFee(SHIPPING_FEE);
            order.setPromoCode(promoCode != null && !promoCode.trim().isEmpty() ? promoCode.trim().toUpperCase() : null);
            order.setDiscountAmount(discountAmount);
            order.setTotalPrice(totalPrice);

            if (payment.equals("bank")) {
                order.setPaymentStatus("Chờ thanh toán"); // Paypal / Online Bank transfer status
            } else {
                order.setPaymentStatus("Chờ giao hàng"); // COD default status
            }

            // Save order using transaction
            int orderId = orderDAO.createOrder(order, cartItems);

            if (orderId > 0) {
                // Reset cart quantity in session
                session.setAttribute("cartSize", 0);

                if (payment.equals("bank")) {
                    // Redirect to simulated Paypal checkout page
                    response.sendRedirect(request.getContextPath() + "/pages/payment.jsp?orderId=" + orderId + "&total=" + totalPrice);
                } else {
                    // Redirect to order success page
                    response.sendRedirect(request.getContextPath() + "/pages/success.jsp?orderId=" + orderId);
                }
            } else {
                request.setAttribute("error", "Lỗi hệ thống khi tạo đơn hàng! Vui lòng thử lại.");
                reloadCheckoutPage(request, response, cartItems);
            }
        }
    }

    private void reloadCheckoutPage(HttpServletRequest request, HttpServletResponse response, List<CartItem> cartItems)
            throws ServletException, IOException {
        double subTotal = 0;
        for (CartItem item : cartItems) {
            subTotal += item.getFood().getPrice() * item.getQuantity();
        }
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subTotal", subTotal);
        request.setAttribute("shippingFee", SHIPPING_FEE);
        request.setAttribute("totalPrice", subTotal + SHIPPING_FEE);
        request.getRequestDispatcher("/pages/checkout.jsp").forward(request, response);
    }
}
