package com.solidifylab.model;

import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;

public class SecurityUtils {

    public static String hashPassword(String passwordInChiaro) {
    	
        try {
        	
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            
            byte[] encodedhash = digest.digest(passwordInChiaro.getBytes(StandardCharsets.UTF_8));
            
            StringBuilder hexString = new StringBuilder(2 * encodedhash.length);
            
            for (int i = 0; i < encodedhash.length; i++) {
            	
                String hex = Integer.toHexString(0xff & encodedhash[i]);
                
                if (hex.length() == 1) {
                	
                    hexString.append('0');
                }
                
                hexString.append(hex);
            }
            
            return hexString.toString();
            
        } catch (Exception e) {
        	
            throw new RuntimeException("Errore durante l'hashing della password", e);
        }
    }
}