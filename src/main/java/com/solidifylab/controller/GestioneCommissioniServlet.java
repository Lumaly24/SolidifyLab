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
        
        request.setAttribute("commissioniList", listaCommissioni);
        
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
                    case "rifiuta":
                        commissioneDAO.updateStato(commissioneId, "RIFIUTATA");
                        break;
                    case "visiona":
                        commissioneDAO.segnaComeVisionata(commissioneId);
                        break;
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