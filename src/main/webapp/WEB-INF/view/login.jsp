<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Aggiunta taglib per gestire i messaggi di errore del server -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<% 
    request.setAttribute("titoloPagina", "Login"); 
    request.setAttribute("cssPagina", "auth.css"); 
%>
<%@ include file="fragment/header.jspf" %>

<div class="bg-video-container">
    <div class="bg-video-overlay"></div>
</div>

    <main class="auth-page-container">
        <section class="auth-box">
            
            <h2>Log in</h2>
            
            <!-- BLOCCO ERRORI SERVER: Mostra l'errore se la Servlet rileva credenziali sbagliate -->
            <c:if test="${not empty errorMessage}">
                <div class="error-msg global-error">
                    <c:out value="${errorMessage}"/>
                </div>
            </c:if>
            
            <!-- Aggiunto onsubmit per la validazione JavaScript -->
            <form id="loginForm" action="${pageContext.request.contextPath}/LoginServlet" method="POST" onsubmit="return validaLogin()">
                
                <div class="form-group">
                    <label for="loginEmail">Email</label>
                    <input type="email" id="loginEmail" name="email" autocomplete="email">
                    <span class="error-msg" id="err-email"></span>
                </div>
                
                <div class="form-group">
                    <label for="loginPassword">Password</label>
                    <input type="password" id="loginPassword" name="password">
                    <span class="error-msg" id="err-password"></span>
                </div>
                
                <button type="submit" class="btn-primary auth-btn">LOG IN</button>
                
            </form>
            
            <div class="auth-footer">
                <p>Non sei registrato? <a href="${pageContext.request.contextPath}/signup">Sign up</a></p>
                <p><a href="#" class="forgot-pwd">Hai dimenticato la password?</a></p>
            </div>
            
        </section>
    </main>

<!-- SCRIPT PER LA VALIDAZIONE JS CON REGEX (Requisito Checklist) -->
<script>
    function validaLogin() {
        let isValid = true;

        // Svuota i messaggi precedenti
        document.getElementById('err-email').innerText = '';
        document.getElementById('err-password').innerText = '';

        // 1. Validazione Email con Regex
        const email = document.getElementById('loginEmail').value.trim();
        const regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        
        if (email === '') {
            document.getElementById('err-email').innerText = 'L\'email è obbligatoria.';
            isValid = false;
        } else if (!regexEmail.test(email)) {
            document.getElementById('err-email').innerText = 'Inserisci un formato email valido.';
            isValid = false;
        }

        // 2. Validazione Password
        const password = document.getElementById('loginPassword').value.trim();
        if (password === '') {
            document.getElementById('err-password').innerText = 'La password è obbligatoria.';
            isValid = false;
        }

        return isValid; // Se false, blocca l'invio del form e mostra i messaggi inline
    }
</script>

<%@ include file="fragment/footer.jspf" %>