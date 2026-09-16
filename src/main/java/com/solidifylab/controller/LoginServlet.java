package com.solidifylab.controller;

import java.io.IOException;
import java.util.List; // Aggiunto import per la lista

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.dao.UserDAO;
import com.solidifylab.dao.WishlistDAO; 
import com.solidifylab.model.User;

@WebServlet("/Login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        UserDAO userDAO = new UserDAO();
        
        User utente = userDAO.doRetrieveByEmailAndPassword(email, password);
        
        if (utente != null) {
            HttpSession session = request.getSession();
            
            session.setAttribute("utenteLoggato", utente);
            
            try {
                WishlistDAO wishlistDAO = new WishlistDAO();
                List<Integer> wishlistIds = wishlistDAO.getWishlistIdsByUtente(utente.getId());
                session.setAttribute("wishlistIds", wishlistIds);
                
                System.out.println("Wishlist caricata al login per l'utente: " + utente.getId());
            } catch (Exception e) {
                System.out.println("Errore durante il caricamento della wishlist al login: " + e.getMessage());
            }
            
            response.sendRedirect(request.getContextPath() + "/Home");
        } else {
            request.setAttribute("erroreLogin", "Email o password errati!");
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
    }
}