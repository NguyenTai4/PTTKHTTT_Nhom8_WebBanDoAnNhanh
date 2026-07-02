package com.webbandoan.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.webbandoan.dao.AccountDAO;
import com.webbandoan.model.User;
import com.webbandoan.model.GooglePojo;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login-google")
public class LoginGoogleController extends HttpServlet {
    private AccountDAO accountDAO;

    private static final String CLIENT_ID = "797549044266-n1h5cl113p3s5pjgm9krg4e1343o16lc.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "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";
    private static final String REDIRECT_URI = "http://localhost:8080/Web_Ban_Do_An_Nhanh/login-google";
    private static final String GOOGLE_LINK_GET_TOKEN = "https://accounts.google.com/o/oauth2/token";
    private static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";

    @Override
    public void init() {
        accountDAO = new AccountDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code == null || code.isEmpty()) {
            request.setAttribute("errorMessage", "Đăng nhập bằng Google thất bại!");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            return;
        }

        String accessToken = getToken(code);

        GooglePojo googleUser = getUserInfo(accessToken);

        if (googleUser != null && googleUser.getEmail() != null) {
            String email = googleUser.getEmail();

            boolean isEmailExist = accountDAO.checkExistEmail(email);

            User user = null;
            if (!isEmailExist) {
                String username = email.split("@")[0];
                if (accountDAO.checkUsernameExists(username)) {
                    username = username + System.currentTimeMillis() % 1000;
                }
                accountDAO.createNewAccount(username, email, "", "GOOGLE_AUTH_ACCOUNT", googleUser.getName());
            }

            user = accountDAO.getAccountDetails(email);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("loggedUser", user);

                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=1");
            }
        }
    }

    private String getToken(String code) throws IOException {
        String response = Request.Post(GOOGLE_LINK_GET_TOKEN)
                .bodyForm(Form.form()
                        .add("client_id", CLIENT_ID)
                        .add("client_secret", CLIENT_SECRET)
                        .add("redirect_uri", REDIRECT_URI)
                        .add("code", code)
                        .add("grant_type", "authorization_code").build())
                .execute().returnContent().asString();

        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        return jobj.get("access_token").toString().replaceAll("\"", "");
    }

    private GooglePojo getUserInfo(String accessToken) throws IOException {
        String link = GOOGLE_LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        return new Gson().fromJson(response, GooglePojo.class);
    }
}