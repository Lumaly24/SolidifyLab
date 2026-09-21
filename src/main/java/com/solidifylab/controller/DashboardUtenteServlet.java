package com.solidifylab.controller;

import java.io.IOException;

import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.dao.CommissioneDAO;
import com.solidifylab.dao.LibreriaDAO;
import com.solidifylab.dao.MetodoPagamentoDAO;
import com.solidifylab.dao.OrdineDAO;
import com.solidifylab.dao.SpedizioneDAO;
import com.solidifylab.dao.WishlistDAO;
import com.solidifylab.model.Asset;
import com.solidifylab.model.Commissione;
import com.solidifylab.model.MetodoPagamento;
import com.solidifylab.model.Ordine;
import com.solidifylab.model.Prodotto;
import com.solidifylab.model.Spedizione;
import com.solidifylab.model.User;

@WebServlet("/UserDashboard") 
public class DashboardUtenteServlet extends HttpServlet {
	
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	HttpSession session = request.getSession(false);
        User utente = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/Login?redirect=UserDashboard");
            return;
        }

        try {
        	
            WishlistDAO wishlistDAO = new WishlistDAO();
            
            List<Prodotto> wishlist = wishlistDAO.getWishlistByUtente(utente.getId());
            session.setAttribute("wishlist", wishlist);

            CommissioneDAO commissioneDAO = new CommissioneDAO();
            
            List<Commissione> commissioni = commissioneDAO.getCommissioniByEmail(utente.getEmail());
            session.setAttribute("mieCommissioni", commissioni);

            OrdineDAO ordineDAO = new OrdineDAO();
            
            List<Ordine> storicoOrdini = ordineDAO.doRetrieveByUtente(utente.getId());
            session.setAttribute("storicoOrdini", storicoOrdini);

            LibreriaDAO libreriaDAO = new LibreriaDAO();
            
            List<Asset> libreria = libreriaDAO.getLibreriaByUtente(utente.getId());
            session.setAttribute("libreriaDigitale", libreria);

            MetodoPagamentoDAO pagamentoDAO = new MetodoPagamentoDAO();
            
            List<MetodoPagamento> carte = pagamentoDAO.getMetodiByUtente(utente.getId());
            session.setAttribute("metodiPagamento", carte);

            SpedizioneDAO spedizioneDAO = new SpedizioneDAO();
            
            Spedizione indirizzo = spedizioneDAO.getIndirizzoPrincipale(utente.getId());
            session.setAttribute("indirizzoPrincipale", indirizzo);

            request.getRequestDispatcher("/WEB-INF/view/user-dashboard.jsp").forward(request, response);

        } catch (Exception e) {
        	
            System.err.println("Errore nel caricamento della UserDashboard:");
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nel caricamento della dashboard utente.");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}