<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- CONTROLLO ACCESSO: Se l'utente non è in sessione, torna al login -->
<c:if test="${empty sessionScope.utenteLoggato}">
    <c:redirect url="login.jsp" />
</c:if>

<% request.setAttribute("titoloPagina", "La mia Area Personale"); 
	request.setAttribute("cssPagina", "areautente.css");
%>

<%@ include file="fragment/header.jspf" %>

<main class="user-dashboard-container">

    <div class="user-layout">
        
        <!-- ================= SIDEBAR NAVIGAZIONE ================= -->
        <aside class="user-sidebar">
            <div class="user-profile-summary">
			    <div class="user-pfp">
			        <i class="fa-solid fa-user"></i>
			    </div>
			    
			    <h3>${sessionScope.utenteLoggato.nome} ${sessionScope.utenteLoggato.cognome}</h3>
			    <p>${sessionScope.utenteLoggato.email}</p>
			</div>
            
            <nav class="user-nav">
			    <ul id="userMenu">
			        <li><a href="#dashboard" class="active" onclick="switchTab('dashboard', this, event)"><i class="fa-solid fa-gauge"></i> Panoramica</a></li>
			        <li><a href="#anagrafica" onclick="switchTab('anagrafica', this, event)"><i class="fa-regular fa-address-card"></i> Anagrafica e Spedizioni</a></li>
			        <li><a href="#libreria" onclick="switchTab('libreria', this, event)"><i class="fa-solid fa-cloud-arrow-down"></i> Libreria Digitale</a></li>
			        <li><a href="#ordini" onclick="switchTab('ordini', this, event)"><i class="fa-solid fa-box-open"></i> I Miei Ordini</a></li>
			        <li><a href="#commissioni" onclick="switchTab('commissioni', this, event)"><i class="fa-solid fa-palette"></i> Tracker Commissioni</a></li>
			        <li><a href="#pagamenti" onclick="switchTab('pagamenti', this, event)"><i class="fa-solid fa-credit-card"></i> Metodi di Pagamento</a></li>
			        <li><a href="#sicurezza" onclick="switchTab('sicurezza', this, event)"><i class="fa-solid fa-shield"></i> Sicurezza e Privacy</a></li>
			        <li><a href="${pageContext.request.contextPath}/Logout" class="text-red"><i class="fa-solid fa-arrow-right-from-bracket"></i> Disconnettiti</a></li>
			    </ul>
			</nav>
        </aside>

        <!-- ================= CONTENUTO PRINCIPALE (TABS) ================= -->
        <div class="user-main-content">
            
            <section id="dashboard" class="user-tab-content active-tab">
                <h2>Bentornato, ${sessionScope.utenteLoggato.username}!</h2>
                <p>Dal tuo pannello di controllo puoi visualizzare le tue attività recenti e aggiornare le tue informazioni.</p>
                
                <div class="kpi-grid">
                    <div class="kpi-card">
                        <h3>Ordini Effettuati</h3>
                        <p class="kpi-number">${sessionScope.storicoOrdini != null ? fn:length(sessionScope.storicoOrdini) : 0}</p>
                    </div>
                    <div class="kpi-card">
                        <h3>Asset Digitali</h3>
                        <p class="kpi-number">${sessionScope.libreriaDigitale != null ? fn:length(sessionScope.libreriaDigitale) : 0}</p>
                    </div>
                    <div class="kpi-card">
                        <h3>Elementi in Wishlist</h3>
                        <p class="kpi-number">${sessionScope.wishlist != null ? fn:length(sessionScope.wishlist) : 0}</p>
                    </div>
                </div>
              </section>
              
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
					    <div class="form-row">
					        <div class="form-group half-width">
					            <label for="via">Via/Piazza</label>
					            <input type="text" id="via" name="via" value="${sessionScope.indirizzoPrincipale.via}">
					        </div>
					        <div class="form-group half-width" style="max-width: 150px;">
					            <label for="civico">Numero Civico</label>
					            <input type="text" id="civico" name="civico" 
					                   value="${sessionScope.indirizzoPrincipale.civico}"
					                   inputmode="numeric"
					                   pattern="[0-9]+" 
					                   oninput="this.value = this.value.replace(/[^0-9]/g, '')"
					                   title="Inserisci solo numeri" required>
					        </div>
					    </div>
					    <div class="form-row">
					        <div class="form-group half-width">
					            <label for="citta">Città</label>
					            <input type="text" id="citta" name="citta" 
					                   value="${sessionScope.indirizzoPrincipale.citta}"
					                   pattern="[a-zA-Za-zA-ZàèéìòùÀÈÉÌÒÙ\s']+" 
					                   oninput="this.value = this.value.replace(/[^a-zA-Za-zA-ZàèéìòùÀÈÉÌÒÙ\s']/g, '')"
					                   title="Inserisci solo lettere" required>
					        </div>
					        <div class="form-group half-width">
					            <label for="cap">CAP</label>
					            <input type="text" id="cap" name="cap" 
					                   maxlength="5" minlength="5"
					                   value="${sessionScope.indirizzoPrincipale.cap}"
					                   inputmode="numeric"
					                   pattern="[0-9]{5}" 
					                   oninput="this.value = this.value.replace(/[^0-9]/g, '')"
					                   title="Inserisci esattamente 5 cifre numeriche" required>
					        </div>
					        <div class="form-group half-width" style="max-width: 100px;">
					            <label for="provincia">Provincia</label>
					            <input type="text" id="provincia" name="provincia" 
					                   maxlength="2" minlength="2"
					                   value="${sessionScope.indirizzoPrincipale.provincia}" 
					                   placeholder="SA"
					                   style="text-transform: uppercase;"
					                   pattern="[a-zA-Za-zA-Z]{2}"
					                   oninput="this.value = this.value.toUpperCase().replace(/[^A-Z]/g, '')"
					                   title="Inserisci le 2 lettere della provincia" required>
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
                    <c:choose>
                        <c:when test="${empty sessionScope.libreriaDigitale}">
                            <p style="grid-column: 1 / -1;">Non hai ancora acquistato nessun asset digitale.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="asset" items="${sessionScope.libreriaDigitale}">
                                <div class="library-item-card">
                                    <div class="library-img">
										    <img src="${pageContext.request.contextPath}/product_images/${asset.prodotto.immagineCopertinaUrl}" alt="${asset.prodotto.nome}"
										         style="width: 100%; border-radius: 8px; object-fit: cover;" />
										</div>
										<div class="library-info">
										    <h4>${asset.prodotto.nome}</h4>
										    
										    <c:choose>
										        <c:when test="${fn:startsWith(asset.prodotto.formatoFile, 'comm_')}">
										            <c:choose>
										                <c:when test="${fn:contains(asset.prodotto.descrizione, '[MODELLO_3D]')}">
										                    <span class="badge-format">.BLEND</span>
										                </c:when>
										                <c:when test="${fn:contains(asset.prodotto.descrizione, '[TEXTURE]')}">
										                    <span class="badge-format">.PNG</span>
										                </c:when>
										                <c:otherwise>
										                    <span class="badge-format">.ZIP</span>
										                </c:otherwise>
										            </c:choose>
										        </c:when>
										        
										        <c:otherwise>
										            <span class="badge-format">${asset.prodotto.formatoFile}</span>
										        </c:otherwise>
										    </c:choose>
										</div>
                                    <a href="${pageContext.request.contextPath}/DownloadAssetServlet?id=${asset.prodotto.id}" class="btn-outline-small w-100">
                                        <i class="fa-solid fa-download"></i> Scarica Asset
                                    </a>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>

            <!-- TAB 4: I MIEI ORDINI -->
            <section id="ordini" class="user-tab-content">
                <h2>Storico Ordini</h2>
                
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
                            <a href="${pageContext.request.contextPath}/FiltraOrdiniUtenteServlet" class="btn-outline-small">Reset</a>
                        </c:if>
                    </form>
                </div>

                <table class="user-table mt-3">
				    <thead>
				        <tr>
				            <th>Data</th>
				            <th>N. Ordine</th>
				            <th>Prodotti</th>
				            <th>Totale</th>
				            <th>Stato</th>
				            <th class="no-print">Azioni</th>
				        </tr>
				    </thead>
				    <tbody>
				        <c:choose>
				            <c:when test="${empty sessionScope.storicoOrdini}">
				                <tr>
				                    <td colspan="6" class="text-center">Nessun ordine trovato.</td>
				                </tr>
				            </c:when>
				            <c:otherwise>
				                <c:forEach var="ordine" items="${sessionScope.storicoOrdini}">
				                    <tr>
				                        <td><fmt:formatDate value="${ordine.dataOrdine}" pattern="dd/MM/yyyy HH:mm" timeZone="Europe/Rome" /></td>
				                        <td>#${ordine.id}</td>
				                        <td>
				                            <ul class="order-items-list">
				                                <c:forEach var="item" items="${ordine.articoli}">
				                                    <li>${item.quantita}x ${item.prodotto.nome}</li>
				                                </c:forEach>
				                            </ul>
				                        </td>
				                        <td>€ <fmt:formatNumber value="${ordine.totale}" pattern="#,##0.00"/></td>
				                        <td><span class="status-badge status-${ordine.stato.toLowerCase().replace(' ', '-')}">${ordine.stato}</span></td>
				                        <td class="table-actions no-print">
				                            <a href="${pageContext.request.contextPath}/FatturaServlet?id=${ordine.id}" target="_blank" class="btn-outline-small">
										        <i class="fa-solid fa-file-pdf"></i>
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
                    <c:choose>
                        <c:when test="${empty sessionScope.mieCommissioni}">
                            <p>Non hai ancora richiesto nessun progetto su misura.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="comm" items="${sessionScope.mieCommissioni}">
                                <div class="commission-card">
                                    <div class="commission-card-header">
                                        <h3 class="commission-title">Richiesta #${comm.id} - ${comm.tipi}</h3>
                                        <span class="status-badge status-${fn:toLowerCase(fn:replace(comm.stato, '_', '-'))}">
					                    	${fn:replace(comm.stato, '_', ' ')}
					                </span>
                                    </div>
                                    <div class="commission-card-footer">
                                        <p class="commission-date">Inviata il: <fmt:formatDate value="${comm.dataRichiesta}" pattern="dd/MM/yyyy HH:mm" timeZone="Europe/Rome" /></p>
                                        <button type="button" class="btn-outline-small" onclick="mostraDettagliCommissione('${comm.id}', '${comm.stato}', '${fn:escapeXml(comm.linkProdotto)}')">
										    <i class="fa-solid fa-eye"></i> 
										</button>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>

            <!-- TAB 6: METODI DI PAGAMENTO -->
            <section id="pagamenti" class="user-tab-content">
                <h2>Metodi di Pagamento Salvati</h2>
                <p>Qui puoi visualizzare e aggiungere le tue carte per un checkout più veloce.</p>
                
                <div class="payment-cards-grid mt-3">
                    <c:choose>
                        <c:when test="${empty sessionScope.metodiPagamento}">
                            <!-- Se l'utente non ha carte salvate, mostriamo un messaggio amichevole all'interno della griglia -->
                            <div style="grid-column: 1 / -1; margin-bottom: 15px; background: rgba(56, 35, 129, 0.05); border: 2px dashed #ccc; padding: 20px; border-radius: 10px; text-align: center;">
                                Non hai ancora nessun metodo di pagamento salvato.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="carta" items="${sessionScope.metodiPagamento}">
                                <div class="saved-card" style="background: linear-gradient(135deg, #0f0326, #382381); color: white; padding: 20px; border-radius: 15px; position: relative; overflow: hidden;">
                                    <!-- Aggiungiamo un effetto di sfondo alla carta -->
                                    <div style="position: absolute; right: -20px; top: -20px; width: 100px; height: 100px; background: rgba(255,255,255,0.1); border-radius: 50%;"></div>
                                    
                                    <div class="card-brand" style="font-size: 2rem; margin-bottom: 20px;">
                                        <!-- Logica base per mostrare un'icona adatta a seconda del circuito (se gestito nel backend) -->
                                        <c:choose>
                                            <c:when test="${fn:containsIgnoreCase(carta.brand, 'Mastercard')}">
                                                <i class="fa-brands fa-cc-mastercard"></i>
                                            </c:when>
                                            <c:when test="${fn:containsIgnoreCase(carta.brand, 'Amex')}">
                                                <i class="fa-brands fa-cc-amex"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa-brands fa-cc-visa"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <div class="card-number" style="font-family: 'Courier New', Courier, monospace; font-size: 1.2rem; letter-spacing: 2px; margin-bottom: 15px;">
                                        ${carta.cartaMascherata} <!-- Mostrerà tipo **** **** **** 1234 -->
                                    </div>
                                    
                                    <div class="card-details" style="display: flex; justify-content: space-between; align-items: flex-end;">
                                        <div class="card-expiry">
                                            <span style="font-size: 0.7rem; text-transform: uppercase; display: block; opacity: 0.8;">Scadenza</span>
                                            ${carta.scadenza}
                                        </div>
                                        <form action="${pageContext.request.contextPath}/DeleteCardServlet" method="POST" style="margin: 0;">
                                            <input type="hidden" name="idCarta" value="${carta.id}">
                                            <button type="submit" class="btn-icon" style="color: #ff4d4d; border: none; background: transparent; cursor: pointer; padding: 5px; font-size: 1.1rem;" onclick="return confirm('Sicuro di voler rimuovere questa carta?')">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>

                    <!-- Pulsante Aggiungi Nuova Carta -->
                    <div class="saved-card add-new-card" onclick="apriModalAggiungiCarta()" >
                        <i class="fa-solid fa-plus"></i>
                        <p class="text-blue mt-2" >Aggiungi Carta</p>
                    </div>
                </div>
            </section>

            <!-- TAB 7: SICUREZZA E PRIVACY -->
            <section id="sicurezza" class="user-tab-content">
                <h2>Sicurezza e Privacy (GDPR)</h2>
                
                <div class="security-card mt-3">
                    <h3>Cambia Password</h3>
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

                <div class="security-card mt-4" style="border-left: 4px solid #ff4d4d; background: rgba(255,77,77,0.05); padding: 20px; border-radius: 8px;">
                    <h3 style="color: #ff4d4d;">Zona Pericolosa</h3>
                    <p>I tuoi dati sono tuoi. Puoi decidere di esportarli o di eliminare definitivamente il tuo account dai nostri server.</p>
                    
                    <div class="danger-actions mt-3" style="display: flex; gap: 15px; flex-wrap: wrap;">
                        <button type="button" class="btn-outline-small" onclick="esportaDatiFinto()">
                            <i class="fa-solid fa-file-export"></i> Esporta i miei dati
                        </button>
                        
                        <!-- L'azione di eliminazione usa il custom alert invece di un banale confirm -->
                        <form id="deleteAccountForm" action="${pageContext.request.contextPath}/DeleteAccountServlet" method="POST" style="margin: 0;">
                            <button type="button" class="btn-danger" style="background: #ff4d4d; color: white; padding: 8px 15px; border-radius: 50px; border: none; cursor: pointer; font-weight: bold;" onclick="confermaEliminazioneAccount()">
                                <i class="fa-solid fa-triangle-exclamation"></i> Elimina Account
                            </button>
                        </form>
                    </div>
                </div>
            </section>

        </div>
    </div>
   
