package com.solidifylab.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.dao.MetodoPagamentoDAO;
import com.solidifylab.dao.UserDAO;
import com.solidifylab.dao.WishlistDAO;
import com.solidifylab.dao.CarrelloDAO;
import com.solidifylab.dao.LibreriaDAO;
import com.solidifylab.dao.SpedizioneDAO;
import com.solidifylab.model.User;
import com.solidifylab.model.Carrello;
import com.solidifylab.model.Spedizione;
import com.solidifylab.model.SecurityUtils; 

@WebServlet("/Login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String passwordInChiaro = request.getParameter("password");
        String redirectParam = request.getParameter("redirect");
        
        UserDAO userDAO = new UserDAO();
        
        User utente = userDAO.getUtenteByEmail(email);
        
        boolean passwordValida = false;
        
        if (utente != null) {
        	
            String hashTentativo = SecurityUtils.hashPassword(passwordInChiaro);
            
            if (hashTentativo.equals(utente.getPasswordHash())) {
            	
                passwordValida = true;
            }
        }
        
        if (utente != null && passwordValida) {
            
            HttpSession session = request.getSession();
            session.setAttribute("utenteLoggato", utente);
            
            SpedizioneDAO spedizioneDAO = new SpedizioneDAO();
            Spedizione indirizzo = spedizioneDAO.getIndirizzoPrincipale(utente.getId());
            
            if (indirizzo != null) {
                session.setAttribute("indirizzoPrincipale", indirizzo);
            }
            
            try {
            	
                WishlistDAO wishlistDAO = new WishlistDAO();
                List<Integer> wishlistIds = wishlistDAO.getWishlistIdsByUtente(utente.getId());
                session.setAttribute("wishlistIds", wishlistIds);
                
                CarrelloDAO carrelloDAO = new CarrelloDAO();
                Carrello carrelloSessione = (Carrello) session.getAttribute("carrello");
                
                if (carrelloSessione != null && !carrelloSessione.getProdotti().isEmpty()) {
                	
                    carrelloDAO.salvaOAggiornaCarrello(utente.getId(), carrelloSessione);
                }
                
                Carrello carrelloDb = carrelloDAO.getCarrelloByUtente(utente.getId());
                session.setAttribute("carrello", carrelloDb);
                
                LibreriaDAO libreriaDAO = new LibreriaDAO();
                session.setAttribute("libreriaDigitale", libreriaDAO.getLibreriaByUtente(utente.getId()));
                session.setAttribute("idAssetPosseduti", libreriaDAO.getIdAssetPosseduti(utente.getId()));
                
                MetodoPagamentoDAO pagamentoDAO = new MetodoPagamentoDAO();
                session.setAttribute("metodiPagamento", pagamentoDAO.getMetodiByUtente(utente.getId()));
                
                System.out.println("Wishlist e Carrello caricati al login per l'utente: " + utente.getId());
                
            } catch (Exception e) {
            	
                System.out.println("Errore durante il caricamento dei dati utente al login: " + e.getMessage());
            }
            
            if (redirectParam != null && !redirectParam.trim().isEmpty()) {
            	
                response.sendRedirect(request.getContextPath() + "/" + redirectParam);
                
            } else {
            	
                response.sendRedirect(request.getContextPath() + "/Home");
            }
            
        } else {
        	
            request.setAttribute("erroreLogin", "Email o password errati!");
            request.setAttribute("redirect", redirectParam);
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String redirect = request.getParameter("redirect");
        if (redirect != null && !redirect.trim().isEmpty()) {
            request.setAttribute("redirect", redirect);
        }
        
        request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
    }
}