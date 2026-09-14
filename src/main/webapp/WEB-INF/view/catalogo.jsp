<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<% 
    request.setAttribute("titoloPagina", "Catalogo"); 
    request.setAttribute("cssPagina", "catalogo.css");
%>

<%@ include file="fragment/header.jspf" %>

    <main class="catalog-page">
        
        <div id="customAlert" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px); z-index: 999999; justify-content: center; align-items: center;">
		    <div style="background: rgba(255, 255, 255, 0.65); backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.5); border-radius: 20px; padding: 30px; max-width: 380px; width: 85%; text-align: center; box-shadow: 0 8px 32px 0 rgba(0,0,0,0.3);">
		        <i class="fa-solid fa-circle-exclamation" style="font-size: 2.5rem; color: #e56399; margin-bottom: 15px;"></i>
		        <h3 style="font-family: 'elephant', sans-serif; font-weight: bold; margin-bottom: 10px; color: #e56399;">Attenzione!</h3>
		        <p id="customAlertText" style="font-family: 'coolveticarg', sans-serif; margin-bottom: 20px; color: #333;">Messaggio</p>
		        
		        <button type="button" class="btn-primary auth-btn" id="customAlertSingleBtn" onclick="closeCustomAlert()" style="width: 100%;">Okay</button>
		        
		        <div id="customAlertDoubleBtns" style="display: none; gap: 15px; justify-content: center; align-items: center;">
				    <button type="button" class="btn-secondary" onclick="closeCustomAlert()" style="margin: 0; border-radius: 50px; padding: 10px 25px;">Annulla</button>
				    <button type="button" class="auth-btn" id="customAlertConfirmBtn" style="margin: 0; border-radius: 50px; padding: 10px 25px; background: #ff4d4d;">Elimina</button>
				</div>
		    </div>
		</div>
    
        <div id="successModal" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px); z-index: 999999; justify-content: center; align-items: center;">
            <div style="background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.5); border-radius: 20px; padding: 40px 30px; max-width: 400px; width: 85%; text-align: center; box-shadow: 0 10px 40px rgba(0,0,0,0.2);">
                <i class="fa-solid fa-circle-check" style="font-size: 3.5rem; color: #2ecc71; margin-bottom: 20px;"></i>
                <h3 style="font-family: 'elephant', sans-serif; font-weight: bold; margin-bottom: 15px; color: #333;">Evviva!</h3>
                <p id="successModalText" style="font-family: 'coolveticarg', sans-serif; margin-bottom: 25px; color: #555; font-size: 1.1rem; line-height: 1.4;">
                    Operazione completata con successo!
                </p>
                
                <button type="button" class="btn-primary auth-btn" onclick="closeSuccessModal()" style="width: 100%;">Okay</button>
            </div>
        </div>
    
        <style>
            .input-error {
                border: 2px solid #e56399 !important;
                box-shadow: 0 0 8px rgba(229, 99, 153, 0.4) !important;
                transition: all 0.3s ease;
            }
        </style>    
                
        <div class="catalog-layout">
            
            <aside class="catalog-sidebar">
            
                <form action="${pageContext.request.contextPath}/Catalogo" method="GET">
                    
                    <div class="filter-group">
                        <h3>Filtro Prezzi</h3>
                        
                        <div class="price-slider">
                            <input type="range" id="priceRange" name="max_price" min="0" max="200" step="5" value="${not empty param.max_price ? param.max_price : 100}">
                            <div class="price-labels">
                                <span>0€</span>
                                <span>Fino a: <b id="priceVal">${not empty param.max_price ? param.max_price : 100}€</b></span>
                            </div>
                        </div>
                    </div>
        
                    <script>
                        document.addEventListener('DOMContentLoaded', function() {
                            // --- 1. GESTIONE SLIDER PREZZO ---
                            const slider = document.getElementById('priceRange');
                            const priceVal = document.getElementById('priceVal');
                            
                            function updateSlider() {
                                const percentage = ((slider.value - slider.min) / (slider.max - slider.min)) * 100;
                                slider.style.setProperty('--val', percentage + '%');
                                priceVal.innerText = slider.value + '€';
                            }
                            
                            updateSlider();
                            slider.addEventListener('input', updateSlider);

                            // --- 2. GESTIONE MANTENIMENTO CHECKBOX E MENU A TENDINA ---
                            const urlParams = new URLSearchParams(window.location.search);
                            const selectedTags = urlParams.getAll('tag');
                            
                            selectedTags.forEach(tag => {
                                const checkbox = document.querySelector('input[name="tag"][value="' + tag + '"]');
                                
                                if (checkbox) {
                                    checkbox.checked = true;
                                    
                                    const detailsContainer = checkbox.closest('details');
                                    if (detailsContainer) {
                                        detailsContainer.open = true;
                                    }
                                }
                            });
                        });
                    </script>

                    <hr class="sidebar-divider">
                    
                    <div class="filter-group">
                        <h3>Categorie</h3>
                        <input type="hidden" name="tipo" value="${not empty param.tipo ? param.tipo : '3D'}">
                        
                        <c:choose>
                            <c:when test="${param.tipo == 'TEXTURES'}">
                                <ul class="filter-list">
                                	<li><label><input type="checkbox" name="tag" value="architettura"> Architettura</label></li>
                                	<li><label><input type="checkbox" name="tag" value="metalli"> Metalli</label></li>
									<li><label><input type="checkbox" name="tag" value="tessuti"> Tessuti</label></li>
									<li><label><input type="checkbox" name="tag" value="organiche"> Organiche</label></li>
                                    
                                </ul>
                    
                                <h3 style="font-size: 1.1em; color: #e56399; margin-top: 15px; margin-bottom: 10px;">Specifiche Tecniche</h3>
                                <ul class="filter-list">
                                    <li>
                                        <details>
                                            <summary>Risoluzione <i class="fa-solid fa-angle-down"></i></summary>
                                            <ul class="sub-filter-list">
                                                <li><label><input type="checkbox" name="tag" value="1k"> 1K</label></li>
                                                <li><label><input type="checkbox" name="tag" value="2k"> 2K</label></li>
                                                <li><label><input type="checkbox" name="tag" value="3k"> 3K</label></li>
                                                <li><label><input type="checkbox" name="tag" value="4k"> 4K</label></li>
                                            </ul>
                                        </details>
                                    </li>
                                    <li><label><input type="checkbox" name="tag" value="seamless"> Seamless</label></li>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <ul class="filter-list">
                                    <li><label><input type="checkbox" name="tag" value="personaggi"> Personaggi</label></li>
                                    <li><label><input type="checkbox" name="tag" value="creature"> Creature</label></li>
                                    <li><label><input type="checkbox" name="tag" value="ambienti"> Ambienti</label></li>
                                    <li><label><input type="checkbox" name="tag" value="props"> Props</label></li>
                                </ul>
                    
                                <h3 style="font-size: 1.1em; color: #e56399; margin-top: 15px; margin-bottom: 10px;">Specifiche tecniche</h3>
                                <ul class="filter-list">
                                    <li>
                                        <details>
                                            <summary>Poly <i class="fa-solid fa-angle-down"></i></summary>
                                            <ul class="sub-filter-list">
                                                <li><label><input type="checkbox" name="tag" value="low_poly"> Low</label></li>
                                                <li><label><input type="checkbox" name="tag" value="high_poly"> High</label></li>
                                            </ul>
                                        </details>
                                    </li>
                                    <li>
                                        <details>
                                            <summary>Stile <i class="fa-solid fa-angle-down"></i></summary>
                                            <ul class="sub-filter-list">
                                                <li><label><input type="checkbox" name="tag" value="realistico"> Realistico</label></li>
                                                <li><label><input type="checkbox" name="tag" value="fantasy"> Fantasy</label></li>
                                            </ul>
                                        </details>
                                    </li>
                                    <li><label><input type="checkbox" name="tag" value="rigged"> Rigged</label></li>
                                    <li><label><input type="checkbox" name="tag" value="game_ready"> Game ready</label></li>
                                </ul>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <button type="submit" class="btn-primary w-100 mt-3">Applica Filtri</button>
                    
                    <div class="physical-promo mt-4">
                        <h4>Vuoi un oggetto fisico?</h4>
                        <p style="font-size: 0.9em; margin-bottom: 15px;">Scopri i nostri modelli già pronti per essere stampati e spediti a casa tua.</p>
                        <a href="${pageContext.request.contextPath}/Stampe" class="btn-outline-small w-100 text-center" style="display: block;">Vai alle Stampe 3D</a>
                    </div>
                    
                </form>
            </aside>

            <!-- ================= MAIN CONTENT ================= -->
            <section class="catalog-main-content">
                
                <div class="top-controls-inline">
                    
                    <div class="catalog-tabs">
                        <a href="${pageContext.request.contextPath}/Catalogo?tipo=3D" class="tab-btn ${param.tipo == 'TEXTURES' ? '' : 'active'}">3D MODELS</a>
                        <a href="${pageContext.request.contextPath}/Catalogo?tipo=TEXTURES" class="tab-btn ${param.tipo == 'TEXTURES' ? 'active' : ''}">TEXTURES</a>
                    </div>
                 
                    <div class="ajax-search-container">
                        <div class="search-input-wrapper">
                            <input type="text" id="ajaxSearchBar" placeholder="Cerca un modello 3D o una texture..." autocomplete="off">
                            <button type="button" class="btn-primary btn-search"><i class="fa-solid fa-search"></i></button>
                        </div>
                 
                        <div id="searchSuggestions" style="display: none; position: absolute; top: 100%; left: 0; right: 0; z-index: 10; max-height: 200px; overflow-y: auto;">
                        </div>
                    </div>
                    
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
				    <nav class="breadcrumbs" aria-label="Percorso di navigazione">
				        <a href="${pageContext.request.contextPath}/Catalogo?tipo=${not empty param.tipo ? param.tipo : '3D'}">
				            ${param.tipo == 'TEXTURES' ? 'Libreria Texture' : 'Libreria Modelli 3D'}
				        </a> 
				        <span class="separator">/</span> 
				        <span class="current-page">
				            <c:choose>
				                <c:when test="${not empty paramValues.tag}">
				                    Filtri:
				                    <c:forEach var="t" items="${paramValues.tag}" varStatus="loop">
				                        <span style="text-transform: capitalize;">${fn:replace(t, '_', ' ')}</span><c:if test="${!loop.last}"> / </c:if>
				                    </c:forEach>
				                </c:when>
				                <c:otherwise>
				                    Tutti i prodotti
				                </c:otherwise>
				            </c:choose>
				        </span>
				    </nav>
				
				    <c:if test="${not empty sessionScope.utenteLoggato and sessionScope.utenteLoggato.ruolo == 'ADMIN'}">
				        <a href="${pageContext.request.contextPath}/admin.jsp#gestione-prodotti" class="btn-primary nuovo-prodotto" style="padding: 5px 15px; font-size: 0.9em;">
				            <i class="fa-solid fa-plus"></i> Nuovo Prodotto
				        </a>
				    </c:if>
				</div>
                
                <div class="catalog-products-grid">
    
                    <c:choose>
                        <c:when test="${empty listaProdotti}">
                            <p>Nessun prodotto trovato per questa ricerca.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="prodotto" items="${listaProdotti}">
                                <article class="product-card">
                                    <div class="product-badges">
                                        
                                        <c:set var="inWishlist" value="false" />
                                            <c:forEach var="wId" items="${sessionScope.wishlistIds}">
                                                <c:if test="${wId == prodotto.id}">
                                                    <c:set var="inWishlist" value="true" />
                                                </c:if>
                                            </c:forEach>
                                            
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.utenteLoggato}">
                                                    <form action="${pageContext.request.contextPath}/AddtoWishlist" method="POST" class="inline-form wishlist-form">
                                                        <input type="hidden" name="id_prodotto" value="${prodotto.id}">
                                                        <button type="submit" class="btn-wishlist" title="${inWishlist ? 'Rimuovi dalla Wishlist' : 'Aggiungi alla Wishlist'}">
                                                            <i class="${inWishlist ? 'fa-solid' : 'fa-regular'} fa-heart" style="${inWishlist ? 'color: #e56399;' : ''}"></i>
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn-wishlist" title="Accedi per la Wishlist" onclick="showLoginAlert('${pageContext.request.contextPath}/Login')">
                                                        <i class="fa-regular fa-heart"></i>
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                
                                        <c:if test="${not empty sessionScope.utenteLoggato and sessionScope.utenteLoggato.ruolo == 'ADMIN'}">
										    <form action="${pageContext.request.contextPath}/DeleteProductServlet" method="POST" style="display:inline;" id="delete-form-${prodotto.id}">
										        <input type="hidden" name="id" value="${prodotto.id}">
										        <button type="button" class="btn-wishlist" title="Elimina dal DB" onclick="showDeleteConfirmAlert('Sei sicuro di voler eliminare definitivamente questo prodotto dal catalogo?', 'delete-form-${prodotto.id}')">
										            <i class="fa-solid fa-trash-can" style="color: #ff4d4d;"></i>
										        </button>
										    </form>
										</c:if>
                
                                    </div>
                                    
                                    <a href="${pageContext.request.contextPath}/Prodotto?id=${prodotto.id}" class="product-link">
                                        <div class="product-image">
                                        
                                            <img src="${pageContext.request.contextPath}/images/prodotti/${prodotto.immagineCopertinaUrl}" alt="${prodotto.nome}" style="max-width: 100%; border-radius: 8px;">
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
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('ajaxSearchBar');
            const suggestionsBox = document.getElementById('searchSuggestions');

            searchInput.addEventListener('keyup', function() {
                let query = this.value.trim();
                
                if(query.length >= 2) {
                    fetch('${pageContext.request.contextPath}/RicercaAjaxServlet?q=' + encodeURIComponent(query))
                        .then(response => response.json())
                        .then(data => {
                            suggestionsBox.innerHTML = '';
                            
                            if(data.length > 0) {
                                data.forEach(item => {
                                    let div = document.createElement('div');
                                    div.style.padding = '12px 15px';
                                    div.style.borderBottom = '1px solid rgba(255,255,255,0.1)';
                                    div.style.cursor = 'pointer';
                                    div.style.transition = 'background 0.2s';
                                    
                                    div.innerHTML = `<strong>\${item.nome}</strong> - €\${item.prezzo}`;
                                    
                                    div.onclick = function() {
                                        window.location.href = '${pageContext.request.contextPath}/Prodotto?id=' + item.id;
                                    };
                                    
                                    div.onmouseover = function() { this.style.backgroundColor = 'rgba(255,255,255,0.1)'; };
                                    div.onmouseout = function() { this.style.backgroundColor = 'transparent'; };
                                    
                                    suggestionsBox.appendChild(div);
                                });
                                suggestionsBox.style.display = 'block';
                            } else {
                                suggestionsBox.innerHTML = '<div style="padding:12px 15px; color:rgba(255,255,255,0.7);">Nessun risultato...</div>';
                                suggestionsBox.style.display = 'block';
                            }
                        })
                        .catch(error => console.error('Errore Fetch AJAX:', error));
                } else {
                    suggestionsBox.style.display = 'none';
                }
            });

            document.addEventListener('click', function(e) {
                if(!searchInput.contains(e.target) && !suggestionsBox.contains(e.target)) {
                    suggestionsBox.style.display = 'none';
                }
            });
        });
    </script>

