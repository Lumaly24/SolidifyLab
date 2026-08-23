<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- CONTROLLO ACCESSO: Se l'utente non è in sessione, torna al login -->
<c:if test="${empty sessionScope.utenteLoggato}">
    <c:redirect url="${pageContext.request.contextPath}/login" />
</c:if>

<% request.setAttribute("titoloPagina", "La mia Area Personale"); %>
<%@ include file="fragment/header.jspf" %>

<main class="user-dashboard-container">

    <div class="user-layout">
        
        <!-- ================= SIDEBAR NAVIGAZIONE ================= -->
        <aside class="user-sidebar">
            <div class="user-profile-summary">
                <div class="avatar"><i class="fa-solid fa-user"></i></div>
                <h3>${sessionScope.utenteLoggato.nome} ${sessionScope.utenteLoggato.cognome}</h3>
                <p>${sessionScope.utenteLoggato.email}</p>
            </div>
            
            <nav class="user-nav">
                <ul id="userMenu">
                    <li><a href="#dashboard" class="active" onclick="switchTab('dashboard', this)"><i class="fa-solid fa-gauge"></i> Panoramica</a></li>
                    <li><a href="#anagrafica" onclick="switchTab('anagrafica', this)"><i class="fa-regular fa-address-card"></i> Anagrafica e Spedizioni</a></li>
                    <li><a href="#libreria" onclick="switchTab('libreria', this)"><i class="fa-solid fa-cloud-arrow-down"></i> Libreria Digitale</a></li>
                    <li><a href="#ordini" onclick="switchTab('ordini', this)"><i class="fa-solid fa-box-open"></i> I Miei Ordini</a></li>
                    <li><a href="#commissioni" onclick="switchTab('commissioni', this)"><i class="fa-solid fa-palette"></i> Tracker Commissioni</a></li>
                    <li><a href="#pagamenti" onclick="switchTab('pagamenti', this)"><i class="fa-solid fa-credit-card"></i> Metodi di Pagamento</a></li>
                    <li><a href="#sicurezza" onclick="switchTab('sicurezza', this)"><i class="fa-solid fa-shield-halved"></i> Sicurezza e Privacy</a></li>
                    <li><a href="${pageContext.request.contextPath}/LogoutServlet" class="text-red"><i class="fa-solid fa-arrow-right-from-bracket"></i> Disconnettiti</a></li>
                </ul>
            </nav>
        </aside>

        <!-- ================= CONTENUTO PRINCIPALE (TABS) ================= -->
        <div class="user-main-content">
            
            <!-- TAB 1: PANORAMICA (DASHBOARD) -->
            <section id="dashboard" class="user-tab-content active-tab">
                <h2>Bentornato, ${sessionScope.utenteLoggato.nome}!</h2>
                <p>Dal tuo pannello di controllo puoi visualizzare le tue attività recenti e aggiornare le tue informazioni.</p>
                
                <div class="kpi-grid">
                    <div class="kpi-card">
                        <h3>Ordini in corso</h3>
                        <p class="kpi-number">1</p>
                    </div>
                    <div class="kpi-card">
                        <h3>Asset Digitali</h3>
                        <p class="kpi-number">${sessionScope.libreriaDigitale.size()}</p>
                    </div>
                    <div class="kpi-card">
                        <h3>Elementi in Wishlist</h3>
                        <p class="kpi-number">4</p>
                    </div>
                </div>
            </section>

            <!-- TAB 2: ANAGRAFICA E SPEDIZIONI -->
            <section id="anagrafica" class="user-tab-content">
                <h2>Anagrafica e Indirizzi di Spedizione</h2>
                <form action="${pageContext.request.contextPath}/UpdateProfiloServlet" method="POST" class="user-form">
                    
                    <fieldset class="form-section">
                        <legend>Dati Personali</legend>
                        <div class="form-row">
                            <div class="form-group half-width">
                                <label for="nome">Nome</label>
                                <input type="text" id="nome" name="nome" value="${sessionScope.utenteLoggato.nome}" required>
                            </div>
                            <div class="form-group half-width">
                                <label for="cognome">Cognome</label>
                                <input type="text" id="cognome" name="cognome" value="${sessionScope.utenteLoggato.cognome}" required>
                            </div>
                        </div>
                    </fieldset>

                    <fieldset class="form-section mt-3">
                        <legend>Indirizzo Principale (per le stampe 3D)</legend>
                        <div class="form-group">
                            <label for="indirizzo">Via/Piazza e Civico</label>
                            <input type="text" id="indirizzo" name="indirizzo" value="${sessionScope.utenteLoggato.indirizzo}">
                        </div>
                        <div class="form-row">
                            <div class="form-group half-width">
                                <label for="citta">Città</label>
                                <input type="text" id="citta" name="citta" value="${sessionScope.utenteLoggato.citta}">
                            </div>
                            <div class="form-group half-width">
                                <label for="cap">CAP</label>
                                <input type="text" id="cap" name="cap" value="${sessionScope.utenteLoggato.cap}">
                            </div>
                        </div>
                    </fieldset>

                    <button type="submit" class="btn-primary mt-3">Salva Modifiche</button>
                </form>
            </section>

            <!-- TAB 3: LIBRERIA DIGITALE -->
            <section id="libreria" class="user-tab-content">
                <h2>La mia Libreria Digitale</h2>
                <p>Qui trovi tutti i Modelli 3D e le Textures che hai acquistato, sempre pronti per il download.</p>
                
                <div class="digital-library-grid">
                    <c:forEach var="asset" items="${sessionScope.libreriaDigitale}">
                        <div class="library-item-card">
                            <div class="library-img">
                                <span>(IMG)</span>
                            </div>
                            <div class="library-info">
                                <h4>${asset.prodotto.nome}</h4>
                                <span class="badge-format">${asset.formatoFile}</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/DownloadAssetServlet?id=${asset.prodotto.id}" class="btn-outline-small w-100">
                                <i class="fa-solid fa-download"></i> Scarica Asset
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </section>

            <!-- TAB 4: I MIEI ORDINI (Con Filtro Date aggiunto e senza CSS inline) -->
            <section id="ordini" class="user-tab-content">
                <h2>Storico Ordini</h2>
                
                <!-- CHECKLIST: Filtro per intervallo di date -->
                <div class="orders-filter-bar">
                    <form action="${pageContext.request.contextPath}/FiltraOrdiniUtenteServlet" method="GET" class="filter-form">
                        
                        <div class="form-group">
                            <label for="dataDa">Da data:</label>
                            <input type="date" id="dataDa" name="data_inizio" value="${param.data_inizio}">
                        </div>
                        
                        <div class="form-group">
                            <label for="dataA">A data:</label>
                            <input type="date" id="dataA" name="data_fine" value="${param.data_fine}">
                        </div>

                        <div class="form-group">
                            <label for="statoOrdine">Stato Ordine:</label>
                            <select id="statoOrdine" name="stato">
                                <option value="">Tutti</option>
                                <option value="Completato" ${param.stato == 'Completato' ? 'selected' : ''}>Completato (Asset)</option>
                                <option value="In Lavorazione" ${param.stato == 'In Lavorazione' ? 'selected' : ''}>In Lavorazione (Stampe)</option>
                                <option value="Spedito" ${param.stato == 'Spedito' ? 'selected' : ''}>Spedito</option>
                            </select>
                        </div>

                        <button type="submit" class="btn-primary"><i class="fa-solid fa-filter"></i> Filtra</button>
                        
                        <c:if test="${not empty param.data_inizio or not empty param.stato}">
                            <a href="${pageContext.request.contextPath}/user-dashboard.jsp#ordini" class="btn-outline-small">Reset</a>
                        </c:if>
                    </form>
                </div>

                <table class="user-table">
                    <thead>
                        <tr>
                            <th>Data</th>
                            <th>N. Ordine</th>
                            <th>Totale</th>
                            <th>Stato</th>
                            <th>Azioni</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty sessionScope.storicoOrdini}">
                                <tr>
                                    <td colspan="5" class="text-center">Nessun ordine trovato.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="ordine" items="${sessionScope.storicoOrdini}">
                                    <tr>
                                        <td>${ordine.data}</td>
                                        <td>#${ordine.id}</td>
                                        <td>€ <fmt:formatNumber value="${ordine.totale}" pattern="#,##0.00"/></td>
                                        <td><span class="status-badge status-${ordine.stato.toLowerCase().replace(' ', '-')}">${ordine.stato}</span></td>
                                        <td class="table-actions">
                                            <a href="${pageContext.request.contextPath}/fattura.jsp?id=${ordine.id}" class="btn-outline-small" target="_blank">
                                                <i class="fa-solid fa-file-pdf"></i> Ricevuta
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </section>

            <!-- TAB 5: TRACKER COMMISSIONI -->
            <section id="commissioni" class="user-tab-content">
                <h2>Tracker Commissioni</h2>
                <p>Segui l'avanzamento dei tuoi progetti 3D su misura.</p>
                
                <div class="commissions-list mt-3">
                    
                    <div class="commission-card">
                        <div class="commission-card-header">
                            <h3 class="commission-title">Modello 3D: Spada Fantasy Personalizzata</h3>
                            <span class="status-badge status-lavorazione">In Lavorazione (60%)</span>
                        </div>
                        <div class="commission-card-footer">
                            <p class="commission-date">Richiesta inviata il: 12/08/2026</p>
                            <button class="btn-outline-small"><i class="fa-regular fa-comments"></i> Messaggi</button>
                        </div>
                    </div>

                    <div class="commission-card">
                        <div class="commission-card-header">
                            <h3 class="commission-title">Stampa 3D: Busto Batman (Resina)</h3>
                            <span class="status-badge status-preventivo">Preventivo Pronto</span>
                        </div>
                        <div class="commission-card-footer">
                            <p class="commission-date">Costo stimato: € 45,00</p>
                            <button class="btn-primary"><i class="fa-solid fa-check"></i> Accetta e Paga</button>
                        </div>
                    </div>

                </div>
            </section>

            <!-- TAB 6: METODI DI PAGAMENTO -->
            <section id="pagamenti" class="user-tab-content">
                <h2>Metodi di Pagamento Salvati</h2>
                
                <div class="payment-cards-grid mt-3">
                    <div class="saved-card">
                        <div class="card-brand"><i class="fa-brands fa-cc-visa"></i></div>
                        <div class="card-number">**** **** **** 4242</div>
                        <div class="card-expiry">Scadenza: 12/28</div>
                        <button class="btn-icon text-red mt-2"><i class="fa-solid fa-trash"></i> Rimuovi</button>
                    </div>

                    <div class="saved-card add-new-card">
                        <i class="fa-solid fa-plus"></i>
                        <p class="text-blue mt-2">Aggiungi Carta</p>
                    </div>
                </div>
            </section>

            <!-- TAB 7: SICUREZZA E PRIVACY -->
            <section id="sicurezza" class="user-tab-content">
                <h2>Sicurezza e Privacy (GDPR)</h2>
                
                <div class="security-card mt-3">
                    <h3>Cambia Password</h3>
                    <!-- CHECKLIST: Validazione JS per il cambio password -->
                    <form action="${pageContext.request.contextPath}/ChangePasswordServlet" method="POST" class="mt-2" onsubmit="return validaPassword()">
                        <div class="form-group">
                            <label for="oldPwd">Password Attuale</label>
                            <input type="password" id="oldPwd" name="oldPassword" required>
                        </div>
                        <div class="form-group">
                            <label for="newPwd">Nuova Password</label>
                            <input type="password" id="newPwd" name="newPassword">
                            <span class="error-msg" id="err-newpwd"></span>
                        </div>
                        <button type="submit" class="btn-primary">Aggiorna Password</button>
                    </form>
                </div>

                <div class="security-card mt-4 border-red">
                    <h3 class="text-red">Zona Pericolosa</h3>
                    <p>I tuoi dati sono tuoi. Puoi decidere di scaricarli o eliminare definitivamente il tuo account in qualsiasi momento.</p>
                    <div class="danger-actions mt-3">
                        <button class="btn-outline-small"><i class="fa-solid fa-file-export"></i> Esporta i miei dati</button>
                        <form action="${pageContext.request.contextPath}/DeleteAccountServlet" method="POST" class="inline-form">
                            <button type="submit" class="btn-danger" onclick="return confirm('Sei sicuro? Questa azione è irreversibile e perderai l\'accesso ai tuoi file digitali!');">
                                <i class="fa-solid fa-triangle-exclamation"></i> Elimina Account
                            </button>
                        </form>
                    </div>
                </div>
            </section>

        </div>
    </div>
