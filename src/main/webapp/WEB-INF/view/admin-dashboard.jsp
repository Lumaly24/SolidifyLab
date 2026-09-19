<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:if test="${empty sessionScope.utenteLoggato or sessionScope.utenteLoggato.ruolo != 'ADMIN'}">
    <c:redirect url="${pageContext.request.contextPath}/login" />
</c:if>

<% 
    request.setAttribute("titoloPagina", "Gestione Commissioni"); 
	request.setAttribute("cssPagina", "areautente.css");
%>

<%@ include file="fragment/header.jspf" %>
		<div id="customAlert" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px); z-index: 999999; justify-content: center; align-items: center;">
		    <div style="background: rgba(255, 255, 255, 0.65); backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.5); border-radius: 20px; padding: 30px; max-width: 380px; width: 85%; text-align: center; box-shadow: 0 8px 32px 0 rgba(0,0,0,0.3);">
		        <i class="fa-solid fa-circle-exclamation" style="font-size: 2.5rem; color: #e56399; margin-bottom: 15px;"></i>
		        <h3 style="font-family: 'elephant', sans-serif; font-weight: bold; margin-bottom: 10px; color: #e56399;">Attenzione!</h3>
		        <p id="customAlertText" style="font-family: 'coolveticarg', sans-serif; margin-bottom: 20px; color: #333;">Messaggio</p>
		        
		        <button type="button" class="btn-primary auth-btn" id="customAlertSingleBtn" onclick="closeCustomAlert()" style="width: 100%;">Okay</button>
		        
		        <div id="customAlertDoubleBtns" style="display: none; gap: 15px; justify-content: center; align-items: center;">
				    <button type="button" class="btn-secondary" onclick="closeCustomAlert()" style="margin: 0; border-radius: 50px; padding: 10px 25px;">Annulla</button>
				    <button type="button" class="auth-btn" id="customAlertConfirmBtn" style="margin: 0; border-radius: 50px; padding: 10px 25px; background: #ff4d4d;">Elimina</button>
				</div>
		    </div>
		</div>
    
        <div id="successModal" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px); z-index: 999999; justify-content: center; align-items: center;">
            <div style="background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.5); border-radius: 20px; padding: 40px 30px; max-width: 400px; width: 85%; text-align: center; box-shadow: 0 10px 40px rgba(0,0,0,0.2);">
                <i class="fa-solid fa-circle-check" style="font-size: 3.5rem; color: #2ecc71; margin-bottom: 20px;"></i>
                <h3 style="font-family: 'elephant', sans-serif; font-weight: bold; margin-bottom: 15px; color: #333;">Evviva!</h3>
                <p id="successModalText" style="font-family: 'coolveticarg', sans-serif; margin-bottom: 25px; color: #555; font-size: 1.1rem; line-height: 1.4;">
                    Operazione completata con successo!
                </p>
                
                <button type="button" class="btn-primary auth-btn" onclick="closeSuccessModal()" style="width: 100%;">Okay</button>
            </div>
        </div>

