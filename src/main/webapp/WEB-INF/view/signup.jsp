<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<% request.setAttribute("titoloPagina", "Login"); 
   request.setAttribute("cssPagina", "auth.css"); 
%>
<%@ include file="fragment/header.jspf" %>

<div class="bg-video-container">
    <div class="bg-video-overlay"></div>
</div>

    <main class="auth-page-container">
        <section class="auth-box signup-box">
            
            <h2>Sign up</h2>
            
            <form id="signupForm" action="${pageContext.request.contextPath}/registerServlet" method="POST">
                
                <div class="form-group">
                    <label for="regUsername">Username</label>
                    <input type="text" id="regUsername" name="username" required autocomplete="off">
                    <!--  AJAX -->
                    <span id="usernameAjaxFeedback" class="ajax-feedback"></span>
                </div>

                <div class="form-group">
                    <label for="regEmail">Email</label>
                    <input type="email" id="regEmail" name="email" required autocomplete="email">
                    <!--  AJAX -->
                    <span id="emailAjaxFeedback" class="ajax-feedback"></span>
                </div>
                
                <div class="form-group">
                    <label for="regPassword">Password</label>
                    <input type="password" id="regPassword" name="password" required>
                    <!--  AJAX -->
                    <span id="pwdAjaxFeedback" class="ajax-feedback"></span>
                </div>
                
                <div class="form-group">
                    <label for="regConfirmPassword">Conferma Password</label>
                    <input type="password" id="regConfirmPassword" name="confirmPassword" required>
                    <span id="confirmPwdAjaxFeedback" class="ajax-feedback"></span>
                </div>
                
                <button type="submit" class="btn-primary auth-btn" id="btnSubmitSignup">SIGN UP</button>
                
            </form>
            
            <div class="auth-footer">
                <p>Sei già registrato? <a href="${pageContext.request.contextPath}/login">Log in</a></p>
            </div>
            
        </section>
    </main>

<%@ include file="fragment/footer.jspf" %>
