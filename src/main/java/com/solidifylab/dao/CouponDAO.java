package com.solidifylab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.solidifylab.model.ConPool;
import com.solidifylab.model.Coupon;


public class CouponDAO {

    public Coupon getCouponByCodice(String codice) {
        String query = "SELECT codice, sconto_percentuale, data_scadenza FROM coupon WHERE codice = ?";
        Coupon couponTrovato = null;

        try (Connection con = ConPool.getConnection(); 
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, codice.toUpperCase()); 
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    couponTrovato = new Coupon();
                    couponTrovato.setCodice(rs.getString("codice"));
                    couponTrovato.setScontoPercentuale(rs.getDouble("sconto_percentuale"));
                    couponTrovato.setDataScadenza(rs.getDate("data_scadenza"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Errore nel recupero del coupon:");
            e.printStackTrace();
        }
        
        return couponTrovato;
    }
}