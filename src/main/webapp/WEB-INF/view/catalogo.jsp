<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<% request.setAttribute("titoloPagina", "Catalogo"); %>
<%@ include file="fragment/header.jspf" %>

    <main class="catalog-page">
        
        <div class="catalog-tabs-container">
            <div class="catalog-tabs">
                <a href="${pageContext.request.contextPath}/CatalogoServlet?tipo=3D" class="tab-btn active">3D MODELS</a>
                <a href="${pageContext.request.contextPath}/CatalogoServlet?tipo=TEXTURES" class="tab-btn">TEXTURES</a>
            </div>
        </div>
        
        <div class="catalog-layout">
            
            <!-- ================= SIDEBAR FILTRI ================= -->
            <aside class="catalog-sidebar">
                <!-- Avvolgiamo i filtri in un form GET -->
                <form action="${pageContext.request.contextPath}/CatalogoServlet" method="GET">
                    
                    <div class="filter-group">
                        <h3>Filtro Prezzi</h3>
                        <div class="price-slider">
                            <input type="range" id="priceRange" name="max_price" min="0" max="200" step="5" value="${not empty param.max_price ? param.max_price : 100}" oninput="document.getElementById('priceVal').innerText = this.value + '€'">
                            <div class="price-labels">
                                <span>0€</span>
                                <span>Fino a: <b id="priceVal">${not empty param.max_price ? param.max_price : 100}€</b></span>
                            </div>
                        </div>
                    </div>

                    <hr class="sidebar-divider">
                    
                   <div class="filter-group">
                        <h3>Categorie</h3>
                        <ul class="filter-list">
                            <li>
                                <details open>
                                    <summary>Personaggi <i class="fa-solid fa-angle-down"></i></summary>
                                    <ul class="sub-filter-list">
                                        <li><label><input type="checkbox" name="subcat" value="fantasy"> Fantasy</label></li>
                                        <li><label><input type="checkbox" name="subcat" value="scifi"> Sci-Fi</label></li>
                                        <li><label><input type="checkbox" name="subcat" value="realistici"> Realistici</label></li>
                                    </ul>
                                </details>
                            </li>
                            <li><label><input type="checkbox" name="cat" value="ambienti"> Ambienti</label></li>
                            <li><label><input type="checkbox" name="cat" value="veicoli"> Veicoli</label></li>
                            <li><label><input type="checkbox" name="cat" value="oggetti"> Oggetti / Props</label></li>
                        </ul>
                    </div>

                    <!-- NUOVO: Call to action per mandare l'utente alla pagina delle stampe -->
                    <div class="physical-promo mt-4" style="background: #f1f8ff; border-left: 4px solid #0056b3; padding: 15px; border-radius: 4px;">
                        <h4 style="margin-top: 0; color: #0056b3;">Vuoi un oggetto fisico?</h4>
                        <p style="font-size: 0.9em; margin-bottom: 10px;">Scopri i nostri modelli già pronti per essere stampati e spediti a casa tua.</p>
                        <a href="${pageContext.request.contextPath}/stampe.jsp" class="btn-outline-small w-100 text-center" style="display: block;">Vai alle Stampe 3D</a>
                    </div>
                    
                    <button type="submit" class="btn-primary w-100 mt-3">Applica Filtri</button>
                </form>
            </aside>

            <!-- ================= MAIN CONTENT ================= -->
            <section class="catalog-main-content">
                
                <!-- REQUISITO CHECKLIST: Barra di ricerca AJAX -->
                <div class="ajax-search-container" style="margin-bottom: 20px; position: relative;">
                    <div class="search-input-wrapper" style="display: flex; gap: 10px;">
                        <input type="text" id="ajaxSearchBar" placeholder="Cerca un modello 3D o una texture..." style="flex: 1; padding: 10px; border: 1px solid #ccc; border-radius: 4px;" autocomplete="off">
                        <button type="button" class="btn-primary"><i class="fa-solid fa-search"></i></button>
                    </div>
                    <!-- Qui appariranno i suggerimenti via JS -->
                    <div id="searchSuggestions" style="display: none; position: absolute; top: 100%; left: 0; right: 0; background: white; border: 1px solid #ddd; z-index: 10; max-height: 200px; overflow-y: auto; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                        <!-- Riempito dinamicamente da JS -->
                    </div>
                </div>

                <!-- Modifica Header Catalogo: Flexbox per mettere il bottone Admin a destra -->
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                    <nav class="breadcrumbs" aria-label="Percorso di navigazione">
                        <a href="${pageContext.request.contextPath}/CatalogoServlet">Libreria Modelli 3D</a> 
                        <span class="separator">/</span> 
                        <span class="current-page">Tutti i prodotti</span>
                    </nav>

                    <!-- AGGIUNTA ADMIN: Bottone "Nuovo Prodotto" -->
                    <c:if test="${not empty sessionScope.utenteLoggato and sessionScope.utenteLoggato.ruolo == 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/admin.jsp#gestione-prodotti" class="btn-primary" style="padding: 5px 15px; font-size: 0.9em;">
                            <i class="fa-solid fa-plus"></i> Nuovo Prodotto
                        </a>
                    </c:if>
                </div>
                
                <div class="catalog-products-grid">
                    
                    <!-- CICLO JSP: Mostriamo i prodotti dal Database -->
                    <c:choose>
                        <c:when test="${empty listaProdotti}">
                            <p>Nessun prodotto trovato per questa ricerca.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="prodotto" items="${listaProdotti}">
                                <article class="product-card">
                                    <div class="product-badges">
                                        
                                        <!-- Tasto Wishlist -->
                                        <form action="${pageContext.request.contextPath}/AggiungiWishlistServlet" method="POST" style="display:inline;">
                                            <input type="hidden" name="id_prodotto" value="${prodotto.id}">
                                            <button type="submit" class="btn-wishlist" title="Aggiungi alla Wishlist">
                                                <i class="fa-regular fa-heart"></i>
                                            </button>
                                        </form>

                                        <!-- AGGIUNTA ADMIN: Tasto Cestino per eliminare il prodotto -->
                                        <c:if test="${not empty sessionScope.utenteLoggato and sessionScope.utenteLoggato.admin}">
                                            <form action="${pageContext.request.contextPath}/DeleteProductServlet" method="POST" style="display:inline; margin-left: 10px;">
                                                <input type="hidden" name="id" value="${prodotto.id}">
                                                <button type="submit" class="btn-wishlist" style="color: #dc3545;" title="Elimina dal DB" onclick="return confirm('ATTENZIONE: Sei sicuro di voler eliminare definitivamente questo prodotto dal catalogo?');">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </button>
                                            </form>
                                        </c:if>

                                    </div>
                                    
                                    <!-- Link al Dettaglio (Requisito Checklist) -->
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

    <!-- REQUISITO CHECKLIST: FETCH API con JSON -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('ajaxSearchBar');
            const suggestionsBox = document.getElementById('searchSuggestions');

            searchInput.addEventListener('keyup', function() {
                let query = this.value.trim();
                
                if(query.length >= 2) {
                    // Chiamata asincrona alla Servlet
                    fetch('${pageContext.request.contextPath}/RicercaAjaxServlet?q=' + encodeURIComponent(query))
                        .then(response => response.json()) // Decodifica il JSON (Requisito prof)
                        .then(data => {
                            suggestionsBox.innerHTML = ''; // Pulisce vecchi risultati
                            
                            if(data.length > 0) {
                                data.forEach(item => {
                                    let div = document.createElement('div');
                                    div.style.padding = '10px';
                                    div.style.borderBottom = '1px solid #eee';
                                    div.style.cursor = 'pointer';
                                    // Mostra nome e prezzo suggerito
                                    div.innerHTML = `<strong>\${item.nome}</strong> - €\${item.prezzo}`;
                                    
                                    // Al click, vai alla pagina del prodotto
                                    div.onclick = function() {
                                        window.location.href = '${pageContext.request.contextPath}/DettaglioProdottoServlet?id=' + item.id;
                                    };
                                    
                                    // Hover effect
                                    div.onmouseover = function() { this.style.backgroundColor = '#f1f8ff'; };
                                    div.onmouseout = function() { this.style.backgroundColor = 'transparent'; };
                                    
                                    suggestionsBox.appendChild(div);
                                });
                                suggestionsBox.style.display = 'block';
                            } else {
                                suggestionsBox.innerHTML = '<div style="padding:10px; color:#888;">Nessun risultato...</div>';
                                suggestionsBox.style.display = 'block';
                            }
                        })
                        .catch(error => console.error('Errore Fetch AJAX:', error));
                } else {
                    suggestionsBox.style.display = 'none';
                }
            });

            // Chiudi tendina se clicchi fuori
            document.addEventListener('click', function(e) {
                if(!searchInput.contains(e.target) && !suggestionsBox.contains(e.target)) {
                    suggestionsBox.style.display = 'none';
                }
            });
        });
    </script>

<%@ include file="fragment/footer.jspf" %>