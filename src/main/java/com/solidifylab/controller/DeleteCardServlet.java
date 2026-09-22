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

@WebServlet("/DeleteCardServlet")
public class DeleteCardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User utente = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idCartaStr = request.getParameter("idCarta");
        
        if (idCartaStr != null && !idCartaStr.isEmpty()) {
            try {
                int idCarta = Integer.parseInt(idCartaStr);
                
                MetodoPagamentoDAO dao = new MetodoPagamentoDAO();
                dao.doDelete(idCarta, utente.getId());
                
                List<MetodoPagamento> listaCarte = dao.getMetodoByUtente(utente.getId());
                session.setAttribute("metodiPagamento", listaCarte);
                
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/UserDashboard#pagamenti");
    }
}