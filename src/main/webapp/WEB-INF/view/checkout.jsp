<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- Sicurezza Base: Se il carrello è vuoto, non ha senso stare nel checkout -->
<c:if test="${empty sessionScope.carrello.prodotti}">
    <c:redirect url="carrello.jsp" />
</c:if>

<% request.setAttribute("titoloPagina", "Checkout Sicuro"); %>
<%@ include file="fragment/header.jspf" %>

    <main class="checkout-page-container">
        
        <div class="checkout-layout">
            <section class="checkout-details-side">
                <h2>Dettagli Fatturazione e Spedizione</h2>
                
                <!-- CHECKLIST: onsubmit per validare con JS -->
                <form id="checkoutForm" action="${pageContext.request.contextPath}/processOrderServlet" method="POST" onsubmit="return validaCheckout()">
                    
                    <fieldset class="form-section">
                        <legend><i class="fa-solid fa-user"></i> Informazioni Personali</legend>
                        
                        <div class="form-row">
                            <div class="form-group half-width">
                                <label for="chkNome">Nome</label>
                                <input type="text" id="chkNome" name="nome" value="${sessionScope.utenteLoggato.nome}">
                                <span class="error-msg" id="err-nome"></span>
                            </div>
                            <div class="form-group half-width">
                                <label for="chkCognome">Cognome</label>
                                <input type="text" id="chkCognome" name="cognome" value="${sessionScope.utenteLoggato.cognome}">
                                <span class="error-msg" id="err-cognome"></span>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="chkEmail">Email </label>
                            <input type="email" id="chkEmail" name="email" value="${sessionScope.utenteLoggato.email}">
                            <span class="error-msg" id="err-email"></span>
                        </div>
                    </fieldset>

                    <fieldset class="form-section">
                        <legend><i class="fa-solid fa-location-dot"></i> Indirizzo di Spedizione</legend>
                        
                        <div class="form-group">
                            <label for="chkIndirizzo">Indirizzo </label>
                            <input type="text" id="chkIndirizzo" name="indirizzo" value="${sessionScope.utenteLoggato.indirizzo}">
                            <span class="error-msg" id="err-indirizzo"></span>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group half-width">
                                <label for="chkCitta">Città</label>
                                <input type="text" id="chkCitta" name="citta" value="${sessionScope.utenteLoggato.citta}">
                                <span class="error-msg" id="err-citta"></span>
                            </div>
                            <div class="form-group half-width">
                                <label for="chkCap">CAP</label>
                                <input type="text" id="chkCap" name="cap" value="${sessionScope.utenteLoggato.cap}">
                                <span class="error-msg" id="err-cap"></span>
                            </div>
                        </div>
                    </fieldset>

                    <fieldset class="form-section payment-section">
                        <legend><i class="fa-solid fa-credit-card"></i> Metodo di Pagamento</legend>
                        
                        <div class="payment-options">
                            <label class="pay-radio">
                                <!-- Aggiunto onchange per mostrare/nascondere la carta -->
                                <input type="radio" name="metodo_pagamento" value="carta" checked onchange="toggleCardDetails()">
                                <span>Carta di Credito <i class="fa-brands fa-cc-visa"></i> <i class="fa-brands fa-cc-mastercard"></i></span>
                            </label>
                            <label class="pay-radio">
                                <input type="radio" name="metodo_pagamento" value="paypal" onchange="toggleCardDetails()">
                                <span>PayPal <i class="fa-brands fa-paypal"></i></span>
                            </label>
                        </div>

                        <!-- Dettagli della carta -->
                        <div class="credit-card-details" id="cardDetailsBox">
                            <div class="form-group">
                                <label for="ccNome">Nome sulla carta</label>
                                <input type="text" id="ccNome" name="cc_nome">
                                <span class="error-msg" id="err-ccnome"></span>
                            </div>
                            <div class="form-group">
                                <label for="ccNumero">Numero Carta</label>
                                <input type="text" id="ccNumero" name="cc_numero" placeholder="1234567812345678" maxlength="16">
                                <span class="error-msg" id="err-ccnumero"></span>
                            </div>
                            <div class="form-row">
                                <div class="form-group half-width">
                                    <label for="ccScadenza">Scadenza</label>
                                    <input type="text" id="ccScadenza" name="cc_scadenza" placeholder="MM/AA" maxlength="5">
                                    <span class="error-msg" id="err-ccscadenza"></span>
                                </div>
                                <div class="form-group half-width">
                                    <label for="ccCvv">CVV</label>
                                    <input type="text" id="ccCvv" name="cc_cvv" placeholder="123" maxlength="3">
                                    <span class="error-msg" id="err-cccvv"></span>
                                </div>
                            </div>
                        </div>
                    </fieldset>
                    
                    <!-- Bottone invisibile che riceve il click dalla sidebar -->
                    <button type="submit" id="realSubmitBtn"></button>

                </form>
            </section>

            <aside class="checkout-summary-side">
                <div class="summary-box">
                    <h2>Riepilogo Ordine</h2>
                    
                    <div class="summary-items">
                        <c:forEach var="item" items="${sessionScope.carrello.prodotti}">
                            <div class="summary-item">
                                <div class="item-info">
                                    <strong>${item.quantita}x</strong> <c:out value="${item.prodotto.nome}"/>
                                </div>
                                <div class="item-price">
                                    € <fmt:formatNumber value="${item.prodotto.prezzo * item.quantita}" pattern="#,##0.00"/>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <hr class="dashed-divider">
                    
                    <div class="summary-totals">
                        <p>Subtotale: <span>€ <fmt:formatNumber value="${sessionScope.carrello.subtotale}" pattern="#,##0.00"/></span></p>
                        <c:if test="${sessionScope.carrello.speseSpedizione > 0}">
                            <p>Spedizione: <span>€ <fmt:formatNumber value="${sessionScope.carrello.speseSpedizione}" pattern="#,##0.00"/></span></p>
                        </c:if>

                        <h3 class="final-total">Totale: <span>€ <fmt:formatNumber value="${sessionScope.carrello.totaleFinale}" pattern="#,##0.00"/></span></h3>
                    </div>
                    
                    <!-- Questo bottone aziona il form a sinistra -->
                    <button type="button" class="btn-primary btn-large btn-pay-now" onclick="document.getElementById('realSubmitBtn').click();">
                        PAGA E COMPLETA L'ORDINE
                    </button>
                    <p class="secure-note"><i class="fa-solid fa-shield-halved"></i> I tuoi pagamenti sono crittografati e sicuri al 100%.</p>
                </div>
            </aside>

        </div>
    </main>

    <!-- SCRIPT PER VALIDAZIONE E DINAMISMO UI -->
    <script>
        // Funzione per nascondere i campi della carta se si sceglie PayPal
        function toggleCardDetails() {
            const isCard = document.querySelector('input[name="metodo_pagamento"][value="carta"]').checked;
            const cardBox = document.getElementById('cardDetailsBox');
            if(isCard) {
                cardBox.style.display = 'block';
            } else {
                cardBox.style.display = 'none';
            }
        }

        // REQUISITO CHECKLIST: Validazione JS con Regex e Messaggi Inline
        function validaCheckout() {
            let isValid = true;
            
            // Pulisce i messaggi precedenti
            document.querySelectorAll('.error-msg').forEach(el => el.innerText = '');

            // 1. Validazione CAP (Esattamente 5 numeri)
            const cap = document.getElementById('chkCap').value.trim();
            const regexCap = /^[0-9]{5}$/;
            if (!regexCap.test(cap)) {
                document.getElementById('err-cap').innerText = 'Inserisci un CAP valido (5 cifre).';
                isValid = false;
            }

            // 2. Validazione Carta (Solo se è selezionata l'opzione carta)
            const isCard = document.querySelector('input[name="metodo_pagamento"][value="carta"]').checked;
            
            if (isCard) {
                // Numero Carta (Esattamente 16 numeri)
                const ccNum = document.getElementById('ccNumero').value.trim();
                const regexCC = /^[0-9]{16}$/;
                if(!regexCC.test(ccNum)) {
                    document.getElementById('err-ccnumero').innerText = 'Il numero della carta deve contenere 16 cifre.';
                    isValid = false;
                }

                // Scadenza (Formato MM/AA)
                const ccExp = document.getElementById('ccScadenza').value.trim();
                const regexExp = /^(0[1-9]|1[0-2])\/\d{2}$/; // Mese da 01 a 12, poi "/", poi due cifre
                if(!regexExp.test(ccExp)) {
                    document.getElementById('err-ccscadenza').innerText = 'Formato non valido (usa MM/AA).';
                    isValid = false;
                }

                // CVV (Esattamente 3 numeri)
                const ccCvv = document.getElementById('ccCvv').value.trim();
                const regexCvv = /^[0-9]{3}$/;
                if(!regexCvv.test(ccCvv)) {
                    document.getElementById('err-cccvv').innerText = 'CVV errato (3 cifre).';
                    isValid = false;
                }
            }

            // CHECKLIST: Messaggio di conferma prima dell'azione irreversibile
            if(isValid) {
                return confirm("Stai per completare l'ordine. Confermi i dati inseriti?");
            }

            return isValid; // Se false, blocca l'invio e mostra gli errori rossi
        }
    </script>

<%@ include file="fragment/footer.jspf" %>