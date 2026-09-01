<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<% request.setAttribute("titoloPagina", "500 - Errore server interno"); %>
<%@ include file="../fragment/header.jspf" %>

    <main class="error-page-container" style="
        width: 100%; 
        min-height: calc(100vh - 120px); 
        background: radial-gradient(circle at center, #EEE0E2 0%, #E99FBB 70%, #E77CA7 100%);
        position: relative; 
        display: flex; 
        align-items: center; 
        justify-content: center; 
        overflow: hidden; 
        margin: 0; 
        padding: 0;">

        <div style="
    		position: absolute; 
    		top: 0; 
    		left: 0; 
    		width: 100%; 
    		height: 100%; 
    		background-image: url('${pageContext.request.contextPath}/images/heartsbg.png'); 
    		background-size: 132% auto; 
    		background-position: center; 
    		background-repeat: repeat-x; 
    		pointer-events: none; 
    		z-index: 1;">
		</div>

        <a href="${pageContext.request.contextPath}/index.jsp" style="
            position: relative; 
            z-index: 2; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            width: 90%; 
            max-width: 900px; 
            height: 80%; 
            text-decoration: none;">
            
            <img src="${pageContext.request.contextPath}/images/500texts.png" 
                 alt="500 Errore server interno" 
                 style="
                    max-width: 100%; 
                    max-height: 70vh; 
                    width: auto; 
                    height: auto; 
                    object-fit: contain; 
                    display: block;" />
        </a>

    </main>

<%@ include file="../fragment/footer.jspf" %>