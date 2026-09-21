package com.solidifylab.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.dao.OrdineDAO;
import com.solidifylab.model.Ordine;
import com.solidifylab.model.User;

@WebServlet("/FatturaServlet")
public class FatturaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        User utenteLoggato = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
        if (utenteLoggato == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String ordineIdParam = request.getParameter("id");
        Ordine ordineDaMostrare = null;

        if (ordineIdParam != null && !ordineIdParam.trim().isEmpty()) {
            try {
                int idOrdine = Integer.parseInt(ordineIdParam);
                OrdineDAO ordineDAO = new OrdineDAO();
                
                ordineDaMostrare = ordineDAO.doRetrieveById(idOrdine); 
                
                if (ordineDaMostrare != null) {
                	
                    boolean isAdmin = "ADMIN".equalsIgnoreCase(utenteLoggato.getRuolo());
                    boolean isOwner = ordineDaMostrare.getUtente().getId() == utenteLoggato.getId();
                    
                    if (!isAdmin && !isOwner) {
                        response.sendRedirect(request.getContextPath() + "/Home");
                        return;
                    }
                }
                
            } catch (NumberFormatException e) {
            	
                System.out.println("Formato ID Ordine non valido.");
            }
            
        } else {
        	
            ordineDaMostrare = (Ordine) session.getAttribute("ultimoOrdine");
        }

        if (ordineDaMostrare == null) {
            response.sendRedirect(request.getContextPath() + "/Home");
            return;
        }

        request.setAttribute("ultimoOrdine", ordineDaMostrare);
        
        request.getRequestDispatcher("/WEB-INF/view/fattura.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}