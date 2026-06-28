package com.webbandoan.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Order implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private String fullname;
    private String phone;
    private String address;
    private String notes;
    private String paymentMethod;
    private String paymentStatus;
    private double totalPrice;
    private String promoCode;
    private double discountAmount;
    private double shippingFee;
    private Timestamp createdAt;

    public Order() {}

    // Constructor phục vụ cho UC9 (Order Tracking)
    public Order(long id, long userId, String receiveName, String phoneNumber, String shippingAddress, String paymentMethod, String orderStatus, double totalAmount, double finalAmount, Timestamp createdAt) {
        this.id = (int) id;
        this.userId = (int) userId;
        this.fullname = receiveName;
        this.phone = phoneNumber;
        this.address = shippingAddress;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = orderStatus;
        this.totalPrice = totalAmount;
        // Bỏ qua finalAmount vì logic mới dùng totalPrice, discountAmount, shippingFee
        this.createdAt = createdAt;
    }

    // --- CÁC GETTER/SETTER CHO CODE MỚI ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public String getPromoCode() { return promoCode; }
    public void setPromoCode(String promoCode) { this.promoCode = promoCode; }

    public double getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(double discountAmount) { this.discountAmount = discountAmount; }

    public double getShippingFee() { return shippingFee; }
    public void setShippingFee(double shippingFee) { this.shippingFee = shippingFee; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    // --- ALIAS GETTER/SETTER ĐỂ KHÔNG PHÁ VỠ CODE UC9 CŨ ---
    public String getReceiveName() { return fullname; }
    public void setReceiveName(String receiveName) { this.fullname = receiveName; }

    public String getPhoneNumber() { return phone; }
    public void setPhoneNumber(String phoneNumber) { this.phone = phoneNumber; }

    public String getShippingAddress() { return address; }
    public void setShippingAddress(String shippingAddress) { this.address = shippingAddress; }

    public String getOrderStatus() { return paymentStatus; }
    public void setOrderStatus(String orderStatus) { this.paymentStatus = orderStatus; }

    public double getTotalAmount() { return totalPrice; }
    public void setTotalAmount(double totalAmount) { this.totalPrice = totalAmount; }

    public double getFinalAmount() { return totalPrice - discountAmount + shippingFee; } 
    public void setFinalAmount(double finalAmount) { /* Not needed */ }
}
