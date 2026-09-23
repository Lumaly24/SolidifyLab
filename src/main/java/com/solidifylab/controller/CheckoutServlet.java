package com.solidifylab.controller;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.dao.MetodoPagamentoDAO;
import com.solidifylab.dao.ProdottoDAO;
import com.solidifylab.dao.CarrelloDAO;
import com.solidifylab.model.Carrello;
import com.solidifylab.model.ItemCarrello;
import com.solidifylab.model.MetodoPagamento;
import com.solidifylab.model.Prodotto;
import com.solidifylab.model.User;

@WebServlet("/Checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        Carrello carrello = (Carrello) session.getAttribute("carrello");
        User utente = (User) session.getAttribute("utenteLoggato");

        if (carrello == null || carrello.getProdotti().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Carrello");
            return;
        }

        ProdottoDAO prodottoDAO = new ProdottoDAO();
        boolean carrelloModificato = false;
        Iterator<ItemCarrello> iterator = carrello.getProdotti().iterator();
        
        while (iterator.hasNext()) {
            ItemCarrello item = iterator.next();
            Prodotto prodottoInDB = prodottoDAO.doRetrieveById(item.getProdotto().getId());
            
            if (prodottoInDB == null || prodottoInDB.isCancellato()) {
                iterator.remove();
                carrelloModificato = true;
            }
        }

        if (carrelloModificato) {
            session.setAttribute("carrello", carrello);
            if (utente != null) {
                CarrelloDAO carrelloDAO = new CarrelloDAO();
                carrelloDAO.salvaOAggiornaCarrello(utente.getId(), carrello);
            }
            
            session.setAttribute("errorMessage", "Il tuo carrello è stato aggiornato perché alcuni prodotti non sono più disponibili.");
            response.sendRedirect(request.getContextPath() + "/Carrello");
            return;
        }

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/Login?redirect=Checkout"); 
            return;
        }
        
        MetodoPagamentoDAO metodoDAO = new MetodoPagamentoDAO();
        List<MetodoPagamento> carteUtente = metodoDAO.getMetodoByUtente(utente.getId());
        
        if (carteUtente != null && !carteUtente.isEmpty()) {
            MetodoPagamento cartaSalvata = carteUtente.get(0);
            request.setAttribute("cartaSalvata", cartaSalvata);
        }
        
        request.getRequestDispatcher("/WEB-INF/view/checkout.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}