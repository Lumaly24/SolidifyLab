<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("titoloPagina", "Carrello"); %>
<%@ include file="fragment/header.jspf" %>

    <main class="cart-page-container">
        
        <h1>Il tuo Carrello</h1>
        <section class="cart-items-container">
            <article class="cart-item-card">
            
                <button class="btn-remove-item" title="Rimuovi dal carrello">
                    <i class="fa-solid fa-xmark"></i>
                </button>
                
                <div class="cart-item-image">
                    <span>(IMG)</span>
                </div>
                
                <div class="cart-item-details">
                    <h4>Nome Modello / Stampa</h4>
                    
                    <div class="cart-item-actions">
                        <span class="cart-item-price">€ 15,00</span>
                        
                        <div class="quantity-control">
                            <label for="qty1">Qtà:</label>
                            <input type="number" id="qty1" name="quantita" min="1" value="1" class="qty-input">
                        </div>
                    </div>
                </div>
            </article>

            <article class="cart-item-card">
                <button class="btn-remove-item" title="Rimuovi dal carrello">
                    <i class="fa-solid fa-xmark"></i>
                </button>
                <div class="cart-item-image"><span>(IMG)</span></div>
                <div class="cart-item-details">
                    <h4>Pack Textures Metallo</h4>
                    <div class="cart-item-actions">
                        <span class="cart-item-price">€ 12,00</span>
                        <div class="quantity-control">
                            <label for="qty2">Qtà:</label>
                            <input type="number" id="qty2" name="quantita" min="1" value="1" class="qty-input">
                        </div>
                    </div>
                </div>
            </article>

            <article class="cart-item-card">
                <button class="btn-remove-item" title="Rimuovi dal carrello">
                    <i class="fa-solid fa-xmark"></i>
                </button>
                <div class="cart-item-image"><span>(IMG)</span></div>
                <div class="cart-item-details">
                    <h4>Miniatura Guerriero (Stampa in resina)</h4>
                    <div class="cart-item-actions">
                        <span class="cart-item-price">€ 35,00</span>
                        <div class="quantity-control">
                            <label for="qty3">Qtà:</label>
                            <input type="number" id="qty3" name="quantita" min="1" value="2" class="qty-input">
                        </div>
                    </div>
                </div>
            </article>

        </section>

        <hr class="section-divider">

        <section class="cart-summary-layout">

            <div class="cart-summary-left">
                <div class="cart-total-box">
                    <h2>Totale: <span class="total-amount">€ 97,00</span></h2>
                </div>

                <div class="payment-methods-box">
                    <p>Metodo di Pagamento</p>
                    <div class="payment-icons-large">
                        <div class="pay-icon-placeholder"><i class="fa-brands fa-cc-visa"></i></div>
                        <div class="pay-icon-placeholder"><i class="fa-brands fa-cc-mastercard"></i></div>
                        <div class="pay-icon-placeholder"><i class="fa-brands fa-paypal"></i></div>
                        <div class="pay-icon-placeholder"><i class="fa-brands fa-cc-apple-pay"></i></div>
                    </div>
                </div>
            </div>

            <div class="cart-summary-right">
                
                <form action="${pageContext.request.contextPath}/applyDiscount" method="POST" class="discount-form">
                    <label for="promoCode">Hai un codice Sconto?</label>
                    <div class="discount-input-group">
                        <input type="text" id="promoCode" name="codice_sconto" placeholder="Es. SOLIDIFY20">
                        <button type="submit" class="btn-apply">APPLICA</button>
                    </div>
                </form>

                <div class="summary-details">
                    <p>Subtotale: <span>€ 97,00</span></p>
                    <p>Sconto applicato: <span>- € 0,00</span></p>
                    <p>Tasse (IVA 22% incl.): <span>€ 17,49</span></p>
                </div>

                <form action="${pageContext.request.contextPath}/checkoutServlet" method="POST" class="checkout-form">
                    <div class="form-group">
                        <label for="checkoutEmail">Indirizzo Mail (per ricevuta e asset):</label>
                        <input type="email" id="checkoutEmail" name="email" required>
                    </div>

                    <button type="submit" class="btn-primary btn-checkout">CONFERMA ORDINE</button>
                </form>

            </div>
            
        </section>

    </main>

<%@ include file="fragment/footer.jspf" %>
