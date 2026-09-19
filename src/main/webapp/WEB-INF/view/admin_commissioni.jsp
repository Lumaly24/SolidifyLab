<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<% 
    request.setAttribute("titoloPagina", "Gestione Commissioni"); 
    request.setAttribute("cssPagina", "commissioni.css");
%>

<%@ include file="fragment/header.jspf" %>

<main class="admin-dashboard">
    <h1>Pannello di Controllo Commissioni</h1>
    <p>Clicca su "Vedi Dettagli" per leggere la richiesta e sbloccare le azioni.</p>

    <div class="admin-dashboard-wrapper">
        
        <div class="admin-tabs">
            <button class="admin-tab in-attesa active" onclick="switchTab('attesa', this)">IN ATTESA</button>
            <button class="admin-tab accettate" onclick="switchTab('accettate', this)">ACCETTATE</button>
            <button class="admin-tab in-lavorazione" onclick="switchTab('lavorazione', this)">IN LAVORAZIONE</button>
            <button class="admin-tab completate" onclick="switchTab('completate', this)">COMPLETATE</button>
            <button class="admin-tab rifiutate" onclick="switchTab('rifiutate', this)">RIFIUTATE</button>
        </div>

        <div id="tab-attesa" class="tab-content" style="display: flex;">
        
            <c:choose>
            
                <c:when test="${not empty requestScope.listaInAttesa}">
                
                    <div class="card-horizontal-scroll">
                        <c:forEach var="commissione" items="${requestScope.listaInAttesa}">
                            <div class="commission-card" id="card-${commissione.id}">
                            
                                <div class="card-header">
                                    <span class="card-title">Ordine #${commissione.id}</span>
                                    
                                    <div class="badge-container">
                                        <span class="badge type-badge"><c:out value="${commissione.tipi}" /></span>
                                        <span class="badge status-badge status-${fn:toLowerCase(commissione.stato)}"><c:out value="${fn:replace(commissione.stato, '_', ' ')}" /></span>
                                    </div>
                                    
                                </div>
                                
                                <div class="card-body">
                                    <p><strong>Cliente:</strong> <c:out value="${commissione.email}" /></p>
                                    <p><strong>Data:</strong> <fmt:formatDate value="${commissione.dataRichiesta}" pattern="dd/MM/yyyy HH:mm" /></p>
                                </div>
                                
                                <button type="button" class="btn-details" onclick="openDetailsModal('${commissione.id}', '${fn:escapeXml(commissione.email)}', '${fn:escapeXml(commissione.tipi)}', '${fn:escapeXml(commissione.descrizione)}', '${fn:escapeXml(commissione.indirizzoSpedizione)}', '${fn:escapeXml(commissione.fileRiferimentoUrl)}', ${commissione.richiedeStampa3d}, '${fn:escapeXml(commissione.materialeStampa)}', '${fn:escapeXml(commissione.descMateriale)}', '${fn:escapeXml(commissione.tipoPostproduzione)}', '${fn:escapeXml(commissione.descPostproduzione)}', ${commissione.richiedeModello3d}, ${commissione.includeTextureModello}, '${fn:escapeXml(commissione.descrizioneTextureModello)}', ${commissione.includeAnimazione}, '${fn:escapeXml(commissione.descrizioneAnimazione)}', ${commissione.includeRigging}, '${fn:escapeXml(commissione.descrizioneRigging)}', ${commissione.richiedeTexture}, ${commissione.includeUvMapping}, '${fn:escapeXml(commissione.descUvMapping)}', ${commissione.includeMaterialiPbr}, '${fn:escapeXml(commissione.descMaterialiPbr)}')">Vedi Dettagli</button>
                                
                                <div class="card-actions ${!commissione.visionata ? 'hidden-actions' : ''}" id="actions-${commissione.id}">
                                    <button type="button" class="btn-action btn-accept" onclick="showConfirm('${commissione.id}', 'accetta')">Accetta</button>
                                    <button type="button" class="btn-action btn-reject" onclick="showConfirm('${commissione.id}', 'rifiuta')">Rifiuta</button>
                                </div>
                                
                            </div>
                            
                        </c:forEach>
                        
                    </div>
                    
                </c:when>
                
                <c:otherwise>
                
                    <p style="text-align: center; color: #0f0326; font-family: 'coolveticaitalic', serif; width: 100%;">Nessuna commissione in attesa.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div id="tab-accettate" class="tab-content">
        
            <c:choose>
            
                <c:when test="${not empty requestScope.listaAccettate}">
                
                    <div class="card-horizontal-scroll">
                    
                        <c:forEach var="commissione" items="${requestScope.listaAccettate}">
                        
                            <div class="commission-card" id="card-${commissione.id}">
                            
                                <div class="card-header">
                                
                                    <span class="card-title">Ordine #${commissione.id}</span>
                                    
                                    <div class="badge-container">
                                        <span class="badge type-badge"><c:out value="${commissione.tipi}" /></span>
                                        <span class="badge status-badge status-${fn:toLowerCase(commissione.stato)}"><c:out value="${fn:replace(commissione.stato, '_', ' ')}" /></span>
                                    </div>
                                    
                                </div>
                                
                                <div class="card-body">
                                    <p><strong>Cliente:</strong> <c:out value="${commissione.email}" /></p>
                                    <p><strong>Data:</strong> <fmt:formatDate value="${commissione.dataRichiesta}" pattern="dd/MM/yyyy HH:mm" /></p>
                                </div>
                                
                                <button type="button" class="btn-details" onclick="openDetailsModal('${commissione.id}', '${fn:escapeXml(commissione.email)}', '${fn:escapeXml(commissione.tipi)}', '${fn:escapeXml(commissione.descrizione)}', '${fn:escapeXml(commissione.indirizzoSpedizione)}', '${fn:escapeXml(commissione.fileRiferimentoUrl)}', ${commissione.richiedeStampa3d}, '${fn:escapeXml(commissione.materialeStampa)}', '${fn:escapeXml(commissione.descMateriale)}', '${fn:escapeXml(commissione.tipoPostproduzione)}', '${fn:escapeXml(commissione.descPostproduzione)}', ${commissione.richiedeModello3d}, ${commissione.includeTextureModello}, '${fn:escapeXml(commissione.descrizioneTextureModello)}', ${commissione.includeAnimazione}, '${fn:escapeXml(commissione.descrizioneAnimazione)}', ${commissione.includeRigging}, '${fn:escapeXml(commissione.descrizioneRigging)}', ${commissione.richiedeTexture}, ${commissione.includeUvMapping}, '${fn:escapeXml(commissione.descUvMapping)}', ${commissione.includeMaterialiPbr}, '${fn:escapeXml(commissione.descMaterialiPbr)}')">Vedi Dettagli</button>
                                
                                <div class="card-actions" id="actions-${commissione.id}">
                                    <button type="button" class="btn-action btn-accept prendi-in-lavorazione" onclick="submitAction('${commissione.id}', 'lavorazione')" style="width: 100%;">Prendi in Lavorazione</button>
                                </div>
                                
                            </div>
                            
                        </c:forEach>
                        
                    </div>
                    
                </c:when>
                
                <c:otherwise>
                    <p style="text-align: center; color: #0f0326; font-family: 'coolveticaitalic', serif; width: 100%;">Nessuna commissione accettata.</p>
                </c:otherwise>
                
            </c:choose>
            
        </div>

        <div id="tab-lavorazione" class="tab-content">
        
            <c:choose>
            
                <c:when test="${not empty requestScope.listaInLavorazione}">
                
                    <div class="card-horizontal-scroll">
                    
                        <c:forEach var="commissione" items="${requestScope.listaInLavorazione}">
                        
                            <div class="commission-card" id="card-${commissione.id}">
                            
                                <div class="card-header">
                                    <span class="card-title">Ordine #${commissione.id}</span>
                                    
                                    <div class="badge-container">
                                        <span class="badge type-badge"><c:out value="${commissione.tipi}" /></span>
                                        <span class="badge status-badge status-${fn:toLowerCase(commissione.stato)}"><c:out value="${fn:replace(commissione.stato, '_', ' ')}" /></span>
                                    </div>
                                    
                                </div>
                                
                                <div class="card-body">
                                    <p><strong>Cliente:</strong> <c:out value="${commissione.email}" /></p>
                                    <p><strong>Data:</strong> <fmt:formatDate value="${commissione.dataRichiesta}" pattern="dd/MM/yyyy HH:mm" /></p>
                                </div>
                                
                                <button type="button" class="btn-details" onclick="openDetailsModal('${commissione.id}', '${fn:escapeXml(commissione.email)}', '${fn:escapeXml(commissione.tipi)}', '${fn:escapeXml(commissione.descrizione)}', '${fn:escapeXml(commissione.indirizzoSpedizione)}', '${fn:escapeXml(commissione.fileRiferimentoUrl)}', ${commissione.richiedeStampa3d}, '${fn:escapeXml(commissione.materialeStampa)}', '${fn:escapeXml(commissione.descMateriale)}', '${fn:escapeXml(commissione.tipoPostproduzione)}', '${fn:escapeXml(commissione.descPostproduzione)}', ${commissione.richiedeModello3d}, ${commissione.includeTextureModello}, '${fn:escapeXml(commissione.descrizioneTextureModello)}', ${commissione.includeAnimazione}, '${fn:escapeXml(commissione.descrizioneAnimazione)}', ${commissione.includeRigging}, '${fn:escapeXml(commissione.descrizioneRigging)}', ${commissione.richiedeTexture}, ${commissione.includeUvMapping}, '${fn:escapeXml(commissione.descUvMapping)}', ${commissione.includeMaterialiPbr}, '${fn:escapeXml(commissione.descMaterialiPbr)}')">Vedi Dettagli</button>
                                
                                <div class="card-actions" id="actions-${commissione.id}">
                                    <button type="button" class="btn-action btn-accept invia-commissione" onclick="submitAction('${commissione.id}', 'completa')" style="width: 100%;">Invia Commissione</button>
                                </div>
                                
                            </div>
                            
                        </c:forEach>
                        
                    </div>
                    
                </c:when>
                
                <c:otherwise>
                    <p style="text-align: center; color: #0f0326; font-family: 'coolveticaitalic', serif; width: 100%;">Nessuna commissione in lavorazione.</p>
                </c:otherwise>
                
            </c:choose>
            
        </div>

        <div id="tab-completate" class="tab-content">
        
            <c:choose>
            
                <c:when test="${not empty requestScope.listaCompletate}">
                
                    <div class="card-horizontal-scroll">
                    
                        <c:forEach var="commissione" items="${requestScope.listaCompletate}">
                        
                            <div class="commission-card" id="card-${commissione.id}">
                            
                                <div class="card-header">
                                    <span class="card-title">Ordine #${commissione.id}</span>
                                    
                                    <div class="badge-container">
                                        <span class="badge type-badge"><c:out value="${commissione.tipi}" /></span>
                                        <span class="badge status-badge status-${fn:toLowerCase(commissione.stato)}"><c:out value="${fn:replace(commissione.stato, '_', ' ')}" /></span>
                                    </div>
                                    
                                </div>
                                
                                <div class="card-body">
                                    <p><strong>Cliente:</strong> <c:out value="${commissione.email}" /></p>
                                    <p><strong>Data:</strong> <fmt:formatDate value="${commissione.dataRichiesta}" pattern="dd/MM/yyyy HH:mm" /></p>
                                </div>
                                
                                <button type="button" class="btn-details" onclick="openDetailsModal('${commissione.id}', '${fn:escapeXml(commissione.email)}', '${fn:escapeXml(commissione.tipi)}', '${fn:escapeXml(commissione.descrizione)}', '${fn:escapeXml(commissione.indirizzoSpedizione)}', '${fn:escapeXml(commissione.fileRiferimentoUrl)}', ${commissione.richiedeStampa3d}, '${fn:escapeXml(commissione.materialeStampa)}', '${fn:escapeXml(commissione.descMateriale)}', '${fn:escapeXml(commissione.tipoPostproduzione)}', '${fn:escapeXml(commissione.descPostproduzione)}', ${commissione.richiedeModello3d}, ${commissione.includeTextureModello}, '${fn:escapeXml(commissione.descrizioneTextureModello)}', ${commissione.includeAnimazione}, '${fn:escapeXml(commissione.descrizioneAnimazione)}', ${commissione.includeRigging}, '${fn:escapeXml(commissione.descrizioneRigging)}', ${commissione.richiedeTexture}, ${commissione.includeUvMapping}, '${fn:escapeXml(commissione.descUvMapping)}', ${commissione.includeMaterialiPbr}, '${fn:escapeXml(commissione.descMaterialiPbr)}')">Vedi Dettagli</button>
                            </div>
                            
                        </c:forEach>
                        
                    </div>
                    
                </c:when>
                
                <c:otherwise>
                    <p style="text-align: center; color: #0f0326; font-family: 'coolveticaitalic', serif; width: 100%;">Nessuna commissione completata.</p>
                </c:otherwise>
                
            </c:choose>
            
        </div>

        <div id="tab-rifiutate" class="tab-content">
        
            <c:choose>
            
                <c:when test="${not empty requestScope.listaRifiutate}">
                
                    <div class="card-horizontal-scroll">
                    
                        <c:forEach var="commissione" items="${requestScope.listaRifiutate}">
                        
                            <div class="commission-card" id="card-${commissione.id}">
                            
                                <div class="card-header">
                                    <span class="card-title">Ordine #${commissione.id}</span>
                                    
                                    <div class="badge-container">
                                        <span class="badge type-badge"><c:out value="${commissione.tipi}" /></span>
                                        <span class="badge status-badge status-${fn:toLowerCase(commissione.stato)}"><c:out value="${fn:replace(commissione.stato, '_', ' ')}" /></span>
                                    </div>
                                    
                                </div>
                                
                                <div class="card-body">
                                    <p><strong>Cliente:</strong> <c:out value="${commissione.email}" /></p>
                                    <p><strong>Data:</strong> <fmt:formatDate value="${commissione.dataRichiesta}" pattern="dd/MM/yyyy HH:mm" /></p>
                                </div>
                                
                                <button type="button" class="btn-details" onclick="openDetailsModal('${commissione.id}', '${fn:escapeXml(commissione.email)}', '${fn:escapeXml(commissione.tipi)}', '${fn:escapeXml(commissione.descrizione)}', '${fn:escapeXml(commissione.indirizzoSpedizione)}', '${fn:escapeXml(commissione.fileRiferimentoUrl)}', ${commissione.richiedeStampa3d}, '${fn:escapeXml(commissione.materialeStampa)}', '${fn:escapeXml(commissione.descMateriale)}', '${fn:escapeXml(commissione.tipoPostproduzione)}', '${fn:escapeXml(commissione.descPostproduzione)}', ${commissione.richiedeModello3d}, ${commissione.includeTextureModello}, '${fn:escapeXml(commissione.descrizioneTextureModello)}', ${commissione.includeAnimazione}, '${fn:escapeXml(commissione.descrizioneAnimazione)}', ${commissione.includeRigging}, '${fn:escapeXml(commissione.descrizioneRigging)}', ${commissione.richiedeTexture}, ${commissione.includeUvMapping}, '${fn:escapeXml(commissione.descUvMapping)}', ${commissione.includeMaterialiPbr}, '${fn:escapeXml(commissione.descMaterialiPbr)}')">Vedi Dettagli</button>
                            </div>
                            
                        </c:forEach>
                        
                    </div>
                    
                </c:when>
                
                <c:otherwise>
                    <p style="text-align: center; color: #0f0326; font-family: 'coolveticaitalic', serif; width: 100%;">Nessuna commissione rifiutata.</p>
                </c:otherwise>
                
            </c:choose>
            
        </div>

    </div>
