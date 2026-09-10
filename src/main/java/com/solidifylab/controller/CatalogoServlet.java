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
        
        ProdottoDAO prodottoDAO = new ProdottoDAO();
        List<Prodotto> prodotti;
        
        // 1. Leggiamo il parametro 'tipo' dai tab in alto nella pagina
        String tipo = request.getParameter("tipo");
        
        // 2. Filtriamo in base alla tab selezionata
        if ("TEXTURES".equals(tipo)) {
            // Categoria ID 2 = Texture (come impostato nel tuo database)
            prodotti = prodottoDAO.doRetrieveByCategoria(2);
        } else {
            // Default o "3D" -> Categoria ID 1 = Modelli 3D
            prodotti = prodottoDAO.doRetrieveByCategoria(1);
        }
        
        // 3. Passiamo la lista filtrata alla request
        request.setAttribute("listaProdotti", prodotti);
        
        // 4. Forward alla JSP
        request.getRequestDispatcher("/WEB-INF/view/catalogo.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}