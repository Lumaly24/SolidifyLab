<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<% request.setAttribute("titoloPagina", "Home"); %>
<%@ include file="/WEB-INF/view/fragment/header.jspf" %>

    <main>
         
        <!-- HERO SECTION -->
        <section class="hero-section">
            <div class="hero-content">
                <h1>ESPLORA<br>LA LIBRERIA</h1>
                <div class="hero-buttons">
                    <a href="${pageContext.request.contextPath}/Catalogo" class="btn"> ESPLORA LA LIBRERIA <i class="fa-solid fa-arrow-right"></i> </a> 
                    <a href="#" class="btn"> SCOPRI DI PIÙ <i class="fa-solid fa-arrow-right"></i></a> 
                </div>
            </div>
        </section>

        <!-- CATEGORIES SECTION -->
        <section class="categories-section">
            <h2>CATEGORIE PRINCIPALI</h2>
            
            <div class="categories-grid">
                <!-- 1. Modelli 3D: Punta al Catalogo con tipo=3D (o default) -->
                <a href="${pageContext.request.contextPath}/Catalogo?tipo=3D" class="category-card">
                    <div class="card-img-container">
                        <img src="${pageContext.request.contextPath}/images/modelli-3d-sfondo.png" alt="Modelli 3D" loading="lazy">
                    </div>
                    <div class="card-info">
                        <h3>Modelli 3D</h3>
                    </div>
                </a>

                <!-- 2. Textures: Punta al Catalogo filtrato per le textures -->
                <a href="${pageContext.request.contextPath}/Catalogo?tipo=TEXTURES" class="category-card">
                    <div class="card-img-container">
                        <img src="${pageContext.request.contextPath}/images/textures-sfondo.png" alt="Textures" loading="lazy">
                    </div>
                    <div class="card-info">
                        <h3>Textures</h3>
                    </div>
                </a>

                <!-- 3. Stampe 3D: Se la servlet delle stampe ti dà ancora 404, puntiamo temporaneamente alla jsp o correggiamo la rotta -->
                <a href="${pageContext.request.contextPath}/Stampe" class="category-card">
                    <div class="card-img-container">
                        <img src="${pageContext.request.contextPath}/images/stampe3d-sfondo.png" alt="Stampe 3D" loading="lazy">
                    </div>
                    <div class="card-info">
                        <h3>Stampe 3D</h3>
                    </div>
                </a>
            </div>
        </section>

        <!-- FEATURED PRODUCTS SECTION -->
        <section class="featured-products-section">
            <h2>PRODOTTI IN EVIDENZA</h2>

            <div class="carousel-outer-container">
            
                <button type="button" class="carousel-arrow prev-btn hidden" id="prevBtn" aria-label="Precedente">
                    <i class="fa-solid fa-chevron-left"></i>
                </button>

                <div class="carousel-mask-wrapper">
                    <div class="products-carousel" id="productsCarousel">
        
                        <!-- CICLO JSP: Mostra dinamicamente i prodotti -->
                        <c:choose>
                            <c:when test="${empty prodottiInEvidenza}">
                                <p class="empty-carousel-msg text-center">Nuovi prodotti in arrivo a breve!</p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="prodotto" items="${prodottiInEvidenza}" varStatus="status">
                                    <article class="product-card">
                                        
                                        <div class="product-badges">
                                            
                                            <c:if test="${status.index < 3}">
                                                <img src="${pageContext.request.contextPath}/images/new-button.png" alt="New" class="new-button-img" loading="lazy">
                                            </c:if>
                                            
                                            <c:set var="inWishlist" value="false" />
                                            <c:forEach var="wId" items="${sessionScope.wishlistIds}">
                                                <c:if test="${wId == prodotto.id}">
                                                    <c:set var="inWishlist" value="true" />
                                                </c:if>
                                            </c:forEach>

                                            <!-- GESTIONE CLICK WISHLIST -->
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
                                            
                                        </div>
                                        
                                        <a href="${pageContext.request.contextPath}/DettaglioProdottoServlet?id=${prodotto.id}" class="product-link">
                                            <div class="product-image">
                                                <span>(IMG ${prodotto.nome})</span>
                                            </div>
                                            <div class="product-price">
                                                <span>&euro; <fmt:formatNumber value="${prodotto.prezzoCorrente}" pattern="#,##0.00"/></span>
                                            </div>
                                        </a>
                                    </article>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
            
                    </div>
                </div>

                <button type="button" class="carousel-arrow next-btn" id="nextBtn" aria-label="Successivo">
                    <i class="fa-solid fa-chevron-right"></i>
                </button>
                
            </div>
        </section>

        <!-- SEZIONE FINALE (CTA + FOOTER UNIFICATI) -->
        <section class="final-section">
            <div class="cta-section">
                <div class="cta-content">
                    <c:choose>
                        <c:when test="${not empty sessionScope.utenteLoggato}">
                            <h2>Bentornato, <c:out value="${sessionScope.utenteLoggato.username}" />!</h2>
                            <div class="cta-buttons">
                                <c:if test="${sessionScope.utenteLoggato.ruolo == 'ADMIN'}">
                                    <a href="${pageContext.request.contextPath}/AdminDashboard" class="btn-login">PANNELLO ADMIN</a>
                                    <a href="${pageContext.request.contextPath}/ModificaProdotto" class="btn-login">GESTISCI CATALOGO</a>
                                </c:if>
                                <c:if test="${sessionScope.utenteLoggato.ruolo != 'ADMIN'}">
                                    <a href="${pageContext.request.contextPath}/UserDashboard" class="btn-login">IL MIO PROFILO</a>
                                    <a href="${pageContext.request.contextPath}/Wishlist" class="btn-signup">VAI ALLA WISHLIST</a>
                                </c:if>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <h2>INIZIA OGGI IL TUO VIAGGIO CREATIVO</h2>
                            <div class="cta-buttons">
                                <a href="${pageContext.request.contextPath}/Login" class="btn-login">LOG IN</a>
                                <a href="${pageContext.request.contextPath}/Signup" class="btn-signup">SIGN UP</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- FOOTER DENTRO LA SEZIONE FINALE -->
            <%@ include file="/WEB-INF/view/fragment/footer.jspf" %>
        </section>
        
        <!-- SCROLL PROGRESS NAV (4 PALLINI) -->
        <div class="scroll-progress-nav" id="scrollProgressNav">
            <div class="dot active" data-section="0" title="Hero"></div>
            <div class="dot" data-section="1" title="Categorie"></div>
            <div class="dot" data-section="2" title="Prodotti"></div>
            <div class="dot" data-section="3" title="Info & Footer"></div>
    
            <button type="button" class="btn-back-to-top" id="backToTopBtn" title="Torna su">
                <i class="fa-solid fa-arrow-up"></i>
            </button>
        </div>

    </main>

