<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<% 
    request.setAttribute("titoloPagina", "Stampe 3D");
    request.setAttribute("cssPagina", "stampe3d.css");
%>

<%@ include file="fragment/header.jspf" %>

<div class="bg-video-container">
    <div class="bg-video-overlay"></div>
</div>

<main class="catalog-page">
    <div class="catalog-layout">
        
        <!-- SIDEBAR FILTRI -->
        <aside class="catalog-sidebar">
            <form action="${pageContext.request.contextPath}/StampeServlet" method="GET">
                
                <div class="filter-group">
                    <h3>Materiale</h3>
                    <ul class="filter-list">
                        <li><label><input type="checkbox" name="materiale" value="resina"> Resina 8K</label></li>
                        <li><label><input type="checkbox" name="materiale" value="pla"> PLA Tough</label></li>
                    </ul>
                </div>

                <hr class="sidebar-divider">
                
                <div class="filter-group">
                    <h3>Filtro Prezzi</h3>
                    
                    <div class="price-slider">
                        <c:set var="currentVal" value="${not empty param.max_price ? param.max_price : 150}" />
                        
                        <input type="range" id="priceRange" name="max_price" min="0" max="300" step="10" value="${currentVal}">
                        
                        <div class="price-labels">
                            <span>Da 0€</span>
                            <span>Fino a: <b id="priceVal">${currentVal}€</b></span>
                        </div>
                    </div>
                </div>
                
                <button type="submit" class="btn-primary w-100 mt-3">Applica Filtri</button>
            </form>
        </aside>

        <!-- COLONNA DI DESTRA -->
        <section class="catalog-main-content">
            
            <div class="top-nav-row">
                <nav class="breadcrumbs" aria-label="Percorso di navigazione">
                    <a href="${pageContext.request.contextPath}/index.jsp">Home</a> 
                    <span class="separator">/</span> 
                    <span class="current-page">Modelli Stampabili</span>
                </nav>

                <c:if test="${not empty sessionScope.utenteLoggato and sessionScope.utenteLoggato.ruolo == 'ADMIN'}">
				    <a href="${pageContext.request.contextPath}/admin.jsp#gestione-prodotti" class="btn-primary" style="padding: 5px 15px; font-size: 0.9em;">
				        <i class="fa-solid fa-plus"></i> Nuova Stampa
				    </a>
				</c:if>
            </div>
            
            <section class="hero-section">
                <div class="hero-card">
                    <h1>SERVIZIO STAMPA 3D</h1>
                    <p>
                        Scegli tra i nostri modelli ottimizzati per la stampa o richiedi un preventivo personalizzato. 
                        Garantiamo altissima risoluzione in Resina 8K e massima resistenza in PLA.
                    </p>
                    
                    <div class="file-upload-wrapper">
                        <input type="file" id="file3dInput" name="file_3d" accept=".stl,.obj,.3mf" class="file-input-hidden">
                        <label for="file3dInput" class="file-dropzone">
                            <i class="fa-solid fa-cloud-arrow-up upload-icon"></i>
                            <span class="upload-title">Carica il tuo file 3D (.STL, .OBJ)</span>
                            <span class="upload-sub">Clicca o trascina il file qui</span>
                        </label>
                    </div>  
                    
                    <div class="hero-buttons">
                        <a href="${pageContext.request.contextPath}/commissioni.jsp" class="btn"> 
                            <i class="fa-solid fa-wand-magic-sparkles"></i> STAMPA UN TUO FILE 
                        </a> 
                    </div>
                </div>
            </section>

            <div class="catalog-products-grid">
                <c:choose>
                    <c:when test="${empty listaStampe}">
                        <div class="empty-products-msg">
                            <p>Nessun modello stampabile trovato.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="prodotto" items="${listaStampe}">
                            <article class="product-card">
                                <div class="product-badges">
                                    <form action="${pageContext.request.contextPath}/AggiungiWishlistServlet" method="POST" style="display:inline;">
                                        <input type="hidden" name="id_prodotto" value="${prodotto.id}">
                                        <button type="submit" class="btn-wishlist" title="Aggiungi alla Wishlist">
                                            <i class="fa-regular fa-heart"></i>
                                        </button>
                                    </form>
                                </div>
                                
                                <a href="${pageContext.request.contextPath}/DettaglioProdottoServlet?id=${prodotto.id}" class="product-link">
                                    <div class="product-image">
                                        <span>(IMG ${prodotto.nome})</span>
                                    </div>
                                    <div class="product-info-minimal">
                                        <h4 class="product-title">${prodotto.nome}</h4>
                                        <div class="product-price">€ <fmt:formatNumber value="${prodotto.prezzo}" pattern="#,##0.00"/></div>
                                    </div>
                                </a>
                            </article>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
            
        </section>
        
    </div>
</main>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const slider = document.getElementById('priceRange');
        const priceDisplay = document.getElementById('priceVal');

        function updateSlider() {
            if (!slider) return;
            const min = parseFloat(slider.min) || 0;
            const max = parseFloat(slider.max) || 300;
            const val = parseFloat(slider.value) || 0;
            
            // 1. Calcola la percentuale
            const pct = ((val - min) / (max - min)) * 100;

            // 2. Aggiorna il testo del prezzo
            if (priceDisplay) {
                priceDisplay.innerText = val + '€';
            }

            // 3. Inietta la percentuale direttamente nella variabile CSS del custom slider
            slider.style.setProperty('--slider-pct', pct + '%');
        }

        if (slider) {
            slider.addEventListener('input', updateSlider);
            slider.addEventListener('change', updateSlider);
            updateSlider(); // Esecuzione al primo caricamento
        }
    });
</script>

<%@ include file="fragment/footer.jspf" %>