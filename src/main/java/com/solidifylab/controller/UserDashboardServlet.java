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
import com.solidifylab.model.Commissione;
import com.solidifylab.dao.CommissioneDAO;

@WebServlet("/UserDashboard") // O il mapping che usi tu
public class UserDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User utente = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
        
        // Controllo di sicurezza: se non è loggato, via al login
        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        // 1. Recuperiamo le commissioni fatte da QUESTO utente specifico tramite la sua email o il suo ID
        CommissioneDAO commissioneDAO = new CommissioneDAO();
        List<Commissione> mieCommissioni = commissioneDAO.getCommissioniByEmail(utente.getEmail());
        
        // 2. Le passiamo alla sessione (o request) per leggerle nella JSP
        session.setAttribute("mieCommissioni", mieCommissioni);
        
        // (Qui sotto puoi lasciare il recupero degli ordini, wishlist, ecc. che già avevi)

        // Reindirizza alla pagina della dashboard
        request.getRequestDispatcher("/WEB-INF/view/user-dashboard.jsp").forward(request, response);
    }
}