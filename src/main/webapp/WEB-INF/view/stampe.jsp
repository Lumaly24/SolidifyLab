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
    
    <!-- MODAL DI AVVISO -->
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

    <!-- MODAL DI SUCCESSO -->
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

    <div class="catalog-layout">
        
        <!-- SIDEBAR FILTRI -->
        <aside class="catalog-sidebar">
            <form action="${pageContext.request.contextPath}/Stampe" method="GET">
                
                <c:set var="tagsScelti" value="${fn:join(paramValues.tag, ',')}" />
                
                <div class="filter-group">
                    <h3>Filtro Prezzi</h3>
                    <div class="price-slider">
                        <c:set var="currentVal" value="${not empty param.max_price ? param.max_price : 300}" />
                        <input type="range" id="priceRange" name="max_price" min="0" max="300" step="10" value="${currentVal}">
                        <div class="price-labels">
                            <span>0€</span>
                            <span>Fino a: <b id="priceVal">${currentVal}€</b></span>
                        </div>
                    </div>
                </div>

                <hr class="sidebar-divider">
                
                <div class="filter-group">
                    <h3>Stampe 3D</h3>
                    <ul class="filter-list">
                        <li>
                            <label>
                                <input type="checkbox" name="tag" value="miniature" ${fn:contains(tagsScelti, 'miniature') ? 'checked' : ''}> 
                                Miniature
                            </label>
                        </li>
                        <li>
                            <label>
                                <input type="checkbox" name="tag" value="props" ${fn:contains(tagsScelti, 'props') ? 'checked' : ''}> 
                                Props
                            </label>
                        </li>
                        <li>
                            <label>
                                <input type="checkbox" name="tag" value="accessori" ${fn:contains(tagsScelti, 'accessori') ? 'checked' : ''}> 
                                Accessori
                            </label>
                        </li>
                    </ul>
                </div>

                <div class="filter-group">
                    <h3>Specifiche tecniche</h3>
                    
                    <details open>
                        <summary>Materiali</summary>
                        <ul class="filter-list">
                            <li>
                                <label>
                                    <input type="checkbox" name="tag" value="resina" ${fn:contains(tagsScelti, 'resina') ? 'checked' : ''}> 
                                    Resina
                                </label>
                            </li>
                            <li>
                                <label>
                                    <input type="checkbox" name="tag" value="pla" ${fn:contains(tagsScelti, 'pla') ? 'checked' : ''}> 
                                    PLA
                                </label>
                            </li>
                            <li>
                                <label>
                                    <input type="checkbox" name="tag" value="petg" ${fn:contains(tagsScelti, 'petg') ? 'checked' : ''}> 
                                    PETG
                                </label>
                            </li>
                        </ul>
                    </details>

                    <details open>
                        <summary>Finitura</summary>
                        <ul class="filter-list">
                            <li>
                                <label>
                                    <input type="checkbox" name="tag" value="supporti_rimossi" ${fn:contains(tagsScelti, 'supporti_rimossi') ? 'checked' : ''}> 
                                    Supporti Rimossi
                                </label>
                            </li>
                            <li>
                                <label>
                                    <input type="checkbox" name="tag" value="levigatura_primer" ${fn:contains(tagsScelti, 'levigatura_primer') ? 'checked' : ''}> 
                                    Levigatura + Primer Base
                                </label>
                            </li>
                            <li>
                                <label>
                                    <input type="checkbox" name="tag" value="colore" ${fn:contains(tagsScelti, 'colore') ? 'checked' : ''}> 
                                    Colore
                                </label>
                            </li>
                        </ul>
                    </details>
                </div>
                
                <button type="submit" class="btn-primary w-100 mt-3">APPLICA FILTRI</button>

            </form>
        </aside>

        <!-- CONTENUTO PRINCIPALE -->
        <section class="catalog-main-content">
            
            <div class="top-nav-row">
                <nav class="breadcrumbs" aria-label="Percorso di navigazione">
                    <a href="${pageContext.request.contextPath}/Stampe">Libreria Stampe 3D</a> 
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
                                Modelli Stampabili
                            </c:otherwise>
                        </c:choose>
                    </span>
                </nav>

                <c:if test="${not empty sessionScope.utenteLoggato and sessionScope.utenteLoggato.ruolo == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/AdminDashboard?cat=STAMPA_3D#aggiunta-prodotti" class="btn-primary nuova-stampa" style="padding: 5px 15px; font-size: 0.9em;">
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
                    
                    <form action="${pageContext.request.contextPath}/Commissioni" method="POST" enctype="multipart/form-data" id="heroStampaForm">
                        <input type="hidden" name="richiede_stampa_3d" value="true">
                        <input type="hidden" name="tipo" value="stampa_3d">
                        <input type="hidden" name="step" value="2">
                        
                        <!-- Wrapper del box di caricamento file -->
                        <div class="file-upload-wrapper" id="fileUploadWrapper">
                            <input type="file" id="file3dInput" name="file_riferimento" accept=".stl,.obj,.3mf,.png" class="file-input-hidden">
                            <label for="file3dInput" class="file-dropzone" id="fileDropzoneLabel">
                                <i class="fa-solid fa-cloud-arrow-up upload-icon" id="uploadIcon"></i>
                                <span class="upload-title" id="uploadTitle">Carica il tuo file 3D (.STL, .OBJ)</span>
                                <span class="upload-sub" id="uploadSub">Clicca o trascina il file qui</span>
                            </label>
                        </div>  
                        
                        <!-- Messaggio verde di conferma file caricato (inizialmente nascosto) -->
                        <div id="fileLoadedMessage" style="display: none; margin-bottom: 15px; padding: 12px 15px; background: rgba(46, 204, 113, 0.2); ; border: 1px solid #46a24a; border-radius: 8px; color: #46a24a; font-family: 'coolveticarg', sans-serif; font-size: 1rem; text-align: center; align-items: center; justify-content: center; gap: 8px;">
                            <i class="fa-solid fa-circle-check"></i> 
                            <span>File caricato: <strong id="selectedFileName" style="color: #46a24a;"></strong></span>
                        </div>
                        
                        <div class="hero-buttons">
                            <a href="#" id="submitStampaBtn"> 
                                <i class="fa-solid fa-wand-magic-sparkles"></i> STAMPA UN TUO FILE 
                            </a> 
                        </div>
                    </form>
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
                                    
                                    <!-- LOGICA ADMIN DELETE -->
                                    <c:if test="${not empty sessionScope.utenteLoggato and sessionScope.utenteLoggato.ruolo == 'ADMIN'}">
                                        <form action="${pageContext.request.contextPath}/Add&Remove" method="POST" style="display:inline;" id="delete-form-${prodotto.id}">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="id" value="${prodotto.id}">
                                            <button type="button" class="btn-wishlist" title="Elimina dal DB" onclick="showDeleteConfirmAlert('Sei sicuro di voler eliminare definitivamente questo prodotto dal catalogo?', 'delete-form-${prodotto.id}')">
                                                <i class="fa-solid fa-trash-can" style="color: #ff4d4d;"></i>
                                            </button>
                                        </form>                       
                                    </c:if>
                                    
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

        const fileInput = document.getElementById('file3dInput');
        const fileUploadWrapper = document.getElementById('fileUploadWrapper');
        const fileLoadedMessage = document.getElementById('fileLoadedMessage');
        const selectedFileName = document.getElementById('selectedFileName');
        const submitStampaBtn = document.getElementById('submitStampaBtn');
        const heroStampaForm = document.getElementById('heroStampaForm');

        if (fileInput) {
            fileInput.addEventListener('change', function() {
                if (fileInput.files && fileInput.files.length > 0) {
                    const fileName = fileInput.files[0].name;
                    
                    if (fileUploadWrapper) {
                        fileUploadWrapper.style.display = 'none';
                    }
                    
                    if (selectedFileName && fileLoadedMessage) {
                        selectedFileName.innerText = fileName;
                        fileLoadedMessage.style.display = "flex";
                    }
                }
            });
        }

        // Gestione click sul pulsante originale per inviare il form
        if (submitStampaBtn && heroStampaForm) {
            submitStampaBtn.addEventListener('click', function(e) {
                e.preventDefault();
                heroStampaForm.submit();
            });
        }
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