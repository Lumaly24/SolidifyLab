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
                
                <c:if test="${not empty param.spedizione_via}">
                    <hr style="border: 0; border-top: 1px solid rgba(0,0,0,0.1); margin: 10px 0;">
                    <p style="margin-bottom: 5px;"><strong>Spedizione a:</strong></p>
                    <p style="font-size: 0.9rem; line-height: 1.4; color: #555;">
                        ${param.spedizione_via} ${param.spedizione_civico} <br>
                        ${param.spedizione_citta}, ${param.spedizione_provincia} - ${param.spedizione_cap}
                    </p>
                </c:if>
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

            <form action="${pageContext.request.contextPath}/ElaboraPagamentoServlet" method="POST" class="checkout-form" onsubmit="return validaScadenza(event)">
                
                <input type="hidden" name="email_ordine" value="${param.email}">
                
                <c:if test="${not empty param.spedizione_via}">
                    <input type="hidden" name="spedizione_via" value="${param.spedizione_via}">
                    <input type="hidden" name="spedizione_civico" value="${param.spedizione_civico}">
                    <input type="hidden" name="spedizione_citta" value="${param.spedizione_citta}">
                    <input type="hidden" name="spedizione_cap" value="${param.spedizione_cap}">
                    <input type="hidden" name="spedizione_provincia" value="${param.spedizione_provincia}">
                </c:if>

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
    
    function validaScadenza(event) {
        const scadenzaInput = document.getElementById('scadenza');
        const valore = scadenzaInput.value;
        
        const erroreEsistente = document.getElementById('errore-scadenza');
        if (erroreEsistente) erroreEsistente.remove();
        scadenzaInput.style.borderColor = 'rgba(0, 0, 0, 0.15)'; 

        if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(valore)) {
            mostraErrore(scadenzaInput, 'Formato non valido (MM/AA).');
            event.preventDefault();
            return false;
        }

        const parti = valore.split('/');
        const meseInput = parseInt(parti[0], 10);

        const annoInput = 2000 + parseInt(parti[1], 10); 

        const oggi = new Date(); 
        const meseOggi = oggi.getMonth() + 1; 
        const annoOggi = oggi.getFullYear(); 

        if (annoInput < annoOggi) {
            mostraErrore(scadenzaInput, 'Carta scaduta.');
            event.preventDefault();
            return false;
        }

        if (annoInput === annoOggi && meseInput < meseOggi) {
            mostraErrore(scadenzaInput, 'Carta scaduta.');
            event.preventDefault();
            return false;
        }

        return true; 
    }

    function mostraErrore(elemento, messaggio) {
        elemento.style.borderColor = 'red';
        const divErrore = document.createElement('div');
        divErrore.id = 'errore-scadenza';
        divErrore.style.color = 'red';
        divErrore.style.fontSize = '0.75rem';
        divErrore.style.marginTop = '4px';
        divErrore.textContent = messaggio;
        elemento.parentNode.appendChild(divErrore); 
    }
</script>

<%@ include file="fragment/footer.jspf" %>