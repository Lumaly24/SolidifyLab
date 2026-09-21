package com.solidifylab.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.dao.CommissioneDAO;
import com.solidifylab.dao.OrdineDAO;
import com.solidifylab.dao.ProdottoDAO;
import com.solidifylab.model.Commissione;
import com.solidifylab.model.Ordine;
import com.solidifylab.model.Prodotto;
import com.solidifylab.model.User;

@WebServlet("/AdminDashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User utente = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
        
        if (utente != null && "ADMIN".equalsIgnoreCase(utente.getRuolo())) {
            
            try {
                ProdottoDAO prodottoDAO = new ProdottoDAO();
                List<Prodotto> listaProdotti = prodottoDAO.doRetrieveAll();
                request.setAttribute("listaProdotti", listaProdotti != null ? listaProdotti : new ArrayList<>());
                
                CommissioneDAO commissioneDAO = new CommissioneDAO();
                List<Commissione> listaCommissioni = commissioneDAO.getAllCommissioni();
                request.setAttribute("listaCommissioni", listaCommissioni != null ? listaCommissioni : new ArrayList<>());
                
                List<Commissione> inAttesa = new ArrayList<>();
                List<Commissione> accettate = new ArrayList<>();
                List<Commissione> inLavorazione = new ArrayList<>();
                List<Commissione> completate = new ArrayList<>();
                List<Commissione> rifiutate = new ArrayList<>();

                if (listaCommissioni != null) {
                    for (Commissione c : listaCommissioni) {
                        String stato = c.getStato() != null ? c.getStato().toUpperCase().trim() : "IN_ATTESA";
                        switch (stato) {
                            case "IN_ATTESA": inAttesa.add(c); break;
                            case "ACCETTATA": accettate.add(c); break;
                            case "IN_LAVORAZIONE": inLavorazione.add(c); break;
                            case "COMPLETATA": completate.add(c); break;
                            case "RIFIUTATA": rifiutate.add(c); break;
                            default: inAttesa.add(c); break;
                        }
                    }
                }

                request.setAttribute("listaInAttesa", inAttesa);
                request.setAttribute("listaAccettate", accettate);
                request.setAttribute("listaInLavorazione", inLavorazione);
                request.setAttribute("listaCompletate", completate);
                request.setAttribute("listaRifiutate", rifiutate);
                
                OrdineDAO ordineDAO = new OrdineDAO();
                List<Ordine> listaOrdiniCompleta = ordineDAO.doRetrieveAll();
                request.setAttribute("listaOrdiniCompleta", listaOrdiniCompleta != null ? listaOrdiniCompleta : new ArrayList<>());

                request.getRequestDispatcher("/WEB-INF/view/admin-dashboard.jsp").forward(request, response);
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore durante il caricamento della dashboard amministrativa.");
            }
            
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accesso non autorizzato.");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}