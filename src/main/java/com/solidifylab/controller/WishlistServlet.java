package com.solidifylab.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.model.User;
import com.solidifylab.dao.WishlistDAO;
import com.solidifylab.model.Prodotto;

@WebServlet("/Wishlist") 
public class WishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Recuperiamo la sessione (passando false, non ne crea una nuova se non esiste)
        HttpSession session = request.getSession(false);
        
        // 2. Controlliamo se c'è un utente loggato
        User utenteLoggato = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
        
        if (utenteLoggato != null) {
            
            // 3. IL PEZZO MANCANTE: Chiediamo al Database i prodotti salvati!
            WishlistDAO wishlistDAO = new WishlistDAO();
            List<Prodotto> listaWishlist = wishlistDAO.getWishlistByUtente(utenteLoggato.getId());
            
            // 4. Passiamo la lista alla JSP
            request.setAttribute("listaWishlist", listaWishlist);
            
            // 5. L'utente è loggato! Gli mostriamo la sua bellissima wishlist
            request.getRequestDispatcher("/WEB-INF/view/wishlist.jsp").forward(request, response);
            
        } else {
            // L'utente NON è loggato. Lo reindirizziamo al login con un messaggino
            response.sendRedirect(request.getContextPath() + "/Login?errore=auth");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}