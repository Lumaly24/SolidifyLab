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

@WebServlet("/UserDashboard")
public class UserDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User utente = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
        
        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        CommissioneDAO commissioneDAO = new CommissioneDAO();
        List<Commissione> mieCommissioni = commissioneDAO.getCommissioniByEmail(utente.getEmail());
        
        session.setAttribute("mieCommissioni", mieCommissioni);
        
        request.getRequestDispatcher("/WEB-INF/view/user-dashboard.jsp").forward(request, response);
    }
}