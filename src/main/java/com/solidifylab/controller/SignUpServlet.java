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
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (email == null || email.trim().isEmpty() || 
            username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("errore", "Tutti i campi (Email, Username, Password) sono obbligatori.");
            request.getRequestDispatcher("/WEB-INF/view/signup.jsp").forward(request, response);
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        
        if (userDAO.esisteEmail(email)) {
            request.setAttribute("errore", "L'email è già in uso");
            request.getRequestDispatcher("/WEB-INF/view/signup.jsp").forward(request, response);
            return;
        }
        
        User nuovoUser = new User();
        nuovoUser.setUsername(username); 
        nuovoUser.setEmail(email);
        nuovoUser.setPasswordHash(password);
        
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