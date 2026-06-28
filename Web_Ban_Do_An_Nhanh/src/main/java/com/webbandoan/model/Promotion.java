package com.webbandoan.model;

import java.io.Serializable;

public class Promotion implements Serializable {
    private static final long serialVersionUID = 1L;

    private String code;
    private int discountPercent;
    private boolean isActive;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
}
