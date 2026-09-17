package com.solidifylab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.solidifylab.model.Carrello;
import com.solidifylab.model.ItemCarrello;
import com.solidifylab.model.Prodotto;
import com.solidifylab.model.ConPool;

public class CarrelloDAO {

    public Carrello getCarrelloByUtente(int utenteId) {
        Carrello carrello = new Carrello();
        ProdottoDAO prodottoDAO = new ProdottoDAO();
        
        String query = "SELECT prodotto_id, quantita FROM carrello WHERE utente_id = ? ORDER BY data_aggiunta ASC";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, utenteId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int prodottoId = rs.getInt("prodotto_id");
                    int quantita = rs.getInt("quantita");
                    
                    Prodotto prodotto = prodottoDAO.doRetrieveById(prodottoId);
                    
                    if (prodotto != null) {
                        ItemCarrello item = new ItemCarrello(prodotto, quantita);
                        carrello.getProdotti().add(item);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Errore durante il recupero del carrello: " + e.getMessage());
        }
        
        return carrello;
    }

    public void salvaOAggiornaCarrello(int utenteId, Carrello carrello) {
        String queryDelete = "DELETE FROM carrello WHERE utente_id = ?";
        String queryInsert = "INSERT INTO carrello (utente_id, prodotto_id, quantita) VALUES (?, ?, ?)";
        
        try (Connection con = ConPool.getConnection()) {
            
            try (PreparedStatement psDelete = con.prepareStatement(queryDelete)) {
                psDelete.setInt(1, utenteId);
                psDelete.executeUpdate();
            }
            
            if (carrello != null && !carrello.getProdotti().isEmpty()) {
                try (PreparedStatement psInsert = con.prepareStatement(queryInsert)) {
                    for (ItemCarrello item : carrello.getProdotti()) {
                        psInsert.setInt(1, utenteId);
                        psInsert.setInt(2, item.getProdotto().getId());
                        psInsert.setInt(3, item.getQuantita());
                        psInsert.addBatch(); 
                    }
                    psInsert.executeBatch();
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Errore durante il salvataggio del carrello: " + e.getMessage());
        }
    }
}