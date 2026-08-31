<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<% 
    request.setAttribute("titoloPagina", "Gestione Commissioni"); 
%>

<%@ include file="fragment/header.jspf" %>

<main class="admin-dashboard">
    <h1>Pannello di Controllo Commissioni</h1>
    <p>Clicca su "Vedi Dettagli" per leggere la richiesta e sbloccare le azioni.</p>

    <div class="card-grid">
        
        <!-- CICLO JSTL PER GENERARE LE CARD DINAMICAMENTE -->
        <c:forEach var="commissione" items="${requestScope.commissioniList}">
            
            <div class="commission-card" id="card-${commissione.id}">
                <div class="card-header">
                    <span class="card-title">Ordine #${commissione.id}</span>
                    
                    <div class="badge-container">
                        <span class="badge type-badge"><c:out value="${commissione.tipi}" /></span>
                        <span class="badge status-badge status-${fn:toLowerCase(commissione.stato)}">
                            <c:out value="${commissione.stato}" />
                        </span>
                    </div>
                </div>
                
                <div class="card-body">
                    <p><strong>Cliente:</strong> <c:out value="${commissione.email}" /></p>
                    <p><strong>Data:</strong> <fmt:formatDate value="${commissione.dataRichiesta}" pattern="dd/MM/yyyy HH:mm" /></p>
                </div>
                
                <!-- Tasto per aprire i dettagli (passiamo tutti i parametri necessari a JS) -->
                <button type="button" class="btn-details" 
                        onclick="openDetailsModal('${commissione.id}', '${commissione.email}', '${commissione.tipi}', '${fn:escapeXml(commissione.descrizione)}', '${fn:escapeXml(commissione.indirizzoSpedizione)}')">
                    Vedi Dettagli
                </button>
                
                <!-- BOTTONI AZIONE: Se non è visionata, aggiungiamo la classe per nasconderli -->
                <div class="card-actions ${!commissione.visionata ? 'hidden-actions' : ''}" id="actions-${commissione.id}">
                    <button type="button" class="btn-action btn-accept" onclick="showConfirm('${commissione.id}', 'accetta')">Accetta</button>
                    <button type="button" class="btn-action btn-reject" onclick="showConfirm('${commissione.id}', 'rifiuta')">Rifiuta</button>
                </div>
            </div>

        </c:forEach>
        
        <c:if test="${empty requestScope.commissioniList}">
            <p>Non ci sono nuove richieste di commissioni al momento.</p>
        </c:if>
        
    </div>
</main>

<!-- MODALE DETTAGLI COMMISSIONE -->
<div class="admin-modal" id="detailsModal" style="display: none;">
    <div class="modal-box">
        <h2>Dettagli Commissione #<span id="modId"></span></h2>
        
        <div class="modal-info">
            <p><strong>Cliente:</strong> <span id="modClient"></span></p>
            <p><strong>Tipologia:</strong> <span id="modType"></span></p>
            <p id="modAddressContainer" style="display: none;"><strong>Indirizzo Spedizione:</strong> <span id="modAddress"></span></p>
        </div>
        
        <hr>
        
        <div class="modal-desc">
            <p><strong>Descrizione Progetto:</strong></p>
            <div id="modDesc"></div>
        </div>
        
        <div class="modal-actions-container">
            <button type="button" class="btn-action btn-accept" onclick="actionFromModal('accetta')">Accetta Progetto</button>
            <button type="button" class="btn-action btn-reject" onclick="actionFromModal('rifiuta')">Rifiuta Progetto</button>
            <button type="button" class="btn-action btn-close" onclick="closeDetailsModal()">Chiudi</button>
        </div>
    </div>
</div>

<!-- MODALE CONFERMA AZIONE -->
<div class="admin-modal" id="confirmModal" style="display: none;">
    <div class="modal-box confirm-box">
        <h3 id="confirmTitle">Sei sicuro?</h3>
        <p id="confirmText"></p>
        
        <div class="modal-actions-container">
            <button type="button" class="btn-action btn-accept" id="confirmYesBtn">Sì, Conferma</button>
            <button type="button" class="btn-action btn-close" onclick="closeConfirmModal()">Annulla</button>
        </div>
    </div>
</div>

