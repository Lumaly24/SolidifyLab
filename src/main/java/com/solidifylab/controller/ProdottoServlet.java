package com.solidifylab.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.solidifylab.dao.ProdottoDAO;
import com.solidifylab.model.Prodotto;

@WebServlet("/Prodotto")
public class ProdottoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String idProdottoStr = request.getParameter("id");
        
        if (idProdottoStr != null && !idProdottoStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idProdottoStr);
                
                ProdottoDAO prodottoDAO = new ProdottoDAO();
                Prodotto prodottoTrovato = prodottoDAO.doRetrieveById(id); 
                
                if (prodottoTrovato != null) {
                	
                    request.setAttribute("prodotto", prodottoTrovato);
                    
                    String catCodice = "";
                    String catNome = "";
                    
                    if (prodottoTrovato.getCategoriaId() == 1) { 
                    	
                        catCodice = "MODELLO_3D"; catNome = "Modelli 3D"; 
                        
                    } else if (prodottoTrovato.getCategoriaId() == 2) { 
                    	
                        catCodice = "TEXTURE"; catNome = "Textures"; 
                        
                    } else if (prodottoTrovato.getCategoriaId() == 3) { 
                    	
                        catCodice = "STAMPA_3D"; catNome = "Stampe 3D"; 
                    }
                    
                    request.setAttribute("catCodice", catCodice);
                    request.setAttribute("catNome", catNome);
                }
                
            } catch (NumberFormatException e) {
                System.out.println("ID non valido");
            }
        }
        
        request.getRequestDispatcher("/WEB-INF/view//prodotto.jsp").forward(request, response);
    }
}