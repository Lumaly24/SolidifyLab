package com.solidifylab.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.solidifylab.dao.ProdottoDAO;
import com.solidifylab.model.Prodotto;

@WebServlet("/Home")
public class IndexServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        try {
            ProdottoDAO prodottoDAO = new ProdottoDAO();
            List<Prodotto> listaProdotti = prodottoDAO.doRetrieveInEvidenza(7);
            
            if (listaProdotti == null) {
                listaProdotti = new ArrayList<>();
            }
            
            request.setAttribute("prodottiInEvidenza", listaProdotti);
            
        } catch (Exception e) {
            System.err.println("Errore nel caricamento dei prodotti in evidenza per la Home:");
            e.printStackTrace();
            request.setAttribute("prodottiInEvidenza", new ArrayList<>());
        }
        
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}