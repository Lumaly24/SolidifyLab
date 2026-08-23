<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% request.setAttribute("titoloPagina", "Stampe 3D"); %>
<%@ include file="fragment/header.jspf" %>

    <main class="catalog-page">
        
        <!-- HERO DEDICATA ALLE STAMPE -->
        <section class="hero-section" style="padding: 3rem 1rem; background: #f4f4f4;">
            <div class="hero-content">
                <h1>SERVIZIO STAMPA 3D</h1>
                <p style="max-width: 600px; margin: 0 auto 20px auto; color: #555;">
                    Scegli tra i nostri modelli ottimizzati per la stampa o richiedi un preventivo personalizzato. 
                    Garantiamo altissima risoluzione in Resina 8K e massima resistenza in PLA.
                </p>
                <div class="hero-buttons">
                    <a href="${pageContext.request.contextPath}/commissioni.jsp" class="btn" style="background: #333; color: white;"> 
                        <i class="fa-solid fa-wand-magic-sparkles"></i> STAMPA UN TUO FILE 
                    </a> 
                </div>
            </div>
        </section>
        
        <div class="catalog-layout">
            
            <!-- SIDEBAR FILTRI (Semplificata solo per le stampe) -->
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
                            <input type="range" id="priceRange" name="max_price" min="0" max="300" step="10" value="${not empty param.max_price ? param.max_price : 150}" oninput="document.getElementById('priceVal').innerText = this.value + '€'">
                            <div class="price-labels">
                                <span>0€</span>
                                <span>Fino a: <b id="priceVal">${not empty param.max_price ? param.max_price : 150}€</b></span>
                            </div>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn-primary w-100 mt-3">Applica Filtri</button>
                </form>
            </aside>

            <!-- MAIN CONTENT: Griglia Modelli Stampabili -->
            <section class="catalog-main-content">
                
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <nav class="breadcrumbs" aria-label="Percorso di navigazione">
                        <a href="${pageContext.request.contextPath}/index.jsp">Home</a> 
                        <span class="separator">/</span> 
                        <span class="current-page">Modelli Stampabili</span>
                    </nav>

                    <!-- Bottone Admin -->
                    <c:if test="${not empty sessionScope.utenteLoggato and sessionScope.utenteLoggato.admin}">
                        <a href="${pageContext.request.contextPath}/admin.jsp#gestione-prodotti" class="btn-primary" style="padding: 5px 15px; font-size: 0.9em;">
                            <i class="fa-solid fa-plus"></i> Nuova Stampa
                        </a>
                    </c:if>
                </div>
                
                <div class="catalog-products-grid">
                    
                    <!-- Il backend dovrà passare una listaProdotti filtrata solo con categoria STAMPA_3D -->
                    <c:choose>
                        <c:when test="${empty listaStampe}">
                            <p>Nessun modello stampabile trovato.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="prodotto" items="${listaStampe}">
                                <article class="product-card">
                                    <div class="product-badges">
                                        <!-- Tasto Wishlist -->
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
    
 <%@ include file="fragment/footer.jspf" %>
