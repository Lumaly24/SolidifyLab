<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<% 
    request.setAttribute("titoloPagina", "Commissioni"); 
    request.setAttribute("cssPagina", "commisioni.css");
%>
<%@ include file="fragment/header.jspf" %>

<div class="bg-video-container">
    <div class="bg-video-overlay"></div>
</div>

	<main class="commission-page-container">
	    <div class="commission-form-wrapper">
            <h1>Richiedi un Progetto su Misura</h1>
            <p>Compila il form per ricevere un preventivo per le tue stampe, modelli o texture.</p>
            
            <div class="step-indicator">
                <div class="step-dot active" id="dot-1">1</div>
                <div class="step-line"></div>
                <div class="step-dot" id="dot-2">2</div>
                <div class="step-line"></div>
                <div class="step-dot" id="dot-3">3</div>
            </div>
               
            <!-- Inserito il tag form mancante con l'evento onsubmit per la validazione JS -->
            <form id="commissionForm" action="${pageContext.request.contextPath}/RichiestaCommissioneServlet" method="POST" onsubmit="return validaCommissione()">
                
                <div class="form-step active" id="step-1">
                    <fieldset class="form-section">
                        <legend><i class="fa-solid fa-wand-magic-sparkles"></i><span> Cosa vuoi ordinare?</span></legend>
                        
                        <div class="checkbox-group inline-group">
                            <label>
                                <input type="checkbox" name="tipo_commissione" value="stampa_3d" id="checkStampa"> Stampa 3D
                            </label>
                            <label>
                                <input type="checkbox" name="tipo_commissione" value="modello_3d" id="checkModello"> Modello 3D
                            </label>
                            <label>
                                <input type="checkbox" name="tipo_commissione" value="texture" id="checkTexture"> Texture
                            </label>
                        </div>
                        <span class="error-msg" id="err-tipo"></span>
                    </fieldset>

                    <div class="step-actions single-right">
                        <button type="button" class="btn-primary auth-btn" onclick="nextStep(2)">Avanti</button>
                    </div>
                </div>

                <div class="form-step" id="step-2">
                    <fieldset class="form-section">
                        <legend><i class="fa-solid fa-pen-nib"></i><span> Descrizione ordine</span></legend>
                        
                        <div class="form-group">
                            <textarea name="descrizione_principale" id="descPrincipale" rows="4" placeholder="Descrivi il tuo progetto nei dettagli..."></textarea>
                            <span class="error-msg" id="err-desc"></span>
                        </div>

                        <!-- Aggiunta classe hidden-section (da gestire via CSS) -->
                        <div class="optional-3d-section hidden-section" id="optional3DSection">
                            <p class="section-subtitle">Se stai ordinando un modello 3D *:</p>
                            
                            <div class="split-options">
                                <div class="option-box">
                                    <label>
                                        <input type="checkbox" name="include_texture"> Modello con texture
                                    </label>
                                    <textarea name="descrizione_texture" rows="2" placeholder="Descrizione texture..."></textarea>
                                </div>
                                <div class="option-box">
                                    <label>
                                        <input type="checkbox" name="include_animazione"> Modello animato
                                    </label>
                                    <textarea name="descrizione_animazione" rows="2" placeholder="Descrizione animazione..."></textarea>
                                </div>
                            </div>
                        </div>
                    </fieldset>

                    <div class="step-actions">
                        <button type="button" class="btn-secondary" onclick="prevStep(1)">Indietro</button>
                        <button type="button" class="btn-primary auth-btn" onclick="nextStep(3)">Avanti</button>
                    </div>
                </div>

                <div class="form-step" id="step-3">
                    <fieldset class="form-section">
                        <legend><i class="fa-solid fa-address-card"></i><span> Inserimento Dati Personali</span></legend>
                        
                        <div class="personal-data-layout">
                            <div class="data-inputs">
                                <div class="form-group">
                                    <label for="commEmail">E-mail :</label>
                                    <input type="email" id="commEmail" name="email" value="${sessionScope.utenteLoggato.email}">
                                    <span class="error-msg" id="err-email"></span>
                                </div>
                                
                                <!-- Aggiunta classe hidden-section (da gestire via CSS) -->
                                <div class="form-group address-group hidden-section" id="addressGroup">
                                    <label>Indirizzo: <span class="note">solo per le stampe 3d da consegnare</span></label>
                                    <input type="text" id="indVia" name="indirizzo_via" placeholder="Via/Piazza e Civico">
                                    <span class="error-msg" id="err-via"></span>
                                    
                                    <div class="address-row">
                                        <input type="text" id="indCitta" name="indirizzo_citta" placeholder="Città">
                                        <input type="text" id="indCap" name="indirizzo_cap" placeholder="CAP">
                                    </div>
                                    <span class="error-msg" id="err-citta"></span>
                                    <span class="error-msg" id="err-cap"></span>
                                </div>
                            </div>

                            <div class="data-info-side">
                                <h4>Info Utili</h4>
                                <ul>
                                    <li>Preventivi gratuiti.</li>
                                    <li>Risposta in 24/48h.</li>
                                    <li>Spedizione tracciabile.</li>
                                </ul>
                            </div>
                        </div>
                    </fieldset>

                    <div class="step-actions">
                        <button type="button" class="btn-secondary" onclick="prevStep(2)">Indietro</button>
                        <button type="submit" class="btn-primary auth-btn">Conferma Richiesta</button>
                    </div>
                </div>

            </form>
        </div>
    </main>

