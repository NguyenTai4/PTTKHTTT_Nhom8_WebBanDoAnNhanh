package com.webbandoan.model;

import java.sql.Date;

public class Voucher {
    private int voucherId;
    private String voucherCode;
    private String voucherName;
    private String voucherImage;
    private String description;
    private int discountAmount;

    public Voucher() {}

    public Voucher(int voucherId, int discountAmount, String description, String voucherImage, String voucherName, String voucherCode) {
        this.voucherId = voucherId;
        this.discountAmount = discountAmount;
        this.description = description;
        this.voucherImage = voucherImage;
        this.voucherName = voucherName;
        this.voucherCode = voucherCode;
    }
    public int getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(int voucherId) {
        this.voucherId = voucherId;
    }

    public int getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(int discountAmount) {
        this.discountAmount = discountAmount;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getVoucherImage() {
        return voucherImage;
    }

    public void setVoucherImage(String voucherImage) {
        this.voucherImage = voucherImage;
    }

    public String getVoucherName() {
        return voucherName;
    }

    public void setVoucherName(String voucherName) {
        this.voucherName = voucherName;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }
}
