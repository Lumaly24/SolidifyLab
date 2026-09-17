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

	public synchronized void doSave(Commissione commissione) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        String insertSQL = "INSERT INTO commissione "
                + "(utente_id, email_contatto, richiede_stampa_3d, richiede_modello_3d, richiede_texture, descrizione_principale, indirizzo_spedizione) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try { 
            connection = ConPool.getConnection();
            preparedStatement = connection.prepareStatement(insertSQL);

            if ( commissione.getId() > 0) {
                preparedStatement.setInt(1, commissione.getId());
            } else {
                preparedStatement.setNull(1, java.sql.Types.INTEGER);
            }

            preparedStatement.setString(2, commissione.getEmail());
            
            String tipi = commissione.getTipi() != null ? commissione.getTipi().toLowerCase() : "";
            preparedStatement.setBoolean(3, tipi.contains("stampa 3d") || tipi.contains("stampa_3d"));
            preparedStatement.setBoolean(4, tipi.contains("modello 3d") || tipi.contains("modello_3d"));
            preparedStatement.setBoolean(5, tipi.contains("texture"));
            
            preparedStatement.setString(6, commissione.getDescrizione());
            
            String indirizzoCompleto = null;
            if (commissione.getVia() != null && !commissione.getVia().trim().isEmpty()) {
                indirizzoCompleto = commissione.getVia() + ", " + 
                                  (commissione.getCitta() != null ? commissione.getCitta() : "") + " " + 
                                  (commissione.getCap() != null ? commissione.getCap() : "");
            }
            preparedStatement.setString(7, indirizzoCompleto);

            preparedStatement.executeUpdate();

        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
            } finally {
                if (connection != null) connection.close();
            }
        }
    }

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
                
                List<String> tipiList = new java.util.ArrayList<>();
                if (rs.getBoolean("richiede_stampa_3d")) tipiList.add("Stampa 3D");
                if (rs.getBoolean("richiede_modello_3d")) tipiList.add("Modello 3D");
                if (rs.getBoolean("richiede_texture")) tipiList.add("Texture");

                c.setTipi(String.join(", ", tipiList));
                
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
                    
                    List<String> tipiList = new java.util.ArrayList<>();
                    if (rs.getBoolean("richiede_stampa_3d")) tipiList.add("Stampa 3D");
                    if (rs.getBoolean("richiede_modello_3d")) tipiList.add("Modello 3D");
                    if (rs.getBoolean("richiede_texture")) tipiList.add("Texture");

                    c.setTipi(String.join(", ", tipiList));
                    
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