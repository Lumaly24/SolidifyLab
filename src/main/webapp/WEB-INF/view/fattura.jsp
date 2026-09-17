<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<% request.setAttribute("titoloPagina", "Ordine Completato"); 
   request.setAttribute("cssPagina", "carrello.css"); 
%>

<%@ include file="fragment/header.jspf" %>

<main class="cart-page-container invoice-page">
    
    <div class="success-icon">
        <i class="fa-solid fa-circle-check"></i>
    </div>

    <h1 class="invoice-title">Grazie di aver acquistato da noi!</h1>
    <p class="invoice-subtitle">Il tuo ordine è stato elaborato con successo.</p>

    <div class="invoice-glass-box">
        <h3>Dettagli Ordine #${sessionScope.ultimoOrdine.id}</h3>
        <hr class="section-divider">
        
        <div class="invoice-details">
            <p><strong>Data:</strong> <span>${sessionScope.ultimoOrdine.data}</span></p>
            <p><strong>Stato Ordine:</strong> <span class="status-success">${sessionScope.ultimoOrdine.stato}</span></p>
            <p><strong>Totale Pagato:</strong> <span>€ <fmt:formatNumber value="${sessionScope.ultimoOrdine.totale}" pattern="#,##0.00"/></span></p>
        </div>
    </div>

    <div class="invoice-actions">
        <a href="${pageContext.request.contextPath}/Catalogo" class="btn-primary" style="text-decoration: none;">Torna allo Shopping</a>
    </div>

</main>

<%@ include file="fragment/footer.jspf" %>