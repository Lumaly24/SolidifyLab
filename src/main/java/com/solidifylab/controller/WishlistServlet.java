package com.solidifylab.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.model.User;

@WebServlet("/Wishlist") 
public class WishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Recuperiamo la sessione (passando false, non ne crea una nuova se non esiste)
        HttpSession session = request.getSession(false);
        
        // 2. Controlliamo se c'è un utente loggato (usando la stessa chiave che hai usato nella LoginServlet)
        User utenteLoggato = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
        
        if (utenteLoggato != null) {
            // L'utente è loggato! Gli mostriamo la sua bellissima wishlist
            request.getRequestDispatcher("/WEB-INF/view/wishlist.jsp").forward(request, response);
        } else {
            // L'utente NON è loggato. Lo reindirizziamo al login con un messaggino
            // Passiamo un parametro nell'URL per far capire alla JSP perché siamo qui
            response.sendRedirect(request.getContextPath() + "/Login?errore=auth");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}