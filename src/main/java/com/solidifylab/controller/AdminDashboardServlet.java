package com.solidifylab.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.model.User;

@WebServlet("/AdminDashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User utente = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
        
        // Verifica se l'utente esiste e se il suo ruolo è ADMIN (o AMMINISTRATORE)
        if (utente != null && "ADMIN".equalsIgnoreCase(utente.getRuolo())) {
            request.getRequestDispatcher("/WEB-INF/view/admin-dashboard.jsp").forward(request, response);
        } else {
            // Se non è admin, via da qui! Lo rimandiamo alla home.
            response.sendRedirect(request.getContextPath() + "/Home");
        }
    }
}