package com.webbandoan.model;

public class Product {
    private long id;
    private int categoryId;
    private String name;
    private String description;
    private double price;
    private String image;
    private int quantityInStock;

    public Product() {}

    public Product(long id, int categoryId, String name, String description, double price, String image, int quantityInStock) {
        this.id = id;
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.image = image;
        this.quantityInStock = quantityInStock;
    }

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public int getQuantityInStock() { return quantityInStock; }
    public void setQuantityInStock(int quantityInStock) { this.quantityInStock = quantityInStock; }
}
