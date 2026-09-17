<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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
        
        <!-- ================= SIDEBAR FILTRI ================= -->
        <aside class="catalog-sidebar">
            <form action="${pageContext.request.contextPath}/Stampe" method="GET">
                
                <!-- Trasformiamo gli array dei parametri in stringhe semplici per poter verificare le spunte -->
                <c:set var="catScelte" value="${fn:join(paramValues.categoria, ',')}" />
                <c:set var="matScelti" value="${fn:join(paramValues.materiale, ',')}" />
                <c:set var="finScelte" value="${fn:join(paramValues.finitura, ',')}" />
                
                <!-- Filtro Prezzi -->
                <div class="filter-group">
                    <h3>Filtro Prezzi</h3>
                    <div class="price-slider">
                        <!-- Default a 300 se non ci sono parametri impostati -->
                        <c:set var="currentVal" value="${not empty param.max_price ? param.max_price : 300}" />
                        
                        <input type="range" id="priceRange" name="max_price" min="0" max="300" step="10" value="${currentVal}">
                        
                        <div class="price-labels">
                            <span>0€</span>
                            <span>Fino a: <b id="priceVal">${currentVal}€</b></span>
                        </div>
                    </div>
                </div>

                <hr class="sidebar-divider">
                
                <!-- Categorie (Stampe 3D) -->
                <div class="filter-group">
                    <h3>Stampe 3D</h3>
                    <ul class="filter-list">
                        <li>
                            <label>
                                <input type="checkbox" name="categoria" value="miniature" ${fn:contains(catScelte, 'miniature') ? 'checked' : ''}> 
                                Miniature
                            </label>
                        </li>
                        <li>
                            <label>
                                <input type="checkbox" name="categoria" value="props" ${fn:contains(catScelte, 'props') ? 'checked' : ''}> 
                                Props
                            </label>
                        </li>
                        <li>
                            <label>
                                <input type="checkbox" name="categoria" value="accessori" ${fn:contains(catScelte, 'accessori') ? 'checked' : ''}> 
                                Accessori
                            </label>
                        </li>
                    </ul>
                </div>

                <!-- Specifiche Tecniche -->
                <div class="filter-group">
                    <h3>Specifiche tecniche</h3>
                    
                    <!-- Sotto-categoria: Materiali -->
                    <details open>
                        <summary>Materiali</summary>
                        <ul class="filter-list">
                            <li>
                                <label>
                                    <input type="checkbox" name="materiale" value="resina" ${fn:contains(matScelti, 'resina') ? 'checked' : ''}> 
                                    Resina
                                </label>
                            </li>
                            <li>
                                <label>
                                    <input type="checkbox" name="materiale" value="pla" ${fn:contains(matScelti, 'pla') ? 'checked' : ''}> 
                                    PLA
                                </label>
                            </li>
                            <li>
                                <label>
                                    <input type="checkbox" name="materiale" value="petg" ${fn:contains(matScelti, 'petg') ? 'checked' : ''}> 
                                    PETG
                                </label>
                            </li>
                        </ul>
                    </details>

                    <!-- Sotto-categoria: Finitura -->
                    <details open>
                        <summary>Finitura</summary>
                        <ul class="filter-list">
                            <li>
                                <label>
                                    <input type="checkbox" name="finitura" value="supporti_rimossi" ${fn:contains(finScelte, 'supporti_rimossi') ? 'checked' : ''}> 
                                    Supporti Rimossi
                                </label>
                            </li>
                            <li>
                                <label>
                                    <input type="checkbox" name="finitura" value="levigatura_primer" ${fn:contains(finScelte, 'levigatura_primer') ? 'checked' : ''}> 
                                    Levigatura + Primer Base
                                </label>
                            </li>
                            <li>
                                <label>
                                    <input type="checkbox" name="finitura" value="colore" ${fn:contains(finScelte, 'colore') ? 'checked' : ''}> 
                                    Colore
                                </label>
                            </li>
                        </ul>
                    </details>
                </div>
                
                <button type="submit" class="btn-primary w-100 mt-3">APPLICA FILTRI</button>

            </form>
        </aside>

        <!-- ================= COLONNA DI DESTRA ================= -->
        <section class="catalog-main-content">
            
            <div class="top-nav-row">
                <nav class="breadcrumbs" aria-label="Percorso di navigazione">
                    <a href="${pageContext.request.contextPath}/Stampe">Libreria Stampe 3D</a> 
                    <span class="separator">/</span> 
                    <span class="current-page">Modelli Stampabili</span>
                </nav>

                <c:if test="${not empty sessionScope.utenteLoggato and sessionScope.utenteLoggato.ruolo == 'ADMIN'}">
				    <a href="${pageContext.request.contextPath}/admin.jsp#gestione-prodotti" class="btn-primary nuova-stampa" style="padding: 5px 15px; font-size: 0.9em;">
				        <i class="fa-solid fa-plus"></i> Nuova Stampa
				    </a>
				</c:if>
            </div>
            
            <section class="hero-section">
                <div class="hero-card">
                    <h1>SERVIZIO STAMPA <span>3</span>D</h1>
                    <p>
                        Scegli tra i nostri modelli ottimizzati per la stampa o richiedi un preventivo personalizzato. 
                        Garantiamo altissima risoluzione in Resina 8K e massima resistenza in PLA e PETG.
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
                        <a href="${pageContext.request.contextPath}/Commissioni"> 
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
                                    
                                    <!-- LOGICA WISHLIST -->
                                    <c:set var="inWishlist" value="false" />
                                    <c:forEach var="wId" items="${sessionScope.wishlistIds}">
                                        <c:if test="${wId == prodotto.id}">
                                            <c:set var="inWishlist" value="true" />
                                        </c:if>
                                    </c:forEach>
                                    
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.utenteLoggato}">
                                            <form action="${pageContext.request.contextPath}/AddtoWishlist" method="POST" style="display:inline;">
                                                <input type="hidden" name="id_prodotto" value="${prodotto.id}">
                                                <button type="submit" class="btn-wishlist" title="${inWishlist ? 'Rimuovi dalla Wishlist' : 'Aggiungi alla Wishlist'}">
                                                    <i class="${inWishlist ? 'fa-solid' : 'fa-regular'} fa-heart" style="${inWishlist ? 'color: #e56399;' : ''}"></i>
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn-wishlist" title="Accedi per la Wishlist" onclick="alert('Devi effettuare il login per usare la Wishlist!'); window.location.href='${pageContext.request.contextPath}/Login';">
                                                <i class="fa-regular fa-heart"></i>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                </div>
                                
                                <a href="${pageContext.request.contextPath}/Prodotto?id=${prodotto.id}" class="product-link">
                                    <div class="product-image">
                                        <img src="${pageContext.request.contextPath}/product_images/${prodotto.immagineCopertinaUrl}" 
										     alt="${prodotto.nome}" 
										     style="width: 100%; max-width: 100%; height: auto; aspect-ratio: 1 / 1; border-radius: 8px; object-fit: contain; display: block;" />
                                    </div>
                                    
                                    <div class="product-info-minimal">
                                        <h4 class="product-title">${prodotto.nome}</h4>
                                        <div class="product-price">€ <fmt:formatNumber value="${prodotto.prezzoCorrente}" pattern="#,##0.00"/></div>
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
            
            const pct = ((val - min) / (max - min)) * 100;

            if (priceDisplay) {
                priceDisplay.innerText = val + '€';
            }

            slider.style.setProperty('--slider-pct', pct + '%');
        }

        if (slider) {
            slider.addEventListener('input', updateSlider);
            slider.addEventListener('change', updateSlider);
            updateSlider();
        }
    });
</script>

<%@ include file="fragment/footer.jspf" %>