</main>

<div class="admin-modal" id="detailsModal" style="display: none;">

    <div class="modal-box">
        <h2>Dettagli Commissione #<span id="modId"></span></h2>
        
        <div class="modal-info">
        
            <p><strong>Cliente:</strong> <span id="modClient"></span></p>
            <p><strong>Tipologia:</strong> <span id="modType"></span></p>
            <p id="modAddressContainer" style="display: none;"><strong>Indirizzo Spedizione:</strong> <span id="modAddress"></span></p>
            <p id="modFileContainer" style="display: none; margin-top: 10px; color: #0f0326;">
                <strong><i class="fa-solid fa-paperclip"></i> File Allegati:</strong> <br>
                <span id="modFile" style="display: flex; flex-wrap: wrap; gap: 8px; margin-top: 5px;"></span>
            </p>
            
        </div>
        
        <hr>
        
        <div class="modal-desc">
        
            <p><strong>Descrizione Progetto:</strong></p>
            
            <div id="modDesc" style="background: rgba(0,0,0,0.03); padding: 10px; border-radius: 5px; margin-bottom: 10px;"></div>
        </div>
        
        <div id="dynamicSectionsContainer"></div>
        
        <div class="modal-actions-container" style="margin-top: 20px;">
            <button type="button" class="btn-action btn-close" onclick="closeDetailsModal()">Chiudi</button>
        </div>
        
    </div>
    
