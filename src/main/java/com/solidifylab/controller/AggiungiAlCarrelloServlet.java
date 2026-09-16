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
import com.solidifylab.dao.ProdottoDAO;

@WebServlet("/AddtoCart")
public class AggiungiAlCarrelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String idProdottoStr = request.getParameter("id_prodotto");
        String azione = request.getParameter("azione"); 
        
        String isAjax = request.getParameter("isAjax"); 
        
        HttpSession session = request.getSession();
        Carrello carrello = (Carrello) session.getAttribute("carrello");
        
        if (carrello == null) {
            carrello = new Carrello();
            session.setAttribute("carrello", carrello);
        }

        if ("svuota_carrello".equals(azione)) {
            carrello.getProdotti().clear(); 
            session.setAttribute("carrello", carrello); 
            response.sendRedirect(request.getContextPath() + "/Carrello"); 
            return; 
        }
        
        if (idProdottoStr != null && !idProdottoStr.isEmpty()) {
            int idProdotto = Integer.parseInt(idProdottoStr);

            ProdottoDAO prodottoDAO = new ProdottoDAO();
            Prodotto prodottoTrovato = prodottoDAO.doRetrieveById(idProdotto);
            
            if (prodottoTrovato != null) {
                
                boolean giaPresente = false;
                boolean quantitaAumentata = false;
                ItemCarrello itemDaRimuovere = null;
                
                for (ItemCarrello item : carrello.getProdotti()) {
                    if (item.getProdotto().getId() == idProdotto) {
                        
                        giaPresente = true;
                        
                        if ("rimuovi_carrello".equals(azione)) {
                            itemDaRimuovere = item;
                        } 
                        else if (item.getProdotto().getCategoriaId() == 3) { 
                            item.setQuantita(item.getQuantita() + 1);
                            quantitaAumentata = true;
                        } 
                        else {
                            itemDaRimuovere = item;
                        }
                        
                        break;
                    }
                }
                
                if (itemDaRimuovere != null) {
                    carrello.getProdotti().remove(itemDaRimuovere);
                } else if (!giaPresente) {
                    ItemCarrello nuovoItem = new ItemCarrello(prodottoTrovato, 1);
                    carrello.getProdotti().add(nuovoItem);
                }
                
                session.setAttribute("carrello", carrello);
                
                if ("true".equals(isAjax)) {
                    response.setContentType("text/plain");
                    if (!giaPresente) {
                        if (prodottoTrovato.getCategoriaId() == 3) {
                            response.getWriter().write("aggiunto_fisico");
                        } else {
                            response.getWriter().write("aggiunto_digitale");
                        }
                    } else if (itemDaRimuovere != null) {
                        response.getWriter().write("rimosso_digitale");
                    } else if (quantitaAumentata) {
                        response.getWriter().write("aggiunto_fisico");
                    }
                } else {
                    if ("rimuovi_carrello".equals(azione)) {
                        response.sendRedirect(request.getContextPath() + "/Carrello");
                        return; 
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
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID Prodotto mancante");
        }
    }
}