<script>
    function clearErrors() {
        document.querySelectorAll('.error-msg').forEach(el => el.innerText = '');
        document.querySelectorAll('.input-error').forEach(el => el.classList.remove('input-error'));
    }

    function showLoginAlert(loginUrl) {
        const modal = document.getElementById('customAlert');
        const modalText = document.getElementById('customAlertText');
        const okayBtn = document.getElementById('customAlertSingleBtn');

        if (modal && modalText) {
            document.getElementById('customAlertSingleBtn').style.display = 'block';
            document.getElementById('customAlertDoubleBtns').style.display = 'none';
            
            modalText.innerText = 'Devi effettuare il login per usare la Wishlist!';
            modal.style.display = 'flex';
            
            okayBtn.onclick = function() {
                window.location.href = loginUrl;
            };
        }
    }
    
    function showCustomAlert(message) {
        const modal = document.getElementById('customAlert');
        const modalText = document.getElementById('customAlertText');
        const okayBtn = document.getElementById('customAlertSingleBtn');
        
        if (modal && modalText) {
            document.getElementById('customAlertSingleBtn').style.display = 'block';
            document.getElementById('customAlertDoubleBtns').style.display = 'none';
            
            modalText.innerText = message;
            modal.style.display = 'flex';
            okayBtn.onclick = closeCustomAlert;
        }
    }

    function showDeleteConfirmAlert(message, formId) {
        const modal = document.getElementById('customAlert');
        const modalText = document.getElementById('customAlertText');
        const confirmBtn = document.getElementById('customAlertConfirmBtn');

        if (modal && modalText && confirmBtn) {
            document.getElementById('customAlertSingleBtn').style.display = 'none';
            document.getElementById('customAlertDoubleBtns').style.display = 'flex';
            
            modalText.innerText = message;
            modal.style.display = 'flex';
            
            confirmBtn.onclick = function() {
                document.getElementById(formId).submit();
            };
        }
    }

    function closeCustomAlert() {
        const modal = document.getElementById('customAlert');
        if (modal) {
            modal.style.display = 'none';
        }
    }

    function showSuccessModal(customMessage) {
        const modal = document.getElementById('successModal');
        const modalText = document.getElementById('successModalText');
        if (modal) {
            if(customMessage && customMessage.trim() !== '') {
                modalText.innerText = customMessage;
            }
            modal.style.display = 'flex';
        }
    }

    function closeSuccessModal() {
        const modal = document.getElementById('successModal');
        if (modal) {
            modal.style.display = 'none';
            window.location.href = "${pageContext.request.contextPath}/Home";
        }
    }
</script>

<c:if test="${not empty requestScope.successMessage}">
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            showSuccessModal("${requestScope.successMessage}");
        });
    </script>
</c:if>

<%@ include file="fragment/footer.jspf" %>