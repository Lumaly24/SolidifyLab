package com.solidifylab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.solidifylab.model.ConPool;
import com.solidifylab.model.Prodotto;

public class WishlistDAO {

    // =================================================================
    // 1. AGGIUNGI PRODOTTO ALLA WISHLIST
    // =================================================================
    public void aggiungiProdotto(int idUtente, int idProdotto) {
        // L'INSERT IGNORE previene errori SQL se l'utente clicca due volte sullo stesso prodotto
        String query = "INSERT IGNORE INTO wishlist (utente_id, prodotto_id) VALUES (?, ?)";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, idUtente);
            ps.setInt(2, idProdotto);
            ps.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println("Errore durante l'aggiunta alla wishlist:");
            e.printStackTrace();
        }
    }

    // =================================================================
    // 2. RIMUOVI PRODOTTO DALLA WISHLIST
    // =================================================================
    public void rimuoviProdotto(int idUtente, int idProdotto) {
        String query = "DELETE FROM wishlist WHERE utente_id = ? AND prodotto_id = ?";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, idUtente);
            ps.setInt(2, idProdotto);
            ps.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println("Errore durante la rimozione dalla wishlist:");
            e.printStackTrace();
        }
    }

    // =================================================================
    // 3. RECUPERA TUTTA LA WISHLIST DI UN UTENTE
    // =================================================================
    public List<Prodotto> getWishlistByUtente(int idUtente) {
        List<Prodotto> wishlist = new ArrayList<>();
        
        // Uniamo la tabella wishlist con i prodotti, assicurandoci di escludere quelli cancellati!
        String query = "SELECT p.* FROM prodotto p " +
                       "JOIN wishlist w ON p.id = w.prodotto_id " +
                       "WHERE w.utente_id = ? AND p.cancellato = FALSE";

        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, idUtente);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Prodotto p = new Prodotto();
                    
                    // Utilizziamo i setter esatti del tuo ProdottoDAO
                    p.setId(rs.getInt("id"));
                    p.setCategoriaId(rs.getInt("categoria_id"));
                    p.setNome(rs.getString("nome"));
                    p.setDescrizione(rs.getString("descrizione"));
                    p.setPrezzoCorrente(rs.getDouble("prezzo_corrente"));
                    p.setIvaCorrente(rs.getDouble("iva_corrente"));
                    p.setQuantitaDisponibile(rs.getInt("quantita_disponibile"));
                    p.setFormatoFile(rs.getString("formato_file"));
                    p.setImmagineCopertinaUrl(rs.getString("immagine_copertina_url"));
                    p.setDataInserimento(rs.getString("data_inserimento"));
                    p.setCancellato(rs.getBoolean("cancellato"));
                    
                    wishlist.add(p);
                }
            }
        } catch (SQLException e) {
            System.out.println("Errore durante il recupero della wishlist:");
            e.printStackTrace();
        }
        
        return wishlist;
    }
}