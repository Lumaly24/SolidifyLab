<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            
            <c:if test="${not empty errore}">
                <div class="error-msg global-error">
                    <c:out value="${errore}"/>
                </div>
            </c:if>
            
            <form id="signupForm" action="${pageContext.request.contextPath}/Signup" method="POST" onsubmit="return validaSignup()">
                
                <div class="form-group">
                    <label for="regNome">Nome</label>
                    <input type="text" id="regNome" name="nome" autocomplete="given-name">
                    <span id="err-nome" class="error-msg"></span>
                </div>

                <div class="form-group">
                    <label for="regCognome">Cognome</label>
                    <input type="text" id="regCognome" name="cognome" autocomplete="family-name">
                    <span id="err-cognome" class="error-msg"></span>
                </div>

                <div class="form-group">
                    <label for="regUsername">Username</label>
                    <input type="text" id="regUsername" name="username" autocomplete="off">
                    <span id="err-username" class="error-msg"></span>
                </div>

                <div class="form-group">
                    <label for="regEmail">Email</label>
                    <input type="email" id="regEmail" name="email" autocomplete="email">
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
                <p>Sei già registrato? <a href="${pageContext.request.contextPath}/Login">Log in</a></p>
            </div>
            
        </section>
    </main>

<script>
    function validaSignup() {
        let isValid = true;

        document.getElementById('err-nome').innerText = '';
        document.getElementById('err-cognome').innerText = '';
        document.getElementById('err-username').innerText = '';
        document.getElementById('err-password').innerText = '';
        document.getElementById('err-confirmpassword').innerText = '';

        const nome = document.getElementById('regNome').value.trim();
        const regexNomeCognome = /^[a-zA-ZàèéìòùÀÈÉÌÒÙ\s']+$/;
        if (!nome || !regexNomeCognome.test(nome)) {
            document.getElementById('err-nome').innerText = 'Inserisci un nome valido.';
            isValid = false;
        }

        const cognome = document.getElementById('regCognome').value.trim();
        if (!cognome || !regexNomeCognome.test(cognome)) {
            document.getElementById('err-cognome').innerText = 'Inserisci un cognome valido.';
            isValid = false;
        }

        const username = document.getElementById('regUsername').value.trim();
        const regexUser = /^[a-zA-Z0-9]{3,20}$/;
        if (!regexUser.test(username)) {
            document.getElementById('err-username').innerText = 'Tra 3 e 20 caratteri alfanumerici.';
            isValid = false;
        }

        if (typeof isEmailValid !== 'undefined' && !isEmailValid) {
            document.getElementById('emailAjaxFeedback').innerText = 'Inserisci un\'email valida e non registrata.';
            document.getElementById('emailAjaxFeedback').className = 'error-msg';
            isValid = false;
        }

        const pwd = document.getElementById('regPassword').value;
        if (pwd.length < 8) {
            document.getElementById('err-password').innerText = 'La password deve avere almeno 8 caratteri.';
            isValid = false;
        }

        const regexPwd = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.])[A-Za-z\d@$!%*?&.]{8,}$/;

        if (!regexPwd.test(pwd)) {
            document.getElementById('err-password').innerText = 'La password deve avere almeno 8 caratteri, includendo una maiuscola, una minuscola, un numero e un carattere speciale.';
            isValid = false;
        }

        const confirmPwd = document.getElementById('regConfirmPassword').value;
        if (confirmPwd !== pwd) {
            document.getElementById('err-confirmpassword').innerText = 'Le password non coincidono.';
            isValid = false;
        }

        return isValid;
    }
</script>

<%@ include file="fragment/footer.jspf" %>