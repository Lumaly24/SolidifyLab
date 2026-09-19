package com.solidifylab.model;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Ordine {
    
    private int id;
    private String data;
    private double totale;
    private String stato;
    private User utente;
    private Timestamp dataOrdine;
    
    private List<ItemCarrello> articoli = new ArrayList<>();

    public Ordine() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Timestamp getDataOrdine() {
        return dataOrdine;
    }

    public void setDataOrdine(Timestamp dataOrdine) {
        this.dataOrdine = dataOrdine;
    }

    public double getTotale() {
        return totale;
    }

    public void setTotale(double totale) {
        this.totale = totale;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

    public User getUtente() {
        return utente;
    }

    public void setUtente(User utente) {
        this.utente = utente;
    }
    
    public List<ItemCarrello> getArticoli() {
        return articoli;
    }

    public void setArticoli(List<ItemCarrello> articoli) {
        this.articoli = articoli;
    }
}