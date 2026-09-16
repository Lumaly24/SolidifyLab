<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<% request.setAttribute("titoloPagina", "Carrello"); 
	request.setAttribute("cssPagina", "carrello.css");
%>

<%@ include file="fragment/header.jspf" %>

    <main class="cart-page-container">
    
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
        
        <c:choose>
            <c:when test="${empty sessionScope.carrello.prodotti}">

                <div class="empty-cart-msg">
                    <i class="fa-solid fa-cart-arrow-down"></i>
                    <h2>Il tuo carrello è vuoto.</h2>
                    <p>Non hai ancora aggiunto nessun modello o texture.</p>
                    <a href="${pageContext.request.contextPath}/Catalogo" class="btn-primary mt-3">VAI AL CATALOGO</a>
                </div>
            </c:when>
            
            <c:otherwise>
            
                <div class="cart-header-actions">
                    <h1>Il tuo Carrello</h1>
                    
                    <form action="${pageContext.request.contextPath}/AddtoCart" method="POST" id="empty-cart-form">
                    
					    <input type="hidden" name="azione" value="svuota_carrello">
					    
					    <button type="button" class="btn-outline-small" onclick="showConfirmAlert('Sei sicuro di voler svuotare completamente il carrello?', 'empty-cart-form')">
					        <i class="fa-solid fa-trash-can"></i> Svuota Carrello
					    </button>
					    
					</form>
					
				</div>

                <section class="cart-items-container">
                    
                    <c:forEach var="item" items="${sessionScope.carrello.prodotti}">
                    
					    <article class="cart-item-card">
    
						    <form action="${pageContext.request.contextPath}/AddtoCart" method="POST" class="remove-form-container" id="remove-form-${item.prodotto.id}">
						        <input type="hidden" name="id_prodotto" value="${item.prodotto.id}">
						        <input type="hidden" name="azione" value="rimuovi_carrello">
						        
						        <button type="button" class="btn-remove-item" title="Rimuovi dal carrello" onclick="showConfirmAlert('Sei sicuro di voler rimuovere questo prodotto dal carrello?', 'remove-form-${item.prodotto.id}')">
						            <i class="fa-solid fa-xmark"></i>
						        </button>
						    </form>
						    
						    <a href="${pageContext.request.contextPath}/Prodotto?id=${item.prodotto.id}" style="text-decoration: none; color: inherit; display: block;">
						        <div class="cart-item-image">
						        
						            <img src="${pageContext.request.contextPath}/product_images/${item.prodotto.immagineCopertinaUrl}" 
									     alt="${item.prodotto.nome}" 
									     style="width: 100%; border-radius: 8px; object-fit: cover;" />
									         
						        </div>
						    </a>
						    
						    <div class="cart-item-details">
						        <a href="${pageContext.request.contextPath}/Prodotto?id=${item.prodotto.id}" style="text-decoration: none; color: inherit;">
						            <h4 style="margin: 0;"><c:out value="${item.prodotto.nome}"/></h4>
						        </a>
						        
						        <div class="cart-item-actions">
						            <span class="cart-item-price">€ <fmt:formatNumber value="${item.prodotto.prezzoCorrente}" pattern="#,##0.00"/></span>
						            
						            <c:choose>
						                <c:when test="${item.prodotto.categoriaId == 3}">
						                    <form action="${pageContext.request.contextPath}/AggiornaQuantitaServlet" method="POST">
						                        <input type="hidden" name="id_prodotto" value="${item.prodotto.id}">
						                        <div class="quantity-control">
						                            <label for="qty_${item.prodotto.id}">Qtà:</label>
						                            <input type="number" id="qty_${item.prodotto.id}" name="quantita" min="1" value="${item.quantita}" class="qty-input" onchange="this.form.submit()">
						                        </div>
						                    </form>
						                </c:when>
						                <c:otherwise>
						                    <div class="quantity-control">
						                        <span>Qtà: 1</span>
						                    </div>
						                </c:otherwise>
						            </c:choose>
						        </div>
						    </div>
					</article>
					</c:forEach>

                </section>

                <hr class="section-divider">

                <section class="cart-summary-layout">

                    <div class="cart-summary-left">
                        <div class="cart-total-box">
                            <h2>Totale: <span class="total-amount">€ <fmt:formatNumber value="${sessionScope.carrello.totaleFinale}" pattern="#,##0.00"/></span></h2>
                        </div>

                        <div class="payment-methods-box">
                            <p>Metodi di Pagamento accettati</p>
                            <div class="payment-icons-large">
                                <div class="pay-icon-placeholder"><i class="fa-brands fa-cc-visa"></i></div>
                                <div class="pay-icon-placeholder"><i class="fa-brands fa-cc-mastercard"></i></div>
                                <div class="pay-icon-placeholder"><i class="fa-brands fa-paypal"></i></div>
                                <div class="pay-icon-placeholder"><i class="fa-brands fa-cc-apple-pay"></i></div>
                            </div>
                        </div>
                    </div>

                    <div class="cart-summary-right">
                        
                        <form action="${pageContext.request.contextPath}/ApplicaScontoServlet" method="POST" class="discount-form">
                            <label for="promoCode">Hai un codice Sconto?</label>
                            <div class="discount-input-group">
                                <input type="text" id="promoCode" name="codice_sconto" placeholder="Es. SOLIDIFY20">
                                <button type="submit" class="btn-apply">APPLICA</button>
                            </div>
                        </form>

                        <div class="summary-details">
                            <p>Subtotale: <span>€ <fmt:formatNumber value="${sessionScope.carrello.subtotale}" pattern="#,##0.00"/></span></p>
                            <p>Sconto applicato: <span>- € <fmt:formatNumber value="${sessionScope.carrello.sconto}" pattern="#,##0.00"/></span></p>
                            <p>Tasse (IVA 22% incl.): <span>€ <fmt:formatNumber value="${sessionScope.carrello.tasse}" pattern="#,##0.00"/></span></p>
                        </div>

						<form action="${pageContext.request.contextPath}/Checkout" method="GET" class="checkout-form">
						    <div class="form-group">
						        <label for="checkoutEmail">Indirizzo Mail (per ricevuta e asset):</label>
						        <input type="email" id="checkoutEmail" name="email" value="${sessionScope.utenteLoggato.email}" required>
						    </div>
						
						    <button type="submit" class="btn-primary btn-checkout">CONFERMA ORDINE <i class="fa-solid fa-arrow-right"></i></button>
						</form>

                    </div>
                    
                </section> 
                
            </c:otherwise>
        </c:choose>
        
        <script>
        
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

        function closeCustomAlert() {
            const modal = document.getElementById('customAlert');
            if (modal) {
                modal.style.display = 'none';
            }
        }
    </script>

    </main>

<%@ include file="fragment/footer.jspf" %>