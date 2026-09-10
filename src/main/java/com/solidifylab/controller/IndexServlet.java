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

@WebServlet("/Home")
public class IndexServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        ProdottoDAO prodottoDAO = new ProdottoDAO();
        
        List<Prodotto> listaProdotti = prodottoDAO.doRetrieveAll();
        
        request.setAttribute("prodottiInEvidenza", listaProdotti);
        
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}