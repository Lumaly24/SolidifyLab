<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<% request.setAttribute("titoloPagina", "Home"); %>
<%@ include file="/WEB-INF/view/fragment/header.jspf" %>

    <main>
        
        <!-- HERO SECTION -->
        <section class="hero-section">
            <div class="hero-content">
                <h1>ESPLORA LA LIBRERIA</h1>
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
                        <img src="" alt="Modelli 3D">
                    </div>
                    <div class="card-info">
                        <h3>Modelli 3D</h3>
                        <p></p>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/CatalogoServlet?categoria=TEXTURE" class="category-card">
                    <div class="card-img-container">
                        <img src="" alt="Textures">
                    </div>
                    <div class="card-info">
                        <h3>Textures</h3>
                        <p></p>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/CatalogoServlet?categoria=STAMPA_3D" class="category-card">
                    <div class="card-img-container">
                        <img src="" alt="Stampe 3D">
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
                                <!-- varStatus="status" ci permette di contare l'indice del ciclo -->
                                <c:forEach var="prodotto" items="${prodottiInEvidenza}" varStatus="status">
                                    <article class="product-card">
                                        
                                        <div class="product-badges">
                                            
                                            <!-- LOGICA DEL "NEW": Se l'indice è 0, 1 o 2 (i primi tre), mostra l'etichetta -->
                                            <c:if test="${status.index < 3}">
                                                <img src="${pageContext.request.contextPath}/images/new-button.png" alt="New" class="new-button-img">
                                            </c:if>
                                            
                                            <!-- FORM WISHLIST -->
                                            <form action="${pageContext.request.contextPath}/AggiungiWishlistServlet" method="POST" class="inline-form">
                                                <input type="hidden" name="id_prodotto" value="${prodotto.id}">
                                                <button type="submit" class="btn-wishlist" title="Wishlist-add">
                                                    <i class="fa-regular fa-heart"></i>
                                                </button>
                                            </form>
                                        </div>
                                        
                                        <!-- Link al Dettaglio Prodotto reale -->
                                        <a href="${pageContext.request.contextPath}/DettaglioProdottoServlet?id=${prodotto.id}" class="product-link">
                                            <div class="product-image">
                                                <span>(IMG ${prodotto.nome})</span>
                                            </div>
                                            <div class="product-price">
                                                <span>&euro; <fmt:formatNumber value="${prodotto.prezzo}" pattern="#,##0.00"/></span>
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

        <!-- CTA SECTION -->
        <section class="cta-section">
		    <h2>INIZIA OGGI IL TUO VIAGGIO CREATIVO</h2>
		    <div class="cta-buttons">
		        <a href="${pageContext.request.contextPath}/login" class="btn-login">LOG IN</a>
		        <a href="${pageContext.request.contextPath}/signup" class="btn-signup">SIGN UP</a>
		    </div>
		</section>
        
        <!-- SCROLL PROGRESS NAV -->
        <div class="scroll-progress-nav" id="scrollProgressNav">
            <div class="dot active" data-section="0" title="Hero"></div>
            <div class="dot" data-section="1" title="Categorie"></div>
            <div class="dot" data-section="2" title="Prodotti"></div>
            <div class="dot" data-section="3" title="Inizia / Footer"></div>
    
            <button type="button" class="btn-back-to-top" id="backToTopBtn" title="Torna su">
                <i class="fa-solid fa-arrow-up"></i>
            </button>
        </div>

        <%@ include file="/WEB-INF/view/fragment/footer.jspf" %>

    </main>
    
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const carousel = document.getElementById('productsCarousel');
        const prevBtn = document.getElementById('prevBtn');
        const nextBtn = document.getElementById('nextBtn');

        if (carousel && prevBtn && nextBtn) {

            function updateArrows() {
                const scrollLeft = Math.ceil(carousel.scrollLeft);
                const maxScroll = Math.floor(carousel.scrollWidth - carousel.clientWidth);
                
                if (scrollLeft > 249) {                 
                    prevBtn.classList.remove('hidden');
                } else {
                    prevBtn.classList.add('hidden');
                }

                if (scrollLeft >= maxScroll - 10) {
                    nextBtn.classList.add('hidden');
                } else {
                    nextBtn.classList.remove('hidden');
                }
            }

            nextBtn.addEventListener('click', function () {
                carousel.scrollBy({ left: 220, behavior: 'smooth' });
            });

            prevBtn.addEventListener('click', function () {
                carousel.scrollBy({ left: -220, behavior: 'smooth' });
            });

            carousel.addEventListener('scroll', updateArrows);
            window.addEventListener('resize', updateArrows);

            updateArrows();
        }
    });
</script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const main = document.querySelector('main');
        const sections = document.querySelectorAll('main > section');
        const dots = document.querySelectorAll('.scroll-progress-nav .dot');
        const backToTopBtn = document.getElementById('backToTopBtn');
        const footer = document.querySelector('.main-footer');

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

            main.addEventListener('scroll', function () {
                const scrollPosition = main.scrollTop;
                const maxScroll = main.scrollHeight - main.clientHeight;
                const sectionHeight = main.clientHeight;

                let currentIndex = Math.round(scrollPosition / sectionHeight);

                if (scrollPosition >= maxScroll - 50) {
                    currentIndex = sections.length - 1;
                }

                dots.forEach((dot, i) => {
                    dot.classList.toggle('active', i === currentIndex);
                });

                if (backToTopBtn) {
                    backToTopBtn.classList.toggle('visible', scrollPosition > 100);
                }
            });
        }
    });
</script>