<div class="admin-body-wrapper">

    <!-- ================= HEADER ADMIN ================= -->
    <header class="admin-header">
        <div class="logo"><strong>SolidifyLab ADMIN</strong></div>
        <div class="admin-user">
            <span>Benvenuto, ${sessionScope.utenteLoggato.nome}</span>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-outline-small text-red">Esci</a>
        </div>
    </header>

    <div class="admin-layout">
        
        <!-- ================= SIDEBAR ================= -->
        <aside class="admin-sidebar">
            <nav>
                <ul>
                	<li><a href="#aggiunta-prodotti" class="active"><i class="fa-solid fa-plus"></i> Aggiungi Prodotti</a></li>
                    <li><a href="#gestione-prodotti"><i class="fa-solid fa-box"></i> Gestisci Prodotti</a></li>
                    <li><a href="#gestione-ordini"><i class="fa-solid fa-receipt"></i> Ordini</a></li>
                    <li><a href="#gestione-commissioni"><i class="fa-solid fa-palette"></i> Commissioni</a></li>
                    <li><a href="#statistiche-sales"><i class="fa-solid fa-chart-line"></i> Statistiche | Sales</a></li>
                    <li><a href="${pageContext.request.contextPath}/Home"><i class="fa-solid fa-house"></i> Torna al Sito</a></li>
                </ul>
            </nav>
        </aside>

        <!-- ================= MAIN CONTENT ================= -->
        <main class="admin-main-content" style="display: block !important; padding: 0 !important; margin: 0 !important;">
            
            <section id="aggiunta-prodotti" class="admin-card" style="margin-top: 0 !important;">
                <h2>Aggiungi Nuovo Prodotto</h2>
                
                <form action="${pageContext.request.contextPath}/Add&Remove" method="POST" enctype="multipart/form-data" class="admin-form mt-3" onsubmit="return validaFormProdotto()">
                    <input type="hidden" name="action" value="add">

                    <div class="form-row">
                        <div class="form-group half-width">
                            <label for="nomeProd">Nome Prodotto</label>
                            <input type="text" id="nomeProd" name="nome">
                            <span class="error-msg" id="err-nome"></span>
                        </div>
                        <div class="form-group half-width">
                            <label for="prezzoProd">Prezzo (€)</label>
                            <input type="number" id="prezzoProd" name="prezzo" step="0.01" min="0">
                            <span class="error-msg" id="err-prezzo"></span>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group half-width">
                            <label for="catProd">Categoria</label>
                            <select id="catProd" name="categoria" required onchange="aggiornaTags()">
                                <option value="" disabled selected>Seleziona una categoria...</option>
                                <option value="MODELLO_3D">Modello 3D</option>
                                <option value="TEXTURE">Texture</option>
                                <option value="STAMPA_3D">Stampa 3D</option>
                            </select>
                        </div>
                        <div class="form-group half-width">
                            <label for="imgProd">Immagine Prodotto (JPEG/PNG)</label>
                            <input type="file" id="imgProd" name="immagine" accept="image/*" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Tag (selezionane almeno uno)</label>
                        <div id="tagContainer" style="display: flex; flex-wrap: wrap; gap: 15px; margin-top: 10px; min-height: 45px; align-items: center;">
                            <span style="color: #666; font-style: italic; font-size: 0.9rem;">Prima scegli la categoria</span>
                        </div>
                        <span class="error-msg" id="err-tags"></span>
                    </div>

                    <div class="form-group">
                        <label for="descProd">Descrizione</label>
                        <textarea id="descProd" name="descrizione" rows="3"></textarea>
                        <span class="error-msg" id="err-desc"></span>
                    </div>

                    <button type="submit" class="btn-primary">Aggiungi al Catalogo</button>
                </form>
            </section>

            <section id="gestione-prodotti" class="admin-card" style="margin-top: 0 !important;">
                <h2>Prodotti in Catalogo</h2>
                
                <table class="admin-table mt-3">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nome</th>
                            <th>Categoria</th>
                            <th>Prezzo</th>
                            <th>Azioni</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="prodotto" items="${listaProdotti}">
                            <tr>
                                <td>${prodotto.id}</td>
                                <td>${prodotto.nome}</td>
                                <td>
								    <c:choose>
								        <c:when test="${prodotto.categoriaId == 1}">Modello 3D</c:when>
								        <c:when test="${prodotto.categoriaId == 2}">Texture</c:when>
								        <c:when test="${prodotto.categoriaId == 3}">Stampe 3D</c:when>
								        <c:otherwise>${prodotto.categoriaId}</c:otherwise>
								    </c:choose>
								</td>
                                <td>€ <fmt:formatNumber value="${prodotto.prezzoCorrente}" pattern="#,##0.00"/></td>
                                <td class="table-actions">
                                    <form action="${pageContext.request.contextPath}/EditProductServlet" method="GET">
                                        <input type="hidden" name="id" value="${prodotto.id}">
                                        <button type="submit" class="btn-icon text-blue" title="Modifica"><i class="fa-solid fa-pen"></i></button>
                                    </form>
                                 
								    <form action="${pageContext.request.contextPath}/Add&Remove" method="POST" style="display:inline;" id="delete-form-${prodotto.id}">
								        <input type="hidden" name="action" value="remove">
								        <input type="hidden" name="id" value="${prodotto.id}">
									      <button type="button" class="btn-icon text-red" title="Elimina dal DB" onclick="showDeleteConfirmAlert('Sei sicuro di voler eliminare definitivamente questo prodotto dal catalogo?', 'delete-form-${prodotto.id}')">
									            <i class="fa-solid fa-trash-can" style="color: #ff4d4d;"></i>
									      </button>
								   </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </section>

            <section id="gestione-ordini" class="admin-card" style="margin-top: 0 !important;">
                <h2>Gestione Ordini</h2>
                
                <div class="filter-bar">
                    <form action="${pageContext.request.contextPath}/FiltraOrdiniAdminServlet" method="GET">
                        <div class="form-group">
                            <label for="filtroCliente">Filtra per Email Cliente:</label>
                            <input type="text" id="filtroCliente" name="email_cliente" value="${param.email_cliente}" placeholder="Es. tom@holland.it">
                        </div>
                        <button type="submit" class="btn-primary"><i class="fa-solid fa-search"></i> Cerca</button>
                        <c:if test="${not empty param.email_cliente}">
                            <a href="${pageContext.request.contextPath}/admin.jsp#gestione-ordini" class="btn-outline-small">Reset</a>
                        </c:if>
                    </form>
                </div>

                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>N. Ordine</th>
                            <th>Data</th>
                            <th>Cliente</th>
                            <th>Totale</th>
                            <th>Stato</th>
                            <th>Azioni</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ordine" items="${listaOrdiniCompleta}">
                            <tr>
                                <td>#${ordine.id}</td>
                                <td>
								    <fmt:formatDate value="${ordine.dataOrdine}" pattern="dd/MM/yyyy HH:mm" />
								</td>
                                <td><strong>${ordine.utente.nome} ${ordine.utente.cognome}</strong></td>
                                <td>€ <fmt:formatNumber value="${ordine.totale}" pattern="#,##0.00"/></td>
                                <td><span class="status-badge status-${ordine.stato.toLowerCase().replace(' ', '-')}">${ordine.stato}</span></td>
                                <td class="table-actions">
                                    <form action="${pageContext.request.contextPath}/Placeholding" method="GET">
                                        <input type="hidden" name="id" value="${comm.id}">
                                        <button type="submit" class="btn-icon blue text-blue"><i class="fa-solid fa-file-lines"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </section>

            <!-- ================= GESTIONE COMMISSIONI ================= -->
            <section id="gestione-commissioni" class="admin-card" style="margin-top: 0 !important;">
                <h2>Richieste di Commissione</h2>
                
                <table class="admin-table mt-3">
                    <thead>
                        <tr>
                            <th>ID Req.</th>
                            <th>Utente</th>
                            <th>Tipo</th>
                            <th>Stato</th>
                            <th>Azioni</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="comm" items="${listaCommissioni}">
                            <tr>
                                <td>#${comm.id}</td>
                                <td>${comm.email}</td>
                                <td>${comm.tipi}</td>
                                <td>
					                <span class="status-badge status-${fn:toLowerCase(fn:replace(comm.stato, '_', '-'))}">
					                    ${fn:replace(comm.stato, '_', ' ')}
					                </span>
					            </td>
                                <td class="table-actions">
                                    <form action="${pageContext.request.contextPath}/GestioneCommissioni" method="GET">
                                        <input type="hidden" name="id" value="${comm.id}">
                                        <button type="submit" class="btn-icon blue text-blue"><i class="fa-solid fa-gear"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </section>

			<!-- ================= STATISTICHE E SALES ================= -->
            <section id="statistiche-sales" class="admin-card" style="margin-top: 0 !important;">
                <h2>Andamento Vendite e Interesse</h2>
                
                <div class="kpi-grid">
                    <div class="kpi-card">
                        <h3>Totale Incassi</h3>
                        <p> € <fmt:formatNumber value="${statistiche.totaleIncassi}" pattern="#,##0.00"/>
                        </p>
                    </div>
                    
                    <div class="kpi-card">
                        <h3>Prodotto Più Venduto</h3>
                        <p>${statistiche.prodottoTop.nome}</p>
                        <span>(${statistiche.prodottoTop.vendite} unità vendute)</span>
                    </div>

                    <div class="kpi-card">
                        <h3><i class="fa-solid fa-heart"></i> Più Desiderato</h3>
                        <p>${statistiche.prodottoWishlist.nome}</p>
                        <span>(In ${statistiche.prodottoWishlist.conteggio} wishlist)</span>
                    </div>
                </div>

            </section>
			

        </main>
    </div>

    <!-- SCRIPT GESTIONE TAG DINAMICI (CHECKBOX) -->
    <script>
        // Lista dei tag esattamente come richiesti
        const tagsPerCategoria = {
            "MODELLO_3D": ["Ambienti", "Creature", "Personaggi", "Props", "Low Poly", "High Poly", "Rigged", "Game Ready", "Realistico", "Fantasy"],
            "TEXTURE": ["Architettura", "Metalli", "Tessuti", "Organiche", "1K", "2K", "3K", "4K", "Seamless"],
            "STAMPA_3D": ["Accessori", "Miniature", "Props", "Resina", "PLA", "PETG", "Supporti rimossi", "Levigatura primer", "Colore"]
        };

        function aggiornaTags() {
            const catSelect = document.getElementById("catProd");
            const tagContainer = document.getElementById("tagContainer");
            const categoriaSelezionata = catSelect.value;

            tagContainer.innerHTML = '';

            if (categoriaSelezionata && tagsPerCategoria[categoriaSelezionata]) {
                tagsPerCategoria[categoriaSelezionata].forEach(tag => {
                    
                    const label = document.createElement("label");
                    label.style.display = "inline-flex";
                    label.style.alignItems = "center";
                    label.style.gap = "8px";
                    label.style.cursor = "pointer";
                    label.style.fontFamily = "'coolveticarg', sans-serif";
                    label.style.color = "#0f0326";

                    const checkbox = document.createElement("input");
                    checkbox.type = "checkbox";
                    checkbox.name = "tags"; 
                    checkbox.value = tag; 

                    const textNode = document.createTextNode(tag);
                    
                    label.appendChild(checkbox);
                    label.appendChild(textNode);
                    tagContainer.appendChild(label);
                });
                
            } else {
                tagContainer.innerHTML = '<span style="color: #666; font-style: italic; font-size: 0.9rem;">Prima scegli la categoria</span>';
            }
        }
    </script>

    <!-- SCRIPT VALIDAZIONE FORM -->
    <script>
        function validaFormProdotto() {
            let isValid = true;
            
            document.getElementById('err-nome').innerText = "";
            document.getElementById('err-prezzo').innerText = "";
            document.getElementById('err-desc').innerText = "";
            document.getElementById('err-tags').innerText = "";

            let nome = document.getElementById('nomeProd').value.trim();
            let regexNome = /^[a-zA-Z0-9\s\-_]{3,50}$/;
            if (!regexNome.test(nome)) {
                document.getElementById('err-nome').innerText = "Il nome deve avere tra 3 e 50 caratteri (solo lettere, numeri, spazi, trattini).";
                isValid = false;
            }

            let prezzo = document.getElementById('prezzoProd').value;
            if (prezzo === "" || isNaN(prezzo) || parseFloat(prezzo) <= 0) {
                document.getElementById('err-prezzo').innerText = "Inserisci un prezzo valido maggiore di 0.";
                isValid = false;
            }

            let desc = document.getElementById('descProd').value.trim();
            if (desc.length < 10) {
                document.getElementById('err-desc').innerText = "La descrizione deve contenere almeno 10 caratteri.";
                isValid = false;
            }

            // Nuova validazione per le checkbox
            const catSelezionata = document.getElementById("catProd").value;
            if (catSelezionata) {
                const checkedTags = document.querySelectorAll('input[name="tags"]:checked');
                if (checkedTags.length === 0) {
                    document.getElementById('err-tags').innerText = "Seleziona almeno un tag per il prodotto.";
                    isValid = false;
                }
            }

            return isValid; 
        }
    </script>

    <!-- SCRIPT TABS NAVIGAZIONE ADMIN -->
	<script>
        document.addEventListener("DOMContentLoaded", function() {
            
            const sezioni = document.querySelectorAll('.admin-main-content section');
            sezioni.forEach((sec) => {
                sec.setAttribute('data-target', '#' + sec.id); 
                
                sec.removeAttribute('id'); 
                
                sec.classList.add('admin-tab-content');
                sec.classList.remove('active-tab'); 
            });

            const hash = window.location.hash.split('?')[0]; 
            let activeSection = null;
            let activeLink = null;

            if (hash) {
                activeSection = document.querySelector('section[data-target="' + hash + '"]');
                activeLink = document.querySelector('.admin-sidebar a[href$="' + hash + '"]');
            }

            if (!activeSection) {
                activeSection = sezioni[0];
                activeLink = document.querySelector('.admin-sidebar a[href="#aggiunta-prodotti"]');
            }

            // 3. MOSTRIAMO LA SCHEDA
            if (activeSection) {
                activeSection.classList.add('active-tab');
            }
            document.querySelectorAll('.admin-sidebar a').forEach(el => el.classList.remove('active'));
            if (activeLink) {
                activeLink.classList.add('active');
            }

            // Forziamo la visuale in alto per massima sicurezza
            setTimeout(() => window.scrollTo(0, 0), 10);

            // 4. GESTIONE CLICK SUL MENU LATERALE
            document.querySelectorAll('.admin-sidebar a[href^="#"]').forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault(); 

                    document.querySelectorAll('.admin-sidebar a').forEach(el => el.classList.remove('active'));
                    this.classList.add('active');

                    sezioni.forEach(sec => sec.classList.remove('active-tab'));

                    const targetHash = this.getAttribute('href');
                    const targetSection = document.querySelector('section[data-target="' + targetHash + '"]');
                    if (targetSection) {
                        targetSection.classList.add('active-tab');
                    }
                    
                    history.replaceState(null, null, targetHash);
                    window.scrollTo(0, 0);
                });
            });
        });
	</script>
