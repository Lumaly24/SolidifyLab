package com.solidifylab.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.solidifylab.model.Prodotto;
import com.solidifylab.dao.ProdottoDAO;

@WebServlet("/EditProductServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class EditProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public EditProductServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String nome = request.getParameter("nome");
        String descrizione = request.getParameter("descrizione");
        String prezzoStr = request.getParameter("prezzo");
        String categoriaStr = request.getParameter("categoria");
        
        String[] tagScelti = request.getParameterValues("tags"); 
        
        if (idStr != null && nome != null && !nome.trim().isEmpty() && prezzoStr != null && categoriaStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                double prezzo = Double.parseDouble(prezzoStr.replace(",", "."));
                int categoriaId = Integer.parseInt(categoriaStr);

                ProdottoDAO prodottoDAO = new ProdottoDAO();
                Prodotto p = prodottoDAO.doRetrieveById(id);
                
                if (p != null) {
                    p.setNome(nome);
                    p.setDescrizione(descrizione);
                    p.setPrezzoCorrente(prezzo);
                    p.setCategoriaId(categoriaId);
                    
                    p.setQuantitaDisponibile(categoriaId == 3 ? 10 : 0);
                    p.setFormatoFile(categoriaId == 3 ? null : ".zip");

                    Part filePart = request.getPart("immagine");
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                        String uploadPath = getServletContext().getRealPath("") + File.separator + "product_images";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) uploadDir.mkdir();
                        
                        filePart.write(uploadPath + File.separator + fileName);
                        p.setImmagineCopertinaUrl(fileName); 
                    }

                    prodottoDAO.doUpdate(p);
                    
                    if (tagScelti != null && tagScelti.length > 0) {
                        prodottoDAO.doDeleteTagsByProdottoId(id);       
                        prodottoDAO.doSaveTagsByNames(id, tagScelti);   
                    }
                    
                    request.getSession().setAttribute("successMessage", "Prodotto e tag aggiornati con successo!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Prodotto non trovato.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Formato dati non valido.");
            }
        } else {
            request.getSession().setAttribute("errorMessage", "Compila tutti i campi obbligatori.");
        }

        response.sendRedirect(request.getContextPath() + "/AdminDashboard#gestione-prodotti");
    }
}