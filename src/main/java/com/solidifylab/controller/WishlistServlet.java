package com.solidifylab.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.dao.WishlistDAO;
import com.solidifylab.model.Prodotto;
import com.solidifylab.model.User;

@WebServlet("/Wishlist") 
public class WishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        User utenteLoggato = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
        
        if (utenteLoggato != null) {
            
            String tipo = request.getParameter("tipo");
            
            WishlistDAO wishlistDAO = new WishlistDAO();
            List<Prodotto> listaWishlist;
            
            if (tipo != null && !tipo.trim().isEmpty()) {
                int categoriaId = 1;
                if ("TEXTURES".equals(tipo)) {
                    categoriaId = 2;
                } else if ("STAMPE".equals(tipo)) {
                    categoriaId = 3;
                }
                listaWishlist = wishlistDAO.getProdottiWishlistPerCategoria(utenteLoggato.getId(), categoriaId);
            } else {
                listaWishlist = wishlistDAO.getWishlistByUtente(utenteLoggato.getId());
            }
            
            request.setAttribute("listaWishlist", listaWishlist);
            
            request.getRequestDispatcher("/WEB-INF/view/wishlist.jsp").forward(request, response);
            
        } else {
            response.sendRedirect(request.getContextPath() + "/Login?errore=auth");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}