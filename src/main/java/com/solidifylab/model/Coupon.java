package com.solidifylab.model;

import java.sql.Date;

public class Coupon {
    private String codice;
    private double scontoPercentuale; 
    private Date dataScadenza;

    public Coupon() {}

    public String getCodice() { 
    	return codice; 
    }
    
    public void setCodice(String codice) { 
    	this.codice = codice; 
    }

    public double getScontoPercentuale() { 
    	return scontoPercentuale; 
    }
    
    public void setScontoPercentuale(double scontoPercentuale) { 
    	this.scontoPercentuale = scontoPercentuale; 
    }

    public Date getDataScadenza() { 
    	return dataScadenza; 
    }
    
    public void setDataScadenza(Date dataScadenza) { 
    	this.dataScadenza = dataScadenza; 
    }
}
