<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<% request.setAttribute("titoloPagina", "Dettaglio Prodotto"); 
	request.setAttribute("cssPagina", "prodotto.css");
%>

<%@ include file="/WEB-INF/view/fragment/header.jspf" %>

    <main class="product-page-container">
        
        <div class="product-top-nav">
            <a href="javascript:history.back()" class="btn-back">
                <i class="fa-solid fa-chevron-left"></i> BACK
            </a>
            <nav class="breadcrumbs" aria-label="Percorso di navigazione">
                <a href="${pageContext.request.contextPath}/Catalogo">Catalogo</a> 
                <span class="separator">/</span> 
                <a href="${pageContext.request.contextPath}/Catalogo?categoria=${catNome}">${catNome}</a> 
                <span class="separator">/</span> 
                <span class="current-page">${prodotto.nome}</span>
            </nav>
        </div>

        <div class="product-layout">
            
            <aside class="product-gallery-side">
                
                <c:set var="isDigitale" value="${not empty prodotto.formatoFile}"/>
                <c:set var="giaPosseduto" value="${not empty sessionScope.utenteLoggato and isDigitale and not empty sessionScope.idAssetPosseduti and sessionScope.idAssetPosseduti.contains(prodotto.id)}" />
                
                <c:set var="tagsStr" value="${fn:toLowerCase(prodotto.tagsUniti)}" />
                
                <div class="main-product-image" style="position: relative;">
                
                    <c:if test="${giaPosseduto}">
                        <img src="${pageContext.request.contextPath}/images/badge-gia-acquistato.png" 
                             alt="Già Acquistato" 
                             style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; z-index: 10; pointer-events: none;">
                    </c:if>
                
                    <img src="${pageContext.request.contextPath}/product_images/${prodotto.immagineCopertinaUrl}" alt="${prodotto.nome}" 
					     style="width: 100%; border-radius: 8px; object-fit: cover;" />
                    
                </div>

                <c:if test="${catCodice == 'MODELLO_3D'}">
                    <c:set var="isLow" value="${fn:contains(tagsStr, 'low_poly')}" />
                    <c:set var="isHigh" value="${fn:contains(tagsStr, 'high_poly')}" />
                    
                    <div class="polycount-indicator">
                        <p><strong>Livello di Dettaglio:</strong></p>
                        <div class="poly-steps">
                            <div class="step ${isLow ? 'active' : ''}">
                                <span class="dot ${isLow ? 'filled' : ''}"></span>
                                <label>Low</label>
                            </div>
                            <div class="step ${isHigh ? 'active' : ''}">
                                <span class="dot ${isHigh ? 'filled' : ''}"></span>
                                <label>High</label>
                            </div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${catCodice == 'TEXTURE'}">
                    <div class="resolution-indicator">
                        <p><strong>Risoluzione disponibile:</strong></p>
                        <div class="resolution-steps">
                            <span class="res-badge ${fn:contains(tagsStr, '1k') ? 'active' : ''}">1K</span>
                            <span class="res-badge ${fn:contains(tagsStr, '2k') ? 'active' : ''}">2K</span>
                            <span class="res-badge ${fn:contains(tagsStr, '3k') ? 'active' : ''}">3K</span>
                            <span class="res-badge ${fn:contains(tagsStr, '4k') ? 'active' : ''}">4K</span>
                        </div>
                    </div>
                </c:if>

                <div class="product-meta">
                    <p><strong>Licenza:</strong> Royalty Free (Standard)</p>
                </div>
            </aside>

            <section class="product-info-side">
                
                <header class="product-info-header">
                    <h1 class="product-title">${prodotto.nome}</h1>
                    
                    <div class="header-actions">
                        
                        <c:if test="${not empty sessionScope.utenteLoggato and sessionScope.utenteLoggato.ruolo == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/AdminDashboard?edit=${prodotto.id}#gestione-prodotti" class="btn-icon admin-edit-btn" title="Modifica Prodotto">
                                <i class="fa-solid fa-pen"></i>
                            </a>
                        </c:if>

                        <c:set var="isFavorito" value="false" />
                        <c:if test="${not empty sessionScope.wishlistIds}">
                            <c:forEach var="wId" items="${sessionScope.wishlistIds}">
                                <c:if test="${wId == prodotto.id}">
                                    <c:set var="isFavorito" value="true" />
                                </c:if>
                            </c:forEach>
                        </c:if>

                        <form class="wishlist-form-inline" action="${pageContext.request.contextPath}/AddtoWishlist" method="POST">
                            <input type="hidden" name="id_prodotto" value="${prodotto.id}">
                            <button type="submit" class="btn-wishlist-large" title="${isFavorito ? 'Rimuovi dalla Wishlist' : 'Aggiungi alla Wishlist'}">
                                <c:choose>
                                    <c:when test="${isFavorito}">
                                        <i class="fa-solid fa-heart" style="color: #e56399;"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fa-regular fa-heart"></i>
                                    </c:otherwise>
                                </c:choose>
                            </button>
                        </form>
                        
                    </div>
                </header>

                <div class="product-description">
                    <p>${prodotto.descrizione}</p>
                </div>

                <c:if test="${catCodice == 'MODELLO_3D'}">
                    <div class="product-specs-box">
                        <h3>Specifiche Modello 3D</h3>
                        <hr class="box-divider">
                        <div class="specs-grid">
                            <ul class="specs-list">
                                <li><strong>Geometria:</strong> Polygon mesh</li>
                                <c:if test="${fn:contains(tagsStr, 'ambienti')}"><li><strong>Categoria:</strong> Ambienti</li></c:if>
                                <c:if test="${fn:contains(tagsStr, 'creature')}"><li><strong>Categoria:</strong> Creature</li></c:if>
                                <c:if test="${fn:contains(tagsStr, 'personaggi')}"><li><strong>Categoria:</strong> Personaggi</li></c:if>
                                <c:if test="${fn:contains(tagsStr, 'props')}"><li><strong>Categoria:</strong> Props</li></c:if>
                                
                                <c:if test="${fn:contains(tagsStr, 'rigged')}">
                                    <li><strong>Rigging:</strong> Modello Rigged (Pronto per l'animazione)</li>
                                </c:if>
                                <c:if test="${fn:contains(tagsStr, 'game_ready')}">
                                    <li><strong>Ottimizzazione:</strong> Game Ready</li>
                                </c:if>
                                <c:if test="${fn:contains(tagsStr, 'realistico')}">
                                    <li><strong>Stile:</strong> Realistico</li>
                                </c:if>
                                <c:if test="${fn:contains(tagsStr, 'fantasy')}">
                                    <li><strong>Stile:</strong> Fantasy</li>
                                </c:if>
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
                        </div>
                    </div>
                </c:if>

                <c:if test="${catCodice == 'TEXTURE'}">
                    <div class="product-specs-box">
                        <h3>Specifiche Texture</h3>
                        <hr class="box-divider">
                        <div class="specs-grid">
                            <ul class="specs-list">
                                <li><strong>Seamless:</strong> ${fn:contains(tagsStr, 'seamless') ? 'Sì' : 'No'}</li>
                                <c:if test="${fn:contains(tagsStr, 'architettura')}"><li><strong>Categoria:</strong> Architettura</li></c:if>
                                <c:if test="${fn:contains(tagsStr, 'metalli')}"><li><strong>Categoria:</strong> Metalli</li></c:if>
                                <c:if test="${fn:contains(tagsStr, 'tessuti')}"><li><strong>Categoria:</strong> Tessuti</li></c:if>
                                <c:if test="${fn:contains(tagsStr, 'organiche')}"><li><strong>Categoria:</strong> Organiche</li></c:if>
                            </ul>
                            <ul class="specs-list">
                                <li><strong>Workflow:</strong> PBR Metallic/Roughness</li>
                                <li><strong>Mappe incluse:</strong> Albedo, Normal, Roughness, AO</li>
                                <li><strong>Formato File:</strong> .PNG</li>
                            </ul>
                        </div>
                    </div>
                </c:if>

                <c:if test="${catCodice == 'STAMPA_3D'}">
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
                    
                    <div class="product-specs-box" style="margin-top: 12px;">
                        <h3>Specifiche Tecniche</h3>
                        <hr class="box-divider">
                        <div class="specs-grid">
                            <ul class="specs-list">
                                <li><strong>Materiale:</strong> 
                                    <c:choose>
                                        <c:when test="${fn:contains(tagsStr, 'resina')}">Resina 8K (Alto Dettaglio)</c:when>
                                        <c:when test="${fn:contains(tagsStr, 'pla')}">PLA (Resistente)</c:when>
                                        <c:when test="${fn:contains(tagsStr, 'petg')}">PETG (Flessibile/Resistente)</c:when>
                                        <c:otherwise>Standard</c:otherwise>
                                    </c:choose>
                                </li>
                                <li><strong>Tipologia:</strong> 
                                    <c:choose>
                                        <c:when test="${fn:contains(tagsStr, 'miniature')}">Miniatura</c:when>
                                        <c:when test="${fn:contains(tagsStr, 'props')}">Prop / Replica</c:when>
                                        <c:when test="${fn:contains(tagsStr, 'accessori')}">Accessorio</c:when>
                                        <c:otherwise>Oggetto Stampato</c:otherwise>
                                    </c:choose>
                                </li>
                            </ul>
                            <ul class="specs-list">
                                <li><strong>Finitura:</strong> 
                                    <c:choose>
                                        <c:when test="${fn:contains(tagsStr, 'colore')}">Dipinta</c:when>
                                        <c:when test="${fn:contains(tagsStr, 'levigatura_primer')}">Levigata + Primer Base</c:when>
                                        <c:when test="${fn:contains(tagsStr, 'supporti_rimossi')}">Grezza (Supporti rimossi)</c:when>
                                        <c:otherwise>Standard</c:otherwise>
                                    </c:choose>
                                </li>
                            </ul>
                        </div>
                    </div>
                </c:if>
                
                <c:choose>
                    <c:when test="${giaPosseduto}">
                        <div class="add-to-cart-form" style="margin-top: 25px;">
                            <p style="font-family: 'coolveticarg', sans-serif; color: #eff1ed; margin-bottom: 10px; text-shadow: 2px 2px 4px #0f0326; ">Hai già acquistato questo asset. È pronto per il download!</p>
                            <a href="${pageContext.request.contextPath}/UserDashboard#libreria" class="btn-primary btn-add-cart-large" style="text-decoration: none; box-sizing: border-box;">
                                <i class="fa-solid fa-cloud-arrow-down"></i> VAI ALLA LIBRERIA
                            </a>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <form class="add-to-cart-form" action="${pageContext.request.contextPath}/AddtoCart" method="POST">
                            <input type="hidden" name="id_prodotto" value="${prodotto.id}">
                        
                            <c:if test="${catCodice == 'STAMPA_3D'}">
                                <div class="quantity-selector-large" style="display: flex; align-items: center; gap: 15px; margin-bottom: 20px;">
                                    <p style="margin: 0;"><strong>Quantità:</strong></p>
                                    <div class="quantity-control" style="display: flex; align-items: center; background: rgba(255,255,255,0.4); border: 1px solid rgba(229, 99, 153, 0.3); border-radius: 8px; width: 120px; padding: 5px;">
                                        <button type="button" class="qty-btn" onclick="updateQty(this, -1)" style="border:none; background:none; color:#e56399; font-size:1.2rem; cursor:pointer; width: 30px;">-</button>
                                        <input type="number" name="quantita" value="1" min="1" max="99" readonly class="qty-input" style="width: 100%; border:none; background:transparent; text-align:center; font-family:'coolveticarg', sans-serif; font-size:1.1rem; color:#0f0326; pointer-events:none;">
                                        <button type="button" class="qty-btn" onclick="updateQty(this, 1)" style="border:none; background:none; color:#e56399; font-size:1.2rem; cursor:pointer; width: 30px;">+</button>
                                    </div>
                                </div>
                            </c:if>
                        
                            <c:if test="${catCodice != 'STAMPA_3D'}">
                                <input type="hidden" name="quantita" value="1">
                            </c:if>
                        
                            <div class="product-purchase-action">
                                <button type="submit" class="btn-primary btn-add-cart-large">
                                    <i class="fa-solid fa-cart-plus"></i> AGGIUNGI AL CARRELLO - € <fmt:formatNumber value="${prodotto.prezzoCorrente}" pattern="#,##0.00"/>
                                </button>
                            </div>
                        </form>
                    </c:otherwise>
                </c:choose>

              </section>
              
        </div>
        
     <div id="custom-alert-overlay">
     
	    <div class="custom-alert-box">
	    
	        <i id="modal-icon" class="fa-solid fa-circle-check"></i>
	        <h3 id="modal-title">Titolo</h3>
	        <p id="modal-msg">Messaggio</p>
	        <button type="button" class="btn-primary alert-btn" onclick="chiudiModal()">Okay</button>
	        
	    </div>
	    
	</div> 

    </main>

<script>

    const formCarrello = document.querySelector('.add-to-cart-form');
    const btnCarrello = formCarrello.querySelector('button[type="submit"]');
    const modalOverlay = document.getElementById('custom-alert-overlay');
    
    const testoOriginale = btnCarrello.innerHTML;

    function mostraModal(titolo, messaggio, icona, coloreIcona) {
        document.getElementById('modal-title').innerText = titolo;
        document.getElementById('modal-msg').innerText = messaggio;
        const iconEl = document.getElementById('modal-icon');
        iconEl.className = icona;
        iconEl.style.color = coloreIcona;
        modalOverlay.style.display = 'flex'; 
    }
    
    function chiudiModal() {
        modalOverlay.style.display = 'none';
    }

    formCarrello.addEventListener('submit', function(event) {
        event.preventDefault(); 
        const datiForm = new URLSearchParams(new FormData(this));
        datiForm.append('isAjax', 'true');
        const testoAttuale = btnCarrello.innerHTML;
        btnCarrello.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> CARICAMENTO...';

        fetch(this.action, {
            method: 'POST',
            body: datiForm,
            credentials: 'same-origin' 
        })
        .then(risposta => risposta.text())
        .then(esito => {
            
            if(esito === 'aggiunto_fisico') {
            	
                btnCarrello.innerHTML = testoOriginale; 
                mostraModal("Evviva!", "Aggiunto al carrello.", "fa-solid fa-cart-plus", "#e56399"); 
            } 
            else if(esito === 'aggiunto_digitale') {

                btnCarrello.innerHTML = '<i class="fa-solid fa-trash-can"></i> RIMUOVI DAL CARRELLO';
                btnCarrello.style.backgroundColor = '#e74c3c'; 
                btnCarrello.style.borderColor = '#c0392b';
                mostraModal("Evviva!", "Licenza digitale aggiunta al carrello.", "fa-solid fa-cart-plus", "#e56399"); 
            } 
            else if(esito === 'rimosso_digitale') {

                btnCarrello.innerHTML = testoOriginale;
                btnCarrello.style.backgroundColor = ''; 
                btnCarrello.style.borderColor = '';
                mostraModal("Rimosso", "Il prodotto è stato rimosso dal carrello.", "fa-solid fa-trash-can", "#2c3e50"); 
            } 
            else {
                btnCarrello.innerHTML = testoAttuale; 
                mostraModal("Errore", "Si è verificato un problema tecnico.", "fa-solid fa-circle-xmark", "#e74c3c");
            }
        })
        .catch(error => {
            mostraModal("Errore di Rete", "Impossibile comunicare col server.", "fa-solid fa-wifi", "#e74c3c");
            btnCarrello.innerHTML = testoAttuale;
        });
    });
</script>

<script>
	function updateQty(button, change) {
	    const container = button.closest('.quantity-control');
	    const input = container.querySelector('.qty-input');
	    
	    let currentVal = parseInt(input.value) || 1;
	    let newVal = currentVal + change;
	    
	    if (newVal >= 1 && newVal <= 99) {
	        input.value = newVal;
	    }
	}
</script>

<%@ include file="fragment/footer.jspf" %>