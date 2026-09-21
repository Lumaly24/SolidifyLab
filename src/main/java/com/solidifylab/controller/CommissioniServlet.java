package com.solidifylab.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.solidifylab.model.User;

@WebServlet("/Commissioni")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 20,       // 20MB massimo per il file di riferimento
    maxRequestSize = 1024 * 1024 * 50     // 50MB massimo per l'intera request
)
public class CommissioniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/commissioni.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User utenteLoggato = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;

        if (utenteLoggato == null) {
            response.sendRedirect(request.getContextPath() + "/Login?redirect=Stampe");
            return;
        }

        if (request.getContentType() != null && request.getContentType().toLowerCase().startsWith("multipart/")) {
            
            Part filePart = request.getPart("file_riferimento");
            
            if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                
                String lowerName = originalFileName.toLowerCase();
                if (!lowerName.endsWith(".stl") && !lowerName.endsWith(".obj") && !lowerName.endsWith(".3mf") && !lowerName.endsWith(".png")) {
                    request.setAttribute("errore", "Formato file non supportato. Carica un file .stl, .obj, .3mf o .png");
                    request.getRequestDispatcher("/WEB-INF/view/commissioni.jsp").forward(request, response);
                    return;
                }

                String uniqueFileName = UUID.randomUUID().toString() + "_" + originalFileName.replaceAll("\\s+", "_");
                
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "commissioni";
                File uploadDir = new File(uploadPath);
                
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs(); 
                }
                
                filePart.write(uploadPath + File.separator + uniqueFileName);
                
                session.setAttribute("nomeFileTemporaneo", uniqueFileName);
            }
        }
        
        doGet(request, response);
    }
}