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
<hr class="section-divider">
        <section class="categories-section">
		    <h2>CATEGORIE PRINCIPALI</h2>
		    <div class="categories-grid">
		        <a href="${pageContext.request.contextPath}/catalogo" class="category-card">
		            <div class="card-img-container">
		                <img src="" alt="Modelli 3D"> <!--placeholder-->
		            </div>
		            <div class="card-info">
		                <h3>Modelli 3D</h3>
		                <p></p> <!--da riempire-->
		            </div>
		        </a>

		        <a href="${pageContext.request.contextPath}/catalogo" class="category-card">
		            <div class="card-img-container">
		                <img src="" alt="Textures"> <!--placeholder-->
		            </div>
		            <div class="card-info">
		                <h3>Textures</h3>
		                <p></p> <!--da riempire-->
		            </div>
		        </a>

		        <a href="${pageContext.request.contextPath}/stampe" class="category-card">
		            <div class="card-img-container">
		                <img src="" alt="Stampe 3D"> <!--placeholder-->
		            </div>
		            <div class="card-info">
		                <h3>Stampe 3D</h3>
		                <p></p> <!--da riempire-->
		            </div>
		        </a>

    		</div>
		</section>
<hr class="section-divider">
        <section class="featured-products-section">
            <h2>PRODOTTI IN EVIDENZA</h2>

            <div class="products-carousel">
            
                <article class="product-card">
                    <div class="product-badges">
                        <span class="badge-new">new</span>
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
                        <span class="badge-new">new</span>
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
                        <span class="badge-new">new</span>
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
        </section>
<hr class="section-divider">
        <section class="cta-section">
            <h2>INIZIA OGGI IL TUO VIAGGIO CREATIVO</h2>
            <div class="cta-buttons">
                <a href="${pageContext.request.contextPath}/login" class="btn-login">LOG IN</a>
                <a href="${pageContext.request.contextPath}/signup" class="btn-signup">SIGN UP</a>
            </div>
        </section>

    </main>
<hr class="section-divider">

<%@ include file="WEB-INF/view/fragment/footer.jspf" %>