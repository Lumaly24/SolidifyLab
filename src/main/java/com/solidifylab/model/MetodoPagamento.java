package com.solidifylab.model;

public class MetodoPagamento {
    
    private int id;
    private int utenteId;
    private String intestatario;
    private String cartaMascherata;
    private String scadenza;
    private String brand; 

    public int getId() { 
        return id; 
    }
    
    public void setId(int id) { 
        this.id = id; 
    }
    
    public int getUtenteId() { 
        return utenteId; 
    }
    
    public void setUtenteId(int utenteId) { 
        this.utenteId = utenteId; 
    }
    
    public String getIntestatario() {
        return intestatario;
    }

    public void setIntestatario(String intestatario) {
        this.intestatario = intestatario;
    }

    public String getCartaMascherata() { 
        return cartaMascherata; 
    }
    
    public void setCartaMascherata(String cartaMascherata) { 
        this.cartaMascherata = cartaMascherata; 
    }
    
    public String getScadenza() { 
        return scadenza; 
    }
    
    public void setScadenza(String scadenza) { 
        this.scadenza = scadenza; 
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }
}