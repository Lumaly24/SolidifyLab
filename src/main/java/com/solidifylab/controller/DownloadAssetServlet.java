package com.solidifylab.controller;

import java.io.InputStream;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.solidifylab.dao.ProdottoDAO;
import com.solidifylab.model.Prodotto;
import com.solidifylab.model.User;

@WebServlet("/DownloadAssetServlet")
public class DownloadAssetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @SuppressWarnings("unchecked")
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User utenteLoggato = (session != null) ? (User) session.getAttribute("utenteLoggato") : null;

        if (utenteLoggato == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/UserDashboard");
            return;
        }

        try {
            int assetId = Integer.parseInt(idParam);
            Set<Integer> idAssetPosseduti = (Set<Integer>) session.getAttribute("idAssetPosseduti");
            
            if (idAssetPosseduti != null && idAssetPosseduti.contains(assetId)) {
                
                ProdottoDAO prodottoDAO = new ProdottoDAO();
                Prodotto prodotto = prodottoDAO.doRetrieveById(assetId);
                
                if (prodotto != null && prodotto.getImmagineCopertinaUrl() != null && !prodotto.getImmagineCopertinaUrl().isEmpty()) {
                    
                    String imagePath = "/product_images/" + prodotto.getImmagineCopertinaUrl();
                    InputStream inStream = getServletContext().getResourceAsStream(imagePath);
                    
                    if (inStream != null) {
                        try {
                            String mimeType = getServletContext().getMimeType(imagePath);
                            if (mimeType == null) {        
                                mimeType = "application/octet-stream";
                            }
                            
                            response.setContentType(mimeType);
                            
                            String nomePulito = prodotto.getNome() != null ? prodotto.getNome().replaceAll("\\s+", "_") : "Asset";
                            String headerValue = String.format("attachment; filename=\"SolidifyLab_%s_Asset.png\"", nomePulito);
                            response.setHeader("Content-Disposition", headerValue);
                            
                            try (OutputStream outStream = response.getOutputStream()) {
                                byte[] buffer = new byte[4096];
                                int bytesRead;
                                 
                                while ((bytesRead = inStream.read(buffer)) != -1) {
                                    outStream.write(buffer, 0, bytesRead);
                                }
                                outStream.flush();
                            }
                            return;
                        } finally {
                            inStream.close();
                        }
                    }
                }
                
                response.sendRedirect(request.getContextPath() + "/UserDashboard");
                
            } else {
                response.sendRedirect(request.getContextPath() + "/UserDashboard");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/UserDashboard");
        }
    }
}