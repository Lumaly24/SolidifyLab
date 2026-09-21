package com.solidifylab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.solidifylab.model.ConPool;
import com.solidifylab.model.Spedizione;

public class SpedizioneDAO {
    
	public void salvaIndirizzoPrincipale(int utenteId, String via, String civico, String citta, String cap, String provincia) {
        String checkQuery = "SELECT id FROM dati_spedizione WHERE utente_id = ? LIMIT 1";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement psCheck = con.prepareStatement(checkQuery)) {
            
            psCheck.setInt(1, utenteId);
            
            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next()) {
                    int idSpedizione = rs.getInt("id");
                    String updateQuery = "UPDATE dati_spedizione SET via=?, civico=?, citta=?, cap=?, provincia=? WHERE id=?";
                    
                    try (PreparedStatement psUpdate = con.prepareStatement(updateQuery)) {
                        psUpdate.setString(1, via);
                        psUpdate.setString(2, civico);
                        psUpdate.setString(3, citta);
                        psUpdate.setString(4, cap);
                        psUpdate.setString(5, provincia);
                        psUpdate.setInt(6, idSpedizione);
                        psUpdate.executeUpdate();
                    }
                } else {
                    String insertQuery = "INSERT INTO dati_spedizione (utente_id, via, civico, citta, cap, provincia, nazione) VALUES (?, ?, ?, ?, ?, ?, 'Italia')";
                    
                    try (PreparedStatement psInsert = con.prepareStatement(insertQuery)) {
                        psInsert.setInt(1, utenteId);
                        psInsert.setString(2, via);
                        psInsert.setString(3, civico);
                        psInsert.setString(4, citta);
                        psInsert.setString(5, cap);
                        psInsert.setString(6, provincia);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public Spedizione getIndirizzoPrincipale(int utenteId) {
    	
        String query = "SELECT via, civico, citta, cap, provincia FROM dati_spedizione WHERE utente_id = ?";
        
        Spedizione s = new Spedizione();
        
        try (Connection con = ConPool.getConnection();
        		
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, utenteId);
            
            try (ResultSet rs = ps.executeQuery()) {
            	
                if (rs.next()) {
                	
                    s.setVia(rs.getString("via"));
                    s.setCivico(rs.getString("civico"));
                    s.setCitta(rs.getString("citta"));
                    s.setCap(rs.getString("cap"));
                    s.setProvincia(rs.getString("provincia"));
                }
            }
            
        } catch (SQLException e) {
        	
            e.printStackTrace();
        }
        
        return s;
    }
}