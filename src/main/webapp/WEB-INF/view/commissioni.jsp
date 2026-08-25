<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<% 
    request.setAttribute("titoloPagina", "Commissioni"); 
    request.setAttribute("cssPagina", "commisioni.css");
%>

<%@ include file="fragment/header.jspf" %>

<!-- Modal Popup Personalizzato -->
<div id="customAlert" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px); z-index: 999999; justify-content: center; align-items: center;">
    <div style="background: rgba(255, 255, 255, 0.65); backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.5); border-radius: 20px; padding: 30px; max-width: 380px; width: 85%; text-align: center; box-shadow: 0 8px 32px 0 rgba(0,0,0,0.3);">
        <i class="fa-solid fa-circle-exclamation" style="font-size: 2.5rem; color: #e56399; margin-bottom: 15px;"></i>
        <h3 style="font-family: 'elephant', sans-serif; font-weight: bold; margin-bottom: 10px;">Attenzione!</h3>
        <p id="customAlertText" style="font-family: 'coolveticarg', sans-serif; margin-bottom: 20px; color: #333;">Seleziona almeno una tipologia di ordine per proseguire!</p>
        <button type="button" class="btn-primary auth-btn" onclick="closeCustomAlert()">Okay</button>
    </div>
</div>

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

                        <div class="optional-3d-section hidden-section" id="optional3DSection">
                            <p class="section-subtitle">(opzionale) Puoi richiedere:</p>
                            
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
                                
                                <div class="form-group address-group hidden-section" id="addressGroup">
                                    <label>Indirizzo: </label>
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
    // navigazione a step
    
    function showCustomAlert(message) {
    	
    	const modal = document.getElementById('customAlert');
        const modalText = document.getElementById('customAlertText');
        if (modal && modalText) {
            modalText.innerText = message;
            modal.style.display = 'flex';
        }
    }

	function closeCustomAlert() {
		
		const modal = document.getElementById('customAlert');
	    if (modal) {
	        modal.style.display = 'none';
	    }
	}
	
    function nextStep(stepNumber) {
    	
    	const currentActiveStep = document.querySelector('.form-step.active');
        
        if (currentActiveStep && currentActiveStep.id === 'step-1') {
            // Controlla se almeno un checkbox di tipo_commissione è selezionato
            const checkboxes = document.querySelectorAll('input[name="tipo_commissione"]:checked');
            
            if (checkboxes.length === 0) {
                showCustomAlert('Seleziona almeno una tipologia di ordine per proseguire!');
                return; // Blocca l'avanzamento
            }
        }
    	
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

    // nascondi/mostra sezioni
    document.addEventListener('DOMContentLoaded', function() {
        
        // seleziona "Stampa 3D" -> mostra indirizzo
        document.getElementById('checkStampa').addEventListener('change', function() {
            const addressGroup = document.getElementById('addressGroup');
            if(this.checked) {
                addressGroup.classList.remove('hidden-section');
            } else {
                addressGroup.classList.add('hidden-section');
            }
        });

        // seleziona "Modello 3D" -> Mostra opzioni 3D aggiuntive
        document.getElementById('checkModello').addEventListener('change', function() {
            const modelGroup = document.getElementById('optional3DSection');
            if(this.checked) {
                modelGroup.classList.remove('hidden-section');
            } else {
                modelGroup.classList.add('hidden-section');
            }
        });
    });

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

<script>
	document.addEventListener('DOMContentLoaded', () => {
    	const checkStampa = document.getElementById('checkStampa');
    	const checkModello = document.getElementById('checkModello');
    
    	// Elementi da mostrare/nascondere
    	const addressGroup = document.querySelector('.address-group');
    	const optional3DSection = document.getElementById('optional3DSection');

    	// Funzione per aggiornare la visibilità
    	function updateDynamicSections() {
        	// Mostra indirizzo solo se Stampa 3D è spuntata
        	if (addressGroup) {
            	addressGroup.style.display = checkStampa.checked ? 'block' : 'none';
        	}

        	// Mostra dettagli 3D solo se Modello 3D è spuntato
        	if (optional3DSection) {
            	optional3DSection.style.display = checkModello.checked ? 'block' : 'none';
        	}
    	}

    	// Ascolta i cambiamenti sui checkbox
    	document.querySelectorAll('input[name="tipo_commissione"]').forEach(checkbox => {
        	checkbox.addEventListener('change', updateDynamicSections);
    	});

    	// Esegui subito all'avvio
    	updateDynamicSections();
	});
</script>

<%@ include file="fragment/footer.jspf" %>