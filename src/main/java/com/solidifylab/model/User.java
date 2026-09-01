package com.solidifylab.model;

public class User {
    
    private int id;
    private String email;
    private String passwordHash; 
    private String username; // NUOVO CAMPO AGGIUNTO
    private String nome;     // Rimane, ma ora sarà opzionale
    private String cognome;  // Rimane, ma ora sarà opzionale
    private String ruolo;

    // --- Nuovi attributi per la Dashboard (Spedizioni) ---
    private String indirizzo;
    private String citta;
    private String cap;

    // Costruttore vuoto (obbligatorio per i Bean)
    public User() {}

    // ==========================================
    // Metodi Getter e Setter
    // ==========================================
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    // --- Getter e Setter per USERNAME ---
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getCognome() { return cognome; }
    public void setCognome(String cognome) { this.cognome = cognome; }

    public String getRuolo() { return ruolo; }
    public void setRuolo(String ruolo) { this.ruolo = ruolo; }

    // --- Nuovi Getter e Setter ---

    public String getIndirizzo() { return indirizzo; }
    public void setIndirizzo(String indirizzo) { this.indirizzo = indirizzo; }

    public String getCitta() { return citta; }
    public void setCitta(String citta) { this.citta = citta; }

    public String getCap() { return cap; }
    public void setCap(String cap) { this.cap = cap; }
}