package com.webbandoan.utils;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;
import org.apache.http.entity.ContentType;

public class PaypalService {

    // Retrieve credentials from environment variables (fallback to empty string if not configured)
    private static final String CLIENT_ID = System.getenv("PAYPAL_CLIENT_ID") != null ? System.getenv("PAYPAL_CLIENT_ID") : "";
    private static final String CLIENT_SECRET = System.getenv("PAYPAL_CLIENT_SECRET") != null ? System.getenv("PAYPAL_CLIENT_SECRET") : "";
    
    private static final String API_URL = "https://api-m.sandbox.paypal.com";

    private String getAccessToken() throws Exception {
        if (CLIENT_ID == null || CLIENT_ID.trim().isEmpty() || CLIENT_SECRET == null || CLIENT_SECRET.trim().isEmpty()) {
            throw new IllegalStateException("PayPal API Credentials are not configured.");
        }
        
        String auth = CLIENT_ID + ":" + CLIENT_SECRET;
        String encodedAuth = java.util.Base64.getEncoder().encodeToString(auth.getBytes("UTF-8"));

        String response = Request.Post(API_URL + "/v1/oauth2/token")
                .addHeader("Authorization", "Basic " + encodedAuth)
                .addHeader("Accept", "application/json")
                .bodyForm(Form.form().add("grant_type", "client_credentials").build())
                .execute()
                .returnContent()
                .asString();

        JsonObject json = JsonParser.parseString(response).getAsJsonObject();
        return json.get("access_token").getAsString();
    }

    /**
     * Creates a PayPal order and returns the approval URL redirect.
     * Returns null if credentials are empty or request fails, prompting simulator fallback.
     */
    public String createPaypalOrder(int orderId, double total, String returnUrl, String cancelUrl) {
        try {
            String accessToken = getAccessToken();

            JsonObject requestBody = new JsonObject();
            requestBody.addProperty("intent", "CAPTURE");

            JsonObject purchaseUnit = new JsonObject();
            purchaseUnit.addProperty("reference_id", String.valueOf(orderId));

            JsonObject amount = new JsonObject();
            amount.addProperty("currency_code", "USD");
            amount.addProperty("value", String.format(java.util.Locale.US, "%.2f", total));
            purchaseUnit.add("amount", amount);

            JsonArray purchaseUnits = new JsonArray();
            purchaseUnits.add(purchaseUnit);
            requestBody.add("purchase_units", purchaseUnits);

            JsonObject appContext = new JsonObject();
            appContext.addProperty("return_url", returnUrl + "?orderId=" + orderId);
            appContext.addProperty("cancel_url", cancelUrl + "?orderId=" + orderId);
            requestBody.add("application_context", appContext);

            String response = Request.Post(API_URL + "/v2/checkout/orders")
                    .addHeader("Authorization", "Bearer " + accessToken)
                    .addHeader("Content-Type", "application/json")
                    .bodyString(requestBody.toString(), ContentType.APPLICATION_JSON)
                    .execute()
                    .returnContent()
                    .asString();

            JsonObject json = JsonParser.parseString(response).getAsJsonObject();
            JsonArray links = json.getAsJsonArray("links");
            if (links != null) {
                for (int i = 0; i < links.size(); i++) {
                    JsonObject link = links.get(i).getAsJsonObject();
                    if ("approve".equals(link.get("rel").getAsString())) {
                        return link.get("href").getAsString();
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("[BiteSync PayPal Service] Real PayPal setup skipped (falling back to simulator): " + e.getMessage());
        }
        return null;
    }

    /**
     * Captures payment for a completed PayPal order.
     */
    public boolean capturePaypalOrder(String paypalOrderId) {
        try {
            String accessToken = getAccessToken();

            String response = Request.Post(API_URL + "/v2/checkout/orders/" + paypalOrderId + "/capture")
                    .addHeader("Authorization", "Bearer " + accessToken)
                    .addHeader("Content-Type", "application/json")
                    .execute()
                    .returnContent()
                    .asString();

            JsonObject json = JsonParser.parseString(response).getAsJsonObject();
            String status = json.get("status").getAsString();
            return "COMPLETED".equals(status);
        } catch (Exception e) {
            System.err.println("[BiteSync PayPal Service] Capture failed: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