<!-- SCRIPT PER LA GESTIONE MODALI E CHIAMATE AJAX -->
<script>
    let currentCommissionId = null;
    // Salva il contextPath per le chiamate AJAX
    const contextPath = "${pageContext.request.contextPath}";

    // --- 1. APERTURA MODALE DETTAGLI E SBLOCCO TASTI ---
    function openDetailsModal(id, client, type, desc, address) {
        currentCommissionId = id;
        
        document.getElementById('modId').innerText = id;
        document.getElementById('modClient').innerText = client;
        document.getElementById('modType').innerText = type;
        document.getElementById('modDesc').innerText = desc;
        
        // Gestione Indirizzo (mostra solo se esiste)
        const addressContainer = document.getElementById('modAddressContainer');
        if (address && address.trim() !== '') {
            document.getElementById('modAddress').innerText = address;
            addressContainer.style.display = 'block';
        } else {
            addressContainer.style.display = 'none';
        }
        
        // Sblocco visivo dei tasti sulla card
        const cardActions = document.getElementById('actions-' + id);
        if (cardActions && cardActions.classList.contains('hidden-actions')) {
            cardActions.classList.remove('hidden-actions');
            
            // CHIAMATA AJAX (Invisibile): Aggiorna il DB segnando la card come visionata
            fetch(contextPath + "/GestioneCommissioni", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: new URLSearchParams({ action: "visiona", id: id })
            }).catch(error => console.error('Errore durante l\'aggiornamento dello stato visionata:', error));
        }
        
        document.getElementById('detailsModal').style.display = 'flex';
    }

    function closeDetailsModal() {
        document.getElementById('detailsModal').style.display = 'none';
    }

    // --- 2. AZIONE DALLA MODALE DETTAGLI ---
    function actionFromModal(actionType) {
        closeDetailsModal();
        showConfirm(currentCommissionId, actionType);
    }

    // --- 3. APERTURA MODALE DI CONFERMA ---
    function showConfirm(id, actionType) {
        currentCommissionId = id;
        const confirmModal = document.getElementById('confirmModal');
        const confirmTitle = document.getElementById('confirmTitle');
        const confirmText = document.getElementById('confirmText');
        const confirmYesBtn = document.getElementById('confirmYesBtn');

        if (actionType === 'accetta') {
            confirmTitle.innerText = "Accetta Commissione";
            confirmText.innerText = "Stai per accettare l'ordine #" + id + ". Procedere?";
            // Resetta eventuali stili di rifiuto (utile per la compagna nel CSS se cambia colori via JS)
        } else {
            confirmTitle.innerText = "Rifiuta Commissione";
            confirmText.innerText = "Stai per rifiutare l'ordine #" + id + ". L'operazione non può essere annullata.";
        }

        confirmYesBtn.onclick = function() {
            submitAction(id, actionType);
        };

        confirmModal.style.display = 'flex';
    }

    function closeConfirmModal() {
        document.getElementById('confirmModal').style.display = 'none';
    }

    // --- 4. CHIAMATA AJAX PER ACCETTARE O RIFIUTARE ---
    function submitAction(id, actionType) {
        
        // Disabilita temporaneamente il bottone per evitare doppi click
        const confirmYesBtn = document.getElementById('confirmYesBtn');
        confirmYesBtn.disabled = true;
        confirmYesBtn.innerText = "Attendere...";
        
        fetch(contextPath + "/GestioneCommissioni", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: new URLSearchParams({ action: actionType, id: id })
        })
        .then(response => {
            if (response.ok) {
                // Successo! Chiudiamo la modale
                closeConfirmModal();
                
                // Rimuoviamo la card dalla dashboard con una piccola animazione (o nascondendola)
                const cardTarget = document.getElementById('card-' + id);
                if(cardTarget) {
                    cardTarget.style.opacity = '0';
                    setTimeout(() => cardTarget.style.display = 'none', 300);
                }
            } else {
                alert("Si è verificato un errore durante l'operazione.");
            }
        })
        .catch(error => {
            console.error('Errore:', error);
            alert("Errore di connessione al server.");
        })
        .finally(() => {
            // Ripristina il bottone
            confirmYesBtn.disabled = false;
            confirmYesBtn.innerText = "Sì, Conferma";
        });
    }
</script>

<%@ include file="fragment/footer.jspf" %>