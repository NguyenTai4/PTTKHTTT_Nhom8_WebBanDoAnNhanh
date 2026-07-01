package com.webbandoan.model;

public class DashboardDTO {
    private double totalRevenue;
    private int totalStock;
    private int totalCustomers;
    private int pendingOrders;

    public DashboardDTO(double totalRevenue, int totalStock, int totalCustomers, int pendingOrders) {
        this.totalRevenue = totalRevenue;
        this.totalStock = totalStock;
        this.totalCustomers = totalCustomers;
        this.pendingOrders = pendingOrders;
    }
    public DashboardDTO() {}

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public int getTotalStock() {
        return totalStock;
    }

    public void setTotalStock(int totalStock) {
        this.totalStock = totalStock;
    }

    public int getTotalCustomers() {
        return totalCustomers;
    }

    public void setTotalCustomers(int totalCustomers) {
        this.totalCustomers = totalCustomers;
    }

    public int getPendingOrders() {
        return pendingOrders;
    }

    public void setPendingOrders(int pendingOrders) {
        this.pendingOrders = pendingOrders;
    }
}
