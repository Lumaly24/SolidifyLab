<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("titoloPagina", "Login"); %>
<%@ include file="fragment/header.jspf" %>

    <main class="auth-page-container">
        <section class="auth-box">
            
            <h2>Login</h2>
            
            <form id="loginForm" action="${pageContext.request.contextPath}/loginServlet" method="POST">
                
                <div class="form-group">
                    <label for="loginEmail">Email</label>
                    <input type="email" id="loginEmail" name="email" required autocomplete="email">
                </div>
                
                <div class="form-group">
                    <label for="loginPassword">Password</label>
                    <input type="password" id="loginPassword" name="password" required>
                </div>
                
                <button type="submit" class="btn-primary auth-btn">LOGIN</button>
                
            </form>
            
            <div class="auth-footer">
                <p>Non sei registrato? <a href="${pageContext.request.contextPath}/signup">Sign up</a></p>
                <p><a href="#" class="forgot-pwd">Hai dimenticato la password?</a></p>
            </div>
            
        </section>
    </main>

<%@ include file="fragment/footer.jspf" %>
