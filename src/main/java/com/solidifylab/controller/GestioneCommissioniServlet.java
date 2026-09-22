package com.solidifylab.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.solidifylab.dao.CommissioneDAO;
import com.solidifylab.model.Commissione;
import com.solidifylab.model.User;

@WebServlet("/GestioneCommissioni")
@MultipartConfig(
	    fileSizeThreshold = 1024 * 1024 * 10, // 10MB
	    maxFileSize = 1024 * 1024 * 500,      // 500MB per singolo file
	    maxRequestSize = 1024 * 1024 * 500    // 500MB richiesta totale
	)
public class GestioneCommissioniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User utente = null;
        
        if (session != null) {
            utente = (User) session.getAttribute("utenteLoggato");
        }

        if (utente == null || !"ADMIN".equals(utente.getRuolo())) {
            response.sendRedirect(request.getContextPath() + "/Home"); 
            return;
        }

        CommissioneDAO commissioneDAO = new CommissioneDAO();
        List<Commissione> listaCommissioni = commissioneDAO.getAllCommissioni();
        
        String openIdParam = request.getParameter("id");
        String openParam = request.getParameter("open");
        
        if (openIdParam != null && "true".equals(openParam)) {
            try {
                int targetId = Integer.parseInt(openIdParam);
                for (Commissione c : listaCommissioni) {
                    if (c.getId() == targetId) {
                        request.setAttribute("openCommissione", c);
                        break;
                    }
                }
            } catch (NumberFormatException e) {
            }
        }

        List<Commissione> inAttesa = new ArrayList<>();
        List<Commissione> accettate = new ArrayList<>();
        List<Commissione> inLavorazione = new ArrayList<>();
        List<Commissione> completate = new ArrayList<>();
        List<Commissione> rifiutate = new ArrayList<>();

        for (Commissione c : listaCommissioni) {
            String stato = c.getStato() != null ? c.getStato().toUpperCase().trim() : "IN_ATTESA";
            
            switch (stato) {
                case "IN_ATTESA": inAttesa.add(c); break;
                case "ACCETTATA": accettate.add(c); break;
                case "IN_LAVORAZIONE": inLavorazione.add(c); break;
                case "COMPLETATA": completate.add(c); break;
                case "RIFIUTATA": rifiutate.add(c); break;
                default: inAttesa.add(c); break;
            }
        }

        request.setAttribute("listaInAttesa", inAttesa);
        request.setAttribute("listaAccettate", accettate);
        request.setAttribute("listaInLavorazione", inLavorazione);
        request.setAttribute("listaCompletate", completate);
        request.setAttribute("listaRifiutate", rifiutate);
        
        request.getRequestDispatcher("/WEB-INF/view/admin_commissioni.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User utente = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
        
        if (utente == null || !"ADMIN".equals(utente.getRuolo())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accesso negato");
            return;
        }

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        if (action != null && idParam != null) {
            try {
                int commissioneId = Integer.parseInt(idParam);
                CommissioneDAO commissioneDAO = new CommissioneDAO();
                
                switch (action) {
                    case "accetta":
                        commissioneDAO.updateStato(commissioneId, "ACCETTATA");
                        break;
                    case "lavorazione":
                        commissioneDAO.updateStato(commissioneId, "IN_LAVORAZIONE");
                        break;

                    case "completa":
                        String nomeProd = request.getParameter("nome");
                        String descProd = request.getParameter("descrizione");
                        String prezzoStr = request.getParameter("prezzo");
                        double prezzoFinale = (prezzoStr != null && !prezzoStr.isEmpty()) ? Double.parseDouble(prezzoStr) : 0.0;
                        
                        Part filePart = request.getPart("file_prodotto");
                        String fileName = null;
                        
                        if (filePart != null && filePart.getSize() > 0) {
                            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                            originalFileName = originalFileName.replaceAll("\\s+", "_");
                            fileName = "comm_" + commissioneId + "_" + System.currentTimeMillis() + "_" + originalFileName;
                            
                            String appPath = getServletContext().getRealPath("");
                            String imgPath = appPath + File.separator + "product_images";
                            String uploadPath = appPath + File.separator + "uploads" + File.separator + "commissioni";
                            
                            File imgDir = new File(imgPath);
                            if (!imgDir.exists()) imgDir.mkdirs();
                            
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) uploadDir.mkdirs();
                            
                            File fileDestImg = new File(imgDir, fileName);
                            File fileDestUpload = new File(uploadDir, fileName);
                            
                            filePart.write(fileDestImg.getAbsolutePath());
                            
                            Files.copy(
                                fileDestImg.toPath(), 
                                fileDestUpload.toPath(),
                                StandardCopyOption.REPLACE_EXISTING
                            );
                        }
                        
                        boolean isModello3d = false;
                        boolean isTexture = false;
                        boolean isFisica = false;
                        
                        for (Commissione c : commissioneDAO.getAllCommissioni()) {
                            if (c.getId() == commissioneId) {
                                isModello3d = c.isRichiedeModello3d();
                                isTexture = c.isRichiedeTexture();
                                isFisica = c.isRichiedeStampa3d();
                                break;
                            }
                        }

                        com.solidifylab.model.Prodotto prodottoCommissione = new com.solidifylab.model.Prodotto();
                        prodottoCommissione.setNome(nomeProd != null && !nomeProd.isEmpty() ? nomeProd : "Commissione #" + commissioneId);
                        prodottoCommissione.setDescrizione(descProd != null ? descProd : "Prodotto personalizzato");
                        prodottoCommissione.setPrezzoCorrente(prezzoFinale);
                        prodottoCommissione.setIvaCorrente(22.00);
                        prodottoCommissione.setQuantitaDisponibile(1);
                        
                        String formatoAsset = ".ZIP";
                        if (isModello3d) {
                            formatoAsset = ".BLEND";
                        } else if (isTexture) {
                            formatoAsset = ".PNG";
                        }
                        prodottoCommissione.setFormatoFile(formatoAsset);
                        
                        prodottoCommissione.setImmagineCopertinaUrl(fileName); 
                        prodottoCommissione.setCategoriaId(isFisica ? 98 : 99); 
                        
                        com.solidifylab.dao.ProdottoDAO prodDAO = new com.solidifylab.dao.ProdottoDAO();
                        int nuovoProdottoId = prodDAO.doSaveReturnId(prodottoCommissione);
                        
                        if (nuovoProdottoId > 0) {
                            commissioneDAO.impostaComeCompletata(commissioneId, String.valueOf(nuovoProdottoId));
                        } else {
                            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nella generazione del prodotto");
                            return;
                        }
                        break;
                        
                    case "rifiuta":
                        commissioneDAO.updateStato(commissioneId, "RIFIUTATA");
                        break;
                    case "visiona":
                        commissioneDAO.segnaComeVisionata(commissioneId);
                        break;
                    default:
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Azione non valida");
                        return;
                }
                
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Operazione completata con successo");
                
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID non valido");
            } catch (Exception e) {
                e.printStackTrace(); 
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore del database o caricamento file");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametri mancanti");
        }
    }
}