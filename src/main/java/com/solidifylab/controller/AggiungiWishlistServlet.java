package com.solidifylab.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.dao.WishlistDAO;
import com.solidifylab.model.User;

@WebServlet("/AddtoWishlist")
public class AggiungiWishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User utenteLoggato = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;

        if (utenteLoggato == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String idProdottoStr = request.getParameter("id_prodotto");
        
        if (idProdottoStr != null && !idProdottoStr.isEmpty()) {
            try {
                int idProdotto = Integer.parseInt(idProdottoStr);
                int idUtente = utenteLoggato.getId();

                WishlistDAO wishlistDAO = new WishlistDAO();
                
                if (wishlistDAO.isProdottoInWishlist(idUtente, idProdotto)) {
                    wishlistDAO.rimuoviProdotto(idUtente, idProdotto);
                    System.out.println("Prodotto " + idProdotto + " rimosso dalla wishlist.");
                } else {
                    wishlistDAO.aggiungiProdotto(idUtente, idProdotto);
                    System.out.println("Prodotto " + idProdotto + " aggiunto alla wishlist!");
                }

                List<Integer> wishlistIds = wishlistDAO.getWishlistIdsByUtente(idUtente);
                session.setAttribute("wishlistIds", wishlistIds);

            } catch (NumberFormatException e) {
                System.out.println("ID prodotto non valido per la wishlist.");
            }
        } else {
            System.out.println("ERRORE: La Servlet non ha ricevuto l'id_prodotto dalla JSP!");
        }

        response.setStatus(HttpServletResponse.SC_OK);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}