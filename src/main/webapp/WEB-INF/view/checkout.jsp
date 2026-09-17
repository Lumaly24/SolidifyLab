<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:if test="${empty sessionScope.carrello.prodotti}">
    <c:redirect url="/Carrello"/>
</c:if>

<% request.setAttribute("titoloPagina", "Checkout Sicuro"); 
   request.setAttribute("cssPagina", "carrello.css"); 
%>
<%@ include file="fragment/header.jspf" %>

<main class="cart-page-container">
    
    <div class="cart-header-actions checkout-header-title">
        <h1>Checkout</h1>
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
            
            <c:if test="${not empty erroreCheckout}">
                <div style="color: red; margin-bottom: 15px; font-weight: bold;">
                    ${erroreCheckout}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/ElaboraPagamentoServlet" method="POST" class="checkout-form">
                
                <input type="hidden" name="email_ordine" value="${param.email}">

                <label for="nomeCarta">Nome sulla Carta</label>
                <div class="discount-input-group">
                   
                    <input type="text" id="nomeCarta" name="nome_carta" placeholder="Es. Elizabeth Taylor" 
                           oninput="this.value = this.value.replace(/[^a-zA-Z\s]/g, '')" required>
                </div>
                
                <label for="numeroCarta">Numero Carta</label>
                <div class="discount-input-group">
                 
                    <input type="text" id="numeroCarta" name="numero_carta" placeholder="1234 5678 9876 5432" 
                           maxlength="19" oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                </div>
                
                <div class="card-details-row">
                    <div class="card-details-col">
                        <label for="scadenza">Scadenza</label>
                       
                        <input type="text" id="scadenza" name="scadenza" placeholder="MM/AA" 
                               maxlength="5" required>
                    </div>
                    
                    <div class="card-details-col">
                        <label for="cvv">CVV</label>
                    
                        <input type="password" id="cvv" name="cvv" placeholder="***" 
                               maxlength="3" oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                    </div>
                </div>

                <button type="submit" class="btn-primary btn-checkout btn-checkout-submit">
                    <i class="fa-solid fa-credit-card"></i> ACQUISTA
                </button>
                
            </form>
        </div>
    </section> 

</main>

<script>

    document.getElementById('scadenza').addEventListener('input', function(e) {
    	
        let input = e.target.value.replace(/\D/g, ''); 
        if (input.length > 4) input = input.substring(0, 4); 
        
        if (input.length > 2) {
            e.target.value = input.substring(0, 2) + '/' + input.substring(2);
        } else {
            e.target.value = input;
        }
    });
    
    const cardInput = document.getElementById('numeroCarta');
    
    cardInput.addEventListener('input', (e) => {
    	
    	let value = e.target.value.replace(/\D/g, '');
    	
    	let formattedValue = value.replace(/(\d{4})(?=\d)/g, '$1 ');
    
    	e.target.value = formattedValue;
    });
</script>

<%@ include file="fragment/footer.jspf" %>