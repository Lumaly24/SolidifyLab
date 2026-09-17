package com.solidifylab.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.solidifylab.dao.CommissioneDAO;
import com.solidifylab.model.Commissione;
import com.solidifylab.model.User;

@WebServlet("/Request")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 20,       // 20MB
    maxRequestSize = 1024 * 1024 * 25     // 25MB
)
public class RichiestaCommissioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        User utente = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
        
        String email = request.getParameter("email");
        if ((email == null || email.trim().isEmpty()) && utente != null) {
            email = utente.getEmail();
        }
        
        String descrizionePrincipale = request.getParameter("descrizione_principale");
        String[] tipiCommissione = request.getParameterValues("tipo_commissione");
        
        String tipiSelezionati = "";
        if (tipiCommissione != null) {
            List<String> tipiList = new ArrayList<>();
            for (String t : tipiCommissione) {
                if ("stampa_3d".equals(t)) tipiList.add("Stampa 3D");
                if ("modello_3d".equals(t)) tipiList.add("Modello 3D");
                if ("texture".equals(t)) tipiList.add("Texture");
            }
            tipiSelezionati = String.join(", ", tipiList); 
        }
        
        String via = request.getParameter("indirizzo_via");
        String citta = request.getParameter("indirizzo_citta");
        String cap = request.getParameter("indirizzo_cap");
        
        StringBuilder fileNamesBuilder = new StringBuilder();
        for (Part part : request.getParts()) {
            String fileName = part.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                if (fileNamesBuilder.length() > 0) fileNamesBuilder.append(", ");
                fileNamesBuilder.append(fileName);
            }
        }
        
        try {
            Commissione commissione = new Commissione();
            commissione.setEmail(email);
            commissione.setTipi(tipiSelezionati);
            commissione.setDescrizione(descrizionePrincipale);
            commissione.setVia(via);
            commissione.setCitta(citta);
            commissione.setCap(cap);
            
            CommissioneDAO commissioneDAO = new CommissioneDAO();
            commissioneDAO.doSave(commissione); 
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore durante il salvataggio della commissione.");
            return;
        }
        
        request.setAttribute("successMessage", "La tua richiesta è stata inviata con successo. Analizzeremo il progetto e ti risponderemo in 24/48h!");
        request.getRequestDispatcher("/WEB-INF/view/commissioni.jsp").forward(request, response);
    }
}