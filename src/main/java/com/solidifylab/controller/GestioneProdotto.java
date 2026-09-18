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

@WebServlet("/Add&Remove")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB massimo per l'immagine
    maxRequestSize = 1024 * 1024 * 50     // 50MB massimo per tutta la request
)
public class GestioneProdotto extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public GestioneProdotto() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/AdminDashboard");
            return;
        }

        try {
            switch (action) {
                case "add":
                    aggiungiProdotto(request, response);
                    break;
                case "remove":
                    rimuoviProdotto(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/AdminDashboard");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Errore durante l'operazione sul prodotto.");
            response.sendRedirect(request.getContextPath() + "/AdminDashboard");
        }
    }

    private void aggiungiProdotto(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String nome = request.getParameter("nome");
        String descrizione = request.getParameter("descrizione");
        String prezzoStr = request.getParameter("prezzo");
        String categoriaStr = request.getParameter("categoria");
        
        String[] tagScelti = request.getParameterValues("tags"); 

        if (nome != null && !nome.trim().isEmpty() && prezzoStr != null && categoriaStr != null) {
            try {
                double prezzo = Double.parseDouble(prezzoStr);
                
                int categoriaId = 1; 
                if ("TEXTURE".equals(categoriaStr)) {
                    categoriaId = 2;
                } else if ("STAMPA_3D".equals(categoriaStr)) {
                    categoriaId = 3;
                }

                Part filePart = request.getPart("immagine"); 
                String fileName = "default.png"; 
                
                if (filePart != null && filePart.getSize() > 0) {
                    fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "product_images";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }
                    
                    filePart.write(uploadPath + File.separator + fileName);
                }

                Prodotto p = new Prodotto();
                p.setNome(nome);
                p.setDescrizione(descrizione);
                p.setPrezzoCorrente(prezzo);
                p.setCategoriaId(categoriaId);
                p.setImmagineCopertinaUrl(fileName); 
                
                p.setIvaCorrente(22.0); 
                p.setQuantitaDisponibile(categoriaId == 3 ? 10 : 0); 
                p.setFormatoFile(categoriaId == 3 ? null : ".zip"); 
                
                ProdottoDAO prodottoDAO = new ProdottoDAO();
                
                int nuovoProdottoId = prodottoDAO.doSave(p);
                
                if (nuovoProdottoId > 0 && tagScelti != null && tagScelti.length > 0) {
                    prodottoDAO.doSaveTagsByNames(nuovoProdottoId, tagScelti);
                }

                request.getSession().setAttribute("successMessage", "Prodotto aggiunto con successo al catalogo!");
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Formato prezzo non valido.");
            }
        } else {
            request.getSession().setAttribute("errorMessage", "Compila tutti i campi obbligatori.");
        }

        response.sendRedirect(request.getContextPath() + "/AdminDashboard#aggiunta-prodotti");
    }

    private void rimuoviProdotto(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                
                ProdottoDAO prodottoDAO = new ProdottoDAO();
                prodottoDAO.doDelete(id);

                request.getSession().setAttribute("successMessage", "Prodotto eliminato definitivamente!");
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "ID prodotto non valido.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/Catalogo");
    }
}