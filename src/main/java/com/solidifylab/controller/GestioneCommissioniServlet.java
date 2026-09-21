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
import com.solidifylab.model.Commissione;
import com.solidifylab.model.User;

@WebServlet("/GestioneCommissioni")
public class GestioneCommissioniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User utente = null;
        
        if (session != null) {
            utente = (User) session.getAttribute("utenteLoggato");
        }

        if (utente == null || !"ADMIN".equals(utente.getRuolo())) {
            response.sendRedirect(request.getContextPath() + "/Home"); 
            return;
        }

        CommissioneDAO commissioneDAO = new CommissioneDAO();
        List<Commissione> listaCommissioni = commissioneDAO.getAllCommissioni();
        
        String openIdParam = request.getParameter("id");
        String openParam = request.getParameter("open");
        
        if (openIdParam != null && "true".equals(openParam)) {
            try {
                int targetId = Integer.parseInt(openIdParam);
                for (Commissione c : listaCommissioni) {
                    if (c.getId() == targetId) {
                        request.setAttribute("openCommissione", c);
                        break;
                    }
                }
            } catch (NumberFormatException e) {
            }
        }

        List<Commissione> inAttesa = new ArrayList<>();
        List<Commissione> accettate = new ArrayList<>();
        List<Commissione> inLavorazione = new ArrayList<>();
        List<Commissione> completate = new ArrayList<>();
        List<Commissione> rifiutate = new ArrayList<>();

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

        request.setAttribute("listaInAttesa", inAttesa);
        request.setAttribute("listaAccettate", accettate);
        request.setAttribute("listaInLavorazione", inLavorazione);
        request.setAttribute("listaCompletate", completate);
        request.setAttribute("listaRifiutate", rifiutate);
        
        request.getRequestDispatcher("/WEB-INF/view/admin_commissioni.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User utente = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
        
        if (utente == null || !"ADMIN".equals(utente.getRuolo())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accesso negato");
            return;
        }

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        if (action != null && idParam != null) {
            try {
                int commissioneId = Integer.parseInt(idParam);
                CommissioneDAO commissioneDAO = new CommissioneDAO();
                
                switch (action) {
                    case "accetta":
                        commissioneDAO.updateStato(commissioneId, "ACCETTATA");
                        break;
                    case "lavorazione":
                        commissioneDAO.updateStato(commissioneId, "IN_LAVORAZIONE");
                        break;
                    case "completa":
                        commissioneDAO.updateStato(commissioneId, "COMPLETATA");
                        break;
                    case "rifiuta":
                        commissioneDAO.updateStato(commissioneId, "RIFIUTATA");
                        break;
                    case "visiona":
                        commissioneDAO.segnaComeVisionata(commissioneId);
                        break;
                    default:
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Azione non valida");
                        return;
                }
                
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Operazione completata con successo");
                
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID non valido");
            } catch (Exception e) {
                e.printStackTrace(); 
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore del database");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametri mancanti");
        }
    }
}