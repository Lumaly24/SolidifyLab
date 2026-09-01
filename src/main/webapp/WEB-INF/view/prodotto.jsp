<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<% request.setAttribute("titoloPagina", "Dettaglio Prodotto"); %>
<%@ include file="fragment/header.jspf" %>

    <main class="product-page-container">
        
        <div class="product-top-nav">
            <a href="javascript:history.back()" class="btn-back">
                <i class="fa-solid fa-chevron-left"></i> BACK
            </a>
            <nav class="breadcrumbs" aria-label="Percorso di navigazione">
                <a href="${pageContext.request.contextPath}/CatalogoServlet">Libreria</a> 
                <span class="separator">/</span> 
                <a href="${pageContext.request.contextPath}/CatalogoServlet?categoria=${prodotto.categoria}">${prodotto.categoria}</a> 
                <span class="separator">/</span> 
                <span class="current-page">${prodotto.nome}</span>
            </nav>
        </div>

            
            <!-- ================= COLONNA SINISTRA (Immagine e Carrello) ================= -->
            <aside class="product-gallery-side">
                
                <div class="main-product-image">
                    <span class="img-placeholder">(IMG ${prodotto.nome})</span>
                    <c:if test="${prodotto.categoria == 'MODELLO_3D'}">
                        <div class="icon-360" title="Visualizza modello a 360 gradi">
                            <i class="fa-solid fa-arrows-rotate"></i> <span>360°</span>
                        </div>
                    </c:if>
                </div>

                <c:if test="${prodotto.categoria == 'MODELLO_3D'}">
                    <div class="polycount-indicator">
                        <p><strong>Livello di Dettaglio:</strong></p>
                        <div class="poly-steps">
                            <div class="step"><span class="dot"></span><label>Low</label></div>
                            <div class="step"><span class="dot"></span><label>Mid</label></div>
                            <div class="step active"><span class="dot filled"></span><label>High</label></div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${prodotto.categoria == 'TEXTURE'}">
                    <div class="resolution-indicator">
                        <p><strong>Risoluzione disponibile:</strong></p>
                        <div class="resolution-steps">
                            <span class="res-badge">2K</span>
                            <span class="res-badge active">4K</span>
                            <span class="res-badge">8K</span>
                        </div>
                    </div>
                </c:if>

                <!-- FORM AGGIUNTA AL CARRELLO -->
                <form class="add-to-cart-form" action="${pageContext.request.contextPath}/AggiungiAlCarrelloServlet" method="POST">
                    
                    <input type="hidden" name="id_prodotto" value="${prodotto.id}">

                    <c:if test="${prodotto.categoria == 'STAMPA_3D'}">
                        <div class="material-selector">
                            <p><strong>Seleziona Materiale:</strong></p>
                            <div class="material-options">
                                <label class="mat-radio">
                                    <input type="radio" name="materiale" value="resina_grigia" checked>
                                    <span>Resina Grigia (Alto Dettaglio)</span>
                                </label>
                                <label class="mat-radio">
                                    <input type="radio" name="materiale" value="pla_nero">
                                    <span>PLA Nero (Resistente)</span>
                                </label>
                            </div>
                        </div>
                    </c:if>

                    <div class="product-purchase-action">
                        <button type="submit" class="btn-primary btn-add-cart-large">
                            <i class="fa-solid fa-cart-plus"></i> AGGIUNGI AL CARRELLO - € <fmt:formatNumber value="${prodotto.prezzo}" pattern="#,##0.00"/>
                        </button>
                    </div>
                </form>

                <div class="product-meta">
                    <p><strong>Licenza:</strong> Royalty Free (Standard)</p>
                </div>
            </aside>

            <!-- ================= COLONNA DESTRA (Info e Specifiche) ================= -->
            <section class="product-info-side">
                
                <header class="product-info-header">
                    <h1 class="product-title">${prodotto.nome}</h1>
                    
                    <!-- Contenitore per raggruppare i bottoni di azione (Modifica e Wishlist) -->
                    <div class="header-actions">
                        
                        <!-- AGGIUNTA ADMIN: Tasto Modifica (Visibile solo all'admin) -->
                        <c:if test="${not empty sessionScope.utenteLoggato and sessionScope.utenteLoggato.admin}">
                            <a href="${pageContext.request.contextPath}/EditProductServlet?id=${prodotto.id}" class="btn-icon admin-edit-btn" title="Modifica Prodotto">
                                <i class="fa-solid fa-pen"></i>
                            </a>
                        </c:if>

                        <!-- FORM AGGIUNTA WISHLIST -->
                        <form class="wishlist-form-inline" action="${pageContext.request.contextPath}/AggiungiWishlistServlet" method="POST">
                            <input type="hidden" name="id_prodotto" value="${prodotto.id}">
                            <button type="submit" class="btn-wishlist-large" title="Aggiungi alla Wishlist">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </form>
                        
                    </div>
                </header>

                <div class="product-description">
                    <p>${prodotto.descrizione}</p>
                </div>

                <c:if test="${prodotto.categoria == 'MODELLO_3D'}">
                    <div class="product-specs-box">
                        <h3>Specifiche Modello 3D</h3>
                        <hr class="box-divider">
                        <div class="specs-grid">
                            <ul class="specs-list">
                                <li><strong>Geometria:</strong> Polygon mesh</li>
                                <li><strong>Textures:</strong> Sì (4K PBR)</li>
                            </ul>
                        </div>
                    </div>
                    <div class="product-formats-box">
                        <h3>Formati Compatibili</h3>
                        <hr class="box-divider">
                        <div class="formats-layout">
                            <ul class="formats-list">
                                <li>.BLEND</li>
                                <li>.FBX</li>
                                <li>.OBJ</li>
                            </ul>
                            <div class="software-icons-grid">
                                <div class="soft-box" title="Blender"><i class="fa-solid fa-cube"></i></div>
                                <div class="soft-box" title="Unreal Engine"><i class="fa-brands fa-gamepad"></i></div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${prodotto.categoria == 'TEXTURE'}">
                    <div class="product-specs-box">
                        <h3>Specifiche Texture</h3>
                        <hr class="box-divider">
                        <div class="specs-grid">
                            <ul class="specs-list">
                                <li><strong>Seamless:</strong> Sì</li>
                                <li><strong>Workflow:</strong> PBR Metallic/Roughness</li>
                            </ul>
                            <ul class="specs-list">
                                <li><strong>Mappe incluse:</strong> Albedo, Normal, Roughness, AO</li>
                                <li><strong>Formato File:</strong> .PNG</li>
                            </ul>
                        </div>
                    </div>
                </c:if>

                <c:if test="${prodotto.categoria == 'STAMPA_3D'}">
                    <div class="product-shipping-box">
                        <h3>Dettagli di Stampa e Spedizione</h3>
                        <hr class="box-divider">
                        <div class="shipping-info-layout">
                            <ul class="specs-list">
                                <li><strong>Infill (Riempimento):</strong> 100% (Solido)</li>
                                <li><strong>Lavorazione:</strong> 3-5 giorni lavorativi</li>
                            </ul>
                            <div class="shipping-icon-box">
                                <i class="fa-solid fa-box-open"></i>
                                <p>Spedizione Tracciata Inclusa</p>
                            </div>
                        </div>
                    </div>
                </c:if>

            </section>
        </div>
    </main>

<%@ include file="fragment/footer.jspf" %>
