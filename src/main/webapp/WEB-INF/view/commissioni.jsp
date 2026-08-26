<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<% 
    request.setAttribute("titoloPagina", "Commissioni"); 
    request.setAttribute("cssPagina", "commisioni.css");
%>

<%@ include file="fragment/header.jspf" %>

<!-- Stile dinamico per i bordi di errore -->
<style>
    .input-error {
        border: 2px solid #e56399 !important;
        box-shadow: 0 0 8px rgba(229, 99, 153, 0.4) !important;
        transition: all 0.3s ease;
    }
</style>

<!-- Stringa di supporto per mantenere spuntate le checkbox se il form fallisce -->
<c:set var="tipiSelezionati" value="${fn:join(paramValues.tipo_commissione, ',')}" />

<!-- Modal Popup Successo -->
<div id="successModal" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px); z-index: 999999; justify-content: center; align-items: center;">
    <div style="background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.5); border-radius: 20px; padding: 40px 30px; max-width: 400px; width: 85%; text-align: center; box-shadow: 0 10px 40px rgba(0,0,0,0.2);">
        <i class="fa-solid fa-circle-check" style="font-size: 3.5rem; color: #2ecc71; margin-bottom: 20px;"></i>
        <h3 style="font-family: 'elephant', sans-serif; font-weight: bold; margin-bottom: 15px; color: #333;">Evviva!</h3>
        <p id="successModalText" style="font-family: 'coolveticarg', sans-serif; margin-bottom: 25px; color: #555; font-size: 1.1rem; line-height: 1.4;">
            La tua richiesta di commissione è stata inviata con successo. Ti risponderemo in 24/48h!
        </p>
        <button type="button" class="btn-primary auth-btn" onclick="closeSuccessModal()" style="width: 100%;">Torna alla Home</button>
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
        
        <form id="commissionForm" action="${pageContext.request.contextPath}/RichiestaCommissioneServlet" method="POST" enctype="multipart/form-data" onsubmit="return validaCommissione()">
            
            <!-- STEP 1 -->
            <div class="form-step active" id="step-1">
                <fieldset class="form-section">
                    <legend><i class="fa-solid fa-wand-magic-sparkles"></i><span> Cosa vuoi ordinare?</span></legend>
                    
                    <div class="checkbox-group inline-group" id="groupCheckboxes" style="padding: 10px; border-radius: 8px;">
                        <label>
                            <input type="checkbox" name="tipo_commissione" value="stampa_3d" id="checkStampa" <c:if test="${fn:contains(tipiSelezionati, 'stampa_3d')}">checked</c:if>> Stampa 3D
                        </label>
                        <label>
                            <input type="checkbox" name="tipo_commissione" value="modello_3d" id="checkModello" <c:if test="${fn:contains(tipiSelezionati, 'modello_3d')}">checked</c:if>> Modello 3D
                        </label>
                        <label>
                            <input type="checkbox" name="tipo_commissione" value="texture" id="checkTexture" <c:if test="${fn:contains(tipiSelezionati, 'texture')}">checked</c:if>> Texture
                        </label>
                    </div>
                    <span class="error-msg" id="err-tipo" style="color: #e56399; font-weight: bold; display: block; margin-top: 5px; text-align: right;"></span>
                </fieldset>

                <div class="step-actions single-right">
                    <button type="button" class="btn-primary auth-btn" onclick="nextStep(2)">Avanti</button>
                </div>
            </div>

            <!-- STEP 2 -->
            <div class="form-step" id="step-2">
                <fieldset class="form-section">
                    <legend><i class="fa-solid fa-pen-nib"></i><span> Descrizione ordine*</span></legend>
                    
                    <!-- Validazione nativa HTML5 + XSS Security c:out -->
                    <div class="form-group">
                        <textarea name="descrizione_principale" id="descPrincipale" rows="4" minlength="15" maxlength="2000" required placeholder="Descrivi il tuo progetto nei dettagli (dimensioni, proporzioni, riferimenti)..."><c:out value="${param.descrizione_principale}" /></textarea>
                        <span class="error-msg" id="err-desc" style="color: #e56399; font-weight: bold; display: block; margin-top: 5px;"></span>
                    </div>

                    <!-- CAMPO UPLOAD FILE CON FEEDBACK -->
                    <div class="form-group" style="margin-top: 15px;">
                        <label for="fileRiferimento" style="font-weight: bold;"><i class="fa-solid fa-file-arrow-up"></i> Allega file di riferimento (Opzionale)</label>
                        <input type="file" name="file_riferimento" id="fileRiferimento" multiple style="width: 100%; padding: 10px; margin-top: 5px; border-radius: 5px; border: 1px dashed #ccc; font-family: inherit; background-color: rgba(255,255,255,0.7); cursor: pointer;">
                        <small style="color: #666; display: block; margin-top: 5px;">Formati supportati: .stl, .obj, .blend, .png, .jpg (Max 20MB totali)</small>
                        <div id="file-feedback" style="margin-top: 8px; font-size: 0.95rem; color: #2ecc71; font-weight: bold;"></div>
                    </div>

                    <!-- OPZIONI STAMPA 3D -->
                    <div class="optional-section hidden-section" id="optionalStampaSection" style="margin-top: 20px;">
                        <p class="section-subtitle">Opzioni Aggiuntive <strong>Stampa 3D:</strong></p>
                        
                        <div class="split-options">
                            <div class="option-box">
                                <label><input type="checkbox" name="include_materiale" id="checkMateriale" <c:if test="${not empty param.include_materiale}">checked</c:if>> Specifica Materiale</label>
                                <div id="containerMateriale" style="display: none; margin-top: 10px;">
                                    <select name="materiale_stampa" style="width: 100%; padding: 8px; margin-bottom: 10px; border-radius: 5px; border: 1px solid #ccc; font-family: inherit;">
                                        <option value="" disabled <c:if test="${empty param.materiale_stampa}">selected</c:if>>Scegli il materiale...</option>
                                        <option value="pla" <c:if test="${param.materiale_stampa == 'pla'}">selected</c:if>>PLA (Economico, standard)</option>
                                        <option value="resina" <c:if test="${param.materiale_stampa == 'resina'}">selected</c:if>>Resina (Alta precisione)</option>
                                        <option value="petg_abs" <c:if test="${param.materiale_stampa == 'petg_abs'}">selected</c:if>>PETG / ABS (Resistenza)</option>
                                    </select>
                                    <textarea name="desc_materiale" rows="2" maxlength="300" placeholder="Note sul materiale (es. colore base)..."><c:out value="${param.desc_materiale}" /></textarea>
                                </div>
                            </div>

                            <div class="option-box">
                                <label><input type="checkbox" name="include_postproduzione" id="checkPostProduzione" <c:if test="${not empty param.include_postproduzione}">checked</c:if>> Post-produzione</label>
                                <div id="containerPostProduzione" style="display: none; margin-top: 10px;">
                                    <select name="tipo_postproduzione" style="width: 100%; padding: 8px; margin-bottom: 10px; border-radius: 5px; border: 1px solid #ccc; font-family: inherit;">
                                        <option value="" disabled <c:if test="${empty param.tipo_postproduzione}">selected</c:if>>Livello di finitura...</option>
                                        <option value="rimozione_supporti" <c:if test="${param.tipo_postproduzione == 'rimozione_supporti'}">selected</c:if>>Solo rimozione supporti</option>
                                        <option value="primer" <c:if test="${param.tipo_postproduzione == 'primer'}">selected</c:if>>Levigatura + Primer base</option>
                                        <option value="pittura" <c:if test="${param.tipo_postproduzione == 'pittura'}">selected</c:if>>Pittura completa a mano</option>
                                    </select>
                                    <textarea name="desc_postproduzione" rows="2" maxlength="300" placeholder="Dettagli sulle finiture..."><c:out value="${param.desc_postproduzione}" /></textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- OPZIONI MODELLO 3D -->
                    <div class="optional-section hidden-section" id="optionalModelloSection" style="margin-top: 20px;">
                        <p class="section-subtitle">Opzioni aggiuntive <strong>Modello 3D:</strong></p>
                        <div class="split-options">
                            <div class="option-box">
                                <label><input type="checkbox" name="include_texture_modello" <c:if test="${not empty param.include_texture_modello}">checked</c:if>> Modello con texture</label>
                                <textarea name="descrizione_texture_modello" rows="2" maxlength="300" placeholder="Descrizione texture (stile, risoluzione)..."><c:out value="${param.descrizione_texture_modello}" /></textarea>
                            </div>
                            <div class="option-box">
                                <label><input type="checkbox" name="include_animazione" <c:if test="${not empty param.include_animazione}">checked</c:if>> Modello animato</label>
                                <textarea name="descrizione_animazione" rows="2" maxlength="300" placeholder="Tipo di animazione (camminata, idle...)?"><c:out value="${param.descrizione_animazione}" /></textarea>
                            </div>
                            <div class="option-box">
                                <label><input type="checkbox" name="include_rigging" <c:if test="${not empty param.include_rigging}">checked</c:if>> Rigging</label>
                                <textarea name="descrizione_rigging" rows="2" maxlength="300" placeholder="Dettagli sul rigging..."><c:out value="${param.descrizione_rigging}" /></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- OPZIONI TEXTURE -->
                    <div class="optional-section hidden-section" id="optionalTextureSection" style="margin-top: 20px;">
                        <p class="section-subtitle">Opzioni Aggiuntive <strong>Texture:</strong></p>
                        <div class="split-options">
                            <div class="option-box">
                                <label><input type="checkbox" name="include_uv_mapping" <c:if test="${not empty param.include_uv_mapping}">checked</c:if>> Mappatura UV</label>
                                <textarea name="desc_uv_mapping" rows="2" maxlength="300" placeholder="Dettagli UV Mapping..."><c:out value="${param.desc_uv_mapping}" /></textarea>
                            </div>
                            <div class="option-box">
                                <label><input type="checkbox" name="include_materiali_pbr" <c:if test="${not empty param.include_materiali_pbr}">checked</c:if>> Materiali PBR Specifici</label>
                                <textarea name="desc_materiali_pbr" rows="2" maxlength="300" placeholder="Es: Metallo graffiato..."><c:out value="${param.desc_materiali_pbr}" /></textarea>
                            </div>
                        </div>
                    </div>
                    
                </fieldset>

                <div class="step-actions">
                    <button type="button" class="btn-secondary" onclick="prevStep(1)">Indietro</button>
                    <button type="button" class="btn-primary auth-btn" onclick="nextStep(3)">Avanti</button>
                </div>
            </div>

            <!-- STEP 3 -->
            <div class="form-step" id="step-3">
                <fieldset class="form-section">
                    <legend><i class="fa-solid fa-address-card"></i><span> Inserimento Dati Personali</span></legend>
                    
                    <div class="personal-data-layout">
                        <div class="data-inputs">
                            <div class="form-group">
                                <label for="commEmail">E-mail :</label>
                                <input type="email" id="commEmail" name="email" value="<c:out value='${not empty param.email ? param.email : sessionScope.utenteLoggato.email}' />" required>
                                <span class="error-msg" id="err-email" style="color: #e56399; font-weight: bold;"></span>
                            </div>
                            
                            <div class="form-group address-group" id="addressGroup" style="display: none; margin-top: 15px;">
                                <label>Indirizzo di Spedizione (per Stampa 3D): </label>
                                <input type="text" id="indVia" name="indirizzo_via" value="<c:out value='${param.indirizzo_via}' />" placeholder="Via/Piazza e Civico" maxlength="150">
                                <span class="error-msg" id="err-via" style="color: #e56399; font-weight: bold;"></span>
                                
                                <div class="address-row" style="margin-top: 10px;">
                                    <input type="text" id="indCitta" name="indirizzo_citta" value="<c:out value='${param.indirizzo_citta}' />" placeholder="Città" maxlength="100">
                                    <input type="text" id="indCap" name="indirizzo_cap" value="<c:out value='${param.indirizzo_cap}' />" placeholder="CAP" maxlength="5" pattern="[0-9]{5}">
                                </div>
                                <span class="error-msg" id="err-citta" style="color: #e56399; font-weight: bold; display:block;"></span>
                                <span class="error-msg" id="err-cap" style="color: #e56399; font-weight: bold; display:block;"></span>
                            </div>
                        </div>

                        <div class="data-info-side">
                            <h4>Info Utili</h4>
                            <ul>
                                <li>Preventivi gratuiti in 24/48h.</li>
                                <li>Stampe fisiche spedite con corriere tracciabile.</li>
                                <li>File digitali consegnati via cloud.</li>
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
    // Helper per pulire messaggi e bordi d'errore
    function clearErrors() {
        document.querySelectorAll('.error-msg').forEach(el => el.innerText = '');
        document.querySelectorAll('.input-error').forEach(el => el.classList.remove('input-error'));
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
            window.location.href = "${pageContext.request.contextPath}/index.jsp";
        }
    }

    function nextStep(stepNumber) {
        const currentActiveStep = document.querySelector('.form-step.active');
        clearErrors();
        
        // CONTROLLI STEP 1
        if (currentActiveStep && currentActiveStep.id === 'step-1') {
            const checkboxes = document.querySelectorAll('input[name="tipo_commissione"]:checked');
            if (checkboxes.length === 0) {
                document.getElementById('err-tipo').innerText = 'Devi selezionare almeno un\'opzione per proseguire.';
                document.getElementById('groupCheckboxes').classList.add('input-error');
                return; 
            }
        }

        // CONTROLLI STEP 2
        if (currentActiveStep && currentActiveStep.id === 'step-2') {
            const descInput = document.getElementById('descPrincipale');
            if (descInput.value.trim().length < 15) {
                document.getElementById('err-desc').innerText = '*Fornisci una descrizione di almeno 15 caratteri per proseguire.';
                descInput.classList.add('input-error');
                return; 
            }

            const optionBoxes = document.querySelectorAll('#step-2 .option-box');
            for (let i = 0; i < optionBoxes.length; i++) {
                const box = optionBoxes[i];
                const checkbox = box.querySelector('input[type="checkbox"]');
                
                if (checkbox && checkbox.checked) {
                    const select = box.querySelector('select');
                    const textarea = box.querySelector('textarea');

                    if (select && select.value === "") {
                        document.getElementById('err-desc').innerText = 'Hai spuntato un\'opzione aggiuntiva: ricordati di fare una scelta dal menu a tendina.';
                        select.classList.add('input-error');
                        return; 
                    }

                    if (textarea && !select && textarea.value.trim().length < 3) {
                        document.getElementById('err-desc').innerText = 'Hai spuntato un\'opzione extra: inserisci una breve descrizione nel relativo campo di testo.';
                        textarea.classList.add('input-error');
                        return; 
                    }
                }
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

    function validaCommissione() {
        let isValid = true;
        clearErrors();

        const checkStampa = document.getElementById('checkStampa').checked;
        const checkModello = document.getElementById('checkModello').checked;
        const checkTexture = document.getElementById('checkTexture').checked;
        
        if(!checkStampa && !checkModello && !checkTexture) {
            document.getElementById('err-tipo').innerText = 'Devi selezionare almeno un\'opzione per proseguire.';
            document.getElementById('groupCheckboxes').classList.add('input-error');
            nextStep(1); 
            return false;
        }

        const descInput = document.getElementById('descPrincipale');
        if(descInput.value.trim().length < 15) {
            document.getElementById('err-desc').innerText = '*Fornisci una descrizione di almeno 15 caratteri per proseguire.';
            descInput.classList.add('input-error');
            nextStep(2);
            isValid = false;
        }

        const optionBoxes = document.querySelectorAll('#step-2 .option-box');
        for (let i = 0; i < optionBoxes.length; i++) {
            const checkbox = optionBoxes[i].querySelector('input[type="checkbox"]');
            if (checkbox && checkbox.checked) {
                const select = optionBoxes[i].querySelector('select');
                const textarea = optionBoxes[i].querySelector('textarea');
                if (select && select.value === "") {
                    document.getElementById('err-desc').innerText = 'Compila correttamente le opzioni extra che hai spuntato.';
                    select.classList.add('input-error');
                    nextStep(2); 
                    return false;
                }
                if (textarea && !select && textarea.value.trim().length < 3) {
                    document.getElementById('err-desc').innerText = 'Compila correttamente le opzioni extra che hai spuntato.';
                    textarea.classList.add('input-error');
                    nextStep(2); 
                    return false;
                }
            }
        }

        const emailInput = document.getElementById('commEmail');
        const regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if(!regexEmail.test(emailInput.value.trim())) {
            document.getElementById('err-email').innerText = 'Inserisci un indirizzo email valido.';
            emailInput.classList.add('input-error');
            isValid = false;
        }

        if(checkStampa) {
            const viaInput = document.getElementById('indVia');
            const cittaInput = document.getElementById('indCitta');
            const capInput = document.getElementById('indCap');
            const regexCap = /^[0-9]{5}$/;

            if(viaInput.value.trim() === '') { 
                document.getElementById('err-via').innerText = 'La via è obbligatoria per le stampe fisiche.'; 
                viaInput.classList.add('input-error');
                isValid = false; 
            }
            if(cittaInput.value.trim() === '') { 
                document.getElementById('err-citta').innerText = 'La città è obbligatoria.'; 
                cittaInput.classList.add('input-error');
                isValid = false; 
            }
            if(!regexCap.test(capInput.value.trim())) { 
                document.getElementById('err-cap').innerText = 'Inserisci un CAP valido (5 cifre).'; 
                capInput.classList.add('input-error');
                isValid = false; 
            }
        }

        return isValid;
    }

    document.addEventListener('DOMContentLoaded', () => {
        // --- 1. Gestione Visibilità Dinamica ---
        const checkStampa = document.getElementById('checkStampa');
        const checkModello = document.getElementById('checkModello');
        const checkTexture = document.getElementById('checkTexture');

        const addressGroup = document.getElementById('addressGroup');
        const optionalStampaSection = document.getElementById('optionalStampaSection');
        const optionalModelloSection = document.getElementById('optionalModelloSection');
        const optionalTextureSection = document.getElementById('optionalTextureSection');

        const checkMateriale = document.getElementById('checkMateriale');
        const checkPostProduzione = document.getElementById('checkPostProduzione');
        const containerMateriale = document.getElementById('containerMateriale');
        const containerPostProduzione = document.getElementById('containerPostProduzione');

        function updateMainSections() {
            if (addressGroup) addressGroup.style.display = checkStampa.checked ? 'block' : 'none';
            if (optionalStampaSection) optionalStampaSection.style.display = checkStampa.checked ? 'block' : 'none';
            if (optionalModelloSection) optionalModelloSection.style.display = checkModello.checked ? 'block' : 'none';
            if (optionalTextureSection) optionalTextureSection.style.display = checkTexture.checked ? 'block' : 'none';
        }

        function updateSubOptionsStampa() {
            if (containerMateriale) containerMateriale.style.display = checkMateriale.checked ? 'block' : 'none';
            if (containerPostProduzione) containerPostProduzione.style.display = checkPostProduzione.checked ? 'block' : 'none';
        }

        document.querySelectorAll('input[name="tipo_commissione"]').forEach(checkbox => {
            checkbox.addEventListener('change', updateMainSections);
        });

        if(checkMateriale) checkMateriale.addEventListener('change', updateSubOptionsStampa);
        if(checkPostProduzione) checkPostProduzione.addEventListener('change', updateSubOptionsStampa);

        updateMainSections();
        updateSubOptionsStampa();

        // --- 2. Gestione Feedback Upload File ---
        const fileInput = document.getElementById('fileRiferimento');
        const fileFeedback = document.getElementById('file-feedback');
        
        if (fileInput) {
            fileInput.addEventListener('change', function(e) {
                const files = e.target.files;
                if (files.length === 0) {
                    fileFeedback.innerHTML = ''; // Svuota se l'utente annulla la selezione
                } else {
                    // Prende i nomi di tutti i file selezionati e li unisce con una virgola
                    let fileNames = Array.from(files).map(f => f.name).join(', ');
                    fileFeedback.innerHTML = '<i class="fa-solid fa-check"></i> Hai selezionato: ' + fileNames;
                }
            });
        }
    });
</script>

<c:if test="${not empty requestScope.successMessage}">
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            showSuccessModal("${requestScope.successMessage}");
        });
    </script>
</c:if>

<%@ include file="fragment/footer.jspf" %>