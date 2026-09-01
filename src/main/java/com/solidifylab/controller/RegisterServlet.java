package com.solidifylab.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.solidifylab.dao.UserDAO;
import com.solidifylab.model.User;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Recupero i parametri dal form HTML (es. signup.jsp)
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 2. Validazione di base per evitare campi vuoti
        if (email == null || email.trim().isEmpty() || 
            username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("errore", "Tutti i campi (Email, Username, Password) sono obbligatori.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        // 3. Creazione del Bean User
        User nuovoUtente = new User();
        nuovoUtente.setEmail(email);
        nuovoUtente.setUsername(username);
        
        // NOTA: Se per il progetto TSW avete creato una classe di utilità per l'hashing 
        // (es. SHA-256), dovresti richiamarla qui.
        nuovoUtente.setPasswordHash(password); 

        // 4. Salvataggio tramite DAO
        UserDAO userDao = new UserDAO();
        boolean registrazioneOk = userDao.doSave(nuovoUtente);

        // 5. Reindirizzamento in base al risultato
        if (registrazioneOk) {
            // === OPZIONE 2: Login automatico e redirect alla Home ===
            
            // Recupera l'utente completo dal DB (serve per avere l'ID generato automaticamente)
            User utenteCompleto = userDao.doRetrieveByEmailAndPassword(email, password);
            
            // Salva l'utente nella sessione per loggarlo
            request.getSession().setAttribute("utenteLoggato", utenteCompleto);
            
            // Reindirizza alla Home Page (modifica "index.jsp" se usi un'altra Servlet per la home)
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            
        } else {
            // Se fallisce (probabilmente email o username già presenti nel DB cloud)
            request.setAttribute("errore", "Registrazione fallita. Username o Email già in uso.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Se qualcuno prova ad accedere tramite URL (GET), lo rimandiamo al form
        response.sendRedirect(request.getContextPath() + "/signup.jsp");
    }
}