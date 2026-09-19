package com.solidifylab.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.solidifylab.dao.UserDAO; 

@WebServlet("/ForgotPassword")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ForgotPasswordServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/forgotpassword.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("messaggioErrore", "Inserisci un indirizzo email valido.");
            request.getRequestDispatcher("/WEB-INF/view/forgotpassword.jsp").forward(request, response);
            return;
        }


        request.setAttribute("messaggioSuccesso", "Se l'email è associata a un account, riceverai le istruzioni per il reset a breve.");
        request.getRequestDispatcher("/WEB-INF/view/forgotpassword.jsp").forward(request, response);
    }
}