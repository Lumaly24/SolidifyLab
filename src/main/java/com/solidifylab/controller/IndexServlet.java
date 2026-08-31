package com.solidifylab.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.solidifylab.dao.ProdottoDAO;
import com.solidifylab.model.Prodotto;

// Questa annotazione è fondamentale: dice a Tomcat a quale URL risponde questa Servlet!
@WebServlet("/Home")
public class IndexServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Istanziamo il nostro DAO
        ProdottoDAO prodottoDAO = new ProdottoDAO();
        
        // 2. Estraiamo tutti i prodotti dal database MySQL!
        List<Prodotto> listaProdotti = prodottoDAO.doRetrieveAll();
        
        // 3. Mettiamo la lista in una "valigia" chiamata "prodottiInEvidenza"
        // Ti ricordi? È ESATTAMENTE il nome della variabile che abbiamo usato nel <c:forEach> della index.jsp!
        request.setAttribute("prodottiInEvidenza", listaProdotti);
        
        // 4. Trasferiamo il controllo e i dati alla pagina index.jsp
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}