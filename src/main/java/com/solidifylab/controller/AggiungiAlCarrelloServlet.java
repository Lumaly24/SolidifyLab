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
        
        if (idProdottoStr != null && !idProdottoStr.isEmpty()) {
            int idProdotto = Integer.parseInt(idProdottoStr);

            ProdottoDAO prodottoDAO = new ProdottoDAO();
            Prodotto prodottoTrovato = prodottoDAO.doRetrieveById(idProdotto);
            
            if (prodottoTrovato != null) {
            	
            	HttpSession session = request.getSession();
            	
            	Carrello carrello = (Carrello) session.getAttribute("carrello");
            	
            	if (carrello == null) {
            		carrello = new Carrello();
            		session.setAttribute("carrello", carrello);
            	}
            	
            	boolean giaPresente = false;
            	boolean quantitaAumentata = false;
            	
            	for (ItemCarrello item : carrello.getProdotti()) {
            		if (item.getProdotto().getId() == idProdotto) {
            			
            			if (item.getProdotto().getCategoriaId() == 3) { //controllo se è una stampa 3d allora puoi aumentare la quantità
            				item.setQuantita(item.getQuantita() + 1);
            				quantitaAumentata = true;
            			}
            			
            			giaPresente = true;
            			break;
            		}
            	}
            	
            	if (!giaPresente) {
                    ItemCarrello nuovoItem = new ItemCarrello(prodottoTrovato, 1);
                    carrello.getProdotti().add(nuovoItem);
                    
                    response.setContentType("text/plain");
                    response.getWriter().write("aggiunto");
                    
            	} else if (quantitaAumentata) {
            		
                    response.setContentType("text/plain");
                    response.getWriter().write("aggiunto");
                    
                } else {
                	
                    response.setContentType("text/plain");
                    response.getWriter().write("gia_presente");
                }
            }
            
        } else {
        	
            response.setContentType("text/plain");
            response.getWriter().write("errore");
        }
    }
}