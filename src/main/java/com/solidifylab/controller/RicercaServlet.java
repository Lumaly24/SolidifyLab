package com.solidifylab.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.solidifylab.dao.ProdottoDAO;
import com.solidifylab.model.Prodotto;

@WebServlet("/Search")
public class RicercaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("q");
        String contesto = request.getParameter("contesto");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (query == null || query.trim().length() < 2) {
            out.print("[]"); 
            out.flush();
            return;
        }

        try {
            ProdottoDAO dao = new ProdottoDAO();
            List<Prodotto> risultati = dao.doRetrieveByNomeAndContesto(query.trim(), contesto);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < risultati.size(); i++) {
                Prodotto p = risultati.get(i);
                
                String nomeSicuro = p.getNome().replace("\"", "\\\""); 
                
                json.append("{")
                    .append("\"id\":").append(p.getId()).append(",")
                    .append("\"nome\":\"").append(nomeSicuro).append("\",")
                    .append("\"prezzo\":").append(p.getPrezzoCorrente())
                    .append("}");
                
                if (i < risultati.size() - 1) {
                    json.append(","); 
                }
            }
            json.append("]");
            
            out.print(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("[]"); 
        }
        out.flush();
    }
}