</main>


<!-- ================= MODALI E ALERT ================= -->


<!-- 1. MODALE DINAMICO COMMISSIONE UTENTE -->
<div id="userCommissionModal" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px); z-index: 999999; justify-content: center; align-items: center;">
    <div style="background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.5); border-radius: 20px; padding: 30px; max-width: 450px; width: 90%; text-align: center; box-shadow: 0 10px 40px rgba(0,0,0,0.2);">
        
        <h3 style="font-family: 'elephant', sans-serif; color: #382381; margin-bottom: 10px;">Commissione #<span id="ucModId"></span></h3>
        <p style="font-family: 'coolveticarg', sans-serif; margin-bottom: 20px;">Stato: <span id="ucModStato" style="font-weight: bold; color: #e56399; text-transform: uppercase;"></span></p>
        
        <div id="ucModMessage" style="background: rgba(0,0,0,0.03); padding: 15px; border-radius: 10px; font-family: 'coolveticarg', sans-serif; color: #333; font-size: 1.05rem; line-height: 1.5; margin-bottom: 20px; text-align: left;">
        </div>
        
        <div id="ucModActionContainer" style="display: none; margin-bottom: 20px;">
		    <form id="ucCartForm" onsubmit="aggiungiAlCarrello(event)">
		        <input type="hidden" name="id_prodotto" id="ucModProductIdInput" value="">
		        <button type="submit" class="btn-primary" style="text-decoration: none; display: inline-block; width: 100%; box-sizing: border-box; border-radius: 50px; padding: 12px; background: #2ecc71; color: white; font-weight: bold; border: none; cursor: pointer;">
		            <i class="fa-solid fa-cart-shopping"></i> Acquista il prodotto commissionato!
		        </button>
		    </form>
		</div>
        
        <button type="button" class="btn-secondary" onclick="chiudiUserCommissionModal()" style="width: 100%; border-radius: 50px; padding: 10px; background: rgba(15,3,38,0.1); border: none; color: #0f0326; font-weight: bold; cursor: pointer;">Chiudi</button>
    </div>
