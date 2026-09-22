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
import com.solidifylab.dao.OrdineDAO;
import com.solidifylab.model.Ordine;

@WebServlet("/FiltraOrdiniUtenteServlet")
public class FiltraOrdiniUtenteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User utente = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String dataInizio = request.getParameter("data_inizio");
        String dataFine = request.getParameter("data_fine");
        String stato = request.getParameter("stato");

        OrdineDAO dao = new OrdineDAO();
        List<Ordine> ordiniFiltrati;

        if ((dataInizio == null || dataInizio.isEmpty()) && 
            (dataFine == null || dataFine.isEmpty()) && 
            (stato == null || stato.isEmpty())) {
            
            ordiniFiltrati = dao.doRetrieveByUtente(utente.getId()); 
            
        } else {
            ordiniFiltrati = dao.doRetrieveFiltrati(utente.getId(), dataInizio, dataFine, stato);
        }

        session.setAttribute("storicoOrdini", ordiniFiltrati);

        response.sendRedirect(request.getContextPath() + "/area-utente.jsp#ordini");
    }
}