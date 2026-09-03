package com.solidifylab.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.model.User;

@WebServlet("/UpdatePfpServlet")
public class UpdatePfpServlet extends HttpServlet {
    
	private static final long serialVersionUID = -7204062841287176728L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String nuovaPfp = request.getParameter("Pfp_selezionata");
        
        HttpSession session = request.getSession();
        User utente = (User) session.getAttribute("utenteLoggato");
        
        if (utente != null && nuovaPfp != null && !nuovaPfp.isEmpty()) {

                utente.setPfp(nuovaPfp);
                session.setAttribute("utenteLoggato", utente);
        }
        
        response.sendRedirect(request.getContextPath() + "/UserDashboard");
    }
}