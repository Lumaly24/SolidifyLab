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
import com.solidifylab.model.Prodotto;
import com.solidifylab.model.User;
import com.solidifylab.dao.ProdottoDAO;
import com.solidifylab.dao.CarrelloDAO;

@WebServlet("/AddtoCart")
public class AggiungiAlCarrelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String idProdottoStr = request.getParameter("id_prodotto");
        String azione = request.getParameter("azione"); 
        String isAjax = request.getParameter("isAjax"); 
        
        String quantitaStr = request.getParameter("quantita");
        int quantitaDaAggiungere = (quantitaStr != null && !quantitaStr.isEmpty()) ? Integer.parseInt(quantitaStr) : 1;
        
        HttpSession session = request.getSession();
        Carrello carrello = (Carrello) session.getAttribute("carrello");
        
        if (carrello == null) {
            carrello = new Carrello();
            session.setAttribute("carrello", carrello);
        }

        User utenteLoggato = (User) session.getAttribute("utenteLoggato");
        CarrelloDAO carrelloDAO = new CarrelloDAO();

        if ("svuota_carrello".equals(azione)) {
            carrello.getProdotti().clear(); 
            session.setAttribute("carrello", carrello); 
            
            if (utenteLoggato != null) {
                carrelloDAO.salvaOAggiornaCarrello(utenteLoggato.getId(), carrello);
            }
            
            response.sendRedirect(request.getContextPath() + "/Carrello"); 
            return; 
        }
        
        if (idProdottoStr != null && !idProdottoStr.isEmpty()) {
            
            int idProdotto = Integer.parseInt(idProdottoStr);

            ProdottoDAO prodottoDAO = new ProdottoDAO();
            Prodotto prodottoTrovato = prodottoDAO.doRetrieveById(idProdotto);
            
            if (prodottoTrovato != null) {
                
                boolean giaPresente = false;
                ItemCarrello itemTrovato = null;
                
                for (ItemCarrello item : carrello.getProdotti()) {
                    if (item.getProdotto().getId() == idProdotto) {
                        giaPresente = true;
                        itemTrovato = item;
                        break;
                    }
                }
                
                boolean isDigitale = (prodottoTrovato.getCategoriaId() != 3); 
                boolean duplicateError = false;

                if ("rimuovi_carrello".equals(azione)) {
                    if (itemTrovato != null) {
                        carrello.getProdotti().remove(itemTrovato);
                    }
                } else {
                    if (giaPresente) {
                        if (isDigitale) {
                            duplicateError = true;
                        } else {
                            itemTrovato.setQuantita(itemTrovato.getQuantita() + quantitaDaAggiungere);
                        }
                    } else {
                        ItemCarrello nuovoItem = new ItemCarrello(prodottoTrovato, quantitaDaAggiungere);
                        carrello.getProdotti().add(nuovoItem);
                    }
                }
                
                session.setAttribute("carrello", carrello);
                
                if (utenteLoggato != null) {
                    carrelloDAO.salvaOAggiornaCarrello(utenteLoggato.getId(), carrello);
                }
                
                if ("true".equals(isAjax)) {
                    response.setContentType("text/plain");
                    
                    if (duplicateError) {
                        response.getWriter().write("gia_presente");
                    } else if (isDigitale) {
                        response.getWriter().write("aggiunto_digitale");
                    } else {
                        response.getWriter().write("aggiunto_fisico");
                    }
                    
                } else {
                    if ("rimuovi_carrello".equals(azione)) {
                        response.sendRedirect(request.getContextPath() + "/Carrello");
                        return; 
                    }
                    
                    if (duplicateError) {
                        session.setAttribute("errorMessage", "Questo elemento è già nel tuo carrello!");
                    } else {
                        session.setAttribute("successMessage", "Aggiunto al carrello con successo!");
                    }
                    
                    String referer = request.getHeader("referer");
                    if (referer != null) {
                        response.sendRedirect(referer);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/Carrello");
                    }
                }
                return;
            }
        }
        
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID Prodotto mancante");
    }
}