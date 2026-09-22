package com.solidifylab.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.solidifylab.dao.UserDAO;
import com.solidifylab.model.SecurityUtils;

@WebServlet("/Signup")

public class SignUpServlet extends HttpServlet {
	
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String passwordInChiaro = request.getParameter("password");
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        
        if (email == null || email.trim().isEmpty() || 
            username == null || username.trim().isEmpty() || 
            passwordInChiaro == null || passwordInChiaro.trim().isEmpty() ||
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
        
        String passwordHashata = SecurityUtils.hashPassword(passwordInChiaro);
        
        boolean successo = userDAO.salvaUtente(email, passwordHashata, username.trim(), nome.trim(), cognome.trim());
        
        if (successo) {
        	
            response.sendRedirect(request.getContextPath() + "/Login?registrazione=ok");
            return;
        } else {
        	
            request.setAttribute("errore", "Registrazione fallita. L'username potrebbe essere già in uso.");
            request.getRequestDispatcher("/WEB-INF/view/signup.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/signup.jsp").forward(request, response);
    }
}