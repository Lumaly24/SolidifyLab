<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<% request.setAttribute("titoloPagina", "La mia Wishlist"); 
	request.setAttribute("cssPagina", "wishlist.css");
%>

<%@ include file="fragment/header.jspf" %>

<main class="wishlist-page-container">
    
   <div id="customAlert" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px); z-index: 999999; justify-content: center; align-items: center;">
	    <div style="background: rgba(255, 255, 255, 0.65); backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.5); border-radius: 20px; padding: 30px; max-width: 380px; width: 85%; text-align: center; box-shadow: 0 8px 32px 0 rgba(0,0,0,0.3);">
	        <i class="fa-solid fa-circle-exclamation" style="font-size: 2.5rem; color: #e56399; margin-bottom: 15px;"></i>
	        <h3 style="font-family: 'elephant', sans-serif; font-weight: bold; margin-bottom: 10px; color: #e56399;">Attenzione!</h3>
	        <p id="customAlertText" style="font-family: 'coolveticarg', sans-serif; margin-bottom: 20px; color: #333;">Messaggio di errore</p>
	        
	        <div style="display: flex; gap: 10px; justify-content: center;">
	            <button type="button" class="btn-secondary" onclick="closeCustomAlert()" style="padding: 10px 20px; border-radius: 8px;">Annulla</button>
	            <button type="button" class="btn-primary auth-btn" id="customAlertConfirmBtn" style="padding: 10px 20px; border-radius: 8px;">Rimuovi</button>
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
    
    <div class="wishlist-header">
        <h1>La mia Wishlist <i class="fa-solid fa-heart"></i></h1>
    </div>

    <div class="catalog-layout">
        
        <!-- ================= SIDEBAR ================= -->
        <aside class="catalog-sidebar">
            <div class="filter-group">
                <h3>Filtra per Categoria</h3>
                <ul class="filter-list">
				    <li>
				        <label>
				            <input type="checkbox" name="tipo" value="3D" ${param.tipo == '3D' ? 'checked' : ''} onchange="window.location.href='${pageContext.request.contextPath}/Wishlist?tipo=3D'">Modelli 3D
				        </label>
				    </li>
				    <li>
				        <label>
				            <input type="checkbox" name="tipo" value="TEXTURES" ${param.tipo == 'TEXTURES' ? 'checked' : ''} onchange="window.location.href='${pageContext.request.contextPath}/Wishlist?tipo=TEXTURES'">Textures
				        </label>
				    </li>
				    <li>
				        <label>
				            <input type="checkbox" name="tipo" value="STAMPE" ${param.tipo == 'STAMPE' ? 'checked' : ''} onchange="window.location.href='${pageContext.request.contextPath}/Wishlist?tipo=STAMPE'">Stampe 3D
				        </label>
				    </li>
				</ul>
            </div>
        </aside>

        <!-- ================= MAIN CONTENT ================= -->
        <section class="catalog-main-content">
            <div class="collection-title">
                <h2>Tutti i salvataggi</h2>
                <p>Hai ${fn:length(listaWishlist)} elementi salvati in questa vista.</p>
            </div>

            <div class="catalog-products-grid">
                
                <c:choose>
                    <c:when test="${empty listaWishlist}">
                        <div class="empty-msg text-center w-100 mt-4">
                            <i class="fa-regular fa-heart" style="font-size: 3em; color: #e56299;"></i>
                            <h3>La tua wishlist è vuota.</h3>
                            <p>Esplora il catalogo e salva qui i tuoi progetti preferiti!</p>

                            <a href="${pageContext.request.contextPath}/Catalogo" class="btn-primary mt-3">Vai al Catalogo</a>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <c:forEach var="item" items="${listaWishlist}">
                            <article class="product-card">
                                
                                <div class="product-badges">
                                    <form action="${pageContext.request.contextPath}/AddtoWishlist" method="POST" class="inline-form" id="remove-form-${item.id}">
									    <input type="hidden" name="id_prodotto" value="${item.id}">
									    <button type="button" class="btn-wishlist text-red" title="Rimuovi" onclick="showConfirmAlert('Vuoi davvero rimuovere questo prodotto dalla tua wishlist?', 'remove-form-${item.id}')">
									        <i class="fa-solid fa-trash-can" style="color: #ff4d4d;"></i>
									    </button>
									</form>
                                </div>
                                
                                <a href="${pageContext.request.contextPath}/DettaglioProdottoServlet?id=${item.id}" class="product-link">
                                    <div class="product-image">
                                     
                                        <img src="${pageContext.request.contextPath}/images/prodotti/${item.immagineCopertinaUrl}" alt="${item.nome}" style="max-width: 100%; border-radius: 8px;">
                                    </div>
                                    <div class="product-info-minimal">
                                        <h4 class="product-title">${item.nome}</h4>
                                        <div class="product-price">€ <fmt:formatNumber value="${item.prezzoCorrente}" pattern="#,##0.00"/></div>
                                    </div>
                                </a>
                                
                                <form action="${pageContext.request.contextPath}/AggiungiAlCarrelloServlet" method="POST">
                                    <input type="hidden" name="id_prodotto" value="${item.id}">
                                    <input type="hidden" name="quantita" value="1">
                                    <button type="submit" class="btn-primary w-100 btn-bottom-rounded">
                                        <i class="fa-solid fa-cart-plus"></i> AL CARRELLO
                                    </button>
                                </form>
                                
                            </article>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                
            </div>
        </section>
        
    </div>
</main>

<script>
    function clearErrors() {
        document.querySelectorAll('.error-msg').forEach(el => el.innerText = '');
        document.querySelectorAll('.input-error').forEach(el => el.classList.remove('input-error'));
    }

    function showConfirmAlert(message, formId) {
        const modal = document.getElementById('customAlert');
        const modalText = document.getElementById('customAlertText');
        const confirmBtn = document.getElementById('customAlertConfirmBtn');

        if (modal && modalText && confirmBtn) {
            modalText.innerText = message;
            modal.style.display = 'flex';
            
            confirmBtn.onclick = function() {
                document.getElementById(formId).submit();
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

<%@ include file="fragment/footer.jspf" %>