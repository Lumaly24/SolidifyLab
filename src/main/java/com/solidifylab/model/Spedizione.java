package com.solidifylab.model;

public class Spedizione {
    private String via = "";
    private String civico = "";
    private String citta = "";
    private String cap = "";
    private String provincia = "";

    public String getVia() { 
    	return via; 
    }
    
    public void setVia(String via) { 
    	this.via = via; 
    }
    
    public String getCivico() { 
    	return civico; 
    }
    
    public void setCivico(String civico) { 
    	this.civico = civico; 
    }
    
    public String getCitta() { 
    	return citta; 
    }
    
    public void setCitta(String citta) { 
    	this.citta = citta; 
    }
    
    public String getCap() { 
    	return cap; 
    }
    
    public void setCap(String cap) { 
    	this.cap = cap; 
    }
    
    public String getProvincia() { 
    	return provincia; 
    }
    
    public void setProvincia(String provincia) { 
    	this.provincia = provincia; 
    }
}