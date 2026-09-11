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

@WebServlet("/Stampe") 
public class StampeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Chiamiamo il DAO per interrogare il database
        ProdottoDAO prodottoDAO = new ProdottoDAO();
        
        // 2. Recuperiamo i prodotti della categoria Stampe 3D. 
        // Assicurati che '3' sia l'ID corretto della categoria Stampe nel tuo Database!
        int idCategoriaStampe = 3; 
        List<Prodotto> stampe = prodottoDAO.doRetrieveByCategoria(idCategoriaStampe);
        
        // 3. Passiamo la lista alla JSP usando l'esatto nome che si aspetta: "listaStampe"
        request.setAttribute("listaStampe", stampe);
        
        // 4. Facciamo il forward al nome corretto della pagina JSP
        request.getRequestDispatcher("/WEB-INF/view/stampe.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}