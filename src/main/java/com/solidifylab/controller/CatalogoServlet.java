package com.solidifylab.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.dao.ProdottoDAO;
import com.solidifylab.dao.WishlistDAO;
import com.solidifylab.model.Prodotto;
import com.solidifylab.model.User;

@WebServlet("/Catalogo")
public class CatalogoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        ProdottoDAO prodottoDAO = new ProdottoDAO();
        List<Prodotto> prodotti;
        
        String tipo = request.getParameter("tipo");
        String maxPriceStr = request.getParameter("max_price");
        String[] tags = request.getParameterValues("tag"); 
        
        int categoriaId = "TEXTURES".equals(tipo) ? 2 : 1;
        
        double maxPrice = 9999.99; 
        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            try {
                maxPrice = Double.parseDouble(maxPriceStr);
            } catch (NumberFormatException e) {
            }
        }
        
        prodotti = prodottoDAO.doRetrieveByFilters(categoriaId, maxPrice, tags);
        
        request.setAttribute("listaProdotti", prodotti);
        request.setAttribute("selectedTags", tags);
        
        HttpSession session = request.getSession(false);
        User utenteLoggato = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
        
        if (utenteLoggato != null) {
            WishlistDAO wishlistDAO = new WishlistDAO();
            List<Integer> wishlistIds = wishlistDAO.getWishlistIdsByUtente(utenteLoggato.getId());
            session.setAttribute("wishlistIds", wishlistIds);
        }
        
        request.getRequestDispatcher("/WEB-INF/view/catalogo.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}