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

@WebServlet("/Catalogo") 
public class CatalogoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Inizializza il DAO
        ProdottoDAO prodottoDAO = new ProdottoDAO();
        
        // 2. Estrai tutti i prodotti dal database TiDB
        List<Prodotto> prodotti = prodottoDAO.doRetrieveAll();
        
        // 3. Inserisci la lista nella request affinché la JSP possa leggerla
        request.setAttribute("listaProdotti", prodotti);
        
        // 4. Passa il controllo alla pagina catalogo.jsp
        request.getRequestDispatcher("/WEB-INF/view/catalogo.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}