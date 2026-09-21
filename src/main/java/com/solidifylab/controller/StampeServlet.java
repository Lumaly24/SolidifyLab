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
        
        ProdottoDAO prodottoDAO = new ProdottoDAO();
        int idCategoriaStampe = 3; 
        
        String maxPriceParam = request.getParameter("max_price");
        
        String[] tagsArray = request.getParameterValues("tag");
        
        double maxPrice = 300.0;
        if (maxPriceParam != null && !maxPriceParam.isEmpty()) {
            try {
                maxPrice = Double.parseDouble(maxPriceParam);
            } catch (NumberFormatException e) {
            }
        }
        
        List<Prodotto> stampe;
        
        if ((maxPriceParam != null && !maxPriceParam.isEmpty()) || (tagsArray != null && tagsArray.length > 0)) {
            stampe = prodottoDAO.doRetrieveByFilters(idCategoriaStampe, maxPrice, tagsArray);
        } else {
            stampe = prodottoDAO.doRetrieveByCategoria(idCategoriaStampe);
        }
        
        request.setAttribute("listaStampe", stampe);
        
        request.getRequestDispatcher("/WEB-INF/view/stampe.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}