package com.webbandoan.utils;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

/**
 * Utility service to send email messages (e.g. OTP validation) via Gmail SMTP.
 */
public class EmailService {

    // Read Gmail SMTP credentials from environment variables for security
    private static final String SENDER_EMAIL = System.getenv("BITESYNC_EMAIL"); 
    private static final String SENDER_PASSWORD = System.getenv("BITESYNC_APP_PASSWORD"); 

    /**
     * Sends a 6-digit OTP code to the recipient email via Gmail SMTP.
     * Also writes it to a local debug file for easy local testing.
     */
    public static void sendEmailOTP(String recipientEmail, String otpCode) {
        if (SENDER_EMAIL != null && SENDER_PASSWORD != null && !SENDER_EMAIL.trim().isEmpty() && !SENDER_PASSWORD.trim().isEmpty()) {
            sendRealSMTP(recipientEmail, otpCode);
        } else {
            System.err.println("[BiteSync SMTP Warning] BITESYNC_EMAIL or BITESYNC_APP_PASSWORD environment variables are not set. Simulating email sending...");
        }
        
        // Debug output (Banner - plain ASCII to prevent encoding errors in Windows terminal)
        System.out.println("\n=================================================================");
        System.out.println("                    [BITESYNC OTP SERVICE]");
        System.out.println("=================================================================");
        System.out.println("  DA GUI MA XAC THUC DEN EMAIL: " + recipientEmail);
        System.out.println("  MA OTP CUA BAN LA           : " + otpCode);
        System.out.println("  THOI GIAN HIEU LUC          : 60 GIAY");
        System.out.println("=================================================================\n");

        // Write OTP to a local debug file for testing automation
        try {
            java.nio.file.Files.writeString(
                java.nio.file.Path.of("otp_debug.txt"),
                "email=" + recipientEmail + "\notp=" + otpCode + "\ntime=" + System.currentTimeMillis()
            );
        } catch (Exception e) {
            System.err.println("Failed to write otp_debug.txt: " + e.getMessage());
        }
    }

    private static void sendRealSMTP(String recipientEmail, String otpCode) {
        Properties prop = new Properties();
        prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.port", "587");
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(prop, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL, "BiteSync Fast Food"));
            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(recipientEmail)
            );
            message.setSubject("[BiteSync] Ma xac thuc OTP khoi phuc mat khau");

            String htmlContent = "<div style=\"font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px;\">"
                    + "<div style=\"text-align: center; margin-bottom: 20px;\">"
                    + "<h2 style=\"color: #ff5e36;\">BiteSync Fast Food</h2>"
                    + "</div>"
                    + "<h3>Xac thuc khoi phuc mat khau</h3>"
                    + "<p>Xin chao,</p>"
                    + "<p>Ban da yeu cau khoi phuc mat khau cho tai khoan tren BiteSync. Day la ma OTP cua ban:</p>"
                    + "<div style=\"background-color: #f8f9fa; padding: 15px; text-align: center; border-radius: 5px; margin: 20px 0;\">"
                    + "<span style=\"font-size: 24px; font-weight: bold; color: #ff5e36; letter-spacing: 5px;\">" + otpCode + "</span>"
                    + "</div>"
                    + "<p>Ma nay co hieu luc trong <strong>60 giay</strong>. Vui long khong chia se ma nay voi bat ky ai.</p>"
                    + "<p>Tran trong,<br>Doi ngu BiteSync</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("[BiteSync SMTP] Da gui mail thanh cong den: " + recipientEmail);
        } catch (Exception e) {
            System.err.println("[BiteSync SMTP Error] Loi khi gui mail SMTP: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
