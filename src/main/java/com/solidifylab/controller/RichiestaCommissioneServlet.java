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
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 20,       // 20MB
    maxRequestSize = 1024 * 1024 * 25     // 25MB
)
public class RichiestaCommissioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        Commissione comm = new Commissione();
        
        // 1. Date Utente
        HttpSession session = request.getSession(false);
        User utente = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;
        
        String email = request.getParameter("email");
        if ((email == null || email.trim().isEmpty()) && utente != null) {
            email = utente.getEmail();
        }
        comm.setEmail(email);
        if (utente != null) comm.setUtenteId(utente.getId());
        
        // 2. Tipologie
        String[] tipiCommissione = request.getParameterValues("tipo_commissione");
        if (tipiCommissione != null) {
            for (String t : tipiCommissione) {
                if ("stampa_3d".equals(t)) comm.setRichiedeStampa3d(true);
                if ("modello_3d".equals(t)) comm.setRichiedeModello3d(true);
                if ("texture".equals(t)) comm.setRichiedeTexture(true);
            }
        }
        
        // 3. Dati Base[cite: 4]
        comm.setDescrizione(request.getParameter("descrizione_principale"));
        comm.setVia(request.getParameter("indirizzo_via"));
        comm.setCitta(request.getParameter("indirizzo_citta"));
        comm.setCap(request.getParameter("indirizzo_cap"));
        
        // 4. Gestione File Allegati[cite: 4]
        List<String> fileCaricati = new ArrayList<>();
        
        // Controlla se c'è un file passato via sessione (es. da /Stampe)
        String filePrecaricato = request.getParameter("file_gia_caricato");
        if (filePrecaricato != null && !filePrecaricato.isEmpty()) {
            fileCaricati.add(filePrecaricato);
            if (session != null) session.removeAttribute("nomeFileTemporaneo");
        }
        
        // Gestisci nuovi file caricati nel form
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

        // 5. Opzioni Stampa 3D[cite: 5]
        if (request.getParameter("include_materiale") != null) {
            comm.setMaterialeStampa(request.getParameter("materiale_stampa"));
            comm.setDescMateriale(request.getParameter("desc_materiale"));
        }
        if (request.getParameter("include_postproduzione") != null) {
            comm.setTipoPostproduzione(request.getParameter("tipo_postproduzione"));
            comm.setDescPostproduzione(request.getParameter("desc_postproduzione"));
        }

        // 6. Opzioni Modello 3D[cite: 5]
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

        // 7. Opzioni Texture[cite: 5]
        if (request.getParameter("include_uv_mapping") != null) {
            comm.setIncludeUvMapping(true);
            comm.setDescUvMapping(request.getParameter("desc_uv_mapping"));
        }
        if (request.getParameter("include_materiali_pbr") != null) {
            comm.setIncludeMaterialiPbr(true);
            comm.setDescMaterialiPbr(request.getParameter("desc_materiali_pbr"));
        }

        // 8. Salvataggio
        try {
            CommissioneDAO commissioneDAO = new CommissioneDAO();
            commissioneDAO.doSave(comm);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore durante il salvataggio della commissione.");
            return;
        }
        
        request.setAttribute("successMessage", "La tua richiesta è stata inviata con successo. Analizzeremo il progetto e ti risponderemo in 24/48h!");
        request.getRequestDispatcher("/WEB-INF/view/commissioni.jsp").forward(request, response);
    }
}