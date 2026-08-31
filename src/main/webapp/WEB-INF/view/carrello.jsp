<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Taglib obbligatorie per far funzionare i cicli e la formattazione dei prezzi -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<% request.setAttribute("titoloPagina", "Carrello"); 
	request.setAttribute("cssPagina", "carrello.css");
%>
<%@ include file="fragment/header.jspf" %>

    <main class="cart-page-container">
        
        <!-- CONTROLLO: Il carrello è vuoto? -->
        <c:choose>
            <c:when test="${empty sessionScope.carrello.prodotti}">
                <!-- VISTA CARRELLO VUOTO -->
                <div class="empty-cart-msg">
                    <i class="fa-solid fa-cart-arrow-down"></i>
                    <h2>Il tuo carrello è vuoto.</h2>
                    <p>Non hai ancora aggiunto nessun modello o texture.</p>
                    <a href="${pageContext.request.contextPath}/CatalogoServlet" class="btn-primary mt-3">VAI AL CATALOGO</a>
                </div>
            </c:when>
            
            <c:otherwise>
                <!-- VISTA CARRELLO PIENO -->
                
                <!-- Intestazione con Titolo e Tasto Svuota Carrello -->
                <div class="cart-header-actions">
                    <h1>Il tuo Carrello</h1>
                    
                    <!-- TASTO SVUOTA CARRELLO -->
                    <form action="${pageContext.request.contextPath}/SvuotaCarrelloServlet" method="POST">
                        <button type="submit" class="btn-outline-small" onclick="return confirm('Sei sicuro di voler svuotare completamente il carrello?');">
                            <i class="fa-solid fa-trash-can"></i> Svuota Carrello
                        </button>
                    </form>
                </div>

                <section class="cart-items-container">
                    
                    <!-- CICLO JSP: Stampa dinamicamente i prodotti nel carrello -->
                    <c:forEach var="item" items="${sessionScope.carrello.prodotti}">
                        <article class="cart-item-card">
                        
                            <!-- CHECKLIST: Conferma prima di cancellare un prodotto -->
                            <form action="${pageContext.request.contextPath}/RimuoviDalCarrelloServlet" method="POST">
                                <input type="hidden" name="id_prodotto" value="${item.prodotto.id}">
                                <button type="submit" class="btn-remove-item" title="Rimuovi dal carrello" onclick="return confirm('Sei sicuro di voler rimuovere questo prodotto dal carrello?');">
                                    <i class="fa-solid fa-xmark"></i>
                                </button>
                            </form>
                            
                            <div class="cart-item-image">
                                <span>(IMG)</span>
                            </div>
                            
                            <div class="cart-item-details">
                                <h4><c:out value="${item.prodotto.nome}"/></h4>
                                
                                <div class="cart-item-actions">
                                    <span class="cart-item-price">€ <fmt:formatNumber value="${item.prodotto.prezzo}" pattern="#,##0.00"/></span>
                                    
                                    <!-- Controllo quantità modificabile -->
                                    <form action="${pageContext.request.contextPath}/AggiornaQuantitaServlet" method="POST">
                                        <input type="hidden" name="id_prodotto" value="${item.prodotto.id}">
                                        <div class="quantity-control">
                                            <label for="qty_${item.prodotto.id}">Qtà:</label>
                                            <input type="number" id="qty_${item.prodotto.id}" name="quantita" min="1" value="${item.quantita}" class="qty-input" onchange="this.form.submit()">
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </article>
                    </c:forEach>

                </section>

                <hr class="section-divider">

                <!-- SEZIONE RIEPILOGO E PAGAMENTO -->
                <section class="cart-summary-layout">

                    <!-- Colonna Sinistra (Totale e Icone Carte) -->
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

                    <!-- Colonna Destra (Sconto, Riepilogo Dettagliato e Conferma) -->
                    <div class="cart-summary-right">
                        
                        <!-- Form Codice Sconto -->
                        <form action="${pageContext.request.contextPath}/ApplicaScontoServlet" method="POST" class="discount-form">
                            <label for="promoCode">Hai un codice Sconto?</label>
                            <div class="discount-input-group">
                                <input type="text" id="promoCode" name="codice_sconto" placeholder="Es. SOLIDIFY20">
                                <button type="submit" class="btn-apply">APPLICA</button>
                            </div>
                        </form>

                        <!-- Dettaglio Costi -->
                        <div class="summary-details">
                            <p>Subtotale: <span>€ <fmt:formatNumber value="${sessionScope.carrello.subtotale}" pattern="#,##0.00"/></span></p>
                            <p>Sconto applicato: <span>- € <fmt:formatNumber value="${sessionScope.carrello.sconto}" pattern="#,##0.00"/></span></p>
                            <p>Tasse (IVA 22% incl.): <span>€ <fmt:formatNumber value="${sessionScope.carrello.tasse}" pattern="#,##0.00"/></span></p>
                        </div>

                        <!-- TASTO CONFERMA ORDINE (Manda al Checkout) -->
                        <form action="${pageContext.request.contextPath}/checkout.jsp" method="GET" class="checkout-form">
                            <div class="form-group">
                                <label for="checkoutEmail">Indirizzo Mail (per ricevuta e asset):</label>
                                <!-- Precompila l'email se l'utente è loggato -->
                                <input type="email" id="checkoutEmail" name="email" value="${sessionScope.utenteLoggato.email}" required>
                            </div>

                            <button type="submit" class="btn-primary btn-checkout">CONFERMA ORDINE <i class="fa-solid fa-arrow-right"></i></button>
                        </form>

                    </div>
                    
                </section>
                
            </c:otherwise>
        </c:choose>

    </main>

<%@ include file="fragment/footer.jspf" %>