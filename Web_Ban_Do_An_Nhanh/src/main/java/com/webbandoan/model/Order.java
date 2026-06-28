package com.webbandoan.model;

import java.sql.Timestamp;

public class Order {
    private long id;
    private long userId;
    private String receiveName;
    private String phoneNumber;
    private String shippingAddress;
    private String paymentMethod;
    private String orderStatus;
    private double totalAmount;
    private double finalAmount;
    private Timestamp createdAt;

    public Order() {}

    public Order(long id, long userId, String receiveName, String phoneNumber, String shippingAddress, String paymentMethod, String orderStatus, double totalAmount, double finalAmount, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.receiveName = receiveName;
        this.phoneNumber = phoneNumber;
        this.shippingAddress = shippingAddress;
        this.paymentMethod = paymentMethod;
        this.orderStatus = orderStatus;
        this.totalAmount = totalAmount;
        this.finalAmount = finalAmount;
        this.createdAt = createdAt;
    }

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }

    public String getReceiveName() { return receiveName; }
    public void setReceiveName(String receiveName) { this.receiveName = receiveName; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) { this.orderStatus = orderStatus; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public double getFinalAmount() { return finalAmount; }
    public void setFinalAmount(double finalAmount) { this.finalAmount = finalAmount; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
