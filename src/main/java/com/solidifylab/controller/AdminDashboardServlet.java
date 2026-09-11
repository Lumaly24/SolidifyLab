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
import com.solidifylab.model.Prodotto;
import com.solidifylab.model.Commissione;
import com.solidifylab.dao.ProdottoDAO;
import com.solidifylab.dao.CommissioneDAO;
import com.solidifylab.model.Ordine;
import com.solidifylab.dao.OrdineDAO;

@WebServlet("/AdminDashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User utente = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
        
        // 1. Controllo di sicurezza: l'utente deve essere loggato ed essere ADMIN
        if (utente != null && "ADMIN".equalsIgnoreCase(utente.getRuolo())) {
            
            // 2. Recupero dei Prodotti per la tabella "Prodotti in Catalogo"
            ProdottoDAO prodottoDAO = new ProdottoDAO();
            List<Prodotto> listaProdotti = prodottoDAO.doRetrieveAll();
            request.setAttribute("listaProdotti", listaProdotti);
            
            // 3. Recupero delle Commissioni per la tabella "Richieste di Commissione"
            CommissioneDAO commissioneDAO = new CommissioneDAO();
            List<Commissione> listaCommissioni = commissioneDAO.getAllCommissioni();
            request.setAttribute("listaCommissioni", listaCommissioni);
            
         // 4. Recupero degli Ordini
            OrdineDAO ordineDAO = new OrdineDAO();
            List<Ordine> listaOrdiniCompleta = ordineDAO.doRetrieveAll();
            request.setAttribute("listaOrdiniCompleta", listaOrdiniCompleta);

            // 5. Inoltro finale alla JSP protetta dentro WEB-INF
            request.getRequestDispatcher("/WEB-INF/view/admin-dashboard.jsp").forward(request, response);
            
        } else {
            // Se non è autorizzato, rimbalzo immediato alla Home
            response.sendRedirect(request.getContextPath() + "/Home");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}