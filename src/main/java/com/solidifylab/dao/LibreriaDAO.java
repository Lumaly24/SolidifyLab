package com.solidifylab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.HashSet;

import com.solidifylab.model.Asset;
import com.solidifylab.model.ConPool;
import com.solidifylab.model.Prodotto;

public class LibreriaDAO {

    public List<Asset> getLibreriaByUtente(int utenteId) {
        List<Asset> libreria = new ArrayList<>();
        
        String query = "SELECT DISTINCT p.* FROM prodotto p " +
                       "JOIN riga_ordine ro ON p.id = ro.prodotto_id " +
                       "JOIN ordine o ON ro.ordine_id = o.id " +
                       "WHERE o.utente_id = ? AND p.formato_file IS NOT NULL " +
                       "AND p.categoria_id != 3 AND p.categoria_id != 98";

        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, utenteId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Prodotto p = new Prodotto();
                    p.setId(rs.getInt("id"));
                    p.setNome(rs.getString("nome"));
                    p.setFormatoFile(rs.getString("formato_file"));
                    p.setImmagineCopertinaUrl(rs.getString("immagine_copertina_url"));
                    
                    Asset asset = new Asset();
                    asset.setProdotto(p);
                    asset.setFormatoFile(p.getFormatoFile());
                    
                    libreria.add(asset);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Errore nel recupero della libreria digitale:");
            e.printStackTrace();
        }
        return libreria;
    }
    
    public boolean haGiaAcquistato(int utenteId, int prodottoId) {
        String query = "SELECT COUNT(ro.id) FROM riga_ordine ro " +
                       "JOIN ordine o ON ro.ordine_id = o.id " +
                       "WHERE o.utente_id = ? AND ro.prodotto_id = ?";

        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, utenteId);
            ps.setInt(2, prodottoId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Errore nel controllo acquisto precedente:");
            e.printStackTrace();
        }
        
        return false;
    }
    
    public Set<Integer> getIdAssetPosseduti(int utenteId) {
        Set<Integer> idPosseduti = new HashSet<>();
        
        String query = "SELECT DISTINCT ro.prodotto_id FROM riga_ordine ro " +
                       "JOIN ordine o ON ro.ordine_id = o.id " +
                       "JOIN prodotto p ON ro.prodotto_id = p.id " +
                       "WHERE o.utente_id = ? AND p.formato_file IS NOT NULL " +
                       "AND p.categoria_id != 3 AND p.categoria_id != 98";

        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, utenteId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    idPosseduti.add(rs.getInt("prodotto_id"));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Errore nel recupero degli ID asset posseduti:");
            e.printStackTrace();
        }
        
        return idPosseduti;
    }
}