</main>

<!-- ================= SCRIPT ================= -->
<script>
    // Gestione dei Tab Menu
    function switchTab(tabId, clickedElement) {
        // Rimuove la classe attiva da tutte le sezioni
        let tabs = document.querySelectorAll('.user-tab-content');
        tabs.forEach(tab => {
            tab.classList.remove('active-tab');
        });

        // Rimuove la classe attiva dal menu laterale
        let links = document.querySelectorAll('#userMenu a');
        links.forEach(link => {
            link.classList.remove('active');
        });

        // Aggiunge la classe attiva alla sezione cliccata
        document.getElementById(tabId).classList.add('active-tab');
        clickedElement.classList.add('active');
    }

    // Validazione Cambio Password (Requisito Checklist: form regex)
    function validaPassword() {
        let isValid = true;
        document.getElementById('err-newpwd').innerText = '';

        const newPwd = document.getElementById('newPwd').value.trim();
        const pwdRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/; // Almeno 8 caratteri, 1 lettera, 1 numero

        if (!pwdRegex.test(newPwd)) {
            document.getElementById('err-newpwd').innerText = "La password deve contenere almeno 8 caratteri, inclusi lettere e numeri.";
            isValid = false;
        }

        return isValid;
    }

    // Legge l'ancoraggio nell'URL al caricamento della pagina e apre il tab corretto
    window.addEventListener('DOMContentLoaded', (event) => {
        let hash = window.location.hash; // Prende l'ancora, es. "#ordini"
        
        if (hash) {
            let tabId = hash.substring(1); // Toglie il simbolo '#' per avere solo "ordini"
            let targetLink = document.querySelector('a[href="' + hash + '"]');
            
            // Se esiste un tab con quel nome, simula il click
            if (targetLink) {
                switchTab(tabId, targetLink);
            }
        }
    });
</script>

<%@ include file="fragment/footer.jspf" %>