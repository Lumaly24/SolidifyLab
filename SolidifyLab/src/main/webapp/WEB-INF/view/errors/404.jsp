<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<% request.setAttribute("titoloPagina", "404 - Pagina non trovata"); %>
<%@ include file="../fragment/header.jspf" %>

    <main class="error-page-container" style="text-align: center; padding: 5rem 1rem;">
        <div class="error-content" style="max-width: 600px; margin: 0 auto;">
            <i class="fa-solid fa-cube" style="font-size: 5rem; color: #b9c1df; margin-bottom: 20px;"></i>
            <h1 style="font-size: 3rem; margin-bottom: 10px;">404</h1>
            <h2>Ops! Il modello 3D è svanito nel nulla</h2>
            <p style="color: #666; margin: 20px 0;">
                La pagina che stai cercando potrebbe essere stata rimossa, rinominata o temporaneamente inattiva nel nostro multiverso digitale.
            </p>
            <div class="error-actions" style="margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn-primary" style="padding: 12px 30px; text-decoration: none; border-radius: 30px;">
                    <i class="fa-solid fa-house"></i> Torna alla Home
                </a>
            </div>
        </div>
    </main>

<%@ include file="../fragment/footer.jspf" %>