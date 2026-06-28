package com.webbandoan.utils;

import java.security.MessageDigest;

/**
 * Utility class for hashing strings (e.g. passwords) using SHA-256.
 */
public class HashUtils {

    /**
     * Hashes a string using SHA-256 and returns its hexadecimal representation.
     */
    public static String sha256(String base) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(base.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception ex) {
            throw new RuntimeException("[BiteSync Hash] Error hashing string", ex);
        }
    }
}