</div>


<!-- 2. MODALE AGGIUNGI CARTA -->
<div id="addCardModal" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px); z-index: 999998; justify-content: center; align-items: center;">
    <div style="background: rgba(255, 255, 255, 0.95); border-radius: 20px; padding: 30px; max-width: 400px; width: 90%; box-shadow: 0 10px 40px rgba(0,0,0,0.2);">
        
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h3 style="font-family: 'elephant', sans-serif; color: #382381; margin: 0;">Aggiungi Carta</h3>
            <button type="button" onclick="chiudiModalAggiungiCarta()" style="background: transparent; border: none; font-size: 1.5rem; color: #333; cursor: pointer;"><i class="fa-solid fa-times"></i></button>
        </div>
        
        <form action="${pageContext.request.contextPath}/AddCardServlet" method="POST" id="addCardForm" onsubmit="mostraSuccessoCarta(event)">
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: block; margin-bottom: 5px; font-weight: bold; font-size: 0.9em; color: #555;">Nome sul titolare</label>
                <input type="text" name="titolareCarta" required style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #ccc; font-family: 'coolveticarg', sans-serif;" placeholder="Mario Rossi">
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label style="display: block; margin-bottom: 5px; font-weight: bold; font-size: 0.9em; color: #555;">Numero della carta</label>
                <input type="text" name="numeroCarta" id="inputCardNumber" maxlength="19" required 
                       style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #ccc; font-family: 'Courier New', monospace; letter-spacing: 2px;" 
                       placeholder="0000 0000 0000 0000"
                       oninput="formattaCarta(this)">
            </div>
            
            <div style="display: flex; gap: 15px; margin-bottom: 25px;">
                <div class="form-group" style="flex: 1;">
                    <label style="display: block; margin-bottom: 5px; font-weight: bold; font-size: 0.9em; color: #555;">Scadenza</label>
                    <input type="text" name="scadenzaCarta" maxlength="5" required 
                           style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #ccc; font-family: 'Courier New', monospace;" 
                           placeholder="MM/AA" oninput="formattaScadenza(this)">
                </div>
                <div class="form-group" style="flex: 1;">
                    <label style="display: block; margin-bottom: 5px; font-weight: bold; font-size: 0.9em; color: #555;">CVV</label>
                    <input type="password" name="cvvCarta" maxlength="3" required 
                           style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #ccc; font-family: 'Courier New', monospace;" 
                           placeholder="***" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                </div>
            </div>
            
            <button type="submit" class="btn-primary" style="width: 100%; border-radius: 50px; padding: 12px; font-weight: bold; font-size: 1.05rem;">
                <i class="fa-solid fa-lock" style="margin-right: 5px;"></i> Salva Carta Sicura
            </button>
        </form>
    </div>
