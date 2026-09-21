package com.solidifylab.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.model.Carrello;
import com.solidifylab.model.User;

@WebServlet("/Checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        Carrello carrello = (Carrello) session.getAttribute("carrello");
        if (carrello == null || carrello.getProdotti().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Carrello");
            return;
        }

        User utente = (User) session.getAttribute("utenteLoggato");
        if (utente == null) {
        	response.sendRedirect(request.getContextPath() + "/Login?redirect=Checkout"); 
            return;
        }

        request.getRequestDispatcher("/WEB-INF/view/checkout.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}