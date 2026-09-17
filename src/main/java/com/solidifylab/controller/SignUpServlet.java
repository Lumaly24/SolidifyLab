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
        
        User nuovoUser = new User();
        nuovoUser.setUsername(username); 
        nuovoUser.setEmail(email);
        nuovoUser.setPasswordHash(password);
        
        UserDAO userDAO = new UserDAO();
        boolean registrato = userDAO.doSave(nuovoUser);
        
        if (registrato) {
        	
            response.sendRedirect(request.getContextPath() + "/login.jsp?registrazione=successo");
            
        } else {
        	
            request.setAttribute("erroreSignup", "Errore durante la registrazione. L'email o l'username potrebbero essere già in uso.");
            request.getRequestDispatcher("/WEB-INF/view/signup.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/signup.jsp").forward(request, response);
    }
}