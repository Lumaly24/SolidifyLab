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
        
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        
        if (email == null || email.trim().isEmpty() || 
            username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty() ||
            nome == null || nome.trim().isEmpty() ||
            cognome == null || cognome.trim().isEmpty()) {
            
            request.setAttribute("errore", "Tutti i campi (Nome, Cognome, Email, Username, Password) sono obbligatori.");
            request.getRequestDispatcher("/WEB-INF/view/signup.jsp").forward(request, response);
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        
        if (userDAO.esisteEmail(email)) {
            request.setAttribute("errore", "L'email è già in uso.");
            request.getRequestDispatcher("/WEB-INF/view/signup.jsp").forward(request, response);
            return;
        }
        
        User nuovoUser = new User();
        nuovoUser.setUsername(username.trim()); 
        nuovoUser.setEmail(email.trim());
        nuovoUser.setPasswordHash(password);
        nuovoUser.setNome(nome.trim());
        nuovoUser.setCognome(cognome.trim());
        
        boolean registrato = userDAO.doSave(nuovoUser);
        
        if (registrato) {
            User utenteCompleto = userDAO.doRetrieveByEmailAndPassword(email, password);
            if (utenteCompleto != null) {
                request.getSession().setAttribute("utenteLoggato", utenteCompleto);
            }
            
            response.sendRedirect(request.getContextPath() + "/Home");
        } else {
            request.setAttribute("errore", "Registrazione fallita. L'username potrebbe essere già in uso.");
            request.getRequestDispatcher("/WEB-INF/view/signup.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/signup.jsp").forward(request, response);
    }
}