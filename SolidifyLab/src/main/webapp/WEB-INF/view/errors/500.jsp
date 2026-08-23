<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<% request.setAttribute("titoloPagina", "500 - Errore del Server"); %>
<%@ include file="../fragment/header.jspf" %>

    <main class="error-page-container" style="text-align: center; padding: 5rem 1rem;">
        <div class="error-content" style="max-width: 600px; margin: 0 auto;">
            <i class="fa-solid fa-triangle-exclamation" style="font-size: 5rem; color: #dc3545; margin-bottom: 20px;"></i>
            <h1 style="font-size: 3rem; margin-bottom: 10px;">500</h1>
            <h2>Errore Critico nel Sistema</h2>
            <p style="color: #666; margin: 20px 0;">
                Il nostro server ha riscontrato un problema imprevisto durante l'elaborazione della richiesta. I nostri tecnici (o tu, tra poco sul codice) sono all'opera!
            </p>
            <div class="error-actions" style="margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn-primary" style="padding: 12px 30px; text-decoration: none; border-radius: 30px;">
                    <i class="fa-solid fa-rotate-right"></i> Riprova / Torna alla Home
                </a>
            </div>
        </div>
    </main>

<%@ include file="../fragment/footer.jspf" %>