</div>


<!-- 3. CUSTOM ALERT STILE CATALOGO (Per tutto: Successi, Errori, Avvisi, Conferme Delete) -->
<div id="customAlert" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px); z-index: 999999; justify-content: center; align-items: center;">
    <div style="background: rgba(255, 255, 255, 0.65); backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.5); border-radius: 20px; padding: 30px; max-width: 380px; width: 85%; text-align: center; box-shadow: 0 8px 32px 0 rgba(0,0,0,0.3);">
        <i id="customAlertIcon" class="fa-solid fa-circle-exclamation" style="font-size: 2.5rem; color: #e56399; margin-bottom: 15px;"></i>
        <h3 id="customAlertTitle" style="font-family: 'elephant', sans-serif; font-weight: bold; margin-bottom: 10px; color: #e56399;">Attenzione!</h3>
        <p id="customAlertText" style="font-family: 'coolveticarg', sans-serif; margin-bottom: 20px; color: #333;">Messaggio</p>
        
        <!-- Bottone singolo (Okay/Chiudi) -->
        <button type="button" class="btn-primary auth-btn" id="customAlertSingleBtn" onclick="closeCustomAlert()" style="width: 100%; border-radius: 50px;">Okay</button>
        
        <!-- Bottoni doppi (Conferma/Annulla per azioni pericolose) -->
        <div id="customAlertDoubleBtns" style="display: none; gap: 15px; justify-content: center; align-items: center;">
            <button type="button" class="btn-secondary" onclick="closeCustomAlert()" style="margin: 0; border-radius: 50px; padding: 10px 25px; border: none; background: #ddd; color: #333; font-weight: bold; cursor: pointer;">Annulla</button>
            <button type="button" class="auth-btn" id="customAlertConfirmBtn" style="margin: 0; border-radius: 50px; padding: 10px 25px; background: #ff4d4d; color: white; border: none; font-weight: bold; cursor: pointer;">Conferma</button>
        </div>
    </div>
