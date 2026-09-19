<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<% 
    request.setAttribute("titoloPagina", "Scopri di più | SolidifyLab"); 
    request.setAttribute("cssPagina", "scopri.css");
%>

<%@ include file="fragment/header.jspf" %>

<div class="admin-body-wrapper scopri-wrapper">

    <!-- SEZIONE INTRODUTTIVA -->
    <div class="admin-card scopri-hero-card">
        <h1 class="scopri-hero-title">IL TUO VIAGGIO CREATIVO INIZIA QUI</h1>
        <p class="scopri-hero-text">
            <strong>SolidifyLab</strong> nasce dall'unione tra la passione per la modellazione tridimensionale e lo sviluppo web avanzato. Un punto di riferimento per artisti, designer e maker alla ricerca di risorse digitali di altissima qualità e servizi di stampa su misura.
        </p>
    </div>

    <!-- SEZIONE CARATTERISTICHE (GRID) -->
    <div class="scopri-grid">
        
        <div class="admin-card scopri-feature-card">
            <i class="fa-solid fa-cube scopri-feature-icon-pink"></i>
            <h3 class="scopri-feature-title">Modelli 3D Ottimizzati</h3>
            <p class="scopri-feature-desc">
                Asset puliti, low-poly e high-poly, rigorosamente Game Ready e testati per integrarsi al meglio nei tuoi progetti con Blender, Eevee Next e Cycles.
            </p>
        </div>

        <div class="admin-card scopri-feature-card">
            <i class="fa-solid fa-mountain-sun scopri-feature-icon-purple"></i>
            <h3 class="scopri-feature-title">Textures Seamless</h3>
            <p class="scopri-feature-desc">
                Mappe e superfici dettagliate pensate per dare vita e realismo a qualsiasi ambiente architettonico, organico o fantasy.
            </p>
        </div>

        <div class="admin-card scopri-feature-card">
            <i class="fa-solid fa-print scopri-feature-icon-pink"></i>
            <h3 class="scopri-feature-title">Stampe 3D & Commissioni</h3>
            <p class="scopri-feature-desc">
                Realizziamo fisicamente le tue idee tramite stampa in resina o filamento (PLA/PETG), offrendo anche servizi di post-produzione, levigatura e primer.
            </p>
        </div>

    </div>

    <!-- SEZIONE CTA FINALE -->
    <div class="admin-card scopri-cta-card">
        <h2 class="scopri-cta-title">Pronto a dare forma alle tue idee?</h2>
        <p class="scopri-cta-desc">Esplora subito la libreria o richiedi una commissione personalizzata.</p>
        
        <div class="scopri-cta-buttons">
            <a href="${pageContext.request.contextPath}/Catalogo" class="auth-btn" style="text-decoration: none; display: inline-block;">Esplora il Catalogo</a>
            <c:choose>
                <c:when test="${not empty sessionScope.utenteLoggato}">
                    <a href="${pageContext.request.contextPath}/UserDashboard" class="scopri-btn-secondary">Richiedi Commissione</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/Login" class="scopri-btn-secondary">Accedi / Registrati</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</div>

<%@ include file="fragment/footer.jspf" %>