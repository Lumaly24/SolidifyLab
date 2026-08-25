<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Taglib per i messaggi di errore lato server -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<% 
    request.setAttribute("titoloPagina", "Sign up"); 
    request.setAttribute("cssPagina", "auth.css"); 
%>
<%@ include file="fragment/header.jspf" %>

<div class="bg-video-container">
    <div class="bg-video-overlay"></div>
</div>

    <main class="auth-page-container">
        <section class="auth-box signup-box">
            
            <h2>Sign up</h2>
            
            <!-- BLOCCO ERRORI SERVER -->
            <c:if test="${not empty errorMessage}">
                <div class="error-msg global-error">
                    <c:out value="${errorMessage}"/>
                </div>
            </c:if>
            
            <form id="signupForm" action="${pageContext.request.contextPath}/RegisterServlet" method="POST" onsubmit="return validaSignup()">
                
                <div class="form-group">
                    <label for="regUsername">Username</label>
                    <input type="text" id="regUsername" name="username" autocomplete="off">
                    <span id="err-username" class="error-msg"></span>
                </div>

                <div class="form-group">
                    <label for="regEmail">Email</label>
                    <input type="email" id="regEmail" name="email" autocomplete="email">
                    <!-- REQUISITO CHECKLIST: Feedback AJAX -->
                    <span id="emailAjaxFeedback" class="error-msg"></span>
                </div>
                
                <div class="form-group">
                    <label for="regPassword">Password</label>
                    <input type="password" id="regPassword" name="password">
                    <span id="err-password" class="error-msg"></span>
                </div>
                
                <div class="form-group">
                    <label for="regConfirmPassword">Conferma Password</label>
                    <input type="password" id="regConfirmPassword" name="confirmPassword">
                    <span id="err-confirmpassword" class="error-msg"></span>
                </div>
                
                <button type="submit" class="btn-primary auth-btn" id="btnSubmitSignup">SIGN UP</button>
                
            </form>
            
            <div class="auth-footer">
                <p>Sei già registrato? <a href="${pageContext.request.contextPath}/login">Log in</a></p>
            </div>
            
        </section>
    </main>

<script>
    // Variabile globale per bloccare il form se l'email esiste già
    let isEmailValid = false;

    // chiamata ajax per fetch email
    document.getElementById('regEmail').addEventListener('blur', function() {
        const email = this.value.trim();
        const feedback = document.getElementById('emailAjaxFeedback');
        const regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (email === '') {
            feedback.innerText = '';
            feedback.className = 'error-msg';
            isEmailValid = false;
            return;
        }

        if (!regexEmail.test(email)) {
            feedback.innerText = 'Formato email non valido.';
            feedback.className = 'error-msg';
            isEmailValid = false;
            return;
        }

        // Se l'email ha un formato corretto, interroghiamo il Database (Servlet)
        fetch('${pageContext.request.contextPath}/CheckEmailServlet?email=' + encodeURIComponent(email))
            .then(response => response.json()) // Requisito: usare JSON
            .then(data => {
                if (data.exists) {
                    feedback.innerText = 'Questa email è già registrata.';
                    feedback.className = 'error-msg';
                    isEmailValid = false;
                } else {
                    feedback.innerText = 'Email disponibile!';
                    feedback.className = 'success-msg'; // Classe diversa per il verde
                    isEmailValid = true;
                }
            })
            .catch(error => {
                console.error('Errore Fetch:', error);
                isEmailValid = true; // Permettiamo l'invio in caso di errore di rete temporaneo
            });
    });

    // ==========================================
    // VALIDAZIONE FORM (REGEX)
    // ==========================================
    function validaSignup() {
        let isValid = true;

        document.getElementById('err-username').innerText = '';
        document.getElementById('err-password').innerText = '';
        document.getElementById('err-confirmpassword').innerText = '';

        // 1. Username (Solo lettere e numeri, 3-20 caratteri)
        const username = document.getElementById('regUsername').value.trim();
        const regexUser = /^[a-zA-Z0-9]{3,20}$/;
        if (!regexUser.test(username)) {
            document.getElementById('err-username').innerText = 'Tra 3 e 20 caratteri alfanumerici.';
            isValid = false;
        }

        // 2. Controllo blocco Email (Se l'AJAX ha detto che esiste, blocchiamo tutto)
        if (!isEmailValid) {
            document.getElementById('emailAjaxFeedback').innerText = 'Inserisci un\'email valida e non registrata.';
            document.getElementById('emailAjaxFeedback').className = 'error-msg';
            isValid = false;
        }

        // 3. Password (Almeno 8 caratteri)
        const pwd = document.getElementById('regPassword').value;
        if (pwd.length < 8) {
            document.getElementById('err-password').innerText = 'La password deve avere almeno 8 caratteri.';
            isValid = false;
        }

        // 4. Conferma Password
        const confirmPwd = document.getElementById('regConfirmPassword').value;
        if (confirmPwd !== pwd) {
            document.getElementById('err-confirmpassword').innerText = 'Le password non coincidono.';
            isValid = false;
        }

        return isValid;
    }
</script>

<%@ include file="fragment/footer.jspf" %>