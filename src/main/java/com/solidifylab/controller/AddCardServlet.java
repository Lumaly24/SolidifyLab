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
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String intestatario = request.getParameter("titolareCarta");
        String numeroPuro = request.getParameter("numeroCarta").replaceAll("\\s+", ""); 
        String scadenza = request.getParameter("scadenzaCarta");

        String ultimi4 = numeroPuro.length() >= 4 ? numeroPuro.substring(numeroPuro.length() - 4) : "0000";
        String cartaMascherata = "**** **** **** " + ultimi4;
        
        String brand = "Visa";
        if (numeroPuro.startsWith("5")) {
            brand = "Mastercard";
        } else if (numeroPuro.startsWith("3")) {
            brand = "Amex";
        }

        MetodoPagamento carta = new MetodoPagamento();
        carta.setUtenteId(utente.getId());
        carta.setIntestatario(intestatario);
        carta.setCartaMascherata(cartaMascherata);
        carta.setScadenza(scadenza);
        carta.setBrand(brand);

        MetodoPagamentoDAO dao = new MetodoPagamentoDAO();
        dao.doSave(carta);
        
        List<MetodoPagamento> listaCarte = dao.getMetodiByUtente(utente.getId());
        session.setAttribute("metodiPagamento", listaCarte);

        response.sendRedirect(request.getContextPath() + "/UserDashboard#pagamenti");
    }
}