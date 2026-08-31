package com.solidifylab.controller;

import java.io.IOException;
import java.util.Arrays;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/RichiestaCommissioneServlet")
// QUESTA È FONDAMENTALE PER LEGGERE I FORM CON UPLOAD DI FILE
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB (dimensione oltre la quale il file viene scritto su disco fisso temporaneo)
    maxFileSize = 1024 * 1024 * 20,       // 20MB (dimensione massima del singolo file)
    maxRequestSize = 1024 * 1024 * 25     // 25MB (dimensione massima totale della request)
)
public class RichiestaCommissioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // --- 1. LETTURA DEI PARAMETRI TESTUALI ---
        
        // I checkbox con lo stesso nome restituiscono un array di String
        String[] tipiCommissione = request.getParameterValues("tipo_commissione");
        String tipiSelezionati = (tipiCommissione != null) ? Arrays.toString(tipiCommissione) : "Nessuno";
        
        String email = request.getParameter("email");
        String descrizionePrincipale = request.getParameter("descrizione_principale");
        
        // Parametri per l'indirizzo (arrivano solo se l'utente compila i campi della stampa 3D)
        String via = request.getParameter("indirizzo_via");
        String citta = request.getParameter("indirizzo_citta");
        String cap = request.getParameter("indirizzo_cap");

        // ... qui in futuro leggerai anche i materiali, le note, le opzioni di rigging, ecc.
        
        
        // --- 2. LETTURA DEI FILE CARICATI ---
        // Visto che l'input ha l'attributo 'multiple', iteriamo su tutte le parti della request
        for (Part part : request.getParts()) {
            String fileName = part.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                // Per ora stampiamo il nome, poi implementerai il salvataggio nella cartella del server!
                System.out.println("File ricevuto: " + fileName);
            }
        }
        
        
        // --- 3. CREAZIONE DEL BEAN E SALVATAGGIO (Da scommentare quando avrai il DAO) ---
        /* 
        Commissione commissione = new Commissione();
        commissione.setEmail(email);
        commissione.setTipi(tipiSelezionati);
        commissione.setDescrizione(descrizionePrincipale);
        commissione.setVia(via);
        // ... set degli altri campi
        
        CommissioneDAO commissioneDAO = new CommissioneDAO();
        commissioneDAO.doSave(commissione);
        */
        
        
        // LOG DI CONTROLLO: Stampiamo in console (su Eclipse) per assicurarci che i dati arrivino sani e salvi!
        System.out.println("--- NUOVA RICHIESTA RICEVUTA ---");
        System.out.println("Email: " + email);
        System.out.println("Tipi selezionati: " + tipiSelezionati);
        System.out.println("Descrizione: " + descrizionePrincipale);
        if (via != null && !via.trim().isEmpty()) {
            System.out.println("Indirizzo di spedizione: " + via + ", " + citta + " - " + cap);
        }
        System.out.println("--------------------------------");
        
        
        // --- 4. RITORNO ALLA PAGINA CON IL POPUP ---
        request.setAttribute("successMessage", "La tua richiesta è stata inviata con successo. Analizzeremo il progetto e ti risponderemo in 24/48h!");
        request.getRequestDispatcher("/WEB-INF/view/commissioni.jsp").forward(request, response);
    }
}