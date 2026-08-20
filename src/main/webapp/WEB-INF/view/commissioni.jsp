<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/icons8-star-16.png?v=3">
<link rel="shortcut icon" type="image/png" href="${pageContext.request.contextPath}/images/icons8-star-16.png?v=3">

<% request.setAttribute("titoloPagina", "Commissioni"); 
	request.setAttribute("cssPagina", "commisioni.css");
%>

<div class="bg-video-container">
    <div class="bg-video-overlay"></div>
</div>

<%@ include file="fragment/header.jspf" %>

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
                </fieldset>

                <div class="step-actions single-right">
                    <button type="button" class="btn-primary auth-btn" onclick="nextStep(2)">Avanti</button>
                </div>
            </div>

            <div class="form-step" id="step-2">
                <fieldset class="form-section">
                    <legend><i class="fa-solid fa-pen-nib"></i><span> Descrizione ordine</span></legend>
                    
                    <div class="form-group">
                        <textarea name="descrizione_principale" rows="4" placeholder="Descrivi il tuo progetto nei dettagli..." required></textarea>
                    </div>

                    <div class="optional-3d-section" id="optional3DSection">
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
                                <input type="email" id="commEmail" name="email" required>
                            </div>
                            
                            <div class="form-group address-group">
                            <!-- da far comparire solo se spuntaa -->
                                <label>Indirizzo: <span class="note">solo per le stampe 3d da consegnare</span></label>
                                <input type="text" name="indirizzo_via" placeholder="Via/Piazza e Civico">
                                <div class="address-row">
                                    <input type="text" name="indirizzo_citta" placeholder="Città">
                                    <input type="text" name="indirizzo_cap" placeholder="CAP">
                                </div>
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
                    <button type="submit" class="btn-primary auth-btn">Conferma</button>
                </div>
            </div>

        </form>
    </div>
</main>

<!-- SCRIPT PER LA NAVIGAZIONE TRA GLI STEP -->
<script>
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
</script>

<%@ include file="fragment/footer.jspf" %>