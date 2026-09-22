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
import com.solidifylab.model.SecurityUtils;

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
        HttpSession session = request.getSession(false);
        User utente = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String azione = request.getParameter("azione");

        if ("password".equals(azione)) {
            gestisciUpdatePassword(request, response, utente);
        } else {
            gestisciUpdateProfilo(request, response, utente, session);
        }
    }

    private void gestisciUpdateProfilo(HttpServletRequest request, HttpServletResponse response, User utente, HttpSession session) throws IOException {
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
        
        if (nome == null || nome.isBlank() || cognome == null || cognome.isBlank()) {
            datiValidi = false;
        }
        if (civico != null && !civico.isBlank() && !civico.matches("^[0-9a-zA-Z/]+$")) { 
            datiValidi = false;
        }
        if (citta != null && !citta.isBlank() && !citta.matches("^[a-zA-Za-zA-ZàèéìòùÀÈÉÌÒÙ\\s']+$")) {
            datiValidi = false; 
        }
        if (cap != null && !cap.isBlank() && !cap.matches("^\\d{5}$")) {
            datiValidi = false; 
        }
        if (provincia != null && !provincia.isBlank() && !PROVINCE_VALIDE.contains(provincia)) {
            datiValidi = false; 
        }

        if (!datiValidi) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("errore_validazione");
            return;
        }

        utente.setNome(nome);
        utente.setCognome(cognome);
        
        UserDAO userDAO = new UserDAO();
        userDAO.updateProfilo(utente); 

        SpedizioneDAO spedizioneDAO = new SpedizioneDAO();
        spedizioneDAO.salvaIndirizzoPrincipale(utente.getId(), via, civico, citta, cap, provincia);
        
        Object indirizzoAggiornato = spedizioneDAO.getIndirizzoPrincipale(utente.getId());
        session.setAttribute("indirizzoPrincipale", indirizzoAggiornato);
        session.setAttribute("utenteLoggato", utente);
        
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("successo");
    }

    private void gestisciUpdatePassword(HttpServletRequest request, HttpServletResponse response, User utente) throws IOException {
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");

        if (oldPassword == null || newPassword == null || newPassword.isBlank()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&.])[A-Za-z\\d@$!%*?&.]{8,}$";
        
        if (!newPassword.matches(passwordRegex)) {
        	
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            
            response.getWriter().write("errore_formato_password"); 
            return;
        }
        
        String hashedOldPassword = SecurityUtils.hashPassword(oldPassword);

        if (!hashedOldPassword.equals(utente.getPasswordHash())) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("errore_vecchia_password");
            return;
        }

        String hashedNewPassword = SecurityUtils.hashPassword(newPassword);

        UserDAO userDAO = new UserDAO();
        boolean aggiornata = userDAO.updatePassword(utente.getEmail(), hashedNewPassword);

        if (aggiornata) {
            utente.setPasswordHash(hashedNewPassword); 
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("successo");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("errore_server");
        }
    }
}