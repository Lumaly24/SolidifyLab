package com.solidifylab.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
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
        
        String[] categorie = request.getParameterValues("categoria");
        String[] materiali = request.getParameterValues("materiale");
        String[] finiture = request.getParameterValues("finitura");
        
        List<String> tuttiITags = new ArrayList<>();
        if (categorie != null) tuttiITags.addAll(Arrays.asList(categorie));
        if (materiali != null) tuttiITags.addAll(Arrays.asList(materiali));
        if (finiture != null) tuttiITags.addAll(Arrays.asList(finiture));
        
        String[] tagsArray = tuttiITags.isEmpty() ? null : tuttiITags.toArray(new String[0]);
        
        double maxPrice = 300.0;
        if (maxPriceParam != null && !maxPriceParam.isEmpty()) {
            try {
                maxPrice = Double.parseDouble(maxPriceParam);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        List<Prodotto> stampe;
        
        if ((maxPriceParam != null) || (tagsArray != null)) {
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