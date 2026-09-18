package com.solidifylab.controller;

import java.io.IOException;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.dao.CarrelloDAO;
import com.solidifylab.dao.LibreriaDAO;
import com.solidifylab.dao.OrdineDAO;
import com.solidifylab.model.Carrello;
import com.solidifylab.model.Ordine;
import com.solidifylab.model.User;

@WebServlet("/ElaboraPagamentoServlet")
public class ElaboraPagamentoServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession();

        User utente = (User) session.getAttribute("utenteLoggato");
        
        if (utente == null) {
        	
            session.setAttribute("messaggioAuth", "Sessione scaduta. Registrati o accedi per completare l'ordine.");
            response.sendRedirect(request.getContextPath() + "/Login"); 
            return;
        }

        Carrello carrello = (Carrello) session.getAttribute("carrello");
        
        if (carrello == null || carrello.getProdotti().isEmpty()) {
        	
            response.sendRedirect(request.getContextPath() + "/Carrello");
            return;
        }

        String nomeCarta = request.getParameter("nome_carta");
        String numeroCarta = request.getParameter("numero_carta");
        String scadenza = request.getParameter("scadenza");
        String cvv = request.getParameter("cvv");

        if (numeroCarta != null) {
        	
            numeroCarta = numeroCarta.replace(" ", "");
        }

        if (nomeCarta == null || nomeCarta.trim().isEmpty() || numeroCarta == null || numeroCarta.length() != 16 || cvv == null || cvv.length() != 3) {
        	
            request.setAttribute("erroreCheckout", "Dati della carta non validi. Controlla i campi.");
            request.getRequestDispatcher("/WEB-INF/view/checkout.jsp").forward(request, response);
            return;
        }
        
        try {
        	
            if (scadenza == null || !scadenza.matches("^(0[1-9]|1[0-2])/\\d{2}$")) {
                throw new IllegalArgumentException("Formato scadenza non valido.");
            }

            String[] parts = scadenza.split("/");
            
            int meseScadenza = Integer.parseInt(parts[0]);
            int annoScadenza = 2000 + Integer.parseInt(parts[1]); 

            java.time.YearMonth dataScadenza = java.time.YearMonth.of(annoScadenza, meseScadenza);
            java.time.YearMonth meseCorrente = java.time.YearMonth.now();

            if (dataScadenza.isBefore(meseCorrente)) {
                throw new IllegalArgumentException("La carta inserita è scaduta.");
            }
            
        } catch (IllegalArgumentException e) {
        	
            request.setAttribute("erroreCheckout", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/checkout.jsp").forward(request, response);
            return;
        }

        Ordine ordine = new Ordine();
        ordine.setData(LocalDate.now().toString());
        ordine.setTotale(carrello.getTotaleFinale());
        ordine.setStato("PAGATO");
        ordine.setUtente(utente); 

        OrdineDAO ordineDAO = new OrdineDAO();
        
        boolean salvato = ordineDAO.doSave(ordine, carrello);

        if (salvato) {
            
            CarrelloDAO carrelloDAO = new CarrelloDAO();
            carrello.getProdotti().clear();
            carrelloDAO.salvaOAggiornaCarrello(utente.getId(), carrello);

            LibreriaDAO libreriaDAO = new LibreriaDAO();
            session.setAttribute("libreriaDigitale", libreriaDAO.getLibreriaByUtente(utente.getId()));
            session.setAttribute("idAssetPosseduti", libreriaDAO.getIdAssetPosseduti(utente.getId()));

            session.removeAttribute("carrello");
            session.setAttribute("ultimoOrdine", ordine);
            response.sendRedirect(request.getContextPath() + "/FatturaServlet");
            
        } else {
        	
            request.setAttribute("erroreCheckout", "Errore durante il salvataggio dell'ordine.");
            request.getRequestDispatcher("/WEB-INF/view/checkout.jsp").forward(request, response);
        }
    }
}