package com.solidifylab.model;

import java.sql.Timestamp;

public class Commissione {
    
    // Attributi privati originali (lato cliente)
    private int id; 
    private String email;
    private String tipi;
    private String descrizione;
    private String via;
    private String citta;
    private String cap;

    // Nuovi attributi (lato Admin Dashboard / Database)
    private String stato;
    private boolean visionata;
    private Timestamp dataRichiesta;
    private String indirizzoSpedizione; // Utile per leggere l'indirizzo unito dal DB

    // Costruttore vuoto (obbligatorio per le regole dei Java Bean)
    public Commissione() {
    }

    // --- GETTER E SETTER ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTipi() {
        return tipi;
    }

    public void setTipi(String tipi) {
        this.tipi = tipi;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public String getVia() {
        return via;
    }

    public void setVia(String via) {
        this.via = via;
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

    // --- NUOVI GETTER E SETTER (Per l'Admin) ---

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

    public boolean isVisionata() {
        return visionata;
    }

    public void setVisionata(boolean visionata) {
        this.visionata = visionata;
    }

    public Timestamp getDataRichiesta() {
        return dataRichiesta;
    }

    public void setDataRichiesta(Timestamp dataRichiesta) {
        this.dataRichiesta = dataRichiesta;
    }

    public String getIndirizzoSpedizione() {
        return indirizzoSpedizione;
    }

    public void setIndirizzoSpedizione(String indirizzoSpedizione) {
        this.indirizzoSpedizione = indirizzoSpedizione;
    }

    // Un metodo toString() opzionale, comodissimo per stampare l'oggetto in console e fare debug
    @Override
    public String toString() {
        return "Commissione [id=" + id + ", email=" + email + ", tipi=" + tipi + 
               ", descrizione=" + descrizione + ", via=" + via + ", citta=" + citta + 
               ", cap=" + cap + ", stato=" + stato + ", visionata=" + visionata + 
               ", dataRichiesta=" + dataRichiesta + "]";
    }
}