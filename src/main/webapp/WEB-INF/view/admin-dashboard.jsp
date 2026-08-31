<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:if test="${empty sessionScope.utenteLoggato or sessionScope.utenteLoggato.ruolo != 'ADMIN'}">
    <c:redirect url="${pageContext.request.contextPath}/login" />
</c:if>

<%@ include file="fragment/header.jspf" %>

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
                    <li><a href="#gestione-prodotti" class="active"><i class="fa-solid fa-box"></i> Prodotti</a></li>
                    <li><a href="#gestione-ordini"><i class="fa-solid fa-receipt"></i> Ordini</a></li>
                    <li><a href="#gestione-commissioni"><i class="fa-solid fa-palette"></i> Commissioni</a></li>
                    <li><a href="#statistiche-sales"><i class="fa-solid fa-chart-line"></i> Statistiche | Sales</a></li>
                    <li><a href="${pageContext.request.contextPath}/index.jsp"><i class="fa-solid fa-house"></i> Torna al Sito</a></li>
                </ul>
            </nav>
        </aside>

        <!-- ================= MAIN CONTENT ================= -->
        <main class="admin-main-content">
            
            <h1>Pannello di Controllo</h1>

            <!-- ================= STATISTICHE E SALES ================= -->
            <section id="statistiche-sales" class="admin-card">
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

                <div class="chart-container">
                    <canvas id="salesChart"></canvas>
                </div>
            </section>

            <!-- ================= GESTIONE PRODOTTI (CREATE) ================= -->
            <section id="gestione-prodotti" class="admin-card mt-4">
                <h2>Aggiungi Nuovo Prodotto</h2>
                
                <!-- CHECKLIST: onsubmit per la validazione JS -->
                <form action="${pageContext.request.contextPath}/AddProductServlet" method="POST" enctype="multipart/form-data" class="admin-form mt-3" onsubmit="return validaFormProdotto()">
                    <div class="form-row">
                        <div class="form-group half-width">
                            <label for="nomeProd">Nome Prodotto</label>
                            <input type="text" id="nomeProd" name="nome">
                            <!-- CHECKLIST: Messaggi errore inline -->
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
                            <select id="catProd" name="categoria" required>
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
                        <label for="descProd">Descrizione</label>
                        <textarea id="descProd" name="descrizione" rows="3"></textarea>
                        <span class="error-msg" id="err-desc"></span>
                    </div>

                    <button type="submit" class="btn-primary">Aggiungi al Catalogo</button>
                </form>
            </section>

            <!-- ================= TABELLA PRODOTTI (READ, UPDATE, DELETE) ================= -->
            <section class="admin-card mt-4">
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
                                <td>${prodotto.categoria}</td>
                                <!-- Corretto in prezzoCorrente -->
                                <td>€ <fmt:formatNumber value="${prodotto.prezzoCorrente}" pattern="#,##0.00"/></td>
                                <td class="table-actions">
                                    <form action="${pageContext.request.contextPath}/EditProductServlet" method="GET">
                                        <input type="hidden" name="id" value="${prodotto.id}">
                                        <button type="submit" class="btn-icon text-blue" title="Modifica"><i class="fa-solid fa-pen"></i></button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/DeleteProductServlet" method="POST">
                                        <input type="hidden" name="id" value="${prodotto.id}">
                                        <button type="submit" class="btn-icon text-red" title="Elimina" onclick="return confirm('Vuoi davvero eliminare questo prodotto?');"><i class="fa-solid fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </section>

            <!-- ================= GESTIONE ORDINI E FILTRO CLIENTE ================= -->
            <section id="gestione-ordini" class="admin-card mt-4">
                <h2>Gestione Ordini</h2>
                
                <!-- CHECKLIST: Filtro ordini per cliente (aggiornato a email) -->
                <div class="filter-bar">
                    <form action="${pageContext.request.contextPath}/FiltraOrdiniAdminServlet" method="GET">
                        <div class="form-group">
                            <label for="filtroCliente">Filtra per Email Cliente:</label>
                            <input type="text" id="filtroCliente" name="email_cliente" value="${param.email_cliente}" placeholder="Es. mario@rossi.it">
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
                        <!-- Verrà popolato dalla Servlet -->
                        <c:forEach var="ordine" items="${listaOrdiniCompleta}">
                            <tr>
                                <td>#${ordine.id}</td>
                                <td>${ordine.data}</td>
                                <!-- Corretto per mostrare nome e cognome invece di username -->
                                <td><strong>${ordine.utente.nome} ${ordine.utente.cognome}</strong></td>
                                <td>€ <fmt:formatNumber value="${ordine.totale}" pattern="#,##0.00"/></td>
                                <td><span class="status-badge status-${ordine.stato.toLowerCase().replace(' ', '-')}">${ordine.stato}</span></td>
                                <td>
                                    <button class="btn-outline-small">Dettagli</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </section>

            <!-- ================= GESTIONE COMMISSIONI ================= -->
            <section id="gestione-commissioni" class="admin-card mt-4">
                <h2>Richieste di Commissione</h2>
                
                <table class="admin-table mt-3">
                    <thead>
                        <tr>
                            <th>ID Req.</th>
                            <th>Utente (Email)</th>
                            <th>Tipo (3D/Texture)</th>
                            <th>Stato</th>
                            <th>Azioni</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="comm" items="${listaCommissioni}">
                            <tr>
                                <td>#${comm.id}</td>
                                <!-- Corretto per usare l'attributo email del bean Commissione -->
                                <td>${comm.email}</td>
                                <td>${comm.tipo}</td>
                                <td>
                                    <span class="status-badge status-${comm.stato.toLowerCase().replace(' ', '-')}">${comm.stato}</span>
                                </td>
                                <td class="table-actions">
                                    <form action="${pageContext.request.contextPath}/GestisciCommissioneServlet" method="GET">
                                        <input type="hidden" name="id" value="${comm.id}">
                                        <button type="submit" class="btn-outline-small">Gestisci</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </section>

        </main>
    </div>

    <!-- SCRIPT PER VALIDAZIONE FORM E REGEX (Richiesto dalla Checklist) -->
    <script>
        function validaFormProdotto() {
            let isValid = true;
            
            // Svuota i messaggi di errore precedenti
            document.getElementById('err-nome').innerText = "";
            document.getElementById('err-prezzo').innerText = "";
            document.getElementById('err-desc').innerText = "";

            // 1. Validazione Nome con Regex (Minimo 3 caratteri, lettere e numeri)
            let nome = document.getElementById('nomeProd').value.trim();
            let regexNome = /^[a-zA-Z0-9\s\-_]{3,50}$/;
            if (!regexNome.test(nome)) {
                document.getElementById('err-nome').innerText = "Il nome deve avere tra 3 e 50 caratteri (solo lettere, numeri, spazi, trattini).";
                isValid = false;
            }

            // 2. Validazione Prezzo (Maggiore di 0)
            let prezzo = document.getElementById('prezzoProd').value;
            if (prezzo === "" || isNaN(prezzo) || parseFloat(prezzo) <= 0) {
                document.getElementById('err-prezzo').innerText = "Inserisci un prezzo valido maggiore di 0.";
                isValid = false;
            }

            // 3. Validazione Descrizione (Non vuota)
            let desc = document.getElementById('descProd').value.trim();
            if (desc.length < 10) {
                document.getElementById('err-desc').innerText = "La descrizione deve contenere almeno 10 caratteri.";
                isValid = false;
            }

            return isValid; // Se false, il form NON viene inviato e mostra i messaggi rossi inline
        }
    </script>

</div> 

<%@ include file="fragment/footer.jspf" %>