<script>
    // ==========================================
    // LOGICA DI NAVIGAZIONE A STEP
    // ==========================================
    function nextStep(stepNumber) {
        document.querySelectorAll('.form-step').forEach(step => step.classList.remove('active'));
        document.getElementById('step-' + stepNumber).classList.add('active');
        updateDots(stepNumber);
    }

    function prevStep(stepNumber) {
        document.querySelectorAll('.form-step').forEach(step => step.classList.remove('active'));
        document.getElementById('step-' + stepNumber).classList.add('active');
        updateDots(stepNumber);
    }

    function updateDots(stepNumber) {
        document.querySelectorAll('.step-dot').forEach((dot, index) => {
            if (index + 1 <= stepNumber) {
                dot.classList.add('active');
            } else {
                dot.classList.remove('active');
            }
        });
    }

    // ==========================================
    // DINAMISMO UI (Nascondi/Mostra Sezioni)
    // ==========================================
    document.addEventListener('DOMContentLoaded', function() {
        
        // Seleziona "Stampa 3D" -> Mostra indirizzo
        document.getElementById('checkStampa').addEventListener('change', function() {
            const addressGroup = document.getElementById('addressGroup');
            if(this.checked) {
                addressGroup.classList.remove('hidden-section');
            } else {
                addressGroup.classList.add('hidden-section');
            }
        });

        // Seleziona "Modello 3D" -> Mostra opzioni 3D aggiuntive
        document.getElementById('checkModello').addEventListener('change', function() {
            const modelGroup = document.getElementById('optional3DSection');
            if(this.checked) {
                modelGroup.classList.remove('hidden-section');
            } else {
                modelGroup.classList.add('hidden-section');
            }
        });
    });

    // ==========================================
    // VALIDAZIONE FORM FINALE
    // ==========================================
    function validaCommissione() {
        let isValid = true;
        
        // Pulisce tutti i messaggi di errore
        document.querySelectorAll('.error-msg').forEach(el => el.innerText = '');

        // 1. Controllo Selezione Iniziale (Almeno una spunta)
        const checkStampa = document.getElementById('checkStampa').checked;
        const checkModello = document.getElementById('checkModello').checked;
        const checkTexture = document.getElementById('checkTexture').checked;
        
        if(!checkStampa && !checkModello && !checkTexture) {
            document.getElementById('err-tipo').innerText = 'Seleziona almeno un tipo di commissione.';
            nextStep(1); // Riporta l'utente allo step 1 se ha barato
            return false;
        }

        // 2. Controllo Descrizione
        const desc = document.getElementById('descPrincipale').value.trim();
        if(desc.length < 15) {
            document.getElementById('err-desc').innerText = 'Fornisci una descrizione più dettagliata (almeno 15 caratteri).';
            nextStep(2);
            isValid = false;
        }

        // 3. Controllo Email
        const email = document.getElementById('commEmail').value.trim();
        const regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if(!regexEmail.test(email)) {
            document.getElementById('err-email').innerText = 'Inserisci un indirizzo email valido.';
            isValid = false;
        }

        // 4. Controllo Indirizzo (Solo se ha selezionato Stampa 3D)
        if(checkStampa) {
            const via = document.getElementById('indVia').value.trim();
            const citta = document.getElementById('indCitta').value.trim();
            const cap = document.getElementById('indCap').value.trim();
            const regexCap = /^[0-9]{5}$/;

            if(via === '') { document.getElementById('err-via').innerText = 'La via è obbligatoria per le stampe fisiche.'; isValid = false; }
            if(citta === '') { document.getElementById('err-citta').innerText = 'La città è obbligatoria.'; isValid = false; }
            if(!regexCap.test(cap)) { document.getElementById('err-cap').innerText = 'Inserisci un CAP valido (5 cifre).'; isValid = false; }
        }

        return isValid;
    }
</script>

<%@ include file="fragment/footer.jspf" %>