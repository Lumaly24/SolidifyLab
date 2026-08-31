package com.solidifylab.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.model.User;

@WebServlet("/ModificaProdotto")
public class ModificaProdottoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User utente = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
        
        // Verifica se l'utente esiste e se il suo ruolo è ADMIN
        if (utente != null && "ADMIN".equalsIgnoreCase(utente.getRuolo())) {
            // In futuro qui prenderai l'ID del prodotto da modificare e lo passerai alla JSP
            request.getRequestDispatcher("/WEB-INF/view/modifica-prodotto.jsp").forward(request, response);
        } else {
            // Selezionata zona vietata! Via alla Home.
            response.sendRedirect(request.getContextPath() + "/Home");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Gestirà il form con il salvataggio effettivo delle modifiche nel DB
        doGet(request, response);
    }
}