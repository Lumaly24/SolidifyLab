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

    public List<MetodoPagamento> getMetodiByUtente(int utenteId) {
        
        List<MetodoPagamento> carte = new ArrayList<>();
        String query = "SELECT id, carta_mascherata, scadenza FROM dati_pagamento WHERE utente_id = ?";

        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, utenteId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MetodoPagamento carta = new MetodoPagamento();
                    carta.setId(rs.getInt("id"));
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
}