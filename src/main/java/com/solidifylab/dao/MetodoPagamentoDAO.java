package com.solidifylab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.solidifylab.model.ConPool;
import com.solidifylab.model.MetodoPagamento;

public class MetodoPagamentoDAO {

    public List<MetodoPagamento> getMetodoByUtente(int utenteId) {
        List<MetodoPagamento> carte = new ArrayList<>();
        String query = "SELECT id, intestatario, carta_mascherata, scadenza FROM dati_pagamento WHERE utente_id = ?";

        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, utenteId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MetodoPagamento carta = new MetodoPagamento();
                    carta.setId(rs.getInt("id"));
                    carta.setIntestatario(rs.getString("intestatario"));
                    carta.setCartaMascherata(rs.getString("carta_mascherata")); 
                    carta.setScadenza(rs.getString("scadenza"));
                    
                    
                    carte.add(carta); 
                }
            }
        } catch (SQLException e) {
            System.err.println("Errore nel recupero dei metodi di pagamento:");
            e.printStackTrace();
        }
        
        return carte;
    }

    public boolean doSave(MetodoPagamento carta) {
        String query = "INSERT INTO dati_pagamento (utente_id, intestatario, carta_mascherata, scadenza) VALUES (?, ?, ?, ?)";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, carta.getUtenteId());
            ps.setString(2, carta.getIntestatario());
            ps.setString(3, carta.getCartaMascherata());
            ps.setString(4, carta.getScadenza());
           
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Errore nel salvataggio del metodo di pagamento:");
            e.printStackTrace();
            return false;
        }
    }

    public boolean doDelete(int idCarta, int utenteId) {
        String query = "DELETE FROM dati_pagamento WHERE id = ? AND utente_id = ?";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, idCarta);
            ps.setInt(2, utenteId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Errore nell'eliminazione del metodo di pagamento:");
            e.printStackTrace();
            return false;
        }
    }
    public boolean eliminaCarteByUtente(int utenteId) {
        String query = "DELETE FROM dati_pagamento WHERE utente_id = ?";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, utenteId);
            return ps.executeUpdate() >= 0; 
            
        } catch (SQLException e) {
            System.err.println("Errore nell'eliminazione dello storico carte dell'utente:");
            e.printStackTrace();
            return false;
        }
    }
}