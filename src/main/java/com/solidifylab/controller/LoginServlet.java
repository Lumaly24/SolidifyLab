package com.solidifylab.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.dao.UserDAO;
import com.solidifylab.model.User; // <-- Import corretto puntato a User

@WebServlet("/Login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Leggiamo email e password inviate dal form di login
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        UserDAO userDAO = new UserDAO();
        
        // 2. Cerchiamo l'utente nel database (usando l'istanza userDAO e il tipo User)
        User utente = userDAO.doRetrieveByEmailAndPassword(email, password);
        
        if (utente != null) {
            // Utente trovato! Creiamo una sessione per ricordarci che è loggato
            HttpSession session = request.getSession();
            session.setAttribute("utenteLoggato", utente);
            
            // Reindirizziamo l'utente alla Home
            response.sendRedirect(request.getContextPath() + "/Home");
        } else {
            // Credenziali errate: rimandiamo al login con un errore
            request.setAttribute("erroreLogin", "Email o password errati!");
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
    }
}