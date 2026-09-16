<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Se il carrello è vuoto, rimbalziamo l'utente --%>
<c:if test="${empty sessionScope.carrello.prodotti}">
    <c:redirect url="/Carrello"/>
</c:if>

<% request.setAttribute("titoloPagina", "Checkout Sicuro"); 
   request.setAttribute("cssPagina", "carrello.css"); 
%>
<%@ include file="fragment/header.jspf" %>

<main class="cart-page-container">
    
    <div class="cart-header-actions checkout-header-title">
        <h1>Checkout Sicuro <i class="fa-solid fa-lock checkout-lock-icon"></i></h1>
    </div>

    <section class="cart-summary-layout checkout-layout">
        
        <div class="cart-summary-left">
        
            <div class="cart-total-box checkout-total-box">
                <h2>Da Pagare: <span class="total-amount">€ <fmt:formatNumber value="${sessionScope.carrello.totaleFinale}" pattern="#,##0.00"/></span></h2>
            </div>
            
            <hr class="section-divider">
            
            <div class="summary-details">
                <p><strong>Articoli nel carrello:</strong> <span>${sessionScope.carrello.prodotti.size()}</span></p>
                <p><strong>Email ricevuta:</strong> <span>${param.email}</span></p>
            </div>
            
            <div class="payment-methods-box checkout-methods-box">
            
                <div class="payment-icons-large">
                    <i class="fa-brands fa-cc-visa"></i>
                    <i class="fa-brands fa-cc-mastercard"></i>
                    <i class="fa-brands fa-cc-apple-pay"></i>
                </div>
                
            </div>
        </div>

        <div class="cart-summary-right">
            <form action="${pageContext.request.contextPath}/ElaboraPagamentoServlet" method="POST" class="checkout-form">
                
                <input type="hidden" name="email_ordine" value="${param.email}">

                <label for="nomeCarta">Nome sulla Carta</label>
                
                <div class="discount-input-group">
                    <input type="text" id="nomeCarta" name="nome_carta" placeholder="Es. Mario Rossi" required>
                </div>
                
                <label for="numeroCarta">Numero Carta</label>
                
                <div class="discount-input-group">
                    <input type="text" id="numeroCarta" name="numero_carta" placeholder="1234 5678 9101 1121" maxlength="16" required>
                </div>
                
                <div class="card-details-row">
                    <div class="card-details-col">
                        <label for="scadenza">Scadenza</label>
                        <input type="text" id="scadenza" name="scadenza" placeholder="MM/AA" maxlength="5" required>
                    </div>
                    
                    <div class="card-details-col">
                        <label for="cvv">CVV</label>
                        <input type="password" id="cvv" name="cvv" placeholder="***" maxlength="3" required>
                    </div>
                </div>

                <button type="submit" class="btn-primary btn-checkout btn-checkout-submit">
                    <i class="fa-solid fa-credit-card"></i> PAGA ORA
                </button>
                
            </form>
        </div>
    </section> 

</main>

<%@ include file="fragment/footer.jspf" %>