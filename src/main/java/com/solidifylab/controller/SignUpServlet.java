package com.solidifylab.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.solidifylab.dao.UserDAO;
import com.solidifylab.model.User;

@WebServlet("/Signup")
public class SignUpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Leggiamo i parametri inviati dal form di registrazione
        String username = request.getParameter("username"); // Sostituisce nome e cognome
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // 2. Creiamo un oggetto User con i dati ricevuti
        User nuovoUser = new User();
        nuovoUser.setUsername(username); // Nuovo campo
        nuovoUser.setEmail(email);
        nuovoUser.setPasswordHash(password);
        
        // 3. Salviamo l'utente tramite il DAO
        UserDAO userDAO = new UserDAO();
        boolean registrato = userDAO.doSave(nuovoUser);
        
        if (registrato) {
            // Registrazione riuscita! Reindirizziamo al login
            response.sendRedirect(request.getContextPath() + "/login.jsp?registrazione=successo");
        } else {
            // Qualcosa è andato storto (es. email o username già esistenti)
            request.setAttribute("erroreSignup", "Errore durante la registrazione. L'email o l'username potrebbero essere già in uso.");
            request.getRequestDispatcher("/WEB-INF/view/signup.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/signup.jsp").forward(request, response);
    }
}