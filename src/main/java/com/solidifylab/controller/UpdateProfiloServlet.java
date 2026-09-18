package com.solidifylab.controller;

import java.io.IOException;
import java.util.Set;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.dao.UserDAO;
import com.solidifylab.dao.SpedizioneDAO;
import com.solidifylab.model.User;

@WebServlet("/UpdateProfiloServlet")

public class UpdateProfiloServlet extends HttpServlet {
	
    private static final long serialVersionUID = 1L;

    private static final Set<String> PROVINCE_VALIDE = Set.of(
        "AG","AL","AN","AO","AR","AP","AT","AV","BA","BT","BL","BN","BG","BI","BO","BZ","BS","BR","CA","CL",
        "CB","CE","CT","CZ","CH","CO","CS","CR","KR","CN","EN","FM","FE","FI","FG","FC","FR","GE","GO","GR",
        "IM","IS","SP","LT","LE","LC","LO","LU","MC","MN","MS","MT","ME","MI","MO","MB","NA","NO","NU","OR",
        "PD","PA","PR","PV","PG","PU","PE","PC","PI","PT","PN","PZ","PO","RG","RA","RC","RE","RI","RN","RM",
        "RO","SA","SS","SV","SI","SR","SO","SU","TA","TE","TR","TO","TP","TN","TV","TS","UD","VA","VE","VB",
        "VC","VR","VV","VI","VT"
    );

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User utente = (User) session.getAttribute("utenteLoggato");

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String via = request.getParameter("via");
        String civico = request.getParameter("civico");
        String citta = request.getParameter("citta");
        String cap = request.getParameter("cap");
        String provincia = request.getParameter("provincia");

        if (provincia != null) {
        	
            provincia = provincia.trim().toUpperCase();
        }

        boolean datiValidi = true;

        if (civico != null && !civico.isBlank() && !civico.matches("\\d+")) {
        	
            datiValidi = false;
        }

        if (citta != null && !citta.isBlank() && !citta.matches("[a-zA-Za-zA-ZàèéìòùÀÈÉÌÒÙ\\s']+")) {
        	
            datiValidi = false; 
        }

        if (cap != null && !cap.isBlank() && !cap.matches("\\d{5}")) {
        	
            datiValidi = false; 
        }

        if (provincia != null && !provincia.isBlank() && !PROVINCE_VALIDE.contains(provincia)) {
        	
            datiValidi = false; 
        }

        if (!datiValidi) {
        	
            session.setAttribute("erroreProfilo", "Formato dei dati non valido. Controlla i campi inseriti.");
            response.sendRedirect(request.getContextPath() + "/UserDashboard#anagrafica");
            return;
        }

        utente.setNome(nome);
        utente.setCognome(cognome);
        
        UserDAO userDAO = new UserDAO();
        userDAO.updateProfilo(utente); 

        SpedizioneDAO spedizioneDAO = new SpedizioneDAO();
        spedizioneDAO.salvaIndirizzoPrincipale(utente.getId(), via, civico, citta, cap, provincia);

        session.setAttribute("utenteLoggato", utente);
        session.removeAttribute("erroreProfilo");
        
        response.sendRedirect(request.getContextPath() + "/UserDashboard#anagrafica");
    }
}