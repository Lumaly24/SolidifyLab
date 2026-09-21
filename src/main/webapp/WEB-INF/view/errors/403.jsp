<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<% request.setAttribute("titoloPagina", "403 - Accesso Negato"); %>
<%@ include file="../fragment/header.jspf" %>

    <main class="error-page-container" style="
        width: 100%; 
        min-height: calc(100vh - 120px); 
        background: radial-gradient(circle at center, #f2e5e5 0%, #a64c4c 70%, #800000 100%);
        position: relative; 
        display: flex; 
        align-items: center; 
        justify-content: center; 
        overflow: hidden; 
        margin: 0; 
        padding: 20px;">

        <div style="
    		position: absolute; 
    		top: 0; 
    		left: 0; 
    		width: 100%; 
    		height: 100%; 
    		background-image: url('${pageContext.request.contextPath}/images/403bg.png'); 
    		background-size: cover; 
    		background-position: center; 
    		background-repeat: no-repeat; 
    		pointer-events: none; 
    		z-index: 1;">
		</div>

        <a href="${pageContext.request.contextPath}/Home" style="
            position: relative; 
            z-index: 2; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            width: 100%; 
            max-width: 900px; 
            text-decoration: none;
            transition: transform 0.2s ease;">
            
            <img src="${pageContext.request.contextPath}/images/403texts.png" 
                 alt="403 Accesso Negato - Torna alla Home" 
                 style="
                    max-width: 100%; 
                    height: auto; 
                    object-fit: contain; 
                    display: block;
                    filter: drop-shadow(0px 8px 16px rgba(0,0,0,0.4));" />
        </a>

    </main>

<%@ include file="../fragment/footer.jspf" %>