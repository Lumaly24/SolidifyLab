<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<% request.setAttribute("titoloPagina", "La mia Wishlist"); %>
<%@ include file="fragment/header.jspf" %>

<main class="wishlist-page-container">
    
    <div class="wishlist-header">
        <h1>La mia Wishlist <i class="fa-solid fa-heart"></i></h1>
    </div>

    <div class="catalog-layout">
        
        <!-- ================= SIDEBAR ================= -->
        <aside class="catalog-sidebar">
            
            <div class="filter-group">
                <h3>Le mie Raccolte</h3>
                <ul class="collections-list">
                    <li><a href="#" class="active"><i class="fa-solid fa-border-all"></i> Tutti i salvataggi</a></li>
                    <li><a href="#"><i class="fa-regular fa-folder"></i> Progetto Sci-Fi</a></li>
                    <li><a href="#"><i class="fa-regular fa-folder"></i> Personaggi Fantasy</a></li>
                </ul>
                <button type="button" class="btn-outline-small w-100 mt-2" onclick="prompt('Nome nuova raccolta:');">
                    <i class="fa-solid fa-plus"></i> Crea Raccolta
                </button>
            </div>

            <hr class="sidebar-divider">

            <div class="filter-group">
                <h3>Filtra per Categoria</h3>
                <form action="${pageContext.request.contextPath}/WishlistServlet" method="GET">
                    <ul class="filter-list">
                        <li><label><input type="checkbox" name="cat" value="MODELLO_3D"> Modelli 3D</label></li>
                        <li><label><input type="checkbox" name="cat" value="TEXTURE"> Textures</label></li>
                        <li><label><input type="checkbox" name="cat" value="STAMPA_3D"> Stampe 3D</label></li>
                    </ul>
                    <button type="submit" class="btn-primary w-100 mt-2">Filtra</button>
                </form>
            </div>
            
        </aside>

        <!-- ================= MAIN CONTENT ================= -->
        <section class="catalog-main-content">
            <div class="collection-title">
                <h2>Tutti i salvataggi</h2>
                <!-- Conteggio dinamico degli elementi -->
                <p>Hai ${fn:length(listaWishlist)} elementi salvati in questa vista.</p>
            </div>

            <div class="catalog-products-grid">
                
                <c:choose>
                    <c:when test="${empty listaWishlist}">
                        <div class="empty-msg text-center w-100 mt-4">
                            <i class="fa-regular fa-heart" style="font-size: 3em; color: #ccc;"></i>
                            <h3>La tua wishlist è vuota.</h3>
                            <p>Esplora il catalogo e salva qui i tuoi progetti preferiti!</p>
                            <a href="${pageContext.request.contextPath}/CatalogoServlet" class="btn-primary mt-3">Vai al Catalogo</a>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <c:forEach var="item" items="${listaWishlist}">
                            <article class="product-card">
                                
                                <div class="product-badges">
                                    <div class="move-collection-dropdown">
                                        <button type="button" class="btn-icon" title="Sposta in una raccolta"><i class="fa-solid fa-folder-plus"></i></button>
                                    </div>
                                    
                                    <!-- FORM RIMOZIONE (Con avviso CHECKLIST) -->
                                    <form action="${pageContext.request.contextPath}/RemoveWishlistServlet" method="POST" class="inline-form">
                                        <input type="hidden" name="id_prodotto" value="${item.prodotto.id}">
                                        <button type="submit" class="btn-wishlist text-red" title="Rimuovi" onclick="return confirm('Vuoi davvero rimuovere questo prodotto dalla tua wishlist?');">
                                            <i class="fa-solid fa-trash-can"></i>
                                        </button>
                                    </form>
                                </div>
                                
                                <a href="${pageContext.request.contextPath}/DettaglioProdottoServlet?id=${item.prodotto.id}" class="product-link">
                                    <div class="product-image">
                                        <span>(IMG ${item.prodotto.nome})</span>
                                    </div>
                                    <div class="product-info-minimal">
                                        <h4 class="product-title">${item.prodotto.nome}</h4>
                                        <div class="product-price">€ <fmt:formatNumber value="${item.prodotto.prezzo}" pattern="#,##0.00"/></div>
                                    </div>
                                </a>
                                
                                <!-- FORM AGGIUNTA AL CARRELLO DALLA WISHLIST -->
                                <form action="${pageContext.request.contextPath}/AggiungiAlCarrelloServlet" method="POST">
                                    <input type="hidden" name="id_prodotto" value="${item.prodotto.id}">
                                    <input type="hidden" name="quantita" value="1">
                                    <button type="submit" class="btn-primary w-100 btn-bottom-rounded">
                                        <i class="fa-solid fa-cart-plus"></i> AL CARRELLO
                                    </button>
                                </form>
                                
                            </article>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                
            </div>
        </section>
        
    </div>
</main>

<%@ include file="fragment/footer.jspf" %>