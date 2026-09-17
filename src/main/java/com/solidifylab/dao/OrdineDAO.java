package com.solidifylab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.solidifylab.model.ConPool;
import com.solidifylab.model.Ordine;
import com.solidifylab.model.User;

public class OrdineDAO {

    public List<Ordine> doRetrieveAll() {
        List<Ordine> ordini = new ArrayList<>();
        
        String query = "SELECT o.*, u.nome as utente_nome, u.cognome as utente_cognome, u.email as utente_email " +
		                "FROM ordine o " +
		                "JOIN utente u ON o.utente_id = u.id " +
		                "ORDER BY o.data_ordine DESC";

        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Ordine ordine = new Ordine();
                ordine.setId(rs.getInt("id"));
                ordine.setData(rs.getString("data")); 
                ordine.setTotale(rs.getDouble("totale"));
                ordine.setStato(rs.getString("stato"));

                User utente = new User();
                utente.setId(rs.getInt("utente_id"));
                utente.setNome(rs.getString("utente_nome"));
                utente.setCognome(rs.getString("utente_cognome"));
                utente.setEmail(rs.getString("utente_email"));
                
                ordine.setUtente(utente);

                ordini.add(ordine);
            }

        } catch (SQLException e) {
            System.out.println("Errore durante l'estrazione degli ordini:");
            e.printStackTrace();
        }

        return ordini;
    }
    
    public boolean doSave(Ordine ordine) {
    	
    	String query = "INSERT INTO ordine (data_ordine, totale, stato, utente_id) VALUES (?, ?, ?, ?)";
    	
    	try (Connection con = ConPool.getConnection();
    			PreparedStatement ps = con.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS)) {
    		
    			ps.setString(1, ordine.getData());
    			ps.setDouble(2, ordine.getTotale());
    			ps.setString(3, ordine.getStato());
    			ps.setInt(4, ordine.getUtente().getId());
    			
    			int affectedRows = ps.executeUpdate();
    			
    			if (affectedRows > 0) {
    				try (ResultSet rs = ps.getGeneratedKeys()) {
    					
    					if (rs.next()) {
    						ordine.setId(rs.getInt(1));
    					}
    				}
    				return true;
    			}	
    	} catch (SQLException e) {
    		System.out.println("Errore durante il salvataggio dell'ordine: ");
    		e.printStackTrace();
    	}
    	return false;
    }
    
}