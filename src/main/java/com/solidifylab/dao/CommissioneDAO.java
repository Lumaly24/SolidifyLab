package com.solidifylab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.solidifylab.model.Commissione;
import com.solidifylab.model.ConPool;

public class CommissioneDAO {

    // =================================================================
    // 1. LATO CLIENTE: SALVATAGGIO NUOVA RICHIESTA
    // =================================================================
    public synchronized void doSave(Commissione commissione) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String insertSQL = "INSERT INTO commissione "
                + "(email_contatto, richiede_stampa_3d, richiede_modello_3d, richiede_texture, descrizione_principale, indirizzo_spedizione) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try { 
            connection = ConPool.getConnection();
            preparedStatement = connection.prepareStatement(insertSQL);

            // 1. Email
            preparedStatement.setString(1, commissione.getEmail());
            
            // 2, 3, 4. Trasformiamo la stringa "tipi" nei boolean del DB
            String tipi = commissione.getTipi() != null ? commissione.getTipi().toLowerCase() : "";
            preparedStatement.setBoolean(2, tipi.contains("stampa_3d"));
            preparedStatement.setBoolean(3, tipi.contains("modello_3d"));
            preparedStatement.setBoolean(4, tipi.contains("texture"));
            
            // 5. Descrizione
            preparedStatement.setString(5, commissione.getDescrizione());
            
            // 6. Formattazione Indirizzo (solo se è stata richiesta una stampa fisica)
            String indirizzoCompleto = null;
            if (commissione.getVia() != null && !commissione.getVia().trim().isEmpty()) {
                indirizzoCompleto = commissione.getVia() + ", " + commissione.getCap() + " " + commissione.getCitta();
            }
            preparedStatement.setString(6, indirizzoCompleto);

            preparedStatement.executeUpdate();

        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
            } finally {
                if (connection != null) connection.close(); // Rimette la connessione nel pool
            }
        }
    }

    // =================================================================
    // 2. LATO ADMIN: GESTIONE DASHBOARD
    // =================================================================

    // RECUPERA TUTTE LE COMMISSIONI (Ordinate dalle più recenti)
    public List<Commissione> getAllCommissioni() {
        List<Commissione> list = new ArrayList<>();
        String query = "SELECT * FROM commissione ORDER BY data_richiesta DESC";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Commissione c = new Commissione();
                
                c.setId(rs.getInt("id"));
                c.setEmail(rs.getString("email_contatto"));
                c.setDescrizione(rs.getString("descrizione_principale"));
                c.setIndirizzoSpedizione(rs.getString("indirizzo_spedizione"));
                
                // Ricostruiamo la stringa "tipi" per stamparla comoda nella JSP dell'admin
                StringBuilder tipiBuilder = new StringBuilder();
                if (rs.getBoolean("richiede_stampa_3d")) tipiBuilder.append("Stampa 3D ");
                if (rs.getBoolean("richiede_modello_3d")) tipiBuilder.append("Modello 3D ");
                if (rs.getBoolean("richiede_texture")) tipiBuilder.append("Texture ");
                c.setTipi(tipiBuilder.toString().trim().replace(" ", ", "));
                
                c.setStato(rs.getString("stato")); 
                c.setVisionata(rs.getBoolean("visionata"));
                c.setDataRichiesta(rs.getTimestamp("data_richiesta"));
                
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Errore durante il recupero delle commissioni", e);
        }
        return list;
    }

    // AGGIORNA LO STATO (Accetta/Rifiuta)
    public void updateStato(int id, String nuovoStato) {
        String query = "UPDATE commissione SET stato = ?, data_aggiornamento = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, nuovoStato);
            ps.setInt(2, id);
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Errore durante l'aggiornamento dello stato", e);
        }
    }

    // SEGNA LA CARD COME VISIONATA (Sblocca i bottoni)
    public void segnaComeVisionata(int id) {
        String query = "UPDATE commissione SET visionata = TRUE WHERE id = ?";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, id);
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Errore durante l'aggiornamento della visualizzazione", e);
        }
    }

    // =================================================================
    // 3. LATO UTENTE: RECUPERA COMMISSIONI PER EMAIL (PER IL TRACKER)
    // =================================================================
    public List<Commissione> getCommissioniByEmail(String email) {
        List<Commissione> list = new ArrayList<>();
        String query = "SELECT * FROM commissione WHERE email_contatto = ? ORDER BY data_richiesta DESC";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Commissione c = new Commissione();
                    
                    c.setId(rs.getInt("id"));
                    c.setEmail(rs.getString("email_contatto"));
                    c.setDescrizione(rs.getString("descrizione_principale"));
                    c.setIndirizzoSpedizione(rs.getString("indirizzo_spedizione"));
                    
                    // Ricostruiamo la stringa dei tipi anche qui
                    StringBuilder tipiBuilder = new StringBuilder();
                    if (rs.getBoolean("richiede_stampa_3d")) tipiBuilder.append("Stampa 3D ");
                    if (rs.getBoolean("richiede_modello_3d")) tipiBuilder.append("Modello 3D ");
                    if (rs.getBoolean("richiede_texture")) tipiBuilder.append("Texture ");
                    c.setTipi(tipiBuilder.toString().trim().replace(" ", ", "));
                    
                    c.setStato(rs.getString("stato")); 
                    c.setVisionata(rs.getBoolean("visionata"));
                    c.setDataRichiesta(rs.getTimestamp("data_richiesta"));
                    
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Errore durante il recupero delle commissioni dell'utente", e);
        }
        return list;
    }
}