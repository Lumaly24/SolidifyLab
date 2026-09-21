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
        
        if (request.getContentType() != null && request.getContentType().toLowerCase().startsWith("multipart/")) {
            
            Part filePart = request.getPart("file_riferimento");
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "commissioni";
                File uploadDir = new File(uploadPath);
                
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs(); 
                }
                
                filePart.write(uploadPath + File.separator + fileName);
                
                request.getSession().setAttribute("nomeFileTemporaneo", fileName);
            }
        }
        
        doGet(request, response);
    }
}