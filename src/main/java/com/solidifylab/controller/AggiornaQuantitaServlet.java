package com.solidifylab.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.model.Carrello;
import com.solidifylab.model.ItemCarrello;
import com.solidifylab.model.User;
import com.solidifylab.dao.CarrelloDAO;

@WebServlet("/AggiornaQuantitaServlet")
public class AggiornaQuantitaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String idProdottoStr = request.getParameter("id_prodotto");
        String quantitaStr = request.getParameter("quantita");

        if (idProdottoStr != null && quantitaStr != null) {
            try {
                int idProdotto = Integer.parseInt(idProdottoStr);
                int nuovaQuantita = Integer.parseInt(quantitaStr);

                if (nuovaQuantita < 1) {
                    nuovaQuantita = 1;
                }

                HttpSession session = request.getSession(false);
                Carrello carrello = (session != null) ? (Carrello) session.getAttribute("carrello") : null;

                if (carrello != null) {
                    for (ItemCarrello item : carrello.getProdotti()) {
                        
                        if (item.getProdotto().getId() == idProdotto) {
                            
                            if (item.getProdotto().getCategoriaId() == 3) {
                                item.setQuantita(nuovaQuantita);
                            } else {
                                item.setQuantita(1);
                            }
                            
                            break; 
                        }
                    }
                    
                    User utenteLoggato = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
                    if (utenteLoggato != null) {
                        CarrelloDAO carrelloDAO = new CarrelloDAO();
                        carrelloDAO.salvaOAggiornaCarrello(utenteLoggato.getId(), carrello);
                    }
                }
            } catch (NumberFormatException e) {
                System.out.println("Errore nel formato dei numeri per l'aggiornamento quantità.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/Carrello");
    }
}