<div id="customAlert" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px); z-index: 999999; justify-content: center; align-items: center;">
    <div style="background: rgba(255, 255, 255, 0.65); backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.5); border-radius: 20px; padding: 30px; max-width: 380px; width: 85%; text-align: center; box-shadow: 0 8px 32px 0 rgba(0,0,0,0.3);">
        <i class="fa-solid fa-circle-exclamation" style="font-size: 2.5rem; color: #e56399; margin-bottom: 15px;"></i>
        <h3 style="font-family: 'elephant', sans-serif; font-weight: bold; margin-bottom: 10px; color: #e56399;">Attenzione!</h3>
        <p id="customAlertText" style="font-family: 'coolveticarg', sans-serif; margin-bottom: 20px; color: #333;">Messaggio di errore</p>
        <button type="button" class="btn-primary auth-btn" onclick="closeCustomAlert()">Okay</button>
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


<script>
    document.addEventListener("DOMContentLoaded", function () {
        // --- SCRIPT 1: CAROSELLO ---
        const carousel = document.getElementById('productsCarousel');
        const prevBtn = document.getElementById('prevBtn');
        const nextBtn = document.getElementById('nextBtn');

        if (carousel && prevBtn && nextBtn) {
            function updateArrows() {
                const scrollLeft = Math.ceil(carousel.scrollLeft);
                const maxScroll = Math.floor(carousel.scrollWidth - carousel.clientWidth);
                
                prevBtn.classList.toggle('hidden', scrollLeft <= 10);
                nextBtn.classList.toggle('hidden', scrollLeft >= maxScroll - 10);
            }

            nextBtn.addEventListener('click', () => carousel.scrollBy({ left: 220, behavior: 'smooth' }));
            prevBtn.addEventListener('click', () => carousel.scrollBy({ left: -220, behavior: 'smooth' }));
            carousel.addEventListener('scroll', updateArrows);
            window.addEventListener('resize', updateArrows);
            updateArrows();
        }

        // --- SCRIPT 2: SCROLL SPY CON OBSERVER (PRECISO AL 100%) ---
        const main = document.querySelector('main');
        const sections = document.querySelectorAll('main > section');
        const dots = document.querySelectorAll('.scroll-progress-nav .dot');
        const backToTopBtn = document.getElementById('backToTopBtn');

        if (main && sections.length > 0) {
            dots.forEach((dot, index) => {
                dot.addEventListener('click', function () {
                    if (sections[index]) {
                        sections[index].scrollIntoView({ behavior: 'smooth' });
                    }
                });
            });

            if (backToTopBtn) {
                backToTopBtn.addEventListener('click', function () {
                    main.scrollTo({ top: 0, behavior: 'smooth' });
                });
            }

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const index = Array.from(sections).indexOf(entry.target);
                        dots.forEach((dot, i) => dot.classList.toggle('active', i === index));
                    }
                });
            }, { root: main, threshold: 0.5 });

            sections.forEach(sec => observer.observe(sec));

            main.addEventListener('scroll', function () {
                if (backToTopBtn) {
                    backToTopBtn.classList.toggle('visible', main.scrollTop > 100);
                }
            });
        }

        // --- SCRIPT 3: WISHLIST AJAX ---
        const wishlistForms = document.querySelectorAll('.wishlist-form');
        wishlistForms.forEach(form => {
            form.addEventListener('submit', function(event) {
                event.preventDefault(); 
                const url = this.action;
                const formData = new FormData(this);
                const btn = this.querySelector('.btn-wishlist');
                const icon = btn.querySelector('i');
                
                fetch(url, {
                    method: 'POST',
                    body: new URLSearchParams(formData),
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                })
                .then(response => {
                    if (response.ok) {
                        icon.classList.toggle('fa-regular');
                        icon.classList.toggle('fa-solid');
                        icon.style.color = icon.classList.contains('fa-solid') ? '#e56399' : '';
                        
                        btn.style.transform = 'scale(1.3)';
                        setTimeout(() => { btn.style.transform = 'scale(1)'; }, 200);
                    }
                })
                .catch(err => console.error('Errore Wishlist:', err));
            });
        });
    });
</script>

<!-- custom alert index -->

<script>
    function clearErrors() {
        document.querySelectorAll('.error-msg').forEach(el => el.innerText = '');
        document.querySelectorAll('.input-error').forEach(el => el.classList.remove('input-error'));
    }

    function showLoginAlert(loginUrl) {
        const modal = document.getElementById('customAlert');
        const modalText = document.getElementById('customAlertText');
        const okayBtn = modal.querySelector('.auth-btn');

        if (modal && modalText) {
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
        if (modal && modalText) {
            modalText.innerText = message;
            modal.style.display = 'flex';
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