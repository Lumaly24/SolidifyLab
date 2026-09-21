package com.solidifylab.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
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

@WebServlet("/Request")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  
    maxFileSize = 1024 * 1024 * 20,       
    maxRequestSize = 1024 * 1024 * 25     
)
public class RichiestaCommissioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        Commissione comm = new Commissione();
        
        HttpSession session = request.getSession(false);
        User utente = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
        
        String email = request.getParameter("email");
        if ((email == null || email.trim().isEmpty()) && utente != null) {
            email = utente.getEmail();
        }
        comm.setEmail(email);
        if (utente != null) comm.setUtenteId(utente.getId());
        
        String[] tipiCommissione = request.getParameterValues("tipo_commissione");
        if (tipiCommissione != null) {
            for (String t : tipiCommissione) {
                if ("stampa_3d".equals(t)) comm.setRichiedeStampa3d(true);
                if ("modello_3d".equals(t)) comm.setRichiedeModello3d(true);
                if ("texture".equals(t)) comm.setRichiedeTexture(true);
            }
        }
        
        comm.setDescrizione(request.getParameter("descrizione_principale"));
        comm.setVia(request.getParameter("indirizzo_via"));
        comm.setCitta(request.getParameter("indirizzo_citta"));
        comm.setCap(request.getParameter("indirizzo_cap"));
        
        List<String> fileCaricati = new ArrayList<>();
        
        String filePrecaricato = request.getParameter("file_gia_caricato");
        if (filePrecaricato != null && !filePrecaricato.isEmpty()) {
            fileCaricati.add(filePrecaricato);
            if (session != null) session.removeAttribute("nomeFileTemporaneo");
        }
        
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "commissioni";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        for (Part part : request.getParts()) {
            if (part.getName().equals("file_riferimento") && part.getSize() > 0) {
                String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                part.write(uploadPath + File.separator + fileName);
                fileCaricati.add(fileName);
            }
        }
        
        if (!fileCaricati.isEmpty()) {
            comm.setFileRiferimentoUrl(String.join(", ", fileCaricati));
        }

        if (request.getParameter("include_materiale") != null) {
            comm.setMaterialeStampa(request.getParameter("materiale_stampa"));
            comm.setDescMateriale(request.getParameter("desc_materiale"));
        }
        if (request.getParameter("include_postproduzione") != null) {
            comm.setTipoPostproduzione(request.getParameter("tipo_postproduzione"));
            comm.setDescPostproduzione(request.getParameter("desc_postproduzione"));
        }

        if (request.getParameter("include_texture_modello") != null) {
            comm.setIncludeTextureModello(true);
            comm.setDescrizioneTextureModello(request.getParameter("descrizione_texture_modello"));
        }
        if (request.getParameter("include_animazione") != null) {
            comm.setIncludeAnimazione(true);
            comm.setDescrizioneAnimazione(request.getParameter("descrizione_animazione"));
        }
        if (request.getParameter("include_rigging") != null) {
            comm.setIncludeRigging(true);
            comm.setDescrizioneRigging(request.getParameter("descrizione_rigging"));
        }

        if (request.getParameter("include_uv_mapping") != null) {
            comm.setIncludeUvMapping(true);
            comm.setDescUvMapping(request.getParameter("desc_uv_mapping"));
        }
        if (request.getParameter("include_materiali_pbr") != null) {
            comm.setIncludeMaterialiPbr(true);
            comm.setDescMaterialiPbr(request.getParameter("desc_materiali_pbr"));
        }

        try {
            CommissioneDAO commissioneDAO = new CommissioneDAO();
            commissioneDAO.doSave(comm);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore durante il salvataggio della commissione.");
            return;
        }
        
        request.setAttribute("successMessage", "La tua richiesta è stata inviata con successo. Analizzeremo il progetto e ti risponderemo in 24/48h!");
        request.getRequestDispatcher("/WEB-INF/view/Commissioni").forward(request, response);
    }
}