</div>

<div class="admin-modal" id="confirmModal" style="display: none;">

    <div class="modal-box confirm-box">
    
        <h3 id="confirmTitle">Sei sicuro?</h3>
        <p id="confirmText"></p>
        
        <div class="modal-actions-container">
            <button type="button" class="btn-action btn-accept" id="confirmYesBtn">Conferma</button>
            <button type="button" class="btn-action btn-close" onclick="closeConfirmModal()">Annulla</button>
        </div>
        
    </div>
</div>

<script>
    let currentCommissionId = null;
    const contextPath = "${pageContext.request.contextPath}";

    function switchTab(tabId, btnElement) {
    	
        document.querySelectorAll('.tab-content').forEach(tab => {
            tab.style.display = 'none';
        });
        
        document.querySelectorAll('.admin-tab').forEach(btn => {
            btn.classList.remove('active');
        });

        const activeTab = document.getElementById('tab-' + tabId);
        if(activeTab) {
            activeTab.style.display = 'flex';
        }
        
        if(btnElement) {
            btnElement.classList.add('active');
        }
    }

    function openDetailsModal(
        id, client, type, desc, address, fileUrl, 
        richiedeStampa, matStampa, descMat, tipoPost, descPost,
        richiedeModello, incTexMod, descTexMod, incAnim, descAnim, incRig, descRig,
        richiedeTexture, incUv, descUv, incPbr, descPbr
    ) {
        currentCommissionId = id;
        
        document.getElementById('modId').innerText = id;
        document.getElementById('modClient').innerText = client;
        document.getElementById('modType').innerText = type;
        document.getElementById('modDesc').innerText = desc || 'Nessuna descrizione fornita.';
        
        const addressContainer = document.getElementById('modAddressContainer');
        if (address && address.trim() !== '') {
            document.getElementById('modAddress').innerText = address;
            addressContainer.style.display = 'block';
        } else {
            addressContainer.style.display = 'none';
        }

        const fileContainer = document.getElementById('modFileContainer');
        const modFileSpan = document.getElementById('modFile');
        
        if (fileUrl && fileUrl.trim() !== '') {
            let fileLinks = '';
            let fileArray = fileUrl.split(',');
            
            fileArray.forEach(function(file) {
                let cleanFileName = file.trim();
                let downloadUrl = contextPath + "/uploads/commissioni/" + encodeURIComponent(cleanFileName);
                fileLinks += '<a href="' + downloadUrl + '" target="_blank" style="display: inline-block; background: #e56399; color: white; padding: 5px 12px; border-radius: 5px; text-decoration: none; font-size: 0.85em; font-weight: bold; transition: opacity 0.2s;"><i class="fa-solid fa-download"></i> ' + cleanFileName + '</a>';
            });
            
            modFileSpan.innerHTML = fileLinks;
            fileContainer.style.display = 'block';
        } else {
            fileContainer.style.display = 'none';
            modFileSpan.innerHTML = '';
        }

        const container = document.getElementById('dynamicSectionsContainer');
        container.innerHTML = ''; 

        if (richiedeStampa && (matStampa || tipoPost)) {
            let html = '<div style="margin-top: 15px; padding: 12px; background: rgba(0,0,0,0.03); border-radius: 8px; border-left: 3px solid #e56399;">';
            html += '<h5 style="margin-bottom: 8px; color: #0f0326; font-family: \'elephant\', sans-serif;">Opzioni Stampa 3D</h5>';
            html += '<ul style="list-style: none; padding-left: 0; font-size: 0.9em; color: #333; margin: 0;">';
            if (matStampa) {
                html += '<li style="margin-bottom: 5px;"><strong>Materiale:</strong> ' + matStampa;
                if (descMat) html += '<br><em>Note: ' + descMat + '</em>';
                html += '</li>';
            }
            if (tipoPost) {
                html += '<li><strong>Post-Produzione:</strong> ' + tipoPost;
                if (descPost) html += '<br><em>Note: ' + descPost + '</em>';
                html += '</li>';
            }
            html += '</ul></div>';
            container.innerHTML += html;
        }

        if (richiedeModello && (incTexMod || incAnim || incRig)) {
            let html = '<div style="margin-top: 15px; padding: 12px; background: rgba(0,0,0,0.03); border-radius: 8px; border-left: 3px solid #e56399;">';
            html += '<h5 style="margin-bottom: 8px; color: #0f0326; font-family: \'elephant\', sans-serif;">Opzioni Modello 3D</h5>';
            html += '<ul style="list-style: none; padding-left: 0; font-size: 0.9em; color: #333; margin: 0;">';
            if (incTexMod) html += '<li style="margin-bottom: 5px;"><strong>Modello con texture:</strong> ' + (descTexMod || 'Sì') + '</li>';
            if (incAnim) html += '<li style="margin-bottom: 5px;"><strong>Animazione:</strong> ' + (descAnim || 'Sì') + '</li>';
            if (incRig) html += '<li><strong>Rigging:</strong> ' + (descRig || 'Sì') + '</li>';
            html += '</ul></div>';
            container.innerHTML += html;
        }

        if (richiedeTexture && (incUv || incPbr)) {
            let html = '<div style="margin-top: 15px; padding: 12px; background: rgba(0,0,0,0.03); border-radius: 8px; border-left: 3px solid #e56399;">';
            html += '<h5 style="margin-bottom: 8px; color: #0f0326; font-family: \'elephant\', sans-serif;">Opzioni Texture</h5>';
            html += '<ul style="list-style: none; padding-left: 0; font-size: 0.9em; color: #333; margin: 0;">';
            if (incUv) html += '<li style="margin-bottom: 5px;"><strong>Mappatura UV:</strong> ' + (descUv || 'Sì') + '</li>';
            if (incPbr) html += '<li><strong>Materiali PBR Specifici:</strong> ' + (descPbr || 'Sì') + '</li>';
            html += '</ul></div>';
            container.innerHTML += html;
        }

        const cardActions = document.getElementById('actions-' + id);
        if (cardActions && cardActions.classList.contains('hidden-actions')) {
            cardActions.classList.remove('hidden-actions');
            fetch(contextPath + "/GestioneCommissioni", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: new URLSearchParams({ action: "visiona", id: id })
            }).catch(error => console.error('Errore:', error));
        }
        
        document.getElementById('detailsModal').style.display = 'flex';
    }

    function closeDetailsModal() {
        document.getElementById('detailsModal').style.display = 'none';
    }

    function showConfirm(id, actionType) {
        currentCommissionId = id;
        const confirmModal = document.getElementById('confirmModal');
        const confirmTitle = document.getElementById('confirmTitle');
        const confirmText = document.getElementById('confirmText');
        const confirmYesBtn = document.getElementById('confirmYesBtn');

        if (actionType === 'accetta') {
            confirmTitle.innerText = "Accetta Commissione";
            confirmText.innerText = "Stai per accettare l'ordine #" + id + ". Procedere?";
        } else {
            confirmTitle.innerText = "Rifiuta Commissione";
            confirmText.innerText = "Stai per rifiutare l'ordine #" + id + ". L'ordine verrà spostato tra i rifiutati.";
        }

        confirmYesBtn.onclick = function() {
            submitAction(id, actionType);
        };

        confirmModal.style.display = 'flex';
    }

    function closeConfirmModal() {
        document.getElementById('confirmModal').style.display = 'none';
    }

    function submitAction(id, actionType) {
        const confirmYesBtn = document.getElementById('confirmYesBtn');
        confirmYesBtn.disabled = true;
        confirmYesBtn.innerText = "Attendere...";
        
        fetch(contextPath + "/GestioneCommissioni", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: new URLSearchParams({ action: actionType, id: id })
        })
        .then(response => {
            if (response.ok) {
                closeConfirmModal();
                window.location.reload(); 
            } else {
                alert("Si è verificato un errore durante l'operazione.");
            }
        })
        .catch(error => {
            console.error('Errore:', error);
            alert("Errore di connessione al server.");
        })
        .finally(() => {
            confirmYesBtn.disabled = false;
            confirmYesBtn.innerText = "Sì, Conferma";
        });
    }
</script>

<%@ include file="fragment/footer.jspf" %>