</div>


<!-- ================= SCRIPT ================= -->
<script>
    /* =========================================================
       1. NAVIGAZIONE TABS
       ========================================================= */
    function switchTab(tabId, clickedElement, event) {
        if (event) event.preventDefault();
    
        let tabs = document.querySelectorAll('.user-tab-content');
        tabs.forEach(tab => tab.classList.remove('active-tab'));
    
        let links = document.querySelectorAll('#userMenu a');
        links.forEach(link => link.classList.remove('active'));
    
        document.getElementById(tabId).classList.add('active-tab');
        if (clickedElement) clickedElement.classList.add('active');
    
        window.scrollTo({ top: 0, behavior: 'smooth' });
        
        // Salvataggio nel sessionStorage per mantenere il tab al ricaricamento
        sessionStorage.setItem('activeUserTab', tabId);
    }

    document.addEventListener("DOMContentLoaded", function() {
        const savedTab = sessionStorage.getItem('activeUserTab');
        if (savedTab) {
            const tabButton = document.querySelector('a[href="#' + savedTab + '"]');
            if (tabButton) {
                switchTab(savedTab, tabButton, null);
            }
        }
    });


    /* =========================================================
       2. GESTIONE COMMISSIONI E CARRELLO
       ========================================================= */
    function mostraDettagliCommissione(id, stato, linkProdotto) {
        document.getElementById('ucModId').innerText = id;
        
        let statoPulito = stato ? stato.toUpperCase().trim() : 'IN_ATTESA';
        document.getElementById('ucModStato').innerText = statoPulito.replace(/_/g, ' ');
        
        const messageDiv = document.getElementById('ucModMessage');
        const actionContainer = document.getElementById('ucModActionContainer');
        const productIdInput = document.getElementById('ucModProductIdInput');
        
        actionContainer.style.display = 'none';
        
        switch (statoPulito) {
            case 'IN_ATTESA': messageDiv.innerHTML = 'La tua richiesta è in attesa di verifica.'; break;
            case 'ACCETTATA': messageDiv.innerHTML = 'La tua commissione è stata accettata.'; break;
            case 'IN_LAVORAZIONE': messageDiv.innerHTML = 'La commissione è in lavorazione.'; break;
            case 'COMPLETATA':
                messageDiv.innerHTML = 'La commissione è completata! Il prodotto è pronto.';
                if (linkProdotto && linkProdotto.trim() !== '') {
                    productIdInput.value = linkProdotto.trim();
                    actionContainer.style.display = 'block';
                }
                break;
            case 'RIFIUTATA': messageDiv.innerHTML = 'La commissione è stata rifiutata.'; break;
        }
        
        document.getElementById('userCommissionModal').style.display = 'flex';
    }

    function chiudiUserCommissionModal() {
        document.getElementById('userCommissionModal').style.display = 'none';
    }

    function aggiungiAlCarrello(event) {
        event.preventDefault();
        const productId = document.getElementById('ucModProductIdInput').value;
        const formData = new URLSearchParams();
        formData.append('id_prodotto', productId);
        formData.append('isAjax', 'true');
        
        fetch('${pageContext.request.contextPath}/AddtoCart', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
        })
        .then(response => response.text())
        .then(result => {
            if (result === 'aggiunto_digitale' || result === 'aggiunto_fisico') {
                showCustomAlert("Aggiunto!", "L'elemento è stato inserito nel carrello.", false);
                chiudiUserCommissionModal();
                setTimeout(() => { window.location.href = '${pageContext.request.contextPath}/Carrello'; }, 1500);
            } else if (result === 'gia_presente') {
                showCustomAlert("Attenzione", "Questo elemento è già nel tuo carrello.", true);
            } else if (result === 'gia_acquistato') {
                showCustomAlert("Attenzione", "Hai già acquistato questo asset digitale!", true);
            }
        });
    }

    /* =========================================================
       3. GESTIONE CUSTOM ALERT
       ========================================================= */
    function showCustomAlert(title, message, isError = true, onConfirm = null) {
        const alertModal = document.getElementById('customAlert');
        const alertTitle = document.getElementById('customAlertTitle');
        const alertText = document.getElementById('customAlertText');
        const alertIcon = document.getElementById('customAlertIcon');
        const singleBtn = document.getElementById('customAlertSingleBtn');
        const doubleBtns = document.getElementById('customAlertDoubleBtns');
        const confirmBtn = document.getElementById('customAlertConfirmBtn');
        
        alertTitle.innerText = title;
        alertText.innerText = message;
        
        if (onConfirm) {
            // Modalità "Confirm" (due bottoni)
            singleBtn.style.display = 'none';
            doubleBtns.style.display = 'flex';
            confirmBtn.onclick = function() {
                closeCustomAlert();
                onConfirm(); // Esegue l'azione (es. submit form)
            };
        } else {
            // Modalità "Alert" normale (un bottone)
            singleBtn.style.display = 'block';
            doubleBtns.style.display = 'none';
        }

        // Stile dinamicizzato
        if (isError) {
            alertTitle.style.color = '#e56399';
            alertIcon.style.color = '#e56399';
            alertIcon.className = 'fa-solid fa-circle-exclamation';
            singleBtn.style.background = '#e56399';
        } else {
            alertTitle.style.color = '#00c853';
            alertIcon.style.color = '#00c853';
            alertIcon.className = 'fa-solid fa-circle-check';
            singleBtn.style.background = '#00c853';
        }

        alertModal.style.display = 'flex';
    }

    function closeCustomAlert() {
        document.getElementById('customAlert').style.display = 'none';
    }


    /* =========================================================
       4. SICUREZZA (Export Dati & Elimina Account)
       ========================================================= */
    function esportaDatiFinto() {
        showCustomAlert(
            "Richiesta Ricevuta", 
            "Un file contenente i tuoi dati, lo storico ordini e i file di sistema associati al tuo account verrà inviato all'indirizzo email: ${sessionScope.utenteLoggato.email} entro 48 ore.", 
            false
        );
    }

    function confermaEliminazioneAccount() {
        showCustomAlert(
            "Eliminare l'account?", 
            "Sei sicuro? Questa azione è IRREVERSIBILE. Perderai l'accesso alla libreria digitale e a tutto lo storico.", 
            true, 
            function() {
                // Se l'utente clicca su "Conferma" nel modal, facciamo il submit vero
                document.getElementById('deleteAccountForm').submit();
            }
        );
    }


    /* =========================================================
       5. GESTIONE CARTE DI CREDITO
       ========================================================= */
    function apriModalAggiungiCarta() {
        document.getElementById('addCardModal').style.display = 'flex';
    }

    function chiudiModalAggiungiCarta() {
        document.getElementById('addCardModal').style.display = 'none';
    }

    function formattaCarta(input) {
        // Rimuove tutto ciò che non è un numero e aggiunge uno spazio ogni 4 cifre
        let v = input.value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
        let matches = v.match(/\d{4,16}/g);
        let match = matches && matches[0] || '';
        let parts = [];

        for (i=0, len=match.length; i<len; i+=4) {
            parts.push(match.substring(i, i+4));
        }

        if (parts.length) {
            input.value = parts.join(' ');
        } else {
            input.value = v;
        }
    }

    function formattaScadenza(input) {
        // MM/AA
        let v = input.value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
        if (v.length >= 2) {
            input.value = v.substring(0, 2) + '/' + v.substring(2, 4);
        } else {
            input.value = v;
        }
    }

    function mostraSuccessoCarta(event) {
        // Dato che ci serve il backend, non facciamo preventDefault, lasciamo che il form parta.
        // Ma prima chiudiamo il modale per pulizia visiva (Il backend farà il redirect).
        // Se si implementerà via AJAX, qui andrà inserito un preventDefault() e un fetch come nel carrello.
        
        // Per ora facciamo fare il submit naturale al form. Se la servlet non c'è, darà 404, ma è il comportamento standard.
    }
    
</script>

<%@ include file="fragment/footer.jspf" %>