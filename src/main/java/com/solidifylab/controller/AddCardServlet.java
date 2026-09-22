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
import com.solidifylab.dao.MetodoPagamentoDAO;
import com.solidifylab.model.MetodoPagamento;

@WebServlet("/AddCardServlet")
public class AddCardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User utente = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String intestatario = request.getParameter("titolareCarta");
        String numeroCartaRaw = request.getParameter("numeroCarta");
        String scadenza = request.getParameter("scadenzaCarta");

        if (numeroCartaRaw == null || numeroCartaRaw.isBlank() || scadenza == null || intestatario == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String numeroPuro = numeroCartaRaw.replaceAll("\\s+", ""); 
        String ultimi4 = numeroPuro.length() >= 4 ? numeroPuro.substring(numeroPuro.length() - 4) : "0000";
        String cartaMascherata = "**** **** **** " + ultimi4;
        
        

        MetodoPagamento carta = new MetodoPagamento();
        carta.setUtenteId(utente.getId());
        carta.setIntestatario(intestatario);
        carta.setCartaMascherata(cartaMascherata);
        carta.setScadenza(scadenza);
        

        MetodoPagamentoDAO dao = new MetodoPagamentoDAO();
        
        dao.eliminaCarteByUtente(utente.getId());
        
        dao.doSave(carta);
        
        List<MetodoPagamento> listaCarte = dao.getMetodoByUtente(utente.getId());
        session.setAttribute("metodiPagamento", listaCarte);

        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("successo");
    }
}