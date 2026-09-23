package com.solidifylab.controller;

import java.io.IOException;
import java.util.Iterator;

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

@WebServlet("/Carrello") 
public class CarrelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Carrello carrello = (Carrello) session.getAttribute("carrello");
        User utenteLoggato = (User) session.getAttribute("utenteLoggato");

        if (carrello != null && !carrello.getProdotti().isEmpty()) {
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
                
                if (utenteLoggato != null) {
                    CarrelloDAO carrelloDAO = new CarrelloDAO();
                    carrelloDAO.salvaOAggiornaCarrello(utenteLoggato.getId(), carrello); 
                }
                
                request.setAttribute("errorMessage", "Attenzione: alcuni articoli non sono più disponibili e sono stati rimossi dal tuo carrello.");
            }
        }

        request.getRequestDispatcher("/WEB-INF/view/carrello.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}