<script>
    function clearErrors() {
        document.querySelectorAll('.error-msg').forEach(el => el.innerText = '');
        document.querySelectorAll('.input-error').forEach(el => el.classList.remove('input-error'));
    }
function showCustomAlert(message) {
        const modal = document.getElementById('customAlert');
        const modalText = document.getElementById('customAlertText');
        const okayBtn = document.getElementById('customAlertSingleBtn');
        
        if (modal && modalText) {
            document.getElementById('customAlertSingleBtn').style.display = 'block';
            document.getElementById('customAlertDoubleBtns').style.display = 'none';
            
            modalText.innerText = message;
            modal.style.display = 'flex';
            okayBtn.onclick = closeCustomAlert;
        }
    }

    function showDeleteConfirmAlert(message, formId) {
        const modal = document.getElementById('customAlert');
        const modalText = document.getElementById('customAlertText');
        const confirmBtn = document.getElementById('customAlertConfirmBtn');

        if (modal && modalText && confirmBtn) {
            document.getElementById('customAlertSingleBtn').style.display = 'none';
            document.getElementById('customAlertDoubleBtns').style.display = 'flex';
            
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

    function showSuccessModal(customMessage) {
        const modal = document.getElementById('successModal');
        const modalText = document.getElementById('successModalText');
        if (modal) {
            if(customMessage && customMessage.trim() !== '') {
                modalText.innerText = customMessage;
            }
            modal.style.display = 'flex';
        }
    }

    function closeSuccessModal() {
        const modal = document.getElementById('successModal');
        if (modal) {
            modal.style.display = 'none';
            window.location.reload(); 
        }
    }
</script>
</div> 

<%@ include file="fragment/footer.jspf" %>