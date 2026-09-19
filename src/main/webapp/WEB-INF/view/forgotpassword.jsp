<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<% 
    request.setAttribute("titoloPagina", "Recupero Password"); 
    request.setAttribute("cssPagina", "auth.css"); 
%>
<%@ include file="fragment/header.jspf" %>

<div class="bg-video-container">
    <div class="bg-video-overlay"></div>
</div>

<main class="auth-page-container">
    <section class="auth-box">
        
        <h2>Recupero Password</h2>
        
        <c:if test="${empty messaggioSuccesso}">
            <p>
                Inserisci l'indirizzo email associato al tuo account. Ti forniremo le istruzioni per modificare la password.
            </p>
        </c:if>
        
        <c:if test="${not empty messaggioErrore}">
            <div class="error-msg global-error">
                <c:out value="${messaggioErrore}"/>
            </div>
        </c:if>

        <c:if test="${not empty messaggioSuccesso}">
            <div>
                <c:out value="${messaggioSuccesso}"/>
            </div>
        </c:if>
        
        <form id="forgotForm" action="${pageContext.request.contextPath}/ForgotPassword" method="POST" onsubmit="return validaForgot()">
            
            <div class="form-group">
                <label for="forgotEmail">Email</label>
                <input type="email" id="forgotEmail" name="email" autocomplete="email">
                <span class="error-msg" id="err-forgot-email"></span>
            </div>
            
            <button type="submit" class="btn-primary auth-btn">INVIA</button>
            
        </form>
        
        <div class="auth-footer" style="margin-top: 20px;">
            <p>Non serve più? <a href="${pageContext.request.contextPath}/Login" class="forgot-pwd" style="color: #e56399; text-decoration: underline;">Vai al login</a></p>
        </div>
        
    </section>
</main>

<script>
    function validaForgot() {
        let isValid = true;
        const errSpan = document.getElementById('err-forgot-email');
        errSpan.innerText = '';

        const email = document.getElementById('forgotEmail').value.trim();
        const regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        
        if (email === '') {
            errSpan.innerText = 'L\'email è obbligatoria.';
            isValid = false;
        } else if (!regexEmail.test(email)) {
            errSpan.innerText = 'Inserisci un formato email valido.';
            isValid = false;
        }

        return isValid;
    }
</script>

<%@ include file="fragment/footer.jspf" %>