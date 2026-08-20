<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setAttribute("titoloPagina", "Home"); %>
<%@ include file="WEB-INF/view/fragment/header.jspf" %>

    <main>
        
        <section class="hero-section">
        
            <div class="hero-content">
            
                <h1>ESPLORA LA LIBRERIA</h1>
                
                <div class="hero-buttons">
                    <a href="${pageContext.request.contextPath}/catalogo" class="btn"> ESPLORA LA LIBRERIA <i class="fa-solid fa-arrow-right"></i> </a> 
                    <a href="#" class="btn"> SCOPRI DI PIÙ <i class="fa-solid fa-arrow-right"></i></a> 
                </div>
                
            </div>
            
        </section>

        <section class="categories-section">
            <h2>CATEGORIE PRINCIPALI</h2>
            
            <div class="categories-grid">
                <a href="${pageContext.request.contextPath}/catalogo" class="category-card">
                
                    <div class="card-img-container">
                        <img src="" alt="Modelli 3D">
                    </div>
                    
                    <div class="card-info">
                        <h3>Modelli 3D</h3>
                        <p></p>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/catalogo" class="category-card">
                    <div class="card-img-container">
                        <img src="" alt="Textures">
                    </div>
                    <div class="card-info">
                        <h3>Textures</h3>
                        <p></p>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/stampe" class="category-card">
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

        <section class="featured-products-section">
            <h2>PRODOTTI IN EVIDENZA</h2>

            <div class="carousel-outer-container">
            
                <button type="button" class="carousel-arrow prev-btn hidden" id="prevBtn" aria-label="Precedente">
    				<i class="fa-solid fa-chevron-left"></i>
				</button>

                <div class="carousel-mask-wrapper">
                    <div class="products-carousel" id="productsCarousel">
        
                        <article class="product-card">
                            <div class="product-badges">
                                <img src="${pageContext.request.contextPath}/images/new-button.png" alt="New" class="new-button-img">
                                <button type="button" class="btn-wishlist" title="Wishlist-add">
                                    <i class="fa-regular fa-heart"></i>
                                </button>
                            </div>
                            <a href="${pageContext.request.contextPath}/prodotto" class="product-link">
                                <div class="product-image">
                                    <span>(IMG 1)</span>
                                </div>
                                <div class="product-price">
                                    <span>&euro; 15,00</span>
                                </div>
                            </a>
                        </article>
            
                        <article class="product-card">
                            <div class="product-badges">
                                <img src="${pageContext.request.contextPath}/images/new-button.png" alt="New" class="new-button-img">
                                <button type="button" class="btn-wishlist" title="Wishlist-add">
                                    <i class="fa-regular fa-heart"></i>
                                </button>
                            </div>
                            <a href="${pageContext.request.contextPath}/prodotto" class="product-link">
                                <div class="product-image">
                                    <span>(IMG 2)</span>
                                </div>
                                <div class="product-price">
                                    <span>&euro; 22,50</span>
                                </div>
                            </a>
                        </article>
            
                        <article class="product-card">
                            <div class="product-badges">
                                <img src="${pageContext.request.contextPath}/images/new-button.png" alt="New" class="new-button-img">
                                <button type="button" class="btn-wishlist" title="Wishlist-add">
                                    <i class="fa-regular fa-heart"></i>
                                </button>
                            </div>
                            <a href="${pageContext.request.contextPath}/prodotto" class="product-link">
                                <div class="product-image">
                                    <span>(IMG 3)</span>
                                </div>
                                <div class="product-price">
                                    <span>&euro; 12,00</span>
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
                                <div class="product-price">
                                    <span>&euro; 35,00</span>
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
                                    <span>(IMG 5)</span>
                                </div>
                                <div class="product-price">
                                    <span>&euro; 9,99</span>
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
                                    <span>(IMG 6)</span>
                                </div>
                                <div class="product-price">
                                    <span>&euro; 45,00</span>
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
                                    <span>(IMG 7)</span>
                                </div>
                                <div class="product-price">
                                    <span>&euro; 18,50</span>
                                </div>
                            </a>
                        </article>

                    </div>
                </div>

                <button type="button" class="carousel-arrow next-btn" id="nextBtn" aria-label="Successivo">
                    <i class="fa-solid fa-chevron-right"></i>
                </button>
                
            </div>
        </section>

        <section class="cta-section">
            <h2>INIZIA OGGI IL TUO VIAGGIO CREATIVO</h2>
            <div class="cta-buttons">
                <a href="${pageContext.request.contextPath}/login" class="btn-login">LOG IN</a>
                <a href="${pageContext.request.contextPath}/signup" class="btn-signup">SIGN UP</a>
            </div>
        </section>
        
        <div class="scroll-progress-nav" id="scrollProgressNav">
    		<div class="dot active" data-section="0" title="Hero"></div>
    		<div class="dot" data-section="1" title="Categorie"></div>
    		<div class="dot" data-section="2" title="Prodotti"></div>
    		<div class="dot" data-section="3" title="Inizia / Footer"></div>
    
    		<button type="button" class="btn-back-to-top" id="backToTopBtn" title="Torna su">
        		<i class="fa-solid fa-arrow-up"></i>
    		</button>
		</div>

		<%@ include file="WEB-INF/view/fragment/footer.jspf" %>

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
                
                // Freccia Sinistra: appare appena si scorre più di 5px verso destra
                if (scrollLeft > 249) {               	
                    prevBtn.classList.remove('hidden');
                } else {
                    prevBtn.classList.add('hidden');
                }

                // Freccia Destra: scompare solo quando si arriva alla fine del carosello
                if (scrollLeft >= maxScroll - 10) {
                    nextBtn.classList.add('hidden');
                } else {
                    nextBtn.classList.remove('hidden');
                }
            }

            // Click freccia destra (220px equivale a 1 card da 200px + gap 20px)
            nextBtn.addEventListener('click', function () {
                carousel.scrollBy({ left: 220, behavior: 'smooth' });
            });

            // Click freccia sinistra
            prevBtn.addEventListener('click', function () {
                carousel.scrollBy({ left: -220, behavior: 'smooth' });
            });

            // Eventi per aggiornare la visibilità delle frecce
            carousel.addEventListener('scroll', updateArrows);
            window.addEventListener('resize', updateArrows);

            // Controllo iniziale
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

        	// Click sui pallini
        	dots.forEach((dot, index) => {
            	dot.addEventListener('click', function () {
                	if (sections[index]) {
                    	sections[index].scrollIntoView({ behavior: 'smooth' });
                	}
            	});
        	});

        	// Click su Torna Su
        	if (backToTopBtn) {
            	backToTopBtn.addEventListener('click', function () {
                	main.scrollTo({ top: 0, behavior: 'smooth' });
            	});
        	}

        	// Calcolo dello Scroll
        	main.addEventListener('scroll', function () {
            	const scrollPosition = main.scrollTop;
            	const maxScroll = main.scrollHeight - main.clientHeight;
            	const sectionHeight = main.clientHeight;

            	let currentIndex = Math.round(scrollPosition / sectionHeight);

            	// Se siamo arrivati in fondo al footer, evidenzia l'ultimo pallino (sezione 4)
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