<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<% request.setAttribute("titoloPagina", "Ordine Completato"); 
   request.setAttribute("cssPagina", "carrello.css"); 
%>

<%@ include file="fragment/header.jspf" %>

<main class="cart-page-container invoice-page">
    
    <div class="web-only" style="text-align: center; width: 100%;">
        <div class="success-icon">
            <i class="fa-solid fa-circle-check"></i>
        </div>
        <h1 class="invoice-title">Grazie per aver acquistato da noi!</h1>
        <p class="invoice-subtitle">Il tuo ordine è stato elaborato con successo!</p>
    </div>

    <div class="print-only invoice-print-header">
    
        <div class="invoice-meta">
            <p>Data fattura: <fmt:formatDate value="${ultimoOrdine.dataOrdine}" pattern="dd/MM/yyyy" /><br>
               Data di scadenza: Pagato</p>
        </div>
    </div>
    
    <div class="print-only client-info">
        <p>Fattura a:<br>
        <strong>${ultimoOrdine.utente.nome} ${ultimoOrdine.utente.cognome}</strong><br>
        ${ultimoOrdine.utente.email}</p>
    </div>

    <h2 class="print-only print-invoice-title">Fattura n. ${ultimoOrdine.id}</h2>

    <div class="invoice-glass-box">
    
        <h3 class="web-only">Dettagli Ordine #${ultimoOrdine.id}</h3>
        <hr class="section-divider web-only">
        
        <div class="invoice-details web-only">
            <p><strong>Data:</strong> <span><fmt:formatDate value="${ultimoOrdine.dataOrdine}" pattern="dd/MM/yyyy HH:mm" /></span></p>
            <p><strong>Stato Ordine:</strong> <span class="status-success">${ultimoOrdine.stato}</span></p>
        </div>

        <h4 class="web-only" style="font-family: 'elephant', serif; font-size: 1.2rem; margin: 20px 0 10px 0; color: #0f0326;">Articoli Acquistati:</h4>
        
        <table class="invoice-table">
        
            <thead>
            
                <tr>
                    <th style="text-align: left;">Descrizione</th>
                    <th style="text-align: center;">Quantità</th>
                    <th style="text-align: right;">Prezzo</th>
                    <th style="text-align: right;">Subtotale</th>
                </tr>
                
            </thead>
            
            <tbody>
                <c:forEach var="item" items="${ultimoOrdine.articoli}">
                
                    <tr>
                        <td style="text-align: left;">${item.prodotto.nome}</td>
                        <td style="text-align: center;">${item.quantita}</td>
                        <td style="text-align: right;">
                            <fmt:formatNumber value="${item.prodotto.prezzoCorrente}" pattern="#,##0.00"/> €
                        </td>
                        
                        <td style="text-align: right;">
                            <fmt:formatNumber value="${item.prodotto.prezzoCorrente * item.quantita}" pattern="#,##0.00"/> €
                        </td>
                        
                    </tr>
                    
                </c:forEach>
                
            </tbody>
            
        </table>
        
        <hr class="section-divider web-only">
        
        <c:set var="totaleIva" value="0" />
        
        <c:forEach var="item" items="${ultimoOrdine.articoli}">
        
            <c:set var="prezzoRiga" value="${item.prodotto.prezzoCorrente * item.quantita}" />
            
            <c:set var="ivaRiga" value="${prezzoRiga - (prezzoRiga / (1 + (item.prodotto.ivaCorrente / 100.0)))}" />
            
            <c:set var="totaleIva" value="${totaleIva + ivaRiga}" />
            
        </c:forEach>
        
        <div class="invoice-details web-only">
        
            <p><strong>Subtotale (senza IVA):</strong> <span>€ <fmt:formatNumber value="${ultimoOrdine.totale - totaleIva}" pattern="#,##0.00"/></span></p>
            <p><strong>IVA:</strong> <span>€ <fmt:formatNumber value="${totaleIva}" pattern="#,##0.00"/></span></p>
            <p><strong>Totale Pagato:</strong> <span>€ <fmt:formatNumber value="${ultimoOrdine.totale}" pattern="#,##0.00"/></span></p>
        
        </div>

        <div class="print-only print-totals">
        
            <p>Subtotale (senza IVA): <fmt:formatNumber value="${ultimoOrdine.totale - totaleIva}" pattern="#,##0.00"/> €</p>
            <p>IVA: <fmt:formatNumber value="${totaleIva}" pattern="#,##0.00"/> €</p>
            <p style="font-weight: bold; font-size: 12pt;">Totale: <fmt:formatNumber value="${ultimoOrdine.totale}" pattern="#,##0.00"/> €</p>
        
        </div>
        
    </div>

    <div class="invoice-actions web-only" style="width: 100%; text-align: center;">
    
        <a href="${pageContext.request.contextPath}/Catalogo" class="btn-primary" style="text-decoration: none;">Torna allo Shopping</a>
        <button onclick="window.print()" class="btn-primary stampa-ricevuta" style="margin-right: 15px; text-decoration: none;">
            <i class="fa-solid fa-print"></i> Stampa Ricevuta
        </button>
        
    </div>
    
</main>

<%@ include file="fragment/footer.jspf" %>