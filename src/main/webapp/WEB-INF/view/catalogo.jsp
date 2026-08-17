<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("titoloPagina", "Catalogo"); %>
<%@ include file="fragment/header.jspf" %>

	<main class="catalog-page">
        
        <div class="catalog-tabs-container">
            <div class="catalog-tabs">
                <a href="${pageContext.request.contextPath}/catalogo" class="tab-btn active">3D MODELS</a>
                <a href="${pageContext.request.contextPath}/catalogo" class="tab-btn">TEXTURES</a>
            </div>
        </div>
        <div class="catalog-layout">
            <aside class="catalog-sidebar">
                <div class="filter-group">
                    <h3>Filtro Prezzi</h3>
                    <div class="price-slider">
                        <input type="range" id="priceRange" name="price" min="0" max="200" step="5" value="100">
                        <div class="price-labels">
                            <span>0€</span>
                            <span>Max €€</span>
                        </div>
                    </div>
                </div>

                <hr class="sidebar-divider">
                <div class="filter-group">
                    <h3>Categorie</h3>
                    <ul class="filter-list"> <!--placeholder perché non so come farla benissimo-->
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

            </aside>
            <section class="catalog-main-content">
                <nav class="breadcrumbs" aria-label="Percorso di navigazione">
                    <a href="${pageContext.request.contextPath}/catalogo">Libreria Modelli 3D</a> 
                    <span class="separator">/</span> 
                    <a href="#">Personaggi</a> 
                    <span class="separator">/</span> 
                    <span class="current-page">Fantasy</span>
                </nav>
                <div class="catalog-products-grid">
                    
                    <article class="product-card">
                        <div class="product-badges">
                            <span class="badge-new">New</span>
                            <button type="button" class="btn-wishlist" title="Wishlist-add">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </div>
                        
                        <a href="${pageContext.request.contextPath}/prodotto" class="product-link">
                            <div class="product-image">
                                <span>(IMG 1)</span>
                            </div>
                            <div class="product-info-minimal">
                                <h4 class="product-title">Guerriero Fantasy</h4>
                                <div class="product-price">€ 15,00</div>
                            </div>
                        </a>
                    </article>
                    
                    <article class="product-card">
                        <div class="product-badges">
                            <button type="button" class="btn-wishlist" title="Wishlist-add">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </div>
                        <a href="${pageContext.request.contextPath}/prodotto" class="product-link">
                            <div class="product-image">
                                <span>(IMG 2)</span>
                            </div>
                            <div class="product-info-minimal">
                                <h4 class="product-title">Pack Textures Metallo</h4>
                                <div class="product-price">€ 22,50</div>
                            </div>
                        </a>
                    </article>
                    
                    <article class="product-card">
                        <div class="product-badges">
                            <span class="badge-new">New</span>
                            <button type="button" class="btn-wishlist" title="Wishlist-add">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </div>
                        <a href="${pageContext.request.contextPath}/prodotto" class="product-link">
                            <div class="product-image">
                                <span>(IMG 3)</span>
                            </div>
                            <div class="product-info-minimal">
                                <h4 class="product-title">Spada Medievale</h4>
                                <div class="product-price">€ 9,90</div>
                            </div>
                        </a>
                    </article>
                    
                    <article class="product-card">
                        <div class="product-badges">
                            <button type="button" class="btn-wishlist" title="Wishlist-add">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </div>
                        <a href="${pageContext.request.contextPath}/prodotto" class="product-link">
                            <div class="product-image">
                                <span>(IMG 4)</span>
                            </div>
                            <div class="product-info-minimal">
                                <h4 class="product-title">Stanza Sci-Fi Modulare</h4>
                                <div class="product-price">€ 35,00</div>
                            </div>
                        </a>
                    </article>

                </div>
            </section>
            
        </div>
    </main>

<%@ include file="fragment/footer.jspf" %>
