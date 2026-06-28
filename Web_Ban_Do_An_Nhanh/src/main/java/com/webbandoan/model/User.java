package com.webbandoan.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model class representing a user/account.
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String username;
    private String email;
    private String phone;
    private String password; // hashed
    private String fullname;
    private boolean isActivated = true;
    private Timestamp createdAt;

    // Default Constructor
    public User() {
    }

    // Parameterized Constructor (with ID and createdAt)
    public User(int id, String username, String email, String phone, String password, String fullname, Timestamp createdAt) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.fullname = fullname;
        this.createdAt = createdAt;
    }

    // Parameterized Constructor (without ID and createdAt)
    public User(String username, String email, String phone, String password, String fullname) {
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.fullname = fullname;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isActivated() {
        return isActivated;
    }

    public void setActivated(boolean isActivated) {
        this.isActivated = isActivated;
    }
}
