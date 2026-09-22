package com.solidifylab.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.dao.CouponDAO;
import com.solidifylab.model.Carrello;
import com.solidifylab.model.Coupon;

@WebServlet("/ApplicaScontoServlet")
public class ApplicaScontoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Carrello carrello = (Carrello) session.getAttribute("carrello");
        String codiceInserito = request.getParameter("codice_sconto");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (carrello == null || carrello.getProdotti().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"Il carrello è vuoto.\"}");
            out.flush();
            return;
        }

        if (codiceInserito != null && !codiceInserito.trim().isEmpty()) {
            CouponDAO couponDAO = new CouponDAO();
            Coupon couponTrovato = couponDAO.getCouponByCodice(codiceInserito);

            if (couponTrovato != null) {
                LocalDate dataScadenza = couponTrovato.getDataScadenza().toLocalDate();
                LocalDate dataOdierna = LocalDate.now();

                if (!dataOdierna.isAfter(dataScadenza)) {

                    double percentualeDecimale = couponTrovato.getScontoPercentuale() / 100.0;
                    double importoSconto = carrello.getSubtotale() * percentualeDecimale;
                    
                    carrello.setSconto(importoSconto);
                    
                    out.print("{\"success\": true, \"message\": \"Codice applicato con successo\"}");
                } else {
                    carrello.setSconto(0.0);
                    
                    out.print("{\"success\": false, \"message\": \"Codice non valido\"}");
                }
            } else {
                carrello.setSconto(0.0);
                
                out.print("{\"success\": false, \"message\": \"Codice non valido\"}");
            }
        } else {
            carrello.setSconto(0.0);
            out.print("{\"success\": false, \"message\": \"Inserisci un codice.\"}");
        }
        
        out.flush();
    }
}