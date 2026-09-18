package com.solidifylab.model;

public class Asset {
	
    private Prodotto prodotto;
    private String formatoFile;

    public Prodotto getProdotto() { 
    	return prodotto; 
    }
    
    public void setProdotto(Prodotto prodotto) { 
    	this.prodotto = prodotto; 
    }
    
    public String getFormatoFile() { 
    	return formatoFile; 
    }
    
    public void setFormatoFile(String formatoFile) { 
    	this.formatoFile = formatoFile; 
    }
}