package com.solidifylab.controller;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.model.User;
import com.solidifylab.dao.WishlistDAO; // Assicurati di avere questo DAO!

@WebServlet("/AggiungiWishlistServlet")
public class AggiungiWishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Controllo se l'utente è loggato
        HttpSession session = request.getSession();
        User utenteLoggato = (User) session.getAttribute("utenteLoggato");

        if (utenteLoggato == null) {
            // Se non è loggato, lo rimandiamo alla pagina di login
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 2. Recupero l'ID del prodotto cliccato
        String idProdottoStr = request.getParameter("id");
        
        if (idProdottoStr != null && !idProdottoStr.isEmpty()) {
            try {
                int idProdotto = Integer.parseInt(idProdottoStr);
                int idUtente = utenteLoggato.getId();

                WishlistDAO wishlistDAO = new WishlistDAO();
                
                // Salvo nel Database
                wishlistDAO.aggiungiProdotto(idUtente, idProdotto);

                // Aggiorno la lista in sessione
                session.setAttribute("wishlist", wishlistDAO.getWishlistByUtente(idUtente));

            } catch (NumberFormatException e) {
                System.out.println("ID prodotto non valido per la wishlist.");
            }
            // Il blocco catch SQLException è stato rimosso!
        }

        // 5. Rimando l'utente alla pagina da cui ha cliccato il bottone (Referer)
        String referer = request.getHeader("Referer");
        if (referer != null) {
            response.sendRedirect(referer);
        } else {
            // Fallback se il referer non è disponibile
            response.sendRedirect(request.getContextPath() + "/catalogo.jsp");
        }
    }

    // Permettiamo anche il GET nel caso tu voglia usare un semplice tag <a> invece di un form
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}