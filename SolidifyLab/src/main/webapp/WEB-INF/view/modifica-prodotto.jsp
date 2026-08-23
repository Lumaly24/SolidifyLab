<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- CONTROLLO DI SICUREZZA: Solo l'admin può stare qui -->
<c:if test="${empty sessionScope.utenteLoggato or !sessionScope.utenteLoggato.admin}">
    <c:redirect url="login.jsp" />
</c:if>

<!-- Sicurezza 2: Se manca l'oggetto prodotto, rimanda alla dashboard -->
<c:if test="${empty prodotto}">
    <c:redirect url="admin.jsp" />
</c:if>

<% request.setAttribute("titoloPagina", "Modifica Prodotto | Admin"); %>
<%@ include file="fragment/header.jspf" %>

<div class="admin-layout">
    
    <!-- SIDEBAR ADMIN (Semplificata o uguale a quella dell'admin) -->
    <aside class="admin-sidebar">
        <nav>
            <ul>
                <li><a href="${pageContext.request.contextPath}/admin.jsp"><i class="fa-solid fa-arrow-left"></i> Torna alla Dashboard</a></li>
            </ul>
        </nav>
    </aside>

    <main class="admin-main-content">
        
        <h1 style="margin-bottom: 20px;">Modifica Prodotto #${prodotto.id}</h1>

        <section class="admin-card">
            <h2>Dettagli Prodotto</h2>
            
            <!-- Il form invia i dati alla Servlet di Update. Manteniamo multipart/form-data per l'immagine -->
            <form action="${pageContext.request.contextPath}/UpdateProductServlet" method="POST" enctype="multipart/form-data" class="admin-form mt-3" onsubmit="return validaModificaProdotto()">
                
                <!-- FONDAMENTALE: l'ID nascosto -->
                <input type="hidden" name="id" value="${prodotto.id}">

                <div class="form-row">
                    <div class="form-group half-width">
                        <label for="modNome">Nome Prodotto</label>
                        <!-- value precompilato -->
                        <input type="text" id="modNome" name="nome" value="${prodotto.nome}">
                        <span class="error-msg" id="err-mod-nome"></span>
                    </div>
                    
                    <div class="form-group half-width">
                        <label for="modPrezzo">Prezzo (€)</label>
                        <!-- Rimuoviamo la virgola per i campi number, usiamo il punto per compatibilità HTML -->
                        <input type="number" id="modPrezzo" name="prezzo" step="0.01" min="0" value="${prodotto.prezzo}">
                        <span class="error-msg" id="err-mod-prezzo"></span>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group half-width">
                        <label for="modCat">Categoria</label>
                        <select id="modCat" name="categoria" required>
                            <!-- Seleziona dinamicamente l'option giusta in base al dato del DB -->
                            <option value="MODELLO_3D" ${prodotto.categoria == 'MODELLO_3D' ? 'selected' : ''}>Modello 3D</option>
                            <option value="TEXTURE" ${prodotto.categoria == 'TEXTURE' ? 'selected' : ''}>Texture</option>
                            <option value="STAMPA_3D" ${prodotto.categoria == 'STAMPA_3D' ? 'selected' : ''}>Stampa 3D</option>
                        </select>
                    </div>
                    
                    <div class="form-group half-width">
                        <label for="modImg">Nuova Immagine (Opzionale)</label>
                        <!-- Non è required! Se l'admin non mette nulla, la servlet manterrà l'immagine vecchia -->
                        <input type="file" id="modImg" name="immagine" accept="image/*">
                        <span class="note text-muted">Lascia vuoto per mantenere l'immagine attuale.</span>
                    </div>
                </div>

                <div class="form-group">
                    <label for="modDesc">Descrizione</label>
                    <!-- Nelle textarea il value si mette in mezzo ai tag! -->
                    <textarea id="modDesc" name="descrizione" rows="5">${prodotto.descrizione}</textarea>
                    <span class="error-msg" id="err-mod-desc"></span>
                </div>

                <div class="form-actions mt-4">
                    <a href="${pageContext.request.contextPath}/admin.jsp" class="btn-secondary">Annulla</a>
                    <button type="submit" class="btn-primary">Salva Modifiche</button>
                </div>
            </form>
        </section>

    </main>
</div>

<!-- CHECKLIST: JS Validazione (Come per l'inserimento) -->
<script>
    function validaModificaProdotto() {
        let isValid = true;
        
        document.getElementById('err-mod-nome').innerText = "";
        document.getElementById('err-mod-prezzo').innerText = "";
        document.getElementById('err-mod-desc').innerText = "";

        // Validazione Nome
        let nome = document.getElementById('modNome').value.trim();
        let regexNome = /^[a-zA-Z0-9\s\-_]{3,50}$/;
        if (!regexNome.test(nome)) {
            document.getElementById('err-mod-nome').innerText = "Tra 3 e 50 caratteri ammessi.";
            isValid = false;
        }

        // Validazione Prezzo
        let prezzo = document.getElementById('modPrezzo').value;
        if (prezzo === "" || isNaN(prezzo) || parseFloat(prezzo) <= 0) {
            document.getElementById('err-mod-prezzo').innerText = "Prezzo non valido.";
            isValid = false;
        }

        // Validazione Descrizione
        let desc = document.getElementById('modDesc').value.trim();
        if (desc.length < 10) {
            document.getElementById('err-mod-desc').innerText = "La descrizione deve essere di almeno 10 caratteri.";
            isValid = false;
        }

        if(isValid) {
            return confirm("Vuoi davvero salvare queste modifiche al prodotto?");
        }

        return isValid; 
    }
</script>

<%@ include file="fragment/footer.jspf" %>