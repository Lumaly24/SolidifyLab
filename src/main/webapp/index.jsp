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
                    <a href="${pageContext.request.contextPath}/CatalogoServlet" class="btn"> ESPLORA LA LIBRERIA <i class="fa-solid fa-arrow-right"></i> </a> 
                    <a href="#" class="btn"> SCOPRI DI PIÙ <i class="fa-solid fa-arrow-right"></i></a> 
                </div>
            </div>
        </section>

        <!-- CATEGORIES SECTION -->
        <section class="categories-section">
            <h2>CATEGORIE PRINCIPALI</h2>
            
            <div class="categories-grid">
                <a href="${pageContext.request.contextPath}/CatalogoServlet?categoria=MODELLO_3D" class="category-card">
                    <div class="card-img-container">
                        <img src="" alt="Modelli 3D" loading="lazy">
                    </div>
                    <div class="card-info">
                        <h3>Modelli 3D</h3>
                        <p></p>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/CatalogoServlet?categoria=TEXTURE" class="category-card">
                    <div class="card-img-container">
                        <img src="" alt="Textures" loading="lazy">
                    </div>
                    <div class="card-info">
                        <h3>Textures</h3>
                        <p></p>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/CatalogoServlet?categoria=STAMPA_3D" class="category-card">
                    <div class="card-img-container">
                        <img src="" alt="Stampe 3D" loading="lazy">
                    </div>
                    <div class="card-info">
                        <h3>Stampe 3D</h3>
                        <p></p>
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
                                            
                                            <!-- LOGICA DEL "NEW" -->
                                            <c:if test="${status.index < 3}">
                                                <img src="${pageContext.request.contextPath}/images/new-button.png" alt="New" class="new-button-img" loading="lazy">
                                            </c:if>
                                            
                                            <!-- VERIFICA PRE-ESISTENZA IN WISHLIST -->
                                            <c:set var="inWishlist" value="false" />
                                            <c:forEach var="wId" items="${sessionScope.wishlistIds}">
                                                <c:if test="${wId == prodotto.id}">
                                                    <c:set var="inWishlist" value="true" />
                                                </c:if>
                                            </c:forEach>

                                            <!-- GESTIONE CLICK WISHLIST -->
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.utenteLoggato}">
                                                    <form action="${pageContext.request.contextPath}/AggiungiWishlistServlet" method="POST" class="inline-form wishlist-form">
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
                                    <a href="${pageContext.request.contextPath}/wishlist" class="btn-signup">VAI ALLA WISHLIST</a>
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