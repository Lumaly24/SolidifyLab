<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("titoloPagina", "Commissioni"); %>
<%@ include file="fragment/header.jspf" %>

	<main class="commission-page-container">
		<div class="commission-form-wrapper">
	            
	            <h1>Richiedi un Progetto su Misura</h1>
	            <p>Compila il form per ricevere un preventivo per le tue stampe, modelli o texture.</p>
	
	            <form id="commissionForm" action="${pageContext.request.contextPath}/submitCommissionServlet" method="POST">
	                <fieldset class="form-section">
	                    <legend><i class="fa-solid fa-wand-magic-sparkles"></i> Cosa commissionare?</legend>
	                    
	                    <div class="checkbox-group inline-group">
	                        <label>
	                            <input type="checkbox" name="tipo_commissione" value="stampa_3d" id="checkStampa"> Stampa 3D
	                        </label>
	                        <label>
	                            <input type="checkbox" name="tipo_commissione" value="modello_3d" id="checkModello"> Creazione Modello 3D
	                        </label>
	                        <label>
	                            <input type="checkbox" name="tipo_commissione" value="texture" id="checkTexture"> Richiesta Texture
	                        </label>
	                    </div>
	                </fieldset>
	                <hr class="dashed-divider">
	                <fieldset class="form-section">
	                    <legend><i class="fa-solid fa-pen-nib"></i> Descrizione</legend>
	                    
	                    <div class="form-group">
	                        <textarea name="descrizione_principale" rows="6" placeholder="Descrivi il tuo progetto nei dettagli..." required></textarea>
	                    </div>
	                    <div class="optional-3d-section" id="optional3DSection">
	                        <p class="section-subtitle">Se modello 3D (opzionale):</p>
	                        
	                        <div class="split-options">
	                            <div class="option-box">
	                                <label>
	                                    <input type="checkbox" name="include_texture"> Includere texture
	                                </label>
	                                <textarea name="descrizione_texture" rows="3" placeholder="Descrizione texture..."></textarea>
	                            </div>
	                            <div class="option-box">
	                                <label>
	                                    <input type="checkbox" name="include_animazione"> Includere Animazione
	                                </label>
	                                <textarea name="descrizione_animazione" rows="3" placeholder="Descrizione animazione..."></textarea>
	                            </div>
	                        </div>
	                    </div>
	                </fieldset>
	
	                <hr class="dashed-divider">
	                <fieldset class="form-section">
	                    <legend><i class="fa-solid fa-address-card"></i> Inserimento Dati Personali</legend>
	                    
	                    <div class="personal-data-layout">
	                        <div class="data-inputs">
	                            <div class="form-group">
	                                <label for="commEmail">E-mail :</label>
	                                <input type="email" id="commEmail" name="email" required>
	                            </div>
	                            
	                            <div class="form-group address-group">
	                                <label>Indirizzo (ecc) : <span class="note">solo per le stampe 3d che devono essere consegnate</span></label>
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
	                                <li>I preventivi sono gratuiti.</li>
	                                <li>Tempo di risposta: 24/48h.</li>
	                                <li>Spedizione tracciabile per le stampe fisiche.</li>
	                            </ul>
	                        </div>
	                        
	                    </div>
	                </fieldset>
	                <div class="form-actions">
	                    <button type="submit" class="btn-primary btn-large">Invia Richiesta di Preventivo</button>
	                </div>
	
	            </form>
	        </div>
    </main>

<%@ include file="fragment/footer.jspf" %>
