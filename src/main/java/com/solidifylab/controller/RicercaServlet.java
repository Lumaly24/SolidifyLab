package com.solidifylab.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Search") // L'action del tuo form punta qui
public class RicercaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recuperiamo il testo scritto dall'utente nella barra
        String query = request.getParameter("q");
        
        // Per ora stampiamo in console cosa ha cercato, in futuro interrogheremo il DB!
        if (query != null && !query.trim().isEmpty()) {
            System.out.println("L'utente ha cercato: " + query);
        }
        
        // Rimandiamo ai risultati (per ora possiamo reindirizzare al catalogo o creare una pagina risultati)
        // Se non hai una pagina dedicata, per ora possiamo rimandare al catalogo
        request.getRequestDispatcher("/WEB-INF/view/catalogo.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}